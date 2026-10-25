#!/usr/bin/env bash
# Lints the files coding agents load, so problems show up in CI instead of in agent behaviour.
#
# Usage: ./scripts/check-agent-context.sh
#   ALLOW_FILL=1 ./scripts/check-agent-context.sh   # report leftover FILL markers as warnings
#
# Exit code 1 if any check fails.

set -uo pipefail
cd "$(dirname "$0")/.." || exit 1

fail=0
warn=0
pass() { printf '  ok    %s\n' "$1"; }
warning() { printf '  WARN  %s\n' "$1"; warn=$((warn + 1)); }
error() { printf '  FAIL  %s\n' "$1"; fail=$((fail + 1)); }

AGENTS_MAX_WARN=150
AGENTS_MAX_FAIL=250
NESTED_MAX_WARN=60

echo "== Instruction files"

if [[ ! -f AGENTS.md ]]; then
  error "AGENTS.md is missing at the repo root"
else
  lines=$(wc -l < AGENTS.md | tr -d ' ')
  if (( lines > AGENTS_MAX_FAIL )); then
    error "AGENTS.md is $lines lines (limit $AGENTS_MAX_FAIL). Move detail into linked docs or skills."
  elif (( lines > AGENTS_MAX_WARN )); then
    warning "AGENTS.md is $lines lines (aim for under $AGENTS_MAX_WARN)."
  else
    pass "AGENTS.md is $lines lines"
  fi
fi

if [[ -L CLAUDE.md ]]; then
  target=$(readlink CLAUDE.md)
  if [[ "$target" == "AGENTS.md" || "$target" == "./AGENTS.md" ]]; then
    warning "CLAUDE.md is a symlink to AGENTS.md. Works, but Windows clones may get a one-line text file; prefer '@AGENTS.md'."
  else
    error "CLAUDE.md is a symlink to '$target', not AGENTS.md"
  fi
elif [[ -f CLAUDE.md ]]; then
  # An import must sit outside code spans/blocks; we look for it at the start of a line.
  if grep -qE '^@AGENTS\.md[[:space:]]*$' CLAUDE.md; then
    pass "CLAUDE.md imports AGENTS.md"
  else
    error "CLAUDE.md exists but does not import AGENTS.md. Claude Code then skips AGENTS.md by default. Add a line: @AGENTS.md"
  fi
  # Every @import in CLAUDE.md must resolve (skip fenced code blocks and backticked text).
  # The backticks in the awk/sed patterns below are literal, not command substitution.
  # shellcheck disable=SC2016
  while IFS= read -r imp; do
    path="${imp#@}"
    [[ "$path" == ~* ]] && continue   # home-directory imports are personal; not checked here
    [[ -e "$path" ]] || error "CLAUDE.md imports '$path', which does not exist"
  done < <(awk '/^```/{f=!f; next} !f' CLAUDE.md | sed 's/`[^`]*`//g' | grep -oE '(^|[[:space:]])@[A-Za-z0-9_./~-]+' | tr -d ' \t')
fi

while IFS= read -r nested; do
  n=$(wc -l < "$nested" | tr -d ' ')
  if (( n > NESTED_MAX_WARN )); then
    warning "$nested is $n lines (nested files should stay short)"
  else
    pass "$nested is $n lines"
  fi
done < <(find . -mindepth 2 -iname 'AGENTS.md' -not -path './node_modules/*' -not -path './.git/*' | sort)

if [[ -d .cursor/rules ]]; then
  while IFS= read -r stray; do
    warning "$stray: Cursor ignores plain .md files in .cursor/rules/ (use .mdc, or move it to AGENTS.md)"
  done < <(find .cursor/rules -type f -name '*.md')
fi

echo "== Links from AGENTS.md"
if [[ -f AGENTS.md ]]; then
  missing_links=0
  while IFS= read -r ref; do
    ref="${ref#./}"
    if [[ ! -e "$ref" ]]; then
      error "AGENTS.md mentions '$ref', which does not exist"
      missing_links=1
    fi
  done < <(grep -oE '(^|[^A-Za-z0-9_<>/.-])([A-Za-z0-9_-]+/)*[A-Za-z0-9_-]+\.md\b|(^|[^A-Za-z0-9_<>/.-])(docs|infra|tests|src|scripts)(/[A-Za-z0-9_-]+)*/' AGENTS.md \
           | sed -E 's/^[^A-Za-z0-9_.]//' | sort -u)
  (( missing_links == 0 )) && pass "every file and folder AGENTS.md mentions exists"
fi

echo "== Placeholders"
fill_files=(AGENTS.md CLAUDE.md GEMINI.md ARCHITECTURE.md DESIGN.md SECURITY.md CONTRIBUTING.md docs/DEPLOY.md)
while IFS= read -r nested; do fill_files+=("${nested#./}"); done < <(find . -mindepth 2 -iname 'AGENTS.md' -not -path './node_modules/*' -not -path './.git/*')
fill_hits=0
for f in "${fill_files[@]}"; do
  [[ -f "$f" ]] || continue
  count=$(grep -c 'FILL' "$f" || true)
  if (( count > 0 )); then
    fill_hits=1
    if [[ "${ALLOW_FILL:-0}" == "1" ]]; then
      warning "$f still has $count FILL marker(s)"
    else
      error "$f still has $count FILL marker(s) — agents will follow placeholders literally"
    fi
  fi
done
(( fill_hits == 0 )) && pass "no FILL markers left"

echo "== Secrets in agent-visible files"
secret_pattern='(ghp_[A-Za-z0-9]{36}|github_pat_[A-Za-z0-9_]{40,}|AKIA[0-9A-Z]{16}|xox[abposr]-[A-Za-z0-9-]{10,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|Bearer [A-Za-z0-9._-]{20,})'
secret_hits=$(grep -rInE "$secret_pattern" \
  --include='*.md' --include='*.mdc' --include='*.json' --include='*.example' \
  --exclude-dir=.git --exclude-dir=node_modules . || true)
if [[ -n "$secret_hits" ]]; then
  error "possible secret(s) found:"
  printf '%s\n' "$secret_hits" | sed 's/^/          /'
else
  pass "no token-like strings in Markdown, rules or MCP config"
fi

echo "== Config files"
json_files=()
for f in .mcp.json .mcp.json.example .claude/settings.json .vscode/settings.json .cursor/mcp.json .cursor/mcp.json.example; do
  [[ -f "$f" ]] && json_files+=("$f")
done
if command -v python3 >/dev/null 2>&1; then
  for f in "${json_files[@]}"; do
    if python3 -I -c 'import json,sys; json.load(open(sys.argv[1]))' "$f" 2>/dev/null; then
      pass "$f is valid JSON"
    else
      error "$f is not valid JSON"
    fi
  done
else
  warning "python3 not found; skipped JSON validation"
fi

if [[ -f .gitignore ]]; then
  for entry in '.env' 'CLAUDE.local.md' '.claude/settings.local.json'; do
    if grep -qxF "$entry" .gitignore; then
      pass ".gitignore covers $entry"
    else
      error ".gitignore is missing '$entry'"
    fi
  done
else
  error ".gitignore is missing"
fi

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  tracked_env=$(git ls-files | grep -E '(^|/)\.env(\.|$)' | grep -v '\.env\.example$' || true)
  if [[ -n "$tracked_env" ]]; then
    error "env files are committed: $tracked_env"
  else
    pass "no .env files tracked by git"
  fi
fi

echo
echo "Result: $fail failure(s), $warn warning(s)"
(( fail == 0 ))
