# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
ts-monoidal213

## Design question

The project hand-rolls the coherence isomorphisms (associator, unitors, braiding)
of a tensor product `tensorObj M N := sheafification (M.val ⊗ᵖ N.val)` on
`AlgebraicGeometry.Scheme.Modules X` (= `SheafOfModules X.ringCatSheaf`), where
`⊗ᵖ` is `PresheafOfModules.Monoidal.tensorObj` and `sheafification` is
`PresheafOfModules.sheafification`. The associator
`(M ⊗ N) ⊗ P ≅ M ⊗ (N ⊗ P)` is the load-bearing piece (the iso-class commutative
monoid `Pic = Units (Skeleton …)` needs `Nonempty ((M⊗N)⊗P ≅ M⊗(N⊗P))` for
`IsInvertible` M, N, P).

**The question, in three parts:**

1. **Does Mathlib already provide a monoidal category structure on
   `SheafOfModules R`** (or on `Sheaf J (ModuleCat …)` / sheaves of modules over a
   ringed site / `TopCat.Sheaf` of modules)? If so, the project's hand-rolled
   `tensorObj` + associator/unitors/braiding is a PARALLEL API to a Mathlib
   `MonoidalCategory (SheafOfModules R)` instance, and the associator comes free.

2. **Is `PresheafOfModules.sheafification` a monoidal functor** (lax and/or
   strong) in Mathlib — i.e. is there a `sheafification.Monoidal` /
   `Functor.LaxMonoidal` / `Functor.Monoidal` instance, or a reflective-localization
   monoidal-structure-transport result (`Localization.Monoidal`,
   `MorphismProperty.Monoidal`, monoidal left-adjoint to a monoidal inclusion)?
   A strong-monoidal sheafification would give the associator of `tensorObj` for
   free by functoriality, with NO flatness hypothesis. A lax-monoidal one plus a
   "comparison map is iso" criterion is the next-best.

3. **If neither (1) nor (2) exists**, what is the minimal correct route to JUST the
   existence `Nonempty ((M⊗N)⊗P ≅ M⊗(N⊗P))` for `IsInvertible` objects, and does
   that route necessarily require EITHER (a) sectionwise flatness over all opens
   `[∀ U, Module.Flat (𝒪_X(U)) (M.val.obj U)]` (which is FALSE for non-affine
   opens — see context) OR (b) the abandoned local-trivialization machinery
   (`tensorObj_restrict_iso`: restriction of a sheafified tensor to an open
   commutes with tensoring restrictions — an open sorry the project pivoted AWAY
   from in iter-209)? If a route exists that needs NEITHER, name it precisely.

## Project artifact(s) under question
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:408` — `tensorObj` (the sheafified presheaf tensor).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:568` — `tensorObj_assoc_iso` (typed sorry; the associator).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:332` — `W_whiskerLeft_of_flat` (needs sectionwise `[∀ X, Module.Flat (R.obj X) (F.obj X)]`).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:348` — `W_whiskerRight_of_flat` (same flatness hyp).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:373` — `isIso_sheafification_map_of_W` (closed axiom-clean; the go/no-go bridge).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:437` — `IsInvertible` (global/sheaf-level existential `∃ N, Nonempty (tensorObj M N ≅ 𝒪)`).
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean:633` — `tensorObj_restrict_iso` (the abandoned-wall sorry).
- Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex` (the `lem:tensorobj_assoc_iso` 3-step composite proof, ~lines 632–728; the "Flatness is free" step ~lines 659–664 is the FALSE step).

## Why now

iter-212's prover located a confirmed blueprint gap: the associator's "invertible ⇒
projective ⇒ flat" step conflates global sheaf-invertibility with
sectionwise-over-all-opens flatness, which is false for non-affine opens (verified
independently by lean-vs-blueprint-checker). The designated bridge cleared
axiom-clean, so the route did not bottom out THERE — but the flat-exactness
realization is now dead, and the only named fix (local-triviality whiskering)
re-introduces the local-trivialization machinery the iter-209 pivot abandoned.
Before committing multiple iters to either rebuilding that abandoned machinery or
escalating, I need to know whether Mathlib already supplies the monoidal structure
(or monoidal sheafification) that makes the whole hand-rolled coherence effort
unnecessary. This is a possible parallel-API situation that has been hardening over
~8 iters (205–212).

## Hints (optional)
- Mathlib namespaces to probe: `PresheafOfModules.sheafification`,
  `SheafOfModules`, `Mathlib.Algebra.Category.ModuleCat.Sheaf.*`,
  `Mathlib.Algebra.Category.ModuleCat.Presheaf.Monoidal`,
  `Mathlib.CategoryTheory.Monoidal.Functor`, `Localization.Monoidal`,
  `CategoryTheory.Monoidal.Braided`, reflective-subcategory monoidal transport.
- The project already found `inverseImage_W_toPresheaf_eq_inverseImage_isomorphisms`
  (sheafification IS the localization at `J.W.inverseImage (toPresheaf R₀)`). If
  Mathlib has a "monoidal structure descends along a monoidal localization /
  reflective monoidal adjunction" lemma, that may be the clean route.
- Check whether a `MonoidalCategory (SheafOfModules R)` or
  `MonoidalCategory (Sheaf J (ModuleCat R))` instance exists at all.

## Severity expectation
high-stakes
