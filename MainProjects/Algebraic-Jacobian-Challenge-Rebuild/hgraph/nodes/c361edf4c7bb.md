---
author: sync
content_type: theorem
created: '2026-08-02T04:08:38'
decl: AlgebraicGeometry.DivRepAffinePullbackAff.classifyPiece_over
file: AlgebraicJacobian/Picard/DivRepGlobalClassifyAff.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.DivRepAffinePullbackAff.classifyPiece_over
type: lean
updated: '2026-08-02T07:12:49'
---
private theorem classifyPiece_over
    {T : Over (Spec (CommRingCat.of k))} (F : divFamZarAff C g T)
    (U : T.left.affineOpens) :
    classifyPiece hpi g hO hchi r1 r2 b1 b2 F U ≫ (DivOver).hom = U.1.ι ≫ T.hom := by
  rw [classifyPiece, Category.assoc, CategoryTheory.Over.w,
    ← CategoryTheory.Over.w (Over.fromSpecAffine T U), ← Category.assoc]
  exact congrArg (· ≫ T.hom) (isoSpec_hom_fromSpec U.2)