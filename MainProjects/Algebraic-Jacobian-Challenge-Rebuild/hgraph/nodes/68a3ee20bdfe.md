---
author: sync
content_type: structure
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.Scheme.PointUniformizerData
docstring: '**A tracked point-uniformizer.** An open neighbourhood of the closed point
  `x`

  carrying a regular section whose germ at the generic point is the chosen uniformizer

  `uniformizer K hx` and whose germ at every other point of the neighbourhood is a
  unit.

  This is the public form of the data underlying the point divisor `1 · x`: unlike
  an

  existential, it lets consumers read off the orders of the section — `+1` at `x`

  (a uniformizer), `0` elsewhere on the neighbourhood.'
file: AlgebraicJacobian/Picard/PointPresentation.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PointUniformizerData
type: lean
updated: '2026-07-29T15:31:48'
---
structure PointUniformizerData : Type u where
  /-- The neighbourhood of `x` carrying the spread-out uniformizer. -/
  opens : X.Opens
  /-- The point `x` lies in the neighbourhood. -/
  mem : x ∈ opens
  /-- The spread-out uniformizer. -/
  sec : Γ(X, opens)
  /-- The germ of the section at the generic point is the chosen uniformizer. -/
  germ_generic :
    (X.presheaf.germ opens (genericPoint X)
      (genericPoint_mem_of_nonempty ⟨x, mem⟩)).hom sec = uniformizer K hx
  /-- The section is regular: its germs are nonzerodivisors. -/
  regular : ∀ (y : X) (hy : y ∈ opens),
    (X.presheaf.germ opens y hy).hom sec ∈ nonZeroDivisors (X.presheaf.stalk y)
  /-- Away from `x`, the section is a unit. -/
  isUnit_germ : ∀ (y : X) (hy : y ∈ opens), y ≠ x →
    IsUnit ((X.presheaf.germ opens y hy).hom sec)