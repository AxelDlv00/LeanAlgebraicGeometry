# Mathlib Analogist Directive

## Mode: api-alignment

## Slug
p3b-presheafcech

## Context

The project formalizes the Čech computation of higher direct images for schemes. We are about to
scaffold a brand-new block of "presheaf-level Čech machinery" over a scheme's `O_X`-modules (the P3b
bridge: injective `O_X`-modules are Čech-acyclic). Before we author Lean signatures, we need to know
Mathlib's idiom for these constructions so we build the aligned version, NOT a parallel API.

Project context:
- For a scheme `X`, the project uses `X.Modules` for the category of `O_X`-modules (sheaf side). The
  goal theorem carries `[HasInjectiveResolutions X.Modules]`.
- We now need the PRESHEAF category `PMod(O_X)` (presheaves of `O_X`-modules, before sheafification)
  and the relationship `PMod(O_X) ⇄ Mod(O_X)` (sheafification ⊣ inclusion).

## Declarations we are about to scaffold (proposed `[expected]` names + intended meaning)

These come from the blueprint chapter `Cohomology_CechHigherDirectImage.tex` (Stacks "Cohomology" ch.,
`lemma-cech-map-into`, `lemma-homology-complex`, `lemma-cech-cohomology-derived-presheaves`,
`lemma-injective-trivial-cech`). For each, tell us the Mathlib-aligned shape (type, bundling, which
existing Mathlib API to build on) or whether Mathlib already provides it:

1. `AlgebraicGeometry.cechFreePresheafComplex` — the complex `K(𝒰)_•` of presheaves of `O_X`-modules
   for an open cover `𝒰` of `U`: in degree `p`, `⨁_{i_0…i_p} (j_{i_0…i_p})_! (O_X|_{U_{i_0…i_p}})`
   (extension-by-zero / "shriek" of the restricted structure sheaf), with the alternating Čech
   differential. → What is Mathlib's category for presheaves of modules over a (pre)sheaf of rings on
   a topological space / site? (`PresheafOfModules`? over what site — `(Opens X)ᵒᵖ`?) Does Mathlib
   have the extension-by-zero `j_!` (left adjoint to restriction) for presheaves/sheaves of modules on
   opens of a space? Does it have any Čech complex of presheaves/modules already?

2. `cechComplex_hom_identification` — `Hom_{O_X}(K(𝒰)_•, F) = Č•(𝒰, F)` naturally in `F`. → the
   shriek–restriction adjunction termwise. Is `j_! ⊣ restriction` (or `restriction ⊣ j_*`) available
   for `PresheafOfModules` on opens?

3. `cechFreeComplex_quasiIso` — `K(𝒰)_•` is quasi-isomorphic to `O_U[0]` (augmented Čech complex of
   presheaves is exact, via a sectionwise contracting homotopy). → Is there existing Čech-exactness /
   alternating-face contractibility infra?

4. `presheafModules_enoughInjectives` — `PMod(O_X)` has enough injectives. The intended route
   (confirmed by the strategy-critic): `CategoryTheory.IsGrothendieckAbelian.enoughInjectives`
   [verified present] + the presheaf category is Grothendieck abelian. KEY QUESTION: does Mathlib have
   an `IsGrothendieckAbelian (PresheafOfModules …)` instance, or the AB5 / filtered-colimits +
   generator infrastructure to derive it cheaply? `instIsGrothendieckAbelianModuleCat` [verified] gives
   it for `ModuleCat R` — is there a transfer to presheaf categories valued in a Grothendieck category
   (functor categories `[Cᵒᵖ, D]` Grothendieck when `D` is)? Cite the exact Mathlib instance/lemma if
   it exists; if not, name the cheapest construction path.

5. `cech_delta_functor_presheaves` — the Čech functors `Ȟ^p(𝒰, -)` on `PMod(O_X)` form a δ-functor
   canonically iso to the right-derived functors of `Ȟ^0(𝒰, -)`. → Does Mathlib's
   `CategoryTheory.Functor.rightDerived` + universal-δ-functor / effaceability API
   (`Abelian.RightDerived`, `deltaFunctor`, etc.) give this directly once enough-injectives holds?

6. `injective_cech_acyclic` — injective `O_X`-module `I` ⟹ `Ȟ^p(𝒰, I) = 0` for `p>0`. Route: an
   injective sheaf is injective as a presheaf (sheafification exact left adjoint preserves injectives
   under inclusion's right-adjointness — `Adjunction` + injective-preservation lemmas in Mathlib). →
   Confirm Mathlib has "right adjoint of an exact functor preserves injectives" and the
   `Mod ↪ PMod` / sheafification adjunction for `O_X`-modules.

## Also confirm (P3 re-sign)

7. We intend to re-sign the (non-protected) `CechAcyclic.affine` from `(𝒰 : X.OpenCover)` to carry the
   spanning-family bundle `(s : ι → Γ(X, O_X)) (hs : Ideal.span (Set.range s) = ⊤)` via
   `def:standard_affine_cover` (`Scheme.affineOpenCoverOfSpanRangeEqTop s hs`, verified present). Confirm
   the idiomatic way to feed `affineOpenCoverOfSpanRangeEqTop s hs` into the project's `CechComplex`
   (which currently takes `X.OpenCover`), and the cleanest signature shape so the proof can apply
   `exact_of_isLocalized_span` (which consumes the same `(s, hs)` datum). See
   `.archon/analogies/p3-localisation.md` for the prior P3 design lock.

## What I need back

For each of 1–7: the Mathlib-aligned shape (existing API to reuse, or the construction path if absent),
whether the project's proposed name/shape risks a parallel API, and the cost of misalignment. Rank by
risk. Persist the design to `analogies/p3b-presheafcech.md` so the scaffolder + future provers can read
it.
