---
author: sync
content_type: theorem
created: '2026-07-28T19:44:57'
decl: AlgebraicGeometry.mem_chartLocus_of_drop
docstring: "**THE B-5 ASSEMBLY** (`w4-datb` §1.2, everything except the two per-fibre\
  \ choices).\n\nFor a point `t` of a general test `T` and a plus class `lam` over\
  \ `T`: given a finite separable\n`L/κ(t)` presenting the fibre class, and a divisor\
  \ `W₀` in the twisted class over `L` of degree\n`g + e` with vanishing `H¹`, the\
  \ point `t` lies in `chartLocus C m Z lam` — and the drop at `L`\nadditionally yields\
  \ the `h⁰ = 1` normalisation.\n\n**Reading this against `w4-datb` §1.2 — corrected,\
  \ and the earlier version of this paragraph\nwas wrong in two places** (issues I-0614,\
  \ I-0615).  It said \"steps 1, 2, 4, 5, 6 are all\ndischarged\".  Three of those\
  \ five are; the other two are not:\n\n* **step 1 — discharged.**  The `hM₀` hypothesis,\
  \ which `exists_splitting_of_picEt` supplies\n  unconditionally.\n* **step 2 — DISCHARGED\
  \ 2026-07-28, this line supersedes the \"NOT discharged\" it replaced.**\n  The\
  \ missing input was base-field invariance of `degAff` under `PicEtAff.map`; it is\
  \ now\n  `PicEtAff.degAff_map` (`Picard/DegreeZeroBaseField.lean`) and holds for\
  \ an **arbitrary** field\n  extension `L/K`, with no finiteness or separability.\
  \  Step 2 itself is\n  `classDeg_presenting_eq_zero` (`Picard/Pic0ChartCoverageDegreeStep2.lean`),\
  \ and the whole\n  twisted ledger closes to `g + e` there.\n* **step 4 — discharged**\
  \ as an input: `hdeg` + `h1`.\n* **step 5 — discharged** by the oracle.\n* **step\
  \ 6 — NOT NEEDED, which supersedes \"NOT discharged\".**  The feedback is real for\
  \ the\n  route *through the drop*, and the DEFECT section's arithmetic stands. \
  \ But coverage does not\n  need the drop: `IsSplitWitness` asks for `h¹ = 0` and\
  \ for **neither** effectivity **nor**\n  degree `g`, so a witness of the twisted\
  \ class suffices and there is only ever one `Z`.  See\n  `Picard/Pic0ChartCoverageNoDrop.lean`,\
  \ whose `mem_chartLocus_of_witness_h1` strictly\n  generalises this theorem's membership\
  \ half — with `g`, `e`, `hχ`, `hdeg` and the whole oracle\n  deleted rather than\
  \ discharged.\n* **step 3 — the residue this paragraph originally named**, and still\
  \ a residue: `m`, `W₀` and\n  `hdeg` are *inputs*, because `b_L` is per-fibre and\
  \ does not transport (I-0204), so no\n  formulation of this theorem can produce\
  \ `m` for the caller.\n\n**Note one conclusion this theorem deliberately drops**\
  \ — wanted not by coverage (which needs no\ndrop at all, see the step-6 entry above)\
  \ but by DAT-C's canonical section and GAP-2 uniqueness: the fibre\nstep returns\
  \ `S`'s support clause (`coeffAt hx S ≠ 0 → x ∈ P`), and the `-` pattern below\n\
  discards it.  A lane closing step 6 should re-expose it — it is what says `Σ` is\
  \ supported in\nthe rational points whose graph classes the index is built from."
file: AlgebraicJacobian/Picard/Pic0ChartCoverageTest.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_chartLocus_of_drop
type: lean
updated: '2026-07-29T02:23:55'
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