---
name: verify-after-change
description: >-
  Run appropriate checks after edits to catch regressions before handing work back.
  Use after non-trivial code changes or when tests and linters exist in the repo.
---

# Verify after change

## When to use

- You modified logic, types, or dependencies that could break callers
- The project has automated tests, linters, or formatters configured
- The user cares about CI green or you are unsure about edge cases

## Steps

1. Identify which package or app owns the files you changed.
2. Run the narrowest meaningful check first (unit tests or lint for that scope).
3. If failures appear, read the error output and fix root causes before retrying broadly.
4. When types or APIs shifted, search for other references that need the same update.
5. For user-visible behavior, sanity-check the main path manually if no test covers it.
6. Stop when checks pass or when a failure clearly needs product input rather than guessing.
