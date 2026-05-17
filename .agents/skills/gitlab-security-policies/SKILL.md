---
name: gitlab-security-policies
description: Working with GitLab security policies — reading, writing, gnerating security policies including approval policies, scan execution policies
version: 1.0.0
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: gitlab-security
---

# GitLab Security Policies Skill

Everything needed to read, write, and manage GitLab security policies on a local GDK instance or GitLab.com.

- `ee/app/validators/json_schemas/security_orchestration_policy.json` is the source of truth for `policy.yml` structure and validation rules

- Security policies live in `.gitlab/security-policies/policy.yml` inside a **policy project** (often the project itself). Three policy types exist:


## `approval_policy` Reference

### Rule types

| `type` | Triggers on |
|--------|-------------|
| `scan_finding` | Scanner finds vulnerabilities |
| `license_finding` | License scan detects denied/unknown licenses |
| `any_merge_request` | Any MR (optionally filter by `commits: unsigned`) |

### `scan_finding` — valid `scanners` values
`sast`, `secret_detection`, `dependency_scanning`, `container_scanning`, `coverage_fuzzing`, `dast`

### `vulnerability_states`
`new_needs_triage`, `detected`, `confirmed`, `resolved`, `dismissed`

### `branch_type`
`protected`, `default`, `all`

### `fallback_behavior.fail`
- `closed` — block MR if scan didn't run (strict)
- `open` — allow MR if scan didn't run (lenient)

### Full `scan_finding` example

```yaml
approval_policy:
  - name: MR - SAST
    description: Require approval when SAST finds new vulnerabilities
    enabled: true
    rules:
      - type: scan_finding
        scanners:
          - sast
        vulnerabilities_allowed: 0
        severity_levels: []          # empty = all severities
        vulnerability_states:
          - new_needs_triage
        branch_type: protected
    actions:
      - type: require_approval
        approvals_required: 1
        role_approvers:
          - developer
          - maintainer
          - owner
      - type: send_bot_message
        enabled: true
    approval_settings:
      block_branch_modification: false
      prevent_pushing_and_force_pushing: false
      prevent_approval_by_author: false
      prevent_approval_by_commit_author: false
      remove_approvals_with_new_commit: false
      require_password_to_approve: false
    fallback_behavior:
      fail: closed
```

### `license_finding` example

```yaml
  - name: MR - Copyleft Licenses
    description: Block MRs introducing copyleft licenses
    enabled: true
    rules:
      - type: license_finding
        branch_type: protected
        license_states:
          - newly_detected
          - detected
        match_on_inclusion_license: true
        licenses:
          denied:
            - name: GNU General Public License v2.0
            - name: GNU General Public License v3.0
            - name: GNU Lesser General Public License v2.1
            - name: GNU Lesser General Public License v3.0
            - name: GNU Affero General Public License v3.0
            - name: Mozilla Public License 2.0
            - name: Server Side Public License
    actions:
      - type: require_approval
        approvals_required: 2
        role_approvers:
          - maintainer
          - owner
      - type: send_bot_message
        enabled: true
    approval_settings:
      block_branch_modification: true
      prevent_pushing_and_force_pushing: true
      prevent_approval_by_author: true
      prevent_approval_by_commit_author: true
      remove_approvals_with_new_commit: true
      require_password_to_approve: false
    fallback_behavior:
      fail: closed
```

### `any_merge_request` (unsigned commits) example

```yaml
  - name: MR - Unsigned Commits
    description: Require approval for MRs with unsigned commits
    enabled: true
    rules:
      - type: any_merge_request
        commits: unsigned
        branch_type: protected
    actions:
      - type: require_approval
        approvals_required: 1
        role_approvers:
          - developer
          - maintainer
          - owner
      - type: send_bot_message
        enabled: true
    approval_settings:
      block_branch_modification: true
      prevent_pushing_and_force_pushing: true
      prevent_approval_by_author: true
      prevent_approval_by_commit_author: true
      remove_approvals_with_new_commit: true
      require_password_to_approve: false
    fallback_behavior:
      fail: open
```

---

## `scan_execution_policy` (SEP) Reference

### Rule types

| `type` | Key fields |
|--------|-----------|
| `pipeline` | `branch_type` or `branches`, optional `pipeline_sources` |
| `schedule` | `branch_type` or `branches` or `agents`, `cadence` (cron), optional `timezone` |

**`branch_type` values:** `default`, `protected`, `all`, `target_default`, `target_protected`

**`pipeline_sources.including` values:** `push`, `merge_request_event`, `schedule`, `web`, `api`, `trigger`

### Action `scan` values
`sast`, `secret_detection`, `dependency_scanning`, `container_scanning`, `dast`, `coverage_fuzzing`, `api_fuzzing`

> `sast_iac` = SAST for Infrastructure as Code (Terraform, Helm, CloudFormation, Kubernetes manifests, Ansible). Valid scan value but only useful when IaC files are present.

### Action fields
| Field | Values |
|-------|--------|
| `scan` | scanner name (required) |
| `template` | `default` or `latest` |
| `variables` | key/value CI variables |
| `tags` | runner tag array |
| `site_profile` | DAST site profile name |
| `scanner_profile` | DAST scanner profile name |

### `skip_ci`
`skip_ci.allowed: true` — allows users to skip the policy-enforced scan with `[skip ci]`.

### Pipeline-triggered SEP example

```yaml
scan_execution_policy:
  - name: ''
    description: ''
    enabled: true
    rules:
      - type: pipeline
        branch_type: default
      - type: pipeline
        branch_type: target_default
        pipeline_sources:
          including:
            - merge_request_event
    actions:
      - scan: sast
        variables:
          SECURE_ENABLE_LOCAL_CONFIGURATION: 'false'
        template: latest
      - scan: dependency_scanning
        template: latest
      - scan: container_scanning
        template: latest
      - scan: secret_detection
        variables:
          SECURE_ENABLE_LOCAL_CONFIGURATION: 'false'
        template: latest
    skip_ci:
      allowed: true
```

### Scheduled SEP example

```yaml
  - name: Nightly full scan
    description: Run all scanners nightly on default branch
    enabled: true
    rules:
      - type: schedule
        cadence: '0 2 * * *'
        branch_type: default
    actions:
      - scan: sast
      - scan: secret_detection
      - scan: dependency_scanning
      - scan: container_scanning
```

---

## `pipeline_execution_policy` (PEP) Reference

Injects arbitrary CI config into every pipeline. Use SEP instead when you only need to enforce security scanners.

```yaml
pipeline_execution_policy:
  - name: Enforce CI templates
    description: ''
    enabled: true
    pipeline_config_strategy: inject_policy
    content:
      include:
        - template: Jobs/SAST.gitlab-ci.yml
        - template: Jobs/Secret-Detection.gitlab-ci.yml
```

---

## Sample policy files (`.bundle/scripts/projects/policies/`)

| File | Contents |
|------|---------|
| `pep.yml` | Pipeline execution policy — inject a CI file from another project |
| `pesp_daily.yml` | Pipeline execution schedule policy — daily scheduled pipeline |
| `sep.yml` | Scan execution policy (currently empty — use examples above) |
| `unsigned_commit_on_develop_branch.yml` | `any_merge_request` approval policy for unsigned commits |
| `restricted_license_on_feature_branch.yml` | `license_finding` approval policy for feature branches |
