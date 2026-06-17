# AlgebraicJacobian/AbelianVarietyRigidity.lean — iter-182 Lane E

## Summary

**Result**: PARTIAL — structural progress. Lane E target `iotaGm_range_isOpen` (L98+) refactored
into a strictly-stronger named helper `iotaGm_isOpenImmersion`. The main lemma now closes in
two lines via `IsOpenImmersion.isOpen_range`. The helper carries the substantive content as a
single honest sorry with documented strategy and step-by-step structural reductions.

- **Net file sorries**: 2 → 2 (unchanged). Disclosure tier improved.
- **Axioms**: 0 new (build green).
- **Helper budget used**: 1 of 2 (new `iotaGm_isOpenImmersion`).
- **3-tier disclosure**: helper body is honest direct sorry (tier 3) with docstring strategy
  + 6-step in-body strategy comment + driven structural reductions (`Over.lift_left` +
  `simp only` unfolds + `change` to `glueMorphisms` form). The residual sorry is one
  step away from the chart-1 factorisation chase.

## `iotaGm_range_isOpen` (L98+ → L98–110 post-refactor)

### Attempt 1: refactor to strictly-stronger named helper
- **Approach**: per analogist recipe `analogies/intersection-ring-cross01.md` Decision 4.
  Replace the inline `sorry` with a 2-line body that consumes a new named helper
  `iotaGm_isOpenImmersion : IsOpenImmersion ((lift _ _).left ≫ gmScalingP1.left)`.
  Close via `IsOpenImmersion.isOpen_range`.
- **Result**: RESOLVED — `iotaGm_range_isOpen` body now reads:
  ```lean
  haveI := iotaGm_isOpenImmersion (kbar := kbar)
  exact IsOpenImmersion.isOpen_range _
  ```
- **Key insight**: the open-range claim is implied by the open-immersion claim. Promoting
  the substantive content to `IsOpenImmersion` makes it (i) strictly stronger (so the
  follow-on consumer `iotaGm_isDominant` gains the same advantage), (ii) cleanly
  reducible via a one-line Mathlib lemma at the call site, and (iii) more amenable to
  decomposition via Mathlib's open-immersion composition lemmas.

## `iotaGm_isOpenImmersion` (NEW, L98–141)

### Attempt 1: structural unfold + honest sorry on residual
- **Approach**: drive the structural progress per the analogist recipe steps (a)–(f):
  1. `Over.lift_left` rewrites `(lift _ _).left` to `pullback.lift _ _ _`.
  2. `simp only [Over.comp_left, Over.id_left, Over.toUnit_left]` exposes the
     pullback factors `(Gm.hom ≫ onePt.left)` and `(𝟙 Gm.left)`.
  3. `change` exposes `(gmScalingP1).left = (cover).glueMorphisms gmScalingP1_chart _`
     via the `Over.homMk` definitional unfolding.
  4. Residual: chart-1 factorisation chain (steps (b)+(f) of the recipe).
- **Result**: PARTIAL — steps (a)+(c)+(d)+(e) of the recipe are structurally encoded
  (the `change` step bridges into the `glueMorphisms` form where `Cover.ι_glueMorphisms`
  would apply once the section `s` is built). The residual sorry is one named honest
  sorry capturing the chart-1 factorisation of `onePt.left` (step (b)) and the chart-1
  open-immersion conclusion (step (f)).
- **Key insight**: the `change` to `glueMorphisms` form works cleanly because
  `gmScalingP1 = Over.homMk ((cover).glueMorphisms _ _) _`, so `gmScalingP1.left` is
  definitionally the glued morphism. The `simp only` for `Over.comp_left, id_left,
  toUnit_left` cleanly removes the `Over.Hom.left` layers.
- **Lemmas referenced (verified present)**:
  - `Over.lift_left` (CategoryTheory/LocallyCartesianClosed/Over.lean:130)
  - `Over.comp_left`, `Over.id_left`, `Over.toUnit_left` (same file)
  - `Proj.fromOfGlobalSections_morphismRestrict` (ProjectiveSpectrum/Basic.lean:493)
  - `Proj.awayι` `IsOpenImmersion` instance (ProjectiveSpectrum/Basic.lean:196)
  - `Cover.ι_glueMorphisms` (Gluing.lean:458)
  - `IsOpenImmersion.of_isLocalization` (OpenImmersion.lean:290) — for the chart-1
    localization Spec.map
  - `IsOpenImmersion.isOpen_range` (OpenImmersion.lean:66)

### What remains (next-iter task)
- **Sub-task (b)** — chart-1 factorisation of `onePt.left`: build
  `r_1 : Spec k̄ ⟶ Spec(Away 𝒜 (X 1))` with `onePt.left = r_1 ≫ Proj.awayι (X 1) _ _`.
  The `r_1` is `Spec.map (CommRingCat.ofHom (eval Away 𝒜 (X 1) → k̄))` where the eval
  map sends `u ↦ 0` (since `onePt = pointOfVec (fun _ => 1) _ _` has `X 0 / X 1 = 1/1 = 1`,
  i.e. `r_1` is the chart-1 evaluation point `u = 1`).
  The factorisation equation chases through `Proj.fromOfGlobalSections_morphismRestrict`
  applied to the basic open `D₊(X 1)`. ETA ~30-50 LOC. NB: this is the chart-1
  analogue of the chart-bridge work `awayι_comp_PLB_hom` (axiom-clean iter-173).
- **Sub-task (f)** — chart-1 open-immersion conclusion: after building the section
  `s : Gm.left ⟶ (cover).X 1` and reducing via `Cover.ι_glueMorphisms`, show that
  `s ≫ gmScalingP1_chart 1` decomposes into three open immersions (the chart-iso,
  the ring-map Spec.map at chart-1 which is a localization, and `Proj.awayι (X 1)`).
  Use `IsOpenImmersion.of_isLocalization` for the middle step. ETA ~30-60 LOC.

### Dead ends documented
- **`exact IsOpenImmersion.isOpen_range _` directly**: FAILED — typeclass
  inference cannot synthesize the `IsOpenImmersion` instance for the composed
  morphism (the composition is not a composition of typeclass-resolvable open
  immersions without the chart-1 factorisation).
- **`rw [Over.lift_left, Over.comp_left, ...]` (single tactic)**: FAILED with
  "motive is not type correct" because the `Over.Hom.w` proof term in
  `Over.Hom.left (toUnit_Gm ≫ onePt)` depends on the rewritten expression.
  WORKAROUND: use `simp only` (which handles motive issues via congr lemmas).
- **`Proj.awayι_isOpenImmersion` as named lemma**: FAILED via
  `lean_local_search` — Mathlib provides this as an anonymous `instance` at
  ProjectiveSpectrum/Basic.lean:196, NOT a named lemma. Resolution: rely on
  `inferInstance` after explicit unfolding.

## Off-target sorry

- **`genusZero_curve_iso_P1`** (L402, off-target): unchanged this iter (gated on RR.4
  chain per task_pending — Pin 1 → Pin 2 wrapper iter-182 Lane I → Pin 2 body iter-183+
  → Pin 3 body iter-183+).

## Blueprint status

- Chapter `blueprint/src/chapters/AbelianVarietyRigidity.tex` is unchanged (the
  iter-167 NOTE block at L1912-1918 already documents the chart-1 factorisation
  strategy; the new helper `iotaGm_isOpenImmersion` is an internal-tactic helper
  with no separate blueprint pin). The plan-phase blueprint-writer for iter-183
  may wish to add a brief `\lean{iotaGm_isOpenImmersion}` pin if the helper
  remains as a top-level decl post-iter-183 closure.
- **Marker recommendations for review agent**: none new this iter — the helper
  `iotaGm_isOpenImmersion` is private, not user-facing, so no `\lean{...}` pin
  is required.

## Coordination with Lane B

The recipe for Lane B (`gmScalingP1_chart_agreement_cross01` body in
`GmScaling.lean`) consumes the SAME chart-1 infrastructure (the
`Proj.fromOfGlobalSections_morphismRestrict` + chart-iso bridge). If Lane B
landed this iter, the chart-1 helpers Lane B builds would directly unblock
sub-task (b) here. Check `task_results/AlgebraicJacobian_Genus0BaseObjects_GmScaling.lean.md`
on iter-183 plan-phase ingestion.

## Iter-183 follow-up checklist

1. **Close sub-task (b)** — chart-1 factorisation of `onePt.left`. May coordinate
   with the Lane B `gmScalingP1_cover_intersection_X_iso` helper if both land.
2. **Close sub-task (f)** — chart-1 open immersion of `s ≫ gmScalingP1_chart 1`.
3. After both close, `iotaGm_isOpenImmersion` body fully closes kernel-clean,
   transitively retiring `iotaGm_range_isOpen` and the propagated sorryAx in
   `iotaGm_isDominant` + `morphism_P1_to_grpScheme_const_aux`.

## Build status

`lake env lean AlgebraicJacobian/AbelianVarietyRigidity.lean` GREEN: 2 sorry warnings
(L110 helper + L402 off-target), 0 errors, 0 new axioms.
