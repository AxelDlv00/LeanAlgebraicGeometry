---
author: sync
content_type: lemma
created: '2026-07-16T21:33:29'
decl: AlgebraicGeometry.jumpProj_eq_of_coe_eq
docstring: '`jumpProj` depends only on the underlying rational function: two sections
  (over possibly

  different opens both containing `x`) with the same value in `K(X)` project to the
  same class.'
file: AlgebraicJacobian/RiemannRoch/Devissage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.jumpProj_eq_of_coe_eq
type: lean
updated: '2026-07-16T21:33:29'
---
lemma jumpProj_eq_of_coe_eq {U V : X.Opens} (hxU : x ∈ U) (hxV : x ∈ V)
    (s : divisorSections K D U) (t : divisorSections K D V)
    (h : (s : X.functionField) = (t : X.functionField)) :
    jumpProj K hx D U hxU s = jumpProj K hx D V hxV t := by
  rw [jumpProj_apply, jumpProj_apply]
  exact congrArg _ (Subtype.ext h)

/-! ## S2: the skyscraper morphism `π : 𝒪(D) ⟶ sky_x J` -/

variable {K}

omit [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of K))] [IsIntegral X] in