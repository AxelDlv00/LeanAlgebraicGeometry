---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.localDualNumberHomEquivCotangentSpaceDual
docstring: '**The tangent space is the dual of the cotangent space** (Kleiman §5,

  Thm. 5.11, first step), in its `κ`-linear form: the dual-number points of a

  `k`-rational point of a local `k`-algebra `R` form the

  `ResidueField R`-linear dual of `m/m²`.'
file: AlgebraicJacobian/Picard/TangentSpaceDualNumbers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.localDualNumberHomEquivCotangentSpaceDual
type: lean
updated: '2026-07-16T21:14:28'
---
noncomputable def localDualNumberHomEquivCotangentSpaceDual :
    {f : R →ₐ[k] DualNumber k // ∀ x ∈ maximalIdeal R, fst (f x) = 0}
      ≃ Module.Dual (ResidueField R) (CotangentSpace R) :=
  (localDualNumberHomEquivCotangentDual hres).trans
    (cotangentDualExtendScalars (R := R)).toEquiv