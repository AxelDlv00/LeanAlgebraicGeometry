# Mathlib Analogist Report

## Mode
api-alignment

## Slug
deepbridge

## Iteration
054

## Question
Two ACTIVE prover lanes have each collapsed to a "deep categorical bridge" residual (same family as
`CechAcyclic.affine`). (1) Lane 1 `cechAugmented_exact`: from `Homotopy (𝟙 C) 0` on a section cochain
complex, get `IsZero (C.homology p)`, and the cleanest way to obtain that homotopy (incl. whether
`ExtraDegeneracy` applies). (2) Lane 2 open-immersion `f_*`-acyclicity: identify objectwise homology of a
pushed-forward injective resolution with the `Ext`-based absolute cohomology presheaf.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1a — `Homotopy (𝟙 C) 0` ⟹ `IsZero (C.homology p)` | PROCEED | informational |
| 1b — obtain the homotopy; `ExtraDegeneracy`? | PROCEED (packaging) / NEEDS_MATHLIB_GAP_FILL (section identification) | informational |
| 2a — objectwise homology of `F.mapHomologicalComplex I.cocomplex` ↔ `rightDerived n` | PROCEED | informational |
| 2b — `Ext^n` (inj. res. of 2nd arg) ↔ `Hⁿ(Hom(X, I^•))` | PROCEED | informational |

## Informational

**1a — homotopy ⟹ IsZero homology (PROCEED).** No single packaged lemma exists; the idiom is a 3-lemma
combo, all confirmed present:
- `Homotopy.homologyMap_eq (ho : Homotopy f g) (i) : homologyMap f i = homologyMap g i` —
  `Mathlib.Algebra.Homology.Homotopy`.
- `HomologicalComplex.homologyMap_id (K) (i) : homologyMap (𝟙 K) i = 𝟙 (K.homology i)` and
  `HomologicalComplex.homologyMap_zero (K L) (i) : homologyMap 0 i = 0` —
  `Mathlib.Algebra.Homology.ShortComplex.HomologicalComplex`.
- `IsZero.iff_id_eq_zero (X) : IsZero X ↔ 𝟙 X = 0` —
  `Mathlib.CategoryTheory.Limits.Shapes.ZeroMorphisms` (already used in
  `isZero_of_faithful_preservesZeroMorphisms`).
Build-this-shape: `(IsZero.iff_id_eq_zero _).mpr (by rw [← HomologicalComplex.homologyMap_id,
h.homologyMap_eq p, HomologicalComplex.homologyMap_zero])`.
Refuted/heavier: `HomotopyEquiv.homologyIso` does not exist; `HomotopyCategory.isZero_quotient_obj_iff`
(`Mathlib.Algebra.Homology.HomotopyCategory`) gives `IsZero` only in the homotopy category (needs extra
`homologyFunctorFactors` plumbing); `homotopyEquivalences_le_quasiIso` + `HomologicalComplex.isZero_zero`
also works but is heavier.

**1b — obtaining the homotopy (PROCEED on packaging).** `ExtraDegeneracy` is RULED OUT by variance: the
only one in Mathlib, `CategoryTheory.SimplicialObject.Augmented.ExtraDegeneracy.homotopyEquiv`
(`Mathlib.AlgebraicTopology.ExtraDegeneracy`), yields a `HomotopyEquiv` of **ChainComplex** (homological,
simplicial face maps), whereas `cechAugmentedComplex` is a **CochainComplex** (`ComplexShape.up ℕ`,
alternating coface). No cosimplicial dual exists — confirms project memory and the DEAD-END notes in
`CechAcyclic.lean:57` and `FreePresheafComplex.lean:98`. The two directive sub-routes (i) field-build on the
abstract complex vs (ii) concrete-complex + `combHomotopy_spec` COINCIDE: the `Homotopy.hom` fields must be
the concrete prepend `combHomotopy i_fix`, with the relation discharged by `combHomotopy_spec` (CechAcyclic
`d∘h+h∘d=id`). Build-this-shape — mirror the project's OWN axiom-clean `cechFreeComplex_quasiIso`
(FreePresheafComplex.lean:83-100): (a) identify `(GV.mapHomologicalComplex cc).obj Kp` with concrete `D =
∏_σ Γ(coverInter σ ⊓ V, F)` via `Functor.mapHomologicalComplex` naturality + degreewise iso; (b) build
`HomologicalComplex.Homotopy (𝟙 D) 0` from `combHomotopy`/`combHomotopy_spec`; (c) close with the 1a combo.
Because `V ≤ coverOpen 𝒰 i_fix`, the prepend map on sections is the identity (the `c = id` specialisation),
so this is the simpler constant/`hu`-trivial case — "F-agnostic, cover-agnostic". The section-complex
identification (step a) is the SAME L1-bridge family as `CechAcyclic.affine` (`[[l1-bridge]]`) — that part
is genuine project work, not a Mathlib call; the `Homotopy` packaging is free.

**2a — objectwise homology ↔ rightDerived (PROCEED).** `CategoryTheory.InjectiveResolution.isoRightDerivedObj
(I) (F) [F.Additive] (n) : (F.rightDerived n).obj X ≅ (homologyFunctor D (up ℕ) n).obj
((F.mapHomologicalComplex (up ℕ)).obj I.cocomplex)` — `Mathlib.CategoryTheory.Abelian.RightDerived`.
Confirmed and ALREADY used at HigherDirectImagePresheaf.lean:164. Evaluation-at-`V` commutes because
`evaluation` is exact ⟹ `[Additive] [PreservesHomology]`; the project already applies its
`Functor.mapHomologyIso'` to `GV` (CechAugmentedResolution.lean:173). Not a gap.

**2b — Ext via inj. res. of 2nd arg ↔ cohomology of Hom-into-resolution (PROCEED).** THE bridge, confirmed:
- `CategoryTheory.InjectiveResolution.extAddEquivCohomologyClass (R : InjectiveResolution Y) {n} : Ext X Y n
  ≃+ CochainComplex.HomComplex.CohomologyClass ((CochainComplex.singleFunctor C 0).obj X) R.cochainComplex
  ↑n` — `Mathlib.CategoryTheory.Abelian.Injective.Ext` (plain `Equiv`: `extEquivCohomologyClass`).
- `CochainComplex.HomComplex.homologyAddEquiv (K L) (n) : ↑(HomologicalComplex.homology (K.HomComplex L) n)
  ≃+ CohomologyClass K L n` — `Mathlib.Algebra.Homology.HomotopyCategory.HomComplexCohomology`.
Compose ⟹ `Ext^n(X,Y) ≅ Hⁿ(Hom(X[0], I^•))`, `I^•` an injective resolution of the SECOND argument `Y`.
Build-this-shape for the hand-off: with `X = jShriekOU(f⁻¹V)`, `Y = G`, use corepresentability
`jShriekOU_homEquiv : (jShriekOU U ⟶ F) ≃+ Γ(U,F)` (AbsoluteCohomology.lean:50) degreewise to turn the
Hom-complex into the section/pushforward complex `(f_* I^•)(V)`, giving `Ext^n(jShriek(f⁻¹V),G) ≅
(pushforwardResolutionPresheafComplex f I).homology n` at `V` — closing HigherDirectImagePresheaf.lean:131-157.
Reindexing (minor): `Ext`/`HomComplex` use ℤ-indexed `R.cochainComplex`; `isoRightDerivedObj` + the project
complex use ℕ-indexed `I.cocomplex`. Bridge: `CategoryTheory.InjectiveResolution.cochainComplexXIso (R)
(n:ℤ) (k:ℕ) (h:↑k=n) : R.cochainComplex.X n ≅ R.cocomplex.X k` — `Mathlib.CategoryTheory.Abelian.Injective.Extend`.
No abstract `rightDerived = Ext` comparison lemma is forced: both compute as `Hⁿ` over the SAME injective
resolution, and their agreement is mediated by the already-built corepresentability `Γ(f⁻¹V,-) =
Hom(jShriek(f⁻¹V),-)`.

## Persistent file
- `analogies/deepbridge.md` — design-rationale + exact decl list captured for future iters.

Overall verdict: both "deep bridge" residuals are PROCEED with off-the-shelf Mathlib idioms (1a: the
`homologyMap_eq`/`homologyMap_id`/`homologyMap_zero`/`iff_id_eq_zero` combo; 2b: `extAddEquivCohomologyClass`
∘ `homologyAddEquiv` + corepresentability + `cochainComplexXIso`), with `ExtraDegeneracy` refuted by variance
and the ONLY genuine project work being Lane 1's L1-style section-complex identification.
