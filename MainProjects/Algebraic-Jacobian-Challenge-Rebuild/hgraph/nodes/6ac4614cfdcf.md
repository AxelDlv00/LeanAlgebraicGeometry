---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.exists_effective_of_picClass
docstring: '**An effective witness of a class of large degree.** If a Weil divisor
  `W` has

  `1 ≤ deg W + χ(𝒪)` then its Čech Picard class is realized by an **effective** divisor.
  The

  Riemann inequality (`riemann_inequality`) forces a nonzero global section `f` of
  `𝒪(W)`, i.e.

  `f ∈ K(X)ˣ` with `W + div f ≥ 0`; that shift is effective and of the same class

  (`CurveDivisor.picClass_divOf`).'
file: AlgebraicJacobian/RiemannRoch/FLVClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_effective_of_picClass
type: lean
updated: '2026-07-31T20:15:29'
---
lemma exists_effective_of_picClass (W : X.CurveDivisor)
    (hW : 1 ≤ CurveDivisor.deg K W + Sheaf.chi (X.moduleKSheaf K)) :
    ∃ E : X.CurveDivisor, 0 ≤ E ∧ CurveDivisor.picClass K E = CurveDivisor.picClass K W := by
  -- `h⁰(𝒪(W)) ≥ 1`, so `H⁰` is nontrivial.
  have hfr : 0 < Module.finrank K (Sheaf.HModule (X.divisorSheaf K W) 0) := by
    have h1 : (1 : ℤ) ≤ (Sheaf.h0 (X.divisorSheaf K W) : ℤ) :=
      le_trans hW (riemann_inequality K W)
    have : 0 < Sheaf.h0 (X.divisorSheaf K W) := by omega
    exact this
  haveI : Nontrivial (Sheaf.HModule (X.divisorSheaf K W) 0) :=
    Module.nontrivial_of_finrank_pos hfr
  -- a nonzero global section `g ∈ 𝒪(W)(⊤) ⊆ K(X)`.
  obtain ⟨t, ht⟩ := exists_ne (0 : Sheaf.HModule (X.divisorSheaf K W) 0)
  set s := (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens)) (X.divisorSheaf K W)) t with hs
  have hsne : s ≠ 0 := by
    rw [hs]; exact (LinearEquiv.map_ne_zero_iff _).mpr ht
  set g : X.functionField := divisorVal K s with hg
  have hgmem : g ∈ divisorSections K W ⊤ := divisorVal_mem K s
  have hgne : g ≠ 0 := by
    intro h
    exact hsne (divisorSection_ext K
      (show divisorVal K s = divisorVal K (0 : _) from by rw [← hg, h]; rfl))
  -- the unit `u` and the effective shift.
  set u : X.functionFieldˣ := Units.mk0 g hgne with hu
  have huval : (u : X.functionField) = g := rfl
  refine ⟨W + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u, ?_, ?_⟩
  · -- effectivity: `coeffAt (W + div u) ≥ 0` from the pole bound
    refine Finsupp.le_def.mpr (fun p => ?_)
    change (0 : ℤ) ≤ coeffAt p.2 (W + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) u)
    have htop : ((⊤ : X.Opens) : Set X).Nonempty := ⟨genericPoint X, trivial⟩
    have hb := (mem_divisorSections_of_nonempty K htop).mp hgmem p.1 p.2 trivial
    rw [← huval, Scheme.ord_val_eq K u p.2, divisorBound_le_iff p.2,
      CurveDivisor.coeffAt_neg] at hb
    rw [CurveDivisor.coeffAt_add]
    omega
  · -- same class
    rw [CurveDivisor.picClass_add, CurveDivisor.picClass_divOf, mul_one]

end Effective

/-! ## Effective peeling of `Subsingleton H¹` -/

section Peel

variable {K : Type u} [Field K] {X : Scheme.{u}} [X.Over (Spec (CommRingCat.of K))]
  [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X]
  [QuasiCompact (X ↘ Spec (CommRingCat.of K))]