# AlgebraicJacobian/AbelianVarietyRigidity.lean

## Lane E (iter-185 sub-task (f) pickup)

**Status entering**: 2 sorries.
**Status exiting**: 2 sorries (sorry count unchanged, but the sorry at L238
has been pushed substantially deeper — from "opaque, blocked by privacy"
to "concrete `appTop` ring-map equation").
**Helper budget used**: 0 / 1.

## `iotaGm_chart1_composition_isOpenImmersion` (L238)

### Attempt 1 — `change` + reconstruct iso via `_, _` placeholders
- **Approach**: The original iter-184 task_result identified the residual sorry
  as "structural chase blocked by the privacy of `gmScalingP1_cover_X_iso` and
  `gmScalingP1_chart_PLB_eq` (both `private` in
  `Genus0BaseObjects/GmScaling.lean`)" — `unfold gmScalingP1_cover_X_iso` from
  this file fails with `Unknown identifier`. Verified: `lean_multi_attempt`
  on `unfold gmScalingP1_cover_X_iso` returns this error.

  **The unblock**: `gmScalingP1_cover_X_iso`'s body is
  `pullbackSymmetry ≪≫ pullbackRightPullbackFstIso ≪≫
  pullback.congrHom (awayι_comp_PLB_hom ...) (rfl) ≪≫ pullbackSpecIso`.
  The two `pullback.congrHom` arguments are `Prop`-typed (proofs of ring-map
  equalities), so by **proof irrelevance** the kernel sees through them.
  A `change` with `_, _` placeholders for those proofs reconstructs the
  iso chain from public Mathlib names alone — sidestepping the private
  `awayι_comp_PLB_hom` entirely.

  ```lean
  change (iotaGm_chart1_section kbar r_1 h_r_1 ≫
      (pullbackSymmetry _ _ ≪≫
        pullbackRightPullbackFstIso _ _ _ ≪≫
        pullback.congrHom _ _ ≪≫
        pullbackSpecIso kbar _ (GmRing kbar)).hom) ≫ _ = _
  ```

  Lean elaborates and the kernel discharges the defEq via proof irrelevance.
  Goal pre-change: `(section ≫ (gmScalingP1_cover_X_iso✝ kbar 1).hom) ≫ ...`
  Goal post-change: `(section ≫ (pullbackSymmetry ≪≫ ... ≪≫ pullbackSpecIso).hom) ≫ ...`
  — the private name is GONE from the goal.

- **Result**: SUCCESS on the structural step. Privacy barrier eliminated.

### Attempt 2 — Spread + cancel trailing iso + reduce to ring map
- **Approach**: After exposing the iso chain, spread via
  `simp only [Iso.trans_hom, Category.assoc, iotaGm_chart1_section]` (also
  unfolds the section's `pullback.lift` skeleton).

  Then split the trailing `Spec.map (eval₂Hom.comp iso.toRingHom)` on both
  sides via `CommRingCat.ofHom_comp` + `Spec.map_comp` so both sides end
  with `Spec.map(CommRingCat.ofHom iso.toRingHom)` (an iso, since the ring map
  is an iso `RingEquiv → IsIso`-promoted by the existing `h_iso_isIso` in
  the proof's local context). Re-associate via `simp only [← Category.assoc]`
  and `apply (CategoryTheory.cancel_mono (f := Spec.map ...)).mpr` cancels
  the trailing iso (`IsIso → Mono`).

  Goal reduces to:
  ```
  (pullback.lift _ _ _ ≫ pullbackSymmetry.hom ≫ pullbackRightPullbackFstIso.hom ≫
    pullback.congrHom.hom ≫ pullbackSpecIso.hom) ≫ Spec.map(eval₂Hom)
    = Spec.map(algMap MvPoly Unit kbar → GmRing kbar)
  ```

- **Result**: SUCCESS on the cancellation step. Goal is now between morphisms
  `Gm.left → Spec(MvPoly Unit kbar)` (both ends `Spec _`, with target
  `IsAffine`).

### Attempt 3 — `ext_of_isAffine` reduction to global-sections ring map
- **Approach**: Target `Spec(MvPoly Unit kbar)` is affine. Apply
  `refine ext_of_isAffine ?_` (Mathlib lemma at
  `AlgebraicGeometry/AffineScheme.lean:154`) to reduce the morphism equality
  to a ring-map equality on global sections (`.appTop`).

  After this, `simp only [Scheme.Hom.comp_appTop]` distributes `.appTop`
  through the composition, yielding a concrete chain of
  `Scheme.Hom.app _ ⊤` applications to identify.

- **Result**: SUCCESS on reduction. Goal is now a concrete ring-map equation
  with no remaining schemes / opacity / privacy.

### Residual sorry (L382 — fully spread `.appTop` equation)
- **What remains**: A long but mechanical chase through Mathlib's `appTop`
  simp lemmas. Specifically the LHS appTop is:
  ```
  Spec.map(eval₂Hom).appTop ≫
    (pullbackSpecIso _ _ _).hom.appTop ≫
    (pullback.congrHom _ _).hom.appTop ≫
    (pullbackRightPullbackFstIso _ _ _).hom.appTop ≫
    (pullbackSymmetry _ _).hom.appTop ≫
    (pullback.lift (pullback.lift A B C) (Gm.hom ≫ r_1) D).appTop
  ```
  RHS: `Spec.map(algMap MvPoly GmRing).appTop` = `algMap` modulo ΓSpecIso.

  **Closure recipe** (iter-186+):
  1. `Spec.map(f).appTop = (ΓSpecIso _).inv ≫ CommRingCat.ofHom f ≫ (ΓSpecIso _).hom`
     (i.e., `Spec.map_appTop` simp lemma — exact name needs verification;
     `Spec.map_appTop` or `Spec.map_appOfIso` or similar).
  2. Each `pullbackSpecIso/_Symmetry/_RightPullbackFstIso.hom.appTop` reduces
     via the appropriate Mathlib appTop simp lemma OR via
     `pullback.hom_ext` applied at the underlying ring level after
     `pullbackSpecIso.inv_naturality`.
  3. `pullback.lift.appTop` distributes via `pullback.lift_appTop` or
     similar.
  4. Final ring-map identity via `MvPolynomial.algHom_ext` (check on the
     constant `algebraMap kbar _` and the single variable `X()`).

  The substantive content:
  - `iso(isLocElem) = X()` (the chart-ring iso sends `X_0/X_1 ↦ X()`),
  - `homogeneousLocalizationAwayIso_algebraMap` (the iso respects the kbar
    embedding),
  - `eval₂Hom_X`: `eval₂Hom(X()) = isLocElem ⊗ algMap(X())`.

  Then chasing through the pullback iso projections:
  - The `pullbackSpecIso` step turns `Spec(Away_1 ⊗ GmRing)` into `pullback`,
    and `Spec.map(eval₂Hom)` resolves via the tensor's left/right algebra
    maps acting on `eval₂Hom`'s value at `X()` = `isLocElem ⊗ algMap(X())`.

### Lemmas discovered / verified
- `cancel_iso_hom_right_assoc` (Mathlib): cancels a trailing `iso.hom` from
  both sides of a 3-deep composition — useful but not directly applicable
  in our 2-deep case (we used `cancel_mono.mpr` instead).
- `ext_of_isAffine` (AlgebraicGeometry, AffineScheme.lean:154): ext for
  morphisms into an affine target.
- `Scheme.Hom.comp_appTop`: distributes `.appTop` through composition
  (contravariantly).
- `pullbackSpecIso_inv_fst' : pullbackSpecIso.inv ≫ pullback.fst = Spec.map(algMap S (S⊗T))`.
- `pullbackSpecIso_hom_fst' : pullbackSpecIso.hom ≫ Spec.map(algMap S (S⊗T)) = pullback.fst`.
- `pullbackSpecIso_hom_base`: `pullbackSpecIso.hom ≫ Spec.map(algMap R _) = pullback.fst ≫ Spec.map(algMap R S)`.

### Dead ends / negative results
- `unfold gmScalingP1_cover_X_iso` from this file: **fails** with
  `Unknown identifier` (the def is `private` in GmScaling.lean). The
  `change` route bypasses this by reconstructing the iso chain definitionally.
- `congr 1` after the Spec.map_comp rewrites: gives heterogeneous goals
  (`Spec(Away_1 ⊗ GmRing) = Spec(MvPoly Unit kbar)` impossible) because
  the intermediate object types don't align. **Fix**: explicit
  left-associate via `simp only [← Category.assoc]` before applying
  `cancel_mono.mpr`.
- `rw [cancel_mono]` after `conv_lhs => rw [← Category.assoc]`: still
  failed pattern match — `cancel_mono`'s explicit `f := ...` form via
  `apply (CategoryTheory.cancel_mono (f := ...)).mpr` works (the
  pattern-matching variant `rw [cancel_mono]` couldn't infer `f`).
- `apply (cancel_mono _).mp`: wrong direction — gives goal `g = h` from
  hypothetical `g ≫ f = h ≫ f`. Need `.mpr` direction (forward direction
  of the iff `(g ≫ f = h ≫ f) ↔ (g = h)` taking the equation we have to
  give the simpler goal).

### Next-iter suggestions
1. **iter-186 closure** of L238: chase `.appTop` through the pullback iso
   composition using Mathlib's `appTop` simp lemmas. The chase is long but
   mechanical — no more conceptual barriers.
2. **Alternative iter-186 closure**: in GmScaling.lean, drop the `private`
   on `gmScalingP1_cover_X_iso` (a 1-line visibility change by a write-
   capable subagent or the mathematician). Then this file's proof closes
   via `unfold gmScalingP1_cover_X_iso` + the simp lemma chain used inside
   `gmScalingP1_chart_PLB_eq` (which itself is also private — so dropping
   both would be cleanest).

## `genusZero_curve_iso_P1` (L678)
Untouched. RR-gated (iter-167+ standing deferral).

## Blueprint marker readiness
Both declarations remain unmarked: `iotaGm_chart1_composition_isOpenImmersion`
is `private` (not blueprint-bound), and `genusZero_curve_iso_P1` body is
still a bare sorry (already unmarked or `\notready` per current chapter
state). The parent `morphism_P1_to_grpScheme_const` and
`rigidity_genus0_curve_to_grpScheme` carry propagated `sorryAx` via this
helper but their statements are unchanged.
