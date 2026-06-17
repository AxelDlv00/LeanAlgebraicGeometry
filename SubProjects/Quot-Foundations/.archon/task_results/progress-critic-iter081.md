# Progress Critic: iter081
**Iter:** 081

## Routes

- **`GrassmannianQuot.lean`** (Route A): **CONVERGING**. Sorry 6→4→3→1 over iters 078–080; COMPLETE each iter; no recurring blockers; ~11–13 helpers/iter with matching sorry closure. Strategy `Iters left` = 1–3; elapsed = 3 iters of real proving → **on schedule**. Iter-081 proposal (close `tautologicalQuotient_epi`, the final sorry) is consistent with convergence.

- **`FlatBaseChangeGlobal.lean`** (Route C): **UNCLEAR**. Only 1 iter of signal (080 NOOP — planValidate dropped 0-sorry file before scaffold landed). No prover trajectory to assess. Iter-081 proposal (scaffold 2 assembly decls as sorry stubs, then prove) directly addresses the 0-sorry noop-drop mechanism. Strategy `Iters left` = 2–4; elapsed ≤ 1 → on schedule. Watch: if the noop-drop recurs again this iter the route tips to CHURNING.

- **`SectionGradedRing.lean`** (Route D): **UNCLEAR** (borderline; flag mandatory). 2-iter no-prover streak (079 scaffolder DIED, 080 queued-not-dispatched); not yet ≥3 for plan-phase-only CHURNING, and the blocker was root-caused and resolved (blueprint rewrite in 080, not cosmetic re-try). No helpers added 079–080 (structural redesign, not helper churn). Strategy `Iters left` = 1–4; elapsed ≈ 2 deferral iters → on schedule but at the edge. **Mandatory: dispatch this iter.** A 3rd consecutive no-prover iter triggers CHURNING by plan-phase-only meta-pattern.

## Dispatch Sanity

- **Verdict**: **OK**. 3 files proposed; all 3 are the full set of active routes. No capping issues (3 << 10 default cap). No under-dispatch vs ready lanes — Route A is 1-sorry endgame (1 lane correct), FBC-B and SNAP are both in the proposal (satisfying the mandatory dispatch obligation for Route D).

## Must-fix-this-iter

- Route D (`SectionGradedRing.lean`): dispatch is **mandatory** this iter — a 3rd no-prover iter would trigger CHURNING (plan-phase-only). The blueprint design fix is ready; do not queue again.

## Overall

2 UNCLEAR routes (fresh/recovering, not yet CHURNING), 1 CONVERGING route at endgame; dispatch OK; Route D must land a prover this iter or it crosses into CHURNING next iter.
