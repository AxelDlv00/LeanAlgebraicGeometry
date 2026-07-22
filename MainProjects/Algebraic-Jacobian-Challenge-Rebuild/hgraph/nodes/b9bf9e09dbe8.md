---
author: sync
content_type: theorem
created: '2026-07-22T11:03:23'
decl: AlgebraicGeometry.windowAddCoherenceDivisorEquiv_apply
file: AlgebraicJacobian/Picard/DivSchemeHighWindowFibreNormalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.windowAddCoherenceDivisorEquiv_apply
type: lean
updated: '2026-07-22T11:03:23'
---
theorem windowAddCoherenceDivisorEquiv_apply (p q : Nat)
    (D : (relCurve C K).CurveDivisor)
    (x : ↥(Scheme.divisorSections K
      (windowTransportDivisor C K pi (p + q) - D) ⊤)) :
    (windowAddCoherenceDivisorEquiv (pi := pi) C K p q D x :
        (relCurve C K).functionField) =
      ((windowAddCoherenceUnit (pi := pi) C K p q :
        (relCurve C K).functionFieldˣ) : (relCurve C K).functionField) * x :=
  rfl