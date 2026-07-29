---
author: sync
content_type: theorem
created: '2026-07-29T22:29:08'
decl: AlgebraicGeometry.Scheme.DivFamily.isQuasicoherent_pushforward
docstring: '**`q_* O_D` is quasi-coherent** when the ambient family is proper.


  Free: properness of `π` gives `QuasiCompact` and `QuasiSeparated` of the projection

  `q = pullback.snd π T.hom` by base change, and pushforward along a qcqs morphism

  preserves quasi-coherence.


  Not a binder of `AlgebraicGeometry.flatLocusStratification_universal`, which asks

  only for `[IsNoetherian S]` and `[F.IsFinitePresentation]` — quasi-coherence is
  a

  mathlib instance from the latter. Kept because it is wanted in its own right and
  is

  the cheap half of the pair.'
file: AlgebraicJacobian/Picard/DivPushforwardFlat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.isQuasicoherent_pushforward
type: lean
updated: '2026-07-29T22:46:00'
---
theorem Scheme.DivFamily.isQuasicoherent_pushforward
    {S X : Scheme.{u}} {π : X ⟶ S} [IsProper π] {T : Over S}
    (x : Scheme.DivFamily π T) :
    ((Scheme.Modules.pushforward (pullback.snd π T.hom)).obj x.F).IsQuasicoherent := by
  letI := x.isFinitePresentation
  exact Scheme.Modules.pushforward_isQuasicoherent _ x.F