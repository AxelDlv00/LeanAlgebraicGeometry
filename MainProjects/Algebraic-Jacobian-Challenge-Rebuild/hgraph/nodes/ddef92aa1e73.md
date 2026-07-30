---
author: sync
content_type: definition
created: '2026-07-17T10:20:05'
decl: AlgebraicGeometry.rowSnd
docstring: 'The row morphism `x ↦ (x, u)` through a rational point `u` (given as a

  `k̄`-point `pt : Spec k̄ ⟶ X.left`): second coordinate frozen at `u`.'
file: AlgebraicJacobian/Albanese/Milne33Rows.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.rowSnd
type: lean
updated: '2026-07-30T15:28:04'
---
noncomputable def rowSnd (pt : Spec (.of kbar) ⟶ X.left) (hpt : pt ≫ X.hom = 𝟙 _) :
    X.left ⟶ pullback X.hom X.hom :=
  pullback.lift (𝟙 _) (X.hom ≫ pt)
    (by rw [Category.id_comp, Category.assoc, hpt, Category.comp_id])

variable {X} in
@[simp]