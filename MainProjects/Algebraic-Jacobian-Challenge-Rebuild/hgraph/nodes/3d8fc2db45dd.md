---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.Over.basicOpen_mul_le_left
docstring: "The trivializing unit at `a`. -/\nprivate noncomputable def μunit (w :\
  \ Γ(Sq, ⊤)ˣ)\n    (hW : Module.IsDescentCocycle\n      (Units.map (Scheme.ΓSpecIso\
  \ (.of (B ⊗[A] B))).hom.hom.toMonoidHom w))\n    (F : Scheme.TrivializingFamily\
  \ (SA) (Γ(SA, ⊤) ⊗[A] ↥(hW.descended))) (a : SA) :\n    Γ(SB, (gS) ⁻¹ᵁ (SA).basicOpen\
  \ (F.sec a))ˣ :=\n  (isUnit_μval w hW F a).unit\n\nprivate lemma μunit_val (w :\
  \ Γ(Sq, ⊤)ˣ)\n    (hW : Module.IsDescentCocycle\n      (Units.map (Scheme.ΓSpecIso\
  \ (.of (B ⊗[A] B))).hom.hom.toMonoidHom w))\n    (F : Scheme.TrivializingFamily\
  \ (SA) (Γ(SA, ⊤) ⊗[A] ↥(hW.descended))) (a : SA) :\n    (μunit w hW F a).val = μval\
  \ w hW F a :=\n  (isUnit_μval w hW F a).unit_spec\n\n/-! ## The transition identity\
  \ on values"
file: AlgebraicJacobian/Picard/DescentClassRepBuild.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Over.basicOpen_mul_le_left
type: lean
updated: '2026-07-30T15:46:01'
---
private lemma basicOpen_mul_le_left
    (f g : Γ(SA, ⊤)) :
    (SA).basicOpen (f * g) ≤ (SA).basicOpen f :=
  ((SA).basicOpen_mul f g).trans_le inf_le_left