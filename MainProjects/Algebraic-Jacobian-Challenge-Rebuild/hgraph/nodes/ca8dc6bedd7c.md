---
author: sync
content_type: lemma
created: '2026-07-24T17:02:48'
decl: AlgebraicGeometry.Over.hom_f₁₃_q₂_appTop
docstring: The composite intertwining for the insertion `f₁₃ ≫ q₂`.
file: AlgebraicJacobian/Picard/WitnessAway.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Over.hom_f₁₃_q₂_appTop
type: lean
updated: '2026-07-28T17:25:28'
---
private lemma hom_f₁₃_q₂_appTop (x : Γ(XB, ⊤)) :
    (Scheme.ΓSpecIso (CommRingCat.of (B ⊗[A] (B ⊗[A] B)))).hom.hom
        ((f₁₃).appTop.hom ((q₂).appTop.hom x))
      = (1 : B) ⊗ₜ[A]
          ((1 : B) ⊗ₜ[A] ((Scheme.ΓSpecIso (CommRingCat.of B)).hom.hom x)) := by
  refine (hom_f₁₃_appTop ((q₂).appTop.hom x)).trans ?_
  refine (congrArg (tensorFace₁₃ (k := k) (A := A) (B := B)) (hom_q₂_appTop x)).trans ?_
  rfl