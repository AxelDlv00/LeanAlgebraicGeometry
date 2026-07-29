---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.relTwistDiff_apply
docstring: The twisted differential elementwise.
file: AlgebraicJacobian/Cohomology/RigidEngine4BaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relTwistDiff_apply
type: lean
updated: '2026-07-29T15:26:34'
---
lemma relTwistDiff_apply
    (p : ↥(twistSubmodule R (relCover C R D).V₀ (relCover C R D).V₁ g
        (relCover C R D).V₀) ×
      ↥(twistSubmodule R (relCover C R D).V₀ (relCover C R D).V₁ g
        (relCover C R D).V₁)) :
    relTwistDiff C R D g p
      = secRes (twistSheaf R (relCover C R D).V₀ (relCover C R D).V₁ g)
          (inf_le_left : (relCover C R D).V₀ ⊓ (relCover C R D).V₁ ≤
            (relCover C R D).V₀) p.1
        - secRes (twistSheaf R (relCover C R D).V₀ (relCover C R D).V₁ g)
            (inf_le_right : (relCover C R D).V₀ ⊓ (relCover C R D).V₁ ≤
              (relCover C R D).V₁) p.2 := rfl

set_option maxHeartbeats 1000000 in
-- The `respectTransparency false` defeq checks through the `relCurve`/product spellings
-- make elaboration exceed the default limit, as in the landed `relDiffBaseChange` ...
set_option synthInstance.maxHeartbeats 400000 in
-- ... and the instance searches on the large tensor types exceed the default limit.