---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Grassmannian.freeCompareEquiv
docstring: 'The value-level comparison between the relative Grassmannian of the free

  module and the merged absolute Grassmannian functor.'
file: AlgebraicJacobian/Picard/GrassmannianRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Grassmannian.freeCompareEquiv
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def freeCompareEquiv (d r : ℕ) (T : Over S) :
    Quotient (Scheme.LocallyFreeQuotient.setoid
      (SheafOfModules.free (R := S.ringCatSheaf) (Fin r)) d T) ≃
    Quotient (AlgebraicGeometry.Grassmannian.rqSetoid r d T.left) where
  toFun := Quotient.map Scheme.LocallyFreeQuotient.toRankQuotient
    (fun _ _ h => Scheme.LocallyFreeQuotient.toRankQuotient_rel h)
  invFun := Quotient.map Scheme.LocallyFreeQuotient.ofRankQuotient
    (fun _ _ h => Scheme.LocallyFreeQuotient.ofRankQuotient_rel h)
  left_inv := fun z => by
    induction z using Quotient.ind with
    | _ x =>
      refine Quotient.sound ⟨Iso.refl _, ?_⟩
      change ((Scheme.Modules.pullbackFreeIso T.hom (Fin r)).hom ≫
          ((Scheme.Modules.pullbackFreeIso T.hom (Fin r)).inv ≫ x.q)) ≫ 𝟙 _
        = x.q
      rw [Category.comp_id, Iso.hom_inv_id_assoc]
  right_inv := fun z => by
    induction z using Quotient.ind with
    | _ x =>
      refine Quotient.sound ⟨Iso.refl _, ?_⟩
      change ((Scheme.Modules.pullbackFreeIso T.hom (Fin r)).inv ≫
          ((Scheme.Modules.pullbackFreeIso T.hom (Fin r)).hom ≫ x.q)) ≫ 𝟙 _
        = x.q
      rw [Category.comp_id, Iso.inv_hom_id_assoc]

set_option backward.isDefEq.respectTransparency false in
omit [IsLocallyNoetherian S] in