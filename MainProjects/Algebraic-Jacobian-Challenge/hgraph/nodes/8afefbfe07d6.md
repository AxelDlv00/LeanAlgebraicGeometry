---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.inv_telescope
docstring: Collapse a palindromic composite when its three nested pairs are inverse.
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.inv_telescope
type: lean
updated: '2026-07-25T05:32:31'
---
private lemma inv_telescope {C : Type*} [Category C] {w x y z t : C}
    (A : w ⟶ x) (A' : x ⟶ w) (B : x ⟶ y) (B' : y ⟶ x) (Cc : y ⟶ z) (C' : z ⟶ y) (g : w ⟶ t)
    (hA : A ≫ A' = 𝟙 w) (hB : B ≫ B' = 𝟙 x) (hC : Cc ≫ C' = 𝟙 y) :
    g = (A ≫ B ≫ Cc) ≫ C' ≫ B' ≫ A' ≫ g := by
  simp only [Category.assoc]
  rw [← Category.assoc Cc C', hC, Category.id_comp, ← Category.assoc B B', hB, Category.id_comp,
    ← Category.assoc A A', hA, Category.id_comp]