---
author: sync
content_type: theorem
created: '2026-07-17T10:19:49'
decl: AlgebraicGeometry.geometricallyIrreducible_of_abelSource
docstring: '**G1 (Wave-5 target 3, geometric irreducibility; route GI-(a))**: the
  structure

  morphism of the representing object of a Jacobian datum is geometrically irreducible,

  given any Abel source.  For each field `K/k` and each pullback `Z` of `d.J.hom`
  along

  `y : Spec K ⟶ Spec k`: the base-changed source `D_K` is irreducible (the

  certificate), the comparison morphism `D_K ⟶ Z` induced by `abel` is the base change

  of `abel.left` along `Z ⟶ d.J.left` (pullback pasting), hence surjective, and the

  continuous surjective image of an irreducible space is irreducible.'
file: AlgebraicJacobian/AbelianVariety/AbelSource.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.geometricallyIrreducible_of_abelSource
type: lean
updated: '2026-07-17T10:19:49'
---
theorem geometricallyIrreducible_of_abelSource (a : AbelSourceData d) :
    GeometricallyIrreducible d.J.hom := by
  constructor
  intro K _ y Z fst snd h
  -- the base-changed source `D_K` is irreducible
  haveI : IrreducibleSpace ↥(pullback a.D.hom y) :=
    a.geometricallyIrreducible.geometrically_irreducibleSpace y
      (pullback.fst a.D.hom y) (pullback.snd a.D.hom y)
      (IsPullback.of_hasPullback a.D.hom y)
  -- `D_K` is also the pullback of the composite `abel.left ≫ d.J.hom` along `y`
  have s : IsPullback (pullback.fst a.D.hom y) (pullback.snd a.D.hom y)
      (a.abel.left ≫ d.J.hom) y := by
    rw [Over.w a.abel]
    exact IsPullback.of_hasPullback a.D.hom y
  -- pasting: the induced comparison `D_K ⟶ Z` is the base change of `abel.left`
  -- along `fst : Z ⟶ d.J.left`, hence surjective
  have hsurj := MorphismProperty.of_isPullback (P := @Surjective)
    (IsPullback.of_bot' s h) a.surjective
  exact Function.Surjective.irreducibleSpace (Scheme.Hom.continuous _) hsurj.surj