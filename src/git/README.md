# Git Install 

## Metadata

| Identifier      | Version |
| ------- | ------- |
| git | 1.0.0 |

## Description

A feature to install Git on Redhat UBI DevContainers

## Options
No options available



---

## OS Support

This Feature works on recent versions of Redhat UBI distributions. `bash` is required to execute the `install.sh` script. An `ansible-core` bootstrap instance owned by the `ansible` bootstrap user performs the heavy lifting.

## Example Usage

*accept option values*

```json
// devcontainer.json
...
"features": {
    "./git-feature": {}
},
...
```