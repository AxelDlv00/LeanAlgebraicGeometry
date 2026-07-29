---
author: sync
content_type: theorem
created: '2026-07-29T22:29:08'
decl: AlgebraicGeometry.Scheme.DivFamily.isQuasicoherent_pushforward
docstring: '**`q_* O_D` is quasi-coherent** when the ambient family is proper — the
  second

  of the three binders `Scheme.Modules.flatLocusStratification_universal` wants on

  the module it stratifies.


  Free: properness of `π` gives `QuasiCompact` and `QuasiSeparated` of the projection

  `q = pullback.snd π T.hom` by base change, and pushforward along a qcqs morphism

  preserves quasi-coherence. Recorded separately from the flatness statement because

  the two are consumed together and neither implies the other.'
file: AlgebraicJacobian/Picard/DivPushforwardFlat.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.DivFamily.isQuasicoherent_pushforward
type: lean
updated: '2026-07-29T22:29:08'
---
theorem Scheme.DivFamily.isQuasicoherent_pushforward
    {S X : Scheme.{u}} {π : X ⟶ S} [IsProper π] {T : Over S}
    (x : Scheme.DivFamily π T) :
    ((Scheme.Modules.pushforward (pullback.snd π T.hom)).obj x.F).IsQuasicoherent := by
  letI := x.isFinitePresentation
  exact Scheme.Modules.pushforward_isQuasicoherent _ x.F