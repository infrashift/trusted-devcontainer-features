# features

<!-- okfw:generated — maintained by okfw; edits here are overwritten -->

## Concepts

* [Feature: ansible-core](feature-ansible-core--01a183800d2e.md) - The ansible-core feature installs a user copy of ansible-core as a uv tool; it is separate from the pinned copy in /opt/bootstrap.
* [Feature: bootstrap](feature-bootstrap--01a183800d4f.md) - The bootstrap feature installs pinned uv, Python and ansible-core in /opt/bootstrap and the runner that every other feature uses.
* [Feature: bun](feature-bun--01a183800d6f.md) - The bun feature installs the Bun JavaScript runtime from a GitHub release zip, verified against a pinned SHA256 checksum.
* [Feature: claude-code](feature-claude-code--01a183800d91.md) - The claude-code feature installs the Claude Code CLI with bun install -g; it resolves the npm dist-tag latest to an exact version first.
* [Feature: cuelang](feature-cuelang--01a183800db4.md) - The cuelang feature installs the cue command from a GitHub release tarball, verified against a pinned SHA256 checksum.
* [Feature: dotnet](feature-dotnet--01a183800dda.md) - The dotnet feature installs the .NET SDK 10 (default) or 8 from the Microsoft CDN in ~/.local/share/dotnet, verified against a pinned SHA512 checksum.
* [Feature: envbuilder](feature-envbuilder--01a183800e01.md) - The envbuilder feature downloads the single image layer of Coder envbuilder from the registry; the pinned layer digest is the URL and the checksum.
* [Feature: git](feature-git--01a183800e27.md) - The git feature installs the git RPM of the distribution with dnf5 in the privileged lane; it has no options.
* [Feature: git-lfs](feature-git-lfs--01a183800e4e.md) - The git-lfs feature installs the git-lfs RPM of the distribution with dnf5 in the privileged lane; it has no options.
* [Feature: golang](feature-golang--01a183800e75.md) - The golang feature installs Go from go.dev in ~/.local/share/go, verified against a pinned SHA256 checksum, with GOPATH set.
* [Feature: gradle](feature-gradle--01a183800e9f.md) - The gradle feature installs Gradle from services.gradle.org, verified against a pinned SHA256 checksum; it needs a JDK.
* [Feature: grype](feature-grype--01a183800ecb.md) - The grype feature installs the Anchore Grype scanner; it verifies the tarball against the checksums file of the release.
* [Feature: jq](feature-jq--01a183800ef7.md) - The jq feature installs the jq binary from GitHub releases into ~/.local/bin, verified against a pinned SHA256 checksum.
* [Feature: kaniko](feature-kaniko--01a183800f23.md) - The kaniko feature downloads one pinned image layer each for the kaniko executor and the cache warmer from the registry.
* [Feature: make](feature-make--01a183800f4f.md) - The make feature installs the make RPM of the distribution in the privileged lane, so that make all works in a workspace.
* [Feature: maven](feature-maven--01a183800f7a.md) - The maven feature installs Apache Maven from archive.apache.org, verified against a pinned SHA512 checksum; it needs a JDK.
* [Feature: nodejs](feature-nodejs--01a183800fa6.md) - The nodejs feature installs Node.js from nodejs.org and replaces the bundled npm with the version in the npm_version option.
* [Feature: npm](feature-npm--01a183800fd2.md) - Deprecated: the nodejs feature now replaces its bundled npm, so the npm feature does nothing at the default versions.
* [Feature: okfw](feature-okfw--01a1a8536440.md) - The okfw feature installs the OKF Wiki CLI and MCP server; it verifies a pinned checksum and the upstream cosign signature.
* [Feature: openai-codex](feature-openai-codex--01a183800ffe.md) - The openai-codex feature installs the OpenAI Codex CLI with bun install -g; it resolves the npm dist-tag latest to an exact version first.
* [Feature: openjdk](feature-openjdk--01a18380102a.md) - The openjdk feature installs Eclipse Temurin OpenJDK from Adoptium in ~/.local/share/java, verified against a pinned SHA256 checksum.
* [Feature: pnpm](feature-pnpm--01a183801056.md) - The pnpm feature installs the pnpm standalone binary into ~/.local/bin, verified against a pinned SHA256 checksum.
* [Feature: python](feature-python--01a183801082.md) - The python feature installs a Python version with uv python install; it uses the uv of the dev user, or else the bootstrap uv.
* [Feature: sqlpackage](feature-sqlpackage--01a1838010af.md) - The sqlpackage feature installs SqlPackage as a .NET tool from NuGet; it needs the .NET SDK of the dotnet feature.
* [Feature: sshd](feature-sshd--01a1838010dc.md) - The sshd feature installs and hardens an OpenSSH server for public-key access; it is the only feature with an entrypoint.
* [Feature: syft](feature-syft--01a183801108.md) - The syft feature installs the Anchore Syft SBOM generator; it verifies the tarball against the checksums file of the release.
* [Feature: uv-ruff](feature-uv-ruff--01a183801130.md) - The uv-ruff feature installs uv for the dev user from a checksum-verified tarball, then installs Ruff with uv tool install.
* [Feature: yq](feature-yq--01a18380115a.md) - The yq feature installs the yq binary from GitHub releases into ~/.local/bin, verified against a pinned SHA256 checksum.
* [Features overview](features-overview--01a1837af6b6.md) - One pointer concept for each published feature, with its version, options and dependencies.

