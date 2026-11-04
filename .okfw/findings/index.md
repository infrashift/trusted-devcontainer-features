# findings

<!-- okfw:generated — maintained by okfw; edits here are overwritten -->

## Concepts

* [Findings overview](findings-overview--01a1837af700.md) - Measured facts that have a date: advisory counts, version currency and scan results.
* [On 2026-08-23, stale feature tool pins caused most template CVE findings](on-2026-08-23-stale-feature-tool-pins-caused-most-template-cve-findings--01a183826856.md) - The first templates CVE gate run traced most blocking findings to old tool versions in features: syft and grype 38 each, go 38.
* [On 2026-10-28, jq tags 1.4.0 to 1.5.1 resolve to the 1.5.2 build](on-2026-10-28-jq-tags-1-4-0-to-1-5-1-resolve-to-the-1-5-2-build--01a183826888.md) - In production, the jq tags 1.4.0, 1.5.0, 1.5.1 and 1.5.2 have one manifest digest, so three old tags do not give their own build.
* [On 2026-10-28, kaniko is the only feature pin behind upstream](on-2026-10-28-kaniko-is-the-only-feature-pin-behind-upstream--01a1838267fd.md) - make check-currency on 2026-10-28: 18 pins current, kaniko behind (1.28.6 against 1.29.0), sqlpackage unknown, four not comparable.
* [npm 12.2.1 clears 22 of 27 bundled-dependency advisories](npm-12-2-1-clears-22-of-27-bundled-dependency-advisories--01a183826829.md) - On 2026-10-28 an OSV scan found 27 advisories in npm 12.0.2 node_modules and 6 in 12.2.1; undici and ip-address fixes wait upstream.

