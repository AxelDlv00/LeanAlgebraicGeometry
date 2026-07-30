---
author: sync
content_type: instance
created: '2026-07-24T17:02:46'
decl: TwoLatticePair.moduleFinite_aeval_model_t₀
file: AlgebraicJacobian/Cohomology/RigidEngineLatticeModelHom.lean
generated: lean
lean_status: lean_ok
stale: true
title: TwoLatticePair.moduleFinite_aeval_model_t₀
type: lean
updated: '2026-07-30T15:28:05'
---
instance moduleFinite_aeval_model_t₀ :
    Module.Finite R[X] (Module.AEval' (model R ι m).t₀) :=
  Module.Finite.equiv (modelAEvalEquiv R ι m).symm