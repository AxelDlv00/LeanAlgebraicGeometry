---
author: sync
content_type: definition
created: '2026-07-30T01:58:51'
decl: AlgebraicGeometry.Scheme.PicScheme.picEt_baseChangeField_crossBaseIso_of_relPresheaf
docstring: 'The reduction, specialised to the base-changed curve — the shape the

  descent step actually consumes. The base-changed curve inherits both binders

  (`smoothOfRelativeDimension_one_hom_baseChangeField`,

  `isProper_hom_baseChangeField`), so no hypothesis on `C_{k''}` is needed beyond

  those on `C`.'
file: AlgebraicJacobian/Picard/PicEtCrossBase.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.picEt_baseChangeField_crossBaseIso_of_relPresheaf
type: lean
updated: '2026-07-30T01:58:51'
---
noncomputable def picEt_baseChangeField_crossBaseIso_of_relPresheaf
    (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] (k' : Type u) [Field k']
    [Algebra k k']
    (e : PicSharp.relPresheaf (baseChangeField C k')
      ≅ (restrictTest k k').op ⋙ PicSharp.relPresheaf C) :
    picEt (baseChangeField C k') ≅ (restrictTest k k').op ⋙ picEt C :=
  picEt_crossBaseIso_of_relPresheaf C (baseChangeField C k') e