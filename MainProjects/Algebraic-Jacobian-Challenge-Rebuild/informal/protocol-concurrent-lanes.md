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

### 1a. THE RECIPE ABOVE HAS A RACE — read HEAD ONCE, not twice (2026-07-28, run 0072)

**As written, the recipe reads `HEAD` twice**: once in `read-tree HEAD`, and again several lines
later in `PARENT=$(… rev-parse HEAD)`. If another lane's CAS lands **between those two reads**,
your tree is built from the *old* snapshot while your parent is the *new* commit — and
`update-ref` **succeeds**, because it only checks that the ref has not moved since `rev-parse`.
It never checks that the tree was built from that ref. You publish a stale tree, silently
reverting everything that landed in the window.

**Measured once, and the measurement is narrow — do not over-read it.** `e964967e8` has parent
`a1ef4d59c` and, diffed against *that parent*, deletes 95 lines of
`informal/w4-rep-critical-path.md`, 52 of `informal/w5-t4-worksheet.md` and 19 of
`Picard/Pic0ChartLocusIsOpen.lean` — exactly the restore `a1ef4d59c` had just performed, undone.
Its `read-tree` ran before `a1ef4d59c` landed; its parent was captured after. It staged explicit
paths and the pathspec *was* honoured: **the sweep came from the TREE BASE, not the pathspec**,
which is why "stage explicit files" is not a defence and why the symptom is indistinguishable
from §1b's shared-index staleness.

**Two other lanes audited their own CAS commits the same day (fifteen commits between them,
recipe verbatim) and found zero reverts.** That is consistent with this: the race only fires when
another lane's CAS lands inside your particular window, so clean commits are the expected
outcome, not evidence of absence. The discriminating question is not "did my commits look clean"
but "was my `read-tree` separated from my `rev-parse` by somebody else's commit". Treat §1a as
cheap insurance, not as a diagnosis of every mystery revert — and check §1b too.

**The fix is one line — capture the parent BEFORE the tree, and read-tree that sha:**

```bash
PARENT=$(git --git-dir=$GD rev-parse HEAD)     # ONCE, up front
export GIT_INDEX_FILE=$(mktemp)
git --git-dir=$GD --work-tree=. read-tree $PARENT      # not "HEAD"
git --git-dir=$GD --work-tree=. add <ONLY your paths…>
TREE=$(git --git-dir=$GD --work-tree=. write-tree)
COMMIT=$(git --git-dir=$GD … commit-tree $TREE -p $PARENT -m "…")
git --git-dir=$GD update-ref refs/heads/main $COMMIT $PARENT   # now genuinely atomic
```

Then a mid-recipe CAS by another lane makes `update-ref` **fail**, you re-read and retry, and the
protocol behaves as it was meant to. The verification step ("must touch only your paths") is what
catches it after the fact — run it every time, and read the file list, not just the count.

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

### 4a. A MINUS line in that diff is never yours (2026-07-28, run 0072)

The check above works. The failure mode is **misreading** it, and it happened again on
2026-07-28: the diff printed a `-import`/`+import` pair from a sibling lane's *uncommitted*
worktree edit, the committing lane read it as background noise, and the commit published the
sibling's replacement — dropping `Picard/DivRepAffPullIndep.lean` from the import closure.
The file stayed in HEAD and still compiled, but was reachable from nothing: **un-rooted**,
i.e. I-0153 again, from a lane that had run the I-0153 check.

So state the rule in a form that needs no judgement:

> **A `-import` line in that diff is never yours.** The only clean result is `+import <your
> file>` and nothing else. Any minus line means you are about to delete another lane's root
> entry — stop and explain it before committing. An unexplained `+import` you did not write
> is the same signal: a sibling's uncommitted edit is in your worktree copy, and a minus line
> usually accompanies it.

This is strictly stronger than "commit only your own lines", because you can intend that and
still sweep — staging the whole file is what publishes their edit, and the diff is your only
warning.

**Repair additively, never by reverting.** Restore the dropped import while **keeping** the
other lane's new one, then verify with a full root build (the 2026-07-28 repair: 9139 jobs,
exit 0, with the un-rooted file rebuilt). Reverting to your own earlier root blob discards
their work and turns one incident into two.

## 5. The AJCR mutex is for AJCR lake invocations only

No cross-workspace use (an OpenGA-Horizon agent squatted it ~25 min for its own
`lake cache get`, silently serializing AJCR lanes against unrelated work). Other
workspaces must use their own lock paths.

### 5a. Read it as per-PROJECT, not per-workspace (2026-07-28, run 0072)

The rule above says "cross-workspace", and that wording has a hole: **AJC and AJCR are two
projects in the SAME workspace.** Observed live on 2026-07-28 — the AJCR mutex was held for
over ten minutes while the only live `lake build` belonged to an `ajc-*` lane building
`MainProjects/Algebraic-Jacobian-Challenge`, the sibling project. Same failure as the
OpenGA incident, not covered by the rule as written.

The lock path is `ajcr-locks`, so read the rule as: **only lanes building
`Algebraic-Jacobian-Challenge-Rebuild` may take it.** AJC lanes need their own path
(`/tmp/claude-1001/ajc-locks/lake.lock`). Note the AJC task prompts do not mention a mutex
at all, which is very likely why an AJC lane reached for this one.

### 5b. Write the pidfile — the no-pidfile fallback cannot distinguish squatter from orphan

§2's acquire recipe writes `$$` into `$LOCK/pid` so a later lane can prove death via
`kill -0`. In the incident above the lock directory had **no pidfile**, so that branch could
not fire and the fallback ("no live `lake build AlgebraicJacobian` **and** dir >15 min old")
also could not fire — there *was* a live build, just not an AJCR one. Net effect: a
provably-non-AJCR holder is unreapable for 15 minutes.

Two consequences for a blocked lane, both applied in that incident:

* **Do not reap a directory whose holder you cannot prove dead**, even when you suspect a
  squatter. Reaping mid-build is worse than waiting.
* **Fall back to the narrowest check instead of blocking.** `lake env lean <file>` on the
  single changed file writes no shared build state and needs no lock; it is a faithful
  kernel check for that file. Record in the report that the mutex was unavailable and which
  check you substituted.
