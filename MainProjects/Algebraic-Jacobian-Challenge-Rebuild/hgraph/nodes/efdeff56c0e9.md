---
author: sync
content_type: theorem
created: '2026-07-24T21:02:20'
decl: AlgebraicGeometry.Scheme.ordZ_unitsMap_stalk_eq_one
docstring: 'A unit in a closed-point stalk remains a unit in the function field, hence
  has

  trivial `ordZ`.  This is the valuation form of the stalk-unit transition bridge
  used

  when comparing a pulled local equation with a theta-chart reading.'
file: AlgebraicJacobian/Picard/DivisorFamilyFieldDegree.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.Scheme.ordZ_unitsMap_stalk_eq_one
type: lean
updated: '2026-07-31T20:14:52'
---
theorem ordZ_unitsMap_stalk_eq_one {z : X} (hz : z ≠ genericPoint X)
    (v : (X.presheaf.stalk z)ˣ) :
    Scheme.ordZ (X ↘ Spec (CommRingCat.of K)) hz
      (Units.map (algebraMap (X.presheaf.stalk z) X.functionField).toMonoidHom v) = 1 := by
  rw [Scheme.ordZ_eq_one_iff (X ↘ Spec (CommRingCat.of K)) hz]
  exact Valuation.Integers.one_of_isUnit'
    (v := Scheme.ord (X ↘ Spec (CommRingCat.of K)) hz)
    v.isUnit (fun y => Scheme.ord_algebraMap_stalk_le_one K hz y)