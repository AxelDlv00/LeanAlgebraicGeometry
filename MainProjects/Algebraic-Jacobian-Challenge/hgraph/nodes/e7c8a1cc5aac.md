---
author: sync
content_type: definition
created: '2026-07-16T21:14:25'
decl: RingTheory.Module.depth
docstring: "The **`I`-depth** of a finite `R`-module `M`: the supremum (in `ℕ∞`) of\n\
  lengths of `M`-regular sequences contained in the ideal `I`.\n\nWhen `IM = M` (the\
  \ \"trivial-quotient\" case, e.g. `M = 0` or `I = R`) the\nsupremum is taken to\
  \ be `⊤` by convention. When `(R, \U0001D52A)` is local one usually\ncalls `depth\
  \ (IsLocalRing.maximalIdeal R) M` simply *the depth* of `M`.\n\niter-176+: the body\
  \ is the supremum\n```\nsSup { (n : ℕ∞) | ∃ rs : List R, rs.length = n ∧ (∀ r ∈\
  \ rs, r ∈ I) ∧\n                  RingTheory.Sequence.IsRegular M rs }\n```\nfolded\
  \ with the `IM = M` clause. The signature is non-tautological: it\nasserts a function\
  \ `(Ideal R) → (M : Type v) → ℕ∞` matching the Stacks\n00LF definition.\n\n**iter-179\
  \ Mathlib-gap check (Lane F Target 2 STRETCH)**: a pinned-commit\naudit of `Mathlib.RingTheory.Regular.Depth`\
  \ (the only file under\n`Mathlib/RingTheory/*` containing the word \"depth\") confirms\
  \ that Mathlib\n`b80f227` ships only depth-zero lemmas (`IsSMulRegular.subsingleton_linearMap_iff`)\n\
  and *not* the numeric depth function itself. The one-liner re-export route\nis therefore\
  \ not available; the body stays a typed `sorry` until an\niter-180+ body lane fills\
  \ the supremum-with-`IM=M` clause directly."
file: AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean
generated: lean
lean_status: lean_ok
title: RingTheory.Module.depth
type: lean
updated: '2026-07-24T03:02:08'
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

Mathlib `b80f227` exposes the categorical
`CategoryTheory.projectiveDimension : C → WithBot ℕ∞` on an abelian category
with enough projectives (file `Mathlib.CategoryTheory.Abelian.Projective.Dimension`).
For `R`-modules this specialises to `ModuleCat.of R M`. The blueprint pins the
`Module.projectiveDimension` name as the re-export that downstream consumers
can use directly on an `R`-module without first packaging it in `ModuleCat`.

Blueprint reference: `def:projective_dimension`. -/