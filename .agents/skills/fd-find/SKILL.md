---
name: fd-find
description: Fast file name search with fd — correct pattern modes, type filters, ignore behavior, exec patterns, and common misuse to avoid
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: search
---

# fd (fd-find) Skill

`fd` searches **file names** (and paths). It is Rust-based, respects `.gitignore` automatically, and traverses in parallel. Use it instead of `find`.

---

## Mental Model

| Question | Answer |
|----------|--------|
| What does fd search? | File/directory **names** (not contents — use `rg` for contents) |
| Default pattern type | **Regex** against the filename (not full path) |
| Files skipped by default | Hidden files, `.gitignore` matches |
| How to search everything | `-u` or `-HI` |

---

## Core Flags (Daily Use)

### Pattern Modes
```bash
fd "pattern"              # regex against filename (default)
fd -g "*.rb"              # glob pattern (use for extension matching)
fd -F "exact.name"        # fixed string — no regex parsing
fd -p "src/.*spec"        # match against full path (not just basename)
fd -i "pattern"           # case-insensitive (default on case-insensitive FS)
fd -s "Pattern"           # case-sensitive (explicit)
```

### File Type Filters (`-t`)
```bash
fd -t f "pattern"         # files only
fd -t d "pattern"         # directories only
fd -t l "pattern"         # symlinks only
fd -t x "pattern"         # executables only
fd -t e "pattern"         # empty files or directories
fd -t s "pattern"         # sockets
fd -t p "pattern"         # named pipes (FIFOs)
fd -t f -t l "pattern"   # files OR symlinks (combine multiple)
```

**Important semantics:**
- `-t x` (executable) **implies** `-t f` — no need to add `-t f`
- `-t e` (empty) matches both empty files AND empty dirs unless you also pass `-t f` or `-t d`

### Extension Filter
```bash
fd -e rb                  # files with .rb extension
fd -e rb -e rake          # .rb OR .rake (repeatable)
```

### Depth Control
```bash
fd -d 2 "pattern"         # max depth 2
fd --min-depth 2 "pat"    # skip top-level results
fd --exact-depth 3 "pat"  # only at exactly depth 3
```

### Output
```bash
fd -a "pattern"           # absolute paths
fd --format "{//}/{/}"    # custom format: parent dir / basename
fd -0 "pattern"           # NUL-separated output (safe for xargs -0)
```

---

## Hidden Files + Ignore Behavior

fd skips by default:
1. Hidden files/dirs (dotfiles)
2. `.fdignore` (per-directory)
3. `.ignore`
4. `.gitignore` (repo + global git config)

**When fd "misses" something:**
```bash
fd -H "pattern"           # include hidden files (still respects ignore files)
fd -I "pattern"           # disable all ignore files (still skips hidden)
fd -u "pattern"           # = --hidden --no-ignore (search everything)
fd -HI "pattern"          # same as -u (explicit)
fd --no-ignore-vcs "pat"  # disable gitignore but keep .fdignore/.ignore
```

**Custom ignore file:** `~/.config/fd/ignore` (global) or `.fdignore` (per-directory)

---

## Excluding Results
```bash
fd -E "node_modules" "pattern"    # exclude by glob (repeatable)
fd -E "*.min.js" "pattern"        # exclude by extension glob
fd -E ".git" -E "tmp" "pattern"   # multiple exclusions
```

---

## Executing Commands on Results

### `-x` — per file, parallel
```bash
fd -tf -x wc -l           # run wc -l on each file (parallel)
fd -e rb -x rubocop {}    # rubocop on each Ruby file
```

### `-X` — once with all results (batch)
```bash
fd -e rb -X rg "TODO"     # pass all .rb files to rg at once
fd -tf -X wc -l           # wc -l with all files as args
```

### Placeholder syntax
| Placeholder | Meaning |
|-------------|---------|
| `{}` | Full path |
| `{/}` | Basename |
| `{.}` | Path without extension |
| `{/.}` | Basename without extension |
| `{//}` | Parent directory |

```bash
fd -e jpg -x convert {} {.}.png   # convert each jpg to png
fd -tf -x mv {} {//}/archive/     # move each file into archive/ subdir
```

### Ordering caveat
`-x` and `-X` results are **non-deterministic** (parallel traversal). Do not rely on order. For serial execution: `--threads=1`.

---

## Common Misuse Patterns (AVOID)

### ❌ Using find instead of fd
```bash
# WRONG
find . -name "*.rb" -type f
# CORRECT
fd -e rb -t f
```

### ❌ Using regex when you want glob (extension matching)
```bash
# WRONG — regex . matches any char, not just dot
fd ".rb"           # matches "arb", "xrb", etc.
# CORRECT
fd -e rb           # extension filter (no dot needed)
fd -g "*.rb"       # glob (explicit dot)
fd "\.rb$"         # regex with escaped dot and anchor
```

### ❌ Forgetting -p for path-based patterns
```bash
# WRONG — matches only basename "spec"
fd "spec/models"
# CORRECT — match against full path
fd -p "spec/models"
```

### ❌ Expecting -t e to mean only empty files
```bash
# WRONG — -t e matches empty files AND empty dirs
fd -t e
# CORRECT — only empty files
fd -t f -t e
# CORRECT — only empty directories
fd -t d -t e
```

### ❌ Using -x and expecting ordered output
```bash
# WRONG — parallel execution = non-deterministic order
fd -tf -x process_file {}
# CORRECT — serial if order matters
fd -tf --threads=1 -x process_file {}
# OR — collect first, then process in order
fd -tf | sort | xargs -I{} process_file {}
```

### ❌ Searching hidden files without -H
```bash
# WRONG — .env, .git, .cache etc. are silently skipped
fd ".env"
# CORRECT
fd -H ".env"
```

### ❌ Using -X with placeholders (they don't work with -X)
```bash
# WRONG — {} placeholders are for -x only
fd -e rb -X rubocop {}   # {} is passed literally to rubocop
# CORRECT for batch
fd -e rb -X rubocop       # fd appends all paths automatically
# CORRECT for per-file with placeholder
fd -e rb -x rubocop {}
```

### ❌ Passing extension with dot to -e
```bash
# WRONG — -e does not want the dot
fd -e .rb
# CORRECT
fd -e rb
```

### ❌ Expecting -g glob to match path separators without -p
```bash
# WRONG — glob without -p only matches basename
fd -g "spec/models/*.rb"   # matches nothing (no / in basename)
# CORRECT
fd -p -g "spec/models/*.rb"
```

---

## Practical Recipes (GitLab Codebase)

```bash
# Find all Ruby spec files
fd -e rb -t f "spec" spec/

# Find recently modified files (last day)
fd --changed-within 1d -t f

# Find all migration files
fd -t f -e rb . db/migrate/

# Find files matching full path pattern
fd -p "ee/app/models.*policy"

# Find empty directories (for cleanup)
fd -t d -t e

# Find all .yml files excluding vendor
fd -e yml -E vendor/

# Find and delete compiled assets
fd -e js -p "public/assets" -X rm

# Find all files changed in last git commit
fd -t f --changed-within "$(git log -1 --format=%cd --date=iso)"

# Search for a file by partial name (case-insensitive)
fd -i "user_policy"

# Find all executables in bin/
fd -t x . bin/
```

---

## Performance Tips

1. **Always pass a directory** — `fd "pattern" src/` is faster than `fd "pattern" .`
2. **Use `-e` for extension filtering** — faster than regex with `\.ext$`
3. **Use `-E` to exclude large dirs** — `fd -E node_modules -E .git "pattern"`
4. **`-X` (batch) is faster than `-x` (per-file)** when running one command on many files
5. **Traversal is parallel by default** — don't add `--threads=1` unless you need ordering
