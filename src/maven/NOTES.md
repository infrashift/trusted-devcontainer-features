# Maven Feature

Installs [Apache Maven](https://maven.apache.org/) as `mvn` on `PATH`.

## OS Support

Red Hat UBI9/UBI10 and Fedora 43. `bash` is required to execute `install.sh`. Installation is
orchestrated by `/opt/bootstrap/run-feature.sh`, provided by the `bootstrap` feature, in the
userland lane: nothing here touches system state.

## Install Location

- Distribution: `~/.local/share/maven/apache-maven-<version>/`
- Launcher: `~/.local/bin/mvn` → `~/.local/share/maven/apache-maven-<version>/bin/mvn`

The version-scoped prefix is the idempotency probe: if `<prefix>/bin/mvn` exists the download
is skipped, and a re-run reports `changed=0`. The `mvn` launcher resolves `$0` through symlinks
to find its own home, so no `MAVEN_HOME` and no `containerEnv` entry is needed.

Maven's local repository stays at its default, `~/.m2`.

## Requires a JDK

Maven is pure Java and cannot run without one. This feature declares `installsAfter: ["./openjdk"]`
for ordering only; it does not force `openjdk` in, so a system JDK on `PATH` also works. At
install time the role points `JAVA_HOME` at `~/.local/share/java` when the `openjdk` feature has
put a JDK there, because the userland lane does not carry that feature's `containerEnv`.

## Checksums are SHA512

Apache publishes only a `.sha512` next to each distribution, so that is the digest the role pins
and the digest `target_checksum` accepts (128 hex characters). Per ADR-006 an unpinned version
with no `target_checksum` is a named failure, never an unverified download.

To pin a new version, copy the digest from
`https://archive.apache.org/dist/maven/maven-3/<version>/binaries/apache-maven-<version>-bin.tar.gz.sha512`
into `_maven_pinned_checksums` in `ansible-role-feature/vars/main.yml`, and byte-verify it.

## Why archive.apache.org

`dlcdn.apache.org` serves only current releases and drops a version as soon as it is superseded,
which would turn a pinned older version into a 404. `archive.apache.org` holds every release,
the current one included.

## Versions

See https://maven.apache.org/download.cgi and https://archive.apache.org/dist/maven/maven-3/.
Maven 4 is still a release candidate and is not offered as a proposal.
