/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# Acyclic resolutions compute right-derived functors

This file provides the abstract homological-algebra core underlying the Čech
computation of higher direct images (Stacks Tag 015E, Leray's acyclicity lemma):
**an acyclic resolution computes every right-derived functor**.

Throughout, `𝒜` and `ℬ` are abelian categories, `𝒜` has injective resolutions
(so that `G.rightDerived n` is everywhere defined), and `G : 𝒜 ⥤ ℬ` is an
additive functor.

## Declarations

* `CategoryTheory.Functor.IsRightAcyclic` — typeclass for right-`G`-acyclic objects.
* Instance: every injective object is right-acyclic (from Mathlib's
  `Functor.isZero_rightDerived_obj_injective_succ`).

The following declarations are outlined in the strategy block below and will be
constructed by the prover in `mathlib-build` mode:

* `CategoryTheory.InjectiveResolution.ofShortExact` — dual Horseshoe Lemma:
  lift `0 → A → B → C → 0` to a degreewise-split SES of injective resolutions.
* `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic` — dimension-shift
  isomorphism `(Rᵏ G)(Z) ≅ (Rᵏ⁺¹ G)(A)` across a SES with acyclic middle term.
* `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution` — main theorem:
  `(Rⁿ G)(A) ≅ Hⁿ(G(J•))` for any acyclic resolution `J•` of `A`.

See `blueprint/src/chapters/Cohomology_AcyclicResolution.tex` and
`.archon/analogies/p4-derived-les.md` for the full informal argument.

## Mathlib building blocks (all verified present)

All from `Mathlib/CategoryTheory/Abelian/RightDerived.lean`:
- `CategoryTheory.InjectiveResolution.isoRightDerivedObj` — iso
  `(F.rightDerived n).obj X ≅ Hⁿ(F.mapHomologicalComplex.obj I.cocomplex)`.
- `CategoryTheory.Functor.rightDerivedZeroIsoSelf` — `R⁰G ≅ G` (left-exact `G`).
- `CategoryTheory.Functor.isZero_rightDerived_obj_injective_succ` — vanishing on
  injectives: `IsZero ((F.rightDerived (n+1)).obj J)` for `[Injective J]`.

From `Mathlib/Algebra/Homology/HomologySequence.lean`:
- `CategoryTheory.ShortComplex.ShortExact.homology_exact₁`
- `CategoryTheory.ShortComplex.ShortExact.homology_exact₂`
- `CategoryTheory.ShortComplex.ShortExact.homology_exact₃`
- `CategoryTheory.ShortComplex.ShortExact.δ`

## Source

Stacks Project, Derived Categories:
- Tag 0157 (definition-derived-functor, items 3–4)
- Tag 015C (lemma-F-acyclic, part 2)
- Tag 015D (lemma-F-acyclic-ses)
- Tag 015E (lemma-leray-acyclicity)
- Tag 05TA (proposition-enough-acyclics)
-/

/-! ## Project-local Mathlib supplement — middle-term quasi-isomorphism transfer

Given a morphism `φ : S₁ ⟶ S₂` between two short exact sequences of homological complexes
in an abelian category, Mathlib proves that if `φ.τ₁` and `φ.τ₂` are quasi-isomorphisms then so
is `φ.τ₃` (`HomologicalComplex.HomologySequence.quasiIso_τ₃`). The companion statements for `φ.τ₁`
and `φ.τ₂` are an explicit Mathlib TODO (see `HomologySequenceLemmas.lean`). We supply the `φ.τ₂`
version here: it is the engine that proves the horseshoe middle complex `I_B` is an injective
*resolution* of `B` (the outer verticals `I_A.ι`, `I_C.ι` are quasi-isos, hence so is the middle
augmentation). The proof mirrors Mathlib's `τ₃` argument: a homology four-lemma on the windows of
`composableArrows₅`, with the boundary degrees (no predecessor / no successor) handled by
`mono_homologyMap_of_mono_of_not_rel` / `epi_homologyMap_of_epi_of_not_rel`. -/

namespace HomologicalComplex.HomologySequence

open CategoryTheory ComposableArrows Abelian Limits

variable {C ι : Type*} [Category C] [Abelian C] {c : ComplexShape ι}
  {S₁ S₂ : ShortComplex (HomologicalComplex C c)} (φ : S₁ ⟶ S₂)
  (hS₁ : S₁.ShortExact) (hS₂ : S₂.ShortExact)

include hS₁ hS₂ in
/-- **Middle-term quasi-isomorphism transfer** (the `τ₂` companion of Mathlib's `quasiIso_τ₃`).
If `φ.τ₁` and `φ.τ₃` are quasi-isomorphisms then so is `φ.τ₂`, provided that at each boundary
degree (one with no incoming / no outgoing differential) the middle component `φ.τ₂.f i` is a
mono / epi respectively. This is the `lean_aux` infrastructure behind
`InjectiveResolution.ofShortExact_resolvesMiddle`. -/
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

/-- The cohomology of the `G`-image of an injective resolution of a right-`G`-acyclic
object `J` vanishes in every positive degree. This is the homology-level form of
right-acyclicity, obtained by transporting the vanishing of `(R^{k+1} G)(J)` across
`InjectiveResolution.isoRightDerivedObj`. It is the input that kills the middle terms
of the homology long exact sequence in the dimension-shift step. -/
lemma Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic
    (G : 𝒜 ⥤ ℬ) [G.Additive] {J : 𝒜} (I : InjectiveResolution J)
    [G.IsRightAcyclic J] (k : ℕ) :
    IsZero ((HomologicalComplex.homologyFunctor ℬ (ComplexShape.up ℕ) (k + 1)).obj
      ((G.mapHomologicalComplex (ComplexShape.up ℕ)).obj I.cocomplex)) :=
  (Functor.IsRightAcyclic.vanish (G := G) (J := J) k).of_iso
    (I.isoRightDerivedObj G (k + 1)).symm

omit [HasInjectiveResolutions 𝒜] in
/-- A short complex of cochain complexes that is *degreewise split* (each degree carries a
`ShortComplex.Splitting`) is short exact. Project-local because Mathlib only provides the
degreewise-short-exact criterion `shortExact_of_degreewise_shortExact`; this packages the
common special case where the degreewise data is a splitting. -/
lemma shortExact_of_degreewise_splitting
    {S : ShortComplex (CochainComplex 𝒜 ℕ)}
    (splits : ∀ n, (S.map (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting) :
    S.ShortExact :=
  HomologicalComplex.shortExact_of_degreewise_shortExact S (fun n => (splits n).shortExact)

omit [HasInjectiveResolutions 𝒜] in
/-- An additive functor applied degreewise to a degreewise-split short complex of cochain
complexes yields a short exact short complex. This is the step where degreewise splitness is
essential: `G` is not assumed exact, but it preserves the *split* short exact sequences in each
degree (`ShortComplex.Splitting.map`), and degreewise short exactness then assembles to a short
exact sequence of complexes. -/
lemma shortExact_map_mapHomologicalComplex_of_degreewise_splitting
    {S : ShortComplex (CochainComplex 𝒜 ℕ)}
    (splits : ∀ n, (S.map (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting)
    (G : 𝒜 ⥤ ℬ) [G.Additive] :
    (S.map (G.mapHomologicalComplex (ComplexShape.up ℕ))).ShortExact :=
  HomologicalComplex.shortExact_of_degreewise_shortExact _
    (fun n => ((splits n).map G).shortExact)

/-- **Dimension shift, part (1), from a degreewise-split SES of injective resolutions.**
Given a short exact sequence `0 → A → J → Z → 0` lifted (via the horseshoe) to a
degreewise-split short exact sequence of injective resolutions
`0 → I_A → I_J → I_Z → 0`, presented here as chain maps `φ, ψ` with degreewise splittings,
and with the middle object `J` right-`G`-acyclic, the connecting map of the homology long
exact sequence of `G(I_•)` is an isomorphism in every positive degree:
`(R^{k+1} G)(Z) ≅ (R^{k+2} G)(A)`.

This is the engine of the staircase induction (`rightDerivedIsoOfAcyclicResolution`).
It is stated over the *resolution-level* SES because the object-level dimension-shift theorem
`rightDerivedShiftIsoOfAcyclic` requires the horseshoe lift to produce that SES; once the
horseshoe is available, the object-level statement follows by feeding its output here. -/
noncomputable def Functor.rightDerivedShiftIsoOfSplitResolutionSES
    (G : 𝒜 ⥤ ℬ) [G.Additive] {A J Z : 𝒜}
    (I_A : InjectiveResolution A) (I_J : InjectiveResolution J) (I_Z : InjectiveResolution Z)
    [G.IsRightAcyclic J]
    (φ : I_A.cocomplex ⟶ I_J.cocomplex) (ψ : I_J.cocomplex ⟶ I_Z.cocomplex)
    (w : φ ≫ ψ = 0)
    (splits : ∀ n, ((ShortComplex.mk φ ψ w).map
      (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting)
    (k : ℕ) :
    (G.rightDerived (k + 1)).obj Z ≅ (G.rightDerived (k + 2)).obj A :=
  have hSG : ((ShortComplex.mk φ ψ w).map
      (G.mapHomologicalComplex (ComplexShape.up ℕ))).ShortExact :=
    shortExact_map_mapHomologicalComplex_of_degreewise_splitting splits G
  (I_Z.isoRightDerivedObj G (k + 1)) ≪≫
    hSG.δIso (k + 1) (k + 2) (by simp)
      (G.isZero_homology_mapHomologicalComplex_of_isRightAcyclic I_J k)
      (G.isZero_homology_mapHomologicalComplex_of_isRightAcyclic I_J (k + 1)) ≪≫
    (I_A.isoRightDerivedObj G (k + 2)).symm

omit [HasInjectiveResolutions 𝒜] in
/-- **Horseshoe per-stage monomorphism.** Given an exact short complex
`A → B → C` with `A → B` a monomorphism, and monomorphisms `α : A ↪ P`, `γ : C ↪ Q` with `P`
injective, the map `B → P ⊞ Q` whose first component is the injective extension of `α` along
`A ↪ B` (`Injective.factorThru α S.f`) and whose second component is `B ↠ C ↪ Q` is itself a
monomorphism. This is the cokernel/kernel step driving each stage of the dual Horseshoe Lemma
`InjectiveResolution.ofShortExact`: applied to the `n`-th cosyzygy short exact sequence with
`P = I_A.X (n+1)`, `Q = I_C.X (n+1)`, it produces the monomorphism into the next biproduct term
whose cokernel feeds the following stage. -/
lemma mono_biprod_lift_factorThru_of_exact {S : ShortComplex 𝒜} (hS : S.Exact) [Mono S.f]
    {P Q : 𝒜} [Injective P] (α : S.X₁ ⟶ P) [Mono α] (γ : S.X₃ ⟶ Q) [Mono γ] :
    Mono (biprod.lift (Injective.factorThru α S.f) (S.g ≫ γ)) := by
  rw [Preadditive.mono_iff_cancel_zero]
  intro T x hx
  have h1 : x ≫ Injective.factorThru α S.f = 0 := by simpa using hx =≫ biprod.fst
  have h2 : x ≫ S.g ≫ γ = 0 := by simpa using hx =≫ biprod.snd
  have hxg : x ≫ S.g = 0 := by rw [← cancel_mono γ, zero_comp, Category.assoc]; exact h2
  have hyf : hS.lift x hxg ≫ S.f = x := hS.lift_f x hxg
  have hya : hS.lift x hxg ≫ α = 0 := by
    have h3 : hS.lift x hxg ≫ S.f ≫ Injective.factorThru α S.f = 0 := by
      rw [← Category.assoc, hyf]; exact h1
    rwa [Injective.comp_factorThru] at h3
  have hy0 : hS.lift x hxg = 0 := by rw [← cancel_mono α, zero_comp]; exact hya
  rw [← hyf, hy0, zero_comp]

/-! ## Project-local Mathlib supplement — twisted biproduct of cochain complexes

This block builds the *structural* core of the dual Horseshoe Lemma as a general, injective-free
construction. Given two cochain complexes `K`, `L` and a degreewise family
`τ n : L.X n ⟶ K.X (n+1)` satisfying the cocycle identity
`L.d n (n+1) ≫ τ (n+1) = -(τ n ≫ K.d (n+1) (n+2))`, the biproduct objects `K.X n ⊞ L.X n` with the
twisted matrix differential `[[d_K, τ], [0, d_L]]` form a cochain complex `twistedBiprod τ hτ`,
the coprojection `K ⟶ twistedBiprod` and projection `twistedBiprod ⟶ L` are chain maps, and every
degree is the canonical split short exact sequence of the biproduct.

This is exactly the content of the blueprint sub-lemmas `lem:horseshoe_dComp` (the differential
squares to zero) and `lem:horseshoe_chainMap` (the coprojection/projection are chain maps and the
degrees split); it is isolated here free of injectivity because the only inputs are the cocycle
identity and the biproduct structure. The horseshoe specialises it to `K = I_A.cocomplex`,
`L = I_C.cocomplex` once the twist `τ` has been produced by injectivity. -/

section TwistedBiprod

omit [HasInjectiveResolutions 𝒜]

variable {K L : CochainComplex 𝒜 ℕ} (τ : ∀ n, L.X n ⟶ K.X (n + 1))

/-- The twisted matrix differential `[[d_K, τ], [0, d_L]]` on the degreewise biproduct
`K.X n ⊞ L.X n ⟶ K.X (n+1) ⊞ L.X (n+1)`. -/
noncomputable def twistedBiprodD (n : ℕ) :
    (K.X n ⊞ L.X n) ⟶ (K.X (n + 1) ⊞ L.X (n + 1)) :=
  biprod.lift (biprod.fst ≫ K.d n (n + 1) + biprod.snd ≫ τ n) (biprod.snd ≫ L.d n (n + 1))

@[reassoc (attr := simp)]
lemma twistedBiprodD_fst (n : ℕ) :
    twistedBiprodD τ n ≫ biprod.fst = biprod.fst ≫ K.d n (n + 1) + biprod.snd ≫ τ n := by
  simp [twistedBiprodD]

@[reassoc (attr := simp)]
lemma twistedBiprodD_snd (n : ℕ) :
    twistedBiprodD τ n ≫ biprod.snd = biprod.snd ≫ L.d n (n + 1) := by
  simp [twistedBiprodD]

variable (hτ : ∀ n, L.d n (n + 1) ≫ τ (n + 1) = -(τ n ≫ K.d (n + 1) (n + 2)))

include hτ in
lemma twistedBiprodD_comp (n : ℕ) :
    twistedBiprodD τ n ≫ twistedBiprodD τ (n + 1) = 0 := by
  apply biprod.hom_ext
  · simp only [Category.assoc, twistedBiprodD_fst, Preadditive.comp_add,
      twistedBiprodD_fst_assoc, twistedBiprodD_snd_assoc, zero_comp]
    rw [Preadditive.add_comp, Category.assoc, Category.assoc, HomologicalComplex.d_comp_d,
      comp_zero, zero_add, ← Preadditive.comp_add, hτ n, add_neg_cancel, comp_zero]
  · simp only [Category.assoc, twistedBiprodD_snd, twistedBiprodD_snd_assoc, zero_comp]
    rw [HomologicalComplex.d_comp_d, comp_zero]

/-- The twisted biproduct cochain complex with differential `[[d_K, τ], [0, d_L]]`. -/
noncomputable def twistedBiprod : CochainComplex 𝒜 ℕ :=
  CochainComplex.of (fun n => K.X n ⊞ L.X n) (twistedBiprodD τ) (twistedBiprodD_comp τ hτ)

@[simp]
lemma twistedBiprod_X (n : ℕ) : (twistedBiprod τ hτ).X n = (K.X n ⊞ L.X n) := rfl

@[simp]
lemma twistedBiprod_d (n : ℕ) : (twistedBiprod τ hτ).d n (n + 1) = twistedBiprodD τ n :=
  CochainComplex.of_d _ _ _ _

/-- The coprojection `K ⟶ twistedBiprod τ hτ`, degreewise `biprod.inl`. -/
noncomputable def twistedBiprodInl : K ⟶ twistedBiprod τ hτ where
  f n := biprod.inl
  comm' i j hij := by
    obtain rfl : i + 1 = j := hij
    simp only [twistedBiprod_d]
    apply biprod.hom_ext <;> simp

/-- The projection `twistedBiprod τ hτ ⟶ L`, degreewise `biprod.snd`. -/
noncomputable def twistedBiprodSnd : twistedBiprod τ hτ ⟶ L where
  f n := biprod.snd
  comm' i j hij := by
    obtain rfl : i + 1 = j := hij
    simp [twistedBiprod_d]

@[simp]
lemma twistedBiprodInl_f (n : ℕ) : (twistedBiprodInl τ hτ).f n = biprod.inl := rfl

@[simp]
lemma twistedBiprodSnd_f (n : ℕ) : (twistedBiprodSnd τ hτ).f n = biprod.snd := rfl

lemma twistedBiprodInl_comp_Snd : twistedBiprodInl τ hτ ≫ twistedBiprodSnd τ hτ = 0 := by
  ext n
  simp

/-- Each degree of `0 → K → twistedBiprod → L → 0` is the canonical split short exact sequence of
the biproduct `K.X n ⊞ L.X n`. -/
noncomputable def twistedBiprodSplitting (n : ℕ) :
    ((ShortComplex.mk _ _ (twistedBiprodInl_comp_Snd τ hτ)).map
      (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting where
  r := biprod.fst
  s := biprod.inr
  id := by simpa using biprod.total

end TwistedBiprod

/-! ## Project-local Mathlib supplement — the horseshoe twist family

Given a short exact sequence `ses : 0 → A → B → C → 0` and chosen injective resolutions
`I_A`, `I_C`, this block constructs the off-diagonal twist family
`τ n : I_C.X n ⟶ I_A.X (n+1)` together with the augmentation first component, satisfying the
cocycle identity `d_C n ≫ τ (n+1) = -(τ n ≫ d_A (n+1))`. Each `τ` is produced by the universal
lifting property of injectives (`Injective.factorThru` / `ShortComplex.Exact.descToInjective`)
against the cosyzygy monomorphisms of `I_C`. This is the blueprint sub-lemma `lem:horseshoe_twist`
(the recursion kernel). Combined with the `twistedBiprod` construction above it yields the middle
complex of the dual Horseshoe Lemma. -/

namespace InjectiveResolution

section OfShortExact

variable {ses : ShortComplex 𝒜} (hses : ses.ShortExact)
  (I_A : InjectiveResolution ses.X₁) (I_C : InjectiveResolution ses.X₃)

/-- First component `B ⟶ I_A^0` of the horseshoe augmentation: the injective extension of the
augmentation `A ⟶ I_A^0` along the monomorphism `A ↪ B`. -/
noncomputable def horseshoeβ₁ : ses.X₂ ⟶ I_A.cocomplex.X 0 :=
  @Injective.factorThru _ _ _ _ _ (I_A.injective 0) (I_A.ι.f 0) ses.f hses.mono_f

@[reassoc (attr := simp)]
lemma f_comp_horseshoeβ₁ : ses.f ≫ horseshoeβ₁ hses I_A = I_A.ι.f 0 :=
  @Injective.comp_factorThru _ _ _ _ _ (I_A.injective 0) (I_A.ι.f 0) ses.f hses.mono_f

/-- Auxiliary map `C ⟶ I_A^1` through which `β₁ ≫ d_A^0` factors (since it kills `A`). -/
noncomputable def horseshoeH : ses.X₃ ⟶ I_A.cocomplex.X 1 :=
  hses.exact.descToInjective (horseshoeβ₁ hses I_A ≫ I_A.cocomplex.d 0 1) (by
    rw [← Category.assoc, f_comp_horseshoeβ₁]; exact I_A.ι_f_zero_comp_complex_d)

@[reassoc (attr := simp)]
lemma g_comp_horseshoeH :
    ses.g ≫ horseshoeH hses I_A = horseshoeβ₁ hses I_A ≫ I_A.cocomplex.d 0 1 :=
  hses.exact.comp_descToInjective _ _

lemma horseshoeH_comp_d : horseshoeH hses I_A ≫ I_A.cocomplex.d 1 2 = 0 := by
  haveI := hses.epi_g
  rw [← cancel_epi ses.g, comp_zero, ← Category.assoc, g_comp_horseshoeH, Category.assoc,
    HomologicalComplex.d_comp_d, comp_zero]

/-- The base twist `τ⁰ : I_C^0 ⟶ I_A^1`, extending `-(C ⟶ I_A^1)` along `C ↪ I_C^0`. -/
noncomputable def horseshoeτZero : I_C.cocomplex.X 0 ⟶ I_A.cocomplex.X 1 :=
  @Injective.factorThru _ _ _ _ _ (I_A.injective 1) (-horseshoeH hses I_A) (I_C.ι.f 0)
    (mono_of_isLimit_fork I_C.isLimitKernelFork)

@[reassoc (attr := simp)]
lemma ιC_comp_horseshoeτZero :
    I_C.ι.f 0 ≫ horseshoeτZero hses I_A I_C = -horseshoeH hses I_A :=
  @Injective.comp_factorThru _ _ _ _ _ (I_A.injective 1) (-horseshoeH hses I_A) (I_C.ι.f 0)
    (mono_of_isLimit_fork I_C.isLimitKernelFork)

lemma horseshoeτZero_hf :
    I_C.ι.f 0 ≫ (-(horseshoeτZero hses I_A I_C ≫ I_A.cocomplex.d 1 2)) = 0 := by
  have e : (-horseshoeH hses I_A) ≫ I_A.cocomplex.d 1 2 = 0 := by
    rw [Preadditive.neg_comp, horseshoeH_comp_d, neg_zero]
  rw [Preadditive.comp_neg, neg_eq_zero, ← Category.assoc, ιC_comp_horseshoeτZero]
  exact e

/-- The recursion carrying, at each degree `n`, consecutive twists `τⁿ`, `τⁿ⁺¹` together with the
cocycle identity `d_C^n ≫ τⁿ⁺¹ = -(τⁿ ≫ d_A^{n+1})`. The step uses the lifting property of the
injective `I_A^{n+3}` against the cosyzygy mono of `I_C` (`exact_succ`); the base uses the
augmentation exactness `exact₀`. -/
noncomputable def twistPair : (n : ℕ) →
    Σ' (t0 : I_C.cocomplex.X n ⟶ I_A.cocomplex.X (n + 1))
       (_t1 : I_C.cocomplex.X (n + 1) ⟶ I_A.cocomplex.X (n + 2)),
       I_C.cocomplex.d n (n + 1) ≫ _t1 = -(t0 ≫ I_A.cocomplex.d (n + 1) (n + 2))
  | 0 => ⟨horseshoeτZero hses I_A I_C,
      I_C.exact₀.descToInjective (-(horseshoeτZero hses I_A I_C ≫ I_A.cocomplex.d 1 2))
        (horseshoeτZero_hf hses I_A I_C),
      I_C.exact₀.comp_descToInjective _ _⟩
  | (n + 1) =>
      let p := twistPair n
      ⟨p.2.1,
        (I_C.exact_succ n).descToInjective (-(p.2.1 ≫ I_A.cocomplex.d (n + 2) (n + 3))) (by
          have e : (-(p.1 ≫ I_A.cocomplex.d (n + 1) (n + 2))) ≫ I_A.cocomplex.d (n + 2) (n + 3)
              = 0 := by
            rw [Preadditive.neg_comp, Category.assoc, HomologicalComplex.d_comp_d, comp_zero,
              neg_zero]
          rw [Preadditive.comp_neg, neg_eq_zero, ← Category.assoc, p.2.2]
          exact e),
        (I_C.exact_succ n).comp_descToInjective _ _⟩

/-- The horseshoe off-diagonal twist family `τⁿ : I_C^n ⟶ I_A^{n+1}`. -/
noncomputable def horseshoeτ (n : ℕ) : I_C.cocomplex.X n ⟶ I_A.cocomplex.X (n + 1) :=
  (twistPair hses I_A I_C n).1

/-- The cocycle identity for the horseshoe twist: `d_C^n ≫ τⁿ⁺¹ = -(τⁿ ≫ d_A^{n+1})`. -/
lemma horseshoeτ_cocycle (n : ℕ) :
    I_C.cocomplex.d n (n + 1) ≫ horseshoeτ hses I_A I_C (n + 1) =
      -(horseshoeτ hses I_A I_C n ≫ I_A.cocomplex.d (n + 1) (n + 2)) :=
  (twistPair hses I_A I_C n).2.2

/-- The middle cochain complex `I_B` of the horseshoe: the twisted biproduct of `I_A` and `I_C`
along the horseshoe twist family. -/
noncomputable def horseshoeMid : CochainComplex 𝒜 ℕ :=
  twistedBiprod (horseshoeτ hses I_A I_C) (horseshoeτ_cocycle hses I_A I_C)

/-- The short complex `0 → I_A → I_B → I_C → 0` of the horseshoe, with the coprojection and
projection chain maps. -/
noncomputable def horseshoeSES : ShortComplex (CochainComplex 𝒜 ℕ) :=
  ShortComplex.mk _ _
    (twistedBiprodInl_comp_Snd (horseshoeτ hses I_A I_C) (horseshoeτ_cocycle hses I_A I_C))

/-- Each degree of the horseshoe short complex is the canonical biproduct splitting. -/
noncomputable def horseshoeSES_splitting (n : ℕ) :
    ((horseshoeSES hses I_A I_C).map
      (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting :=
  twistedBiprodSplitting (horseshoeτ hses I_A I_C) (horseshoeτ_cocycle hses I_A I_C) n

/-- The horseshoe short complex `0 → I_A → I_B → I_C → 0` is short exact (degreewise split). -/
lemma horseshoeSES_shortExact : (horseshoeSES hses I_A I_C).ShortExact :=
  shortExact_of_degreewise_splitting (horseshoeSES_splitting hses I_A I_C)

@[simp]
lemma horseshoeτ_zero : horseshoeτ hses I_A I_C 0 = horseshoeτZero hses I_A I_C := rfl

/-- Clean-domain degree-0 augmentation map of `I_C` (definitionally `I_C.ι.f 0`, but with syntactic
domain `ses.X₃` so it composes cleanly on the left with `ses.g`; the bundled `I_C.ι.f 0` carries the
single-complex domain `((single₀).obj ses.X₃).X 0`, which blocks rewriting under `ses.g ≫ -`). -/
noncomputable def ιC0 : ses.X₃ ⟶ I_C.cocomplex.X 0 := I_C.ι.f 0

lemma ιC0_comp_d : ιC0 I_C ≫ I_C.cocomplex.d 0 1 = 0 := I_C.ι_f_zero_comp_complex_d

lemma ιC0_comp_τZero :
    ιC0 I_C ≫ horseshoeτZero hses I_A I_C = -horseshoeH hses I_A :=
  ιC_comp_horseshoeτZero hses I_A I_C

/-- The horseshoe augmentation `β : B ⟶ I_A^0 ⊞ I_C^0`. -/
noncomputable def horseshoeβ : ses.X₂ ⟶ I_A.cocomplex.X 0 ⊞ I_C.cocomplex.X 0 :=
  biprod.lift (horseshoeβ₁ hses I_A) (ses.g ≫ ιC0 I_C)

@[reassoc (attr := simp)]
lemma horseshoeβ_fst : horseshoeβ hses I_A I_C ≫ biprod.fst = horseshoeβ₁ hses I_A := by
  rw [horseshoeβ, biprod.lift_fst]

@[reassoc (attr := simp)]
lemma horseshoeβ_snd : horseshoeβ hses I_A I_C ≫ biprod.snd = ses.g ≫ ιC0 I_C := by
  rw [horseshoeβ, biprod.lift_snd]

/-- The augmentation composes to zero with the first horseshoe differential, so it descends to a
chain map from `B` (in degree 0) into the middle complex. -/
lemma horseshoeβ_comp_d :
    horseshoeβ hses I_A I_C ≫ twistedBiprodD (horseshoeτ hses I_A I_C) 0 = 0 := by
  have e : ses.g ≫ ιC0 I_C ≫ horseshoeτZero hses I_A I_C
      = -(horseshoeβ₁ hses I_A ≫ I_A.cocomplex.d 0 (0 + 1)) := by
    rw [ιC0_comp_τZero, Preadditive.comp_neg, g_comp_horseshoeH]
  have e2 : ses.g ≫ ιC0 I_C ≫ I_C.cocomplex.d 0 (0 + 1) = 0 := by
    have h0 : ιC0 I_C ≫ I_C.cocomplex.d 0 (0 + 1) = 0 := I_C.ι_f_zero_comp_complex_d
    rw [h0, comp_zero]
  apply biprod.hom_ext
  · simp only [Category.assoc, twistedBiprodD_fst, Preadditive.comp_add,
      horseshoeβ_fst_assoc, horseshoeβ_snd_assoc, horseshoeτ_zero, zero_comp]
    rw [e, add_neg_cancel]
  · simp only [Category.assoc, twistedBiprodD_snd, horseshoeβ_snd_assoc, zero_comp]
    exact e2

/-- Maps out of a `single₀` cochain complex are determined by their degree-`0` component. -/
private lemma single₀_hom_ext {X : 𝒜} {D : CochainComplex 𝒜 ℕ}
    {g h : (CochainComplex.single₀ 𝒜).obj X ⟶ D} (h0 : g.f 0 = h.f 0) : g = h := by
  apply (CochainComplex.fromSingle₀Equiv D X).injective
  ext
  exact h0

/-- The horseshoe augmentation packaged as a chain map `(single₀ B) ⟶ I_B`, with degree-`0`
component the augmentation `β : B ⟶ I_A^0 ⊞ I_C^0`. -/
noncomputable def horseshoeι :
    (CochainComplex.single₀ 𝒜).obj ses.X₂ ⟶ horseshoeMid hses I_A I_C :=
  (CochainComplex.fromSingle₀Equiv (horseshoeMid hses I_A I_C) ses.X₂).symm
    ⟨horseshoeβ hses I_A I_C, by
      show horseshoeβ hses I_A I_C ≫
          (twistedBiprod (horseshoeτ hses I_A I_C) (horseshoeτ_cocycle hses I_A I_C)).d 0 1 = 0
      rw [twistedBiprod_d]
      exact horseshoeβ_comp_d hses I_A I_C⟩

@[simp]
lemma horseshoeι_f_zero : (horseshoeι hses I_A I_C).f 0 = horseshoeβ hses I_A I_C := by
  simp [horseshoeι, CochainComplex.fromSingle₀Equiv]

/-- The augmentation `β : B ⟶ I_A^0 ⊞ I_C^0` is a monomorphism (the base stage of the horseshoe
recursion: `mono_biprod_lift_factorThru_of_exact` applied to the original short exact sequence). -/
lemma mono_horseshoeβ : Mono (horseshoeβ hses I_A I_C) := by
  haveI := hses.mono_f
  haveI : Injective (I_A.cocomplex.X 0) := I_A.injective 0
  -- The domain of `I_A.ι.f 0` is `((single₀).obj ses.X₁).X 0`, not syntactically `ses.X₁`; we
  -- ascribe the clean domain so the `Mono` instance matches the lemma's `α : S.X₁ ⟶ P`.
  haveI : Mono (show ses.X₁ ⟶ I_A.cocomplex.X 0 from I_A.ι.f 0) :=
    mono_of_isLimit_fork I_A.isLimitKernelFork
  haveI : Mono (show ses.X₃ ⟶ I_C.cocomplex.X 0 from I_C.ι.f 0) :=
    mono_of_isLimit_fork I_C.isLimitKernelFork
  exact mono_biprod_lift_factorThru_of_exact hses.exact
    (show ses.X₁ ⟶ I_A.cocomplex.X 0 from I_A.ι.f 0)
    (show ses.X₃ ⟶ I_C.cocomplex.X 0 from I_C.ι.f 0)

/-- The horseshoe left square: `I_A.ι ≫ (I_A → I_B) = (single₀ A → single₀ B) ≫ horseshoeι`. -/
lemma horseshoeφ_comm₁₂ :
    I_A.ι ≫ (horseshoeSES hses I_A I_C).f =
      (ses.map (CochainComplex.single₀ 𝒜)).f ≫ horseshoeι hses I_A I_C := by
  apply single₀_hom_ext
  change (I_A.ι ≫ twistedBiprodInl (horseshoeτ hses I_A I_C)
      (horseshoeτ_cocycle hses I_A I_C)).f 0 =
    ((CochainComplex.single₀ 𝒜).map ses.f ≫ horseshoeι hses I_A I_C).f 0
  rw [HomologicalComplex.comp_f, HomologicalComplex.comp_f, twistedBiprodInl_f,
    CochainComplex.single₀_map_f_zero, horseshoeι_f_zero, horseshoeβ]
  -- The biproduct projections from `twistedBiprod` carry a `(twistedBiprod).X 0`-flavoured
  -- domain; ascribe the clean biproduct so the `biprod.*` simp lemmas fire.
  change I_A.ι.f 0 ≫ (biprod.inl : I_A.cocomplex.X 0 ⟶ I_A.cocomplex.X 0 ⊞ I_C.cocomplex.X 0) =
    ses.f ≫ biprod.lift (horseshoeβ₁ hses I_A) (ses.g ≫ ιC0 I_C)
  apply biprod.hom_ext <;> simp [f_comp_horseshoeβ₁, reassoc_of% ses.zero]

/-- The horseshoe right square: `horseshoeι ≫ (I_B → I_C) = (single₀ B → single₀ C) ≫ I_C.ι`. -/
lemma horseshoeφ_comm₂₃ :
    horseshoeι hses I_A I_C ≫ (horseshoeSES hses I_A I_C).g =
      (ses.map (CochainComplex.single₀ 𝒜)).g ≫ I_C.ι := by
  apply single₀_hom_ext
  show (horseshoeι hses I_A I_C ≫
      twistedBiprodSnd (horseshoeτ hses I_A I_C) (horseshoeτ_cocycle hses I_A I_C)).f 0 =
    ((CochainComplex.single₀ 𝒜).map ses.g ≫ I_C.ι).f 0
  rw [HomologicalComplex.comp_f, HomologicalComplex.comp_f, twistedBiprodSnd_f,
    CochainComplex.single₀_map_f_zero, horseshoeι_f_zero, horseshoeβ]
  change biprod.lift (horseshoeβ₁ hses I_A) (ses.g ≫ ιC0 I_C) ≫
    (biprod.snd : I_A.cocomplex.X 0 ⊞ I_C.cocomplex.X 0 ⟶ I_C.cocomplex.X 0) = ses.g ≫ I_C.ι.f 0
  rw [biprod.lift_snd]
  rfl

/-- The morphism of short complexes of cochain complexes
`(single₀ A → single₀ B → single₀ C) ⟶ (I_A → I_B → I_C)` whose outer verticals are the
resolution augmentations `I_A.ι`, `I_C.ι` and whose middle vertical is the horseshoe augmentation
`horseshoeι`. -/
noncomputable def horseshoeφ :
    ses.map (CochainComplex.single₀ 𝒜) ⟶ horseshoeSES hses I_A I_C :=
  ShortComplex.homMk I_A.ι (horseshoeι hses I_A I_C) I_C.ι
    (horseshoeφ_comm₁₂ hses I_A I_C) (horseshoeφ_comm₂₃ hses I_A I_C)

@[simp] lemma horseshoeφ_τ₁ : (horseshoeφ hses I_A I_C).τ₁ = I_A.ι := rfl
@[simp] lemma horseshoeφ_τ₂ : (horseshoeφ hses I_A I_C).τ₂ = horseshoeι hses I_A I_C := rfl
@[simp] lemma horseshoeφ_τ₃ : (horseshoeφ hses I_A I_C).τ₃ = I_C.ι := rfl

/-- The horseshoe augmentation `(single₀ B) ⟶ I_B` is a quasi-isomorphism: by the middle-term
quasi-isomorphism transfer `quasiIso_τ₂`, since the outer augmentations `I_A.ι`, `I_C.ι` are
quasi-isomorphisms (they are injective resolutions) and `β` is mono. -/
lemma quasiIso_horseshoeι : QuasiIso (horseshoeι hses I_A I_C) := by
  have key := HomologicalComplex.HomologySequence.quasiIso_τ₂ (horseshoeφ hses I_A I_C)
    (hses.map_of_exact (CochainComplex.single₀ 𝒜))
    (horseshoeSES_shortExact hses I_A I_C)
    (h₁ := I_A.quasiIso) (h₃ := I_C.quasiIso)
    (hbMono := by
      intro i hi
      obtain rfl : i = 0 := by
        rcases i with _ | m
        · rfl
        · exact absurd rfl (hi m)
      simpa only [horseshoeφ_τ₂, horseshoeι_f_zero] using mono_horseshoeβ hses I_A I_C)
    (hbEpi := by
      intro i hi
      exact absurd rfl (hi (i + 1)))
  simpa only [horseshoeφ_τ₂] using key

/-- **The middle complex resolves `B`** (blueprint `lem:horseshoe_resolvesMiddle`). The horseshoe
middle complex `I_B = twistedBiprod I_A I_C`, with augmentation `β`, is an injective resolution of
`B = ses.X₂`: its terms `I_A^n ⊞ I_C^n` are injective, and the augmentation is a quasi-isomorphism
by `quasiIso_horseshoeι`. -/
noncomputable def ofShortExact_resolvesMiddle : InjectiveResolution ses.X₂ where
  cocomplex := horseshoeMid hses I_A I_C
  injective n := by
    haveI : Injective (I_A.cocomplex.X n) := I_A.injective n
    haveI : Injective (I_C.cocomplex.X n) := I_C.injective n
    exact (inferInstance : Injective (I_A.cocomplex.X n ⊞ I_C.cocomplex.X n))
  ι := horseshoeι hses I_A I_C
  quasiIso := quasiIso_horseshoeι hses I_A I_C

/-- **Dual Horseshoe Lemma** (blueprint `lem:injective_resolution_of_ses`). From a short exact
sequence `0 → A → B → C → 0` and chosen injective resolutions `I_A`, `I_C`, the horseshoe produces
an injective resolution of the middle term `B` fitting into the degreewise-split short exact
sequence of cochain complexes `0 → I_A → I_B → I_C → 0` (`horseshoeSES`, short exact by
`horseshoeSES_shortExact` and degreewise split by `horseshoeSES_splitting`). -/
noncomputable def ofShortExact : InjectiveResolution ses.X₂ :=
  ofShortExact_resolvesMiddle hses I_A I_C

end OfShortExact

end InjectiveResolution

/-! ## Project-local Mathlib supplement — the dimension-shift isomorphism -/

/-- **Dimension shift across an acyclic short exact sequence** (blueprint
`lem:acyclic_dimension_shift`, TARGET 2). Given an additive functor `G` and a short exact sequence
`0 → A → J → Z → 0` with middle term `J` right-`G`-acyclic, the connecting maps of the long exact
sequence of right-derived functors furnish isomorphisms
`(R^{k+1} G)(Z) ≅ (R^{k+2} G)(A)` for all `k`.

The proof feeds the dual Horseshoe Lemma (`InjectiveResolution.ofShortExact_resolvesMiddle`) — a
degreewise-split short exact sequence of injective resolutions `0 → I_A → I_B → I_C → 0` — into the
resolution-level dimension shift `rightDerivedShiftIsoOfSplitResolutionSES`. -/
noncomputable def Functor.rightDerivedShiftIsoOfAcyclic
    (G : 𝒜 ⥤ ℬ) [G.Additive] {ses : ShortComplex 𝒜} (hses : ses.ShortExact)
    [G.IsRightAcyclic ses.X₂] (k : ℕ) :
    (G.rightDerived (k + 1)).obj ses.X₃ ≅ (G.rightDerived (k + 2)).obj ses.X₁ :=
  let I_A : InjectiveResolution ses.X₁ := (inferInstance : HasInjectiveResolution ses.X₁).out.some
  let I_C : InjectiveResolution ses.X₃ := (inferInstance : HasInjectiveResolution ses.X₃).out.some
  G.rightDerivedShiftIsoOfSplitResolutionSES I_A
    (InjectiveResolution.ofShortExact_resolvesMiddle hses I_A I_C) I_C
    (InjectiveResolution.horseshoeSES hses I_A I_C).f
    (InjectiveResolution.horseshoeSES hses I_A I_C).g
    (InjectiveResolution.horseshoeSES hses I_A I_C).zero
    (InjectiveResolution.horseshoeSES_splitting hses I_A I_C) k

/-!
### Status (iter-005): horseshoe structural core + twist recursion BUILT; sole remaining gap is
the middle-term quasi-isomorphism (`resolvesMiddle`)

This iteration built, axiom-clean, the genuinely novel mathematical content of the dual Horseshoe
Lemma:

* **Twisted biproduct complex** (`twistedBiprod`, `twistedBiprodInl`, `twistedBiprodSnd`,
  `twistedBiprodSplitting`): given any cocycle family `τ`, the matrix differential `[[d_K,τ],[0,d_L]]`
  on `K^n ⊞ L^n` is a cochain complex with chain maps and a degreewise biproduct splitting. This is
  the content of blueprint `lem:horseshoe_dComp` + `lem:horseshoe_chainMap`, isolated injective-free.
* **Twist recursion** (`horseshoeτ`, `horseshoeτ_cocycle`, via `twistPair`): the off-diagonal family
  `τⁿ : I_C^n ⟶ I_A^{n+1}` with the cocycle identity `d_C^n ≫ τⁿ⁺¹ = -(τⁿ ≫ d_A^{n+1})`, built by
  ℕ-recursion using `Injective.factorThru` / `descToInjective` against the cosyzygy monos
  (blueprint `lem:horseshoe_twist`, the recursion kernel).
* **Middle complex + degreewise-split SES** (`horseshoeMid`, `horseshoeSES`, `horseshoeSES_splitting`,
  `horseshoeSES_shortExact`): the short exact sequence `0 → I_A → I_B → I_C → 0` of cochain complexes,
  degreewise split — exactly the shape `rightDerivedShiftIsoOfSplitResolutionSES` consumes.
* **Augmentation** (`horseshoeβ`, `horseshoeβ_comp_d`): the map `β : B ⟶ I_B^0` with `β ≫ d_B^0 = 0`.

REMAINING GAP (next iter): `InjectiveResolution.ofShortExact_resolvesMiddle` — that `horseshoeMid`
with augmentation `β` is an injective *resolution* of `B`, i.e. the augmentation chain map
`(single₀ B) ⟶ horseshoeMid` is a quasi-isomorphism. The clean route is the map of short exact
sequences `(single A → single B → single C) ⟶ (I_A → I_B → I_C)` with the two outer verticals
`I_A.ι`, `I_C.ι` quasi-isos, then transfer to the middle. Mathlib provides only the *last-term*
transfer `HomologicalComplex.HomologySequence.quasiIso_τ₃`; the **middle-term** version `quasiIso_τ₂`
is ABSENT and must be built first (homology five-lemma on a 7-term LES window across two
`composableArrows₅`, handling the `ℕ`-boundary at degree 0). Once `resolvesMiddle` lands, assemble
`ofShortExact`, feed it to `rightDerivedShiftIsoOfSplitResolutionSES` for
`rightDerivedShiftIsoOfAcyclic`, then the staircase `rightDerivedIsoOfAcyclicResolution`.

The supplement above reduces the entire P4 lane to **constructing the horseshoe object**
(`InjectiveResolution.ofShortExact`): a degreewise-split short exact sequence of injective
resolutions `0 → I_A → I_B → I_C → 0`. Everything that *consumes* that object is now in place
and axiom-clean:

* `Functor.rightDerivedShiftIsoOfSplitResolutionSES` — given the horseshoe SES (as chain maps
  `φ, ψ` with degreewise splittings), produces the dimension-shift iso
  `(R^{k+1} G)(Z) ≅ (R^{k+2} G)(A)` directly (no further homological algebra needed). This is
  TARGET 2 part (1), modulo plugging in the horseshoe.
* `shortExact_of_degreewise_splitting` /
  `shortExact_map_mapHomologicalComplex_of_degreewise_splitting` — turn the degreewise splittings
  into complex-level `ShortExact`, before and after applying the additive `G`.
* `Functor.isZero_homology_mapHomologicalComplex_of_isRightAcyclic` — kills the acyclic middle
  terms `H^{≥1}(G(I_J))` (the δIso vanishing hypotheses).
* `mono_biprod_lift_factorThru_of_exact` — the per-stage monomorphism `B → I_A^{n+1} ⊞ I_C^{n+1}`
  that drives each step of the horseshoe recursion.

Mathlib supplies the rest of the horseshoe's *consumption* side: the canonical biproduct
splitting `ShortComplex.Splitting` of `(biprod.inl, biprod.snd)`
(`Mathlib/Algebra/Homology/ShortComplex/Exact.lean`, the `biprod` splitting), `δIso`
(`HomologySequence.lean`), and `isoRightDerivedObj` (`Abelian/RightDerived.lean`).

What remains (TARGET 1, the genuine gap): the ℕ-recursion building `I_B.cocomplex` with the
twisted differential `[[d_A, τ], [0, d_C]]`, where each off-diagonal `τ_n` and the augmentation
come from `Injective.factorThru` against the cosyzygy short exact sequences — exactly the
`mono_biprod_lift_factorThru_of_exact` shape, iterated. Model the recursion on
`InjectiveResolution.ofCocomplex` / `exact_f_d` / `ofCocomplex_exactAt_succ`. Then assemble the
SES `0 → I_A → I_B → I_C → 0` (degreewise `biprod.inl`/`biprod.snd`, so degreewise split via the
Mathlib biproduct splitting) and feed it to `rightDerivedShiftIsoOfSplitResolutionSES`.

### Planner strategy for the prover (`mathlib-build` mode)

The three declarations below are NOT yet present as Lean stubs because their
signatures depend on types (e.g. `InjectiveResolution.ofShortExact` requires a
freshly-built `InjectiveResolution B` whose `cocomplex` is not simply stated) whose
elaboration requires careful bootstrapping. The prover should build them in the order
listed here, each as its own standalone lemma chain.

References:
- Informal argument: `blueprint/src/chapters/Cohomology_AcyclicResolution.tex`
- Mathlib-alignment analysis: `.archon/analogies/p4-derived-les.md`

────────────────────────────────────────────────────────────────────
TARGET 1: `CategoryTheory.InjectiveResolution.ofShortExact`
Blueprint: `lem:injective_resolution_of_ses` (§ "Lifting a SES to injective resolutions").

Statement (informal):
  Given `0 → A → B → C → 0` short exact in `𝒜`, produce injective resolutions
  `I_A`, `I_B`, `I_C` and a degreewise-split short exact sequence of cochain complexes
  `0 → I_A.cocomplex → I_B.cocomplex → I_C.cocomplex → 0`.

Construction (dual Horseshoe Lemma):
1. Choose resolutions `I_A : InjectiveResolution A` and `I_C : InjectiveResolution C`
   (they exist because `𝒜` has injective resolutions / enough injectives).
2. Set `I_B^n := I_A.cocomplex.X n ⊞ I_C.cocomplex.X n` (biproduct of injectives
   = injective). The inclusion `I_A^n ↪ I_B^n` and projection `I_B^n ↠ I_C^n`
   are the canonical biproduct maps, so every degree is degreewise split.
3. Build the augmentation `B → I_B^0` and the twisted differential
   `d_B : I_B^n → I_B^{n+1}` by induction on `n`:
   - At each stage, the off-diagonal component `τ_n : I_C^n → I_A^{n+1}` is
     obtained by applying the injective lifting property
     (`Injective.factorThru`) to the mono `I_A^{n+1} → ...` and the relevant
     composite through `B`.
   - Differential in matrix notation: `d_B = [[d_A, τ], [0, d_C]]`.
4. Verify chain-map laws (d² = 0 for `d_B`; vertical maps are chain maps).
5. Prove `I_B` resolves `B`: exactness follows from the homology LES
   (`ShortComplex.ShortExact.homology_exact₁/₂/₃`) applied to the degreewise-split
   SES of complexes (split ⇒ additive functor preserves ⇒ applies to any `G`);
   the outer complexes `I_A, I_C` are acyclic, so the LES forces `I_B` acyclic.

Mathlib models (read these files):
- `Mathlib/CategoryTheory/Abelian/Injective/Resolution.lean:270–352`
  (`InjectiveResolution.ofCocomplex`, `exact_f_d`, `ofCocomplex_exactAt_succ`)
- `Injective.factorThru` for the stage-by-stage lift.

Build advice: do NOT write one monolithic def. Instead chain:
  a) `horseshoe_τ (n : ℕ) : I_C.cocomplex.X n ⟶ I_A.cocomplex.X (n+1)` — off-diagonal.
  b) `horseshoe_d (n : ℕ) : (I_A.X n ⊞ I_C.X n) ⟶ (I_A.X (n+1) ⊞ I_C.X (n+1))` — differential.
  c) Exactness lemmas per degree.
  d) Package as `InjectiveResolution B` and expose the SES of complexes.

Suggested output type (NOT yet defined):
-- def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜)
--     (hses : ses.ShortExact) (I_A : InjectiveResolution ses.X₁)
--     (I_C : InjectiveResolution ses.X₃) :
--     InjectiveResolution ses.X₂ × ShortComplex (CochainComplex 𝒜 ℕ)
or equivalently expose the SES directly as a field. The exact output shape is left
to the prover; the key postcondition is that the resulting SES `.ShortExact` holds
and the middle term is an injective resolution of `B = ses.X₂`.

────────────────────────────────────────────────────────────────────
TARGET 2: `CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`
Blueprint: `lem:acyclic_dimension_shift` (§ "The dimension-shift step").

Statement (informal):
  Let `G : 𝒜 ⥤ ℬ` be additive and left-exact, and
  `0 → A → J → Z → 0` a SES in `𝒜` with `J` right-`G`-acyclic. Then:
  (1) Connecting isomorphisms: `(Rᵏ G)(Z) ≅ (Rᵏ⁺¹ G)(A)` for all `k ≥ 1`.
  (2) Base case: `(R¹ G)(A) ≅ coker(G(J) → G(Z))`.

Route:
1. Apply `InjectiveResolution.ofShortExact` to get a degreewise-split SES
   `0 → I_A → I_J → I_Z → 0` of injective resolutions.
2. Apply `G` degreewise. Degreewise splitness + additive `G` ⇒ the image SES
   `0 → G(I_A) → G(I_J) → G(I_Z) → 0` is also short exact (as complexes).
   (Use `ShortComplex.Splitting.map` or `Functor.mapShortComplex` on the per-degree
   splitting.)
3. Feed to `ShortComplex.ShortExact.homology_exact₁/₂/₃` and `ShortComplex.ShortExact.δ`
   to get the complex-level homology LES.
4. Transport each `Hⁿ(G(I_•))` to `(Rⁿ G)(•)` via
   `InjectiveResolution.isoRightDerivedObj` (for `I_A`, `I_J`, `I_Z` individually).
5. Use `[IsRightAcyclic G J]` (i.e. `Functor.IsRightAcyclic.vanish`) to kill the
   `(Rᵏ G)(J)` terms for `k ≥ 1`; exactness collapses the LES to the isomorphisms
   claimed in parts (1) and (2).

Lean target name (must match blueprint exactly):
`CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic`

────────────────────────────────────────────────────────────────────
TARGET 3: `CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`
Blueprint: `lem:acyclic_resolution_computes_derived` (§ "The acyclic-resolution comparison theorem").

Statement (informal):
  Let `G : 𝒜 ⥤ ℬ` additive left-exact, and
  `0 → A → J⁰ → J¹ → J² → ⋯` a resolution of `A` with every `Jⁿ`
  right-`G`-acyclic. Then `(Rⁿ G)(A) ≅ Hⁿ(G(J•))` for all `n`.

Route (staircase induction):
1. Put `Z⁰ := A`, `Zᵐ := ker(Jᵐ → Jᵐ⁺¹) = im(Jᵐ⁻¹ → Jᵐ)` (cosyzygies).
   Exactness of the resolution ⇒ `0 → Zᵐ → Jᵐ → Zᵐ⁺¹ → 0` for each `m`.
2. Base: left-exactness of `G` gives `H⁰(G(J•)) ≅ G(A) = (R⁰G)(A)`.
   `rightDerivedShiftIsoOfAcyclic` part (2) gives `(R¹G)(A) ≅ coker(G(J⁰) → G(Z¹)) ≅ H¹(G(J•))`.
3. Induction step: compose the shift isomorphisms down the staircase
   `(Rⁿ G)(A) ≅ (Rⁿ⁻¹ G)(Z¹) ≅ ⋯ ≅ (R¹ G)(Zⁿ⁻¹)`
   and close with part (2) applied to the `(n-1)`-th SES.

Lean target name (must match blueprint exactly):
`CategoryTheory.Functor.rightDerivedIsoOfAcyclicResolution`

────────────────────────────────────────────────────────────────────
Note: the LES for `Functor.rightDerived n G` at a SES of objects does NOT exist in
Mathlib as a standalone theorem for general `G`. The Ext LES is Hom-specific
(cannot specialize to `G = f_*`); the derived-category triangulated route requires
`rightDerivedFunctorPlus` which is an explicit open Mathlib TODO. The horseshoe +
homology LES is the correct, self-contained gap to fill. (See `.archon/analogies/p4-derived-les.md`.)
-/

end CategoryTheory
