---
author: sync
content_type: theorem
created: '2026-07-23T23:01:57'
decl: AlgebraicGeometry.divUniversalHighWindowRelationBasisStep_fibre_conjugacy
docstring: 'One relative relation-basis step becomes multiplication by the corresponding

  member of the scalar-extended multiplier basis on canonical fibre windows.'
file: AlgebraicJacobian/Picard/DivSchemeHighWindowRelationKoszulConjugacy.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.divUniversalHighWindowRelationBasisStep_fibre_conjugacy
type: lean
updated: '2026-07-29T15:31:40'
---
theorem divUniversalHighWindowRelationBasisStep_fibre_conjugacy (n : Nat)
    [Module.Projective RZ (Amb[n] ⧸ Kr[n])]
    [Module.Projective RZ (Amb[n + 1] ⧸ Kr[n + 1])]
    (himage : DivUniversalHighWindowFibreImage
      C hpi g r1 r2 b1 b2 i j K hO hchi hker n)
    (himageNext : DivUniversalHighWindowFibreImage
      C hpi g r1 r2 b1 b2 i j K hO hchi hker (n + 1))
    (t : HI) (x : K ⊗[RZ] ↥Kr[n]) :
    divUniversalHighWindowRelationFibreEquiv
        C hpi g r1 r2 b1 b2 i j K hO hchi hker (n + 1) himageNext
        (LinearMap.baseChange K
          (divUniversalHighWindowRelationBasisStep (C := C) (pi := pi)
            hpi g r1 r2 b1 b2 i j n t) x) =
      Scheme.finiteMulStepTo
        (Scheme.divisorSections K (windowS C K hpi g) ⊤) HF[n] HF[n + 1]
        (divUniversalMultiplierFibreBasis (pi := pi) C hpi g K)
        (fun s z => Scheme.mul_mem_divisorSections_highWindow
          (windowN C K hpi g) (windowS C K hpi g) Dᵤ n
          (divUniversalMultiplierFibreBasis (pi := pi) C hpi g K s) z)
        t
        (divUniversalHighWindowRelationFibreEquiv
          C hpi g r1 r2 b1 b2 i j K hO hchi hker n himage x) := by
  have hsub :
      Kr[n + 1].subtype.comp
          (divUniversalHighWindowRelationBasisStep (C := C) (pi := pi)
            hpi g r1 r2 b1 b2 i j n t) =
        divUniversalHighWindowMulRow (C := C) (pi := pi)
          hpi g r1 r2 b1 b2 i j n Kr[n] t := by
    apply LinearMap.ext
    intro z
    rfl
  have hbcx := LinearMap.congr_fun (congrArg (LinearMap.baseChange K) hsub) x
  simp only [LinearMap.baseChange_comp, LinearMap.comp_apply] at hbcx
  apply Subtype.ext
  rw [divUniversalHighWindowRelationFibreEquiv_coe, hbcx]
  simpa only [divUniversalHighWindowClosedAmbientFibreRead_apply,
    Scheme.finiteMulStepTo_apply] using
    (divUniversalHighWindowMulRow_fibre_conjugacy
      (C := C) (pi := pi) hpi g r1 r2 b1 b2 i j K hO hchi hker
        n himage t x)

set_option maxHeartbeats 4800000 in
-- The map equation combines two dependent finite-product conjugacy squares.
set_option synthInstance.maxHeartbeats 1200000 in
-- Consecutive projective fibres and their Koszul sources share a deep scalar tower.
set_option maxRecDepth 24000 in