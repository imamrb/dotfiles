---
name: gitlab-pipeline-investigate
description: Extract and analyze all failures from the most recent GitLab pipeline
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: gitlab-ci
---

# Pipeline Failure Extraction Skill

Extract all failures from the most recent pipeline, deduplicate errors, and analyze whether failures are related to each other.

## Workflow

### 1. Get Most Recent Pipeline

```bash
# Get MR details and find the most recent pipeline:
# - GitLab-Production_get_merge_request
# - GitLab-Production_get_merge_request_pipelines
# - Select the first pipeline (most recent)
# - GitLab-Production_get_pipeline_jobs (per_page=100) for the latest pipeline
```

### 2. Extract All Failed Jobs

**CRITICAL**: For ALL failed jobs in the most recent pipeline:

```bash
# For each failed job, fetch the complete trace:
glab ci trace <job-id> -R <org>/<project>

# Focus on last 300 lines where errors typically appear:
glab ci trace <job-id> -R <org>/<project> | tail -300
```

**What to extract**:
- Complete error messages and exception types
- Full stack traces with file paths and line numbers
- Test descriptions and failure contexts
- Coverage gaps and uncovered files
- Service/infrastructure errors (DB, ES, Redis, timeouts)
- Job name, ID, and failure reason

### 3. Deduplicate Failures

**Deduplication strategy**:
- Group failures by error signature (exception type + error message)
- Identify identical stack traces across different jobs
- Merge similar errors with slight variations (e.g., different line numbers in same test)
- Track which jobs had each unique failure

**Unique failure keys**:
- Exception type (e.g., `RSpec::Expectations::ExpectationNotMetError`)
- Core error message (normalize dynamic values like IDs, timestamps)
- File path and approximate location
- Test name/description

### 4. Analyze Failure Relationships

For each unique failure, determine if it's related to other failures:

**Related failure indicators**:
- Same root cause (e.g., service unavailable affecting multiple tests)
- Cascading failures (setup failure causing multiple test failures)
- Same file/module affected
- Same infrastructure issue (timeout, connection errors)

**Unrelated failure indicators**:
- Different services/components
- Different error types with no common ancestor
- Different stages of pipeline (build vs test vs deploy)
- Independent test suites

**Report format**:

```markdown
## Most Recent Pipeline Failures

**Pipeline**: #<id> | **Status**: failed | **Date**: YYYY-MM-DD HH:MM
**Total Failed Jobs**: X | **Unique Failures**: Y

---

### Unique Failure `#1`: RSpec expectation not met in runner details

**Jobs affected**: 3 (rspec-ee system 8/16, rspec-ee system 12/16, rspec-ee system 14/16)

**Related to other failures**: No - isolated test failure

**Stack Trace**:
```
Failures:
  1) Feature: Admin Runners - shows runner details
     Failure/Error: expect(page).to have_content('runner-123')
     Expected to find text "runner-123" but did not
     # ./ee/spec/features/admin/admin_runners_spec.rb:45:in `block (3 levels) in <top (required)>'
```

**Files involved**: 
- ee/spec/features/admin/admin_runners_spec.rb:45

---

### Unique Failure `#2`: Elasticsearch connection timeout

**Jobs affected**: 5 (rspec-ee system 3/16, rspec-ee system 7/16, rspec integration 2/8, jest-ee, karma)

**Related to other failures**: Yes - likely infrastructure issue affecting multiple suites

**Stack Trace**:
```
Elasticsearch::Transport::Transport::Errors::RequestTimeout: 
  [503] {"error":"Timeout waiting for Elasticsearch"}
     # ./lib/gitlab/elastic/client.rb:78:in `search'
     # ./ee/app/services/search/elastic_service.rb:23:in `execute'
     # ./ee/spec/services/search/elastic_service_spec.rb:120
```

**Files involved**:
- lib/gitlab/elastic/client.rb:78
- ee/app/services/search/elastic_service.rb:23
- Multiple test files across different suites

---

### Unique Failure `#3`: Coverage below threshold

**Jobs affected**: 1 (rspec:undercoverage)

**Related to other failures**: No - coverage-specific issue

**Stack Trace**:
```
Coverage report:
Expected: 85.2% | Got: 84.9%

Uncovered files:
- lib/gitlab/search/zoekt/client.rb (75.0%)
- lib/gitlab/search/zoekt/query_builder.rb (80.0%)
```

**Files involved**:
- lib/gitlab/search/zoekt/client.rb
- lib/gitlab/search/zoekt/query_builder.rb

---

## Failure Relationship Summary

**Related Failure Groups**:
1. Elasticsearch infrastructure (Failures `#2`) - 5 jobs affected
   - Root cause: ES service timeout/unavailability
   - Impact: Multiple test suites unable to execute search tests

**Independent Failures**:
1. Runner details test (Failure `#1`) - 3 jobs affected
2. Coverage gap (Failure `#3`) - 1 job affected

**Recommendation Priority**:
1. 🔴 **Critical**: Fix Elasticsearch infrastructure issue (blocking 5 jobs)
2. 🟡 **Medium**: Investigate runner details test flakiness
3. 🟢 **Low**: Add test coverage for search/zoekt files
```

## Deduplication Examples

**Example 1 - Same failure in different shards**:
```
Job: rspec-ee system 3/16
Error: Failure/Error: expect(page).to have_content('foo')
File: spec/features/projects_spec.rb:100

Job: rspec-ee system 8/16
Error: Failure/Error: expect(page).to have_content('foo')
File: spec/features/projects_spec.rb:100
```
→ **Deduplicate**: Same unique failure, list both jobs

**Example 2 - Different errors (don't deduplicate)**:
```
Job: jest-unit
Error: TypeError: Cannot read property 'length' of undefined
File: app/assets/javascripts/project.js:45

Job: rspec-unit 2/12
Error: NoMethodError: undefined method `size' for nil:NilClass
File: lib/gitlab/project.rb:120
```
→ **Keep separate**: Different error types, different languages

**Example 3 - Related failures (note relationship)**:
```
Job: db:migrate
Error: PG::ConnectionBad: could not connect to server

Job: rspec-unit 1/12
Error: ActiveRecord::StatementInvalid: PG::ConnectionBad
File: spec/models/user_spec.rb:50

Job: rspec-unit 5/12
Error: ActiveRecord::StatementInvalid: PG::ConnectionBad
File: spec/models/project_spec.rb:120
```
→ **Related**: Root cause is DB connection, affecting multiple test files

## Quick Commands

```bash
glab mr view <number> --web                                    # MR overview
glab ci trace <job-id> -R <org>/<project>                     # Full job trace
glab ci trace <job-id> -R <org>/<project> | tail -300        # Last 300 lines
glab ci status -R <org>/<project>                             # Pipeline status
```

## Investigation Checklist

- [ ] Get most recent pipeline for the MR
- [ ] Fetch all failed job details from that pipeline
- [ ] For each failed job: Extract trace with `glab ci trace <job-id>`
- [ ] Parse each trace for error messages, stack traces, and file paths
- [ ] Deduplicate failures by error signature
- [ ] Group jobs by unique failure
- [ ] Analyze relationships between failures
- [ ] Generate structured report with all unique failures
- [ ] Prioritize by impact (number of jobs affected)

## Agent Guidelines

1. **Focus on most recent pipeline only** - not historical analysis
2. Use parallel tool calls when fetching job traces (batch by 5-10)
3. **CRITICAL**: Extract complete stack traces, not just failure_reason
4. Deduplicate aggressively - same error in 10 jobs = 1 unique failure
5. Preserve full context: error message + stack trace + file paths
6. Identify cascading failures from root causes
7. Group related failures explicitly in the report
8. Calculate impact: how many jobs affected by each unique failure
9. Extract at least 200-300 lines from traces to capture full context
10. Present failures in order of impact (most jobs affected first)

## Trace Parsing Patterns

**RSpec failures - extract test name, expectation, file:line**:
```
Failures:
  1) Feature: Admin Runners shows details
     Failure/Error: expect(page).to have_content('runner-123')
     expected to find text "runner-123" in "..."
     # ./spec/features/admin/admin_runners_spec.rb:45:in `block (3 levels)'
```

**JavaScript test failures - extract test name, error, file:line**:
```
FAIL app/assets/javascripts/components/__tests__/app_spec.js
  ● Component › renders correctly
    TypeError: Cannot read property 'map' of undefined
      at Object.<anonymous> (app/assets/javascripts/components/app.vue:23:15)
```

**Coverage failures - extract threshold, actual, uncovered files**:
```
SimpleCov failed with exit code 2
Expected minimum coverage: 85.2%
Actual coverage: 84.9%
Files with low coverage:
  lib/gitlab/search/client.rb: 75.0%
```

**Infrastructure failures - extract service, error type, context**:
```
Errno::ECONNREFUSED: Connection refused - connect(2) for "redis" port 6379
  lib/gitlab/redis/wrapper.rb:45:in `connect'
  
PG::ConnectionBad: FATAL:  sorry, too many clients already
  lib/gitlab/database.rb:120:in `connect'
```
