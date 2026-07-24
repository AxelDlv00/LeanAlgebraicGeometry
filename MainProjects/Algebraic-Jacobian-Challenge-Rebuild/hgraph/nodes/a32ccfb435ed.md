---
author: sync
content_type: instance
created: '2026-07-24T17:02:46'
decl: TwoLatticePair.moduleFinite_aeval_model_t₁
file: AlgebraicJacobian/Cohomology/RigidEngineLatticeModelHom.lean
generated: lean
lean_status: lean_ok
title: TwoLatticePair.moduleFinite_aeval_model_t₁
type: lean
updated: '2026-07-24T17:02:46'
---
instance moduleFinite_aeval_model_t₁ :
    Module.Finite R[X] (Module.AEval' (model R ι m).t₁) :=
  moduleFinite_aeval_model_t₀ R ι m

end ModelFinite

/-! ### The finite model surjection -/