# npm Feature

> **Deprecated.** The nodejs feature now replaces the npm bundled with Node.js
> itself, through its `npm_version` option (default 12.2.1). Set that option
> instead of adding this feature. With both at their defaults this feature is a
> no-op; it is kept so existing devcontainer.json files keep building.

Updates [npm](https://www.npmjs.com/) to a specific version.

## Install Location

- npm is installed as part of Node.js at `~/.local/share/nodejs/bin/npm`
- This feature updates it in-place using `npm install -g npm@<version>`

## Versions

See available versions at https://github.com/npm/cli/releases

## Notes

- Requires Node.js (installsAfter nodejs-feature)
- npm is bundled with Node.js; this feature updates it to a specific version
