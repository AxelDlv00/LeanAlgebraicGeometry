---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GroupScheme.identityComponentSubgroupFunctor
docstring: 'The presheaf of groups `T ↦ {f : T ⟶ G | im f ⊆ G⁰}`.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.GroupScheme.identityComponentSubgroupFunctor
type: lean
updated: '2026-07-28T13:22:16'
---
private noncomputable def identityComponentSubgroupFunctor :
    (Over (Spec (.of k)))ᵒᵖ ⥤ GrpCat.{u} where
  obj T := GrpCat.of (identityComponentSubgroup G T.unop)
  map {T T'} φ := GrpCat.ofHom
    { toFun := fun f => ⟨φ.unop ≫ f.1, (range_comp_left_subset _ _).trans f.2⟩
      map_one' := Subtype.ext (by
        change φ.unop ≫ (1 : T.unop ⟶ G) = (1 : T'.unop ⟶ G)
        simp only [Hom.one_def]
        rw [← Category.assoc, comp_toUnit])
      map_mul' := fun f g => Subtype.ext (by
        change φ.unop ≫ (f.1 * g.1) = (φ.unop ≫ f.1) * (φ.unop ≫ g.1)
        simp only [Hom.mul_def]
        rw [← Category.assoc, comp_lift]) }
  map_id T := by
    ext f
    exact Category.id_comp _
  map_comp {T T' T''} φ ψ := by
    ext f
    exact Category.assoc _ _ _