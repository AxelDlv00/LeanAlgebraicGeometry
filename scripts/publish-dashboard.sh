#!/usr/bin/env bash
# Export the Horizon static dashboard, commit it into the workspace ledger,
# and push the ledger to the 'upstream' GitHub remote (public dashboard repo).
#
# Cron/timer: every 30 minutes.
set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
DEFAULT_WS=$(cd -- "$SCRIPT_DIR/.." && pwd)
WS=${HORIZON_WORKSPACE:-$DEFAULT_WS}

export PATH="$HOME/.local/bin:$HOME/.archon-env/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

if [[ -z "${HORIZON_BIN:-}" ]]; then
  for candidate in \
    "$WS/../Archon-Horizon/.venv/bin/horizon" \
    "$HOME/.archon-env/bin/horizon"; do
    if [[ -x "$candidate" ]]; then
      HORIZON_BIN=$candidate
      break
    fi
  done
fi

if [[ -z "${HORIZON_BIN:-}" || ! -x "$HORIZON_BIN" ]]; then
  echo "Horizon CLI not found; set HORIZON_BIN to an executable horizon command." >&2
  exit 1
fi

LEDGER_GIT=${HORIZON_WORKSPACE_GIT:-$WS/.archon-horizon/vcs/workspace.git}
PUBLISH_REMOTE=${HORIZON_PUBLISH_REMOTE:-upstream}
PUBLISH_BRANCH=${HORIZON_PUBLISH_BRANCH:-main}

cd "$WS"

# Do not let two timer invocations share the ledger index or replace the site
# while a previous export is still running.
LOCK_FILE=${HORIZON_PUBLISH_LOCK:-$WS/.archon-horizon/locks/dashboard-publish.lock}
mkdir -p "$(dirname -- "$LOCK_FILE")"
exec 9>"$LOCK_FILE"
if ! flock -n 9; then
  echo "[$(date -u +%FT%TZ)] dashboard publish already running; skipping"
  exit 0
fi

echo "[$(date -u +%FT%TZ)] starting dashboard publish"

# Export into a fresh directory outside the workspace. The Horizon exporter
# otherwise leaves removed API endpoints in an existing dashboard tree; one of
# those stale files contained a credential and blocked every later commit.
SNAPSHOT=$(mktemp -d "${TMPDIR:-/tmp}/horizon-dashboard.XXXXXX")
trap 'rm -rf "$SNAPSHOT"' EXIT
"$HORIZON_BIN" --root "$WS" dashboard --static --out "$SNAPSHOT"

# Static API payloads include transcript text. Redact only high-confidence
# credential formats before anything enters the public repository, while the
# ledger pre-commit hook remains the final safety check.
SECRET_PATTERN='ghp_[0-9A-Za-z]{30,}|gho_[0-9A-Za-z]{30,}|github_pat_[0-9A-Za-z_]{30,}|sk-ant-[0-9A-Za-z_-]{20,}|sk-[0-9A-Za-z]{20,}|xox[baprs]-[0-9A-Za-z-]{10,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
while IFS= read -r -d '' file; do
  if grep -qEi "$SECRET_PATTERN" "$file"; then
    perl -pi -e \
      's/ghp_[0-9A-Za-z]{30,}/[REDACTED]/ig; s/gho_[0-9A-Za-z]{30,}/[REDACTED]/ig; s/github_pat_[0-9A-Za-z_]{30,}/[REDACTED]/ig; s/sk-ant-[0-9A-Za-z_-]{20,}/[REDACTED]/ig; s/sk-[0-9A-Za-z]{20,}/[REDACTED]/ig; s/xox[baprs]-[0-9A-Za-z-]{10,}/[REDACTED]/ig; s/AKIA[0-9A-Z]{16}/[REDACTED]/ig; s/AIza[0-9A-Za-z_-]{30,}/[REDACTED]/ig; s/-----BEGIN [A-Z ]*PRIVATE KEY-----/[REDACTED]/ig' \
      "$file"
  fi
done < <(find "$SNAPSHOT" -type f -print0)
if find "$SNAPSHOT" -type f -print0 \
  | xargs -0 -r grep -qEi "$SECRET_PATTERN"; then
  echo "dashboard export still contains a credential-like value" >&2
  exit 1
fi

# Replace the whole tree so stale endpoint files cannot be staged again.
mkdir -p "$WS/dashboard"
rsync -a --delete "$SNAPSHOT/" "$WS/dashboard/"

git_cmd=(git --git-dir="$LEDGER_GIT" --work-tree="$WS")

# Commit with a private index and compare-and-swap against HEAD. This avoids
# clobbering another Horizon writer's staged state or a concurrent commit.
snapshot_ready=0
for attempt in 1 2 3 4 5; do
  base=$("${git_cmd[@]}" rev-parse --verify HEAD 2>/dev/null || true)
  index="$SNAPSHOT/index-$attempt"
  if [[ -n "$base" ]]; then
    GIT_INDEX_FILE="$index" "${git_cmd[@]}" read-tree "$base"
  else
    GIT_INDEX_FILE="$index" "${git_cmd[@]}" read-tree --empty
  fi
  GIT_INDEX_FILE="$index" "${git_cmd[@]}" add -A -- dashboard
  if GIT_INDEX_FILE="$index" "${git_cmd[@]}" diff --cached --quiet -- dashboard; then
    snapshot_ready=1
    break
  fi
  current=$("${git_cmd[@]}" rev-parse --verify HEAD 2>/dev/null || true)
  [[ "$current" == "$base" ]] || continue
  if ARCHON_COMMIT_BASE="$base" GIT_INDEX_FILE="$index" \
      "${git_cmd[@]}" commit -m "workspace: publish static dashboard" \
      >"$SNAPSHOT/commit-$attempt.log" 2>&1; then
    snapshot_ready=1
    break
  fi
done

if [[ "$snapshot_ready" != 1 ]]; then
  echo "dashboard export could not be committed" >&2
  cat "$SNAPSHOT"/commit-*.log >&2 2>/dev/null || true
  exit 1
fi

# Push only after the fresh snapshot has been committed.
"${git_cmd[@]}" push "$PUBLISH_REMOTE" "HEAD:$PUBLISH_BRANCH"

echo "[$(date -u +%FT%TZ)] dashboard publish complete"
