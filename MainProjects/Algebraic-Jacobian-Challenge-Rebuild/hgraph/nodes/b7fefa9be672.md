---
author: sync
content_type: theorem
created: '2026-07-31T00:01:01'
decl: AlgebraicGeometry.ProbeC7.isOpenImmersion_presheaf_of_injective
docstring: 'THE REPRICING: given coverage, antecedent 1 IS plain elementwise injectivity.'
file: scratch_pic_c_r4/p07.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProbeC7.isOpenImmersion_presheaf_of_injective
type: lean
updated: '2026-07-31T00:01:01'
---
theorem isOpenImmersion_presheaf_of_injective {X : Scheme.{u}}
    (f : yoneda.obj X ⟶ (pic0SigmaSheaf C).1)
    (hinj : ∀ T : Scheme.{u}ᵒᵖ, Function.Injective (f.app T))
    (hcov : Presheaf.IsLocallySurjective Scheme.zariskiTopology f) :
    IsOpenImmersion.presheaf f := by
  letI : IsIso f := by
    haveI := chartIso_of_injective C f hinj hcov
    exact (inferInstance : IsIso ((sheafToPresheaf Scheme.zariskiTopology (Type u)).map
      (chartSheafHom C f)))
  exact MorphismProperty.of_isIso (P := IsOpenImmersion.presheaf) f