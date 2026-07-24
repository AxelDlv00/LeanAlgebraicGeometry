---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: IsLocalization.AwayCover.piDoubleEquiv_descentIncl₁
docstring: 'The inclusion `descentIncl₁ : B → B ⊗[A] B` becomes the left overlap restriction.'
file: AlgebraicJacobian/Algebra/LocalizationCocycle.lean
generated: lean
lean_status: lean_ok
title: IsLocalization.AwayCover.piDoubleEquiv_descentIncl₁
type: lean
updated: '2026-07-24T17:02:46'
---
lemma piDoubleEquiv_descentIncl₁ (s : ∀ i, S i) :
    piDoubleEquiv f S T (Module.descentIncl₁ A (∀ i, S i) s)
      = fun p : ι × ι => inclLeft f S T p.1 p.2 (s p.1) := by
  have key : (piDoubleEquiv f S T).toAlgHom.comp (Module.descentIncl₁ A (∀ i, S i))
      = Pi.algHom _ _ fun p : ι × ι =>
          (inclLeft f S T p.1 p.2).comp (Pi.evalAlgHom _ _ p.1) := by
    apply AlgHom.ext_of_isLocalization_pi (fun i => Submonoid.powers (f i))
    intro i
    change piDoubleEquiv f S T (Module.descentIncl₁ A (∀ i, S i) (Pi.single i 1))
        = fun p : ι × ι => inclLeft f S T p.1 p.2 (Pi.single i 1 p.1)
    rw [Module.descentIncl₁_apply, piDoubleEquiv_single_tmul_one f S T i]
    funext p
    obtain ⟨a, b⟩ := p
    dsimp only
    by_cases ha : a = i
    · subst ha
      rw [if_pos rfl, Pi.single_eq_same, map_one]
    · rw [if_neg ha, Pi.single_eq_of_ne ha, map_zero]
  exact DFunLike.congr_fun key s