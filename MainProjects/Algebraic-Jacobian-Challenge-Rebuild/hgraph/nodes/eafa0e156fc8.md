---
author: sync
content_type: definition
created: '2026-07-28T17:25:25'
decl: AlgebraicGeometry.AffCoverData.HasAffineOverlaps
docstring: '**Overlap affineness of a widened cover** — the one datum the certificate
  transport needs

  beyond `AffCoverData`''s own fields.  Named so that it can be threaded explicitly
  and read off

  any signature; for a relative curve over a proper `C` it follows from separatedness.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffMapAlg.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffCoverData.HasAffineOverlaps
type: lean
updated: '2026-07-29T15:31:44'
---
def AffCoverData.HasAffineOverlaps (D : AffCoverData C R) : Prop :=
  ∀ i j : D.index, IsAffineOpen (D.pieces i ⊓ D.pieces j)

variable (R' : Type u) [CommRing R'] [Algebra k R'] [Algebra R R'] [IsScalarTower k R R']
variable (n : ℕ)