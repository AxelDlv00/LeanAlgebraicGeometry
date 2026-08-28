---
author: sync
content_type: definition
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.Over.diagonalComplement
docstring: '**The complement of the diagonal**, as an open of the curve square: the
  off-diagonal

  member of the diagonal cover (worksheet D4), on which the local equation of the
  diagonal

  divisor is `1`.'
file: AlgebraicJacobian/Curve/DiagonalClosed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.diagonalComplement
type: lean
updated: '2026-08-01T09:44:10'
---
noncomputable def diagonalComplement : (C ⊗ C).left.Opens :=
  ⟨(Set.range (diagonal C).left.base)ᶜ, (isClosed_range_diagonal C).isOpen_compl⟩