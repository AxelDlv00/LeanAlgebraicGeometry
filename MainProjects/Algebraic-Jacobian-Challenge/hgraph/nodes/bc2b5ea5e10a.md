---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.tensorPresheaf
docstring: 'The presheaf-of-modules tensor of the underlying presheaves of `A B :
  X.Modules`;

  objectwise `Γ(A, V) ⊗_{Γ(X, V)} Γ(B, V)`.  Its sheafification is

  `Scheme.Modules.tensorObj A B`.'
file: AlgebraicJacobian/Picard/TensorSectionFormula.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.tensorPresheaf
type: lean
updated: '2026-07-24T03:02:12'
---
noncomputable abbrev tensorPresheaf (A B : X.Modules) : X.PresheafOfModules :=
  PresheafOfModules.Monoidal.tensorObj (R := X.presheaf) A.val B.val