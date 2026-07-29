---
author: sync
content_type: theorem
created: '2026-07-30T01:58:51'
decl: AlgebraicGeometry.Scheme.PicScheme.relPresheaf_crossBaseIso
docstring: 'The `Nonempty` form, which is what a downstream consumer that only needs

  existence of the identification should cite.'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.relPresheaf_crossBaseIso
type: lean
updated: '2026-07-30T03:33:55'
---
theorem relPresheaf_crossBaseIso (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] (k' : Type u) [Field k']
    [Algebra k k'] :
    Nonempty (PicSharp.relPresheaf (baseChangeField C k')
      ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :=
  ⟨relPresheafCrossBaseIso C k'⟩

/-! ## §5. The reduction: sheafification adds nothing -/