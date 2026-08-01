---
author: sync
content_type: theorem
created: '2026-07-30T20:44:25'
decl: AlgebraicGeometry.existsUnique_ofCurve_comp_of_vanishing
docstring: '**S11''s uniqueness clause with the datum supplied rather than assumed.**


  `JacobianData.existsUnique_ofCurve_comp_of_pic0Subgroup_eq_bot` is the upstream
  assembly; it

  takes a datum, the vanishing, surjectivity of the curve''s structure morphism, a
  rational

  point, and the existence half `hex`.  This is the same theorem with the datum *built
  from the

  vanishing*, so the hypotheses are: the vanishing, a nonempty curve, a rational point,
  and `hex`.


  **Not a generalisation of the upstream theorem** (`I-1575`): that one holds at an
  arbitrary `d`,

  and this is its `d := jacobianData_of_vanishing C h` face.  The conclusion''s type
  names that

  carrier, so a consumer holding a different datum must use the upstream form.  What
  is bought is

  that the chain runs from the vanishing alone, with no datum from elsewhere.


  `hex` is Milne I 3.9 and is still open, exactly as upstream.'
file: AlgebraicJacobian/Albanese/Genus0VanishingDatum.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.existsUnique_ofCurve_comp_of_vanishing
type: lean
updated: '2026-08-01T09:44:08'
---
theorem existsUnique_ofCurve_comp_of_vanishing
    (h : ∀ T : Over (Spec (.of k)), pic0Subgroup C T = ⊥) (hs : Surjective C.hom)
    (P : 𝟙_ (Over (Spec (.of k))) ⟶ C) {A : Over (Spec (.of k))} (f : C ⟶ A)
    (hex : ∃ g : (jacobianData_of_vanishing C h).J ⟶ A,
      f = (jacobianData_of_vanishing C h).ofCurve P ≫ g) :
    ∃! g : (jacobianData_of_vanishing C h).J ⟶ A,
      f = (jacobianData_of_vanishing C h).ofCurve P ≫ g :=
  JacobianData.existsUnique_ofCurve_comp_of_pic0Subgroup_eq_bot _ h hs P f hex