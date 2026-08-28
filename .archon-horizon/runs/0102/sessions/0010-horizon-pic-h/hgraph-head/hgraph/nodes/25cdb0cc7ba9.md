---
author: sync
content_type: theorem
created: '2026-07-30T11:09:50'
decl: AlgebraicGeometry.isDominant_opens_ι_of_irreducibleSpace
docstring: '**On an irreducible scheme every nonempty open is dominant.**


  Two lines: `isDominant_iff` unfolds to `DenseRange`, `Scheme.Opens.range_ι` identifies
  the range

  with the open, and `IsOpen.dense` is the topological fact.  Landed as a named lemma
  because the

  docstring above previously *asserted* it as a reason not to worry about the `IsDominant`
  binder,

  which is the "prose standing in for a theorem" failure mode.


  The sibling project has the density form of this (`isDominant_opens_ι`,

  `AlgebraicJacobian/Albanese/AlbaneseFromData.lean:280` in Algebraic-Jacobian-Challenge,
  outside

  this project''s import closure); the irreducibility form is what a consumer here
  wants, because

  irreducibility is a property of the *chart source* and can be discharged once, whereas
  density

  is a property of each candidate `V`.'
file: AlgebraicJacobian/Picard/Pic0ChartSeamCollapse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isDominant_opens_ι_of_irreducibleSpace
type: lean
updated: '2026-08-01T09:44:16'
---
theorem isDominant_opens_ι_of_irreducibleSpace {X : Scheme.{u}} [IrreducibleSpace X]
    (V : X.Opens) (hne : (V : Set X).Nonempty) :
    IsDominant (V.ι) := by
  rw [isDominant_iff]
  simpa [DenseRange, Scheme.Opens.range_ι] using V.2.dense hne

variable (C) in