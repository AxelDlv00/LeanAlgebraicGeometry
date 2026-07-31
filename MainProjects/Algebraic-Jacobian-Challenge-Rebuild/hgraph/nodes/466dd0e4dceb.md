---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.isPushout_sections_gen
docstring: 'The mathlib pushout-sections square for the base-change square of the
  tower

  `A → R`, with the `Spec R`-side at `⊤` and an affine open `U` on the product side.'
file: AlgebraicJacobian/Picard/SectionsDescent.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.Over.isPushout_sections_gen
type: lean
updated: '2026-07-31T20:14:43'
---
private lemma isPushout_sections_gen {U : (XA).Opens} (hU : IsAffineOpen U) :
    IsPushout
      ((pA).appLE ⊤ U (le_top.trans (Scheme.Hom.preimage_top (pA)).ge))
      ((Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left.appLE ⊤ ⊤
        (Scheme.Hom.preimage_top (Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left).ge)
      ((C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left.appLE U
        ((C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left ⁻¹ᵁ U) le_rfl)
      ((snd C (overSpec k R)).left.appLE ⊤
        ((C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left ⁻¹ᵁ U)
        (le_top.trans (Scheme.Hom.preimage_top (snd C (overSpec k R)).left).ge)) := by
  have H := Over.isPullback_whiskerLeft_snd C
    (Over.overSpecMap ((Algebra.ofId A R).restrictScalars k))
  have hUY : (C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left ⁻¹ᵁ U
      = (C ◁ Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left ⁻¹ᵁ U
        ⊓ (snd C (overSpec k R)).left ⁻¹ᵁ (⊤ : ((overSpec k R).left).Opens) := by
    rw [Scheme.Hom.preimage_top, inf_top_eq]
  have h := isIso_pushoutSection_of_isAffineOpen H
    (le_top.trans
      (Scheme.Hom.preimage_top (Over.overSpecMap ((Algebra.ofId A R).restrictScalars k)).left).ge)
    (le_top.trans (Scheme.Hom.preimage_top (pA)).ge) hUY
    (isAffineOpen_top_overSpec k A) (isAffineOpen_top_overSpec k R) hU
  exact (isIso_pushoutSection_iff _ _ _ _).mp h