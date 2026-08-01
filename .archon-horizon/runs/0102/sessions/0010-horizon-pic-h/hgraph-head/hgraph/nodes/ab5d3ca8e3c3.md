---
author: sync
content_type: lemma
created: '2026-07-19T10:01:15'
decl: AlgebraicGeometry.twistRes_relThetaFieldSection
docstring: '(Implementation) The top-restricted `k`-level section is the chart-0 collapse
  of the

  top-restricted field pair — the `H⁰`-carrier val computation through

  `TwoCoverPairData.h0Equiv_val` and the kernel transport of the base-field collapse.'
file: AlgebraicJacobian/Picard/DivSchemeEpsCarveKit.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.twistRes_relThetaFieldSection
type: lean
updated: '2026-08-01T09:44:11'
---
private lemma twistRes_relThetaFieldSection
    (h : ↥(divisorSections k (n • fiberWeilDivisor π) ⊤)) :
    twistRes k (relCover C k (fiberTwoCover π)).V₀ (relCover C k (fiberTwoCover π)).V₁
        (relThetaCocycle C k π n) le_top (relThetaFieldSection C π n h)
      = twistCollapse₀ C π n
          (twistRes k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) le_top
            (thetaSectionPair C π n h)) := by
  obtain ⟨y, hy⟩ : ∃ y,
      ((relThetaH0FieldEquiv C π n).trans (thetaTwistH0Equiv k π n)).symm h = y :=
    ⟨_, rfl⟩
  have h0 : thetaTwistH0Equiv k π n (relThetaH0FieldEquiv C π n y) = h := by
    rw [← hy]
    exact ((relThetaH0FieldEquiv C π n).trans
      (thetaTwistH0Equiv k π n)).apply_symm_apply h
  have h1 : relThetaH0FieldEquiv C π n y = (thetaTwistH0Equiv k π n).symm h :=
    (LinearEquiv.eq_symm_apply (thetaTwistH0Equiv k π n)).mpr h0
  rw [relThetaH0FieldEquiv, LinearEquiv.trans_apply, LinearEquiv.trans_apply] at h1
  have h2 := (LinearEquiv.symm_apply_eq (thetaFieldH0PairEquiv C π n)).mp h1
  have h3 := (LinearEquiv.symm_apply_eq
    (AlgebraicJacobian.RigidEngine.kerCongr (thetaFieldPair C π n).diff
      (relTwistPair C k π (relThetaCocycle C k π n)).diff
      (twistCollapseDomEquiv C π n) (twistCollapseN C π n)
      (twistCollapseN_diff C π n))).mp h2
  have hL := congrArg Prod.fst (Scheme.TwoCoverPairData.h0Equiv_val
    (relTwistPairData C k π (relThetaCocycle C k π n))
    (relCover_isAffineOpen₀ C k (fiberTwoCover π))
    (relCover_isAffineOpen₁ C k (fiberTwoCover π))
    (relCover_sup C k (fiberTwoCover π)) y)
  have hR := congrArg Prod.fst (Scheme.TwoCoverPairData.h0Equiv_val
    (thetaFieldPairData C π n) (isAffineOpen_preimage_chartOpen π 0)
    (isAffineOpen_preimage_chartOpen π 1) (preimage_chartOpen_sup π)
    ((thetaTwistH0Equiv k π n).symm h))
  have hW : relThetaFieldSection C π n h
      = relTwistSectionsEquiv₀ C k (fiberTwoCover π) (relThetaCocycle C k π n) y := by
    rw [relThetaFieldSection, hy]
  rw [hW]
  refine (hL.symm.trans ?_).trans (congrArg (twistCollapse₀ C π n) hR)
  exact congrArg
    (fun q : ↥(relTwistPair C k π (relThetaCocycle C k π n)).H0 => q.val.1) h3

set_option maxHeartbeats 1600000 in
-- Mixed `relCurve`/twist spellings force heavy defeq checks (`respectTransparency false`).
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 4000 in