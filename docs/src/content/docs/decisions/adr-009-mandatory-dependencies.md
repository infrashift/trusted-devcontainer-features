---
title: "ADR-009: Mandatory Dependencies via dependsOn"
description: Decision to use dependsOn for mandatory feature inclusion, retaining installsAfter for ordering.
---

**Status:** Accepted — supersedes [ADR-007](/trusted-devcontainer-features/decisions/adr-007-feature-dependency-model/)

## Context

[ADR-007](/trusted-devcontainer-features/decisions/adr-007-feature-dependency-model/) chose `installsAfter` and recorded its own limitation: *"`installsAfter` only controls ordering, not mandatory inclusion. Users must explicitly add all required features."*

That was tolerable when dependencies were soft. If a user added `npm` without `nodejs`, only `npm` broke. It is not tolerable now that [ADR-008](/trusted-devcontainer-features/decisions/adr-008-pinned-bootstrap-environment/) makes every feature depend on a shared runner at `/opt/bootstrap`. A `devcontainer.json` that omits the `bootstrap` feature would break **every** feature at once, with an error pointing at whichever happened to run first.

## Decision

Every feature declares the bootstrap feature under **`dependsOn`**, using a **relative** reference:

```jsonc
{
    "dependsOn": {
        "./bootstrap": {}
    }
}
```

The relative form is deliberate. An absolute OCI reference
(`ghcr.io/infrashift/trusted-devcontainer-features/bootstrap`) cannot be resolved before the
feature is published, so it breaks the repository's own CI and any local build of an unpublished
change:

```
Could not resolve Feature manifest for '…/bootstrap'.
ERR: Feature '…/bootstrap' could not be processed.
```

That failure occurs even when the template explicitly lists the local `./bootstrap` feature — the
CLI resolves the declared dependency independently. A relative reference resolves within the same
collection, exactly as the existing `installsAfter` entries (`./bun`, `./nodejs`) already do, and
it works both locally and once published.

Unlike `installsAfter`, `dependsOn` causes the runtime to *install* the dependency if it is not already present. Templates need not list `bootstrap` explicitly, though ours do for visibility.

`installsAfter` is retained for its original purpose — ordering between features that do not require each other's presence (`cuelang` after `golang`, `python` after `uv-ruff`).

Defence in depth: `run-feature.sh` also asserts the environment exists and exits with an explanatory error if it does not. A hand-edited `devcontainer.json` or a damaged image fails loudly rather than silently falling back to an unpinned `uv run`.

## Consequences

- **Positive**: A feature set cannot be assembled in a state where the runner is missing.
- **Positive**: Templates stay readable — they list what the developer wants, not plumbing.
- **Positive**: The runtime assert turns a confusing cascade of failures into one clear message.
- **Negative**: `dependsOn` is newer than `installsAfter` and less widely implemented; consumers on older tooling may need to list `bootstrap` explicitly.
- **Positive**: The relative reference keeps features namespace-agnostic — a fork publishing under a different registry needs no edits.
- **Negative**: `dependsOn` is resolved by the runtime, so a template's `devcontainer.json` no longer lists everything that will be installed. Our templates list `bootstrap` explicitly anyway, for visibility.

## Alternatives Considered

- **`installsAfter` plus a runtime assert only**: Keeps ADR-007 intact but makes every template responsible for remembering plumbing, and fails at build time rather than resolution time.
- **Vendor the runner into every feature**: Restores the 21-way duplication this architecture exists to remove, and lets copies drift.
- **Bake the runner into the base image**: Works for our own templates, but makes features unusable on any other base. `dependsOn` keeps them self-contained.
- **Absolute OCI reference in `dependsOn`**: Unambiguous, but unresolvable until published — it breaks CI for the very change that introduces a new feature, and hardcodes the publishing namespace.
