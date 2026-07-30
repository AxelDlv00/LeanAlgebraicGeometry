---
author: sync
content_type: theorem
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.ker_windowCarve
docstring: '**THE FACE, PLUGGED IN**: the kernel of the widened window carve arrow
  is exactly the window

  submodule `K_a(d)`.


  This is what `ker_thetaGluedEval` was for, and stating it is the step inbox `I-0769`
  correctly

  observed was missing.  Together with surjectivity of the widened evaluation — **not**
  proved, see

  the module docstring — it gives the widened analogue of `windowQuotEquiv`, i.e.
  the identification

  `(R ⊗[k] H_a) ⧸ K_a(d) ≃ W(d)^{Θᵃ}` that the ε-value facts are transported along.


  Note what carries it: `divisorWindow` is a `Submodule.comap` of the vanishing submodule,
  and

  `ker_thetaGluedEval` says the widened kernel *is* that vanishing submodule, so this
  is

  `LinearMap.ker_comp` and nothing else.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.ker_windowCarve
type: lean
updated: '2026-07-30T15:46:03'
---
theorem ker_windowCarve :
    LinearMap.ker (windowCarve A τ a hH1) = divisorWindow d hH1 := by
  rw [windowCarve, LinearMap.ker_comp, ker_thetaGluedEval, divisorWindow]