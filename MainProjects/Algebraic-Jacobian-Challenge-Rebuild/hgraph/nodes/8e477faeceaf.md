---
author: sync
content_type: theorem
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.supportTube_smoke
docstring: 'Acceptance smoke test: the support tube applies to the relative curve
  over an

  arbitrary test ring with the universally-closed instance found by resolution.'
file: AlgebraicJacobian/Picard/SupportTube.lean
generated: lean
lean_status: lean_ok
private: true
stale: true
title: AlgebraicGeometry.supportTube_smoke
type: lean
updated: '2026-07-30T15:28:01'
---
private theorem supportTube_smoke (d : (relCurve C R).LocalEquations)
    {U : Set (relCurve C R)} (hU : IsOpen U) {s : Spec (CommRingCat.of R)}
    (hfib : ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹' {s} ∩ d.supportLocus
      ⊆ U) :
    ∃ V : (Spec (CommRingCat.of R)).Opens, s ∈ V ∧
      ((relCurve C R) ↘ Spec (CommRingCat.of R)).base ⁻¹' (V : Set (Spec (CommRingCat.of R)))
        ∩ d.supportLocus ⊆ U :=
  d.exists_supportTube _ hU hfib

end RelCurveProper

/-! ## The adaptation reads the same support, and the (c1) junction -/

section Adaptation

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k}

namespace FinCoverData

variable [IsFinite π] (D : FinCoverData C R π)