---
author: sync
content_type: lemma
created: '2026-08-01T04:12:00'
decl: AlgebraicGeometry.Scheme.Modules.fromSpec_restrict_ring_section
docstring: 'The section-ring comparison for the canonical spectrum chart commutes
  with

  restriction from the affine open to every open of its spectrum model.'
file: AlgebraicJacobian/Picard/AffineOpenStalkLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.fromSpec_restrict_ring_section
type: lean
updated: '2026-08-01T04:12:00'
---
lemma fromSpec_restrict_ring_section
    {U : X.Opens} (hU : IsAffineOpen U)
    (V : (Spec Γ(X, U)).Opens) (r : Γ(X, U)) :
    let j := hU.fromSpec
    let eT : j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) = U :=
      (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
    let hVU : j ''ᵁ V ≤ U := (j.image_mono le_top).trans_eq eT
    (j.appIso V).inv.hom
        (((Spec Γ(X, U)).presheaf.map (homOfLE (le_top : V ≤ ⊤)).op).hom
          ((Scheme.ΓSpecIso Γ(X, U)).inv.hom r)) =
      (X.presheaf.map (homOfLE hVU).op).hom r := by
  let j := hU.fromSpec
  let eT : j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) = U :=
    (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
  let hVU : j ''ᵁ V ≤ U := (j.image_mono le_top).trans_eq eT
  have hnat := j.appIso_inv_naturality
    (homOfLE (le_top : V ≤ (⊤ : (Spec Γ(X, U)).Opens))).op
  have happ := ConcreteCategory.congr_hom hnat
    ((Scheme.ΓSpecIso Γ(X, U)).inv.hom r)
  simp only [CategoryTheory.comp_apply] at happ
  rw [← fromSpec_restrict_ring_section_top hU eT r] at happ
  refine happ.trans ?_
  rw [← ConcreteCategory.comp_apply, ← X.presheaf.map_comp]
  congr 1

set_option backward.isDefEq.respectTransparency false in