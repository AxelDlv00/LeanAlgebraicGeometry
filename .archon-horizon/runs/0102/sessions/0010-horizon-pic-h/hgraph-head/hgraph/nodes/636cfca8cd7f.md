---
author: sync
content_type: lemma
created: '2026-07-17T10:19:50'
decl: AlgebraicGeometry.thetaToDivisorApp_injective
docstring: 'The section-wise map is injective: the value determines both component
  germs at `η`

  (chart-0 through the definition, chart-1 through `thetaVal_eq_germ_snd`), and germs
  at `η`

  determine sections on the integral `Y`.'
file: AlgebraicJacobian/RiemannRoch/ThetaSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaToDivisorApp_injective
type: lean
updated: '2026-08-01T09:44:18'
---
lemma thetaToDivisorApp_injective {W : Y.Opens} (hηW : genericPoint Y ∈ W) :
    Function.Injective (thetaToDivisorApp K π n hηW) := by
  intro a b hab
  have hval : thetaVal K π n hηW a = thetaVal K π n hηW b := by
    have := congrArg
      (fun t : ↥(divisorSections K (n • fiberWeilDivisor π) W) => (t : Y.functionField)) hab
    rwa [thetaToDivisorApp_coe, thetaToDivisorApp_coe] at this
  refine Subtype.ext (Prod.ext ?_ ?_)
  · have ha : (((fiberCoordUnit π ^ n)⁻¹ : Y.functionFieldˣ) : Y.functionField) *
          (Y.presheaf.germ (W ⊓ fiberChart₀ π) (genericPoint Y)
            ⟨hηW, (genericPoint_mem_preimage_inf π).1⟩).hom a.val.1 =
        (((fiberCoordUnit π ^ n)⁻¹ : Y.functionFieldˣ) : Y.functionField) *
          (Y.presheaf.germ (W ⊓ fiberChart₀ π) (genericPoint Y)
            ⟨hηW, (genericPoint_mem_preimage_inf π).1⟩).hom b.val.1 := hval
    exact germ_injective_of_isIntegral Y (genericPoint Y)
      (show genericPoint Y ∈ W ⊓ fiberChart₀ π from
        ⟨hηW, (genericPoint_mem_preimage_inf π).1⟩)
      (mul_left_cancel₀ (Units.ne_zero ((fiberCoordUnit π ^ n)⁻¹)) ha)
  · have hgerm : (Y.presheaf.germ (W ⊓ fiberChart₁ π) (genericPoint Y)
        ⟨hηW, (genericPoint_mem_preimage_inf π).2⟩).hom a.val.2 =
      (Y.presheaf.germ (W ⊓ fiberChart₁ π) (genericPoint Y)
        ⟨hηW, (genericPoint_mem_preimage_inf π).2⟩).hom b.val.2 :=
      (thetaVal_eq_germ_snd K π n hηW a).symm.trans
        (hval.trans (thetaVal_eq_germ_snd K π n hηW b))
    exact germ_injective_of_isIntegral Y (genericPoint Y)
      (show genericPoint Y ∈ W ⊓ fiberChart₁ π from
        ⟨hηW, (genericPoint_mem_preimage_inf π).2⟩) hgerm

/-! ## The section-wise map is surjective -/