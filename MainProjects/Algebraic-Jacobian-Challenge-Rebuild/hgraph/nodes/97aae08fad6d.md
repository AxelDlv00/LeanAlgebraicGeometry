---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.Scheme.isGluingCocycle_unitsRestrict_evInf
docstring: '**Restricted pair values along an anchored family form a gluing cocycle**:
  for a

  unit cocycle `γ` on a pointed cover `𝒰`, an arbitrary family of opens `U : J → X.Opens`

  and anchor points with `U j ≤ 𝒰.opens (anchor j)`, the restrictions of the pair
  values

  `γ.evInf (anchor i) (anchor j)` to the double overlaps satisfy the gluing cocycle

  law.'
file: AlgebraicJacobian/Cohomology/GluedSheafExtraction.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.isGluingCocycle_unitsRestrict_evInf
type: lean
updated: '2026-07-17T08:41:24'
---
lemma Scheme.isGluingCocycle_unitsRestrict_evInf {𝒰 : X.PointedCover}
    (γ : X.unitsCocycle 𝒰) {J : Type u} (U : J → X.Opens) (anchor : J → X)
    (hanch : ∀ j : J, U j ≤ 𝒰.opens (anchor j)) :
    Scheme.IsGluingCocycle U (fun i j =>
      X.unitsRestrict (inf_le_inf (hanch i) (hanch j))
        (Scheme.unitsEvInf γ (anchor i) (anchor j))) := by
  constructor
  · intro i
    rw [Scheme.unitsEvInf_self γ (anchor i), map_one, Units.val_one]
  · intro i j l
    simp only [coe_unitsRestrict, Scheme.resHom_resHom]
    exact Scheme.unitsEvInf_mul_res_of_le γ (anchor i) (anchor j) (anchor l) _ _ _

end EvInf

/-! ## The affine basic-open refinement of a pointed cover -/