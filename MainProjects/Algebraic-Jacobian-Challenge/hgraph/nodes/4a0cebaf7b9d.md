---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.sectOfBijective_algebraMap
file: AlgebraicJacobian/Picard/TangentSpaceDualNumbers.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.sectOfBijective_algebraMap
type: lean
updated: '2026-07-16T21:14:28'
---
lemma sectOfBijective_algebraMap (c : k) :
    sectOfBijective hres (algebraMap k R c) = algebraMap k R c := by
  unfold sectOfBijective
  rw [residue_algebraMap]
  congr 1
  exact (residueFieldEquivOfBijective (R := R) hres).symm_apply_apply c