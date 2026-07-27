---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: RingTheory.Module.depth
docstring: "The **`I`-depth** of a finite `R`-module `M`: the supremum (in `ℕ∞`) of\n\
  lengths of `M`-regular sequences contained in the ideal `I`.\n\nWhen `IM = M` (the\
  \ \"trivial-quotient\" case, e.g. `M = 0` or `I = R`) the\nsupremum is taken to\
  \ be `⊤` by convention. When `(R, \U0001D52A)` is local one usually\ncalls `depth\
  \ (IsLocalRing.maximalIdeal R) M` simply *the depth* of `M`.\n\nExplicitly, the\
  \ body is the supremum\n```\nsSup { (n : ℕ∞) | ∃ rs : List R, rs.length = n ∧ (∀\
  \ r ∈ rs, r ∈ I) ∧\n                  RingTheory.Sequence.IsRegular M rs }\n```\n\
  folded with the `IM = M` clause."
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.depth
type: lean
updated: '2026-07-27T12:05:09'
---
noncomputable def depth {R : Type u} [CommRing R] (_I : Ideal R)
    (_M : Type v) [AddCommGroup _M] [Module R _M] : ℕ∞ :=
  open Classical in
  if _I • (⊤ : Submodule R _M) = ⊤ then (⊤ : ℕ∞)
  else sSup { n : ℕ∞ | ∃ rs : List R, (rs.length : ℕ∞) = n ∧
    (∀ r ∈ rs, r ∈ _I) ∧ RingTheory.Sequence.IsRegular _M rs }

end Module

end RingTheory

/-! ## §2. Projective dimension

Mathlib exposes the categorical
`CategoryTheory.projectiveDimension : C → WithBot ℕ∞` on an abelian category
with enough projectives (file `Mathlib.CategoryTheory.Abelian.Projective.Dimension`).
For `R`-modules this specialises to `ModuleCat.of R M`. The blueprint pins the
`Module.projectiveDimension` name as the re-export that downstream consumers
can use directly on an `R`-module without first packaging it in `ModuleCat`.

Blueprint reference: `def:projective_dimension`. -/