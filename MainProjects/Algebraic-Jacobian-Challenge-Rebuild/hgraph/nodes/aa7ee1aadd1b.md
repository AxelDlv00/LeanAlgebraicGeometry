---
author: sync
content_type: theorem
created: '2026-07-24T10:02:38'
decl: AlgebraicGeometry.windowShiftMul_mem_divisorWindow
docstring: 'Multiplication by a section of the shift window preserves vanishing along
  arbitrary

  local equations.  This is the certificate-free membership core of `divFamEps_carve`.'
file: AlgebraicJacobian/Picard/DivSchemeEpsCarve.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowShiftMul_mem_divisorWindow
type: lean
updated: '2026-07-31T20:15:21'
---
theorem windowShiftMul_mem_divisorWindow
    (d : (relCurve C R).LocalEquations)
    (a : ↥(divisorSections k (windowS_choice π hπ g • fiberWeilDivisor π) ⊤))
    {x : R ⊗[k] ↥(divisorSections k
      (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)}
    (hx : x ∈ divisorWindow d (relThetaPairH1_windowM C π hπ g)) :
    LinearMap.baseChange R (windowShiftMul hπ g a) x ∈
      divisorWindow d (relThetaPairH1_windowMS C π hπ g) := by
  have hmem := (Scheme.LocalEquations.mem_vanishingSubmodule_iff R).mp
    (mem_divisorWindow_iff.mp hx)
  rw [mem_divisorWindow_iff]
  refine (Scheme.LocalEquations.mem_vanishingSubmodule_iff R).mpr
    ⟨fun z hz => ?_, fun z hz => ?_⟩
  · have hkey := relThetaWindowEquiv_sectionMul_fst C π hπ g R a
      (relThetaPairH1_windowM C π hπ g) (relThetaPairH1_windowMS C π hπ g) x
    have heq := germ_resHom_rel (le_inf le_top le_rfl) z hz.2
      ((relThetaWindowEquiv C R π (windowM_choice π hπ g + windowS_choice π hπ g)
        (relThetaPairH1_windowMS C π hπ g)
        (LinearMap.baseChange R (windowShiftMul hπ g a) x)).val.1)
    rw [← heq, hkey, map_mul]
    refine Ideal.mul_mem_left _ _ ?_
    rw [germ_resHom_rel (le_inf le_top le_rfl) z hz.2]
    exact hmem.1 z hz
  · have hkey := relThetaWindowEquiv_sectionMul_snd C π hπ g R a
      (relThetaPairH1_windowM C π hπ g) (relThetaPairH1_windowMS C π hπ g) x
    have heq := germ_resHom_rel (le_inf le_top le_rfl) z hz.2
      ((relThetaWindowEquiv C R π (windowM_choice π hπ g + windowS_choice π hπ g)
        (relThetaPairH1_windowMS C π hπ g)
        (LinearMap.baseChange R (windowShiftMul hπ g a) x)).val.2)
    rw [← heq, hkey, map_mul]
    refine Ideal.mul_mem_left _ _ ?_
    rw [germ_resHom_rel (le_inf le_top le_rfl) z hz.2]
    exact hmem.2 z hz

set_option maxHeartbeats 800000 in
-- Mixed `relCurve`/twist spellings force heavy defeq checks (`respectTransparency false`).
set_option synthInstance.maxHeartbeats 400000 in
set_option maxRecDepth 8000 in