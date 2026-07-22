---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.relBasicFibreMul
docstring: '**The basic-open multiplication comparison**

  `Γ(C_R, D(g)) ⊗[R] R'' →+* Γ(C_{R''}, D(g''))`.'
file: AlgebraicJacobian/Picard/DivSchemeSeedFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relBasicFibreMul
type: lean
updated: '2026-07-17T16:57:13'
---
noncomputable def relBasicFibreMul
    (g : Γ(relCurve C R, (fst C (overSpec k R)).left ⁻¹ᵁ V)) :
    Γ(relCurve C R, (relCurve C R).basicOpen g) ⊗[R] R' →+*
      Γ(relCurve C R', (relCurve C R').basicOpen (relSectionsMap C R R' V g)) :=
  fibreMulAux (relBasicPull C R R' V g)
    ((relCurve C R').overAlgebraMap R'
      ((relCurve C R').basicOpen (relSectionsMap C R R' V g)))
    (fun r => relBasicPull_overAlgebraMap C R R' V g r)

set_option synthInstance.maxHeartbeats 400000 in
-- tensor-algebra instance searches on the large section rings exceed the lakefile default