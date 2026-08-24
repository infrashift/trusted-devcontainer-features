package tdf.pdp_test

import data.tdf.pdp

# The gate consumes `violations` / `blocking` as JSON ARRAYS. If any of these
# rules is ever written `p[x] if { ... }` instead of `p contains x if { ... }`,
# Rego v1 makes it a partial OBJECT, `opa check --strict` still passes, and a
# clean scan marshals to {} instead of []. That is not hypothetical: it is how
# this gate came to block every release. The shape assertions below are the
# guard, because a type check will not do it.

NOW := "2026-08-23T00:00:00Z"

# ===========================================================================
# repo_decision
# ===========================================================================

clean_repo := {
	"evaluated_at": NOW,
	"gitleaks": {"status": "ran", "findings": [], "config_bytes": 3594, "uses_default_ruleset": true},
	"tools": {"OPA_VERSION": "v1.19.1", "SYFT_VERSION": "v1.51.0"},
	"unpinned_actions": [],
}

test_clean_repo_is_allowed if {
	d := pdp.repo_decision with input as clean_repo
	d.allow
	d.counts.violations == 0
}

test_repo_violations_marshal_as_an_array if {
	d := pdp.repo_decision with input as clean_repo
	json.marshal(d.violations) == "[]"
	json.marshal(d.warnings) == "[]"
}

# --- fail-closed on the input itself ---------------------------------------

test_missing_timestamp_denies if {
	d := pdp.repo_decision with input as object.remove(clean_repo, {"evaluated_at"})
	not d.allow
	some v in d.violations
	v.code == "INPUT_TIMESTAMP_INVALID"
}

test_non_rfc3339_timestamp_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"evaluated_at": "yesterday"})
	not d.allow
}

# A policy that fails to evaluate must deny, never return undefined.
test_default_repo_decision_denies if {
	d := pdp.repo_decision with input as "not-an-object"
	not d.allow
}

# --- secret scanning -------------------------------------------------------

test_gitleaks_not_run_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"gitleaks": {"status": "not-installed", "findings": [], "config_bytes": 3594, "uses_default_ruleset": true}})
	not d.allow
	some v in d.violations
	v.code == "GITLEAKS_DID_NOT_RUN"
}

# The headline case: an empty config means zero rules, so gitleaks scans, finds
# nothing and exits 0 -- indistinguishable from a clean scan unless the byte
# count is what the policy reads.
test_empty_gitleaks_config_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"gitleaks": {"status": "ran", "findings": [], "config_bytes": 0, "uses_default_ruleset": true}})
	not d.allow
	some v in d.violations
	v.code == "GITLEAKS_CONFIG_EMPTY"
	v.bytes == 0
}

test_gitleaks_defaults_disabled_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"gitleaks": {"status": "ran", "findings": [], "config_bytes": 3594, "uses_default_ruleset": false}})
	not d.allow
	some v in d.violations
	v.code == "GITLEAKS_DEFAULTS_DISABLED"
}

test_malformed_findings_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"gitleaks": {"status": "ran", "findings": "none", "config_bytes": 3594, "uses_default_ruleset": true}})
	not d.allow
	some v in d.violations
	v.code == "GITLEAKS_REPORT_MALFORMED"
}

test_non_numeric_config_bytes_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"gitleaks": {"status": "ran", "findings": [], "config_bytes": "3338", "uses_default_ruleset": true}})
	not d.allow
	some v in d.violations
	v.code == "GITLEAKS_CONFIG_UNKNOWN"
}

test_detected_secret_denies_and_names_the_file if {
	leak := {"File": "cosign.key", "RuleID": "cosign-sigstore-private-key"}
	d := pdp.repo_decision with input as object.union(clean_repo, {"gitleaks": {"status": "ran", "findings": [leak], "config_bytes": 3594, "uses_default_ruleset": true}})
	not d.allow
	some v in d.violations
	v.code == "SECRET_DETECTED"
	v.file == "cosign.key"
}

# --- tool and action pinning ----------------------------------------------

test_unpinned_tool_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"tools": {"OPA_VERSION": "latest"}})
	not d.allow
	some v in d.violations
	v.code == "TOOL_NOT_PINNED"
	v.tool == "OPA_VERSION"
}

test_missing_tools_lock_denies if {
	d := pdp.repo_decision with input as object.remove(clean_repo, {"tools"})
	not d.allow
	some v in d.violations
	v.code == "TOOLS_LOCK_MISSING"
}

test_unpinned_action_denies if {
	d := pdp.repo_decision with input as object.union(clean_repo, {"unpinned_actions": ["actions/checkout@v4"]})
	not d.allow
	some v in d.violations
	v.code == "ACTION_NOT_PINNED"
	v.ref == "actions/checkout@v4"
}
