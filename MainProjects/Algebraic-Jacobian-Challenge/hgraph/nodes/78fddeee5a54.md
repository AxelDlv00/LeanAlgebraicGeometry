---
author: sync
content_type: definition
created: '2026-07-28T22:30:22'
decl: AlgebraicGeometry.actionDiagram
docstring: '**A ring action, as a one-object diagram in `CommRingCat`.**


  The single value is `A` and the endomorphism at `g` is the ring automorphism `x
  ↦ g • x`.

  A *limit* of this diagram is the invariant subring; dually, a colimit in `CommRingCatᵒᵖ`

  is the affine quotient.'
file: AlgebraicJacobian/Albanese/SymPowInvariants.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.actionDiagram
type: lean
updated: '2026-07-28T22:30:22'
---
noncomputable def actionDiagram (G : Type u) [Group G] (A : Type u) [CommRing A]
    [MulSemiringAction G A] : SingleObj G ⥤ CommRingCat.{u} :=
  SingleObj.functor (M := G) (X := CommRingCat.of A)
    { toFun := fun g => CommRingCat.ofHom (MulSemiringAction.toRingHom G A g)
      map_one' := by apply CommRingCat.hom_ext; ext x; simp
      map_mul' := by
        intro g h
        apply CommRingCat.hom_ext
        ext x
        change (g * h) • x = g • h • x
        rw [mul_smul] }

variable (G : Type u) [Group G] (A : Type u) [CommRing A] [MulSemiringAction G A]

@[simp]