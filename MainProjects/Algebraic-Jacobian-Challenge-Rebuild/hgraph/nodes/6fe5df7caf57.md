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
  \ which `exists_splitting_of_picEt` supplies\n  unconditionally.\n* **step 2 — NOT\
  \ discharged.**  It needs `degAt λ_t = 0` transported to the presenting Čech\n \
  \ class, and the theorem meant to do that (`classDeg_of_presenting`) cannot: it\
  \ relates\n  `classDeg L M` to the plus-class degree **at `L`**, while the coverage\
  \ argument has it at `K`,\n  and base-field invariance of `degAff` under `PicEtAff.map`\
  \ does not exist in the tree.  See\n  that theorem's docstring; the missing lemma\
  \ is small but real.\n* **step 4 — discharged** as an input: `hdeg` + `h1`.\n* **step\
  \ 5 — discharged** by the oracle.\n* **step 6 — NOT discharged.**  The drop's output\
  \ `Σ` must become the chart index's `Z`, and\n  the graph transport of `Picard/Pic0ChartRationalGraph.lean`\
  \ goes *upward from a `k`-point*,\n  not from the `L`-level divisor the drop produces.\
  \  See the DEFECT section above for why the\n  two stages carry different `Z`.\n\
  * **step 3 — the residue this paragraph originally named**, and still a residue:\
  \ `m`, `W₀` and\n  `hdeg` are *inputs*, because `b_L` is per-fibre and does not\
  \ transport (I-0204), so no\n  formulation of this theorem can produce `m` for the\
  \ caller.\n\n**Note one conclusion this theorem deliberately drops and step 6 will\
  \ want back**: the fibre\nstep returns `S`'s support clause (`coeffAt hx S ≠ 0 →\
  \ x ∈ P`), and the `-` pattern below\ndiscards it.  A lane closing step 6 should\
  \ re-expose it — it is what says `Σ` is supported in\nthe rational points whose\
  \ graph classes the index is built from."
file: AlgebraicJacobian/Picard/Pic0ChartCoverageTest.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.mem_chartLocus_of_drop
type: lean
updated: '2026-07-28T22:23:04'
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