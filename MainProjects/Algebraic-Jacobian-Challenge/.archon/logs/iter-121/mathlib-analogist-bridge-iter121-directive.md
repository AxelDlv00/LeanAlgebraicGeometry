# Mathlib Analogist Directive

## Slug
bridge-iter121

## Design question

How should the bridge between the presheaf-section module of
`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf` and the
appLE-algebra Kähler module `Ω[B/A]` on an affine chart be designed in
Lean? Specifically:

1. **Statement shape**: Should the bridge be stated as a `LinearEquiv`
   (`≃ₗ[B]`), an `Iso` in the `ModuleCat B` category, or a more
   PresheafOfModules-aware bridge (e.g. a global natural iso between
   the relevant presheaves restricted to affine charts)?

2. **`IsLocalization` packaging for `A → A_colim`**: Should the
   sub-lemma `appLE_isLocalization` be stated as an
   `IsLocalization M A_colim` instance (typeclass) on `A_colim` and
   `M := {g ∈ A : appLE(g) ∈ B^×}`, OR as an `AlgEquiv`
   `Localization M ≃ₐ[A] A_colim`, OR as both? What does Mathlib
   do for analogous "the inverse-image presheaf section is a
   localization" results, if any?

3. **Cofinality argument packaging**: The proof requires showing that
   the basic-open subsystem `{D(g) : g ∈ M}` is cofinal in the
   colimit-cone `{W : f V ⊆ W ⊆ S}` of `TopCat.Presheaf.pullback`.
   Mathlib has `CategoryTheory.Functor.Final` for cofinality;
   `IsCofiltered` / `IsFiltered` for poset-style cones. What is the
   idiomatic packaging for "directed colimit over `M`-localizations
   equals localization at `M`"?

## Project artifact(s) under question

- `AlgebraicJacobian/Differentials.lean:49-64` —
  `relativeDifferentialsPresheaf` definition, the
  `relativeDifferentialsPresheaf_obj_kaehler` rfl-style identification.
- `AlgebraicJacobian/Differentials.lean:91-109` —
  `smooth_locally_free_omega` forward direction (algebra-Kähler form,
  closed iter-120). This is the downstream consumer that will benefit
  from the bridge if/when it becomes a `LinearEquiv` lifting to the
  presheaf form.
- `blueprint/src/chapters/Differentials.tex § sec:bridge` — the new
  in-scope theorem block introduced this iter, with sub-lemmas
  `lem:appLE_isLocalization`, `lem:kaehler_localization_subsingleton`,
  `lem:kaehler_quotient_localization_iso`.

## Why now

Iter-121 introduces a `sorry`-bearing declaration
`relativeDifferentialsPresheaf_iso_kaehler_appLE` in `Differentials.lean`
to be filled across M1.a–M1.e sub-steps. Picking the wrong API shape
now will force a refactor multiple iters later. The Mathlib analogist
audit BEFORE the declaration ships is far cheaper than retroactive
cleanup.

## Hints (optional)

- `Mathlib.RingTheory.Etale.Kaehler` has `KaehlerDifferential.isLocalizedModule_map`
  — the second-fundamental-sequence-collapse argument.
- `Mathlib.RingTheory.Localization.Basic` for `IsLocalization` (a
  predicate / typeclass, not a definition; multiple algebra structures
  can witness the same localization).
- `Mathlib.AlgebraicGeometry.Spec` and `Mathlib.AlgebraicGeometry.Open`
  for `IsAffineOpen.basicOpen_isLocalization` — the obvious analogue
  for ring-level localization of basic-open section rings.
- `Mathlib.Topology.Sheaves.SheafCondition.OpensLeCover` and
  `Mathlib.CategoryTheory.Sites.Coverage` for cofinality on the
  presheaf-pullback side.
- The Stacks Project Tag 02M5 ("Cofinal subsystems of basic opens of an
  affine open under restriction to an affine subset") is the
  mathematical analogue; check whether Mathlib has analogues.

## Severity expectation

high-stakes. The bridge declaration is load-bearing for the M1
milestone and ships as a `\lean{...}`-tagged blueprint theorem with a
Mathlib-contribution ambition. Strict adherence to idiom matters.

Also: please write the persistent analogy file to
`analogies/relative-differentials-presheaf-bridge.md` rather than a
generic slug — the file should be findable from the chapter prose for
future iters.
