---
name: mr-description
description: Generate GitLab MR descriptions matching the project's writing conventions — includes database queries, background context, series references, and validation steps
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: gitlab-mr
---

# MR Description Generator

Generate a GitLab MR description that matches the established writing conventions
for this project. The output should be indistinguishable from a senior engineer's
hand-written description.

## Workflow

### 1. Gather Context (parallel)

Run these in parallel before writing anything:

```bash
# Current branch and linked issue number
git branch --show-current
# Extract issue number from branch name (e.g. 593892-fix-foo → #593892)

# Fetch the issue details for context

# MR template baseline
cat .gitlab/merge_request_templates/Default.md
```

Also check:
- DB migrations? → `fd . db/migrate db/post_migrate --changed-within 7d`
- New workers? → `rg "class.*Worker" --type rb -l` on changed files
- Feature flags introduced? → `rg "Feature\.(enable|disable|flag)" --type rb` on changed files

### 2. Classify the MR Type

Determine which sections to include:

| Signal | Section to add |
| --- | --- |
| New database queries| `## Database Queries` |
| Non-obvious system being changed | `## Background` |
| Feature flag introduced or used | Feature flag enable step first in validation |
| Security policy involved (most common) | Full policy YAML in validation steps |

### 3. Write the Description

Follow these conventions **exactly**:

Focus on testing from UI if possible, if not fallback to console for backend specifics

#### `## What does this MR do and why?`
- **Line 1**: One-sentence summary of the change (present tense, active voice)
- **Paragraph 2**: The problem that existed before — what was wrong/missing/too aggressive
- Use **bold** for key concepts: `**pre-existing**`, `**only when**`, `**both with and without**`
- Link to specific code with relative paths: `[PurgeWorker](./ee/app/workers/security/finding_enrichments/purge_worker.rb)`
- Link to specific lines with anchors: `[stale](../ee/app/services/.../purge_service.rb#L16)`


#### `## Background` (include when system is non-obvious)
- Plain-English explanation of what the affected records/workers/services do
- Describe existing behavior and why it's problematic
- Link to code with relative paths and line anchors

#### `## References`
- Always: `Issue: https://gitlab.com/gitlab-org/gitlab/-/work_items/<NUMBER>` or `https://gitlab.com/gitlab-org/gitlab/-/issues/<NUMBER>`
- If part of a series:
  ```markdown
  This MR is part of a series of related merge requests to implement #ISSUE:
  - [First MR title](url)
  - 👉 [This MR title](url)
  - [Next MR title](url)
  ```
  The 👉 arrow marks the current MR.

#### `## Database Queries` (include when DB is touched)

Structure each query as:

**<Label>**: `:<scope_name>` or **<Operation>:**

```sql
SELECT ...
```

Plan: instruct to generate plan from https://console.postgres.ai and paste the link , or skip for now in the option

Rules:
- Label = bold description of what the query does (e.g., `**scope**: :stale`, `**Upsert:**`, `**Delete (per batch):**`)
- SQL = the actual query extracted from the migration or service file — never pseudocode
- Always include a postgres.ai explain plan link for production
- If prod data unavailable: use `https://explain.depesz.com/s/<hash>` with note: `(can't get plan from prod as we don't have the <column> yet in prod)`
- Multiple queries = multiple labeled subsections

#### `## How to set up and validate locally`

Numbered steps using `1.` (not `-`). Every step must be copy-pasteable — no placeholders.

**Key conventions:**
- Feature flag syntax: `bin/rails runner "Feature.enable(:flag_name)"` — NOT a rails console block
- Long policy/CI configs: wrap in `<details><summary>Test Setup</summary>` collapsible
- Each major step ends with `**Observation:**` stating exactly what to verify
- UI navigation uses bold: `Navigate to **Secure > Policies**`, `**Settings > Merge requests**`

---

**Pattern A — Security policy feature (the most common pattern for this domain):**

```markdown
1. Enable the feature flag:
   ```
   bin/rails runner "Feature.enable(:your_flag_name)"
   ```

2. Create a new project.

3. Navigate to **Settings > Merge requests > Merge request approvals** and uncheck all approval setting boxes, then **Save changes**.

4. Navigate to **Settings > Repository > Protected branches** and add `feature/*` as a protected branch.

5. Navigate to **Secure > Policies** and create the following **Merge request approval policy**:

<details>
<summary>Test Setup</summary>

**.gitlab/security-policies/policy.yml**
```yaml
approval_policy:
- name: My Policy
  description: ''
  enabled: true
  enforcement_type: enforce
  rules:
  - type: scan_finding
    scanners:
    - secret_detection
    vulnerabilities_allowed: 0
    severity_levels: []
    vulnerability_states: []
    branch_type: protected
  actions:
  - type: require_approval
    approvals_required: 1
    role_approvers:
    - owner
  - type: send_bot_message
    enabled: true
  approval_settings:
    block_branch_modification: false
    prevent_pushing_and_force_pushing: false
    prevent_approval_by_author: true
    prevent_approval_by_commit_author: false
    remove_approvals_with_new_commit: false
    require_password_to_approve: false
  fallback_behavior:
    fail: open
```

**.gitlab-ci.yml**

```yaml
image: busybox:latest
include:
  - template: 'Jobs/Secret-Detection.gitlab-ci.yml'
  # - template: 'Jobs/SAST.gitlab-ci.yml'
  # - template: 'Jobs/Dependency-Scanning.gitlab-ci.yml'
```

</details>


6. Create an MR targeting the default branch with the following file:

**env.sample**
```env
AWS_TOKEN=AKIAZYONPI3G4JNCCWGQ
```

**Observation:** The policy bot comment appears and the approval widget shows the policy requires 1 approval.

7. Change the MR target branch to `feature/test-branch`.

**Observation:** [describe expected change in policy behavior]

8. Change the target branch back to `main`.

**Observation:** [describe what reverts / what stays]
```
```

---

**Pattern B — Backend-only, rails console validation:**

```markdown
1. In rails console, create the necessary test data:
   ```ruby
   project = Project.find(<id>)
   enrichment = Security::FindingEnrichment.create!(
     project: project,
     finding_uuid: SecureRandom.uuid,
     cve: 'CVE-2024-1234'
   )
   ```

2. Run the worker manually:
   ```ruby
   Security::FindingEnrichments::PurgeWorker.new.perform
   ```

3. Verify the enrichment was NOT deleted:
   ```ruby
   Security::FindingEnrichment.find(enrichment.id)
   # should not raise ActiveRecord::RecordNotFound
   ```
```
```
---
**Pattern C — Flaky spec fix (seed-based reproduction):**

```markdown
1. Reproduce the failure on master:
   ```bash
   git checkout master
   bin/rspec path/to/spec_spec.rb --seed XXXXX
   ```

   <details>
   <summary>Expected failure output</summary>

   ```
   1) ClassName#method context description
      Failure/Error: expect { ... }.to change { ... }.by(1)
      expected `Model.count` to have changed by 1, but was changed by 0
   ```
   </details>

2. Verify the fix on your branch:
   ```bash
   bin/rspec path/to/spec_spec.rb --seed XXXXX
   # All examples should pass
   ```
```
```
---

Combine patterns when multiple apply (e.g., migration + feature flag + policy YAML).

#### `## Side effects` (include when behavior changes)
- Explicitly name unintended consequences
- Link to discussions where the side effect was acknowledged
- Explain why the new behavior is correct

#### `## MR acceptance checklist`

Always include verbatim:

```markdown
## MR acceptance checklist

Evaluate this MR against the [MR acceptance checklist](https://docs.gitlab.com/development/code_review/#acceptance-checklist).
It helps you analyze changes to reduce risks in quality, performance, reliability, security, and maintainability.
```

### 4. Policy YAML Generation

When the MR involves security policy behavior, generate realistic policy YAML for validation steps.

- Policy YAML must be valid according to the schema — use gitlab-security-policies SKILL as reference for field names and values


**Key schema facts (do not invent values outside these):**

`approval_policy` top-level fields:
- `name` (string, required)
- `description` (string)
- `enabled` (boolean)
- `enforcement_type`: `enforce` (default) | `warn`
- `fallback_behavior.fail`: `open` | `closed`
- `rules[]`: array of rule objects
- `actions[]`: array of action objects
- `approval_settings`: object with boolean fields
- `policy_scope`: for targeting specific projects/groups

`approval_settings` boolean fields:
`prevent_approval_by_author`, `prevent_approval_by_commit_author`,
`remove_approvals_with_new_commit`, `require_password_to_approve`,
`block_branch_modification`, `prevent_pushing_and_force_pushing`,
`prevent_editing_approval_rules`, `block_group_branch_modification`

**Common rule patterns:**
```yaml
# Scan finding rule — branch type
- type: scan_finding
  scanners: [secret_detection]   # or: sast, dast, dependency_scanning, container_scanning
  vulnerabilities_allowed: 0
  severity_levels: []            # or: [critical, high, medium, low, info, unknown]
  vulnerability_states: []       # or: [detected, confirmed, resolved, dismissed]
  branch_type: protected         # or: default

# Scan finding rule — branch name pattern
- type: scan_finding
  scanners: [sast]
  vulnerabilities_allowed: 0
  severity_levels: []
  vulnerability_states: []
  branches:
  - feature/*

# Any MR rule
- type: any_merge_request
  commits: any                   # or: unsigned
  branch_type: protected         # or use branches: [pattern]
```

**Common action patterns:**
```yaml
- type: require_approval
  approvals_required: 1
  role_approvers:
  - owner                        # or: developer, maintainer, guest, reporter

- type: send_bot_message
  enabled: true
```

**Standard test files for triggering scanners:**

Secret detection:
```env
# env.sample
AWS_TOKEN=AKIAZYONPI3G4JNCCWGQ
```

SAST (code injection):
```ruby
# test.rb
job = params[:job]
eval(job)
```

**Standard CI YAML for MR pipelines with scanners:**

```yaml
image: busybox:latest
include:
  - template: 'Jobs/Secret-Detection.gitlab-ci.yml'
  - template: 'Jobs/SAST.gitlab-ci.yml'
```

### 5. Output Format

Output the description as a raw markdown block ready to copy-paste.

After the block, print a one-line summary in markdown syntax ready for copy-pasting, prefixed with `**MR Title:** `.

Write the MR description to a file name `mr_description-${title}.md` in the `$PWD/tmp` directory

```
Sections included: What/why · Background · References (series: N) · DB Queries (N) · Validation (Pattern X+Y) · Checklist
```

## Agent Guidelines

1. **Read the diff first** — base every claim on actual changed files, never memory
2. **Extract real SQL** — find the actual query in the service/migration file
3. **Fetch sibling MRs** — check for related open MRs by issue number in branch name
4. **Feature flag syntax** — always `bin/rails runner "Feature.enable(:flag)"`, not a rails console block
5. **Observation assertions** — end each major validation step with `**Observation:**` + what to verify
6. **Collapsible configs** — wrap long policy YAML or CI YAML in `<details><summary>Test Setup</summary>`
7. **Policy YAML** — fetch the schema URL above; use only valid field names and enum values
8. **Match the voice** — present tense, active, direct. No passive constructions
9. **Bold sparingly** — only for genuinely key concepts
10. **Relative code links** — `./path/to/file.rb` for this repo, full URLs for specific lines/commits
11. **No placeholder text** — every section must have real content or be omitted entirely
12. **Postgres.ai links** — if no real URL, write `[explain plan pending — add before review]`
