---
title: Roadmap
description: Planned features and improvements for Infrashift DevContainer Features.
---

## Planned Features

### my-dotfiles
A feature for cloning and applying personal dotfiles repositories. Would support configurable git URLs, installation scripts, and stow-based symlink management.

### Additional Language Runtimes
- **Rust**: Install via rustup with configurable toolchain
- **Ruby**: Install via ruby-build with version pinning

### User-Voted Features
We welcome feature requests via [GitHub Issues](https://github.com/infrashift/trusted-devcontainer-features/issues). Popular requests will be prioritized for implementation.

## Security Enhancements

### SBOM Generation for Features
Generate Software Bills of Materials for each feature installation, documenting exactly what binaries and packages were installed.

### Cosign Signature Verification
Support verifying cosign signatures on downloaded binaries for tools that publish them (e.g., Syft, Grype).

### Supply Chain Attestations
Publish SLSA provenance attestations for the feature container images published to GHCR.

## Platform Support

### UBI 10 Support
Red Hat UBI 10 is on the horizon. We plan to add a parallel test matrix for UBI 10 once it reaches general availability, ensuring all features work on both UBI 9 and UBI 10.

### ARM64 (aarch64) Support
Many features currently only support x86_64. We plan to add ARM64 binary downloads and testing for features where upstream projects provide ARM64 releases.

## Documentation

### Interactive Playground
A browser-based playground for testing feature combinations without local Docker setup.

### Video Tutorials
Step-by-step video guides for common workflows: setting up AI assistants, configuring egress filtering, and creating custom features.

## Contributing

Have an idea for a feature or improvement? [Open an issue](https://github.com/infrashift/trusted-devcontainer-features/issues) or check the [Contributing guide](/trusted-devcontainer-features/reference/contributing/) to get started.
