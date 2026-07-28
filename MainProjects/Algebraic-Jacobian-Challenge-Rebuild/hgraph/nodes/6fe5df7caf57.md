---
author: sync
content_type: theorem
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.mem_chartLocus_of_drop
docstring: '**THE B-5 ASSEMBLY** (`w4-datb` §1.2, everything except the two per-fibre
  choices).


  For a point `t` of a general test `T` and a plus class `lam` over `T`: given a finite
  separable

  `L/κ(t)` presenting the fibre class, and a divisor `W₀` in the twisted class over
  `L` of degree

  `g + e` with vanishing `H¹`, the point `t` lies in `chartLocus C m Z lam` — and
  the drop at `L`

  additionally yields the `h⁰ = 1` normalisation.


  Reading this against `w4-datb` §1.2: steps 1, 2, 4, 5, 6 are all discharged (step
  1 by the

  `hM₀` hypothesis, which `exists_splitting_of_picEt` supplies unconditionally; step
  2/4 by the

  degree ledger of `Picard/Pic0ChartCoverageDegree.lean`; step 5 by the oracle; step
  6 by graph

  classes at the base, `Picard/Pic0ChartRationalGraph.lean`).  **Step 3 — the choice
  of `m` at

  the fibre''s own vanishing bound — is the residue**, and it appears here as the
  fact that `m`,

  `W₀` and `hdeg` are *inputs*: a caller must produce a `W₀` of degree `g + e` with
  `h¹ = 0`,

  which is exactly DAT-0a at `L`.


  That is the honest shape of what remains, and it is deliberately not hidden: the
  bound `b_L` is

  per-fibre and does not transport (I-0204), so no formulation of this theorem can
  produce `m`

  for the caller.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageTest.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_chartLocus_of_drop
type: lean
updated: '2026-07-28T19:44:57'
---
theorem mem_chartLocus_of_drop {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L] [Algebra.IsSeparable (Over.testPointField t) L]
    (g e : ℕ) (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
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
    t ∈ chartLocus C m Z lam
      ∧ ∃ S : ((C ⊗ overSpec k L).left).CurveDivisor, 0 ≤ S ∧
        Scheme.CurveDivisor.deg L S = (e : ℤ) ∧
        Sheaf.h0 ((C ⊗ overSpec k L).left.divisorSheaf L (W₀ - S)) = 1 ∧
        Subsingleton (Sheaf.HModule
          ((C ⊗ overSpec k L).left.divisorSheaf L (W₀ - S)) 1) := by
  obtain ⟨hsplit, S, hS0, hSdeg, -, hSh0, hSh1⟩ :=
    exists_isSplitWitness_of_drop C (picEtMap C (Over.testPoint t) lam) m Z g e hχ M₀ hM₀
      W₀ hW₀ hdeg h1 P hdense hPcl hPdeg
  exact ⟨mem_chartLocus_of_isSplitWitness_fibre C m Z lam t hsplit,
    S, hS0, hSdeg, hSh0, hSh1⟩