---
author: sync
content_type: theorem
created: '2026-07-19T20:01:15'
decl: AlgebraicGeometry.exists_windowCompare_ne_zero_of_divUniversalFibreKM_ne_bot
docstring: '**The bridge** (I-0254 wall A, span level): if the fibre window `divUniversalFibreKM`

  at a field point `K` of the tower `R_{I,J} → R_Z → K` is nonzero, then some universal

  window vector `x ∈ divUniversalFstWindow` survives the fibre comparison

  (`windowCompare R_Z K x ≠ 0`) and its window image `relThetaWindowEquiv … x` is
  a relative

  seed section (it lies in `divUniversalSeedK`).  This realizes fibre-window data
  by a

  relative seed section without a pointwise `thetaFieldRead ↔ divFamPhi` naturality
  square:

  the seam `divUniversalFibreKM_eq_span` already carries the base change, and a nonzero
  span

  must have a nonzero generator.'
file: AlgebraicJacobian/Picard/DivSchemeSeedUnivBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_windowCompare_ne_zero_of_divUniversalFibreKM_ne_bot
type: lean
updated: '2026-07-19T20:01:15'
---
theorem exists_windowCompare_ne_zero_of_divUniversalFibreKM_ne_bot
    (hne : divUniversalFibreKM C hπ g r₁ r₂ b₁ i j K ≠ ⊥) :
    ∃ x ∈ (divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule,
      windowCompare
          (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) K x ≠ 0 ∧
      relThetaWindowEquiv C
          (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
          π (windowM_choice π hπ g) (relThetaPairH1_windowM C π hπ g) x
        ∈ divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j := by
  by_contra hcon
  refine hne ((divUniversalFibreKM_eq_bot_iff C hπ g r₁ r₂ b₁ b₂ i j K).mpr (fun x hx => ?_))
  by_contra hx0
  exact hcon ⟨x, hx, hx0, Submodule.mem_map_of_mem hx⟩

end Bridge

/-! ## The seed-prime instantiation (I-0254 wall A, at every `p : Spec R_Z`) -/

section SeedPrime

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]

noncomputable local instance instOverCleftSeedPrimeBridge : C.left.Over (Spec (.of k)) :=
  ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k
  ↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
variable (b₂ : Module.Basis (Fin r₂) k
  ↥(Scheme.divisorSections k ((windowS_choice π hπ g • fiberWeilDivisor π)
    + (windowM_choice π hπ g • fiberWeilDivisor π)) ⊤))
variable (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)

noncomputable local instance instIsIntegralRelCurveSeedPrimeBridge (L : Type u) [Field L]
    [Algebra k L] : IsIntegral (relCurve C L) := instIsIntegralBaseChange C L

noncomputable local instance instSmoothRelCurveSeedPrimeBridge (L : Type u) [Field L]
    [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance instQCRelCurveSeedPrimeBridge (L : Type u) [Field L]
    [Algebra k L] : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance instLFTRelCurveSeedPrimeBridge (L : Type u) [Field L]
    [Algebra k L] : LocallyOfFiniteType (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  haveI : Smooth (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    SmoothOfRelativeDimension.smooth 1 _
  inferInstance

noncomputable local instance instFinH0RelCurveSeedPrimeBridge (L : Type u) [Field L]
    [Algebra k L] : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L

noncomputable local instance instFinH1RelCurveSeedPrimeBridge (L : Type u) [Field L]
    [Algebra k L] : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

set_option maxHeartbeats 2400000 in
-- the seed-base residue-field tower `k → R_{I,J} → R_Z → κ(p)` drives the `windowCompare`
-- and `divUniversalFibreKM` defeq/instance chains past the defaults (recorded hatch)
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
set_option maxRecDepth 8000 in
set_option linter.unusedSectionVars false in