---
author: sync
content_type: theorem
created: '2026-07-30T20:44:27'
decl: AlgebraicGeometry.subsingleton_picEt_of_affine
docstring: '**The scheme-level quantifier reduces to test algebras, componentwise.**


  If `PicEtAff C A` is a subsingleton for every test algebra `A`, then `picEt C T`
  is a

  subsingleton for every test object `T`.


  One line, because `picEt C T` is a subgroup of the product of the `PicEtAff C Γ(T.left,
  U)`

  and `picEt.ext` says two sections agree as soon as they agree at each affine open.'
file: AlgebraicJacobian/Picard/Pic0VanishingRoute.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.subsingleton_picEt_of_affine
type: lean
updated: '2026-07-31T20:14:44'
---
theorem subsingleton_picEt_of_affine
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A], Subsingleton (PicEtAff C A))
    (T : Over (Spec (.of k))) : Subsingleton (picEt C T) :=
  ⟨fun _ _ => picEt.ext fun U => @Subsingleton.elim _ (h Γ(T.left, U.1)) _ _⟩

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (C) in