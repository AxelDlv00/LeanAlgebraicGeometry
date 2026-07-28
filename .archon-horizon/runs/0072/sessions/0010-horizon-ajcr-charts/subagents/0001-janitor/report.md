Pass complete. Findings below.

## A. Stale-index sweep — zero armed paths, and I repaired the one I created

**The armed set was empty on arrival.** `git --git-dir=$GD --work-tree=. status --porcelain | grep '^D'` returned nothing, and the stronger instrument from I-0656 (`diff --cached --numstat HEAD`, index vs HEAD) returned **zero entries** — not merely no deletions, but no index entry differing from HEAD at all. So there was nothing to repair and I ran no reset on another lane's paths.

Why it was clean, which is worth knowing: the index mtime (03:37) was **later** than HEAD (03:32), so a lane had refreshed the whole shared index after the last CAS. The armed set is therefore not monotone — it can clear as a side effect of another lane's staging, not only by deliberate repair.

**One path did show a deletion, and repairing it would have been wrong.** `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/ScratchChartIso.lean` appeared as ` D` (worktree-side, *unstaged*) — a different shape from the `^D` hazard. Owner via `log --diff-filter=A`: `afdfc99e4092` , run 0070, lane `ajcr-cert-r2`. It was a scratch probe (`PROBE 3` in its own docstring), unrooted in both HEAD and on disk. I did **not** reset it; by the end of the pass commit `a61f14b5c` (lane `ajcr-w5-av`) had removed it from HEAD deliberately. A path-scoped reset would have fought a lane's intentional deletion.

**My own commit re-armed the index at n=1**, exactly as I-0656 predicts. One CAS commit of one README file left the index holding `2 2` against HEAD on my own path. I ran the §1b step-3 check first — `diff <(cat-file -p HEAD:<path>) <path>` reported **identical** — then repaired with the narrowest form, `reset -q -- <path>`. Cached diff back to zero. Recorded as I-0656 C-0003: the regeneration is mechanical and needs no contention.

Final re-check after a sibling commit (HEAD `ab27f5c0b`): staged deletions 0, index-vs-HEAD 0.

## B. Inbox triage — 132 → 129 non-protection, three archived

The prompt's figure of 132 was the store count; the CLI listed 98. Per I-0482 I reconciled: **37 open items are invisible to my session** (project-scoped away, or `audience: human` from another team), so they can be neither read nor archived by me. That gap is the substance of I-0551/I-0610 and is why the counter cannot be driven to 30 from inside a lane.

Archived, each verified at HEAD before the write and read back from the on-disk `status:` field per I-0609:

- **I-0660** — the review finding against my lane. Fully resolved: all three replacement theorems exist in `Pic0ChartCoverageIndexSlack.lean` (`ledger_forces_b_eq_n:119`, `index_of_threshold:147`, `hb_forces_h0_eq_one:180`), the file is rooted at `AlgebraicJacobian.lean:536`, and grepping the project for "DERIVED rather than chosen" across `*.lean` and `*.md` returns nothing — so the retraction reached all four sites. Archived under the initiator-closes rule (`started_by: task:ajcr-charts`). **Stating it explicitly as instructed: I judge it fully resolved.**
- **I-0650** — its one live half ("nothing transports `IsSplitWitness` along a field iso, FALSE by exactly one lemma") is now *discharged*, not assumed: `isSplitWitnessIsoInvariant_holds` at `Pic0ChartLocusIsoInvariance.lean:263`, zero `sorry` terms in the file.
- **I-0658** — consumed handoff; its single named brick is the lemma above.

Kept open deliberately, having checked each rather than assuming:

- **I-0494** — human-started thread, left open as instructed.
- **I-0667 / I-0668** — re-measured and still true: **50** files on the chart-typed carrier (item said 49), 33 `partition₀/₁` hits unchanged, and the stale I-0340 appeal still sits at `DivisorFamilyAffAssemble.lean:25,76`.
- **I-0663** — still live. `pgrep` shows a bare `lake build` (pid 2110190) running while pid 1634799 holds the mutex, which is the item's finding reproducing.
- **I-0675, I-0611, I-0608, I-0677, I-0501, I-0220, I-0144** — all live blockers or unresolved findings. I-0501 is subtler than it reads: `graph frontier` does now return a ranked frontier, but neither main project has `hgraph/config.yaml` and `config.yaml` declares no blueprint keys, so the graph is still a frozen snapshot. Its diagnosis stands.

No `protection` was touched — I-0074, I-0491, I-0492 all confirmed `kind: protection, status: open`.

## C. Roadmap — both mismatches are intentional, left alone

Neither is bookkeeping drift, and both rows say so in their own summaries:

- **`AJC.jacobian.assembly`** (`pending`, only child done) — its summary reads "THIS ITEM STAYS OPEN WITH ITS ONLY CHILD DONE -- that status mismatch is deliberate and must not be 'fixed'". The parent is the assembly step, not a container, and it rests on five named open obligations (`fgaPicardRepresentability`, `Pic0Et.geometricallyReduced`, `.universallyClosed`, and two headline leaves).
- **`AJC.picrep`** (`done`, `.tensor` pending) — "STATUS MISMATCH, KNOWN AND ESCALATED -- DO NOT RE-TRIAGE". Per I-0543 the `done` propagated automatically from task `ajc-etale-pic`'s terminal status; five passes have converged and the decision is with the human as **I-0605**. Resolving it is a route decision, not hygiene.

I touched nothing under `AJCR.w4-rep.datum.dat-b` or `.dat-c`.

**Active-count warning (18 vs 8): left intentionally.** Ninth run of the I-0509 liveness cross — 18 active, 8 live pids, **13 held directly, 5 active ancestors, zero orphans**. Method note recorded: `AJC.fbc` was a false orphan in passes six through eight; crossing on the union including each running task's `roadmap_refs` retires that false positive. **Task-queue warning (13 vs 12): left** — 8 running + 5 charters, exactly the standing answer in I-0648.

## D. Docs and commit

One doc fix. The AJCR README's build-reachability paragraph is the only place a reader learns how much of the tree a bare `lake build` never elaborates, so a stale figure understates an audit gap. Re-measured transitively from the root (587 import lines, closure walked): **715 files, 642 reachable, 73 unreachable**; was 711/71. The `DivSchemeHighWindow*` family is still 38 of them. My first parse said 128 unreachable — it broke early on header comments; the regex parse is the one I used.

**Commit `ea166ce12c6bf0c31bb0c9cc94b94e0ea0e953a9`**, via the §1 CAS recipe with the §1a fix (`PARENT` captured once up front, `read-tree $PARENT`, never `read-tree HEAD`). `show --stat HEAD` confirms **1 file changed, 2 insertions, 2 deletions** — only my path. The over-500 count (19 files) and the `informal/` count (78) were already correct, so I left them.

Comments recorded rather than duplicate items filed, per I-0556: I-0656 C-0003, I-0509 C-0010, I-0648 C-0001, plus closure comments on the three archived items. Four comments were rejected first at the 1200-char cap (I-0612) and reposted trimmed; one `--agent` flag does not exist on `inbox comment`, contrary to the horizon-inbox skill's instruction for subagents — worth knowing, and I verified every write landed by reading the store rather than trusting exit output.

Files: `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/protocol-concurrent-lanes.md`, `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ChartLocusIsoInvariance.lean`.
