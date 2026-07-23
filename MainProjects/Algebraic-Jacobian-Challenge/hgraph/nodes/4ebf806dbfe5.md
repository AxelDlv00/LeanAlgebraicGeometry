---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.twistedSMul_smul_right
docstring: The local graded action is `Γ(X, U)`-linear in the module slot.
file: AlgebraicJacobian/Picard/InvertibleSectionLocalization.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.twistedSMul_smul_right
type: lean
updated: '2026-07-24T03:02:11'
---
lemma twistedSMul_smul_right (F L : X.Modules) (i j : ℕ) (U : X.Opens)
    (a : Γ(X, U)) (r : Γ(tensorPow L i, U)) (x : Γ(moduleTensorPow F L j, U)) :
    twistedSMul F L i j U r (a • x)
      = a • twistedSMul F L i j U r x :=
  twistedSMul_smul_right_aux F L i j U a r x