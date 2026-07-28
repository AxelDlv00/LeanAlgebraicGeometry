---
author: sync
content_type: theorem
created: '2026-07-28T20:09:16'
decl: AlgebraicGeometry.isQuasicoherent_pushforward_specMap
docstring: '**Affine pushforward preserves quasi-coherence, at a literal `Spec.map`.**  For
  a ring map

  `φ : R ⟶ R''` and a quasi-coherent `M` on `Spec R''`, the pushforward `(Spec φ)_*
  M` is

  quasi-coherent on `Spec R`.


  This is the brick the Čech terms need and it is *entirely* mathlib: `isIso_fromTildeΓ_pushforward`

  (`Mathlib/AlgebraicGeometry/Modules/Tilde.lean`) says exactly that an affine pushforward
  preserves

  the tilde model, and `isIso_fromTildeΓ_iff` converts that to essential-image membership,
  whence

  quasi-coherence because a tilde is quasi-coherent outright.


  **Why this exists here rather than being imported.**  The general statement

  `Scheme.Modules.pushforward_isQuasicoherent` (Stacks 01XJ, qcqs morphisms) *does*
  exist in this

  project — in `Picard/QuotScheme.lean`, which this file deliberately does not import
  (see the

  `canonicalBaseChangeMap` note at `openImmersion_bareBC`), because that module carries
  `sorry`s.

  An earlier revision of `cech_flatBaseChange_of_termsQuasicoherent`''s docstring
  advertised that

  out-of-cone lemma as the route for its `h₂`/`h₃`; the affine case, which is all
  the Čech consumer

  needs, is four lines from mathlib and stays inside this cone.  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isQuasicoherent_pushforward_specMap
type: lean
updated: '2026-07-28T20:09:16'
---
theorem isQuasicoherent_pushforward_specMap {R R' : CommRingCat.{u}} (φ : R ⟶ R')
    (M : (Spec R').Modules) (hM : M.IsQuasicoherent) :
    ((Scheme.Modules.pushforward (Spec.map φ)).obj M).IsQuasicoherent := by
  haveI := hM
  haveI hpf : IsIso ((Scheme.Modules.pushforward (Spec.map φ)).obj M).fromTildeΓ :=
    isIso_fromTildeΓ_pushforward φ M
  obtain ⟨N, ⟨e⟩⟩ := isIso_fromTildeΓ_iff.mp hpf
  exact (SheafOfModules.isQuasicoherent.{u} (Spec R).ringCatSheaf).prop_of_iso e
    (presentationTilde.{u} N Set.univ (by simp) _ (Submodule.span_eq _)).isQuasicoherent