---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic
docstring: '**Dimension shift across an acyclic short exact sequence** (blueprint

  `lem:acyclic_dimension_shift`, TARGET 2). Given an additive functor `G` and a short
  exact sequence

  `0 → A → J → Z → 0` with middle term `J` right-`G`-acyclic, the connecting maps
  of the long exact

  sequence of right-derived functors furnish isomorphisms

  `(R^{k+1} G)(Z) ≅ (R^{k+2} G)(A)` for all `k`.


  The proof feeds the dual Horseshoe Lemma (`InjectiveResolution.ofShortExact_resolvesMiddle`)
  — a

  degreewise-split short exact sequence of injective resolutions `0 → I_A → I_B →
  I_C → 0` — into the

  resolution-level dimension shift `rightDerivedShiftIsoOfSplitResolutionSES`.'
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def Functor.rightDerivedShiftIsoOfAcyclic
    (G : 𝒜 ⥤ ℬ) [G.Additive] {ses : ShortComplex 𝒜} (hses : ses.ShortExact)
    [G.IsRightAcyclic ses.X₂] (k : ℕ) :
    (G.rightDerived (k + 1)).obj ses.X₃ ≅ (G.rightDerived (k + 2)).obj ses.X₁ :=
  let I_A : InjectiveResolution ses.X₁ := (inferInstance : HasInjectiveResolution ses.X₁).out.some
  let I_C : InjectiveResolution ses.X₃ := (inferInstance : HasInjectiveResolution ses.X₃).out.some
  G.rightDerivedShiftIsoOfSplitResolutionSES I_A
    (InjectiveResolution.ofShortExact_resolvesMiddle hses I_A I_C) I_C
    (InjectiveResolution.horseshoeSES hses I_A I_C).f
    (InjectiveResolution.horseshoeSES hses I_A I_C).g
    (InjectiveResolution.horseshoeSES hses I_A I_C).zero
    (InjectiveResolution.horseshoeSES_splitting hses I_A I_C) k

/-! ## Project-local Mathlib supplement — lowest-degree cokernel description -/