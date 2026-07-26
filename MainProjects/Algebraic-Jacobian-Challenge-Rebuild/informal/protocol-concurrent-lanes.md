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

### 1b. The CAS recipe leaves the SHARED index permanently stale — this is by design, and it is armed

Added 2026-07-27 (run 0048 r5) after this failed a **third** time (`I-0366`: the shared index
was pinned to a pre-round-5 snapshot and a bare `git commit` would have deleted
`Picard/JacobianDataCharts.lean` and un-rooted it from `AlgebraicJacobian.lean` in one commit).

The mechanism is not a bug in anyone's lane, it is the direct consequence of §1: a CAS commit
publishes a tree built in a **private** `GIT_INDEX_FILE` and moves the ref with `update-ref`.
The **shared** index is never touched, so the moment anybody commits, the shared index still
describes the previous HEAD — and `git status` then reports that difference as *staged changes*,
including **staged deletions** for any file the commit added. The longer a run goes, the further
the shared index drifts behind.

Consequences, all three binding:

1. **Never run a bare `git commit` (no `-a`, no pathspec) against `workspace.git`.** It publishes
   whatever the stale shared index holds, which is a reversion of other lanes' work.
2. **Before finishing, check and repair.** `git --git-dir=$GD --work-tree=. status --porcelain | grep '^D'`
   must be empty. If it is not, repair with the **narrowest** form that covers your paths:
   `git --git-dir=$GD --work-tree=. reset -q -- <your project dir>/`. Prefer this to a whole-index
   `read-tree HEAD` when another run is live — a full reset can discard the other run's staging.
3. **Verify the worktree is the good copy before repairing.** `reset` makes the index match HEAD;
   that is only safe once you have confirmed the on-disk file is the one you want
   (`diff <(git --git-dir=$GD cat-file -p HEAD:<path>) <path>`).

Expect to repeat step 2 more than once in a long session: every CAS commit by any lane re-stales
the index, so a repair done early does not stay done.

## 2. The lake mutex is a mkdir DIRECTORY lock — never flock a file there

`/tmp/claude-1001/ajcr-locks/lake.lock` is acquired by `mkdir` (atomic; a crash leaves a
directory that the next holder's timeout logic can reap). It is NOT a flock file: a lane
that runs `flock /tmp/claude-1001/ajcr-locks/lake.lock …` creates a plain FILE at the
path, and every mkdir-acquire loop then spins forever (this deadlocked all lanes
15:18–19:10 on 2026-07-16 until a human deleted it). Acquire pattern:

```bash
LOCK=/tmp/claude-1001/ajcr-locks/lake.lock
while ! mkdir "$LOCK" 2>/dev/null; do
  # (a) plain FILE at the path = a flock protocol-violation; reap immediately.
  if [ -f "$LOCK" ]; then echo "STALE: plain file at $LOCK (flock violation) — removing" >&2; rm -f "$LOCK"; continue; fi
  # (b) orphaned DIRECTORY from a crashed build (rmdir never ran). Reap on proof of death:
  if [ -d "$LOCK" ]; then
    holder=$(cat "$LOCK/pid" 2>/dev/null)
    if [ -n "$holder" ] && ! kill -0 "$holder" 2>/dev/null; then
      echo "STALE: holder pid $holder dead — reaping" >&2; rm -rf "$LOCK"; continue
    fi
    # No pidfile (old-cohort holder): reap only if NO live lake build AND the dir is >15 min old.
    if [ -z "$holder" ] && ! pgrep -f 'lake build AlgebraicJacobian' >/dev/null 2>&1 \
       && [ $(( $(date +%s) - $(stat -c %Y "$LOCK" 2>/dev/null || date +%s) )) -gt 900 ]; then
      echo "STALE: no live build, lock >15min old — reaping" >&2; rm -rf "$LOCK"; continue
    fi
  fi
  sleep 10
done
echo $$ > "$LOCK/pid" 2>/dev/null      # record holder so a later reaper can prove liveness via kill -0
# … lake build … ; rm -rf "$LOCK"      # release (rm -rf, not rmdir — the pidfile makes the dir non-empty)
```

Two stale shapes, both now handled above (do NOT just `sleep` forever on either):
- A plain FILE at the lock path is by definition stale (mkdir makes directories) — reap immediately.
- An orphaned DIRECTORY from a build that crashed before `rm -rf` (the 2026-07-19 C4 incident,
  I-0257): the OLD acquire loop only checked for a file, so it spun forever on this. Writing
  `$$` into `$LOCK/pid` on acquire lets the next lane prove the holder is dead (`kill -0`) and reap
  safely; the no-pidfile branch (a holder from before this fix) falls back to "no live build + >15min".
  Never reap a directory whose pidfile names a LIVE pid — that is a real build in progress.

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
