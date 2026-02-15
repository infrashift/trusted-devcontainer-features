# Sudo without Password 

## Metadata

| Identifier      | Version |
| ------- | ------- |
| sudo-nopasswd | 1.0.0 |

## Description

 This feature is designed for Red Hat UBI DevContainers.It modifies an existing user to allow sudo without password (NOPASSWD) by updating the sudoers configuration.

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
    "./sudo-nopasswd-feature": {}
},
...
```