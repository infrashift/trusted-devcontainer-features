# Python Feature

Installs a specific Python version using [UV](https://github.com/astral-sh/uv) python management.

## Install Location

- Python: `~/.local/share/uv/python/` (managed by UV)
- Discovery: `uv python find <version>`

## Versions

Supported versions: 3.9, 3.10, 3.11, 3.12, 3.13, 3.14

## Notes

- UV must be available (either from uv-ruff-feature or the bootstrap uv in /usr/local/bin)
- Single version per feature invocation; add multiple feature entries for multiple versions
