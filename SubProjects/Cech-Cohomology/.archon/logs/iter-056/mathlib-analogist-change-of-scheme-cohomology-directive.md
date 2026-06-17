# Mathlib-analogist directive — change-of-scheme cohomology transport (de-risk the `_acyclic` leaf)

## Mode: api-alignment

## Context (minimal)
Project: formalizing that Čech cohomology computes higher direct images. One active lane,
`OpenImmersionPushforward.lean`, is reducing the open-immersion acyclicity `R^q j_* H = 0`
(`j : U ↪ X` an affine open immersion, `H` quasi-coherent on `U`, `q ≥ 1`) to a residual the prover
reshaped to:
  `IsZero ((preadditiveCoyoneda.obj (op (jShriekOU (j ⁻¹ᵁ W)))).rightDerived q).obj H)`
i.e. `Ext^q(jShriekOU(j⁻¹W), H) = 0` for `j⁻¹W` a general affine open of the affine scheme `U`.

The project already has the ⊤-case Serre vanishing `affine_serre_vanishing` :
`Ext^q(jShriekOU ⊤, F) = 0` over `Spec R` (whole-space), and the helper
`isAffineHom_of_affine_separated` (so `j` is an affine morphism, hence `j⁻¹W` is an affine SCHEME).
The CHOSEN route is to transport the ⊤-case along the canonical scheme isomorphism
`j⁻¹W ≅ Spec Γ(j⁻¹W, 𝒪)` rather than build a general-affine-open cover system. The prover has
already built (axiom-clean) `rightDerivedNatIso` (a natural iso of additive functors transports
their n-th right-derived functors) and `sectionsFunctorCorepIso`
(`sectionsFunctor V ≅ preadditiveCoyoneda.obj (op (jShriekOU V))`).

## Structural problem (what I need you to align)
Find Mathlib's idiom — and the exact decl names + imports — for **transporting a right-derived /
Ext cohomology computation across an isomorphism of schemes** `φ : Y ≅ Spec R` (here `Y = j⁻¹W`,
`R = Γ(Y,𝒪)`), in the category of `𝒪_Y`-modules (`SheafOfModules`/`Scheme.Modules`). Concretely:

1. **`isoSpec`**: confirm the exact Lean name + signature of the canonical iso of an affine scheme
   with `Spec` of its global sections. Candidates: `AlgebraicGeometry.Scheme.isoSpec`,
   `AlgebraicGeometry.IsAffine.isoSpec`. Give the real one and its hypotheses.
2. **Module-category transport**: does a scheme isomorphism `φ : Y ≅ Z` induce an equivalence (or at
   least a compatible functor pair) on `Y.Modules ≌ Z.Modules` in Mathlib? Name it
   (e.g. via `Scheme.Hom.pushforward`/`pullback` of an iso, `SheafOfModules` transport along a
   homeomorphism/iso of sites, or `Scheme.Modules` functoriality). If Mathlib has NO such packaged
   equivalence, say so plainly (gap) and give the cheapest project-side construction shape.
3. **Compatibility with `jShriekOU` and `Ext`**: the cohomology is `Ext^q(jShriekOU V, −)` /
   `(preadditiveCoyoneda (op (jShriekOU V))).rightDerived q`. What is the minimal Mathlib-idiomatic
   way to get `Ext^q` (or `rightDerived coyoneda`) to transport across the module-category
   equivalence so that the ⊤-instantiation `affine_serre_vanishing` over `Spec R` discharges the
   `j⁻¹W` case? Is `rightDerivedNatIso` (already built) the right vehicle, and what natural iso of
   functors feeds it here?

## Specific questions
- Q1: exact name/signature of the affine-scheme ≅ Spec(Γ) iso, and any `IsAffine`/`Γ`-functor
  lemmas (`Scheme.ΓSpecIso`, `Scheme.isoSpec_hom`, etc.) needed to identify `Γ(Y,−)` with
  `Γ(Spec R,−)` across it.
- Q2: is there a Mathlib `SheafOfModules`/`Scheme.Modules` equivalence induced by a scheme iso?
  If absent, what is the smallest sound project-side bridge (and is it comparable in size to the
  01I8 sheaf-infra route, which overran badly — flag the risk).
- Q3: the cleanest path from `affine_serre_vanishing` (⊤ over Spec R) to
  `IsZero(Ext^q(jShriekOU(j⁻¹W), H))` — which existing project pieces (`rightDerivedNatIso`,
  `sectionsFunctorCorepIso`, `cech_eq_cohomology_of_basis`) chain, and in what order.
- Q4 (counter-check): is the transport-along-isoSpec route actually SOUND and cheaper than building
  a `BasisCovSystem U` over arbitrary affine opens of `U`? If you find it secretly forces the same
  general-affine-open machinery (i.e. the transport is circular or needs cohomology functoriality
  Mathlib lacks), say so — that is a critical finding the planner must hear before spending prover
  budget.

## Deliverable
Write `analogies/change-of-scheme-cohomology.md` with: the verified Lean names (with `[verified]`/
`[gap]` tags), the recommended chain, the LOC/risk estimate, and an explicit PROCEED / ALIGN-WITH-
MATHLIB / WALL verdict on the transport route vs the cover-system alternative. Also the task_results
report.
