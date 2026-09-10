# Gradle Feature

Installs [Gradle](https://gradle.org/) as `gradle` on `PATH`.

## OS Support

Red Hat UBI9/UBI10 and Fedora 43. `bash` is required to execute `install.sh`. Installation is
orchestrated by `/opt/bootstrap/run-feature.sh`, provided by the `bootstrap` feature, in the
userland lane: nothing here touches system state. `unzip` comes from the base image.

## Install Location

- Distribution: `~/.local/share/gradle/gradle-<version>/`
- Launcher: `~/.local/bin/gradle` → `~/.local/share/gradle/gradle-<version>/bin/gradle`

The version-scoped prefix is the idempotency probe: if `<prefix>/bin/gradle` exists the download
is skipped, and a re-run reports `changed=0`. The `gradle` launcher resolves `$0` through
symlinks to find its own home, so no `GRADLE_HOME` and no `containerEnv` entry is needed.

`GRADLE_USER_HOME` stays at its default, `~/.gradle`. Projects that ship a Gradle wrapper will
keep using the wrapper's own pinned distribution; this feature provides the standalone `gradle`
for projects without one and for generating wrappers.

## Requires a JDK

Gradle is pure Java and cannot run without one. This feature declares `installsAfter: ["./openjdk"]`
for ordering only; it does not force `openjdk` in, so a system JDK on `PATH` also works. At
install time the role points `JAVA_HOME` at `~/.local/share/java` when the `openjdk` feature has
put a JDK there, because the userland lane does not carry that feature's `containerEnv`.

## Checksums

Gradle publishes a `.sha256` next to each distribution at
`https://services.gradle.org/distributions/gradle-<version>-bin.zip.sha256`; the role pins those
in `_gradle_pinned_checksums` in `ansible-role-feature/vars/main.yml`. Per ADR-006 an unpinned
version with no `target_checksum` is a named failure, never an unverified download.

## Versions

See https://gradle.org/releases/. Gradle numbers releases `X.Y` (8.14) and patches `X.Y.Z`
(9.7.1); the role accepts both shapes.
