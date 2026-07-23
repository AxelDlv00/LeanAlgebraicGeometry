---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.GroupScheme.identityComponentHomEquiv
docstring: 'The natural bijection `(T ⟶ G⁰) ≃ {f : T ⟶ G | im f ⊆ G⁰}`.'
file: AlgebraicJacobian/Picard/IdentityComponent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.GroupScheme.identityComponentHomEquiv
type: lean
updated: '2026-07-24T03:02:11'
---
private noncomputable def identityComponentHomEquiv (T : Over (Spec (.of k))) :
    (T ⟶ IdentityComponent G) ≃ ↥(identityComponentSubgroup G T) where
  toFun u := ⟨u ≫ identityComponentInclusion G,
    (range_comp_left_subset _ _).trans (range_inclusion_left_subset G)⟩
  invFun f := identityComponentFactor G f.1 f.2
  left_inv u := by
    apply Over.OverMorphism.ext
    exact (IsOpenImmersion.lift_uniq (identityComponentCarrier G).ι
      (u ≫ identityComponentInclusion G).left _ u.left rfl).symm
  right_inv f := Subtype.ext (identityComponentFactor_comp G f.1 f.2)