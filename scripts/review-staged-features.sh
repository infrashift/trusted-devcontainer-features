#!/usr/bin/env bash
# Inspect features sitting in the STAGING namespace and emit a signed-able
# verdict naming the exact digests that passed.
#
# WHY THIS EXISTS
#
# The release used to publish straight to the consumer-facing namespace and then
# verify what it had published, in the same job, holding the signing key. That
# ordering makes the verification detective rather than preventive: by the time
# it fails, the bad bytes are already the thing consumers pull. It also lets one
# job both publish and attest that its own publish was correct.
#
# Now the build actor publishes to a staging namespace, this script runs as the
# review actor, and only digests named in its verdict are promoted. A compromised
# build job can put anything in staging and still cannot get it promoted, because
# it cannot produce a verdict the release actor will accept.
#
# THE VERDICT IS A DIGEST LIST, NOT A PASS/FAIL
#
# Promotion copies by digest, so what was reviewed and what is promoted are the
# same bytes by construction. A verdict that said only "ok" would leave a gap
# between the thing inspected and the thing shipped.
#
# Required env: FEATURES STAGING_NAMESPACE GITHUB_REPOSITORY
# Optional env: EXPECT_DEPENDS_ON  a full prod reference WITH digest that every
#               dependsOn must equal. Omitted for the bootstrap phase, which
#               depends on nothing.
set -euo pipefail

: "${FEATURES:?}" "${STAGING_NAMESPACE:?}" "${GITHUB_REPOSITORY:?}"
REGISTRY="${REGISTRY:-ghcr.io}"
OUT="${OUT:-staging-verdict.json}"

staging="${REGISTRY}/${STAGING_NAMESPACE,,}"
prod_ns="${GITHUB_REPOSITORY,,}"
prod="${REGISTRY}/${prod_ns}"

fail=0
checked=0
: > /tmp/verdict.jsonl

while IFS= read -r feature; do
    [ -n "$feature" ] || continue
    # Re-assert the shape the matrix guard already checked: this reaches an OCI
    # reference below.
    [[ "$feature" =~ ^[a-z0-9][a-z0-9-]{0,63}$ ]] || {
        echo "::error::refusing to inspect a feature named ${feature@Q}" >&2; exit 1; }

    ref="${staging}/${feature}:latest"

    if ! digest=$(crane digest "$ref" 2>/dev/null); then
        echo "::error::${feature}: not present in staging at ${ref}" >&2
        fail=1; continue
    fi
    [[ "$digest" =~ ^sha256:[0-9a-f]{64}$ ]] || {
        echo "::error::malformed digest for ${ref}: ${digest@Q}" >&2; exit 1; }

    # Inspect BY DIGEST, not by tag. A tag can move between this read and the
    # promotion; the digest is what the verdict commits to.
    meta="$(crane manifest "${staging}/${feature}@${digest}" 2>/dev/null \
            | jq -r '.annotations["dev.containers.metadata"] // empty')"
    if [ -z "$meta" ]; then
        echo "::error::${feature}: no dev.containers.metadata annotation on ${ref}" >&2
        fail=1; continue
    fi

    checked=$((checked + 1))

    # 1. No relative references. A consumer resolves "./bootstrap" against THEIR
    #    .devcontainer/ and gets an ENOENT naming a path inside their own repo.
    relative="$(jq -r '
        [ (.installsAfter // [])[], ((.dependsOn // {}) | keys[]) ]
        | map(select(startswith("./"))) | join(", ")' <<<"$meta")"
    if [ -n "$relative" ]; then
        echo "::error::${feature} staged with relative reference(s): ${relative}" >&2
        fail=1; continue
    fi

    # 2. dependsOn must carry a digest. An absolute reference without one still
    #    resolves to :latest -- pinned in appearance, mutable in fact.
    unpinned=$(jq -r '
        (.dependsOn // {}) | keys
        | map(select(test("@sha256:[0-9a-f]{64}$") | not)) | join(", ")' <<<"$meta")
    if [ -n "$unpinned" ]; then
        echo "::error::${feature} staged with unpinned dependsOn: ${unpinned}" >&2
        fail=1; continue
    fi

    # 3. Every dependsOn must name the PRODUCTION namespace, and exactly the
    #    digest this release promoted in phase one.
    #
    #    This is the check the staging split makes necessary. Promotion copies
    #    bytes verbatim, so a dependsOn pointing at the staging namespace would
    #    survive into production and send consumers to a namespace that is not
    #    theirs to pull -- pinned, immutable, and wrong.
    while IFS= read -r dep; do
        [ -n "$dep" ] || continue
        case "$dep" in
            "${prod}/"*) : ;;
            *) echo "::error::${feature} dependsOn ${dep}, which is not in ${prod}" >&2; fail=1 ;;
        esac
        if [ -n "${EXPECT_DEPENDS_ON:-}" ] && [ "$dep" != "$EXPECT_DEPENDS_ON" ]; then
            echo "::error::${feature} dependsOn ${dep}, expected ${EXPECT_DEPENDS_ON}" >&2
            fail=1
        fi
    done < <(jq -r '(.dependsOn // {}) | keys[]' <<<"$meta")

    jq -n --arg f "$feature" --arg d "$digest" \
      '{feature: $f, digest: $d}' >> /tmp/verdict.jsonl
    echo "  ok ${feature} @ ${digest}"
done < <(jq -r '.[]' <<<"$FEATURES")

[ "$checked" -gt 0 ] || { echo "::error::inspected 0 staged features; refusing to call that a pass" >&2; exit 1; }
[ "$fail" -eq 0 ] || { echo "::error::staging review failed" >&2; exit 1; }

jq -s --arg staging "$staging" --arg prod "$prod" --arg repo "$GITHUB_REPOSITORY" \
  '{repository: $repo, staging_namespace: $staging, production_namespace: $prod,
    reviewed: length, features: .}' /tmp/verdict.jsonl > "$OUT"

echo "OK: ${checked} staged feature(s) reviewed; verdict written to ${OUT}"
