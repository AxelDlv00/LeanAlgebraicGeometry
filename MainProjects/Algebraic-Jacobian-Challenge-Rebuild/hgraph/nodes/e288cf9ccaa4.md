---
author: sync
content_type: theorem
created: '2026-07-29T15:31:44'
decl: AlgebraicGeometry.AffAdaptation.ker_trivGluedEval
docstring: '**THE KERNEL BRIDGE, CHART-FREE**: the kernel of the chart-free Θ-twisted
  evaluation is the

  cover-independent vanishing submodule of the family — the same right-hand side as
  the

  chart-typed `ker_thetaGluedEval` and as `AffAdaptation.ker_thetaGluedEval`, so all
  three kernels

  are the *same submodule* of `relThetaSections C R π a`.


  This is what makes the new index usable rather than merely inhabited: `divisorWindow`
  is a

  `Submodule.comap` of exactly this submodule, so `windowCarve`/`ker_windowCarve`
  transport

  verbatim (below).


  The forward direction picks a piece out of the JOINT cover (`AffCoverData.exists_mem_pieces`,

  obligation `I-0492` 4(ii)); the reverse direction needs the germ law''s unit in
  the other

  direction, which is the same absorption.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTyping.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.ker_trivGluedEval
type: lean
updated: '2026-07-31T20:14:51'
---
theorem ker_trivGluedEval :
    LinearMap.ker (trivGluedEval A T)
      = d.vanishingSubmodule R (relCover C R (fiberTwoCover π)).V₀
          (relCover C R (fiberTwoCover π)).V₁ (relThetaCocycle C R π a) := by
  rw [ker_trivGluedEval_eq_ker]
  ext x
  rw [LinearMap.mem_ker, Scheme.LocalEquations.mem_vanishingSubmodule_iff, funext_iff]
  constructor
  · intro hker
    refine ⟨fun z hz => ?_, fun z hz => ?_⟩
    · obtain ⟨j, hj⟩ := D.exists_mem_pieces z
      have h := germ_read_mem_stalkIdeal_of_trivEval_eq_zero A T hker false j hj hz.2
      simpa using h
    · obtain ⟨j, hj⟩ := D.exists_mem_pieces z
      have h := germ_read_mem_stalkIdeal_of_trivEval_eq_zero A T hker true j hj hz.2
      simpa using h
  · intro h j
    rw [trivEval_apply, Pi.zero_apply, Ideal.Quotient.eq_zero_iff_mem]
    refine Scheme.mem_span_singleton_of_forall_germ
      (fun z hz => A.eqn_regular j z hz) (fun z hz => ?_)
    rw [germ_eqn_span_eq_stalkIdeal A j hz]
    -- the point lies in SOME pinned chart, and the germ law compares the reading there
    have hzc : ∃ b : Bool, z ∈ relPinnedChart C R π b := by
      have hz' : z ∈ (relCover C R (fiberTwoCover π)).V₀
          ⊔ (relCover C R (fiberTwoCover π)).V₁ := by
        rw [relCover_sup]; trivial
      rcases Opens.mem_sup.mp hz' with hb | hb
      · exact ⟨false, hb⟩
      · exact ⟨true, hb⟩
    obtain ⟨b, hzb⟩ := hzc
    obtain ⟨u, hu⟩ := T.germ_read j b z hz hzb x
    rw [hu]
    exact Ideal.mul_mem_left _ _
      (germ_val_mem_stalkIdeal_of_forall_side a x h b ⟨trivial, hzb⟩)

/-! ### The window carve, chart-free

`divisorWindow` is a `Submodule.comap` of the vanishing submodule and mentions no cover, so once
`ker_trivGluedEval` identifies the kernel these are `LinearMap.ker_comp` and nothing else — the
same three lines as the chart-typed versions (`Picard/DivisorFamilyAffTheta.lean:899`), now on an
index every widened cover inhabits at `a = 0`. -/

section WindowCarve

noncomputable local instance instOverCleftTrivWindow :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]

variable (hH1 : Subsingleton (relTwistPair C k π (relThetaCocycle C k π a)).H1)