---
author: sync
content_type: theorem
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.exists_isSplitWitness_of_drop
docstring: '**B-5''s fibre step** (`w4-datb` §1.2 steps 4–5, run at the splitting
  field; **not** step 6 —

  see the header correction and issue I-0615).


  Given the twisted fibre class presented over `L` by `M`, a divisor `W₀` in `M` of
  degree

  `g + e` with vanishing `H¹`, and an admissible point oracle `P` on the `L`-curve,
  the greedy

  drop produces `S` of degree `e` supported in `P` with `h⁰(W₀ − S) = 1` and `h¹(W₀
  − S) = 0`;

  and the class of `W₀` itself already certifies `IsSplitWitness` of the twisted class.


  The two conclusions serve different consumers, which is why both are returned: the

  `IsSplitWitness` half is `chartLocus` membership (`w4-datb` §1.2''s target), while
  the

  `h⁰ = 1` half is what DAT-C''s normalization and the GAP-2 uniqueness of the effective

  representative consume.


  **The `S`-becomes-the-chart-index sentence that stood here is RETRACTED** (issue
  I-0615, and this

  was its last residual site — the file header at the top of this module already carried
  the

  correction, and the worksheet''s `w4-datb` §1.2 SECOND AMENDMENT retracts it harder).  Coverage
  does

  not feed `S` back as the chart index, because it does not need the drop at all:

  `IsSplitWitness` asks for `h¹ = 0` and for **neither** effectivity **nor** degree
  `g`

  (`Picard/Pic0ChartCoverageNoDrop.lean`, `mem_chartLocus_of_witness_h1`).  What the
  drop''s output

  *is* needed for is DAT-C''s canonical section and GAP-2''s uniqueness, which do
  require `0 ≤ W` and

  `h⁰ = 1` — i.e. the chart map''s injectivity, not its coverage.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageFibre.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.exists_isSplitWitness_of_drop
type: lean
updated: '2026-07-31T20:15:26'
---
theorem exists_isSplitWitness_of_drop {K : Type u} [Field K] [Algebra k K]
    (μ : picEt C (overSpec k K)) (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra K L] [IsScalarTower k K L]
    [Module.Finite K L] [Algebra.IsSeparable K L]
    (g e : ℕ) (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L (picEtAffineEquiv C K μ)
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    (W₀ : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hW₀ : Scheme.CurveDivisor.picClass L W₀
      = M₀ * Scheme.CechPic.map (relCurveMap C k L) (chartTwistClass C m Z))
    (hdeg : Scheme.CurveDivisor.deg L W₀ = (g : ℤ) + e)
    (h1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W₀) 1))
    (P : Set ((C ⊗ overSpec k L).left))
    (hdense : ∀ U : ((C ⊗ overSpec k L).left).Opens,
      (U : Set ((C ⊗ overSpec k L).left)).Nonempty → (P ∩ U).Nonempty)
    (hPcl : ∀ x ∈ P, x ≠ genericPoint ((C ⊗ overSpec k L).left))
    (hPdeg : ∀ x ∈ P, ((C ⊗ overSpec k L).left).residueDeg L x = 1) :
    IsSplitWitness C (μ * thetaFamily C (chartTwistClass C m Z) (overSpec k K))
      ∧ ∃ S : ((C ⊗ overSpec k L).left).CurveDivisor, 0 ≤ S ∧
        Scheme.CurveDivisor.deg L S = (e : ℤ) ∧
        (∀ (x : ((C ⊗ overSpec k L).left))
          (hx : x ≠ genericPoint ((C ⊗ overSpec k L).left)),
          coeffAt hx S ≠ 0 → x ∈ P) ∧
        Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L (W₀ - S)) = 1 ∧
        Subsingleton (Sheaf.HModule
          ((C ⊗ overSpec k L).left.divisorSheaf L (W₀ - S)) 1) := by
  refine ⟨isSplitWitness_of_witness_twistClass C μ m Z M₀ hM₀ W₀ hW₀ h1, ?_⟩
  -- the χ-value at the fibre field, transported from `k` (genus is base-field invariant)
  -- The instance pack of `BaseChangeInstances` is keyed to the PRODUCT spelling
  -- `(C ⊗ overSpec k L).left`, not to the `relCurve` alias, so `chi_relCurve_baseField`'s
  -- `relCurve`-spelled binders do not synthesise without these three re-keyings.
  haveI : IsIntegral (relCurve C L) := instIsIntegralBaseChange C L
  haveI : SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    instSmoothOfRelativeDimensionBaseChange C L
  haveI : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    instQuasiCompactBaseChange C L
  haveI : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
    instModuleFiniteHModuleZeroBaseChange C L
  haveI : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
    instModuleFiniteHModuleOneBaseChange C L
  have hχL : Sheaf.chi ((relCurve C L).moduleKSheaf L) = 1 - (g : ℤ) :=
    chi_relCurve_baseField C L g hχ
  exact exists_effective_sub_h0_eq_one (K := L) g hχL P hdense hPcl hPdeg W₀ e hdeg h1