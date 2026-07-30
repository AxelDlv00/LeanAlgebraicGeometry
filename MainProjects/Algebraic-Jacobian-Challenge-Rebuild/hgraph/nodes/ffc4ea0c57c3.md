---
author: sync
content_type: definition
created: '2026-07-28T14:44:52'
decl: AlgebraicGeometry.AffAdaptation.sectionsInfSelfEquiv
docstring: '**The diagonal overlap colength is the piece colength.**  Restriction
  along

  `pieces i ⊓ pieces i = pieces i` is an algebra isomorphism carrying the overlap
  ideal — whose

  two generators coincide there — onto `span {eqn i}`.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffGlue.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.sectionsInfSelfEquiv
type: lean
updated: '2026-07-30T15:28:06'
---
noncomputable def sectionsInfSelfEquiv (i : D.index) :
    Γ(relCurve C R, D.pieces i ⊓ D.pieces i) ≃ₐ[R] Γ(relCurve C R, D.pieces i) where
  toFun := relResAlgHom C R (le_of_eq (pieces_inf_self i).symm)
  invFun := relResAlgHom C R (le_of_eq (pieces_inf_self i))
  left_inv := fun x => by
    rw [relResAlgHom_apply, relResAlgHom_apply, ← CommRingCat.comp_apply,
      ← Functor.map_comp, ← op_comp, homOfLE_comp]
    simpa using congrFun (congrArg (fun f => (CommRingCat.Hom.hom f))
      (congrArg (relCurve C R).presheaf.map
        (congrArg Quiver.Hom.op (Subsingleton.elim _ (homOfLE le_rfl))))) x
  right_inv := fun x => by
    rw [relResAlgHom_apply, relResAlgHom_apply, ← CommRingCat.comp_apply,
      ← Functor.map_comp, ← op_comp, homOfLE_comp]
    simpa using congrFun (congrArg (fun f => (CommRingCat.Hom.hom f))
      (congrArg (relCurve C R).presheaf.map
        (congrArg Quiver.Hom.op (Subsingleton.elim _ (homOfLE le_rfl))))) x
  map_mul' := map_mul _
  map_add' := map_add _
  commutes' := AlgHom.commutes _

@[simp]