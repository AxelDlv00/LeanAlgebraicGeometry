---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_comp4_mid
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.isIso_of_isIso_comp4_mid
type: lean
updated: '2026-07-26T05:44:41'
---
private lemma isIso_of_isIso_comp4_mid {C : Type*} [Category C] {W₀ X₀ Y₀ Z₀ T₀ : C}
    {a : W₀ ⟶ X₀} {b : X₀ ⟶ Y₀} {c : Y₀ ⟶ Z₀} {d : Z₀ ⟶ T₀}
    (h : IsIso (a ≫ b ≫ c ≫ d)) (ha : IsIso a) (hc : IsIso c) (hd : IsIso d) : IsIso b := by
  haveI := h; haveI := ha; haveI := hc; haveI := hd
  haveI : IsIso (b ≫ c ≫ d) := IsIso.of_isIso_comp_left a (b ≫ c ≫ d)
  exact IsIso.of_isIso_comp_right b (c ≫ d)