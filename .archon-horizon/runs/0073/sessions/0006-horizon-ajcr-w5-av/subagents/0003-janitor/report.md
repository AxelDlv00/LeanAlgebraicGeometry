Hygiene pass complete. Report follows.

## 1. Warnings triaged by liveness — zero genuine orphans, as I-0509/I-0556 predicted

I will not produce a seventh identical triage. The roadmap active-count and inbox open-count warnings are structural at eight live lanes; both prior conclusions hold. Two things are new and worth having:

**A false orphan in the inter-round window.** I ran the liveness cross twice, ten minutes apart. First: 17 active rows, 8 running tasks, zero orphans. Second: 18 active rows, 7 running tasks, and `AJCR.w4-rep.datum.dat-d.ddr.divrep` reporting ORPHAN. Nothing went stale — `ajcr-divrep` flipped `running` → `queued` because run 0071 s0005 recorded *"did not record a terminal status; returned it to queued for the next round"*, while its pid 648098 is still live in `horizon ps`. So `task.status == running` is the wrong liveness predicate alone; cross against live pids too. Recorded as a method refinement on I-0509 (C-0005). I-0509's one prescription (`AJC.maintenance` → `pending`) is already applied.

**The memory cap cannot be met by archiving.** 29 open memory items against a cap of 10; 7 are `[persistent]` and exempt, and 13 of the remaining 22 were filed today by the eight live lanes (I-0559/0560/0562/0563/0564/0567/0569/0570/0571 are nine of them, each machine-verified). Archiving to hit the number would delete verified content. Recorded on I-0556.

Genuinely consumed, archived with verification:
- **I-0568** (22 staged deletions) — measured 0 workspace-wide before archiving.
- **I-0561** (`IsChartClause` ≡ its `omega=id` instance) — acted on and landed by the owning lane at 0a6351e5e; `IsChartClause.of_id` present, file elaborates clean.

Everything else open is substantive and lane-owned. Two older items I re-verified as still true rather than stale: **I-0144** (duplicate `overSpecMap` — both declarations live, `AlgebraicJacobian/Cohomology/RelativeSectionsLinear.lean:147` and `AlgebraicJacobian/Picard/RelPicAlgebra.lean:44`, 788 use sites) and **I-0515** (`isSplitWitness_iff_forall` still advertised at `Picard/Pic0ChartLocus.lean:49,62`, still zero declarations).

Counts before → after: issues 22 → 18, memory 29 → 29, conversation 3 → 2, non-protection total 69 → 49.

## 2. The two AJC mismatches — live, unclaimed, and already correctly filed

Both confirmed at HEAD, neither owned by a running task:
- `AJC.jacobian.assembly` **pending**, sole child `AJC.jacobian.reachability` **done** (1/1).
- `AJC.picrep` **done**, children `.quot`/`.serre`/`.tensor` all **pending**.

Not fixed — they belong to AJC lanes, and both are already documented with the right verdict. **I-0411** records that `AJC.jacobian.assembly` must *not* close (the warning is deliberate; `picardJacobianWitness` reports `sorryAx` through five open obligations). **I-0538** (open conversation) holds `AJC.picrep`, and its C-0002 already reaches the conclusion I would have: the `done` transition was not a decision — per **I-0543** it propagated automatically from `ajc-etale-pic`'s terminal status into all four `roadmap_refs` at 06:04:16, overriding a row the same lane had explicitly declined to close three minutes earlier. Reopening `AJC.picrep` is a route decision (the etale rewire may genuinely bypass Quot/Serre/tensor), so it correctly stays open as the place that decision belongs. I added nothing.

## 3. The red root build — confirmed, then fixed under me; blast radius exactly one file

Your report was accurate, and I can be more precise about the window than you could:

- HEAD's blob of `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivRepAffPullClause.lean` did fail to parse. Cause: the docstring closing at line 154 sits between `set_option maxHeartbeats 1600000 in` (line 129) and the theorem, so the parser hits `set_option` at line 155 where it expects a declaration. Reproduced in a standalone minimal probe with the identical error text.
- **The file was not clean vs HEAD when I checked** — the owning lane edited it at 17:48:04, mid-pass. The working tree held the fix; HEAD held the break. The fix has since landed as **0a6351e5e** ("fix red root build: set_option ... in must precede the docstring, not follow it"), and `lake env lean` on the current file exits 0 with zero diagnostics.
- **Blast radius: exactly one file.** I scanned all 674 AJCR `.lean` blobs at HEAD for the same docstring-then-`set_option`/`attribute`/`open`/`variable` pattern. Before the fix: one hit, this file. After, re-run at HEAD 3cc8408dd: zero hits. No other AJCR module is red from this cause. I did not edit the file.

## 4. Your lane's hygiene — clean, with one caveat that is not yours

- Both files under the 500-line limit: `AlgebraicJacobian/Tangent/TwoChartNormalize.lean` 267L, `AlgebraicJacobian/Tangent/TwoChartRepresentable.lean` 327L. For context, 17 AJCR files exceed 500 (worst: `Cohomology/RelCurveCollapse.lean` 752L, tracked in I-0220).
- Both transitively reachable from `AlgebraicJacobian.lean` (imports at lines 468, 469) — verified by walking the import graph, not by grepping the root.
- All three of your files byte-identical to HEAD: the two Lean files and `informal/w5-t4-worksheet.md`. The worksheet's `MM` status is a **stale index**, not real drift — worktree blob `e576f4ea...` equals HEAD exactly.
- The worksheet is 810 lines, not 769; §§6.8, 6.9, 6.10 are present at lines 608, 667, 733. No stated line limit exists for `informal/` — three files exceed it anyway (`spec-dd-r.md` 1069, `wave3-picard-design.md` 1026), so 810 is unremarkable.
- **Protocol §1b did not stay clean.** I measured 22 staged deletions (I-0568), watched two AJC lanes reset them to 0, archived the item, then measured **1 again minutes later**: `MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/Ledger/GenusBridge.lean`, present on disk and blob-identical to HEAD. Not your path and not yours to reset. Filed as **I-0572** — the finding is the *rate* (it re-arms per CAS commit, third clear today) rather than the count; ajc-fbc has already confirmed it independently, adding that 8 commits with explicit paths did not prevent it.

## Fixed directly

Committed **3cc8408dd**, docs only, my paths only, verified byte-identical to HEAD after:
- `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/README.md` — 672/69 → 673/68 files unreachable from root (re-measured twice, at two different HEADs).
- `MainProjects/Algebraic-Jacobian-Challenge-Rebuild/informal/README.md` — internal "26k lines" → "~27k" (actual 27,625; the file's own header already said ~27k).

The `informal/` index needed nothing else: 78 files, 60 index rows, zero listed-but-missing and zero present-but-unlisted. It was re-reconciled earlier today.
