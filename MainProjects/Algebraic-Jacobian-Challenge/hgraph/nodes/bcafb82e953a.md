---
author: sync
content_type: instance
created: '2026-07-30T10:26:46'
decl: AlgebraicGeometry.Scheme.PicScheme.mono_coverMap_of_mono
docstring: 'The cover morphism is a monomorphism whenever `Spec (k''/k)` is — base
  change of

  a mono, reflected into the slice by `Over.forget`.'
file: AlgebraicJacobian/Picard/GaloisDescent/PicEtGaloisBridge.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.mono_coverMap_of_mono
type: lean
updated: '2026-07-30T10:26:46'
---
instance mono_coverMap_of_mono [Mono (specMapAlgebra k k')]
    (T : Over (Spec (CommRingCat.of k))) : Mono (coverMap (k := k) (k' := k') T) := by
  have h : Mono ((Over.forget (Spec (CommRingCat.of k))).map
      (coverMap (k := k) (k' := k') T)) := by
    change Mono (coverMap (k := k) (k' := k') T).left
    rw [coverMap_left]
    exact pullback.fst_of_mono
  exact Functor.mono_of_mono_map _ h