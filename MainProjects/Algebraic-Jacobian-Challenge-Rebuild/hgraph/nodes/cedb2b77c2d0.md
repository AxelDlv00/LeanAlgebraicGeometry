---
author: sync
content_type: theorem
created: '2026-07-28T14:44:53'
decl: AlgebraicGeometry.picFromBase_eq_bot_of_subsingleton
docstring: '**`picFromBase` is trivial at a one-point test object.** Classes on `C
  ⊗ T` pulled back

  from `T` form the range of `CechPic.map (snd C T).left`; when `T.left` has a subsingleton

  underlying space its Čech Picard group is trivial

  (`Scheme.CechPic.subsingleton_of_subsingleton`), so that range is `⊥`.


  No hypothesis on `C` whatsoever, and no commutative algebra: the argument is that
  a

  one-point space has no cover with a nontrivial overlap.'
file: AlgebraicJacobian/Tangent/RelPicPointTest.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.picFromBase_eq_bot_of_subsingleton
type: lean
updated: '2026-07-31T20:14:50'
---
theorem picFromBase_eq_bot_of_subsingleton (T : Over (Spec (.of k)))
    [Subsingleton T.left] : picFromBase C T = ⊥ := by
  refine le_antisymm (fun L hL => ?_) bot_le
  obtain ⟨N, hN⟩ := (mem_picFromBase_iff (C := C)).mp hL
  rw [← hN, Scheme.CechPic.eq_one_of_subsingleton _ N, map_one]
  exact Subgroup.mem_bot.mpr rfl