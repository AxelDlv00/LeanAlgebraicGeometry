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

/-- A short complex of cochain complexes that is *degreewise split* (each degree carries a
`ShortComplex.Splitting`) is short exact. Project-local because Mathlib only provides the
degreewise-short-exact criterion `shortExact_of_degreewise_shortExact`; this packages the
common special case where the degreewise data is a splitting. -/
lemma shortExact_of_degreewise_splitting
    {S : ShortComplex (CochainComplex 𝒜 (ComplexShape.up ℕ))}
    (splits : ∀ n, (S.map (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting) :
    S.ShortExact :=
  HomologicalComplex.shortExact_of_degreewise_shortExact S (fun n => (splits n).shortExact)

/-- An additive functor applied degreewise to a degreewise-split short complex of cochain
complexes yields a short exact short complex. This is the step where degreewise splitness is
essential: `G` is not assumed exact, but it preserves the *split* short exact sequences in each
degree (`ShortComplex.Splitting.map`), and degreewise short exactness then assembles to a short
exact sequence of complexes. -/
lemma shortExact_map_mapHomologicalComplex_of_degreewise_splitting
    {S : ShortComplex (CochainComplex 𝒜 (ComplexShape.up ℕ))}
    (splits : ∀ n, (S.map (HomologicalComplex.eval 𝒜 (ComplexShape.up ℕ) n)).Splitting)
    (G : 𝒜 ⥤ ℬ) [G.Additive] :
    (S.map (G.mapHomologicalComplex (ComplexShape.up ℕ))).ShortExact :=
  HomologicalComplex.shortExact_of_degreewise_shortExact _
    (fun n => ((splits n).map G).shortExact)

/-!
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

Output type (suggested):
```
def InjectiveResolution.ofShortExact {A B C : 𝒜} (ses : ShortComplex 𝒜)
    (hses : ses.ShortExact) (I_A : InjectiveResolution ses.X₁)
    (I_C : InjectiveResolution ses.X₃) :
    InjectiveResolution ses.X₂ × ShortComplex (CochainComplex 𝒜 ℕ)
```
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
