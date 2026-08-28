Report follows. Docs cleanup is done; everything else is findings only.

## Fold-ins, both re-measured

**I-0645 (mathlib outage) has largely resolved itself, or was mid-restore when you measured it.** At `/home/axel/LeanAlgebraicGeometry-Horizon/.lake-packages/mathlib`:
- `.lake/build` exists, **8176 oleans** present, `Mathlib/` source tree present, `git rev-parse HEAD` resolves to `fabf563a7c9`.
- Directory mtimes are `00:02`–`00:04`, i.e. the tree was being rewritten at exactly the minute your measurement ran (`~00:05`). Your reading of zero oleans and an unresolvable HEAD is consistent with observing a restore in flight, not a permanent loss.
- I found no `lake`/`curl`/`unzip` restore process still running; the only Lean processes are LSP servers and workers. So the restore has completed rather than being in progress.
- I-0645 is `open` on disk. It should get a follow-up comment recording the recovery (8176 oleans, HEAD `fabf563a7c9`) so no lane reads it as a live outage. **I did not comment** — the body would need to be yours, and the 1200-char cap applies. NOT MEASURED: whether the olean set is *complete* for v4.31.0 or a partial cache, and whether it matches the toolchain the AJCR lanes use. I ran no build, per your constraint.
- This does not explain any of my health-check results: none of them touched a build.

**Your fourth and fifth commits are in.** All five commits are reachable from ledger HEAD (`2458e9bc4`): `76759f498`, `cf73332ac`, `7debceffe`, `df0e6faf6`, plus `117857598`. `JacobianDataAbelSquare` is now rooted at `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian.lean:577`. **`DivRepChartClassUniv` is still unrooted** — it appears in no import line anywhere, so it is still in I-0624 Half 2's category (present, sorry-free, never a job). Its earlier 47 lines of uncommitted drift are gone, so `7debceffe` picked them up.

## (a) Roadmap parent/child, AJCR.w4-rep.datum

Re-checked after your commits: 67 rows, **zero disagreements**. No row is done with open children; no row has all children closed while itself open. `…ddr.divrep.u2` pending under `…divrep` active is correct and matches this session's re-scope.

The three warnings the CLI emits are all AJC-side and pre-existing: `AJC.picrep` done with `.quot`/`.serre`/`.tensor` pending (already escalated as I-0605; I-0556 says do not triage a fifth time), and `AJC.jacobian.assembly` / `AJC.rr` all-children-done while pending. Separately, three active leaves sit under pending parents — `AJC.fbc` under `AJC.cohomology`, `AJCR.w5-av.t4` and `.t5` under `AJCR.w5-av`. Live lanes hold all three leaves, so the parents are the stale side, but the intent is ambiguous and I changed nothing.

## (b) The two findings — comment, do not create

Neither warrants a new item.

Finding (i), the unrooted 44-file family that had discharged a gate: **already filed by this session** as comment `C-0001` on `I-0624` (`/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/inbox/local/comments/I-0624/C-0001.md`, provenance run 0071 s0008). I-0624 is the persistent consolidation of I-0362 + I-0349, and Half 2 is exactly this failure mode; your comment adds the sharpening that an unrooted family can hide a *positive* result. I-0362 is archived into it — do not reopen (I-0625: archive is one-way here). Nothing more to file. Independently re-measured at HEAD: **697 modules on disk, 627 rooted, 70 unrooted, 40 of them `Picard/DivSchemeHighWindow*`**.

Finding (ii), the certificate free-over-a-field / landed-with-zero-consumers pair: the right home is **`I-0617`** (open, "diff a replacement type's API by face"), whose rule is "a landed layer with no consumer outside its own cone" — your instance is the same rule at a different carrier. Verified rather than assumed: `DivisorFamilyFieldSurj.lean` is rooted at `AlgebraicJacobian.lean:504`; `isCertified_of_deg` had exactly one consumer before this session (`DivSchemeCertFibreRank.lean:78`) and `effectiveDivisorClassifyZar` had **zero** until `JacobianDataAbelSquare.lean`. The certificate-residue half is already carried by `I-0565` (+ its C-0002, which argues for keeping it open) and `I-0506` GAP 2. A new item would be the fourth on one theme. `I-0592` is unrelated (AJC `symPowData_affine` prose); `I-0622` is the positive-availability mirror, related to (i) not (ii).

## (c) Another lane's work reverted or lost

**The I-0611 hazard I found staged in the ledger index has cleared.** When I measured it (index mtime 22:39) it staged, against HEAD: deletion of `AlgebraicJacobian/Tangent/ReductionTrivialCyclic.lean` (on disk, tracked, imported by the root), removal of `import …DivisorFamilyAffGlueZar` from the AJCR root, and 89 lines of stale blobs across `informal/spec-dd-r.md` and `informal/w5-t4-worksheet.md` — two other lanes' worksheets. After your commits and `ajcr-cert-r2`'s integrate commit `2458e9bc4`, `git diff --cached --name-status HEAD` for AJCR is **empty**, `ReductionTrivialCyclic.lean` is in HEAD, and all three root import lines (`DivisorFamilyAffGlueZar`, `ReductionTrivialCyclic`, `JacobianDataAbelSquare`) are present at HEAD. The worktree and HEAD agree on `informal/`. Nothing was lost — but the mechanism fired and was only caught by the intervening commits, which is I-0611's point exactly. Worth a comment on I-0611 recording a fourth occurrence.

No other lane's work looks reverted.

## Health warnings, verbatim

Roadmap: `⚠ AJC.jacobian.assembly: every sub-item is done — consider roadmap set AJC.jacobian.assembly --status done (or add what remains).` / `⚠ AJC.picrep is done but sub-item(s) AJC.picrep.quot, AJC.picrep.serre, AJC.picrep.tensor are not — finish them or reopen AJC.picrep if that was unintended.` / `⚠ AJC.rr: every sub-item is done — consider roadmap set AJC.rr --status done (or add what remains).` — all three **pre-existing**, AJC-side. `⚠ Roadmap has 18 active items (recommended maximum 8) — consider marking deferred work pending, or leave the broader focus active intentionally.` — **artifact of 8 live lanes**; I-0509's liveness cross applies and I re-ran it: all 18 rows are held by a live lane or are active ancestors of one, **zero orphans**, the fifth consecutive pass with that verdict. The rise from I-0509's 13 to 18 is AJC lanes activating rows, not this session (this session changed summaries only, no statuses).

Tasks: `⚠ Task queue has 13 open tasks (recommended maximum 12) — review whether some objectives are done, blocked, cancelled, duplicated, or better kept only as roadmap milestones.` — **artifact of 8 live lanes** (8 running, 5 queued), one over cap, nothing stale.

Inbox: `⚠ Inbox has 45 open memory items (recommended maximum 10)` and `⚠ Inbox has 72 open non-protection items (recommended maximum 30)` — **pre-existing and structural**, per I-0551 (the cap is below the fleet's steady state) and I-0610 (the warning counts the disk set while `list` filters by audience). Before/after over my pass: memory 45 → 47, non-protection 72 → 74. They **rose**, from other lanes filing during the pass; on-disk census is 107 open / 456 archived / 70 closed. I archived nothing and forced nothing down.

## Inbox boundary

No open item other than I-0494 and I-0495 names `ajcr-divrep`, and neither is archivable (human-started, reply-only). I-0492 is the binding protection. Everything the lane consumed was already archived by earlier passes: I-0510, I-0511, I-0566, I-0512 (the U2-free retraction this session superseded), I-0561, I-0500. **I archived nothing and posted no comments.**

## What I changed

Only `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md`: reachability figures refreshed to the fresh measurement (697/627/70, was 693/624/69) with the 40-file HighWindow family named and the pointer moved from archived `I-0362` to live `I-0624`; house-limit violation count 17 → 18 (measured: 18 files over 500 lines). Uncommitted — you commit it.

Three things I would hand to you as comments if the session were not closing: the I-0645 recovery note, the I-0611 fourth-occurrence note, and the I-0617 zero-consumer instance.
