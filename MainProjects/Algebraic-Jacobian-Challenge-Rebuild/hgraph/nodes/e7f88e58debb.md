---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: IsLocalization.AwayCover.piDoubleEquiv_descentIncl
docstring: 'The inclusion `descentIncl₂ : B → B ⊗[A] B` becomes the right overlap
  restriction.'
file: AlgebraicJacobian/Algebra/LocalizationCocycle.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.AwayCover.piDoubleEquiv_descentIncl
type: lean
updated: '2026-07-24T03:34:20'
---
lemma piDoubleEquiv_descentIncl₂ (s : ∀ i, S i) :
    piDoubleEquiv f S T (Module.descentIncl₂ A (∀ i, S i) s)
      = fun p : ι × ι => inclRight f S T p.1 p.2 (s p.2) := by
  have key : (piDoubleEquiv f S T).toAlgHom.comp (Module.descentIncl₂ A (∀ i, S i))
      = Pi.algHom _ _ fun p : ι × ι =>
          (inclRight f S T p.1 p.2).comp (Pi.evalAlgHom _ _ p.2) := by
    apply AlgHom.ext_of_isLocalization_pi (fun i => Submonoid.powers (f i))
    intro i
    change piDoubleEquiv f S T (Module.descentIncl₂ A (∀ i, S i) (Pi.single i 1))
        = fun p : ι × ι => inclRight f S T p.1 p.2 (Pi.single i 1 p.2)
    rw [Module.descentIncl₂_apply, piDoubleEquiv_one_tmul_single f S T i]
    funext p
    obtain ⟨a, b⟩ := p
    dsimp only
    by_cases hb : b = i
    · subst hb
      rw [if_pos rfl, Pi.single_eq_same, map_one]
    · rw [if_neg hb, Pi.single_eq_of_ne hb, map_zero]
  exact DFunLike.congr_fun key s

/-! ## The main conversion -/