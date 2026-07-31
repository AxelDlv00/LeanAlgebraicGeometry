---
author: sync
content_type: theorem
created: '2026-07-17T16:57:14'
decl: AlgebraicGeometry.Scheme.Hom.faithfulSMul_pullbackSections
docstring: '**Injectivity of the chart extension** (EV-2 leg 2): for a morphism of
  integral

  schemes hitting the generic point, the pullback of sections on a chart around `η_Y`
  is

  injective — the generic germ of the pulled section is the function-field image of
  the

  generic germ, `functionFieldMap` is injective, and generic germs on integral schemes
  are

  injective.'
file: AlgebraicJacobian/RiemannRoch/DegreePullbackDictionary.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.Hom.faithfulSMul_pullbackSections
type: lean
updated: '2026-07-31T20:14:51'
---
theorem Scheme.Hom.faithfulSMul_pullbackSections [IsIntegral X] [IsIntegral Y]
    (hf : f.base (genericPoint X) = genericPoint Y) {V : Y.Opens}
    (hη : genericPoint Y ∈ V) :
    letI := f.pullbackSectionsAlgebra V
    FaithfulSMul Γ(Y, V) Γ(X, f ⁻¹ᵁ V) := by
  letI := f.pullbackSectionsAlgebra V
  have hηW : genericPoint X ∈ f ⁻¹ᵁ V := by
    change f.base (genericPoint X) ∈ V
    rw [hf]
    exact hη
  refine (faithfulSMul_iff_algebraMap_injective Γ(Y, V) Γ(X, f ⁻¹ᵁ V)).mpr ?_
  have happ : f.appLE V (f ⁻¹ᵁ V) le_rfl = f.app V := Scheme.Hom.appLE_eq_app f
  intro a b hab
  change (f.appLE V (f ⁻¹ᵁ V) le_rfl).hom a = (f.appLE V (f ⁻¹ᵁ V) le_rfl).hom b at hab
  rw [happ] at hab
  have hgerm : (f.functionFieldMap hf).hom
        ((Y.presheaf.germ V (genericPoint Y) hη).hom a)
      = (f.functionFieldMap hf).hom
        ((Y.presheaf.germ V (genericPoint Y) hη).hom b) := by
    rw [f.functionFieldMap_germ hf V hη hηW a, f.functionFieldMap_germ hf V hη hηW b, hab]
  exact germ_injective_of_isIntegral Y (genericPoint Y) hη
    (f.functionFieldMap_injective hf hgerm)

end Legs

/-! ## EV-2: the generic-rank dictionary -/

section Keystone

variable {X Y : Scheme.{u}}