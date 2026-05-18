# GitLab Project Guidelines

Read @.ai/README.md

## Hard Gates (check FIRST, every task)

1. **Read/write scope**: this directory only — ask permission to go outside
2. **Large repo**: always use targeted searches; never scan broadly
3. **Running Specs**: Do not spawn multiple subagents to run tests, follow the testing instructions given
4. **Fetching GitLab Urls**: Use `glab` skill
5. **Blocker**: When communicating with `gitlab.com`, only do read operations; for any write operations explicitly ask for permission!
6. **Plans**: Write generated plans in `$PWD/tmp/` directory
7. **Sensitive ops**: When doing write operations outside working directory, must ask explicit permission!

## LSP — Use for Navigation and Validation

| Task | Tool | When |
|------|------|------|
| Jump to class/method definition | `lsp_goto_definition` | You see a symbol and want its source |
| Safe rename across workspace | `lsp_rename` | Renaming any symbol — never do this with sed |
| Validate edits before marking done | `lsp_diagnostics` | After EVERY file edit, before marking todo complete |
| Check rename is valid | `lsp_prepare_rename` | Always run before `lsp_rename` |

## Search Tool Hierarchy

**Use native tools over Bash** — no subprocess overhead, no permission checks, faster.

| Task | Tool | Notes |
|------|------|-------|
| Symbol definition | `lsp_goto_definition` | Always try first |
| Find files by name/pattern | Preferred `fd` in Bash | |
| Search file contents | Preferred  `rg` in Bash | |
| Broad multi-angle exploration | `explore` subagent | Not repeated Grep calls |
| Codebase symbol/file analysis | `gkg_search_codebase`, `gkg_analyze_code_files` | Use when GKG MCP is available |
| Symbol impact analysis | `gkg_get_symbol_references` | Before renaming or deleting a symbol |
| Git-tracked files only | `Bash: rtk git grep` | When Grep tool insufficient |
| Recently modified files | `Bash: rtk fd --changed-within` | No native equivalent |

```bash
# ALWAYS use rtk wrappers (60-90% token savings)
rtk rg "pattern" app/models/
rtk git grep "pattern"
rtk fd "user.*spec" spec/
rtk fd --changed-within 1d
```

## Build, Lint, and Test Commands

### Ruby/RSpec

Load the `gitlab-rspec` skill for full commands, patterns, undercoverage workflow, and GitLab-specific conventions.

### Database

- Three database schemas: `main`, `ci`, `sec` — use the schema relevant to the table
- Example: `bin/rails db:migrate:up:main`
- Only commit relevant changes from `db/structure.sql`
- Alert of any missing database indexes required for the query

```bash
bin/rails db:migrate
scripts/validate_schema_changes
```

## Code Style Guidelines

### Ruby

- **Frozen string literal**: Required at top of every file: `# frozen_string_literal: true`
- **Line length**: 120 characters max (RuboCop enforced)

### Commits

- Subject: 72 chars max, imperative mood, capital first letter, no period
- Body: Required if 30+ lines changed across 3+ files; explain "why" not "what"
- References: Use full URLs (`https://gitlab.com/gitlab-org/gitlab/-/issues/123`)

### Branch Naming

- `<issue-number>-<description>` for issue-linked changes
- `<issue-number>-fix-<description>` for bug fixes
- `docs/<description>` or `docs-<description>` for docs-only (triggers faster CI)

## Project Structure

| Path | Contents |
|------|----------|
| `app/` | Rails application code (CE) |
| `ee/app/` | Enterprise Edition code — CE must NOT reference this |
| `lib/` | Shared libraries |
| `spec/` | RSpec tests (CE) |
| `ee/spec/` | RSpec tests (EE) |
| `spec/frontend/` | Jest tests |
| `db/migrate/` | Schema migrations |
| `db/post_migrate/` | Post-deployment data migrations |
| `config/feature_flags/` | Feature flag definitions |
| `.gitlab/ci/` | CI/CD configuration (~58 YAML files) |

## Important Patterns

### Testing

- Use `gitlab-rspec` skill for rspec tests

### Database

- **Always check for existing indexes** before adding new ones
- **Use `each_batch`** for large data operations
- **Migrations**: schema changes → `db/migrate/`, data migrations → `db/post_migrate/`
- **Background migrations**: required for tables >1M rows
- **Multi-database**: check parent class — `ApplicationRecord` (main) vs `Ci::ApplicationRecord` (ci)

### EE vs CE

- New CE code → `app/`, `lib/`, `spec/`
- New EE-only code → `ee/app/`, `ee/lib/`, `ee/spec/`
- CE code must NEVER `require` or reference `ee/` paths

### Feature Flags

- Define in `config/feature_flags/` with proper YAML metadata
- Check order: fail-fast before expensive operations
- Never use dynamic flag names

### Workers

- Register in `config/sidekiq_queues.yml` or `ee/app/workers/all_queues.yml`

## Pre-push Checks (lefthook)

Run `lefthook run pre-push` to execute all checks manually. Checks include:
RuboCop · ESLint · Prettier · HAML-lint · DB schema validation · GraphQL docs sync · Secrets detection

## CI/CD Notes

- Default branch: `master`
- Danger bot comments are often non-blocking warnings

## Common Gotchas

| Gotcha | What to do |
|--------|-----------|
| EE vs CE confusion | Check file path — `ee/` = EE only |
| Wrong database model | Check parent class: `ApplicationRecord` vs `Ci::ApplicationRecord` |
| Bounded context violation | Follow domain boundaries in `app/` — don't reach across domains |
| Migration in wrong dir | Schema → `db/migrate/`, data → `db/post_migrate/` |

## GDK

- Local URL: http://gdk.test:3000
- Use API over browser automation when possible

```bash
curl -s -H "PRIVATE-TOKEN: $(cat ~/.gdk_token)" \
  "http://gdk.test:3000/api/v4/projects/PROJECT_ID"
```

## Token Optimization

```bash
# Git — ALWAYS use rtk (60-90% token savings)
rtk git status
rtk git diff
rtk git log --oneline -10
rtk git branch -a
```

- `--format progress` over `--format documentation` for spec runs
- `--name-only` when only file list is needed
