---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.relTwistPair_diff
docstring: 'The Čech differential of the relative twist pair is the pair-free

  `relTwistDiff`.'
file: AlgebraicJacobian/Cohomology/RigidEngine4BaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relTwistPair_diff
type: lean
updated: '2026-07-30T15:28:02'
---
lemma relTwistPair_diff :
    (relTwistPair C R π g).diff = relTwistDiff C R (fiberTwoCover π) g := rfl