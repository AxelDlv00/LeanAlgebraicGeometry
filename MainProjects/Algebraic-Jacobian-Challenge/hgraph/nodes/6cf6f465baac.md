---
author: sync
content_type: theorem
created: '2026-07-30T22:32:50'
decl: AlgebraicGeometry.Scheme.PicScheme.picEt_comparison_eq_iff_map_inv
docstring: 'The same cancellation in the orientation the composite''s endgame presents:
  an

  equation against `map (hom) c` is the same as `map (inv)` of the left side being
  `c`.

  `w` is a class on the **twisted** restricted test, which is why this is not a

  restatement of `picEt_map_comparison_eq_iff` with substituted variables.'
file: AlgebraicJacobian/Picard/PicEtInvariantMatch.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.PicScheme.picEt_comparison_eq_iff_map_inv
type: lean
updated: '2026-07-30T22:32:50'
---
theorem picEt_comparison_eq_iff_map_inv (D : Over (Spec (CommRingCat.of k')))
    (γ : k' ≃ₐ[k] k')
    (w : (picEt C).obj (op ((twistTestFunctor (k := k) γ ⋙ restrictTest k k').obj D)))
    (c : (picEt C).obj (op ((restrictTest k k').obj D))) :
    (w = (picEt C).map
          ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app D).op c)
      ↔ (picEt C).map
            ((restrictTest_twistTestFunctor_iso (k := k) γ).inv.app D).op w = c := by
  have hIH : ∀ z : (picEt C).obj (op ((restrictTest k k').obj D)),
      (picEt C).map ((restrictTest_twistTestFunctor_iso (k := k) γ).inv.app D).op
          ((picEt C).map
            ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app D).op z) = z := by
    intro z
    rw [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
      (restrictTest_twistTestFunctor_iso (k := k) γ).inv_hom_id_app]
    simp
  have hHI : ∀ v : (picEt C).obj
        (op ((twistTestFunctor (k := k) γ ⋙ restrictTest k k').obj D)),
      (picEt C).map ((restrictTest_twistTestFunctor_iso (k := k) γ).hom.app D).op
          ((picEt C).map
            ((restrictTest_twistTestFunctor_iso (k := k) γ).inv.app D).op v) = v := by
    intro v
    rw [← CategoryTheory.comp_apply, ← Functor.map_comp, ← op_comp,
      (restrictTest_twistTestFunctor_iso (k := k) γ).hom_inv_id_app]
    simp
  constructor
  · intro h; rw [h]; exact hIH c
  · intro h; rw [← h]; exact (hHI w).symm

/-! ## §3. THE MATCH, DISCHARGED -/

set_option maxHeartbeats 1000000 in
-- Heartbeat headroom: the `Over`/`pullback`/`baseTest` coercion chain is unfolded
-- repeatedly against `IsEquivariant`'s and `picEt`'s differing spellings of one
-- object, as in `PicEtDescentGoal.lean`'s §2b. Not a slow proof: each is a rewrite
-- chain, but elaborating the statement costs the default budget on its own.