---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.grFunctorAffineEquiv
docstring: '**The affine comparison**: on an affine test `overSpec k A`, the vehicle
  value of

  the Grassmannian functor is the affine value `G(d, A ⊗[k] H; A)` — the affine-opens

  poset has a top element, so the limit collapses (the `picEtAffineEquiv` pattern).'
file: AlgebraicJacobian/Picard/GrassmannianFunctor.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.grFunctorAffineEquiv
type: lean
updated: '2026-07-31T20:15:25'
---
noncomputable def grFunctorAffineEquiv :
    grFunctor k H d (overSpec k A) ≃ grFunctorAff k H d A where
  toFun := grFunctorToAff k H d A
  invFun := grFunctorOfAff k H d A
  left_inv s := by
    refine grFunctor.ext fun U => ?_
    change Module.Grassmannian.map
        ((Over.resAlgHom (overSpec k A) le_top).comp
          (Over.overSpecΓTopAlgEquiv k A).symm.toAlgHom)
        (Module.Grassmannian.map (Over.overSpecΓTopAlgEquiv k A).toAlgHom
          (s.1 (overSpecTopAffine A)))
      = s.1 U
    rw [← Module.Grassmannian.map_comp, AlgHom.comp_assoc,
      show (Over.overSpecΓTopAlgEquiv k A).symm.toAlgHom.comp
          (Over.overSpecΓTopAlgEquiv k A).toAlgHom
        = AlgHom.id k Γ((overSpec k A).left, ⊤) from
        AlgHom.ext fun x => (Over.overSpecΓTopAlgEquiv k A).symm_apply_apply x,
      AlgHom.comp_id]
    exact s.compat U (overSpecTopAffine A) le_top
  right_inv N := by
    change Module.Grassmannian.map (Over.overSpecΓTopAlgEquiv k A).toAlgHom
        (Module.Grassmannian.map
          ((Over.resAlgHom (overSpec k A) le_top).comp
            (Over.overSpecΓTopAlgEquiv k A).symm.toAlgHom) N)
      = N
    rw [← Module.Grassmannian.map_comp, ← AlgHom.comp_assoc, Over.resAlgHom_rfl,
      AlgHom.comp_id,
      show (Over.overSpecΓTopAlgEquiv k A).toAlgHom.comp
          (Over.overSpecΓTopAlgEquiv k A).symm.toAlgHom
        = AlgHom.id k A from
        AlgHom.ext fun x => (Over.overSpecΓTopAlgEquiv k A).apply_symm_apply x]
    exact grFunctorAff_map_id A N