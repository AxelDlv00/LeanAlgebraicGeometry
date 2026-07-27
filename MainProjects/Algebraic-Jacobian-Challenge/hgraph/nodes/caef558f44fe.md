---
author: sync
content_type: theorem
created: '2026-07-27T19:08:27'
decl: AlgebraicGeometry.appLE_fromSpecResidueField_apply
docstring: '**Global sections of the residue-field point is the residue map.**  Under

  the identifications `Γ(Spec R, ⊤) ≅ R` (`Scheme.ΓSpecIso`) and

  `κ(t) ≅ Γ(Spec κ(t), ⊤)` (`specResidueFieldRingEquiv`), the ring map induced on

  global sections by `(Spec R).fromSpecResidueField t : Spec κ(t) ⟶ Spec R` is the

  residue map `algebraMap R κ(t)`.


  This is the `happ` step currently buried inside

  `exists_point_appLE_fromSpecResidueField_of_isMaximal`

  (`Picard/RigidPushforwardFiberChart.lean` §9), exported here because it is

  exactly the compatibility hypothesis `hστ` of

  `finrank_tensor_eq_of_ringEquiv`.'
file: AlgebraicJacobian/Picard/RigidPushforwardRank.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.appLE_fromSpecResidueField_apply
type: lean
updated: '2026-07-27T19:08:27'
---
theorem appLE_fromSpecResidueField_apply (R : CommRingCat.{u}) (t : Spec R)
    (x : Γ(Spec R, ⊤)) :
    (((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top).hom x
      = specResidueFieldRingEquiv R t
          (algebraMap R t.asIdeal.ResidueField
            ((Scheme.ΓSpecIso R).commRingCatIsoToRingEquiv x)) := by
  have hnat : ∀ {A B : CommRingCat.{u}} (φ : A ⟶ B),
      (Spec.map φ).appTop = (Scheme.ΓSpecIso A).hom ≫ φ ≫ (Scheme.ΓSpecIso B).inv := by
    intro A B φ
    rw [← Category.assoc, ← Scheme.ΓSpecIso_naturality φ, Category.assoc,
      Iso.hom_inv_id, Category.comp_id]
  have hfac : ((Spec R).fromSpecResidueField t).appTop =
      (Scheme.ΓSpecIso R).hom ≫ CommRingCat.ofHom (algebraMap R t.asIdeal.ResidueField) ≫
        (Scheme.Spec.residueFieldIso R t).inv ≫
        (Scheme.ΓSpecIso ((Spec R).residueField t)).inv := by
    rw [← Scheme.Spec.map_residueFieldIso_inv_eq_fromSpecResidueField R t,
      Scheme.Hom.comp_appTop, hnat, hnat]
    simp only [Category.assoc, Iso.inv_hom_id_assoc]
    rfl
  have hLE : ((Spec R).fromSpecResidueField t).appLE ⊤ ⊤ le_top =
      ((Spec R).fromSpecResidueField t).appTop := Scheme.Hom.appLE_eq_app _
  rw [hLE, hfac]
  simp only [CommRingCat.hom_comp, RingHom.comp_apply, CommRingCat.hom_ofHom]
  rfl

/-! ## §3 (Brick C). The fibre-chart Čech square, concluded on kernels -/

section BrickC

variable {X Y : Scheme.{u}}

set_option maxHeartbeats 1600000 in
-- Heartbeat headroom: the statement carries six `letI` module structures, so
-- matching the three chart comparisons against the Čech square forces large
-- `isDefEq` checks.  Measured: this is the only declaration in the file that
-- exceeds the default budget (`synthInstance.maxHeartbeats` is never hit).