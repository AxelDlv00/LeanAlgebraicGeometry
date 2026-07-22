---
author: sync
content_type: lemma
created: '2026-07-17T18:01:32'
decl: AlgebraicGeometry.relCurveMap_base_awayGlueLift
file: AlgebraicJacobian/Picard/DivisorFamilyZariskiGlue.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relCurveMap_base_awayGlueLift
type: lean
updated: '2026-07-17T18:01:32'
---
lemma relCurveMap_base_awayGlueLift (hg : Ideal.span (Set.range g) = ⊤)
    (y : relCurve C R) :
    (relCurveMap C R (S (awayGlueIndex g S hg y))).base (awayGlueLift g S hg y) = y :=
  (exists_relCurveMap_base_eq C R g S hg y).choose_spec.choose_spec

variable [∀ i, IsOpenImmersion (relCurveMap C R (S i))]
variable {n : ℕ} (E : ∀ i, CertifiedDivisorFamily C (S i) π n)