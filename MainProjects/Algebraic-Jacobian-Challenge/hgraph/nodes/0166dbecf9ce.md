---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorObjAssoc_eta_factor
docstring: '**Presheaf-morphism factorization of the associator** (`lem:tensorObjAssoc_eta_factor`).

  As morphisms of presheaves of modules `(A ⊗ₚ B) ⊗ₚ C ⟶ (sheafTensorObj A (sheafTensorObj
  B C)).val`,

  the right-whiskered-unit leg composed with `Γ(tensorObjAssoc)` equals the presheaf
  associator

  `α^p` composed with the left-whiskered-unit leg:

  `(η_{A⊗ₚB} ▷ C ≫ η_{(A⊗B)⊗ₚC}) ≫ Γ(α) = α^p ≫ (A ◁ η_{B⊗ₚC} ≫ η_{A⊗ₚ(B⊗C)})`.

  This is the `η`-naturality-plus-bridge-telescoping identity that lets `Γ(tensorObjAssoc)`
  push the

  presheaf associator through the iterated `sectionsMul`; evaluating it at the top
  open on the

  iterated elementary tensor is what feeds `tensorObjAssoc_hom_sectionsMul`.'
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorObjAssoc_eta_factor
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma tensorObjAssoc_eta_factor (A B C : X.Modules) :
    (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X)
          ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B)))
          ((toPresheafOfModules X).obj C) ≫
        (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj (sheafTensorObj A B)) ((toPresheafOfModules X).obj C))) ≫
        (tensorObjAssoc A B C).hom.val
      = (MonoidalCategory.associator (C := MonoidalPresheaf X)
          ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B)
          ((toPresheafOfModules X).obj C)).hom ≫
        (MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A)
            ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
              (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
                ((toPresheafOfModules X).obj B) ((toPresheafOfModules X).obj C))) ≫
          (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj (sheafTensorObj B C)))) := by
  -- REDUCTION (B4 → sheaf-level core).  `T := toPresheafOfModules X = SheafOfModules.forget` sends
  -- `f ↦ f.val`, and the unit `η` of the sheafification adjunction is natural.  By `η`-naturality
  -- both sides collapse to `η_{(A⊗ₚB)⊗ₚC} ≫ T.map Φ`, and the sheaf-level core
  -- `tensorObjAssoc_eta_factor_sheaf` supplies `Φ_L = Φ_R` (an equation entirely inside the
  -- inherited monoidal structure on `X.Modules`, where the bridge telescoping lives).
  have key := tensorObjAssoc_eta_factor_sheaf A B C
  have hval : (tensorObjAssoc A B C).hom.val
      = (toPresheafOfModules X).map (tensorObjAssoc A B C).hom := rfl
  -- Clean naturality equalities, with the right-adjoint codomain written in `toPresheafOfModules`
  -- form (`restrictScalars (𝟙)` is defeq `𝟭`, so `exact unit.naturality _` bridges the decoration).
  have hnatL :
      MonoidalCategory.whiskerRight (C := MonoidalPresheaf X)
          ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B)))
          ((toPresheafOfModules X).obj C) ≫
        (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj (sheafTensorObj A B)) ((toPresheafOfModules X).obj C))
      = (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B))
            ((toPresheafOfModules X).obj C)) ≫
        (toPresheafOfModules X).map (sheafification.map
          (MonoidalCategory.whiskerRight (C := MonoidalPresheaf X)
            ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
              (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
                ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B)))
            ((toPresheafOfModules X).obj C))) :=
    (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.naturality _
  have hnatA :
      (MonoidalCategory.associator (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B)
            ((toPresheafOfModules X).obj C)).hom ≫
        (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A)
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj B) ((toPresheafOfModules X).obj C)))
      = (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B))
            ((toPresheafOfModules X).obj C)) ≫
        (toPresheafOfModules X).map (sheafification.map
          (MonoidalCategory.associator (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj B)
            ((toPresheafOfModules X).obj C)).hom) :=
    (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.naturality _
  have hnatR :
      MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X)
          ((toPresheafOfModules X).obj A)
          ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj B) ((toPresheafOfModules X).obj C))) ≫
        (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A) ((toPresheafOfModules X).obj (sheafTensorObj B C)))
      = (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
          (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A)
            (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
              ((toPresheafOfModules X).obj B) ((toPresheafOfModules X).obj C))) ≫
        (toPresheafOfModules X).map (sheafification.map
          (MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X)
            ((toPresheafOfModules X).obj A)
            ((PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.app
              (MonoidalCategory.tensorObj (C := MonoidalPresheaf X)
                ((toPresheafOfModules X).obj B) ((toPresheafOfModules X).obj C))))) :=
    (PresheafOfModules.sheafificationAdjunction (𝟙 X.ringCatSheaf.obj)).unit.naturality _
  -- `erw` bridges the `restrictScalars (𝟙)` decoration on the shared middle object
  -- (`η`'s codomain carries it; `tensorObjAssoc`'s domain does not — defeq, but `rw` needs `erw`).
  rw [hval, hnatL]
  erw [Category.assoc, ← Functor.map_comp, key, Functor.map_comp, hnatR]
  erw [← Category.assoc, ← Category.assoc, hnatA]
  rfl