---
author: sync
content_type: definition
created: '2026-07-19T21:31:15'
decl: AlgebraicGeometry.DatG0.deltaCocone
docstring: '**The δ colimit cocone.**  The inclusion cocone from the finite subextensions
  to the

  whole field `K`, with `app k'''' = k'''' ↪ K`.'
file: AlgebraicJacobian/Picard/PicRepColimitMountain.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DatG0.deltaCocone
type: lean
updated: '2026-07-31T20:15:28'
---
noncomputable def deltaCocone : Cocone (deltaRingDiagram (k := k) (K := K)) where
  pt := CommRingCat.of K
  ι :=
    { app := fun L => CommRingCat.ofHom (IntermediateField.val L.1).toRingHom
      naturality := fun {L₁ L₂} h => by
        apply CommRingCat.hom_ext
        ext x
        rfl }