---
author: sync
content_type: definition
created: '2026-08-07T05:01:57'
decl: AlgebraicGeometry.PicRankOneNativePresentation.toLocalPresentation
docstring: 'Convert the native adapter contract to the existing local-presentation
  contract.


  The two native bridge fields are inserted definitionally; all other fields are transported

  without weakening or adding hypotheses.'
file: AlgebraicJacobian/Picard/Pic0RankOneNativePresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.PicRankOneNativePresentation.toLocalPresentation
type: lean
updated: '2026-08-07T05:50:50'
---
noncomputable def toLocalPresentation
    (P : PicRankOneNativePresentation pi lam) :
    PicRankOneLocalPresentation pi lam :=
  { cover := P.cover
    representative := P.representative
    represents := P.represents
    datum := P.datum
    datum_class := P.datum_class
    module := P.datum.nativeModule
    module_iso := P.datum.nativeModuleKSheafIso
    line_bundle := P.datum.nativeModule_isLineBundle
    native_pushforward_base_change := P.native_pushforward_base_change
    h1_vanishing := P.h1_vanishing
    h0_finite := P.h0_finite
    h0_projective := P.h0_projective
    h0_rank_one := P.h0_rank_one }