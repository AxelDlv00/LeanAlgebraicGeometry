---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleShortComplex_shortExact
docstring: 'The short complex `0 → R[X₁] → R[X₂] ⊞ R[X₃] → R[X₄] → 0` of free sheaves
  of

  `R`-modules on a Mayer–Vietoris square is short exact.'
file: AlgebraicJacobian/RiemannRoch/Ledger/MayerVietoris.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.GrothendieckTopology.MayerVietorisSquare.moduleShortComplex_shortExact
type: lean
updated: '2026-07-28T18:12:20'
---
lemma moduleShortComplex_shortExact : (S.moduleShortComplex R).ShortExact where
  exact := S.moduleShortComplex_exact R

variable {R S}
variable (F : Sheaf J (ModuleCat.{u} R))

section DegreeZero

/-! ### Degree 0: the sheaf condition

Exactness of `0 → F(X₄) → F(X₂) × F(X₃) → F(X₁)` is the sheaf condition of the square
and needs no `Ext`. -/

omit [HasSheafify J (ModuleCat.{u} R)] in