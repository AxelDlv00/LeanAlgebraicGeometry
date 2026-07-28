---
author: sync
content_type: definition
created: '2026-07-28T18:12:19'
decl: CategoryTheory.permDiagram
docstring: '**The permutation-action diagram.** The one-object diagram in `K` whose
  single value

  is `C^n` and whose endomorphisms are the factor permutations. A colimit of it is
  the

  quotient `C^n / S_n`.'
file: AlgebraicJacobian/Albanese/SymPowColimit.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.permDiagram
type: lean
updated: '2026-07-28T18:12:19'
---
noncomputable def permDiagram (C : K) (n : ℕ) : SingleObj (Equiv.Perm (Fin n)) ⥤ K :=
  SingleObj.functor (permEnd C n)

variable (C : K) (n : ℕ)

omit [CartesianMonoidalCategory K] in