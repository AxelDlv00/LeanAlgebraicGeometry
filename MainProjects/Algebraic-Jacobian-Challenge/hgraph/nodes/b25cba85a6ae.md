---
author: sync
content_type: theorem
created: '2026-07-30T07:02:15'
decl: AlgebraicGeometry.Scheme.comp_eq_specMap_algebraMap_of_factorization
docstring: '**The factorising morphism really is a `k''`-morphism.** From §4''s factorization
  equation plus

  `hp`, the map `q` satisfies `q ≫ f = Spec.map (algebraMap k k'')` — i.e. `q` is
  a point of `X`

  *over* `Spec k''`, which is what "the point is defined over `k''`" means.


  The step is cancellation against an epi: `Spec.map` of the field inclusion `k''
  ↪ k^s` is flat and

  surjective, hence epi (`Flat.epi_of_flat_of_surjective`). Note it needs **no** finiteness
  and no

  `LocallyOfFiniteType` — it is about the two triangles only.'
file: AlgebraicJacobian/Curve/FiniteLevelRationalPoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.comp_eq_specMap_algebraMap_of_factorization
type: lean
updated: '2026-07-30T07:02:15'
---
theorem comp_eq_specMap_algebraMap_of_factorization {k : Type u} [Field k] {X : Scheme.{u}}
    (f : X ⟶ Spec (CommRingCat.of k))
    (p : Spec (CommRingCat.of (SeparableClosure k)) ⟶ X)
    (hp : p ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k (SeparableClosure k))))
    (k' : IntermediateField k (SeparableClosure k)) (q : Spec (CommRingCat.of k') ⟶ X)
    (hq : Spec.map (CommRingCat.ofHom (k'.val.toRingHom)) ≫ q = p) :
    q ≫ f = Spec.map (CommRingCat.ofHom (algebraMap k k')) := by
  have hepi : Epi (Spec.map (CommRingCat.ofHom (k'.val.toRingHom))) :=
    Flat.epi_of_flat_of_surjective (Spec.map (CommRingCat.ofHom k'.val.toRingHom))
  apply hepi.left_cancellation
  rw [← Category.assoc, hq, hp, specMap_val_comp_specMap_algebraMap]