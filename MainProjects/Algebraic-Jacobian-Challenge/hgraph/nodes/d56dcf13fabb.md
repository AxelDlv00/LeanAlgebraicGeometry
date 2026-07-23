---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.isAffineOpen_iInf_fin
docstring: 'A finite (nonempty-indexed) infimum of affine opens of a separated scheme
  is affine.

  Induction on the index bound via `IsAffineOpen.inf` (which needs the affine diagonal
  of `X`,

  available since `X` is separated). Project-local helper.'
file: AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.isAffineOpen_iInf_fin
type: lean
updated: '2026-07-16T21:14:26'
---
private lemma isAffineOpen_iInf_fin [X.IsSeparated] :
    ∀ (p : ℕ) (W : Fin (p + 1) → X.Opens), (∀ k, IsAffineOpen (W k)) →
      IsAffineOpen (⨅ k, W k) := by
  haveI : IsClosedImmersion (pullback.diagonal (terminal.from X)) :=
    IsSeparated.isClosedImmersion_diagonal
  intro p
  induction p with
  | zero =>
    intro W hW
    have heq : (⨅ k, W k) = W 0 :=
      le_antisymm (iInf_le _ 0) (le_iInf fun k =>
        le_of_eq (congrArg W (Fin.ext (Nat.lt_one_iff.mp k.isLt)).symm))
    rw [heq]; exact hW 0
  | succ p ih =>
    intro W hW
    have hsplit : (⨅ k, W k) = W 0 ⊓ ⨅ k : Fin (p + 1), W k.succ := by
      refine le_antisymm (le_inf (iInf_le _ 0) (le_iInf fun k => iInf_le _ k.succ))
        (le_iInf fun k => ?_)
      rcases Fin.eq_zero_or_eq_succ k with hk | ⟨j, hj⟩
      · subst hk; exact inf_le_left
      · subst hj; exact inf_le_of_right_le (iInf_le _ j)
    rw [hsplit]
    exact (hW 0).inf (ih (fun k => W k.succ) (fun k => hW k.succ))