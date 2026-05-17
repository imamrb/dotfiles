---
name: ripgrep
description: Fast content search with rg (ripgrep) — correct flags, regex engine, ignore behavior, type filtering, and common misuse patterns to avoid
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: search
---

# ripgrep (rg) Skill

`rg` searches **file contents** using regex. It is Rust-based, respects `.gitignore` automatically, and is parallel by default. Use it instead of `grep`.

---

## Mental Model

| Question | Answer |
|----------|--------|
| What does rg search? | File **contents** (not names — use `fd` for names) |
| Default pattern type | **Regex** (Rust `regex` crate — no lookahead/backrefs) |
| Files skipped by default | Hidden files, `.gitignore` matches, binary files |
| How to search everything | `-uuu` (unrestricted × 3) |

---

## Core Flags (Daily Use)

### Pattern Control
```bash
rg "pattern"              # regex search (default)
rg -F "literal.string"    # fixed string — no regex parsing (use for dots, brackets, etc.)
rg -e "pat1" -e "pat2"    # multiple patterns (OR)
rg -f patterns.txt        # patterns from file (one per line)
rg -P "(?<=foo)bar"       # PCRE2 — enables lookahead/lookbehind/backreferences
```

### Case
```bash
rg -i "pattern"           # case-insensitive
rg -s "pattern"           # case-sensitive (explicit)
rg -S "pattern"           # smart-case: insensitive if all lowercase, sensitive if mixed
```

### Output Shape
```bash
rg -l "pattern"           # list matching files only (no content)
rg -c "pattern"           # count matching lines per file
rg -n "pattern"           # show line numbers (default when TTY)
rg -N "pattern"           # suppress line numbers
rg -o "pattern"           # print only the matching part
rg -C 3 "pattern"         # 3 lines context (before + after)
rg -A 2 -B 1 "pattern"   # 2 after, 1 before
rg --json "pattern"       # JSON output (great for scripting/tooling)
```

### Scope Control
```bash
rg "pattern" src/         # search in directory
rg "pattern" file.rb      # search single file
rg --hidden "pattern"     # include hidden files/dirs (dotfiles)
rg -L "pattern"           # follow symlinks
rg -d 2 "pattern"         # max depth 2
rg --max-filesize 1M "p"  # skip files larger than 1MB
rg -j 4 "pattern"         # use 4 threads
```

### File Type Filtering
```bash
rg -t ruby "pattern"      # only Ruby files
rg -T ruby "pattern"      # exclude Ruby files
rg --type-list            # list all built-in types
rg --type-add 'haml:*.haml' -t haml "pattern"  # custom type (current invocation only)
rg -g "*.rb" "pattern"    # glob include
rg -g "!*.min.js" "p"     # glob exclude (! prefix)
```

---

## Ignore / Visibility Behavior

ripgrep skips by default (in precedence order):
1. `.rgignore` (highest priority)
2. `.ignore`
3. `.gitignore` (including global git config + parent dirs)
4. Hidden files/dirs
5. Binary files (NUL-byte heuristic)

**When rg "misses" something:**
```bash
rg --hidden "pattern"     # include dotfiles
rg --no-ignore "pattern"  # disable all ignore files
rg -u "pattern"           # = --no-ignore
rg -uu "pattern"          # = --no-ignore --hidden
rg -uuu "pattern"         # = --no-ignore --hidden --binary (search everything)
rg -a "pattern"           # treat binary as text (risky — can produce garbage output)
```

---

## Regex Engine: Default vs PCRE2

| Feature | Default (Rust regex) | PCRE2 (`-P`) |
|---------|---------------------|--------------|
| Lookahead/lookbehind | ❌ | ✅ |
| Backreferences | ❌ | ✅ |
| Speed | Faster (linear time) | Slower |
| Unicode | Full | Full |

**Rule**: Use default engine unless you specifically need lookahead/backrefs. PCRE2 can be significantly slower on large codebases.

```bash
rg -P "(?<=def )(\w+)"   # PCRE2 lookbehind — find method names after "def"
rg --engine auto "pat"   # auto-selects PCRE2 only if pattern requires it
```

---

## Config File

ripgrep does **not** auto-discover config. You must set the env var:

```bash
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/rc"
```

Format — one flag per line, `#` comments:
```
# ~/.config/ripgrep/rc
--smart-case
--hidden
--type-add=haml:*.haml
```

CLI flags always override config. Disable config: `rg --no-config "pattern"`.

---

## Common Misuse Patterns (AVOID)

### ❌ Using grep instead of rg
```bash
# WRONG
grep -r "pattern" app/
# CORRECT
rg "pattern" app/
```

### ❌ Forgetting -F for literal strings with special chars
```bash
# WRONG — dots match any char, brackets are char classes
rg "user.rb" src/
rg "arr[0]" src/
# CORRECT
rg -F "user.rb" src/
rg -F "arr[0]" src/
```

### ❌ Expecting lookahead/lookbehind without -P
```bash
# WRONG — default engine has no lookahead
rg "(?<=def )\w+" src/
# CORRECT
rg -P "(?<=def )\w+" src/
```

### ❌ Searching hidden/ignored files without flags
```bash
# WRONG — .env, .git, node_modules etc. are skipped silently
rg "SECRET" .
# CORRECT (if you need hidden files)
rg --hidden "SECRET" .
# CORRECT (if you need ignored dirs too)
rg -uu "SECRET" .
```

### ❌ Using --type-add expecting it to persist
```bash
# WRONG — --type-add only applies to current invocation
rg --type-add 'haml:*.haml' -t haml "pattern"  # works now
rg -t haml "pattern"  # FAILS next time — type not defined
# CORRECT — put --type-add in config file or alias
```

### ❌ Piping rg output and expecting consistent ordering
```bash
# WRONG — parallel search = non-deterministic order
rg -l "pattern" | head -1  # may return different file each time
# CORRECT — sort for determinism (disables parallelism)
rg --sort path -l "pattern" | head -1
```

### ❌ Using -c to count total matches (it counts lines)
```bash
# WRONG — -c counts matching LINES, not total matches
rg -c "pattern"
# CORRECT — count every match occurrence
rg --count-matches "pattern"
```

---

## Practical Recipes (GitLab Codebase)

```bash
# Find Ruby method definitions
rg "def (self\.)?authenticate" app/

# Find all usages of a constant
rg -w "UserPolicy" app/ spec/

# Search only Ruby files, show file list
rg -t ruby -l "has_many :projects"

# Find TODO/FIXME comments in non-test code
rg -t ruby -g "!spec/" "# (TODO|FIXME)"

# Search across ignored vendor/node_modules
rg -uu "lodash" --type js

# Find all files importing a specific module
rg "require.*auth_helper" -t ruby -l

# Multi-pattern OR search
rg -e "class.*Controller" -e "module.*Controller" app/controllers/

# Replace preview (no actual replace — rg doesn't modify files)
rg "old_method" --replace "new_method" src/  # prints substituted output only
```

---

## Performance Tips

1. **Narrow the path** — always pass a directory, not `.` when possible
2. **Use `-t` type filters** before broad patterns
3. **Avoid `-P` (PCRE2)** unless you need it — measurably slower on large repos
4. **Avoid `--pre`** (runs a process per file) — use `--pre-glob` to limit scope if needed
5. **Avoid `--sort`** for large searches — it disables parallelism
6. **`-l` (files only)** is faster than full content output when you just need file paths
