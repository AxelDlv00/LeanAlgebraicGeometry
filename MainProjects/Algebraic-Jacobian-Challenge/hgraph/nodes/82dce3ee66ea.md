---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.Scheme.toModuleKPresheaf
docstring: 'Phase A step 5 main, helper (6): the presheaf of `k`-modules built from

  `O_C` and the structure-morphism algebra structure.'
file: AlgebraicJacobian/Cohomology/StructureSheafModuleK/Presheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.toModuleKPresheaf
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def toModuleKPresheaf (C : Over (Spec (CommRingCat.of k))) :
    (TopologicalSpace.Opens C.left.toTopCat)ᵒᵖ ⥤ ModuleCat.{u} k where
  obj U := ModuleCat.of k (C.left.presheaf.obj U)
  map {U V} f := ModuleCat.ofHom
    { toFun := fun x => (C.left.presheaf.map f).hom x
      map_add' := fun x y => by
        simp [(C.left.presheaf.map f).hom.map_add]
      map_smul' := fun r x => by
        simp only [Algebra.smul_def, RingHom.map_mul, RingHom.id_apply]
        congr 1
        exact AlgebraicGeometry.Scheme.toModuleKSheaf.algebraMap_naturality
          (C := C) f r }
  map_id U := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_id, LinearMap.id_coe, id_eq]
    exact congrFun (congrArg (·.hom) (C.left.presheaf.map_id U)) x
  map_comp {U V W} f g := by
    ext x
    simp only [ConcreteCategory.hom_ofHom, LinearMap.coe_mk, AddHom.coe_mk,
      ModuleCat.hom_comp, LinearMap.coe_comp, Function.comp_apply]
    exact congrFun (congrArg (·.hom) (C.left.presheaf.map_comp f g)) x