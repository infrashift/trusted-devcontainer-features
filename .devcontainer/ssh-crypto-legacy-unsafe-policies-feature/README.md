# SSH Crypto Unsafe Policies Modification 

## Metadata

| Identifier      | Version |
| ------- | ------- |
| ssh-crypto-legacy-unsafe-policies | 1.0.0 |

## Description

A feature to modify SSH crypto policies to allow use of RSA SHA1 keys for authentication on Redhat UBI DevContainers

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
    "./ssh-crypto-legacy-unsafe-policies-feature": {}
},
...
```