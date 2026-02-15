# SKELETON-feature 

## Metadata

| Identifier      | Version |
| ------- | ------- |
| SKELETON | 0.0.0 |

## Description

A feature to install SKELETON on Redhat UBI DevContainers

## Options

### color_choice

* Type: `string`
* Default: `green`
* Description: Select a color
* Proposals: `blue`, `green`, `red`

### is_my_favorite_color

* Type: `boolean`
* Default: `true`
* Description: true or false


---

## OS Support

This Feature works on recent versions of Redhat UBI distributions. `bash` is required to execute the `install.sh` script. An `ansible-core` bootstrap instance owned by the `ansible` bootstrap user performs the heavy lifting.

## Example Usage

*accept option values*

```json
// devcontainer.json
...
"features": {
    "./SKELETON-feature": {}
},
...
```

*specify option values*

```json
// devcontainer.json
...
"features": {
    "./SKELETON-feature": {"color": "blue", "is_my_favorite_color": true}
},
...
```