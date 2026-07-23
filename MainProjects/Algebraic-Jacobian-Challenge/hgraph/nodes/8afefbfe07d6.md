---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.inv_telescope
docstring: '**Generic interleaved 3-pair telescope (instance-agnostic).** A palindromic
  composite collapses to

  its centre `g` once the three nested pairs cancel (`A≫A'' = B≫B'' = C≫C'' = 𝟙`).  Stated
  over one

  `[Category C]` so the `Category.assoc` flattening runs on clean abstract variables
  — never on the

  `SheafOfModules` carrier where `simp/rw [Category.assoc]` whnf-bombs — then applied
  to the inverse of

  `sheafificationCompPullback_comp` by `exact`.  This is the Sq4a telescope of

  `sheafificationCompPullback_comp_inv`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.inv_telescope
type: lean
updated: '2026-07-16T21:14:28'
---
private lemma inv_telescope {C : Type*} [Category C] {w x y z t : C}
    (A : w ⟶ x) (A' : x ⟶ w) (B : x ⟶ y) (B' : y ⟶ x) (Cc : y ⟶ z) (C' : z ⟶ y) (g : w ⟶ t)
    (hA : A ≫ A' = 𝟙 w) (hB : B ≫ B' = 𝟙 x) (hC : Cc ≫ C' = 𝟙 y) :
    g = (A ≫ B ≫ Cc) ≫ C' ≫ B' ≫ A' ≫ g := by
  simp only [Category.assoc]
  rw [← Category.assoc Cc C', hC, Category.id_comp, ← Category.assoc B B', hB, Category.id_comp,
    ← Category.assoc A A', hA, Category.id_comp]