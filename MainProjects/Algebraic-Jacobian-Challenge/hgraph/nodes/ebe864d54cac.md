---
author: sync
content_type: definition
created: '2026-07-30T10:26:46'
decl: AlgebraicGeometry.Scheme.PicScheme.IsGalInvariant
docstring: 'A class on `T_{k''}` fixed by every `γ ∈ Gal(k''/k)`, in `ajc-p1`''s `twistTest`

  spelling.'
file: AlgebraicJacobian/Picard/PicEtDescentRepresentability.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.IsGalInvariant
type: lean
updated: '2026-07-30T10:26:46'
---
def IsGalInvariant (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    (T : Over (Spec (CommRingCat.of k)))
    (x : (picEt C).obj (op ((coverFunctor (k := k) (k' := k')).obj T))) : Prop :=
  ∀ γ : k' ≃ₐ[k] k',
    (picEt C).map (twistTest (k' := k') T γ).op x = x

omit [Algebra.IsSeparable k k'] [Module.Finite k k'] in