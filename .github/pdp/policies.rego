package tdf.pdp

# Policy Decision Point for trusted-devcontainer-features.
#
# ONE ENTRY POINT
#
#   data.tdf.pdp.repo_decision   Scope: the repository. Secret scanning and
#                                tool-pinning hygiene. Once per PR.
#
# There is deliberately no CVE gate here. This repo publishes features -- OCI
# artifacts carrying an install script and an Ansible role -- not images. The
# CVE surface belongs to whatever base image a feature is installed into, and
# that gate lives in trusted-devcontainer-templates, which builds the images.
# A second gate here would produce a verdict that can disagree with the
# authoritative one.
#
# ---------------------------------------------------------------------------
# DETERMINISM
#
# time.now_ns() is called NOWHERE in this file. Every temporal comparison uses
# input.evaluated_at, supplied by the caller. Re-running the gate on the same
# input a year later yields byte-identical output, which is what makes a signed
# verdict worth signing.
#
# ---------------------------------------------------------------------------
# FAIL-CLOSED CONTRACT. Read before editing anything below.
#
#   1. NUMBERS. `> 0` against a missing or non-numeric value is *undefined* in
#      Rego, which is silently non-violating. Every numeric field has a
#      companion is_number() guard. Never rely on the comparison alone.
#
#   2. ENUMS. Every enum is read through object.get() with a "<missing>"
#      sentinel and tested against a closed set. Unknown or absent violates.
#
#   3. SETS. Partial sets are declared `contains x if`, never `p[x] if`. Rego v1
#      reads the bracket form as a partial OBJECT and `opa check` accepts it, so
#      a clean scan silently returns {} instead of [] -- which is exactly how
#      this gate came to block every release. policies_test.rego pins the shape.

missing := "<missing>"

severities := {"Critical", "High", "Medium", "Low", "Negligible", "Unknown"}

fix_states := {"fixed", "not-fixed", "wont-fix", "unknown"}

# ---------------------------------------------------------------------------
# Shared helpers

evaluated_at_ns := ns if {
	ns := time.parse_rfc3339_ns(object.get(input, ["evaluated_at"], ""))
	ns > 0
}

evaluated_at_str := object.get(input, ["evaluated_at"], missing)

# ===========================================================================
# REPO SCOPE
# ===========================================================================

# No rule produces a warning in this repo yet -- the waiver machinery that
# generated them belongs to the CVE gate, which lives in the templates repo.
# Declared explicitly so repo_decision stays total rather than undefined, and so
# the decision document keeps the same shape as the templates repo's. To add a
# warning, change this to `repo_warnings contains v if { ... }`.
repo_warnings := set()

default repo_decision := {
	"allow": false,
	"violations": [],
	"warnings": [],
	"error": "policy did not evaluate",
}

repo_decision := {
	"allow": count(repo_violations) == 0,
	"counts": {"violations": count(repo_violations), "warnings": count(repo_warnings)},
	"evaluated_at": evaluated_at_str,
	"violations": sort([v | some v in repo_violations]),
	"warnings": sort([w | some w in repo_warnings]),
}

repo_violations contains v if {
	not evaluated_at_ns
	v := {"code": "INPUT_TIMESTAMP_INVALID", "message": "input.evaluated_at is missing or not RFC3339. Denying."}
}

# --- Secret scanning -------------------------------------------------------
# A sibling repo asserted "gitleaks_passed": true as a hardcoded literal in a
# shell heredoc while .gitleaks.toml was 0 bytes and every rule was disabled.
# These rules consume MEASURED facts instead: the tool ran, the config is
# non-trivial, it extends the defaults, and the findings list is a real array.

repo_violations contains v if {
	object.get(input, ["gitleaks", "status"], missing) != "ran"
	v := {"code": "GITLEAKS_DID_NOT_RUN", "message": "gitleaks.status is not \"ran\". A gate that did not execute is not a pass. Denying."}
}

repo_violations contains v if {
	not is_array(object.get(input, ["gitleaks", "findings"], null))
	v := {"code": "GITLEAKS_REPORT_MALFORMED", "message": "gitleaks.findings is missing or not an array. Denying."}
}

repo_violations contains v if {
	not is_number(object.get(input, ["gitleaks", "config_bytes"], null))
	v := {"code": "GITLEAKS_CONFIG_UNKNOWN", "message": "gitleaks.config_bytes is missing or not a number. Denying."}
}

repo_violations contains v if {
	b := object.get(input, ["gitleaks", "config_bytes"], null)
	is_number(b)
	b < 64
	v := {"code": "GITLEAKS_CONFIG_EMPTY", "bytes": b, "message": sprintf(".gitleaks.toml is %v bytes. An empty config silently disables every rule and exits 0. Denying.", [b])}
}

repo_violations contains v if {
	object.get(input, ["gitleaks", "uses_default_ruleset"], false) != true
	v := {"code": "GITLEAKS_DEFAULTS_DISABLED", "message": ".gitleaks.toml must set [extend] useDefault = true. Denying."}
}

repo_violations contains v if {
	some leak in object.get(input, ["gitleaks", "findings"], [])
	v := {
		"code": "SECRET_DETECTED",
		"file": object.get(leak, "File", missing),
		"rule": object.get(leak, "RuleID", missing),
		"message": sprintf("Secret detected in %v (rule %v). Denying.", [object.get(leak, "File", missing), object.get(leak, "RuleID", missing)]),
	}
}

# --- Tool pinning ----------------------------------------------------------
# These binaries run in the same job as the signing key. Before tools.lock the
# devcontainer CLI, syft, grype and OPA all came from mutable refs.

repo_violations contains v if {
	not is_object(object.get(input, ["tools"], null))
	v := {"code": "TOOLS_LOCK_MISSING", "message": "input.tools is missing. tools.lock could not be read. Denying."}
}

repo_violations contains v if {
	some name, version in object.get(input, ["tools"], {})
	not regex.match(`^v?[0-9]+\.[0-9]+\.[0-9]+`, version)
	v := {
		"code": "TOOL_NOT_PINNED",
		"tool": name,
		"message": sprintf("tools.lock pins %v to %q, which is not a concrete version. Denying.", [name, version]),
	}
}

# --- Action pinning --------------------------------------------------------
# Reported by scripts/lint-workflows.sh, decided here.

repo_violations contains v if {
	some ref in object.get(input, ["unpinned_actions"], [])
	v := {
		"code": "ACTION_NOT_PINNED",
		"ref": ref,
		"message": sprintf("%v is not pinned to a full commit SHA. A movable ref is code execution in CI. Denying.", [ref]),
	}
}
