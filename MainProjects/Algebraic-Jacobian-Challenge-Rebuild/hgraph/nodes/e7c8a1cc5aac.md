---
author: sync
content_type: definition
created: '2026-07-17T08:41:24'
decl: RingTheory.Module.depth
docstring: 'The **`I`-depth** of an `R`-module `M`: the supremum (in `ℕ∞`) of lengths
  of

  `M`-regular sequences contained in the ideal `I`.


  When `IM = M` (the "trivial-quotient" case, e.g. `M = 0` or `I = R`) the

  supremum is taken to be `⊤` by convention. When `(R, 𝔪)` is local one usually

  calls `depth (IsLocalRing.maximalIdeal R) M` simply *the depth* of `M`

  (Stacks tag 00LI).'
file: AlgebraicJacobian/Algebra/ABDepth.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.depth
type: lean
updated: '2026-07-31T20:15:16'
---
noncomputable def depth {R : Type u} [CommRing R] (_I : Ideal R)
    (_M : Type v) [AddCommGroup _M] [Module R _M] : ℕ∞ :=
  open Classical in
  if _I • (⊤ : Submodule R _M) = ⊤ then (⊤ : ℕ∞)
  else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
    (∀ r ∈ rs, r ∈ _I) ∧ RingTheory.Sequence.IsRegular _M rs }

end Module

end RingTheory

/-! ## Projective dimension

Mathlib at the pin exposes the categorical
`CategoryTheory.projectiveDimension : C → WithBot ℕ∞` on an abelian category
with enough projectives (`Mathlib.CategoryTheory.Abelian.Projective.Dimension`).
For `R`-modules this specialises to `ModuleCat.of R M`; downstream consumers use
the wrapper `Module.projectiveDimension` directly on an `R`-module without
threading `ModuleCat.of`. -/