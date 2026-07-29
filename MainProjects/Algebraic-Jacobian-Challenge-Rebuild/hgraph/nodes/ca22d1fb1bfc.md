---
author: sync
content_type: theorem
created: '2026-07-16T21:33:28'
decl: CategoryTheory.PresheafOfGroups.H1.subsingleton_of_forall_le
docstring: 'If the members of the family are mutually comparable (e.g. the family
  is constant,

  as for a cover of a one-point space), then `H1` is trivial: every 1-cocycle is a

  coboundary via `α i := γ.evInf`-type data at a base index.'
file: AlgebraicJacobian/Picard/CechH1.lean
generated: lean
lean_status: lean_ok
stale: true
title: CategoryTheory.PresheafOfGroups.H1.subsingleton_of_forall_le
type: lean
updated: '2026-07-29T15:26:34'
---
theorem H1.subsingleton_of_forall_le (G : Pᵒᵖ ⥤ GrpCat.{w}) (U : I → P)
    (h : ∀ i j, U i ≤ U j) : Subsingleton (H1 G U) := by
  have key : ∀ γ : OneCocycle G U, (1 : OneCocycle G U).IsCohomologous γ := by
    intro γ
    cases isEmpty_or_nonempty I with
    | inl hI => exact ⟨1, fun i ↦ isEmptyElim i⟩
    | inr hI =>
      obtain ⟨i₀⟩ := hI
      refine ⟨fun i ↦ γ.ev i i₀ (𝟙 (U i)) (homOfLE (h i i₀)), fun i j T a b ↦ ?_⟩
      dsimp only
      rw [OneCocycle.one_toOneCochain, OneCochain.one_ev, mul_one,
        OneCochain.ev_precomp, OneCochain.ev_precomp, Category.comp_id, Category.comp_id,
        γ.ev_trans i j i₀ a b (b ≫ homOfLE (h j i₀)),
        Subsingleton.elim (a ≫ homOfLE (h i i₀)) (b ≫ homOfLE (h j i₀))]
  refine ⟨fun x y ↦ ?_⟩
  induction x using Quot.ind with
  | _ γ =>
    induction y using Quot.ind with
    | _ δ =>
      exact Quot.sound ((OneCocycle.equivalence_isCohomologous G U).trans
        ((OneCocycle.equivalence_isCohomologous G U).symm (key γ)) (key δ))

end Poset

/-! ## Commutative values: the group structure on cocycles and `H1` -/

section Comm

variable {G : Cᵒᵖ ⥤ CommGrpCat.{w}} {U V : I → C}