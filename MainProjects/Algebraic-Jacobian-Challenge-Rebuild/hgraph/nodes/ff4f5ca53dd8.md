---
author: sync
content_type: lemma
created: '2026-07-18T20:01:11'
decl: AlgebraicGeometry.DivisorAdaptation.moduleFinite_stalkQuot
docstring: '**Finiteness of the stalk colength along the divisor**: `𝒪_z ⧸ I_d(z)`
  is a finite

  `K`-module at every closed point of a piece.'
file: AlgebraicJacobian/Picard/DivisorFamilyStalkEval.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.DivisorAdaptation.moduleFinite_stalkQuot
type: lean
updated: '2026-07-31T20:14:53'
---
lemma moduleFinite_stalkQuot (j : A.index) {z : relCurve C K} (hz : z ∈ A.pieces j)
    (hzg : z ≠ genericPoint (relCurve C K)) :
    Module.Finite K ((relCurve C K).presheaf.stalk z ⧸ d.stalkIdeal z) := by
  haveI : LocallyOfFiniteType (relCurve C K ↘ Spec (CommRingCat.of K)) :=
    haveI : Smooth (relCurve C K ↘ Spec (CommRingCat.of K)) :=
      SmoothOfRelativeDimension.smooth 1 _
    inferInstance
  have hη : genericPoint (relCurve C K) ∈ A.pieces j :=
    Scheme.genericPoint_mem_of_nonempty ⟨z, hz⟩
  haveI : IsDedekindDomain Γ(relCurve C K, A.pieces j) :=
    isDedekindDomain_section K (A.isAffineOpen_pieces j) hη
  have h := moduleFinite_stalkQuot_span_germ K (A.isAffineOpen_pieces j) hz hzg
    (A.eqn_ne_zero j hη)
  rwa [A.span_germ_eqn_eq_stalkIdeal j hz] at h