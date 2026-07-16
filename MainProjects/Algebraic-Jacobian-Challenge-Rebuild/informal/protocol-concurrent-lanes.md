# Concurrent-lane protocol (2026-07-16, from inbox I-0149's incidents — BINDING for parallel agent fleets)

Adopted after the 2026-07-16 evening wave's four incidents (I-0149). These rules extend the
standing handoff protocol (07-14/14b/15) for any session running two or more lanes in this
workspace.

## 1. Ledger commits: private index + compare-and-swap (the shared-index race)

All lanes commit through one `workspace.git`; concurrent `git add`+`commit` through the
SHARED index can interleave and record spurious deletions of another lane's
freshly-committed files (happened in `6197c9676`, 862 lines vanished from HEAD, restored
byte-identical in `a640fef5b`). Concurrent lanes MUST commit via a private index:

```bash
cd /home/axel/LeanAlgebraicGeometry-Horizon
GD=.archon-horizon/vcs/workspace.git
export GIT_INDEX_FILE=$(mktemp)
git --git-dir=$GD --work-tree=. read-tree HEAD
git --git-dir=$GD --work-tree=. add <ONLY your paths…>
TREE=$(git --git-dir=$GD --work-tree=. write-tree)
PARENT=$(git --git-dir=$GD rev-parse HEAD)
COMMIT=$(git --git-dir=$GD -c user.name="Archon Horizon" -c user.email="archon-horizon@local" \
  commit-tree $TREE -p $PARENT -m "<math-first message>

Archon-Commit: agent
Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>")
git --git-dir=$GD update-ref refs/heads/main $COMMIT $PARENT   # CAS: fails if HEAD moved
unset GIT_INDEX_FILE
```

If the `update-ref` CAS fails (HEAD moved), re-read HEAD and repeat — never force.
ALWAYS verify afterward: `git --git-dir=$GD show --stat HEAD` must touch only your paths.
A single-lane session may keep the plain `add`+`commit` recipe, but must still verify.

## 2. The lake mutex is a mkdir DIRECTORY lock — never flock a file there

`/tmp/claude-1001/ajcr-locks/lake.lock` is acquired by `mkdir` (atomic; a crash leaves a
directory that the next holder's timeout logic can reap). It is NOT a flock file: a lane
that runs `flock /tmp/claude-1001/ajcr-locks/lake.lock …` creates a plain FILE at the
path, and every mkdir-acquire loop then spins forever (this deadlocked all lanes
15:18–19:10 on 2026-07-16 until a human deleted it). Acquire pattern:

```bash
LOCK=/tmp/claude-1001/ajcr-locks/lake.lock
while ! mkdir "$LOCK" 2>/dev/null; do
  if [ -f "$LOCK" ]; then echo "STALE: plain file at $LOCK (protocol violation) — remove it" >&2; break; fi
  sleep 10
done
# … lake build … ; rmdir "$LOCK"
```

A plain FILE at the lock path is by definition stale (mkdir creates directories) — detect
it immediately, report, and remove; do not wait on it.

## 3. /tmp quota with >3 lanes

uid-1001 tmpfs quota exhaustion (EDQUOT) bricked every Bash call machine-wide
(~19:00–19:20). With more than ~3 concurrent lanes, keep scratch artifacts small, clean up
build temp dirs, and if Bash starts failing with quota errors, stop and report rather than
retry-looping.

## 4. The root import file: commit only your own lines (I-0153)

`AlgebraicJacobian.lean` is edited by every lane. Committing the WHOLE file via any recipe
sweeps siblings' uncommitted import lines into HEAD — the root then references files not yet
in HEAD (red for fresh checkouts), and a later sibling's whole-file commit can sweep or drop
YOUR line the same way. Before committing the root file: run
`git --git-dir=$GD --work-tree=. diff HEAD -- <project>/AlgebraicJacobian.lean` — if lines
other than yours differ, either (a) verify every swept import's file is already committed in
HEAD and say so in the commit message, or (b) construct the commit from HEAD's version plus
only your lines (apply a minimal patch to a temp checkout of the HEAD blob). Never commit a
root file that references uncommitted files without naming that in the message.

## 5. The AJCR mutex is for AJCR lake invocations only

No cross-workspace use (an OpenGA-Horizon agent squatted it ~25 min for its own
`lake cache get`, silently serializing AJCR lanes against unrelated work). Other
workspaces must use their own lock paths.
