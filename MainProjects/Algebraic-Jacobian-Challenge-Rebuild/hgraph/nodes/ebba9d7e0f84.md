---
author: sync
content_type: theorem
created: '2026-07-29T00:02:39'
decl: AlgebraicGeometry.mem_chartLocus_of_witness_h1
docstring: '**COVERAGE, DROP-FREE** — `w4-datb` §1.2 with steps 4, 5 and 6 deleted
  rather than

  discharged.


  For a point `t` of an arbitrary test `T` and a plus class `lam`: given a finite
  separable

  `L/κ(t)` presenting the fibre class by `M₀`, and **any** divisor `W` of the twisted
  class over

  `L` with `Subsingleton H¹(𝒪(W))`, the point `t` lies in `chartLocus C m Z lam`.


  Compare `mem_chartLocus_of_drop`, whose membership half this strictly generalises:
  that theorem

  additionally takes `g`, `e`, `hχ`, `hdeg` and a four-part point oracle, and uses
  none of them

  for the membership conclusion.  Dropping them is what removes step 6''s feedback
  — the drop''s

  output `Σ` was the only reason two different `Z`s were in play.'
file: AlgebraicJacobian/Picard/Pic0ChartCoverageNoDrop.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.mem_chartLocus_of_witness_h1
type: lean
updated: '2026-07-31T20:14:52'
---
theorem mem_chartLocus_of_witness_h1 {T : Over (Spec (.of k))} (lam : picEt C T) (t : T.left)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    {L : Type u} [Field L] [Algebra k L] [Algebra (Over.testPointField t) L]
    [IsScalarTower k (Over.testPointField t) L]
    [Module.Finite (Over.testPointField t) L]
    [Algebra.IsSeparable (Over.testPointField t) L]
    (M₀ : (relCurve C L).CechPic)
    (hM₀ : PicEtAff.map C L
        (picEtAffineEquiv C (Over.testPointField t) (picEtMap C (Over.testPoint t) lam))
      = PicEtAff.unit C L (relPicMk C (overSpec k L) M₀))
    (W : ((C ⊗ overSpec k L).left).CurveDivisor)
    (hW : Scheme.CurveDivisor.picClass L W
      = M₀ * Scheme.CechPic.map (relCurveMap C k L) (chartTwistClass C m Z))
    (h1 : Subsingleton (Sheaf.HModule ((C ⊗ overSpec k L).left.divisorSheaf L W) 1)) :
    t ∈ chartLocus C m Z lam :=
  mem_chartLocus_of_isSplitWitness_fibre C m Z lam t
    (isSplitWitness_of_witness_twistClass C (picEtMap C (Over.testPoint t) lam) m Z M₀ hM₀
      W hW h1)

/-! ## Producing the witness from a degree threshold -/

variable (C) in