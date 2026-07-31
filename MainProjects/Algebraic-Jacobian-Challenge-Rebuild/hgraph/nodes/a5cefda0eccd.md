---
author: sync
content_type: definition
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffCoverData.baseChange
docstring: '**Base change of the widened cover datum** along `R → R''`: take preimages.  Affineness
  is

  `isAffineOpen_relCurveMap_preimage` (preimage of an affine open along the affine
  `relCurveMap`)

  and the covering property is the preimage of the joint cover.  There is nothing
  else to

  discharge — no generators, no partitions.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffBaseChange.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffCoverData.baseChange
type: lean
updated: '2026-07-31T20:14:48'
---
noncomputable def baseChange : AffCoverData C R' where
  m := D.m
  pieces j := relCurveMap C R R' ⁻¹ᵁ D.pieces j
  isAffineOpen j := isAffineOpen_relCurveMap_preimage C R' (D.isAffineOpen j)
  cover := by
    refine top_le_iff.mp fun z _ => ?_
    obtain ⟨j, hj⟩ := D.exists_mem_pieces ((relCurveMap C R R').base z)
    exact Opens.mem_iSup.mpr ⟨j, hj⟩

@[simp]