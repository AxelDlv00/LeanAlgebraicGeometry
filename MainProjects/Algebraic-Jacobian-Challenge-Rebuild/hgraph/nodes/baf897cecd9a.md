---
author: sync
content_type: definition
created: '2026-07-21T12:32:00'
decl: AlgebraicGeometry.relThetaSectionFst
docstring: 'The canonical global relative theta section `(t₀ᵃ, 1)`.  Its first component
  is

  the chart-0 coordinate power and its second component is the constant section `1`.'
file: AlgebraicJacobian/Picard/DivisorFamilyThetaSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relThetaSectionFst
type: lean
updated: '2026-07-30T15:46:04'
---
noncomputable def relThetaSectionFst : relThetaSections C R π a := by
  refine ⟨((relCurve C R).resHom inf_le_right (relFiberCoordPow C R π a), 1), ?_⟩
  rw [mem_twistSubmodule_iff]
  have key := congrArg
    ((relCurve C R).resHom
      (le_inf (inf_le_left.trans inf_le_right) inf_le_right :
        ⊤ ⊓ (relCover C R (fiberTwoCover π)).V₀ ⊓
            (relCover C R (fiberTwoCover π)).V₁ ≤
          (relCover C R (fiberTwoCover π)).V₀ ⊓
            (relCover C R (fiberTwoCover π)).V₁))
    (resHom_relFiberCoordPow C R π a)
  simpa only [Scheme.resHom_resHom, map_one, mul_one] using key