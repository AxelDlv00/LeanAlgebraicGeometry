---
author: sync
content_type: lemma
created: '2026-07-28T18:12:20'
decl: AlgebraicGeometry.Scheme.moduleToDivisorZeroApp_coe
docstring: The underlying rational function of `moduleToDivisorZeroApp` is the germ
  at `η`.
file: AlgebraicJacobian/RiemannRoch/Ledger/DivisorSheafZero.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.moduleToDivisorZeroApp_coe
type: lean
updated: '2026-07-28T18:12:20'
---
lemma moduleToDivisorZeroApp_coe {U : X.Opens} (hηU : genericPoint X ∈ U) (s : Γ(X, U)) :
    ((moduleToDivisorZeroApp K hηU s : divisorSections K 0 U) : X.functionField)
      = (X.presheaf.germ U (genericPoint X) hηU).hom s := rfl

open Classical in