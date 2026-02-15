# cuelang-feature 

## Metadata

| Identifier      | Version |
| ------- | ------- |
| cuelang | 1.0.0 |

## Description

A feature to install CUElang on Redhat UBI DevContainers.

## Options

### target_version

* Type: `string`
* Default: `0.6.0-alpha.1`
* Description: Select a supported CUElang binary version
* Proposals: `0.6.0-alpha.1`, `0.5.0`

## Installs After

* ./golang-feature

## Customizations


### vscode

* Extensions: `jallen7usa.vscode-cue-fmt`



---

## OS Support

This Feature works on recent versions of Redhat UBI distributions. `bash` is required to execute the `install.sh` script. An `ansible-core` bootstrap instance owned by the `ansible` bootstrap user performs the heavy lifting.

## Example Usage

*specify option values*

```json
// devcontainer.json
...
"features": {
    "./golang-feature": {
        "target_version": "1.20.3",
        "target_checksum": "979694c2c25c735755bf26f4f45e19e64e4811d661dd07b8c010f7a8e18adfca"
        },
    "./cuelang-feature": { "target_version": "0.6.0-alpha.1"}
},
...
```

*accept option values*

```json
// devcontainer.json
...
"features": {
    "./golang-feature": {},
    "./cuelang-feature": {}
},
...
```