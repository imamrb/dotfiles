---
name: mr-review
description: Pre-submission self-review checklist — catches what reviewers historically flag on your MRs before they get a chance to
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: gitlab-mr
---

- Use glab skill to fetch MRs
- Run RuboCop and fix any reported issues
- Check if any branch is uncovered by tests for if / unless / &.
- Output the review feedbacks in git diff style
- Make sure the MR is not unnecessarilty disabling rubocop violations when they can be addressed

- Migration styleguide

If there is a migration file introduced, fetch the following url and review against the gitlab migration style guide:
https://docs.gitlab.com/development/migration_style_guide/


- Testing Best Practices

If the MR is big(containing change across many files), fetch the following url and review against the gitlab test style guide:
https://docs.gitlab.com/development/testing_guide/best_practices/

