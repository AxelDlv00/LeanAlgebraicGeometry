---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.thetaVal
docstring: '**The value of a twisted section** over a nonempty open: the germ at `η`
  of the

  chart-0 component, divided by `uⁿ`. This is the mirror of

  `MeromorphicPresentation.gluedVal` on the two-chart carrier.'
file: AlgebraicJacobian/RiemannRoch/ThetaSections.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.thetaVal
type: lean
updated: '2026-07-29T15:31:50'
---
noncomputable def thetaVal {W : Y.Opens} (hηW : genericPoint Y ∈ W)
    (p : ↥(twistSubmodule K (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) W)) :
    Y.functionField :=
  (((fiberCoordUnit π ^ n)⁻¹ : Y.functionFieldˣ) : Y.functionField) *
    (Y.presheaf.germ (W ⊓ fiberChart₀ π) (genericPoint Y)
      ⟨hηW, (genericPoint_mem_preimage_inf π).1⟩).hom p.val.1

omit [SmoothOfRelativeDimension 1 (Y ↘ Spec (CommRingCat.of K))]
  [LocallyOfFiniteType (Y ↘ Spec (CommRingCat.of K))]
  [QuasiCompact (Y ↘ Spec (CommRingCat.of K))] in