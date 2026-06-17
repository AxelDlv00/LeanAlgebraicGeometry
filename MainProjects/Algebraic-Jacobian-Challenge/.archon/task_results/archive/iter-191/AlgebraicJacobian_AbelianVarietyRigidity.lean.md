# AlgebraicJacobian/AbelianVarietyRigidity.lean — iter-191 Lane E

## Summary

- **HARD BAR met**: Part 1 (refactor `iotaGm_chart1_section` +
  `iotaGm_chart1_composition_isOpenImmersion` to specialise on
  `iotaGm_r_1` / `iotaGm_r_1_fac`) **LANDED axiom-clean**.
- **Part 2** (body close) **DEFERRED** at the 80 LOC HARD BUDGET
  wall per PROGRESS.md sub-step scope discipline + progress-critic
  STUCK verdict.
- **Sorry count**: 2 → 2 (unchanged). Lines shifted to 265, 775.
- **Build**: GREEN. File compiles cleanly.
- **Net file delta**: −20 LOC raw (abstract `r_1, h_r_1` parameters
  removed from `iotaGm_chart1_section` and the composition lemma);
  +25 LOC documentation explaining the iter-191 refactor + iter-192
  deferral plan.

## Part 1 — `iotaGm_chart1_section` + `iotaGm_chart1_composition_isOpenImmersion` refactor (line 178+)

### Attempt 1
- **Approach** (per PROGRESS.md slot 3 Part 1 + iter-190 review §7):
  Drop abstract `(r_1, h_r_1)` parameters from both
  `iotaGm_chart1_section` and the composition lemma; substitute
  `iotaGm_r_1 kbar` / `iotaGm_r_1_fac kbar` directly. Update the
  downstream consumer `iotaGm_isOpenImmersion` to call the new
  parameter-free signatures.
- **Result**: **RESOLVED** — refactor lands, file compiles, sorry
  count preserved.
- **Key structural change**:
  - `iotaGm_chart1_section` signature: `(kbar : Type u) [Field kbar] :
    (Gm kbar).left ⟶ (gmScalingP1_cover kbar).X (1 : Fin 2)`. The
    `(Gm kbar).hom ≫ iotaGm_r_1 kbar` is now embedded directly in the
    `pullback.lift`, and the compatibility proof uses
    `iotaGm_r_1_fac kbar` directly.
  - `iotaGm_chart1_composition_isOpenImmersion` signature:
    `[IsAlgClosed kbar] : IsOpenImmersion (iotaGm_chart1_section kbar
    ≫ gmScalingP1_chart kbar (1 : Fin 2))`. No more
    `(r_1, h_r_1)` parameters.
  - `iotaGm_isOpenImmersion` consumer: dropped the `have h_r_1 :=
    iotaGm_r_1_fac kbar` step; calls
    `iotaGm_chart1_composition_isOpenImmersion (kbar := kbar)`
    parameter-free.
- **Why it matters**: After the refactor, the section body contains
  `iotaGm_r_1 kbar` directly, which by definition is
  `IsOpenImmersion.lift (Proj.awayι ...) onePt.left _`. So
  `unfold iotaGm_r_1` exposes the `IsOpenImmersion.lift` shape ready
  for `IsOpenImmersion.lift_app` — no `cancel_mono` uniqueness step
  required to certify `r_1` as a `lift`. This is the key new hook
  that Part 2 (iter-192+) will leverage.

## Part 2 — body close (line 432; DEFERRED)

### Attempt 1
- **Approach** (per PROGRESS.md slot 3 Part 2): after Part 1's
  specialisation, apply `unfold iotaGm_r_1` to expose
  `IsOpenImmersion.lift`, then `IsOpenImmersion.lift_app` to evaluate
  the appTop component on `isLocalizationElem`, then
  `Proj.basicOpenIsoAway` + `IsLocalization.map` on chart-1 coord
  to identify `isLocElem ↦ 1 ∈ kbar`.
- **Result**: **PARTIAL — deferred at HARD BUDGET wall** per
  PROGRESS.md sub-step scope discipline.
- **Diagnostic**: Tested via `lean_multi_attempt` at the sorry
  position:
  - `simp` (default): reduces to the same 6-factor `.app ⊤` chain
    as the iter-188 simp telescope — no progress past the iter-190
    structural floor.
  - `simp [pullback.lift_*, pullbackSpecIso_inv_*, pullbackSymmetry_hom_comp_*, Scheme.Hom.comp_appTop, Scheme.Hom.appTop]`:
    **all simp arguments flagged unused** — confirms `simp` alone
    cannot drive the `pullbackSpecIso_inv` / `pullbackSymmetry`
    rewrites with the goal in its present form (the iso factors
    are on the LHS, not exposed as `.fst`/`.snd` projections).
  - `unfold iotaGm_r_1; rw [IsOpenImmersion.lift_app]`: `unfold`
    succeeds (confirms the Part 1 hook), but the `rw` for
    `IsOpenImmersion.lift_app` does not find a syntactic match
    pattern — the `iotaGm_r_1` use sits behind a chain of pullback
    iso `.hom .app ⊤`s and is not at the head of the goal.
- **Dead end**: pure-simp closure on the 6-factor `.app ⊤` chain.
  The genuine substantive gap is the `r_1.appTop(isLocElem) = 1`
  computation, which requires the `Proj.appIso` evaluation
  identifying `isLocElem ∈ Γ(Spec(Away 𝒜(X_1)), ⊤)` with the
  section `[X_0/X_1] ∈ Γ(Proj 𝒜, D₊(X_1))`, then evaluating
  `onePt.left.app` on it. This is the same residual that was
  STUCK iter-188 / iter-189 / iter-190 — a depth of `Proj.appIso`
  machinery that exceeds the iter-191 sub-step 80 LOC budget.
- **Next step (iter-192+)** per PROGRESS.md Failure Mode for Lane E:
  plan-phase dispatch `blueprint-writer
  avr-chart1-composition-expand` to expand the chapter's sketch on
  the `Proj.appIso` evaluation step (`isLocElem ↦ [X_0/X_1] ↦ 1`)
  BEFORE re-attempting the body close. The Part 1 refactor's new
  hook (`iotaGm_r_1` directly an `IsOpenImmersion.lift`) is
  preserved for the iter-192 attempt; the residual now hangs on
  the `Proj.appIso` machinery, no longer on the lift-identification
  step.

## Lemmas / structural observations

- **`IsOpenImmersion.lift_app`** (Mathlib): pattern is
  `Scheme.Hom.app (IsOpenImmersion.lift f g H) V = (Scheme.Hom.appIso
  f V).inv ≫ ...`. Requires the LHS to syntactically expose the
  `IsOpenImmersion.lift f g H` at the head of `.app`. After
  iter-191 Part 1 refactor, this pattern is now reachable from
  `iotaGm_r_1` via `unfold` — but the goal at the sorry has
  `iotaGm_r_1` sitting behind a chain of pullback iso `.hom .app ⊤`s,
  so reaching it requires a `pullback.lift_snd`-style descent first.
- **`Proj.fromOfGlobalSections_preimage_basicOpen`**: used in
  `iotaGm_r_1_range_subset` body (iter-184 closure). The iter-192+
  closure of Part 2 can lean on the analogous `Proj.appIso`
  evaluation lemma — search query for iter-192 prover: "evaluate
  `IsOpenImmersion.lift_app` of `Proj.awayι` composed with a
  `Proj.fromOfGlobalSections` source on the basic open `D₊(X_1)`"
  (the iter-189 mathlib-analogist directive sketched in the
  iter-188 comment block above line 432).

## Files touched

- `AlgebraicJacobian/AbelianVarietyRigidity.lean` — refactor +
  documentation update (no other Lean files modified).

## Blueprint markers

- `chapters/AbelianVarietyRigidity.tex` — CLEARED (no changes
  needed; the Part 1 refactor preserves all declaration names and
  the iter-192 Part 2 plan is consistent with the chapter's
  existing sketch).

## Recommendation

- Part 1 axiom-clean closure is the iter-191 HARD BAR. **MET.**
- Per progress-critic STUCK + PROGRESS.md Failure Mode, the
  iter-192 plan-phase should dispatch
  `blueprint-writer avr-chart1-composition-expand` to expand the
  chapter's sketch on the `Proj.appIso` evaluation step BEFORE the
  iter-192 prover attempts Part 2.
