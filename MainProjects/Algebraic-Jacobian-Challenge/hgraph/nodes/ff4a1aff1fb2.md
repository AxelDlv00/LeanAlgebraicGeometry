---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.appLE_congr_mor
docstring: '`appLE` transport along an equality of morphisms: for equal `f = g` the
  induced

  section maps `Γ(B, U) ⟶ Γ(A, W)` agree (the open-inequality witnesses are

  proof-irrelevant). Generic `subst` helper for the overlap structure-sheaf

  compatibility. Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.appLE_congr_mor
type: lean
updated: '2026-07-16T21:14:27'
---
lemma appLE_congr_mor {A B : Scheme.{u}} {f g : A ⟶ B} (h : f = g) (U : B.Opens)
    (W : A.Opens) (e : W ≤ f ⁻¹ᵁ U) (e' : W ≤ g ⁻¹ᵁ U) :
    f.appLE U W e = g.appLE U W e' := by
  subst h; rfl