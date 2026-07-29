---
author: sync
content_type: lemma
created: '2026-07-17T10:20:05'
decl: AlgebraicGeometry.pullback_lift_diff_self
docstring: '**Scheme-level diagonal triviality core.** For an over-`k̄` morphism

  `A : T ⟶ G.left` (structure map `t`), pairing `A` with itself and applying the

  group difference gives the constant unit morphism: `⟨A, A⟩ ≫ (g,h ↦ g·h⁻¹) = t ≫
  e`.

  This is `CategoryTheory.GrpObj.lift_diff_self` transported through `Over.forget`.'
file: AlgebraicJacobian/Albanese/Milne33Rows.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pullback_lift_diff_self
type: lean
updated: '2026-07-29T15:31:33'
---
lemma pullback_lift_diff_self (G : Over (Spec (.of kbar))) [GrpObj G]
    {T : Scheme.{u}} (t : T ⟶ Spec (.of kbar)) (A : T ⟶ G.left)
    (hA : A ≫ G.hom = t) :
    pullback.lift A A rfl ≫ grpObjDiffLeft G = t ≫ grpObjUnitPoint G := by
  have key := congrArg (fun m : Over.mk t ⟶ G => m.left)
    (GrpObj.lift_diff_self G (Over.homMk A hA))
  simp only [Over.comp_left, Over.lift_left, Over.homMk_left,
    Over.toUnit_left, Over.mk_hom] at key
  exact key

/-! ## §2. The diagonal and the rows of the self-product -/

variable (X : Over (Spec (.of kbar)))