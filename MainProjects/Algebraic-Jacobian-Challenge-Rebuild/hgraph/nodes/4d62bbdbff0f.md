---
author: sync
content_type: theorem
created: '2026-07-23T14:31:46'
decl: AlgebraicGeometry.divUniversalHighWindowMulRow_fibre_conjugacy
docstring: 'One relative multiplication row becomes multiplication by the corresponding

  member of the scalar-extended fixed multiplier basis.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowMulConjugacy.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowMulRow_fibre_conjugacy
type: lean
updated: '2026-07-30T15:46:02'
---
theorem divUniversalHighWindowMulRow_fibre_conjugacy (n : Nat)
    [Module.Projective RZ (Amb[n] ⧸ Kr[n])]
    (himage : DivUniversalHighWindowFibreImage
      C hpi g r1 r2 b1 b2 i j K hO hchi hker n)
    (t : HI) (x : K ⊗[RZ] ↥Kr[n]) :
    divUniversalHighWindowClosedAmbientFibreRead
        (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K (n + 1)
        (LinearMap.baseChange K
          (divUniversalHighWindowMulRow (C := C) (pi := pi)
            hpi g r1 r2 b1 b2 i j n Kr[n] t) x) =
      (divUniversalMultiplierFibreBasis (pi := pi) C hpi g K t :
          (relCurve C K).functionField) *
        (divUniversalHighWindowRelationFibreEquiv
          C hpi g r1 r2 b1 b2 i j K hO hchi hker n himage x :
            (relCurve C K).functionField) := by
  rw [divUniversalHighWindowClosedAmbientFibreRead_apply,
    divUniversalHighWindowMulRow, LinearMap.baseChange_comp,
    LinearMap.comp_apply,
    divUniversalHighWindowClosedAmbientFibreEquiv_shiftMul,
    divUniversalHighWindowRelationFibreEquiv_coe]
  simp only [divUniversalMultiplierFibreBasis, Module.Basis.map_apply,
    Module.Basis.baseChange_apply]

set_option maxHeartbeats 4000000 in
-- Expanding the finite component sum and its fibre reads exceeds the default budget.
set_option synthInstance.maxHeartbeats 1000000 in
-- Each summand carries the dependent relation-fibre equivalence.
set_option maxRecDepth 20000 in