---
author: sync
content_type: theorem
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.Modules.annihilator_tensorObj_eq_right_of_isLocallyTrivial
docstring: 'Tensoring on the left by a line bundle preserves the annihilator exactly.

  The reverse inclusion tensors once more by a tensor inverse of the line bundle

  and contracts the inverse pair.'
file: AlgebraicJacobian/Picard/DivGrassmannianEmbedding.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.annihilator_tensorObj_eq_right_of_isLocallyTrivial
type: lean
updated: '2026-08-01T04:12:00'
---
theorem annihilator_tensorObj_eq_right_of_isLocallyTrivial
    {X : Scheme.{u}} (L F : X.Modules)
    (hL : LineBundle.IsLocallyTrivial L) :
    annihilator (tensorObj L F) = annihilator F := by
  obtain ⟨Linv, _hLinv, ⟨e⟩⟩ := exists_tensorObj_inverse hL
  apply le_antisymm
  · calc
      annihilator (tensorObj L F) ≤
          annihilator (tensorObj Linv (tensorObj L F)) :=
        annihilator_le_annihilator_tensorObj_right Linv (tensorObj L F)
      _ = annihilator F := annihilator_eq_of_iso
        (tensorObj_assoc_iso.symm ≪≫
          tensorObjIsoOfIso (tensorObj_braiding Linv L ≪≫ e) (Iso.refl F) ≪≫
          tensorObj_left_unitor F)
  · exact annihilator_le_annihilator_tensorObj_right L F