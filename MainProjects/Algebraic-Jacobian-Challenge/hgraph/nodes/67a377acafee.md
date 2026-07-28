---
author: sync
content_type: theorem
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.divisorVal_mulEquiv
docstring: '**Behaviour of the multiplication isomorphism on section values.** Over
  a nonempty open the

  forward map of `divisorMulPresheaf` sends a section to `g` times its underlying
  rational

  function.'
file: AlgebraicJacobian/RiemannRoch/Ledger/MulEquiv.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.divisorVal_mulEquiv
type: lean
updated: '2026-07-28T18:12:20'
---
theorem divisorVal_mulEquiv {U : X.Opens} (hU : (U : Set X).Nonempty)
    (s : (divisorPresheaf K D).obj (op U)) :
    divisorVal K ((divisorMulPresheaf K g D).app (op U) s)
      = (g : X.functionField) * divisorVal K s :=
  divisorMulPresheafApp_coe_of_nonempty K g D hU s