# Mathlib Analogist Report

## Mode
api-alignment

## Slug
chart-bridge-shared-helper

## Iteration
174

## Question

Is there a structural Mathlib idiom for "a morphism out of a glued cover factors through a `Spec.map (algebraMap kbar _)` to a target scheme via a per-chart shared certificate"? Concretely: does Mathlib have `Scheme.Cover.glueMorphisms_comp` or `Cover.hom_ext_of_agreement`? If not, is the helper-budget=0 sustainable, or is the recurring "chart-bridge specialisation" blocker a sign of a deeper Mathlib gap?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) Mathlib has no `glueMorphisms_comp` / `hom_ext_of_agreement`; has the structural pair `Cover.hom_ext` + `ι_glueMorphisms` only | PROCEED | informational |
| (2) The iter-173 "single shared helper closes BOTH `over_coherence` + `chart_agreement`" framing is wrong — helper closes one, cocycle needs separate machinery | ALIGN_WITH_MATHLIB | critical |
| (3) 10-step concrete recipe for `gmScalingP1_chart_PLB_eq`; one new ~5-10 LOC sub-lemma needed (`homogeneousLocalizationAwayIso_algebraMap`) | PROCEED | informational |
| (4) iter-173 `chart-bridge.md` sketch's steps 1, 4 need refinement (`pullbackSpecIso_hom_base` over `_hom_fst`); step (a) sub-lemma not made explicit | ALIGN_WITH_MATHLIB | informational |

## Must-fix-this-iter

- **(2)** The iter-174 prover lane must NOT treat `gmScalingP1_chart_PLB_eq` as the one-shot closure for both scaffolds. Split into:
  - **Sub-task A** = `over_coherence`: shared helper + `Cover.hom_ext` + `ι_glueMorphisms_assoc`. ~30-40 LOC. Axiom-clean closable in iter-174.
  - **Sub-task B** = `chart_agreement`: cocycle. Diagonal `(0,0)/(1,1)` cases via `CategoryTheory.Limits.fst_eq_snd_of_mono_eq` (1-2 LOC each); cross `(0,1)/(1,0)` cases via the `λ·u = (1/t)·λ` algebraic identity in `Localization.Away (X 0 · X 1) ⊗[kbar] GmRing` (per `analogies/gmscaling-deep.md` Q4). ~40-60 LOC OR honest deferral to iter-175.

- **(4)** The iter-173 file's claim that `pullbackSpecIso_hom_fst` is the right bridge identity is mis-aimed: the canonical bridge is `AlgebraicGeometry.pullbackSpecIso_hom_base` (`Mathlib.AlgebraicGeometry.Pullbacks:766`), which directly identifies `pullbackSpecIso.hom ≫ Spec.map (algMap R (S ⊗[R] T)) = pullback.fst _ _ ≫ Spec.map (algMap R S)`. Using `_hom_fst` forces an unnecessary `Spec.map (includeLeftRingHom)` detour.

## Major

- **(3)** The iter-174 prover must land a new project-side sub-lemma `homogeneousLocalizationAwayIso_algebraMap` (~5-10 LOC) establishing the kbar-algebra preservation of the chart-ring iso `homogeneousLocalizationAwayIso`. The iter-173 file glossed this as "kbar-linearity (~10 LOC)" but never named the lemma — making the closure obligation invisible. Without it, step (a) of the shared helper does not go through. Derivable from the `aux_right` round-trip on `MvPolynomial.C`-constants OR by direct `MvPolynomial.ringHom_ext` on the forward map (via `Localization.awayLift` + `chartEvalRingHom`'s action on constants `C r ↦ C r`).

## Informational

- **(1)** Mathlib's `AlgebraicGeometry.Scheme.Cover.hom_ext` (`Gluing:448`) + `Cover.ι_glueMorphisms` (`Gluing:457`, `@[reassoc (attr := simp)]`) ARE the structural idiom for "morphisms out of a glued cover agree via per-chart restrictions". They DO NOT bundle a per-chart Spec-level certificate — the certificate must be supplied at each call site. This is a 3-5 LOC idiom, not a single lemma. A "glueMorphisms_comp" lemma would require a fresh cocycle on `f i ≫ g`, which is content-specific and not a clean abstraction. **Conclusion: no Mathlib gap; the project's chart-bridge specialisation is a content-specific obligation per `homogeneousLocalizationAwayIso`-style iso, not a recurring Mathlib infrastructure deficit.**

- The Mathlib variant `glueMorphismsOverOfLocallyDirected` (`Mathlib.AlgebraicGeometry.Cover.Directed:236-253`) DOES bundle an `Over S` coherence (input `w : ∀ i, g i ≫ Y.hom = 𝒰.f i ≫ X.hom`) — but requires `[𝒰.LocallyDirected]`, which is overkill for a 2-chart cover and would force an `IsLocallyDirected` instance the project doesn't have. NOT worth pursuing.

- The 10 named Mathlib lemmas in the recipe (see `analogies/chart-bridge-shared-helper.md` Decision 3):
  1. `AlgebraicGeometry.Spec.map_comp` (`Scheme:507`)
  2. `awayι_comp_PLB_hom` (project, `Genus0BaseObjects:796`)
  3. `homogeneousLocalizationAwayIso_algebraMap` (NEW, project-side)
  4. `MvPolynomial.eval₂Hom_C` (Mathlib, in `Algebra.MvPolynomial.Eval`)
  5. `AlgebraicGeometry.pullbackSpecIso_hom_base` (`Pullbacks:766`)
  6. `CategoryTheory.Limits.pullback.congrHom_hom` (auto-`@[simps! hom]`, `HasPullback:349`)
  7. `CategoryTheory.Limits.pullbackRightPullbackFstIso_hom_fst` (`Pasting:459`)
  8. `CategoryTheory.Limits.pullbackSymmetry_hom_comp_fst` (`HasPullback`)
  9. `CategoryTheory.Limits.pullback.condition` (`HasPullback`)
  10. `CategoryTheory.Over.tensorObj_hom` (`Monoidal.Cartesian.Over:62`)

## Persistent file

- `analogies/chart-bridge-shared-helper.md` — full recipe, decision-table, sub-task-A/B split, kbar-algebra-preservation lemma sketch, structural answer to "is the helper-budget=0 sustainable" (YES).

Overall verdict: PROCEED on the helper as a closure of `over_coherence` only; SPLIT the iter-174 prover lane into sub-task A (`over_coherence`, axiom-clean closable this iter) and sub-task B (`chart_agreement` cocycle, partial closure + diagonal cases this iter, cross cases deferrable to iter-175).
