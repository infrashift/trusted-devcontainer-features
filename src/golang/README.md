# golang-feature 

## Metadata

| Identifier      | Version |
| ------- | ------- |
| golang | 1.0.0 |

## Description

A feature to install Golang on Redhat UBI DevContainers.

## Options

### target_checksum

* Type: `string`
* Default: `979694c2c25c735755bf26f4f45e19e64e4811d661dd07b8c010f7a8e18adfca`
* Description: Select the corresponding Golang binary checksum
* Proposals: `979694c2c25c735755bf26f4f45e19e64e4811d661dd07b8c010f7a8e18adfca`, `e1a0bf0ab18c8218805a1003fd702a41e2e807710b770e787e5979d1cf947aba`

### target_version

* Type: `string`
* Default: `1.20.3`
* Description: Select a supported Golang binary version
* Proposals: `1.20.3`, `1.19.8`

## Customizations


### vscode

* Extensions: `golang.Go`



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
        }
},
...
```

*accept option values*

```json
// devcontainer.json
...
"features": {
    "./golang-feature": {}
},
...
```