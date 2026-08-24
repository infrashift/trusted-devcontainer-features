# Setup runbook

Everything here must be done once, by a human, before the release pipeline can
run. Until steps 1–3 are complete, `release.yaml` fails closed by design:
`scripts/sign-features.sh` requires the signing secrets, and the `Release-Actor`
environment does not exist yet.

```bash
export ORG=infrashift
export REPO=trusted-devcontainer-features
export SLUG="${ORG}/${REPO}"
```

This repo needs **one** actor, not three. The sibling
`trusted-devcontainer-templates` splits build, review and release because it
builds images, grades them against a CVE policy, and promotes them. This repo
publishes features — OCI artifacts carrying an install script and an Ansible
role — so there is one privileged act (publish and sign) and one gate on it.
Inventing a review actor with nothing to review would be ceremony, not control.

---

## 0. Preconditions

```bash
gh auth status          # needs admin:org, repo, write:packages
cosign version          # v2.6.1, matching tools.lock
opa version             # v1.19.1
```

**cosign v3 defaults to `--new-bundle-format=true`** and writes attestations as
OCI referrers; v2 writes the legacy layout the sibling repos read. `tools.lock`
pins v2.6.1. Migrate the org together, never one repo at a time.

---

## 1. Generate the release keypair

**In `/dev/shm`, never in a git working tree.** A sibling repo has three live
private keys sitting in its checkout; treat those as compromised and rotate.

```bash
WORK=$(mktemp -d -p /dev/shm keygen.XXXXXX)
cd "$WORK"
COSIGN_PASSWORD="$(openssl rand -base64 48)"
export COSIGN_PASSWORD
cosign generate-key-pair
mv cosign.key release.key
mv cosign.pub release.pub
printf '%s' "$COSIGN_PASSWORD" > release.password
unset COSIGN_PASSWORD
```

> `cosign generate-key-pair` produces **ECDSA P-256, not ED25519**. Say ECDSA
> P-256 in any documentation. An inaccurate cryptographic claim in a
> supply-chain repo is worse than a boring accurate one.

---

## 2. Commit the public half

Not a secret. Consumers need it to verify a feature came from this org.

```bash
cd "$OLDPWD"
cp "$WORK"/release.pub .github/pdp/public-keys/release.pub
git add .github/pdp/public-keys/release.pub
git commit -m "Add the release public key"
```

Verification, for anyone downstream:

```bash
cosign verify --key .github/pdp/public-keys/release.pub \
  ghcr.io/infrashift/trusted-devcontainer-features/git:latest
```

---

## 3. The Release-Actor environment

```bash
gh api -X PUT "repos/${SLUG}/environments/Release-Actor"
cd "$WORK"
gh secret set COSIGN_PRIVATE_KEY --repo "$SLUG" --env Release-Actor < release.key
gh secret set COSIGN_PASSWORD    --repo "$SLUG" --env Release-Actor < release.password
cd / && rm -rf "$WORK"
```

Then, in the GitHub UI: Settings → Environments → **Release-Actor** →
**Required reviewers** → add `@infrashift/security-admins`, and tick **Prevent
self-review**.

**This is the human gate.** The signing key is unreachable until a named person
approves the deployment, which is what makes a Release-Actor signature proof
that a human approved. Without *Prevent self-review*, the person who merged can
approve their own release and the gate buys nothing.

---

## 4. Teams

CODEOWNERS references three teams. If any does not exist, CODEOWNERS matches
nothing for those paths and "require review from Code Owners" is a silent no-op.

```bash
for t in platform-engineers security-admins devops-leads; do
  gh api "orgs/${ORG}/teams/${t}" --jq .slug || echo "MISSING: $t"
done
```

---

## 5. Branch protection on main

Required status checks — the context strings must match exactly what the
workflows publish:

| Context | Published by |
|---|---|
| `repo-gate` | `pr-gate.yml` |
| `test/gate` | `test-templates.yaml` |

**Never make individual matrix legs required checks.** Job names change with the
matrix, and a required context that stops reporting blocks every PR forever.
`test/gate` is the aggregate that exists for this reason.

> The old per-template contexts (`template (python)` and friends) and the
> standalone `role contract` job may still be configured as required. Remove
> them: the contract check now runs inside `repo-gate`, and the template legs
> are covered by `test/gate`.

Also enable: require a PR before merging, require review from Code Owners,
dismiss stale approvals, and require branches to be up to date.

---

## 6. Verify

```bash
make check          # contract, workflow lint, shellcheck, policy, repo gate
```

Then open a throwaway PR and confirm `repo-gate` reports on it even when the PR
touches only documentation — that is the property `pr-gate.yml` exists to
guarantee, and the reason it is not path-filtered.
