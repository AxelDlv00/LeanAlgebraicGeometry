---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.comp_slide_three
docstring: 'Replace a threefold prefix by a slid pair, then compare the residual composites.


  This is the categorical skeleton of the merged Sq3/Sq4 argument in

  `pullbackTensorMap_restrict`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.comp_slide_three
type: lean
updated: '2026-07-28T13:22:17'
---
private lemma comp_slide_three {C : Type*} [Category C]
    {a b b3 c1 c2 c3 d1 d2 d3 d4 d5 g : C}
    (v : a ⟶ b) (q : b ⟶ c1) (rtc : c1 ⟶ c2) (s3 : c2 ⟶ c3) (s4 : c3 ⟶ g)
    (m3 : a ⟶ d1) (m4 : d1 ⟶ d2) (vv : d2 ⟶ b3) (dh : b3 ⟶ d3) (sh3 : d3 ⟶ d4)
    (sh4 : d4 ⟶ d5) (tf : d5 ⟶ g) (vtail : b ⟶ b3)
    (hcomb : m3 ≫ m4 ≫ vv = v ≫ vtail)
    (hcore2 : q ≫ rtc ≫ s3 ≫ s4 = vtail ≫ dh ≫ sh3 ≫ sh4 ≫ tf) :
    v ≫ q ≫ rtc ≫ s3 ≫ s4 = m3 ≫ m4 ≫ vv ≫ dh ≫ sh3 ≫ sh4 ≫ tf := by
  rw [hcore2, ← Category.assoc v vtail, ← hcomb]
  simp only [Category.assoc]