---
author: sync
content_type: theorem
created: '2026-07-31T03:02:18'
decl: AlgebraicGeometry.P1.genus_asOver_eq_zero
docstring: '**`genus (ℙ¹_k) = 0`**, for every field `k` — the corollary, in the weaker
  numerical form.


  `genus` is `Module.finrank k (Sheaf.HModule (moduleKSheaf k) 1)` and the vanishing
  above makes

  that module a subsingleton, so the rank is `0`.  Note the direction: this is *implied
  by* the

  `Subsingleton` and does not imply it back, which is why `subsingleton_hModule_one`
  is the theorem

  to cite and this is the convenience form.


  The three binders `genus` requires are the ones `Curve/P1Curve.lean` supplies, so
  this statement

  is only expressible because that file exists.'
file: AlgebraicJacobian/Curve/P1H1Vanishing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.P1.genus_asOver_eq_zero
type: lean
updated: '2026-07-31T03:02:18'
---
theorem genus_asOver_eq_zero (k : Type u) [Field k] : genus (asOver k) = 0 := by
  rw [genus]
  haveI : Subsingleton (Sheaf.HModule (Scheme.moduleKSheaf k (asOver k).left) 1) :=
    subsingleton_hModule_one k
  exact Module.finrank_zero_of_subsingleton