---
author: sync
content_type: lemma
created: '2026-07-17T21:31:16'
decl: AlgebraicGeometry.relCurveMap_eq_overSpecMap_ofId
docstring: 'The relative-curve comparison at the base-field transition `k → K` is
  the E-iv-alg

  transition morphism.'
file: AlgebraicJacobian/RiemannRoch/WindowFieldTransport.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.relCurveMap_eq_overSpecMap_ofId
type: lean
updated: '2026-07-29T15:31:50'
---
lemma relCurveMap_eq_overSpecMap_ofId :
    relCurveMap C k K = (C ◁ Over.overSpecMap (Algebra.ofId k K)).left := by
  refine congrArg (fun φ : C ⊗ overSpec k K ⟶ C ⊗ overSpec k k => φ.left)
    (congrArg (fun ψ : overSpec k K ⟶ overSpec k k => C ◁ ψ) ?_)
  exact Over.OverMorphism.ext rfl

set_option linter.unusedSectionVars false in