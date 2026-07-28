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


  **Why this exists here rather than being imported — and the reason is now historical.**  The
  general

  statement `Scheme.Modules.pushforward_isQuasicoherent` (Stacks 01XJ, qcqs morphisms)
  lives in

  `Picard/QuotScheme.lean`, which this file used not to import on the ground that
  that module carries

  `sorry`s.  **That ground was false at HEAD** (its whole cone is `sorry`-free), and
  run 0068 r3 added

  the import, so the general form *is* available here now and

  `isQuasicoherent_pushPullObj_coverInter` uses it.  This affine special case is retained
  because it

  is four lines of mathlib, needs no qcqs side conditions, and several existing proofs
  consume it.

  Project-local.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImageUnconditional.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isQuasicoherent_pushforward_specMap
type: lean
updated: '2026-07-29T01:14:28'
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