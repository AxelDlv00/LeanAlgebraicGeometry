---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.relChartFibreMul
docstring: '**The chart-level multiplication comparison**

  `Γ(C_R, V_R) ⊗[R] R'' →+* Γ(C_{R''}, V_{R''})`: `y ⊗ c ↦ relSectionsMap y · c`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedFibre.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.relChartFibreMul
type: lean
updated: '2026-07-30T15:28:02'
---
noncomputable def relChartFibreMul :
    Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V) ⊗[R] R' →+*
      Γ(relCurve C R', (fst C (overSpec k R')).left ⁻¹ᵁ V) :=
  fibreMulAux (relSectionsMap C R R' V)
    ((relCurve C R').overAlgebraMap R' ((fst C (overSpec k R')).left ⁻¹ᵁ V))
    (fun r => relSectionsMap_overAlgebraMap C R R' V r)

set_option synthInstance.maxHeartbeats 400000 in
-- tensor-algebra instance searches on the large section rings exceed the lakefile default