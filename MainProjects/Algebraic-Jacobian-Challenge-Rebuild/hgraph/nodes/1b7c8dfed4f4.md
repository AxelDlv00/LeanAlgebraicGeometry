---
author: sync
content_type: theorem
created: '2026-07-31T03:02:18'
decl: AlgebraicGeometry.LaurentChartPair.diff_surjective
docstring: '**The Mayer–Vietoris difference map is surjective on a Laurent chart pair.**


  The one thing to notice is the sign.  The span gives `z = a|∩ + b|∩`; `TwoCover.diff`
  computes

  `s₀|∩ - s₁|∩`.  So the preimage of `z` is `(a, -b)`, and that is the whole difference
  between the

  two statements.'
file: AlgebraicJacobian/Curve/P1H1Vanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.LaurentChartPair.diff_surjective
type: lean
updated: '2026-07-31T20:15:19'
---
theorem diff_surjective (D : LaurentChartPair k) :
    Function.Surjective (TwoCover.diff k (P1 k) D.U₀ D.U₁) := by
  intro z
  obtain ⟨a, b, hab⟩ := exists_res_add_res_inf D z
  refine ⟨(a, -b), ?_⟩
  rw [TwoCover.diff_apply]
  simpa [sub_neg_eq_add] using hab.symm