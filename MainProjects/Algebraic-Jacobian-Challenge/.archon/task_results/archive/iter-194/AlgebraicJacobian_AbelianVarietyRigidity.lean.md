# AlgebraicJacobian/AbelianVarietyRigidity.lean

## Summary

- **Sorries**: 3 → 3 (no count change; 1 structural narrowing).
- **Axioms**: unchanged — `[propext, sorryAx, Classical.choice, Quot.sound]`.
  No custom axioms introduced.
- **HARD BAR**: NOT MET (≥1 axiom-clean closure required); **structural progress**
  on Goal 1 (sharper residual; morphism-level reasoning eliminated).

## kbarChart1Ring_specMap_fac (line 222-273) — Lane E target #1

### Attempt 1 (iter-194)
- **Approach:** Reroute through the named `iotaGm_r_1_fac` (=
  `IsOpenImmersion.lift_fac _`), reducing the morphism-level
  `Spec.map(kbarChart1Ring) ≫ awayι X_1 = onePt.left` claim to a
  ring-map identity on `appTop` (both sides between affine Specs).
- **Tactics used:** `rw [← iotaGm_r_1_fac kbar]; congr 1; refine ext_of_isAffine ?_`.
- **Result:** PARTIAL — outer morphism-level reasoning eliminated. The residual
  is now a focused ring-map identity:
  ```
  Scheme.Hom.appTop (Spec.map (CommRingCat.ofHom (kbarChart1Ring kbar))) =
    Scheme.Hom.appTop (iotaGm_r_1 kbar)
  ```
  Both sides are `Γ(Spec(Away 𝒜 X_1), ⊤) →+* Γ(Spec k̄, ⊤)` ring maps.
- **Inner sorry content:** the same `Proj.appIso` evaluation that has been
  STUCK iter-188 → iter-191. Specifically:
  - `iotaGm_r_1 = IsOpenImmersion.lift (Proj.awayι X_1) onePt.left h_range` (by def);
  - by `IsOpenImmersion.lift_app`, `iotaGm_r_1.appTop = ((awayι X_1).appIso ⊤).inv ≫
    onePt.left.app(D₊(X_1)) ≫ presheaf.map _.op`;
  - need to evaluate `(awayι X_1).appIso ⊤ .inv` on `isLocElem ∈ Away 𝒜 X_1`,
    yielding `[X_0/X_1] ∈ HomogeneousLocalization.Away 𝒜 X_1`, then via
    `onePt.left.app(D₊X_1)` evaluating to `1 ∈ k̄`.
- **Next step (iter-195+):**
  - Search for/contribute a Mathlib lemma evaluating `Proj.awayι.appIso ⊤ .inv`
    on `isLocElem` (likely a corollary of `basicOpenIsoSpec_inv_ι` +
    `Scheme.Hom.appIso` of the open-immersion composition factoring of `awayι`).
  - Use `Scheme.Hom.appIso_inv_app` + the explicit `(D₊X_1).ι.appIso ⊤` formula
    via `basicOpenIsoAway` (`(Away 𝒜 X_1) ≅ Γ(Proj 𝒜, D₊X_1)`).
- **Lemmas found relevant:**
  - `Proj.fromOfGlobalSections_morphismRestrict` (factor onePt.left∣_(D₊X_1))
  - `Proj.basicOpenIsoSpec_inv_ι` (rewrite awayι)
  - `Proj.fromOfGlobalSections_preimage_basicOpen` (preimage of D₊X_1 is basicOpen(eval v X_1))
  - `Proj.fromOfGlobalSections_toSpecZero` (toSpecZero factorisation)
  - `Proj.basicOpenIsoAway` (`Away 𝒜 f ≅ Γ(Proj 𝒜, D₊f)`)
  - `Proj.awayι_toSpecZero` (awayι ≫ toSpecZero = Spec.map(fromZeroRingHom))
  - `IsOpenImmersion.lift_app` (formula for app of the universal lift)
  - `IsOpenImmersion.lift_uniq` (used in `iotaGm_r_1_eq_specMap`)
  - `ext_of_isAffine` (codomain affine → app determines morphism)
- **Dead-end warnings:**
  - DO NOT attempt `IsOpenImmersion.lift_uniq` of `awayι X_1` on
    `Spec.map(kbarChart1Ring)` directly: this requires the `_ ≫ awayι X_1 = onePt.left`
    fac equation, which IS the original goal (circular). The same applies
    to `iotaGm_r_1_eq_specMap` (which already uses `lift_uniq` and consumes
    `kbarChart1Ring_specMap_fac`).
  - DO NOT attempt to use only `Proj.fromOfGlobalSections_toSpecZero`: this
    only verifies equality after post-composing with `toSpecZero`, which is
    not mono — so cannot conclude the original equality.
  - `cover.hom_ext` on `openCoverOfMapIrrelevantEqTop` is overkill — the
    `X_1`-patch alone is `(Spec k̄).basicOpen 1 = ⊤` (the whole space), but
    the cover ι is not literally identity; structural noise is high.

## iotaGm_chart1_appIso_eval residual (line 471) — Lane E target #2

### Attempt 1 (iter-194)
- **Approach:** Structural commentary update — explicit note that this
  residual SHARES SUBSTANTIVE CONTENT with the iter-194-narrowed inner
  sorry of `kbarChart1Ring_specMap_fac` (both reduce to chart-`1` `appTop`
  ring-map identity).
- **Result:** NO new closure on the LHS pullback collapse. Body remains
  the iter-192/193 framework: chart-1 ring-map `Spec.map(eval₂Hom)` ≫ iso
  chain (`pullbackSpecIso ≪≫ pullback.congrHom ≪≫ pullbackRightPullbackFstIso
  ≪≫ pullbackSymmetry`) ≫ `pullback.lift(_, _)` collapses to
  `Spec.map(algebraMap MvPoly Unit kbar (GmRing kbar))` (on `appTop`).
- **Dead-end warnings:**
  - `simp only [Scheme.Hom.comp_appTop, Scheme.Hom.appTop, ← Spec.map_comp,
    ← CommRingCat.ofHom_comp]` does NOT make progress on the iso-chain at
    this position (the iso `.app ⊤` does not pre-simplify to a Spec.map).
  - Direct `rfl` does not hold — the iso chain genuinely needs unfolding
    via `pullbackSpecIso_hom_snd` etc.
- **Next step (iter-195+):**
  - Close the iter-194-narrowed inner sorry of `kbarChart1Ring_specMap_fac`
    first; this unlocks the chart-1 ring-map identity. Then re-attack this
    residual via `iotaGm_r_1_eq_specMap` (a now-valid rewrite) and
    `pullbackSpecIso_hom_snd` / `Algebra.TensorProduct.lid` to collapse
    the tensor product.

## genusZero_curve_iso_P1 (line 837)

- Untouched (off-target this iter; gated on Riemann-Roch bridge, not Lane E).

## Build status

```
AlgebraicJacobian/AbelianVarietyRigidity.lean:222:14: warning: declaration uses `sorry`
AlgebraicJacobian/AbelianVarietyRigidity.lean:377:14: warning: declaration uses `sorry`
AlgebraicJacobian/AbelianVarietyRigidity.lean:837:8: warning: declaration uses `sorry`
```

- `kbarChart1Ring_specMap_fac` axioms: `[propext, sorryAx, Classical.choice, Quot.sound]`
- `morphism_P1_to_grpScheme_const` (headline) axioms: unchanged
- `rigidity_genus0_curve_to_grpScheme` (headline) axioms: unchanged

## Blueprint marker recommendation

- `lem:iotaGm_chart1_appIso_eval` (chapter `AbelianVarietyRigidity.tex`,
  L1146-1221): retain `\leanok` on the statement block — formalised with
  named declaration `iotaGm_chart1_appIso_eval`. Proof block: NO `\leanok`
  (sorry still present in body; review agent's `sync_leanok` phase
  will manage).
- `kbarChart1Ring_specMap_fac` is a private helper; no blueprint hook
  required (already documented in source via iter-193 doc-string).
