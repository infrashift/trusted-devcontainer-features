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