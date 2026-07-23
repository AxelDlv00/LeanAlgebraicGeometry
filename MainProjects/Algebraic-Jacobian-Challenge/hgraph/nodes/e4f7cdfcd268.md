---
author: sync
content_type: lemma
created: '2026-07-16T21:14:25'
decl: HomologicalComplex.HomologySequence.quasiIso_
docstring: '**Middle-term quasi-isomorphism transfer** (the `τ₂` companion of Mathlib''s
  `quasiIso_τ₃`).

  If `φ.τ₁` and `φ.τ₃` are quasi-isomorphisms then so is `φ.τ₂`, provided that at
  each boundary

  degree (one with no incoming / no outgoing differential) the middle component `φ.τ₂.f
  i` is a

  mono / epi respectively. This is the `lean_aux` infrastructure behind

  `InjectiveResolution.ofShortExact_resolvesMiddle`.'
file: AlgebraicJacobian/Cohomology/AcyclicResolution.lean
generated: lean
lean_status: lean_ok
title: HomologicalComplex.HomologySequence.quasiIso_
type: lean
updated: '2026-07-24T03:02:09'
---
lemma quasiIso_τ₂ (h₁ : QuasiIso φ.τ₁) (h₃ : QuasiIso φ.τ₃)
    (hbMono : ∀ i, (∀ k, ¬ c.Rel k i) → Mono (φ.τ₂.f i))
    (hbEpi : ∀ i, (∀ j, ¬ c.Rel i j) → Epi (φ.τ₂.f i)) :
    QuasiIso φ.τ₂ := by
  have hI1 : ∀ d, IsIso (homologyMap φ.τ₁ d) := fun d => by
    rw [← quasiIsoAt_iff_isIso_homologyMap]; exact (quasiIso_iff φ.τ₁).1 h₁ d
  have hI3 : ∀ d, IsIso (homologyMap φ.τ₃ d) := fun d => by
    rw [← quasiIsoAt_iff_isIso_homologyMap]; exact (quasiIso_iff φ.τ₃).1 h₃ d
  have hE1 : ∀ d, Epi (homologyMap φ.τ₁ d) := fun d => have := hI1 d; inferInstance
  have hM1 : ∀ d, Mono (homologyMap φ.τ₁ d) := fun d => have := hI1 d; inferInstance
  have hE3 : ∀ d, Epi (homologyMap φ.τ₃ d) := fun d => have := hI3 d; inferInstance
  have hM3 : ∀ d, Mono (homologyMap φ.τ₃ d) := fun d => have := hI3 d; inferInstance
  rw [quasiIso_iff]
  intro i
  rw [quasiIsoAt_iff_isIso_homologyMap]
  have hEpi : Epi (homologyMap φ.τ₂ i) := by
    by_cases hi : ∃ j, c.Rel i j
    · obtain ⟨j, hij⟩ := hi
      apply epi_of_epi_of_epi_of_mono
        ((δlastFunctor ⋙ δlastFunctor).map (mapComposableArrows₅ φ hS₁ hS₂ i j hij))
      · exact (composableArrows₅_exact hS₁ i j hij).δlast.δlast
      · exact (composableArrows₅_exact hS₂ i j hij).δlast.δlast
      · exact hE1 i
      · exact hE3 i
      · exact hM1 j
    · have hi' : ∀ j, ¬ c.Rel i j := fun j hj => hi ⟨j, hj⟩
      have := hbEpi i hi'
      exact epi_homologyMap_of_epi_of_not_rel φ.τ₂ i hi'
  have hMono : Mono (homologyMap φ.τ₂ i) := by
    by_cases hi : ∃ k, c.Rel k i
    · obtain ⟨k, hki⟩ := hi
      apply mono_of_epi_of_mono_of_mono
        ((δ₀Functor ⋙ δ₀Functor).map (mapComposableArrows₅ φ hS₁ hS₂ k i hki))
      · exact (composableArrows₅_exact hS₁ k i hki).δ₀.δ₀
      · exact (composableArrows₅_exact hS₂ k i hki).δ₀.δ₀
      · exact hE3 k
      · exact hM1 i
      · exact hM3 i
    · have hi' : ∀ k, ¬ c.Rel k i := fun k hk => hi ⟨k, hk⟩
      have := hbMono i hi'
      exact mono_homologyMap_of_mono_of_not_rel φ.τ₂ i hi'
  exact isIso_of_mono_of_epi _

end HomologicalComplex.HomologySequence

namespace CategoryTheory

variable {𝒜 : Type*} [Category 𝒜] [Abelian 𝒜] [HasInjectiveResolutions 𝒜]
variable {ℬ : Type*} [Category ℬ] [Abelian ℬ]

/-!
### Right-acyclic objects
Blueprint: `def:right_acyclic` (§ "Right-acyclic objects").
-/

/-- An object `J : 𝒜` is *right-`G`-acyclic* when every higher right-derived
functor of `G` vanishes at `J`:
```
(Rᵏ⁺¹ G)(J) = 0   for all k : ℕ.
```
The index-shifted quantifier `k + 1` matches the statement of
`Functor.isZero_rightDerived_obj_injective_succ` and avoids an inequality
side-condition; it is equivalent to `(Rⁿ G)(J) = 0` for all `n ≥ 1`.

Blueprint: `CategoryTheory.Functor.IsRightAcyclic` (`def:right_acyclic`).
-/
class Functor.IsRightAcyclic (G : 𝒜 ⥤ ℬ) [G.Additive] (J : 𝒜) : Prop where
  vanish : ∀ k : ℕ, Limits.IsZero ((G.rightDerived (k + 1)).obj J)

/-- Every injective object is right-`G`-acyclic.
Follows immediately from `Functor.isZero_rightDerived_obj_injective_succ`. -/
instance (priority := 100) Functor.IsRightAcyclic.ofInjective
    (G : 𝒜 ⥤ ℬ) [G.Additive] (J : 𝒜) [Injective J] : Functor.IsRightAcyclic G J where
  vanish k := Functor.isZero_rightDerived_obj_injective_succ G k J
-- Note: `Functor.isZero_rightDerived_obj_injective_succ` returns
-- `Limits.IsZero ((G.rightDerived (k+1)).obj J)`, matching the class field.

/-! ## Project-local Mathlib supplement — acyclic resolutions

The declarations in this section are project-local infrastructure feeding the
dimension-shift and acyclic-resolution comparison theorems (Stacks Tag 015D/015E).
They are not yet in Mathlib. -/

open Limits