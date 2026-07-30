---
author: sync
content_type: theorem
created: '2026-07-29T15:31:33'
decl: AlgebraicGeometry.epi_pullback_fst_algebraMap
docstring: 'The base change of the field extension morphism `Spec L ⟶ Spec k` along
  an

  arbitrary `k`-scheme `Z` is an **epimorphism** of schemes.


  Both hypotheses of `Flat.epi_of_flat_of_surjective` are stable under base change:

  `Spec L ⟶ Spec k` is flat (a field extension is a flat ring map) and surjective
  (it

  hits the unique point of `Spec k`), so its pullback `pr₁` along `Z ⟶ Spec k` is
  flat

  and surjective too.'
file: AlgebraicJacobian/Albanese/BaseFieldFaithful.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.epi_pullback_fst_algebraMap
type: lean
updated: '2026-07-30T15:45:59'
---
theorem epi_pullback_fst_algebraMap {Z : Scheme.{u}} (g : Z ⟶ Spec (.of k)) :
    Epi (pullback.fst g (Spec.map (CommRingCat.ofHom (algebraMap k L)))) := by
  haveI : Flat (pullback.fst g (Spec.map (CommRingCat.ofHom (algebraMap k L)))) :=
    MorphismProperty.pullback_fst _ _ inferInstance
  haveI : Surjective (pullback.fst g (Spec.map (CommRingCat.ofHom (algebraMap k L)))) :=
    MorphismProperty.pullback_fst _ _ inferInstance
  exact Flat.epi_of_flat_of_surjective _