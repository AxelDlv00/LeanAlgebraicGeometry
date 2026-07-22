---
author: sync
content_type: theorem
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.free_relTwistSectionsOverlap
docstring: 'Freeness of the twisted section modules — the overlap (the pair''s overlap
  module is

  free, hence flat and projective: the split/flat rigidity inputs of RE-3).'
file: AlgebraicJacobian/Cohomology/RigidEngine4Engine.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.free_relTwistSectionsOverlap
type: lean
updated: '2026-07-16T21:33:27'
---
theorem free_relTwistSectionsOverlap :
    Module.Free R ((relTwistSheaf C R (fiberTwoCover π) g).obj.obj
      (op ((relCover C R (fiberTwoCover π)).V₀ ⊓ (relCover C R (fiberTwoCover π)).V₁))) := by
  haveI : Module.Free R Γ(relCurve C R,
      (relCover C R (fiberTwoCover π)).V₀ ⊓ (relCover C R (fiberTwoCover π)).V₁) :=
    free_relSections C R (fiberChart₀ π ⊓ fiberChart₁ π)
      (fiberTwoCover π).isAffineOpen_inf.isCompact
      (fiberTwoCover π).isAffineOpen_inf.isQuasiSeparated
  exact free_twistSheafSections₀ R g
    (inf_le_left : (relCover C R (fiberTwoCover π)).V₀ ⊓
      (relCover C R (fiberTwoCover π)).V₁ ≤ (relCover C R (fiberTwoCover π)).V₀)

/-! ## The keystones -/

section Keystones

variable (hπ : π ≫ P1.structureMap k = C.hom)