# Setup runbook

Everything here must be done once, by a human, before the release pipeline can
run. `release.yaml` fails closed by design until it is: `scripts/sign-features.sh`
requires the signing secrets.

**Current state** (verified 2026-08-23):

| Step | State |
|---|---|
| 1. Release keypair generated | done |
| 2. `release.pub` committed | done — `fa04742` |
| 3. `Release-Actor` + secrets | done — holds `COSIGN_PRIVATE_KEY` and `COSIGN_PASSWORD` |
| 3b. Reviewer | done — `ryancraig`, `prevent_self_review: false` |
| 3c. Ref restriction | done — `custom_branch_policies`, one `branch main` policy |
| 4. Teams | none, deliberately — see that step |
| 5. Branch protection | done — ruleset `main`, PR + `repo-gate`; 0 approvals, no bypass |
| 6. Review keypair + Build/Review actors | done — `review.pub` committed; `Build-Actor` (no secrets) and `Review-Actor` created |

Only step 5 remains. The sibling `trusted-devcontainer-templates` is at the same
point, with its ruleset in place but its Release-Actor ref restriction still to
apply.

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

Then add yourself as an environment reviewer:

```bash
gh api -X PUT "repos/${SLUG}/environments/Release-Actor" \
  -F 'reviewers[][type]=User' \
  -F "reviewers[][id]=$(gh api users/ryancraig --jq .id)"
```

**What this buys you, and what it does not.** `infrashift` has one member, so be
precise about the claim.

The signing key living in an environment is real protection regardless of
headcount: the `contract` job — and anything that runs in it — has no access to
it, so a compromised action or dependency in that job cannot sign or publish.
That is defence against supply-chain compromise, which is the actual threat to a
solo project.

The reviewer is *not* separation of duties. With one member, approving is
approving yourself: a deliberate stop-and-look before a release ships, and a
useful one, but call it a speed bump rather than dual control.

**Do NOT tick "Prevent self-review" while the org has one member.** It would
deadlock every release — the only person who could approve is excluded, and no
one else exists.

Verify it took. An empty array means the environment holds a key but enforces
nothing:

```bash
gh api "repos/${SLUG}/environments/Release-Actor" --jq '[.protection_rules[]?.type]'
```

> This repo is **public**, which is what makes environment protection rules
> available on a Free org at all. On a Free plan they are a public-repo feature;
> a private repo needs Team or Enterprise. Worth knowing before making it
> private.

---

### Restrict which refs may deploy to Release-Actor

A reviewer controls *whether* a deployment proceeds. A deployment branch policy
controls *what may ask*. Without one, any workflow in the repo that names
`environment: Release-Actor` can request the signing key from any ref — a
branch, a fork's PR head, a scratch branch someone pushed. The reviewer prompt
still appears, but it does not show you which ref it came from, so it is one
mis-click away from signing a release built from arbitrary code.

`release.yaml` runs only on a push to `main`, so the environment can say so.
Note this differs from the sibling templates repo, which restricts to a `v*`
**tag** because that is what its release is triggered by — match the policy to
the trigger, not to a convention.

```bash
# The payload is built with jq, not a heredoc. A quoted heredoc (<<'JSON') does
# no substitution, so a placeholder id is sent literally and the API rejects the
# whole body as unparseable JSON -- with a message that names neither the field
# nor the reason. An unquoted heredoc would substitute, but then every " and $
# in the body is live. jq takes the id as a typed argument and emits valid JSON
# either way.
REVIEWER_ID=$(gh api users/ryancraig --jq .id)

# reviewers and prevent_self_review are repeated ON PURPOSE -- see the note below.
jq -n --argjson id "$REVIEWER_ID" '{
  deployment_branch_policy: {protected_branches: false, custom_branch_policies: true},
  prevent_self_review: false,
  reviewers: [{type: "User", id: $id}]
}' | gh api -X PUT "repos/${SLUG}/environments/Release-Actor" --input -

# Only reachable once custom_branch_policies is true. If the PUT above failed,
# this returns 404 -- which reads like a missing environment rather than a
# missing prerequisite.
gh api -X POST "repos/${SLUG}/environments/Release-Actor/deployment-branch-policies" \
  -f name='main' -f type=branch
```

> **`reviewers` and `prevent_self_review` are repeated on purpose.** This
> endpoint creates *or replaces* the environment. Sending only
> `deployment_branch_policy` clears the reviewer you added above, and the
> environment silently goes back to deploying unattended. Any later call to this
> endpoint must carry them too — run the verification below afterwards, every
> time.

Verify both halves landed:

```bash
gh api "repos/${SLUG}/environments/Release-Actor" \
  --jq '{rules: [.protection_rules[]?.type], policy: .deployment_branch_policy}'
gh api "repos/${SLUG}/environments/Release-Actor/deployment-branch-policies" \
  --jq '.branch_policies[] | "\(.type)  \(.name)"'
```

Expect `required_reviewers` in `rules`, `custom_branch_policies: true`, and one
`branch  main` policy.

There is only one actor here, so there is nothing to leave open: the single
environment is also the only one that can publish, which is exactly the actor a
ref restriction belongs on.

---

## 4. Teams — not yet, and not silently

The org has **no teams**, and CODEOWNERS deliberately does not reference any:

```bash
gh api orgs/infrashift/teams --jq 'length'    # 0
```

Three single-member teams would be structure without the property it is meant to
express. Worse, **"Require review from Code Owners" must stay OFF while the org
has one member** — GitHub does not let you approve your own pull request, so
turning it on would block every PR you open and force an admin bypass on every
merge. A protection everyone routinely bypasses is worse than none, because it
reads as enforced.

`.github/CODEOWNERS` therefore lists `@ryancraig` and functions as reviewer
auto-assignment and as a map of which changes are trust decisions. It gates
nothing today, and says so at the top of the file.

**When a second maintainer joins**, do all of this in one change:

```bash
gh auth refresh -s admin:org,write:org        # current token has read:org only

for t in platform-engineers security-admins devops-leads; do
  gh api -X POST "orgs/${ORG}/teams" -f name="$t" -f privacy=closed
  gh api -X PUT "orgs/${ORG}/teams/${t}/repos/${ORG}/${REPO}" -f permission=push
done
```

Then swap the owners in `.github/CODEOWNERS`, enable "Require review from Code
Owners", and tick *Prevent self-review* on `Release-Actor`. Together, so the
file never names teams that do not exist.

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

Also enable: require a PR before merging, dismiss stale approvals, and require
branches to be up to date.

**Do not enable "require review from Code Owners" yet** — see step 4. With one
member it blocks every PR you open. Required status checks are different: they
gate on CI rather than on a second human, so turn those on now.

The sibling templates repo's ruleset is the working example to copy — same
shape, different contexts:

```bash
gh api -X POST "repos/${SLUG}/rulesets" --input - <<'JSON'
{
  "name": "main",
  "target": "branch",
  "enforcement": "active",
  "conditions": {"ref_name": {"include": ["~DEFAULT_BRANCH"], "exclude": []}},
  "rules": [
    {"type": "deletion"},
    {"type": "non_fast_forward"},
    {"type": "pull_request",
     "parameters": {"required_approving_review_count": 0,
                    "dismiss_stale_reviews_on_push": true,
                    "require_code_owner_review": false,
                    "require_last_push_approval": false,
                    "required_review_thread_resolution": false}},
    {"type": "required_status_checks",
     "parameters": {"strict_required_status_checks_policy": true,
                    "required_status_checks": [{"context": "repo-gate"},
                                               {"context": "test/gate"}]}}
  ]
}
JSON
```

**What was actually applied differs from the payload above in one way**: the
`required_status_checks` list contains `repo-gate` only, for the reason below.
`required_approving_review_count` is 0 and `bypass_actors` is empty, exactly as
the payload shows.

That is worth stating because it was briefly otherwise. On 2026-08-24 the count
was set to 1 with a `RepositoryRole` 5 (admin) bypass, on the theory that it
would enforce nothing at one member while already being correct for a second.
Every PR afterwards reported `REVIEW_REQUIRED` and `BLOCKED`: you cannot approve
your own pull request, so no approval can exist, and a bypass does not clear
that state — it only offers an override on top of it. It was reverted the same
day, and the PRs turned `CLEAN` immediately.

The bypass was removed with it. `bypass_mode: always` applies to the whole
ruleset, so leaving it would have let an admin merge past `repo-gate` — the
check that actually works here, because it gates on CI rather than on headcount.

`require_code_owner_review: false` stays as written, and for the stated reason:
it has no bypass of its own, so it would block outright rather than degrade.
Raise the approval count on the day a second maintainer joins, with
`bypass_actors` left empty.

**Only `repo-gate` is required.** An earlier version of this section claimed
both contexts could be required immediately. The reasoning it gave was sound but
answered the wrong question: it is true that there is no *ordering* trap here —
the tests build from feature trees staged out of `src/`, resolve nothing from the
registry, and do not wait on `bootstrap` being published.

The trap is the **path filter**. `test-templates.yaml` runs only for changes
under `src/`, `test-templates/`, `scripts/`, `tools.lock`, or its own file. A PR
touching none of those never starts the workflow, so `test/gate` never reports,
so a required `test/gate` waits forever — the precise failure this section warns
about two paragraphs up, arrived at from the other direction.

This is not hypothetical. The sibling templates repo required `build/gate`,
whose workflow is path-filtered the same way, and its first documentation-only PR
afterwards (#6) sat `BLOCKED` with `repo-gate` and `review/cve-policy` green and
`build/gate` never reporting.

`repo-gate` is safe precisely because `pr-gate.yml` is **not** path-filtered,
which is the property step 6 tells you to verify. Requiring `test/gate` needs a
seeding step first — `pr-gate.yml` publishing a `success` status for it when a PR
touches no test-affecting path, the way the templates repo seeds
`review/cve-policy`.

One default worth knowing about: GitHub sets
`require_extra_approval_for_unattributed_changes: true` on a new ruleset. A
commit whose author email is not linked to a GitHub account counts as
unattributed and needs an extra approval — which, at one member, nothing can
supply. If a PR ever stalls asking for an approval you cannot give, that is the
rule to look at. At `required_approving_review_count: 0` it cannot bite — there
is no approval requirement for it to add to — but it becomes live the moment the
count is raised for a second maintainer.

---

## 6. Verify

```bash
make check          # contract, workflow lint, shellcheck, policy, repo gate
```

Then open a throwaway PR and confirm `repo-gate` reports on it even when the PR
touches only documentation — that is the property `pr-gate.yml` exists to
guarantee, and the reason it is not path-filtered.


---

## 6. The review keypair, and the Build/Review environments

**The staged release cannot complete until this is done.** `release.yaml` fails
at its first job with a message pointing here, which is deliberate: the
alternative is discovering the gap three jobs later, after staging has already
been published.

### What changed, and why it needs a second key

The release used to publish straight to the consumer-facing namespace and then
verify what it had published — in one job, holding the signing key. That made
the verification detective rather than preventive (the bad bytes were already
what consumers pulled by the time it failed), and let one job both publish and
attest that its own publish was correct.

Now:

| Stage | Environment | Holds | Can it ship? |
|---|---|---|---|
| `stage-*` | `Build-Actor` | nothing | no — staging only |
| `review-*` | `Review-Actor` | review key | no — it signs a verdict |
| `promote-*` | `Release-Actor` | release key | only digests the verdict names |

The verdict is a **digest list**, not a pass/fail, so what was reviewed and what
ships are the same bytes by construction. A compromised build actor can fill
staging with anything and still cannot get it promoted: it does not hold the
review key. That property is what the second keypair buys, and it holds
regardless of headcount — unlike an approval requirement, which at one member
buys nothing (see step 4).

### Generate the keypair

Same shape as step 1, a different key. Never reuse the release key: if one key
both signs verdicts and promotes, the separation above collapses back into the
thing it replaced.

```bash
cd "$(mktemp -d)"
COSIGN_PASSWORD="$(openssl rand -base64 32)" cosign generate-key-pair
# keep the password; it goes in the environment secret below
```

Commit the public half — and only the public half:

```bash
cp cosign.pub "${REPO}/.github/pdp/public-keys/review.pub"
```

### The two environments

`Build-Actor` holds **no secrets**. Create it anyway: binding the staging jobs
to an environment is what makes "this job cannot sign" a property of the
configuration rather than of the YAML happening not to reference a secret.

`Review-Actor` holds `COSIGN_PRIVATE_KEY` and `COSIGN_PASSWORD` from the keypair
above.

```bash
SLUG=infrashift/trusted-devcontainer-features
for e in Build-Actor Review-Actor; do
  gh api -X PUT "repos/${SLUG}/environments/${e}" --silent
done
gh secret set COSIGN_PRIVATE_KEY --repo "$SLUG" --env Review-Actor < cosign.key
gh secret set COSIGN_PASSWORD    --repo "$SLUG" --env Review-Actor
```

Reviewers on `Review-Actor` are the same judgement call as step 3: at one member
an approval is a stop-and-look, not separation of duties. The key separation
above is what holds regardless.

### The staging namespace

`release.yaml` publishes to `${{ github.repository }}-staging` — a separate GHCR
namespace, not a tag prefix. Anything a consumer could resolve by accident is
not staging.

The first release creates those packages. They are **private by default**, which
is correct: nothing outside this pipeline should pull from staging. The
production packages keep whatever visibility they already have; promotion copies
into them rather than recreating them.

### Verify

```bash
gh api "repos/${SLUG}/environments" --jq '.environments[].name'   # 3 actors + github-pages
test -s .github/pdp/public-keys/review.pub && echo "review key committed"
```

Then push a release and read the summary table: seven rows, three actors. A
promotion that reports `verdict signature verified against .github/pdp/public-keys/review.pub`
is the gate doing its job.
