# Progress Critic Report

## Slug
route206

## Iteration
206

## Routes audited

### Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 6 → 4 → 4 → 4 across iter-202 to iter-205. The only real
  movement was in iter-203 (−2). The count has been flat for 3 consecutive iters
  (iter-203 to iter-205). Verified against the actual file: 4 direct `sorry`s
  remain (`tensorObj_restrict_iso`, `monoidalCategory`, `exists_tensorObj_inverse`,
  `addCommGroup_via_tensorObj`).

- **Helper accumulation**: 7 helpers added across the 4-iter window. 2 sorries
  closed (both in iter-203). Zero closures in iter-204 or iter-205. Post-iter-203
  accumulation: 5 helpers added (iter-204: `tensorObjIsoOfIso`, `tensorObj_unit_iso`,
  `restrictIsoUnitOfLE`; iter-205: `isMonoidal_W_of_whiskerLeft`,
  `monoidalCategoryOfIsMonoidalW`) with no net sorry reduction. The helpers are
  axiom-clean but each one narrows the residual to a single named missing ingredient
  that then shifts to a different named missing ingredient the following iter.
  This is a **receding-horizon** variant of helper churn: the "one more ingredient"
  keeps moving forward (restrict_iso → whiskerLeft) rather than being closed.

- **Prover dispatch pattern**: 1 file (TS only) for iter-204 and iter-205. The
  other files with open sorries (COE/WD/RPF/FGA/T32) all carry USER-enforced gates
  or re-engagement gates. Effective M = 1 (only TS truly unblocked), so N = M.
  No under-dispatch finding on this basis.

- **Recurring blockers**: "entire/whole cone collapses to ONE Mathlib-absent
  ingredient" in iter-204 and iter-205 — 2 iters, not ≥3. The specific ingredient
  shifted (restrict_iso → whiskerLeft), which is genuine decomposition progress, but
  the structural form is identical. A third consecutive iter with this pattern would
  trigger STUCK; we are one iter away.

- **Avoidance patterns**: Borderline. iter-205 TO_USER language "TS is effectively
  substrate-complete pending a chosen discharge path" has a soft reclassification
  quality — it is not quite "off-critical-path" but it reframes the route as
  "done except for infrastructure" without committing to a concrete discharge
  timeline. Not formally an avoidance pattern (the analogist consult is a
  re-engagement plan), but if the analogist verdict does not produce a committed
  fork decision this iter, the next iter would be a formal avoidance finding.

- **Prover status pattern**: DONE (genuine, −2) → DONE (bar not strictly met,
  net 0) → DONE (mathlib-build invariant only, net 0). The last two are de facto
  PARTIAL outcomes: prover sessions ran, helpers were added, but the bar for the
  iteration was not met as stated. Two consecutive quasi-PARTIAL outcomes following
  one genuine close is the onset of a PARTIAL → PARTIAL pattern.

- **Throughput**: ON_SCHEDULE — estimate "~3–5" iters; elapsed 3 substantive
  iters (iter-203, 204, 205) from phase start at iter-202. Formally within the
  lower bound, but with 4 sorries remaining and the primary blocker confirmed as
  a multi-file Mathlib infrastructure gap (`MonoidalClosed (PresheafOfModules R₀)`
  absent), the estimate will SLIP unless the analogist fork produces a
  shorter-path discharge. One more full helper-accumulation iter with net 0 would
  push this to SLIPPING.

- **Verdict**: **CHURNING**

  CHURNING criterion: helpers added in ≥2 of the last 4 iters (iter-204 AND
  iter-205) ✓; sorry count net unchanged across the last 3 iters (4 → 4 → 4) ✓;
  no structural change in approach (same "collapse to single Mathlib-absent
  ingredient" strategy each iter, ingredient merely shifted) ✓.

- **Primary corrective**: **Mathlib analogy consult — act on the verdict this iter
  and commit to a fork.**

  The consult is already in flight, which is correct. The must-fix action is not to
  dispatch it (done) but to RECEIVE its verdict and make a **committed fork decision
  before this iter closes** — specifically, choose exactly one of:

  (a) **Multi-file mathlib-build lane** for `MonoidalClosed (PresheafOfModules R₀)`:
      open a new sub-lane in this iter's objectives, with a concrete iter-budget
      estimate. This is the expensive path; the analogist should quantify the scope.

  (b) **Lightweight invertible-sheaf pivot**: if the analogist confirms the full
      monoidal structure is NOT needed for the Pic group law and a lighter idiom
      suffices, redesign the carrier (no further prover dispatch on TS in its current
      form — the file may need structural refactoring first).

  (c) **Route pause with concrete re-engagement gate**: if neither (a) nor (b) is
      feasible within the project budget, explicitly pause TS with a documented gate
      condition (e.g. "resume when `MonoidalClosed` lands in Mathlib upstream"),
      and record this in STRATEGY.md so the route is not nominally "active" while
      functionally deferred.

  **Do NOT dispatch another helper round on TS before the fork is chosen.** A third
  helper-accumulation iter with net 0 is predictable from the current trajectory and
  will convert this CHURNING verdict to STUCK at iter-207.

## PROGRESS.md dispatch sanity

Verdict: OK — file count 0–1 within cap 10. Only TS is unblocked (effective M = 1);
the tentative 0 vs 1 dispatch is appropriate pending the analogist verdict. No
over-cap, no under-dispatch, no bloat. Holding dispatch until the analogist returns
is the correct response to a CHURNING route.

## Must-fix-this-iter

- Route TS: **CHURNING** — primary corrective: Mathlib analogy consult (already
  dispatched; the must-fix is to ACT on the verdict and commit to a fork choice
  before iter-206 closes). Why: two consecutive zero-closure helper iters with a
  receding-horizon blocker; a third would lock this route as STUCK.

## Overall verdict

1 route audited; 1 CHURNING, 0 STUCK, 0 formal avoidance findings, dispatch OK.
The planner's tentative proposal — hold prover dispatch pending the analogist verdict
— is the correct immediate response to CHURNING; this iter's must-fix is to land
that verdict AND commit to a fork, not defer the fork decision to iter-207. If the
fork is not decided this iter (e.g. analogist returns an ambiguous verdict), the
planner must record a concrete decision gate in STRATEGY.md and not leave TS in
an indefinite "active, pending" state. The throughput is formally on schedule but
is one helper-accumulation iter away from SLIPPING; the cost of the analogist detour
is acceptable only if it prevents a third net-0 iter.
