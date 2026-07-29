---
author: sync
content_type: lemma
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.Over.algebraMap_testPointField
file: AlgebraicJacobian/Picard/Pic0ChartTestPoint.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.algebraMap_testPointField
type: lean
updated: '2026-07-29T15:26:25'
---
lemma algebraMap_testPointField {T : Over (Spec (.of k))} (t : T.left) :
    algebraMap k (testPointField t)
      = (Spec.preimage (T.left.fromSpecResidueField t ≫ T.hom)).hom :=
  rfl

/-! ## The affine case: the test algebra also acts

Over an affine test `overSpec k A` the residue field of a point is a `κ(t)`-algebra over `A`
as well as over `k`, and the two structures form a tower.  This is what the engine-facing
predicates of the tree require — `BasicOpenCocycleDatum.HasWitnessH1Vanishing` takes
`[Algebra B L]` and `[IsScalarTower k B L]` — so without these two instances the
`testPoint`-indexed loci and the `PrimeSpectrum`-indexed loci cannot even be compared.

Both come from the same source as the `k`-structure: `Spec.preimage` of the composite
`Spec κ(t) ⟶ Spec A`, which for an affine test is the structure morphism itself. -/

section Affine

variable {A : Type u} [CommRing A] [Algebra k A]