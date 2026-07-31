---
author: sync
content_type: definition
created: '2026-07-28T13:42:17'
decl: AlgebraicGeometry.Over.testPointFieldMap
docstring: '**The residue-field extension a morphism of tests induces at a point**,
  as a

  `k`-algebra map `κ(f t) → κ(t)`.  This is `Scheme.Hom.residueFieldMap` with its

  `k`-algebra structure read off; it is the extension along which every fibre-field

  predicate has to be invariant for a locus over `T` to pull back to one over `T''`.'
file: AlgebraicJacobian/Picard/Pic0ChartTestPoint.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Over.testPointFieldMap
type: lean
updated: '2026-07-31T20:14:50'
---
def testPointFieldMap {T T' : Over (Spec (.of k))} (f : T' ⟶ T) (t : T'.left) :
    CommRingCat.of (testPointField (T := T) (f.left.base t))
      ⟶ CommRingCat.of (testPointField (T := T') t) :=
  f.left.residueFieldMap t

/-- The residue-field extension of `testPointFieldMap`, as an algebra structure: `κ(t)` is
a `κ(f t)`-algebra.  This is the shape the fibre-field invariance lemmas of
`Pic0ChartLocusFibreField.lean` consume (`hasWitnessH1Vanishing_iff_of_fieldExtension`
takes `[Algebra L L']`). -/
@[reducible]