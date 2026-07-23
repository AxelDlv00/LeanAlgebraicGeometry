---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Adelic.finiteMapToP1FiberMap_toSpecResidueField
file: AlgebraicJacobian/Picard/RigidPushforwardTransfer.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.finiteMapToP1FiberMap_toSpecResidueField
type: lean
updated: '2026-07-24T03:02:11'
---
lemma finiteMapToP1FiberMap_toSpecResidueField [HasFiniteMapToP1 C]
    (t : Spec (CommRingCat.of A)) :
    finiteMapToP1FiberMap A C t ≫
        (pullback.snd (p1Over k).hom
          (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberToSpecResidueField t =
      (pullback.snd C.hom
        (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberToSpecResidueField t :=
  (pullback.lift_snd _ _ _).trans (Category.comp_id _)