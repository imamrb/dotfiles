---
name: gitlab-rspec
description: Writing, running, and debugging RSpec specs in the GitLab monorepo — commands, patterns, undercoverage, system specs, and GitLab-specific conventions
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: testing
---

# GitLab RSpec Skill

Generic RSpec patterns and GitLab-specific conventions for writing, running, and debugging specs in the GitLab monorepo:

- Optimize running specs with `rspec-diff` and `--format progress` to minimize feedback loop
- Finalize implementation before writing specs — avoid spec churn from changing requirements
- Use table-driven specs (`where`/`with_them`) for 3+ cases with identical structure
- Use shared examples for repeated expectation bodies across contexts
- Avoid writing unnecessary specs, eg: when covered by previous examples, no need to test negative cases again
- Feature flags are enabled by default in specs — stub them to test disabled behavior
- Make sure the rubocop suite is clean before marking work done

## Running Specs

```bash
# Only changed specs (preferred when iterating on a feature)
rtk zsh -i -c "rspec-diff | xargs -r bin/rspec"

# Multiple specs in ONE command — never run them individually (startup cost is high)
rtk bin/rspec spec1.rb:L1:L2 spec2.rb:L1:L2 spec3.rb:L1:L2 --format progress

# Specific line
rtk bin/rspec spec/models/user_spec.rb:42

# Fallback when bin/rspec fails (Ci::JobFactoryHelpers / module not found errors)
rtk bundle exec rspec spec/path/to_spec.rb:15
```

**Decision table:**

| Situation | Command |
|-----------|---------|
| Working on a feature | `zsh -i -c "rspec-diff \| xargs -r bin/rspec"` |
| Specific file/line changed | `bin/rspec file_spec.rb:LINE` |
| Multiple files changed | `bin/rspec spec1.rb spec2.rb --format progress` |
| `bin/rspec` fails with Ci::* module not found | `bundle exec rspec ...` |

**Pre-existing failures**: note them and move on — do NOT fix unrelated failures unless asked.

Always use `--format progress` (dots) over `--format documentation` for large suites — far less output, faster to scan.

---

## EE vs CE spec placement

| Code location | Spec location |
|---------------|---------------|
| `app/` | `spec/` |
| `ee/app/` | `ee/spec/` |
| `lib/` | `spec/lib/` |
| `ee/lib/` | `ee/spec/lib/` |

CE specs must never reference `ee/` paths.

---

## Core GitLab Patterns

### `let_it_be` vs `let!`

Always prefer `let_it_be` (or `let_it_be_with_reload`) over `let!` for DB-backed records. It wraps creation in a transaction rolled back once per example group rather than per example — significantly faster for large suites.

```ruby
# ✅ Preferred — one DB insert per describe block
let_it_be(:project) { create(:project) }
let_it_be_with_reload(:user) { create(:user) }  # use when the record gets mutated in examples

# ❌ Avoid — one DB insert per example
let!(:project) { create(:project) }
```

Use `let_it_be_with_reload` when an example modifies the record and you need a fresh DB read for the next example.

### Factories over mocks

Prefer real objects built with factories. GitLab factories set up proper associations and avoid brittle stub chains.

```ruby
# ✅ Real object — associations work, no stub chain fragility
let(:policy) { build(:approval_policy, name: 'my-policy') }

# ❌ Fragile — breaks when internals change
let(:policy) { instance_double(ApprovalPolicy, name: 'my-policy', rules: double(...)) }
```

Use `build` (no DB) when you don't need persistence. Use `create` only when DB-backed associations are required.

### Shared examples

Check for existing shared examples before creating new ones — the repo has hundreds. Search first:

```bash
rg "shared_examples.*'your pattern'" spec/support/shared_examples/
rg "shared_examples.*'your pattern'" ee/spec/support/shared_examples/
```

Extract repeated assertion bodies into `shared_examples` when the same expectations appear in 2+ contexts:

```ruby
shared_examples 'does not track any feature usage events' do
  it 'does not track enrichment_filter_used' do
    expect(Gitlab::InternalEvents).not_to have_received(:track_event)
      .with('enrichment_filter_used', anything)
  end
end

# Usage — no duplication across contexts
include_examples 'does not track any feature usage events'
```


### Table-driven specs with `where`/`with_them`

Use `where`/`with_them` (from `rspec-parameterized`) for any spec with 3+ structurally identical cases:

```ruby
where(:input, :expected) do
  ['foo',  true],
  ['bar',  false],
  [nil,    false]
end

with_them do
  it { expect(subject.valid?(input)).to eq(expected) }
end
```

When reviewing a `where` table, verify:
- All meaningful branches of the implementation are covered (not just happy path)
- Boundary values are present (nil, empty string, edge inputs)
- Negative cases exist for each positive pattern
- Redundant rows (identical normalization path) are removed


### Licensed features

```ruby
before do
  stub_licensed_features(
    security_orchestration_policies: true,
    sast: true
  )
end
```

## Undercoverage

Make sure to cover all branches of the code under test.

```
ee/app/services/foo/bar_service.rb
  branches: 3/4 (line 140)
  coverage: 0.0% (lines 166-168)
```

- **branches N/M**: N of M branches covered. Find the uncovered branch.
- **coverage 0.0%**: the entire method/block has zero coverage — no spec exercises it at all.


## RuboCop

```bash
# Changed files only (fast)
rtk zsh -i -c "rbc -A"

# Specific file
rtk bundle exec rubocop --parallel path/to/file.rb
```

Always run RuboCop after editing Ruby files. Fix all reported offenses before marking work done.
