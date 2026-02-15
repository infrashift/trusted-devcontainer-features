## OS Support

This Feature works on recent versions of Redhat UBI distributions. `bash` is required to execute the `install.sh` script. An `ansible-core` bootstrap instance owned by the `ansible` bootstrap user performs the heavy lifting. `pipenv` is required to install `ansible-core`.
 
## Example Usage

You can designate one or multiple Ansible Core versions for installation by enclosing the version numbers within square brackets. This is because the input string is interpreted as a list. Remember to use square brackets even if you are specifying only a single version.

Example for a single version: `"['2.14.4']"`.

Example for a list of versions: `"['2.13.0', '2.13.2', '2.14.1']"`.

To pass the option value for specifying either a single or multiple Ansible Core versions in a devcontainer.json file, you can add the respective version(s) to the "target_ansibleCoreVersion" field within the "./ansible-core-pipenv-feature" object under the "features" section.

*accept option defaults*

```json
// devcontainer.json
...
"features": {
    "./pipenv-feature": {},
    "./ansible-core-feature": {}
},
...
```

*single version*

```json
// devcontainer.json
...
"features": {
    "./pipenv-feature": {},
    "./ansible-core-feature": { "target_version": "['2.14.4', '2.14.3', '2.13.0', '2.11.0']"}
},
...
```

*multiple versions*

```json
// devcontainer.json
...
"features": {
    "./pipenv-feature": {},
    "./ansible-core-feature": { "target_version": "['2.14.4', '2.14.3', '2.13.0', '2.11.0']"}
},
...
```