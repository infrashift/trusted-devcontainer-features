# Node.js Feature

Installs [Node.js](https://nodejs.org/) JavaScript runtime.

## Install Location

- Node.js: `~/.local/share/nodejs/`
- Binaries (node, npm, npx, corepack): `~/.local/share/nodejs/bin/`

## Versions

See available versions at https://nodejs.org/en/download/

## Notes

- Node.js tarball contains a nested directory (e.g., `node-v22.16.0-linux-x64/`), extracted with `--strip-components=1`
- npm and corepack are bundled with Node.js. The bundled npm is always replaced
  with `npm_version` (default 12.2.1): the copy Node.js ships lags behind and
  carries dependencies with published advisories.
- npm 12 requires Node.js ^22.22.2 || ^24.15.0 || >=26. To pin an older
  Node.js, also set `npm_version` to a 10.x release.
