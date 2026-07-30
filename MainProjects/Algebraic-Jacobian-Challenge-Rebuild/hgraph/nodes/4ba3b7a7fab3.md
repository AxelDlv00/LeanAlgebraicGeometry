---
author: sync
content_type: theorem
created: '2026-07-31T00:01:01'
decl: AlgebraicGeometry.exists_separableClosure_finSubext_point
docstring: 'Every challenge curve has a point over a finite subextension of its separable
  closure.


  First take a point of the base-changed curve over a separable closure, using smooth
  relative

  dimension one and geometric irreducibility for nonemptiness.  Its projection to
  `C` spreads to a

  finite stage by `exists_finiteSubextension_point_of_point`; every such stage inside
  the separable

  closure is separable.  Keeping the stage bundled is what permits the normal-closure
  enlargement

  in `exists_finite_galois_point`.'
file: AlgebraicJacobian/Picard/Pic0FiniteSeparablePoint.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_separableClosure_finSubext_point
type: lean
updated: '2026-07-31T00:01:01'
---
theorem exists_separableClosure_finSubext_point {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    ∃ L : FinSubext k (SeparableClosure k), Nonempty (overSpec k L.1 ⟶ C) := by
  let Omega := SeparableClosure k
  letI : Algebra.IsAlgebraic k Omega :=
    separableClosure.isAlgebraic k (AlgebraicClosure k)
  letI : Algebra.IsSeparable k Omega :=
    separableClosure.isSeparable k (AlgebraicClosure k)
  letI : SmoothOfRelativeDimension 1 (baseChangeBundle C Omega).hom :=
    instSmoothOfRelativeDimensionBaseChangeBundle C Omega
  letI : GeometricallyIrreducible (baseChangeBundle C Omega).hom :=
    instGeometricallyIrreducibleBaseChangeBundle C Omega
  obtain ⟨q, hq⟩ :=
    SeparablyClosed.exists_rationalPoint_of_smoothOfRelativeDimension_one
      (baseChangeBundle C Omega).hom
  let fst' : (baseChangeBundle C Omega).left ⟶ C.left :=
    pullback.fst C.hom (overSpec k Omega).hom
  let a : Spec (.of Omega) ⟶ C.left := q ≫ fst'
  have hcond : fst' ≫ C.hom =
      (baseChangeBundle C Omega).hom ≫ (overSpec k Omega).hom :=
    pullback.condition
  have haOver : a ≫ C.hom = (overSpec k Omega).hom := by
    dsimp only [a]
    rw [Category.assoc, hcond, ← Category.assoc]
    rw [hq, Category.id_comp]
  have ha : a ≫ C.hom =
      Spec.map (CommRingCat.ofHom (algebraMap k Omega)) :=
    haOver.trans (overSpec_hom k Omega)
  obtain ⟨L, hp⟩ := exists_finiteSubextension_point_of_point a ha
  exact ⟨L, hp⟩