---
author: sync
content_type: theorem
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Grassmannian.universalMatrix_map_chartFrameMap
docstring: 'The universal matrix `X^I` maps to the normalised frame `X_I⁻¹ X` under
  the canonical

  chart map: `θ(X^I) = X_I⁻¹ X`, mirroring `universalMatrix_map_transitionPreMap`.  On
  the

  `I`-columns both sides are the identity block; off them the chart map reads the
  free

  indeterminate onto its assigned frame entry.'
file: AlgebraicJacobian/Picard/GrassmannianChartFrame.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Grassmannian.universalMatrix_map_chartFrameMap
type: lean
updated: '2026-07-31T20:15:25'
---
theorem universalMatrix_map_chartFrameMap (X : Matrix (Fin d) (Fin r) S)
    (I : Finset (Fin r)) (hI : I.card = d) (hu : IsUnit (frameMinor k d r S X I hI).det) :
    (universalMatrix k d r I hI).map (chartFrameMap k d r S X I hI)
      = frameMatrix k d r S X I hI := by
  ext p q
  simp only [Matrix.map_apply, universalMatrix]
  by_cases hq : q ∈ I
  · rw [dif_pos hq]
    set c := (I.orderIsoOfFin hI).symm ⟨q, hq⟩ with hc
    have hqc : (I.orderIsoOfFin hI c : Fin r) = q := by simp [hc]
    have hframe : frameMatrix k d r S X I hI p q = (1 : Matrix (Fin d) (Fin d) S) p c := by
      have e := congrFun (congrFun (frameMinor_frameMatrix k d r S X I hI hu) p) c
      rw [frameMinor, Matrix.submatrix_apply, id_eq] at e
      rw [← hqc]; exact e
    rw [hframe, Matrix.one_apply, apply_ite (chartFrameMap k d r S X I hI), map_one, map_zero]
    have hcond : ((I.orderIsoOfFin hI p : Fin r) = q) ↔ (p = c) := by
      conv_lhs => rw [← hqc]
      rw [Subtype.coe_inj, EmbeddingLike.apply_eq_iff_eq]
    by_cases hpc : p = c
    · rw [if_pos (hcond.mpr hpc), if_pos hpc]
    · rw [if_neg (hcond.not.mpr hpc), if_neg hpc]
  · rw [dif_neg hq, chartFrameMap, MvPolynomial.aeval_X]