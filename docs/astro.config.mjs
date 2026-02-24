// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
	site: 'https://infrashift.github.io',
	base: '/trusted-devcontainer-features',
	integrations: [
		starlight({
			title: 'DevContainer Features',
			social: [
				{ icon: 'github', label: 'GitHub', href: 'https://github.com/infrashift/trusted-devcontainer-features' },
			],
			editLink: {
				baseUrl: 'https://github.com/infrashift/trusted-devcontainer-features/edit/main/docs/',
			},
			customCss: ['./src/styles/custom.css'],
			sidebar: [
				{ label: 'Getting Started', slug: 'getting-started' },
				{
					label: 'Features',
					items: [
						{ label: 'Feature Inventory', slug: 'features' },
						{
							label: 'Languages & Runtimes',
							items: [
								{ label: 'Bun', slug: 'features/bun' },
								{ label: '.NET SDK', slug: 'features/dotnet' },
								{ label: 'Go', slug: 'features/golang' },
								{ label: 'Node.js', slug: 'features/nodejs' },
								{ label: 'OpenJDK', slug: 'features/openjdk' },
								{ label: 'Python', slug: 'features/python' },
							],
						},
						{
							label: 'Package Managers',
							items: [
								{ label: 'npm', slug: 'features/npm' },
								{ label: 'pnpm', slug: 'features/pnpm' },
								{ label: 'UV & Ruff', slug: 'features/uv-ruff' },
							],
						},
						{
							label: 'CLI Tools',
							items: [
								{ label: 'Git', slug: 'features/git' },
								{ label: 'Git LFS', slug: 'features/git-lfs' },
								{ label: 'jq', slug: 'features/jq' },
								{ label: 'yq', slug: 'features/yq' },
								{ label: 'CUElang', slug: 'features/cuelang' },
							],
						},
						{
							label: 'Security & SBOMs',
							items: [
								{ label: 'Grype', slug: 'features/grype' },
								{ label: 'Syft', slug: 'features/syft' },
								{ label: 'Egress Filter', slug: 'features/egress-filter' },
							],
						},
						{
							label: 'Infrastructure',
							items: [
								{ label: 'Ansible Core', slug: 'features/ansible-core' },
							],
						},
						{
							label: 'AI Coding Assistants',
							items: [
								{ label: 'Claude Code', slug: 'features/claude-code', badge: { text: 'New', variant: 'tip' } },
								{ label: 'OpenAI Codex', slug: 'features/openai-codex', badge: { text: 'New', variant: 'tip' } },
							],
						},
					],
				},
				{
					label: 'AI-Powered DevContainers',
					items: [
						{ label: 'Overview', slug: 'ai-support' },
						{ label: 'Claude Code', slug: 'ai-support/claude-code' },
						{ label: 'OpenAI Codex', slug: 'ai-support/openai-codex' },
						{ label: 'Egress Filtering for AI', slug: 'ai-support/egress-filter' },
					],
				},
				{
					label: 'Architecture Decisions',
					items: [
						{ label: 'ADR Index', slug: 'decisions' },
						{ label: 'ADR-001: UBI Image Support', slug: 'decisions/adr-001-ubi-image-support' },
						{ label: 'ADR-002: Ansible Bootstrapper', slug: 'decisions/adr-002-ansible-bootstrapper' },
						{ label: 'ADR-003: Non-Root vscode User', slug: 'decisions/adr-003-non-root-vscode-user' },
						{ label: 'ADR-004: UV as Ansible Runner', slug: 'decisions/adr-004-uv-as-ansible-runner' },
						{ label: 'ADR-005: Bun as Package Manager', slug: 'decisions/adr-005-bun-as-package-manager' },
						{ label: 'ADR-006: Checksum Verification', slug: 'decisions/adr-006-checksum-verification' },
						{ label: 'ADR-007: Feature Dependency Model', slug: 'decisions/adr-007-feature-dependency-model' },
					],
				},
				{
					label: 'Reference',
					items: [
						{ label: 'Architecture', slug: 'reference/architecture' },
						{ label: 'Contributing', slug: 'reference/contributing' },
						{ label: 'Roadmap', slug: 'reference/roadmap' },
					],
				},
			],
		}),
	],
});
