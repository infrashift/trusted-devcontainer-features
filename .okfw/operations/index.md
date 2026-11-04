# operations

<!-- okfw:generated — maintained by okfw; edits here are overwritten -->

## Concepts

* [Add a new feature](add-a-new-feature--01a1837fe116.md) - Copy the SKELETON feature, write the metadata, install.sh and role, add a test template entry and ROLE_ARGS, then run the checks.
* [Change a feature and bump its version](change-a-feature-and-bump-its-version--01a1837fe143.md) - Each change to a feature source needs a new version, or the published drift check fails and the release skips the change.
* [Change the bootstrap feature](change-the-bootstrap-feature--01a1837fe171.md) - A bootstrap change needs a new bootstrap version and a new version for every dependent feature in the same pull request.
* [Check version currency and update a pin](check-version-currency-and-update-a-pin--01a1837fe233.md) - Run make check-currency, then update each behind pin with its checksums, ROLE_ARGS and test-template values and a version bump.
* [Operations overview](operations-overview--01a1837af719.md) - Runbooks: the steps to add, change, test, check and release a feature, and to set up the environments.
* [Release and promote the features](release-and-promote-the-features--01a1837fe1e1.md) - A merge to main starts release.yaml; approve the two Release-Actor gates after you read each review log, then read the summary.
* [Run the documentation site locally](run-the-documentation-site-locally--01a1837fe289.md) - Run make docs-dev to start the Astro Starlight site in docs/ with Bun.
* [Run the static checks and the repo gate locally](run-the-static-checks-and-the-repo-gate-locally--01a1837fe1ba.md) - Install the pinned tools with make tools, then run make check before each push to run the repo-gate checks without containers.
* [Set up the GitHub environments and signing keys](set-up-the-github-environments-and-signing-keys--01a1837fe20a.md) - One-time setup of the three actor environments, the release and review keypairs and the main ruleset, as SETUP-ENVIRONMENTS.md gives it.
* [Test one template locally](test-one-template-locally--01a1837fe195.md) - Build one test template from the working tree with make test-template, run make test-contract, then remove it with make clean.
* [Use the maintainer dev container](use-the-maintainer-dev-container--01a1837fe25c.md) - The .devcontainer/ environment builds from the working-tree features; prepare-devcontainer.sh stages src/ into .devcontainer/ first.
* [Verify a published feature](verify-a-published-feature--01a1837fe2c1.md) - Verify the signature of a published feature with cosign and the committed release.pub key.

