---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.gluedSubordCocycle_isCohomologous
docstring: '**Two subordinations of the same cover give cohomologous cocycles**, through
  the

  `0`-cochain `x ↦ g (σ'' x) (σ x)` (the cocycle law makes the coboundary law hold).'
file: AlgebraicJacobian/Cohomology/GluedSheafClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedSubordCocycle_isCohomologous
type: lean
updated: '2026-08-01T09:44:09'
---
lemma gluedSubordCocycle_isCohomologous (hc : Scheme.IsGluingCocycle U g)
    (𝒲 : X.PointedCover) (σ σ' : X → J) (hσ : ∀ x : X, 𝒲.opens x ≤ U (σ x))
    (hσ' : ∀ x : X, 𝒲.opens x ≤ U (σ' x)) :
    (gluedSubordCocycle hc 𝒲 σ hσ).IsCohomologous (gluedSubordCocycle hc 𝒲 σ' hσ') := by
  refine Scheme.unitsCocycle_isCohomologous
    (fun x => X.unitsRestrict (le_inf (hσ' x) (hσ x) : 𝒲.opens x ≤ U (σ' x) ⊓ U (σ x))
      (g (σ' x) (σ x))) (fun x y => ?_)
  refine Units.ext ?_
  rw [Units.val_mul, Units.val_mul, gluedSubordCocycle_evInf, gluedSubordCocycle_evInf,
    coe_unitsRestrict, coe_unitsRestrict, gluedSubordUnit, gluedSubordUnit,
    coe_unitsRestrict, coe_unitsRestrict, coe_unitsRestrict, coe_unitsRestrict]
  simp only [Scheme.resHom_resHom]
  have hL : X.resHom (le_inf ((inf_le_left.trans (hσ' x)))
        ((inf_le_left.trans (hσ x))) :
        𝒲.opens x ⊓ 𝒲.opens y ≤ U (σ' x) ⊓ U (σ x)) (g (σ' x) (σ x) : Γ(X, _)) *
      X.resHom (le_inf (inf_le_left.trans (hσ x)) (inf_le_right.trans (hσ y)))
        (g (σ x) (σ y) : Γ(X, _)) =
      X.resHom (le_inf (inf_le_left.trans (hσ' x)) (inf_le_right.trans (hσ y)))
        (g (σ' x) (σ y) : Γ(X, _)) :=
    hc.mul_res_of_le (le_inf (le_inf (inf_le_left.trans (hσ' x))
      (inf_le_left.trans (hσ x))) (inf_le_right.trans (hσ y)))
  have hR : X.resHom (le_inf ((inf_le_left.trans (hσ' x)))
        ((inf_le_right.trans (hσ' y))) :
        𝒲.opens x ⊓ 𝒲.opens y ≤ U (σ' x) ⊓ U (σ' y)) (g (σ' x) (σ' y) : Γ(X, _)) *
      X.resHom (le_inf (inf_le_right.trans (hσ' y)) (inf_le_right.trans (hσ y)))
        (g (σ' y) (σ y) : Γ(X, _)) =
      X.resHom (le_inf (inf_le_left.trans (hσ' x)) (inf_le_right.trans (hσ y)))
        (g (σ' x) (σ y) : Γ(X, _)) :=
    hc.mul_res_of_le (le_inf (le_inf (inf_le_left.trans (hσ' x))
      (inf_le_right.trans (hσ' y))) (inf_le_right.trans (hσ y)))
  exact hL.trans hR.symm