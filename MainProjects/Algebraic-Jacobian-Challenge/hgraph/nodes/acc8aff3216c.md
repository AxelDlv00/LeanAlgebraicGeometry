---
author: sync
content_type: theorem
created: '2026-07-28T22:57:23'
decl: AlgebraicGeometry.exists_unit_nonneg_of_h0_pos
docstring: '**A nonzero global section is an effectivity certificate** (the bridge):
  if `𝒪(A)` has a

  nonzero global section then there is `g ∈ K(X)ˣ` with `0 ≤ A + div g`.


  **Provenance.** AJCR proves the same fact as

  `RiemannRoch/SectionBound.exists_effective_of_h0_pos`, but *states* it as "the class
  of `A` is

  realised by an effective divisor", through `CurveDivisor.picClass` — Picard vocabulary
  that

  AJC''s Ledger tree does not import and does not want here.  The three steps (extract
  a nonzero

  element of `H⁰` through `linearEquiv₀`, read it as a nonzero rational function,
  turn the pole

  bound into `0 ≤ A + div g` at each point) are AJCR''s; the statement is stripped
  of `picClass`

  so that it lands one import above `DivisorSheaf`/`MulEquiv` and needs no Picard
  layer.'
file: AlgebraicJacobian/RiemannRoch/Ledger/DegreeVanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_unit_nonneg_of_h0_pos
type: lean
updated: '2026-07-28T22:57:23'
---
theorem exists_unit_nonneg_of_h0_pos (A : X.CurveDivisor)
    (hA : 0 < Sheaf.h0 (X.divisorSheaf K A)) :
    ∃ g : X.functionFieldˣ,
      0 ≤ A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) g := by
  haveI : Nontrivial (Sheaf.HModule (X.divisorSheaf K A) 0) :=
    Module.nontrivial_of_finrank_pos hA
  obtain ⟨t, ht⟩ := exists_ne (0 : Sheaf.HModule (X.divisorSheaf K A) 0)
  set s := (Sheaf.HModule.linearEquiv₀ (Opens.grothendieckTopology (X : TopCat))
    (isTerminalTop : IsTerminal (⊤ : X.Opens)) (X.divisorSheaf K A)) t with hs
  have hsne : s ≠ 0 := by
    rw [hs]; exact (LinearEquiv.map_ne_zero_iff _).mpr ht
  set g : X.functionField := divisorVal K s with hg
  have hgmem : g ∈ divisorSections K A ⊤ := divisorVal_mem K s
  have hgne : g ≠ 0 := by
    intro h
    exact hsne (divisorSection_ext K
      (show divisorVal K s = divisorVal K (0 : _) from by rw [← hg, h]; rfl))
  refine ⟨Units.mk0 g hgne, ?_⟩
  refine Finsupp.le_def.mpr (fun p => ?_)
  have htop : ((⊤ : X.Opens) : Set X).Nonempty := ⟨genericPoint X, trivial⟩
  have hb := (mem_divisorSections_of_nonempty K htop).mp hgmem p.1 p.2 trivial
  have hval : Scheme.ord (X ↘ Spec (CommRingCat.of K)) p.2
      ((Units.mk0 g hgne : X.functionFieldˣ) : X.functionField)
      = divisorBound (- Scheme.divOf (X ↘ Spec (CommRingCat.of K))
          (Units.mk0 g hgne)) p.2 :=
    Scheme.ord_val_eq K (Units.mk0 g hgne) p.2
  rw [show ((Units.mk0 g hgne : X.functionFieldˣ) : X.functionField) = g from rfl,
    hval] at hb
  -- both sides are `ofAdd` of an integer coefficient, so the valuation inequality is an
  -- inequality of coefficients.
  simp only [divisorBound, WithZero.coe_le_coe, Multiplicative.ofAdd_le] at hb
  change (0 : ℤ) ≤ (toFinsupp
    (A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 g hgne))) p
  have hadd : (toFinsupp
      (A + Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 g hgne))) p
      = (toFinsupp A) p
        + (toFinsupp (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 g hgne))) p :=
    rfl
  have hneg : (toFinsupp (- Scheme.divOf (X ↘ Spec (CommRingCat.of K))
      (Units.mk0 g hgne))) p
      = - (toFinsupp (Scheme.divOf (X ↘ Spec (CommRingCat.of K)) (Units.mk0 g hgne))) p :=
    rfl
  rw [hadd]
  rw [hneg] at hb
  omega

/-! ## Translating the base vanishing along a linear equivalence

The peel needs a vanishing divisor **below** `D`.  A given `D₀` need not be below `D`, but its
linear-equivalence class is spread over the whole divisor group, and `H¹` is a class invariant
(`mulEquivDivisorSheaf` plus `Sheaf.h1_congr` / the `Subsingleton` transport).  The Riemann
inequality then supplies the translating function. -/

variable [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)]

omit [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 0)]
  [Module.Finite K (Sheaf.HModule (X.moduleKSheaf K) 1)] in