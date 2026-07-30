---
author: sync
content_type: theorem
created: '2026-07-18T23:31:13'
decl: AlgebraicGeometry.Grassmannian.free_quotient_congrAmbient
docstring: Freeness of the quotient transports across the ambient identification.
file: AlgebraicJacobian/Picard/DivSchemeFrameKit.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.free_quotient_congrAmbient
type: lean
updated: '2026-07-30T15:46:02'
---
theorem free_quotient_congrAmbient (e : H ≃ₗ[k] H') (x : grFunctorAff k H g T)
    (hfree : Module.Free T (TensorProduct k T H ⧸ x.toSubmodule)) :
    Module.Free T (TensorProduct k T H' ⧸ (congrAmbient e x).toSubmodule) :=
  haveI := hfree
  Module.Free.of_equiv (congrAmbientQuotEquiv e x)