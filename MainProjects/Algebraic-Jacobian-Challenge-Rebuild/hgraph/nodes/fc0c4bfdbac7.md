---
author: sync
content_type: theorem
created: '2026-08-10T13:01:39'
decl: AlgebraicGeometry.Scheme.Modules.isIso_of_bijective_appTop_of_fromTildeGamma
docstring: 'Global-section form of

  `Scheme.Modules.isIso_of_isIso_moduleSpecGammaFunctor_map_of_fromTildeGamma`.'
file: AlgebraicJacobian/Cohomology/NativePushforwardBaseChangeAffine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isIso_of_bijective_appTop_of_fromTildeGamma
type: lean
updated: '2026-08-18T20:50:51'
---
theorem Scheme.Modules.isIso_of_bijective_appTop_of_fromTildeGamma
    {R : CommRingCat.{u}} {M N : (Spec R).Modules}
    [IsIso M.fromTildeΓ] [IsIso N.fromTildeΓ] (φ : M ⟶ N)
    (h : Function.Bijective (Scheme.Modules.Hom.app φ (⊤ : (Spec R).Opens))) :
    IsIso φ := by
  refine Scheme.Modules.isIso_of_isIso_moduleSpecGammaFunctor_map_of_fromTildeGamma φ ?_
  rw [ConcreteCategory.isIso_iff_bijective]
  have hfun : ⇑(ConcreteCategory.hom ((moduleSpecΓFunctor (R := R)).map φ)) =
      ⇑(ConcreteCategory.hom (Scheme.Modules.Hom.app φ (⊤ : (Spec R).Opens))) := rfl
  rw [hfun]
  exact h