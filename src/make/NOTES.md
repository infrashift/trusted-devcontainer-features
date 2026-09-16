# GNU Make Feature

Installs [GNU Make](https://www.gnu.org/software/make/) on Red Hat UBI and
Fedora DevContainers.

## Why this feature exists

Every seed repository ships a `Makefile`, and the golden workflow is spelled
`make all` — in the seeds' own READMEs, in `RDW-DEV-GUIDE-*.md` and in
`DEVELOPER-SEED-TO-WORKSPACE.md`. The trusted base images carry no `make`, so a
developer who followed those instructions inside a workspace got

```
make: command not found
```

Found on `chad/dotnet`, gcloud-dc, 2026-09-16. The pipeline's runner image hit
the same wall earlier and was fixed there; the workspace image was not, because
the pipeline runs `make build test` in the runner and never in the workspace.

## Install Location

`/usr/bin/make`, from the distribution's own package. This is a **privileged**
feature: it installs a system RPM, so `install.sh` passes `--privileged` and the
runner stays root rather than dropping to the target user.

## No options

The distribution's `make` is the one we want. Pinning a version would mean
building it from source for no benefit the golden workflow can observe.

`make` alone, not a full build toolchain: the seeds' Makefiles drive shell
scripts, and a language's compiler comes from that language's feature.

## Example Usage

```json
// devcontainer.json
"features": {
    "./make": {}
}
```
