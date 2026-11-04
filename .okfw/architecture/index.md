# architecture

<!-- okfw:generated — maintained by okfw; edits here are overwritten -->

## Concepts

* [Architecture overview](architecture-overview--01a1837af69f.md) - How a feature installs: install.sh, the bootstrap runner, and one Ansible role, with the contract that binds them.
* [Bootstrap environment](bootstrap-environment--01a1837fdda1.md) - The bootstrap feature installs pinned uv, Python and ansible-core into root-owned /opt/bootstrap, with the runner, inventory and site.yml.
* [Contract tests](contract-tests--01a1837fde81.md) - test-templates/shared/contract-tests.sh runs each role again and requires changed=0, then checks that bad parameters fail by name.
* [Dev user](dev-user--01a1837fde35.md) - Features never hardcode the user: the runner reads _REMOTE_USER and _REMOTE_USER_HOME, and the test Containerfile defaults to dev 1001:1001.
* [Feature dependency model](feature-dependency-model--01a1837fddea.md) - Every feature has dependsOn bootstrap, pinned by digest at publish time, so bootstrap publishes first; installsAfter only orders features.
* [Feature install pipeline](feature-install-pipeline--01a1837fdd88.md) - Each feature installs in three stages: install.sh calls /opt/bootstrap/run-feature.sh, which runs site.yml to apply the feature role.
* [Install paths](install-paths--01a1837fde1b.md) - Userland features install below the dev user home: binaries link into ~/.local/bin, tool trees go in ~/.local/share/<tool>.
* [Repository layout](repository-layout--01a1837fde9c.md) - The top-level directories and files of the features repository and what each one holds.
* [Role contract](role-contract--01a1837fddd1.md) - The ADR-012 rules that make a missing or bad option fail by name; make check-contract enforces the static rules on each role.
* [System packages](system-packages--01a1837fde4e.md) - Privileged roles install RPMs through /opt/bootstrap/tasks/install-packages.yml, which calls dnf5; shared libraries stay in the base image.
* [Test templates](test-templates--01a1837fde68.md) - Seven dev containers in test-templates/ build the working-tree features on the shared Containerfile and run smoke tests in tests.sh.
* [Userland and privileged lanes](userland-and-privileged-lanes--01a1837fddb9.md) - The runner drops to the dev user with setpriv by default; --privileged keeps root for the four features that change system state.
* [Variant detection](variant-detection--01a1837fde02.md) - The bootstrap feature reads /etc/os-release once and writes the variant (fedora43, ubi9, ubi10) to the inventory; each role asserts it.

