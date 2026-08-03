---
author: sync
content_type: theorem
created: '2026-08-03T11:10:50'
decl: AlgebraicGeometry.Scheme.Hom.fiberEulerIndex_eq_cech
docstring: 'A two-affine cover of the fibre computes `fiberEulerIndex` for a

  quasicoherent module.  This is an equality with the concrete signed

  kernel/quotient-by-range index; it does not assert finite-dimensionality.'
file: AlgebraicJacobian/Picard/FiberEulerIndex.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Hom.fiberEulerIndex_eq_cech
type: lean
updated: '2026-08-03T11:10:50'
---
theorem Hom.fiberEulerIndex_eq_cech (f : X ⟶ S) (s : S)
    (M : X.Modules) [M.IsQuasicoherent]
    (V : (f.fiber s).AffineCoverMVSquare) :
    f.fiberEulerIndex s M =
      V.chi (Over.mk (f.fiberToSpecResidueField s)) (f.fiberModule s M) := by
  haveI : (f.fiberModule s M).IsQuasicoherent := f.fiberModule_isQuasicoherent s M
  unfold Hom.fiberEulerIndex
  exact @AffineCoverMVSquare.chi_toModuleKSheafOfModules_eq _ _
    (Over.mk (f.fiberToSpecResidueField s)) V (f.fiberModule s M) this