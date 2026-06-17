# Progress Critic Report

## Slug
ts246

## Iteration
246

## Routes audited

### Route TS — `Picard/TensorObjSubstrate.lean`

- **Sorry trajectory**: 2 → 2 → 2 → 2 → 2 across iter-241 to iter-245. FLAT across 7 iters
  (iter-239 to iter-245). Neither `exists_tensorObj_inverse` (L694) nor
  `addCommGroup_via_tensorObj` (L1406) has closed at any point in the audited window.

- **Helper accumulation**: 5 iters, 13+ helpers/declarations landed (presheaf-monoidal
  scaffolding → 2 lax/oplax instances → pullbackTensorMap + pullbackValIso → 7 D1 bricks →
  isIso_pullbackTensorMap_of_isIso_sheafifyDelta + 1 helper). Zero sorry-elimination across
  the full 5-iter window. The character of helpers HAS shifted meaningfully (presheaf orbit
  helpers 241–243 → D1 load-bearing bricks iter-244 → reduction brick iter-245).

- **Prover dispatch pattern**: 1 of 1 ready lane dispatched in each of iters 241–245 (FlatBaseChange
  on a documented hold; no other ready lanes). No under-dispatch.

- **Prover status pattern**: PARTIAL × 5 (iter-241 through iter-245).

- **Recurring blockers**:
  - Iters 241–243 (orbit-helper phase): "Mathlib-scale / no extendScalars" → "pullbackTensorIso
    confirmed Mathlib-scale" → "forward bridge Mathlib-scale." Three surface descriptions of one
    root gap. This was correctly diagnosed CHURNING at iter-244.
  - Iter-244 (D1 brick): "D2/D3 structurally Mathlib-absent." One appearance; named next target.
  - Iter-245 (loc-triv pivot): "η-bridge not yet built (mate calculus)." One appearance; specific
    and tractable (unlike the Mathlib-absent blockers of 241–243).
  - The "Mathlib-scale / no extendScalars" family does NOT recur after iter-243. The iter-245
    blocker ("mate calculus") is a categorically different kind: a technique gap (known, validated
    by `pullbackObjUnitToUnit_comp`) rather than a Mathlib-absent infrastructure gap (unknown
    cost). No recurring blocker on the NEW route.

- **Avoidance patterns**: None. Active prover dispatch in every audited iter; no off-critical-path
  reclassification; no consecutive plan-only iters.

- **Throughput**: ON SCHEDULE for the loc-triv route. Strategy estimates 8–16 iters; loc-triv route
  entered at iter-245 (elapsed: 1 iter). 1 ≤ 8 → on schedule. Note: a prior OVER_BUDGET concern
  arose for the "general build" path (which estimated 20–38 iters and was abandoned after 1 iter).
  The pivot converted a 20–38-iter obligation into an 8–16-iter one; this is a favorable revision,
  not a schedule slip.

- **Verdict**: UNCLEAR

  **Basis.** The loc-triv route is 1 iter old (< K = 5 iters of data). The "fresh route" UNCLEAR
  rule applies as the primary classification.

  **Rules reconciliation.** Three mechanical triggers are present in the 5-iter window:
  1. PARTIAL × 5 → CHURNING trigger fires.
  2. Helpers added without any sorry-elimination across K iters → STUCK trigger fires.
  3. "No structural change in approach" — the CHURNING condition — is NOT met: the iter-245 pivot
     from general strong-monoidal to loc-triv chart-chase is a genuine structural change.
     `isIso_pullbackTensorMap_of_isIso_sheafifyDelta` is a reduction brick (collapses ALL remaining
     targets to one goal shape `IsIso (a_Y.map δ …)`), not an orbit helper. The new route has a
     narrower, fully specified residual that the prior routes lacked.

  The PARTIAL × 5 and flat-counter STUCK triggers arose under PRIOR routes (the orbit-helper phase
  and the aborted D1→D2→D3→D4 path). Projecting them onto a 1-iter-old route whose structural
  basis is genuinely different would mischaracterize the evidence. The correct verdict is UNCLEAR:
  the loc-triv route has not yet had time to demonstrate its own trajectory.

  **"Possible rotation churn" assessment.** The directive flags the risk that the pivot is rotation
  churn (old route blocked → new route's blocker is the same infrastructure gap). This does NOT
  apply here. The old route's D2 was blocked by the Mathlib absence of `extendScalars` /
  `distribBaseChange` (indeterminate cost, multi-hundred-LOC, correctly abandoned). The new route's
  D2' is blocked by mate calculus for `IsIso (a_Y.map (η …))` — a different, tractable technique
  whose analog (`pullbackObjUnitToUnit_comp`) is PROVEN axiom-clean on this file. The root
  infrastructure gap is not the same.

  **Monitoring condition for iter-246.** The critical test is: does D2' (η-bridge, ~60–120 LOC
  mate calculus) land as a named, axiom-clean brick in iter-246? If yes, the loc-triv route is
  CONVERGING. If iter-246 returns PARTIAL with a NEW "Mathlib-absent" or unexpected blocker on
  D2' that was NOT the planned D3'/D4' gap, that is the CHURNING signal — the route has hit a
  second surface-rotation point. The key diagnostic: "did a named brick on the D2'→D3'→D4'
  decomposition land?" not "did a sorry close?"

---

### Route RPF — `Picard/RelPicFunctor.lean`

- **Sorry trajectory**: 1 sorry (L269, `addCommGroup` body) throughout. No recent prover data
  (lane held from iter ~235 to iter-246). No trajectory to assess.

- **Helper accumulation**: None in the audited window (held lane).

- **Prover dispatch pattern**: Not dispatched in audited iters (held by documented condition).

- **Recurring blockers**: The L269 sorry has been open since at least iter-198 (the RPF closure
  iter). The documented gate is the `Scheme.Modules` monoidal-structure gap (Mathlib `b80f227`
  pin). This is the SAME gap that route TS exists to close. The parallelization shape proposed for
  iter-246 correctly uses a typed-sorry bridge for D4' (`addCommGroup_via_tensorObj` / its
  prerequisite `exists_tensorObj_inverse`) rather than waiting for TS to close first.

- **Avoidance patterns**: The lane hold from iter-235 to iter-245 (11 iters) was a DOCUMENTED hold
  pending substrate completion — not an undocumented deferral or off-critical-path reclassification.
  The directive confirms the hold was sanctioned. No avoidance pattern.

- **Prover status pattern**: No recent data.

- **Throughput**: ESTIMATE_FREE (no prior prover phase on this lane in the audited window; the
  "Iters left ≈ 7–12" estimate in the strategy applies to the lane from this iter forward). No
  elapsed count to compare.

- **Verdict**: UNCLEAR

  **Basis.** Fresh lane (no recent prover trajectory). The directive's own instruction: "Treat as
  UNCLEAR/fresh unless the proposed parallelization shape itself looks unsound."

  **Parallelization shape soundness check.** The proposed objective: author `addCommGroup` via a
  typed-sorry bridge for D4' (`addCommGroup_via_tensorObj`), and upgrade `PicSharp.functorial` off
  the `0` stub.

  The soundness question is whether the consumer needs the iso's computational content or only its
  existence. From `RelPicFunctor.lean` L208–269: the `addCommGroup` body at L269 is intended to
  produce an `AddCommGroup` instance on the quotient set by the construction:
  - Addition: `[L] + [L'] := [L ⊗ L']` — needs `tensorObj` defined (YES, axiom-clean at
    `TensorObjSubstrate.lean` L140).
  - Inverse: `-[L] := [L⁻¹]` — needs `exists_tensorObj_inverse` (TS's D4'), which the typed-sorry
    bridge supplies existentially.
  - Group axioms: each is a `Nonempty (… ≅ …)` proposition on iso-classes, dischargeable from the
    bridge's existential without extracting computational content.

  The bridge is existential throughout — the consumer does NOT need to pattern-match on the iso's
  specific morphisms. The parallelization shape is **sound**.

  One potential issue: the setoid `preimage_subgroup` (defined in `LineBundlePullback.lean`) must
  be reconciled with `QuotientAddGroup.leftRel (pullbackHom.range)` before `QuotientAddGroup`
  machinery applies. This reconciliation step (`L ~ L' ↔ L⁻¹ ⊗ L' ∈ π_T^* Pic(T)`) is
  substantive but does not require D4' beyond existence (it is an iso-class equality argument).
  Flagged for the prover's attention; not a soundness blocker on the parallelization shape itself.

---

## PROGRESS.md dispatch sanity

- **File count**: 2 (cap: 10). Well within cap.
- **Over the cap**: No.
- **Independence**: `TensorObjSubstrate.lean` and `RelPicFunctor.lean` are separate files with no
  shared write domain. No same-file collision.
- **Ready but not dispatched**: FlatBaseChange is on a documented hold (re-engagement condition:
  `IsInvertible.pullback` lands OR `#37189` merged; hard deadline iter-252). No other files with
  complete blueprint chapters and open sorries are identified as ready.
- **Under-dispatch finding**: No — the 2-file dispatch matches the available ready lanes.
- **RPF timing**: RPF is NOT premature. The typed-sorry bridge pattern is specifically designed to
  decouple RPF's authorship from TS's D4' closure. Opening RPF this iter with a bridge is the
  intended use of the pattern. Waiting for TS to close before opening RPF would waste 8–16 iters
  of parallel capacity.
- **Verdict**: OK — file count 2 within cap 10, 2 independent ready lanes, no under-dispatch.

---

## Informational

**Route TS: inherited flat-counter caution.** The loc-triv route is assessed UNCLEAR (fresh, 1 iter
old), but the planner should be aware that this file has NOT closed a sorry in 7 iters across THREE
strategic approaches (orbit helpers 241–243 → D1 one iter → loc-triv pivot). If D2' in iter-246
produces another "unexpected Mathlib-absent" blocker rather than a mate-calculus brick, that IS
the CHURNING/STUCK signal and must trigger an escalation (blueprint-expansion or user-escalation
corrective), not a fourth pivot. The diagnostic question for iter-246 remains: "did a named brick
on D2'→D3'→D4' land?" — not "did a sorry close?"

**Flat-counter re-classification.** The 7-iter flat counter is the designed shape: payoff sorries
(`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) close only at D4' (the end of the build,
not at intermediate bricks). The STUCK rule "helpers added without sorry-elimination across K
iters" is technically triggered but does not reflect route failure for a build where the sorry
counter is designed to be flat until the end. However, this excuse has now been applied across TWO
strategic pivots (D1 decompose AND loc-triv); if it applies a third time with a new D2'/D3'
blocker, it is a genuine stuck signal.

**RPF: setoid-reconciliation sub-goal.** The prover should budget explicit effort for reconciling
`preimage_subgroup πC πT` with `QuotientAddGroup.leftRel (pullbackHom.range)` as a concrete
sub-step. This is independent of the D4' bridge and should be addressable from existing
`LineBundlePullback.lean` definitions. If the reconciliation hits a missing lemma, that is a
separate (smaller) obstacle from the D4' gate.

---

## Overall verdict

Two routes audited, both UNCLEAR: route TS (loc-triv route, 1 iter old) and route RPF (fresh lane,
no prover trajectory). No CHURNING or STUCK verdicts. No must-fix items. Dispatch is OK — 2 files,
within cap, no under-dispatch.

The planner should proceed with the iter-246 objective list as proposed. Route TS's iter-246
result is the decisive diagnostic for whether the loc-triv route is CONVERGING or enters its own
CHURNING phase: D2' (η-bridge, mate calculus, ~60–120 LOC, analog of the PROVEN
`pullbackObjUnitToUnit_comp`) must land as a named axiom-clean brick. Route RPF opening now is
correctly timed via the typed-sorry bridge pattern.

The inherited 7-iter flat counter is noted context, not a must-fix: the route pivot was
evidence-based and introduced a genuinely narrower residual. If D2' stalls with a new
"Mathlib-absent" blocker in iter-246, the progress-critic at iter-247 must re-classify TS as
CHURNING and prescribe user escalation.
