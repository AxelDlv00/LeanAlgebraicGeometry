---
author: sync
content_type: definition
created: '2026-07-29T03:25:40'
decl: AlgebraicGeometry.Over.testPointFieldAlgEquiv
docstring: '**An invertible residue-field extension is a `k`-algebra equivalence.**  This
  is the shape

  the `IsSplitWitness` transport consumes, and the `IsIso` hypothesis of

  `IsSplitWitnessIsoInvariant` exists precisely to supply it.'
file: AlgebraicJacobian/Picard/Pic0ChartLocusIsoInvariance.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.testPointFieldAlgEquiv
type: lean
updated: '2026-07-29T15:31:47'
---
def testPointFieldAlgEquiv {T T' : Over (Spec (.of k))} (f : T' ⟶ T) (t : T'.left)
    [IsIso (testPointFieldMap f t)] :
    testPointField (T := T) (f.left.base t) ≃ₐ[k] testPointField (T := T') t :=
  { (asIso (testPointFieldMap f t)).commRingCatIsoToRingEquiv with
    commutes' := (testPointFieldAlgHom f t).commutes }