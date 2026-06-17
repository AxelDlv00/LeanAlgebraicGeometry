# Mathlib Analogist Directive

## Mode
api-alignment

## Slug
p4-derived-les

## Design question
To build the abstract "an acyclic resolution computes the right-derived functor"
theorem (Leray's acyclicity, Stacks Tag 015E) at the level of Mathlib's
`CategoryTheory.Functor.rightDerived n` objects, the kernel step is a **dimension
shift across a short exact sequence**: for an additive left-exact `G : 𝒜 ⥤ ℬ`
(𝒜 abelian with enough injectives) and a short exact sequence `0 → A → J → Z → 0`
with `J` right-`G`-acyclic, produce the connecting isomorphisms
`(R^k G)(Z) ≅ (R^{k+1} G)(A)` (k ≥ 1) and `(R^1 G)(A) ≅ coker(G J → G Z)`.

This requires a **long exact sequence of right-derived functors** associated to a
SES. The plan's current route builds it by (a) a horseshoe lift of the SES to a
degreewise-split SES of injective resolutions
(`InjectiveResolution.ofShortExact`, which the plan agent has VERIFIED is ABSENT
from Mathlib — a project-side build), then (b) applying `G` degreewise (split ⇒
preserved), then (c) the complex-level homology LES
(`ShortComplex.ShortExact.homology_exact₁/₂/₃` + `δ`, VERIFIED present), then (d)
transporting along `InjectiveResolution.isoRightDerivedObj` (VERIFIED present).

**The question:** Is the explicit horseshoe (`ofShortExact`) the cheapest Mathlib-aligned
path, or does Mathlib already provide the SES → LES of derived functors by another
mechanism that avoids building a horseshoe — e.g.
- a derived-category / triangulated route (`DerivedCategory 𝒜`, distinguished triangle
  of a SES, cohomology LES of a triangle, reconciled with `Functor.rightDerived` via
  `isoRightDerivedObj` or an `Ext`-level bridge), or
- a snake-lemma argument on a SINGLE chosen injective resolution + its cokernel complex
  (avoiding the full horseshoe), or
- any existing `Abelian.Ext` / `DerivedFunctor` LES that specializes to `rightDerived`?

Tell me the cleanest **Mathlib-aligned** construction of this dimension-shift / LES,
and whether the horseshoe is genuinely the right project-side gap to fill or an
avoidable detour.

## Project artifact(s) under question
- `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` — the whole chapter; in
  particular `lem:injective_resolution_of_ses` (horseshoe), `lem:acyclic_dimension_shift`
  (the kernel), `lem:acyclic_resolution_computes_derived` (Leray 015E).
- Target Lean names (to be scaffolded into `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`):
  `CategoryTheory.Functor.IsRightAcyclic`, `InjectiveResolution.ofShortExact`,
  `Functor.rightDerivedShiftIsoOfAcyclic`, `Functor.rightDerivedIsoOfAcyclicResolution`.

## Why now
The plan agent is about to scaffold `AcyclicResolution.lean` and dispatch a
`mathlib-build` prover at it THIS iter. The scaffold shape (do we scaffold an explicit
`ofShortExact` horseshoe, or a leaner snake/derived-category construction?) depends on
your answer. This is the hardest remaining phase (P4); the horseshoe is its dominant
Lean-feasibility risk. Getting the route right before scaffolding saves prover iters.

## Hints
- Verified present: `CategoryTheory.InjectiveResolution.isoRightDerivedObj`,
  `Functor.rightDerivedZeroIsoSelf`, `Functor.isZero_rightDerived_obj_injective_succ`
  (all `Mathlib/CategoryTheory/Abelian/RightDerived.lean`);
  `ShortComplex.ShortExact.homology_exact₁/₂/₃`, `ShortComplex.ShortExact.δ`
  (`Mathlib/Algebra/Homology/HomologySequence.lean`).
- Verified ABSENT (grep over `Mathlib/`): any `InjectiveResolution.ofShortExact`,
  any horseshoe, any `shortExact`/`longExact`/`δ` inside
  `Mathlib/CategoryTheory/Abelian/RightDerived.lean`.
- Look at: `Mathlib/CategoryTheory/Derived/` (if present), `Mathlib/Algebra/Homology/`
  (`DerivedCategory`, `HomologySequence`, `Ext`), `Mathlib/CategoryTheory/Abelian/Ext`.

## Severity expectation
high-stakes
