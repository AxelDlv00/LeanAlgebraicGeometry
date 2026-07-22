---
author: sync
content_type: lemma
created: '2026-07-18T03:38:58'
decl: AlgebraicGeometry.Over.hom_f
docstring: The composite intertwining for the insertion `f₁₃ ≫ q₂`.
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Over.hom_f
type: lean
updated: '2026-07-22T17:56:04'
---
private lemma hom_f₁₃_q₂_appTop (x : Γ(XB, ⊤)) :
    (Scheme.ΓSpecIso (CommRingCat.of (B ⊗[A] (B ⊗[A] B)))).hom.hom
        ((f₁₃).appTop.hom ((q₂).appTop.hom x))
      = (1 : B) ⊗ₜ[A]
          ((1 : B) ⊗ₜ[A] ((Scheme.ΓSpecIso (CommRingCat.of B)).hom.hom x)) := by
  refine (hom_f₁₃_appTop ((q₂).appTop.hom x)).trans ?_
  refine (congrArg (tensorFace₁₃ (k := k) (A := A) (B := B)) (hom_q₂_appTop x)).trans ?_
  rfl

/-- The `ΓSpecIso`-image of `pairSection` is the two-base localization element
`(awayElt i ⊗ 1) ⋅ (1 ⊗ awayElt j)`. -/
lemma ΓSpecIso_hom_pairSection (i j : P.ι) :
    (Scheme.ΓSpecIso (CommRingCat.of (B ⊗[A] B))).hom.hom (pairSection P i j)
      = (awayElt P i ⊗ₜ[A] (1 : B)) * ((1 : B) ⊗ₜ[A] awayElt P j) :=
  ((congrArg _ (pairSection_def P i j)).trans (map_mul _ _ _)).trans
    (congrArg₂ (· * ·) (hom_q₁_appTop (P.r i)) (hom_q₂_appTop (P.r j)))