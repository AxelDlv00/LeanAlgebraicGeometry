/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib

/-!
# The Quot scheme: Quot-foundations layer

This file packages the Quot-foundations layer of the
Grothendieck–Altman–Kleiman Quot-scheme construction. It introduces the
per-fiber Hilbert polynomial of a coherent sheaf, the Quot functor
`Quot^{Φ,L}_{E/X/S}` of `T`-flat coherent quotients, and the Grassmannian
*scheme* (Mathlib at the pinned commit carries only a linear-algebra
Grassmannian) together with its representability.

The 4 blueprint-pinned declarations are:

1. `AlgebraicGeometry.Scheme.hilbertPolynomial` (def) — the
   **Hilbert polynomial function** `s ↦ Φ_{F,s} ∈ ℚ[λ]` of a coherent
   sheaf `F` on `X` over a finite-type `π : X ⟶ S` with respect to a
   line bundle `L`. Encoded as a function `S → Polynomial ℚ`.

2. `AlgebraicGeometry.Scheme.QuotFunctor` (def) — the **Quot
   functor** `Quot^{Φ,L}_{E/X/S} : (Sch/S)^op ⥤ Set` sending an
   `S`-scheme `T ⟶ S` to the set of equivalence classes
   `⟨F, q⟩` of pairs `(F, q)` with `F` a `T`-flat coherent sheaf on
   `X_T`, `q : E_T ↠ F` a surjection, and `F|_{X_t}` having Hilbert
   polynomial `Φ` at every `t ∈ T`.

3. `AlgebraicGeometry.Scheme.Grassmannian` (def) — the
   **Grassmannian functor** `Grass(V, d) : (Sch/S)^op ⥤ Set` of
   rank-`d` quotients of a locally free `O_S`-module `V`.

4. `AlgebraicGeometry.Scheme.Grassmannian.representable` (theorem)
   — the **representability of the Grassmannian** by a smooth projective
   `S`-scheme `Gr_S(V, d)` of relative dimension `d(r-d)`, equipped with
   the Plücker closed embedding into `ℙ_S(⋀^d V)`.

## Note on type expressivity

Following the project rule "Never weaken the type to dodge the proof",
each declaration carries a substantive, non-tautological type:

- `hilbertPolynomial` returns `Polynomial ℚ` keyed by `s : S`, not
  `Unit`; the Hilbert polynomial is a non-trivial invariant of the
  coherent sheaf at the fiber over `s`.
- `QuotFunctor` and `Grassmannian` return contravariant functors into
  `Type u` — substantive presheaves of sets, not constant functors.
- `Grassmannian.representable` packages the
  `Functor.RepresentableBy` Yoneda-bijection structure: existence of a
  scheme `Y` together with a `RepresentableBy Y` witness — substantive
  content (a representable functor is determined by its representing
  object up to canonical isomorphism, and the witness is the data of
  that isomorphism family).

## Mathlib status

Mathlib (master `b80f227`) provides:
- `AlgebraicGeometry.Scheme.Modules` (the category `X.Modules`),
- `Scheme.Modules.pullback`, `Scheme.Modules.pushforward` (the
  pullback–pushforward adjunction at level `i = 0`),
- `CategoryTheory.Functor.RepresentableBy` for representable functors,
- `AlgebraicGeometry.LocallyOfFiniteType`, `AlgebraicGeometry.IsLocallyNoetherian`
  (morphism / object property predicates), and
- `Polynomial` for `ℚ[λ]`.

Mathlib does NOT provide (at the pinned commit):
- a Grassmannian *scheme* (only a linear-algebra Grassmannian
  as a finite-rank-quotient variety),
- the Quot/Hilbert functor or its representability,
- Snapper's Lemma for the polynomial property of Euler characteristics.

## References

Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`. Source:
Nitsure, "Construction of Hilbert and Quot Schemes", §1 (FGA Explained
Ch. 5, arXiv:math/0504020 pp. 5–35); cf. Hartshorne III.5.2.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

/-! ## §1. Hilbert polynomial of a coherent sheaf

For a finite-type morphism `π : X ⟶ S` with `S` noetherian and a coherent
sheaf `F` on `X` whose schematic support is proper over `S` (here encoded
as plain `X.Modules` for the file-skeleton), the per-fiber Hilbert
polynomial is the function

`s ↦ Φ_{F,s} ∈ ℚ[λ],   Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗m})`.

Snapper's Lemma ensures this is a polynomial in `m`; the proof requires
graded-Euler-characteristic infrastructure and is not stated here.

Blueprint reference: `def:hilbert_polynomial` (Nitsure §1; cf. Hartshorne
III.5.2). -/

/-- The **Hilbert polynomial** of a coherent sheaf `F` on `X` over `S` at
the fiber over `s ∈ S` with respect to a line bundle `L` on `X`.

Encoded as a function `s ↦ Φ_{F,s} ∈ ℚ[λ]`. The defining formula

`Φ_{F,s}(m) = χ(X_s, F|_{X_s} ⊗ L_s^{⊗ m})
            = Σ_i (-1)^i dim_{κ(s)} H^i(X_s, F|_{X_s} ⊗ L_s^{⊗m})`

is a polynomial in `m` by Snapper's Lemma; the polynomial coefficients
depend on `s` through the fiber `F|_{X_s}`. When `F` is `S`-flat the
function `s ↦ Φ_{F,s}` is locally constant on `S`.

iter-177+: the body unfolds to the graded-Euler-characteristic
construction once `χ` of a coherent sheaf on a noetherian scheme +
Snapper's polynomial-eventually-property are in scope. For the iter-176
file-skeleton the body is a typed `sorry`. -/
noncomputable def hilbertPolynomial {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _F : X.Modules) (_s : S) :
    Polynomial ℚ :=
  sorry

/-! ## §2. The Quot functor

The Quot functor `Quot^{Φ,L}_{E/X/S}` sends an `S`-scheme `T ⟶ S` to the
set of equivalence classes `⟨F, q⟩` of pairs `(F, q)` where
- `F` is a coherent sheaf on `X_T = X ×_S T` whose schematic support is
  proper over `T` and which is `T`-flat,
- `q : E_T ↠ F` is a surjective `O_{X_T}`-linear homomorphism,
- the fiberwise Hilbert polynomial of `F|_{X_t}` with respect to `L|_{X_t}`
  equals `Φ` at every `t ∈ T`.

Two pairs `(F, q)` and `(F', q')` are equivalent iff `ker(q) = ker(q')`.

The Hilbert scheme is the special case `E = O_X`:
`Hilb^{Φ,L}_{X/S} = Quot^{Φ,L}_{O_X/X/S}`.

Blueprint reference: `def:quot_functor` (Nitsure §1; FGA Explained Ch. 5). -/

/-- The **Quot functor** `Quot^{Φ,L}_{E/X/S}` of coherent quotients of `E`
on `X ×_S -` with Hilbert polynomial `Φ`.

Encoded as a contravariant functor `(Over S)ᵒᵖ ⥤ Type u`, sending an
`S`-scheme `T → S` (i.e. an object of `Over S`) to the set of
equivalence classes `⟨F, q⟩` of pairs `(F, q)` of a `T`-flat coherent
sheaf `F` on `X ×_S T` with proper support and a surjection
`q : E_T ↠ F` whose fiberwise Hilbert polynomial is `Φ`, modulo
`ker(q) = ker(q')`. Functoriality is pullback of the quotient along
`X ×_S T' ⟶ X ×_S T`.

iter-177+: the body packages the on-objects / on-morphisms data using the
`Scheme.Modules.pullback` bifunctor on the relative product
`X ×_S T`, with the equivalence relation `ker(q) = ker(q')` quotiented
out via `Setoid` / `Quotient`. For the iter-176 file-skeleton the body
is a typed `sorry`. -/
noncomputable def QuotFunctor {S X : Scheme.{u}} [IsLocallyNoetherian S]
    (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _E : X.Modules)
    (_Φ : Polynomial ℚ) :
    (Over S)ᵒᵖ ⥤ Type u :=
  sorry

end Scheme

/-! ## §3. The Grassmannian scheme

Since Mathlib carries no Grassmannian *scheme*, we encode it here as a
contravariant functor on `Over S` together with a representability
statement. The construction proceeds by gluing `binom(r, d)` affine
charts `U^I ≅ A^{d(r-d)}_S` along the Plücker cocycle, yielding a smooth
projective `S`-scheme `Gr_S(V, d)` of relative dimension `d(r-d)`,
equipped with a tautological rank-`d` quotient
`π* V ↠ U` and the Plücker closed embedding into `ℙ_S(⋀^d V)`.

Blueprint references: `def:grassmannian_scheme`,
`thm:grassmannian_representable` (Nitsure §1 Exercise (2),
"Construction of Grassmannian"; FGA Explained Ch. 5). -/

namespace Scheme

/-- The **Grassmannian functor** `Grass(V, d) : (Sch/S)^op ⥤ Set` of
rank-`d` quotients of a locally free `O_S`-module `V` of rank `r ≥ d`.

Encoded as the functor sending an `S`-scheme `T → S` to the set of
equivalence classes `⟨F, q⟩` of pairs `(F, q)` with
`q : V_T ↠ F` a surjection of `O_T`-modules and `F` locally free of
rank `d`, modulo `ker(q) = ker(q')`. Concretely
`Grass(V, d) = Quot^{d, O_S}_{V/S/S}` (the Quot functor for `X = S`,
`E = V`, constant Hilbert polynomial `d`).

iter-177+: the body re-exports `QuotFunctor (𝟙 S) (?) V Φ_d`, where
`Φ_d : Polynomial ℚ` is the constant polynomial `d`. For the iter-176
file-skeleton the body is a typed `sorry`. -/
noncomputable def Grassmannian {S : Scheme.{u}} [IsLocallyNoetherian S]
    (_V : S.Modules) (_d : ℕ) :
    (Over S)ᵒᵖ ⥤ Type u :=
  sorry

/-- **Representability of the Grassmannian.**

For a noetherian scheme `S`, a locally free `O_S`-module `V` of rank `r`,
and `1 ≤ d ≤ r`, the Grassmannian functor `Grass(V, d)` of
`Grassmannian` is representable by a smooth projective `S`-scheme
`Gr_S(V, d) ⟶ S` of relative dimension `d(r-d)`, equipped with a
tautological rank-`d` quotient `π* V ↠ U`. The determinant line bundle
`det(U)` is relatively very ample, giving a Plücker closed embedding
`Gr_S(V, d) ↪ ℙ_S(⋀^d V)`.

We package the conclusion as the existence of a representing
`Y : Over S` together with a `Functor.RepresentableBy Y` witness for
`Grassmannian V d`; the additional projective / smooth / Plücker
structure is implicit in the construction and is iter-177+ refinement
work (once the proof body lands).

iter-177+: the body follows Nitsure §1 "Construction of Grassmannian":
glue the `binom(r, d)` affine charts `U^I ≅ A^{d(r-d)}_S` along the
Plücker cocycle, verify separatedness via the diagonal cut, verify
properness by the DVR valuative criterion, build the tautological
quotient `U`, exhibit the Plücker embedding via the determinant line
bundle. For the iter-176 file-skeleton the body is a typed `sorry`. -/
theorem Grassmannian.representable {S : Scheme.{u}} [IsLocallyNoetherian S]
    (V : S.Modules) (d : ℕ) :
    ∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y) := by
  sorry

end Scheme

/-! ## Project-local Mathlib supplement — Quot/Grassmannian predicates

These declarations build the support/freeness predicates of
`blueprint/src/chapters/Picard_QuotScheme.tex`, §"Support and freeness
predicates". Mathlib (at the pinned commit) carries no rank-`d` local
freeness predicate for sheaves of modules on a scheme, so it is built here. -/

namespace SheafOfModules

/-- **Locally free of rank `d`** for a sheaf of modules on a scheme.

A sheaf of modules `M` on a scheme `X` is *locally free of rank `d`* when `X`
admits an open cover `{U i}` on each member of which the restriction
`M|_{U i}` (the pullback of `M` along the open immersion `(U i).ι`) is
isomorphic to the free module of rank `d`, `O_{U i}^{⊕ d}` (encoded as
`SheafOfModules.free (ULift (Fin d))` over the structure-ring sheaf of the
open subscheme `(U i).toScheme`).

This predicate is project-local: Mathlib does not supply a rank-indexed local
freeness predicate for sheaves of modules on a scheme. Blueprint:
`def:is_locally_free_of_rank` (Nitsure §1, Exercise (2)). -/
def IsLocallyFreeOfRank {X : Scheme.{u}} (M : X.Modules) (d : ℕ) : Prop :=
  ∃ (ι : Type u) (U : ι → X.Opens), (⨆ i, U i = ⊤) ∧
    ∀ i, Nonempty ((Scheme.Modules.pullback (U i).ι).obj M ≅
      _root_.SheafOfModules.free (R := (U i).toScheme.ringCatSheaf) (ULift.{u} (Fin d)))

end SheafOfModules

/-! ## Project-local Mathlib supplement — annihilator ideal sheaf and schematic support

These declarations build the annihilator ideal sheaf of a sheaf of modules and the
support/properness predicates of `blueprint/src/chapters/Picard_QuotScheme.tex`,
§"Support and freeness predicates". Mathlib (at the pinned commit) carries no
annihilator ideal sheaf for sheaves of modules on a scheme, nor a schematic-support
or proper-support predicate, so they are built here.

The annihilator is packaged via `Scheme.IdealSheafData.ofIdeals`, exactly mirroring
Mathlib's `Scheme.Hom.ker` (which is `ofIdeals fun U ↦ RingHom.ker (f.app U).hom`):
`ofIdeals` produces *the largest ideal sheaf contained in* an arbitrary affine-local
family of ideals, so the structure's `map_ideal_basicOpen` coherence is discharged
internally and need not be supplied at definition time. The basic-open coherence that
makes the local annihilators agree with `ofIdeals` (the analogue of `Hom.ker_apply`,
`def:modules_annihilator`) is the separate characterization lemma `annihilator_ideal`,
which depends on the not-yet-closed QCoh→localization bridge
`isLocalizedModule_basicOpen` (`lem:qcoh_section_localization_basicOpen`) together with
the algebra engine `Module.annihilator_isLocalizedModule_eq_map`
(`lem:annihilator_localization_eq_map`); see the handoff in
`task_results/.../QuotScheme.md`. -/

namespace Scheme.Modules

variable {X : Scheme.{u}}

/-- The **annihilator ideal sheaf** of a sheaf of modules `F` on a scheme `X`
(`def:modules_annihilator`).

On each affine open `U`, the intended section is the annihilator
`Ann_{Γ(X,U)}(Γ(F,U))` of the `Γ(X,U)`-module of sections `Γ(F,U)`. The ideal sheaf
is assembled with `Scheme.IdealSheafData.ofIdeals`, the largest ideal sheaf contained
in that affine-local family — exactly the construction used for `Scheme.Hom.ker`. This
sidesteps proving the basic-open coherence (`map_ideal_basicOpen`) at definition time;
the identity `(annihilator F).ideal U = Ann_{Γ(X,U)}(Γ(F,U))` is the downstream
characterization lemma (`annihilator_ideal`, blocked on the QCoh localization bridge).

This is a project-local primitive: Mathlib does not carry an annihilator ideal sheaf
for sheaves of modules on a scheme. -/
noncomputable def annihilator (F : X.Modules) : X.IdealSheafData :=
  IdealSheafData.ofIdeals fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1)

/-- The component of the annihilator ideal sheaf at an affine open is contained in the
module annihilator of the sections. This is the always-available (`ofIdeals`) direction
of the characterization; the reverse inclusion is the basic-open coherence blocked on
`isLocalizedModule_basicOpen`. Project-local because `annihilator` is. -/
lemma annihilator_ideal_le (F : X.Modules) (U : X.affineOpens) :
    (annihilator F).ideal U ≤ Module.annihilator Γ(X, U.1) Γ(F, U.1) :=
  IdealSheafData.ideal_ofIdeals_le _ _

/-- The **schematic support** of a sheaf of modules `F` on a scheme `X`
(`def:schematic_support`): the closed subscheme of `X` cut out by the annihilator
ideal sheaf `annihilator F`. Project-local because `annihilator` is. -/
noncomputable def schematicSupport (F : X.Modules) : Scheme.{u} :=
  (annihilator F).subscheme

/-- The canonical closed immersion of the schematic support into the ambient scheme,
realizing `schematicSupport F` as a closed subscheme of `X` (`def:schematic_support`).
This is the `IdealSheafData.subschemeι` of the annihilator ideal sheaf; it is a
`IsPreimmersion` + `QuasiCompact` immersion onto the support. Project-local because
`annihilator` is. -/
noncomputable def schematicSupportι (F : X.Modules) : schematicSupport F ⟶ X :=
  (annihilator F).subschemeι

/-- The sheaf of modules `F` **has proper support over `S` along `f`**
(`def:has_proper_support`): the composite of the schematic-support immersion with
`f : X ⟶ S` is a proper morphism. Since `AlgebraicGeometry.IsProper` is stable under
base change, this condition is preserved by pullback, as required by the Quot functor's
pullback action. Project-local because `schematicSupport` is. -/
def HasProperSupport {S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop :=
  IsProper (schematicSupportι F ≫ f)

end Scheme.Modules

end AlgebraicGeometry

/-! ## Project-local Mathlib supplement — annihilator under localization

The annihilator ideal sheaf `def:modules_annihilator` of a coherent sheaf is
built from the affine-local data `U ↦ Ann_{O(U)}(F(U))`, packaged as a
`Scheme.IdealSheafData`. The structure's coherence field `map_ideal_basicOpen`
requires the algebraic fact that, for a *finitely generated* module, the
annihilator commutes with localization:
`Ann(S⁻¹M) = (Ann M)·S⁻¹R`. Mathlib (at the pinned commit) does not carry this
lemma, so it is supplied here as the load-bearing engine for that construction.
-/

namespace Module

/-- For a finitely generated module `M` over a commutative ring `R`, the
annihilator commutes with localization: if `Rₚ` localizes `R` at a submonoid
`S` and `f : M →ₗ[R] Mₚ` localizes `M` at `S`, then the annihilator of `Mₚ`
over `Rₚ` is the extension (`Ideal.map` along `algebraMap R Rₚ`) of the
annihilator of `M` over `R`.

This is the abstract `IsLocalization`/`IsLocalizedModule` form, matching the
shape needed for the affine-basic-open coherence of the annihilator ideal sheaf
(`AlgebraicGeometry.Scheme.Modules.annihilator`, `def:modules_annihilator`):
the structure-sheaf restriction `Γ(X,U) → Γ(X, D(f))` is
`IsLocalization (powers f)`, and for a quasi-coherent `F` the section
restriction is `IsLocalizedModule (powers f)`.

Mathlib has no annihilator-localization lemma, so this is project-local. -/
theorem annihilator_isLocalizedModule_eq_map
    {R : Type*} [CommRing R] (S : Submonoid R)
    {Rₚ : Type*} [CommRing Rₚ] [Algebra R Rₚ] [IsLocalization S Rₚ]
    {M : Type*} [AddCommGroup M] [Module R M] [Module.Finite R M]
    {Mₚ : Type*} [AddCommGroup Mₚ] [Module R Mₚ] [Module Rₚ Mₚ] [IsScalarTower R Rₚ Mₚ]
    (f : M →ₗ[R] Mₚ) [IsLocalizedModule S f] :
    Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ) := by
  classical
  obtain ⟨t, htop⟩ := (Module.Finite.fg_top (R := R) (M := M))
  -- annihilating a spanning finset suffices for membership in the annihilator
  have key : ∀ (r : R), (∀ m ∈ t, r • m = 0) → r ∈ Module.annihilator R M := by
    intro r h
    rw [Module.mem_annihilator]
    intro x
    have hx : x ∈ Submodule.span R (t : Set M) := htop ▸ Submodule.mem_top
    induction hx using Submodule.span_induction with
    | mem y hy => exact h y hy
    | zero => simp
    | add a b _ _ ha hb => rw [smul_add, ha, hb, add_zero]
    | smul c a _ ha => rw [smul_comm, ha, smul_zero]
  apply le_antisymm
  · -- `Ann Rₚ Mₚ ⊆ (Ann R M).map`: clear one common denominator over the generators
    intro y hy
    rw [Module.mem_annihilator] at hy
    obtain ⟨⟨a, s⟩, rfl⟩ := IsLocalization.mk'_surjective S y
    dsimp only at hy ⊢
    have hgen : ∀ m ∈ t, ∃ u : S, (u : R) • a • m = 0 := by
      intro m hm
      have hz := hy (IsLocalizedModule.mk' f m (1 : S))
      rw [IsLocalizedModule.mk'_smul_mk' Rₚ f, IsLocalizedModule.mk'_eq_zero,
        IsLocalizedModule.eq_zero_iff S f] at hz
      obtain ⟨u, hu⟩ := hz
      exact ⟨u, hu⟩
    choose u hu using hgen
    obtain ⟨U, hU⟩ : ∃ U : S, ∀ m ∈ t, (U : R) • a • m = 0 := by
      refine ⟨∏ x ∈ t.attach, u x.1 x.2, ?_⟩
      intro m hm
      obtain ⟨c, hc⟩ :=
        Finset.dvd_prod_of_mem (fun x : t => u x.1 x.2) (Finset.mem_attach t ⟨m, hm⟩)
      have hcoe : ((∏ x ∈ t.attach, u x.1 x.2 : S) : R) = (u m hm : R) * (c : R) := by
        rw [hc]; push_cast; ring
      rw [hcoe, mul_smul, smul_comm, hu m hm, smul_zero]
    have hUa : (U : R) * a ∈ Module.annihilator R M := by
      apply key; intro m hm; rw [mul_smul]; exact hU m hm
    have heq : IsLocalization.mk' Rₚ a s
        = (algebraMap R Rₚ ((U : R) * a)) * IsLocalization.mk' Rₚ 1 (U * s) := by
      rw [← IsLocalization.mk'_eq_mul_mk'_one, IsLocalization.mk'_eq_iff_eq]
      push_cast; ring
    rw [heq]
    exact Ideal.mul_mem_right _ _ (Ideal.mem_map_of_mem _ hUa)
  · -- `(Ann R M).map ⊆ Ann Rₚ Mₚ`: the image of an annihilator annihilates
    rw [Ideal.map_le_iff_le_comap]
    intro a ha
    rw [Ideal.mem_comap, Module.mem_annihilator]
    rw [Module.mem_annihilator] at ha
    intro x
    obtain ⟨⟨m, s⟩, rfl⟩ := IsLocalizedModule.mk'_surjective S f x
    dsimp only [Function.uncurry]
    rw [← IsLocalization.mk'_one (M := S) Rₚ a, IsLocalizedModule.mk'_smul_mk' Rₚ f, ha m,
      IsLocalizedModule.mk'_zero]

end Module

/-! ## Project-local Mathlib supplement — quasi-coherent sections localize on a basic open

This section builds, bottom-up, toward the keystone
`lem:qcoh_section_localization_basicOpen`: for a quasi-coherent sheaf of modules `M`
on a scheme `X`, an affine open `U`, and `f ∈ Γ(X,U)`, the restriction
`M(U) → M(D(f))` exhibits `M(D(f))` as `IsLocalizedModule (powers f)` over `Γ(X,U)`.

The substance is the affine (Spec-local) computation: over `Spec R`, a quasi-coherent
sheaf is `Ñ = tilde N` for `N = Γ(M)`, and the basic-open restriction of `Ñ` is the
module localization map. Mathlib's `AlgebraicGeometry.tilde` namespace already carries
the localization fact for `tilde N` *as the map out of `N`* (the instance
`IsLocalizedModule (.powers f) (tilde.toOpen N (basicOpen f)).hom`). The first building
block below repackages this as a statement about the *presheaf restriction map* of `Ñ`
itself (from global sections to `D(f)`), which is the form the downstream scheme-level
argument consumes after the affine identification `M|_U ≅ Ñ`.

Mathlib (at the pinned commit) does **not** prove that an arbitrary quasi-coherent sheaf
on `Spec R` lies in the essential image of `tilde` (the comment in
`Mathlib/AlgebraicGeometry/Modules/Tilde.lean` says this "will later be shown"); the
equivalence `QCoh(Spec R) ≃ Mod R` is a genuine gap. Consequently the keystone for an
*arbitrary* quasi-coherent `M` is gated on that bridge (`IsQuasicoherent M → IsIso
M.fromTildeΓ`); the building blocks here are stated for `tilde N` directly, and for a
general `M : (Spec R).Modules` under the explicit hypothesis `[IsIso M.fromTildeΓ]`
(equivalently, `M` in the essential image of `tilde`). -/

namespace AlgebraicGeometry

open CategoryTheory Limits

/-- **Basic-open restriction of a `tilde` sheaf is a module localization.**

For `N : ModuleCat R` and `f : R`, the presheaf restriction map of the associated sheaf
`Ñ = tilde N` from global sections `Γ(Ñ, ⊤)` to the basic open `Γ(Ñ, D(f))` exhibits the
latter as `IsLocalizedModule (powers f)` over `R`.

This is the affine, Spec-local heart of `lem:qcoh_section_localization_basicOpen`. Mathlib
carries the localization fact for the map `tilde.toOpen N (D f) : N → Γ(Ñ, D(f))` out of
`N`; since `tilde.toOpen N ⊤ : N → Γ(Ñ, ⊤)` is an isomorphism and
`tilde.toOpen N (D f) = tilde.toOpen N ⊤ ≫ restriction` (`tilde.toOpen_res`), precomposing
the localization map with the inverse isomorphism (`IsLocalizedModule.of_linearEquiv_right`)
transfers the property to the restriction map. Project-local: Mathlib states the fact only
for the map out of `N`, not for the presheaf restriction of `Ñ`. -/
theorem isLocalizedModule_tilde_restrict {R : CommRingCat.{u}} (N : ModuleCat.{u} R) (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj (tilde N)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  set res := (modulesSpecToSheaf.obj (tilde N)).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op with hresdef
  have hres := tilde.toOpen_res N ⊤ (PrimeSpectrum.basicOpen f)
    (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤))
  -- `e : N ≃ₗ Γ(Ñ, ⊤)` is the global-sections isomorphism of the tilde sheaf.
  set e : N ≃ₗ[R] _ := (tilde.isoTop N).toLinearEquiv with hedef
  have key : (tilde.toOpen N (PrimeSpectrum.basicOpen f)).hom = res.hom ∘ₗ e.toLinearMap := by
    rw [hedef, ← hres]; rfl
  have hinst0 : IsLocalizedModule (Submonoid.powers f)
      (tilde.toOpen N (PrimeSpectrum.basicOpen f)).hom := inferInstance
  rw [key] at hinst0
  set g := res.hom ∘ₗ e.toLinearMap with hg
  haveI : IsLocalizedModule (Submonoid.powers f) g := hinst0
  have h2 := IsLocalizedModule.of_linearEquiv_right (S := Submonoid.powers f) (f := g) e.symm
  have he : g ∘ₗ e.symm.toLinearMap = res.hom := by
    apply LinearMap.ext; intro x
    change res.hom (e (e.symm x)) = res.hom x
    rw [e.apply_symm_apply]
  rw [he] at h2
  exact h2

/-- **Basic-open restriction localizes, for a sheaf in the essential image of `tilde`.**

For a sheaf of modules `M` on `Spec R` whose tilde-Gamma counit `M.fromTildeΓ` is an
isomorphism (equivalently, `M` lies in the essential image of the `tilde` functor — the
honest Spec-affine stand-in for quasi-coherence, see the section header), the presheaf
restriction map of `M` from global sections `Γ(M, ⊤)` to the basic open `Γ(M, D(f))`
exhibits the latter as `IsLocalizedModule (powers f)` over `R`.

This transports `isLocalizedModule_tilde_restrict` across the isomorphism
`M.fromTildeΓ : tilde N ⟶ M` (where `N = Γ(M, ⊤)`): the induced presheaf isomorphism is
natural in the open, so on each of `⊤` and `D(f)` it provides an `R`-linear isomorphism
intertwining the two restriction maps. Post- and pre-composing the localization map for
`tilde N` with these isomorphisms (`IsLocalizedModule.of_linearEquiv`,
`IsLocalizedModule.of_linearEquiv_right`) yields the property for `M`.

Project-local: it is the affine engine of `lem:qcoh_section_localization_basicOpen`. The
general quasi-coherent case additionally requires the (currently Mathlib-absent) bridge
`IsQuasicoherent M → IsIso M.fromTildeΓ`. -/
theorem isLocalizedModule_restrict_of_isIso_fromTildeΓ {R : CommRingCat.{u}}
    (M : (Spec R).Modules) [IsIso M.fromTildeΓ] (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  -- the presheaf-level isomorphism induced by the (iso) counit `M.fromTildeΓ`
  let ψ := (TopCat.Sheaf.forget (ModuleCat R) (Spec R)).map (modulesSpecToSheaf.map M.fromTildeΓ)
  haveI : IsIso ψ := inferInstance
  haveI : IsIso (ψ.app (.op (⊤ : (Spec R).Opens))) := inferInstance
  haveI : IsIso (ψ.app (.op (PrimeSpectrum.basicOpen f))) := inferInstance
  -- the component isomorphisms as `R`-linear equivalences
  let eTop : _ ≃ₗ[R] _ := (asIso (ψ.app (.op (⊤ : (Spec R).Opens)))).toLinearEquiv
  let eDf : _ ≃ₗ[R] _ := (asIso (ψ.app (.op (PrimeSpectrum.basicOpen f)))).toLinearEquiv
  -- the restriction map of `tilde N` (localizes by `isLocalizedModule_tilde_restrict`)
  let rt := ((modulesSpecToSheaf.obj
        (tilde ((modulesSpecToSheaf.obj M).presheaf.obj (.op ⊤)))).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom
  -- naturality square of `ψ` for `D(f) ⟶ ⊤`
  have hnat := ψ.naturality (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op
  have hnathom := congrArg ModuleCat.Hom.hom hnat
  rw [ModuleCat.hom_comp, ModuleCat.hom_comp] at hnathom
  haveI hrt : IsLocalizedModule (Submonoid.powers f) rt :=
    isLocalizedModule_tilde_restrict ((modulesSpecToSheaf.obj M).presheaf.obj (.op ⊤)) f
  haveI step1 : IsLocalizedModule (Submonoid.powers f) (eDf.toLinearMap ∘ₗ rt) :=
    IsLocalizedModule.of_linearEquiv (S := Submonoid.powers f) (f := rt) (e := eDf)
  haveI step2 : IsLocalizedModule (Submonoid.powers f)
      ((eDf.toLinearMap ∘ₗ rt) ∘ₗ eTop.symm.toLinearMap) :=
    IsLocalizedModule.of_linearEquiv_right (S := Submonoid.powers f)
      (f := eDf.toLinearMap ∘ₗ rt) (e := eTop.symm)
  -- identify the target restriction map with `(eDf ∘ rt) ∘ eTop⁻¹`
  convert step2 using 1
  apply LinearMap.ext; intro x
  have hc := LinearMap.congr_fun hnathom (eTop.symm x)
  simp only [LinearMap.comp_apply] at hc ⊢
  refine (?_ : _ = _).trans hc.symm
  congr 1
  exact (eTop.apply_symm_apply x).symm

/-- A morphism of sheaves of `R`-modules on `Spec R` that is an isomorphism on every basic open
`D(f)` is an isomorphism. This is the "isomorphism on a basis ⟹ isomorphism" reduction specialised
to the basic-open basis of `Spec R` (`PrimeSpectrum.isBasis_basic_opens`): injectivity on stalks is
`stalkFunctor_map_injective_of_isBasis`, surjectivity on stalks is the basic-open germ lift, and
`isIso_of_stalkFunctor_map_iso` concludes. Project-local glue used to assemble `IsIso M.fromTildeΓ`
from per-basic-open section data. -/
private theorem isIso_sheaf_of_isIso_app_basicOpen {R : CommRingCat.{u}}
    {F G : TopCat.Sheaf (ModuleCat.{u} R) (Spec R)} (α : F ⟶ G)
    (h : ∀ f : R, IsIso (α.1.app (.op (PrimeSpectrum.basicOpen f)))) : IsIso α := by
  have hB : TopologicalSpace.Opens.IsBasis (Set.range (@PrimeSpectrum.basicOpen R _)) :=
    PrimeSpectrum.isBasis_basic_opens
  have hinj : ∀ U ∈ Set.range (@PrimeSpectrum.basicOpen R _),
      Function.Injective (α.1.app (.op U)) := by
    rintro U ⟨f, rfl⟩
    exact ((ConcreteCategory.isIso_iff_bijective _).mp (h f)).1
  have hstalk : ∀ x, IsIso ((TopCat.Presheaf.stalkFunctor (ModuleCat.{u} R) x).map α.1) := by
    intro x
    rw [ConcreteCategory.isIso_iff_bijective]
    refine ⟨TopCat.Presheaf.stalkFunctor_map_injective_of_isBasis hB hinj x, ?_⟩
    intro t
    obtain ⟨U, hxU, hUB, s, rfl⟩ := TopCat.Presheaf.germ_exist_of_isBasis hB G.presheaf x t
    obtain ⟨f, rfl⟩ := hUB
    obtain ⟨s', rfl⟩ := ((ConcreteCategory.isIso_iff_bijective _).mp (h f)).2 s
    exact ⟨F.presheaf.germ _ x hxU s', by rw [TopCat.Presheaf.stalkFunctor_map_germ_apply]⟩
  exact TopCat.Presheaf.isIso_of_stalkFunctor_map_iso α

/-- A linear map intertwining two localizations of the same module at the same submonoid is
bijective: if `f : M →ₗ M'` and `g : M →ₗ M''` both exhibit a localization at `S` and
`h : M' →ₗ M''` satisfies `h ∘ₗ f = g`, then `h` is bijective (it is the canonical localization
isomorphism `IsLocalizedModule.linearEquiv`). Stated with the two `IsLocalizedModule` facts as
explicit hypotheses to avoid typeclass-diamond ambiguity at the call site. -/
private theorem bijective_comp_of_localizations {R : Type u} [CommRing R] (S : Submonoid R)
    {M M' M'' : Type u} [AddCommGroup M] [Module R M] [AddCommGroup M'] [Module R M']
    [AddCommGroup M''] [Module R M''] {f : M →ₗ[R] M'} {g : M →ₗ[R] M''} {h : M' →ₗ[R] M''}
    (hf : IsLocalizedModule S f) (hg : IsLocalizedModule S g) (hh : h ∘ₗ f = g) :
    Function.Bijective h := by
  haveI := hf; haveI := hg
  have heq : h = (IsLocalizedModule.linearEquiv S f g).toLinearMap := by
    apply IsLocalizedModule.linearMap_ext S (f := f) (f' := g)
    apply LinearMap.ext
    intro x
    rw [LinearMap.comp_apply, LinearMap.comp_apply, ← LinearMap.comp_apply, hh,
      LinearEquiv.coe_toLinearMap, IsLocalizedModule.linearEquiv_apply]
  rw [heq]
  exact (IsLocalizedModule.linearEquiv S f g).bijective

/-- **`IsIso M.fromTildeΓ` from per-basic-open section localization** (the cheap stalk/section
assembly of `lem:qcoh_affine_isIso_fromTildeΓ`, the blueprint "G1-assemble" step). If for every
`f : R` the section restriction `Γ(M, ⊤) → Γ(M, D(f))` of a sheaf of modules `M` on `Spec R`
exhibits the target as `IsLocalizedModule (powers f)` over `R` — exactly the conclusion of G1-core
(`lem:qcoh_affine_section_localization`,
`isLocalizedModule_basicOpen_of_isQuasicoherent`) — then the tilde-Gamma counit `M.fromTildeΓ` is
an isomorphism (equivalently `M` lies in the essential image of `tilde`).

On each basic open `D(f)` the component of `modulesSpecToSheaf.map M.fromTildeΓ` is a map between
two localizations of `N = Γ(M, ⊤)` at `powers f`: the source `Γ(tilde N, D(f))` localizes via the
instance `tilde.toOpen N (D f)` and the target `Γ(M, D(f))` localizes by hypothesis, and the two
localization maps are intertwined by `Scheme.Modules.toOpen_fromTildeΓ_app`. Hence the component is
the canonical localization isomorphism (`IsLocalizedModule.linearEquiv`);
`isIso_sheaf_of_isIso_app_basicOpen` upgrades this to an isomorphism of sheaves, and
`modulesSpecToSheaf` being fully faithful reflects it to `IsIso M.fromTildeΓ`.

This turns the remaining keystone obligation into exactly G1-core: combined with the converse engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ`, the per-basic-open localization hypothesis is
*equivalent* to `IsIso M.fromTildeΓ`. Project-local: Mathlib has no `IsQuasicoherent → IsIso
fromTildeΓ` bridge. -/
theorem isIso_fromTildeΓ_of_isLocalizedModule_restrict {R : CommRingCat.{u}}
    (M : (Spec R).Modules)
    (H : ∀ f : R, IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom) :
    IsIso M.fromTildeΓ := by
  haveI hmain : IsIso (modulesSpecToSheaf.map M.fromTildeΓ) := by
    apply isIso_sheaf_of_isIso_app_basicOpen
    intro f
    set N := (modulesSpecToSheaf.obj M).presheaf.obj (.op ⊤) with hN
    -- target localizes by hypothesis; source localizes by the `tilde.toOpen` instance
    haveI htgt : IsLocalizedModule (Submonoid.powers f)
        ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := H f
    set comp := (modulesSpecToSheaf.map M.fromTildeΓ).1.app (.op (PrimeSpectrum.basicOpen f))
      with hcomp
    rw [ConcreteCategory.isIso_iff_bijective]
    have hcompose := Scheme.Modules.toOpen_fromTildeΓ_app M (PrimeSpectrum.basicOpen f)
    -- the component intertwines the two localization maps of `N` at `powers f`
    have h1 : comp.hom ∘ₗ (tilde.toOpen N (PrimeSpectrum.basicOpen f)).hom
        = ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
      have e := congrArg ModuleCat.Hom.hom hcompose
      rwa [ModuleCat.hom_comp] at e
    change Function.Bijective (⇑comp.hom)
    exact bijective_comp_of_localizations (Submonoid.powers f)
      (inferInstance : IsLocalizedModule _ (tilde.toOpen N (PrimeSpectrum.basicOpen f)).hom)
      (H f) h1
  exact SpecModulesToSheafFullyFaithful.isIso_of_isIso_map M.fromTildeΓ

/-- **Characterization of `IsIso M.fromTildeΓ` by section localization.** For a sheaf of modules
`M` on `Spec R`, the tilde-Gamma counit `M.fromTildeΓ` is an isomorphism iff for every `f : R` the
section restriction `Γ(M, ⊤) → Γ(M, D(f))` exhibits the target as `IsLocalizedModule (powers f)`.

The forward direction is the affine engine `isLocalizedModule_restrict_of_isIso_fromTildeΓ`; the
reverse is `isIso_fromTildeΓ_of_isLocalizedModule_restrict`. Combined with G1-core
(`isLocalizedModule_basicOpen_of_isQuasicoherent`, `lem:qcoh_affine_section_localization`, not yet
formalized) — which supplies the right-hand side for any quasi-coherent `M` — this yields gap1
(`lem:qcoh_affine_isIso_fromTildeΓ`). Project-local. -/
theorem isIso_fromTildeΓ_iff_isLocalizedModule_restrict {R : CommRingCat.{u}}
    (M : (Spec R).Modules) :
    IsIso M.fromTildeΓ ↔ ∀ f : R, IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom :=
  ⟨fun h f => by haveI := h; exact isLocalizedModule_restrict_of_isIso_fromTildeΓ M f,
    isIso_fromTildeΓ_of_isLocalizedModule_restrict M⟩

/-! ## Project-local Mathlib supplement — G1-core (Route F) building blocks

The keystone G1-core `lem:qcoh_affine_section_localization` asks: for a *quasi-coherent*
`M : (Spec R).Modules` and `f : R`, the section restriction `Γ(M,⊤) → Γ(M,D(f))` is
`IsLocalizedModule (powers f)`. Via `isIso_fromTildeΓ_iff_isLocalizedModule_restrict` this is
*equivalent* to `IsIso M.fromTildeΓ` — i.e. to the statement that a quasi-coherent sheaf on an
affine scheme lies in the essential image of `tilde` (the `QCoh(Spec R) ≃ Mod R` equivalence). That
equivalence is a genuine Mathlib gap at the pinned commit (Tilde.lean only proves the *globally
presented* case, `isIso_fromTildeΓ_of_presentation`).

The composition lemma below discharges the **globally-presented** sub-case end to end (it is the
Route-F endpoint once a global presentation/tilde identification is in hand). The residual gap is
exactly the production of a global presentation/tilde from local (quasi-coherent) data on `Spec R`;
see the handoff in `task_results/.../QuotScheme.md`. -/

/-- **Basic-open restriction localizes, for a globally presented module.** If `M : (Spec R).Modules`
admits a global `SheafOfModules.Presentation`, then for every `f : R` the section restriction
`Γ(M,⊤) → Γ(M,D(f))` exhibits the target as `IsLocalizedModule (powers f)` over `R`.

This is the composition of Mathlib's `isIso_fromTildeΓ_of_presentation` (a global presentation
forces `M.fromTildeΓ` to be an isomorphism, i.e. `M` is a `tilde`) with the affine engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ`. It is the Route-F endpoint for the
globally-presented case; the general quasi-coherent case additionally requires producing a global
presentation/tilde identification from the (Mathlib-absent) affine `QCoh(Spec R) ≃ Mod R` bridge.
Project-local. -/
theorem isLocalizedModule_basicOpen_of_presentation {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (_P : M.Presentation) (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  haveI : IsIso M.fromTildeΓ := isIso_fromTildeΓ_of_presentation M _P
  exact isLocalizedModule_restrict_of_isIso_fromTildeΓ M f

/-- **`map_units` field of G1-core (Route F), for any sheaf of modules.** For `M : (Spec R).Modules`
and `f : R`, every element of `Submonoid.powers f` acts invertibly on the sections `Γ(M, D(f))` over
`R`. This is exactly the first field `IsLocalizedModule.map_units` of the target
`isLocalizedModule_basicOpen_of_isQuasicoherent`, in the shape the 3-field constructor consumes.

It holds for an *arbitrary* `M` (no quasi-coherence needed): on `D(f)` the element `f` already maps
to a unit of the structure ring `Γ(O_{Spec R}, D(f))` (the away-localization
`IsLocalization.Away.algebraMap_isUnit`), and the `R`-action on `Γ(M, D(f))` factors through it via
the scalar tower `R → Γ(O, D(f)) → Γ(M, D(f))`. Packaged from Mathlib's
`AlgebraicGeometry.tilde.isUnit_algebraMap_end_basicOpen`. Project-local only as the *named* field
of the Route-F decomposition; the substance of G1-core is `surj`/`exists_of_eq` (see handoff). -/
theorem map_units_restrict_basicOpen {R : CommRingCat.{u}} (M : (Spec R).Modules) (f : R) :
    ∀ x : Submonoid.powers f, IsUnit (algebraMap R (Module.End R
      ((modulesSpecToSheaf.obj M).presheaf.obj
        (.op (PrimeSpectrum.basicOpen f)))) (x : R)) := by
  rintro ⟨x, n, rfl⟩
  simpa using (tilde.isUnit_algebraMap_end_basicOpen M f).pow n

/-- **Finite basic-open cover refining a quasi-coherent presentation cover.** Given a
sheaf of modules `M` on `Spec R` together with quasi-coherent data `q` (a — possibly
infinite — open cover `q.X : q.I → (Spec R).Opens` of `⊤` with a presentation of
`M.over (q.X i)` on each member), there is a *finite* family of elements `t : Finset R`
whose basic opens cover `Spec R` (`Ideal.span t = ⊤`), with each basic open `D(r)`
(`r ∈ t`) contained in some member `q.X i` of the presentation cover.

This is the topological "finite-cover front" of `lem:exists_isIso_fromTildeΓ_basicOpen_cover`:
quasi-compactness of `Spec R` plus the basic-open basis (`PrimeSpectrum.isBasis_basic_opens`)
refine `q.X` to a finite basic-open subcover; the cover condition `q.coversTop` is read off the
`Opens.grothendieckTopology` sieve via `Sieve.mem_ofObjects_iff`, and finiteness is extracted
through `Ideal.span_eq_top_iff_finite`. To obtain `q` from `[M.IsQuasicoherent]`, take
`‹M.IsQuasicoherent›.nonempty_quasicoherentData.some`.

The remaining (heavy) step toward gap1 — transporting each presentation `q.presentation i`
of `M.over (q.X i)` across `D(r) ≅ Spec R_r` to `IsIso ((M|_{D(r)}).fromTildeΓ)` — is the
site-slice ↔ scheme-pullback transport, which has no Mathlib support at the pinned commit.
Project-local: Mathlib has no affine quasi-coherent → finite presentation cover lemma. -/
theorem exists_finite_basicOpen_cover_le_quasicoherentData {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) :
    ∃ t : Finset R, Ideal.span (t : Set R) = ⊤ ∧
      ∀ r ∈ t, ∃ i, (PrimeSpectrum.basicOpen r : (Spec R).Opens) ≤ q.X i := by
  classical
  set G : Set R := {r | ∃ i, (PrimeSpectrum.basicOpen r : (Spec R).Opens) ≤ q.X i} with hG
  have hspanG : Ideal.span G = ⊤ := by
    rw [← PrimeSpectrum.iSup_basicOpen_eq_top_iff']
    rw [eq_top_iff]
    intro x _
    simp only [TopologicalSpace.Opens.mem_iSup]
    obtain ⟨U, f, hf, hxU⟩ := q.coversTop ⊤ x (by trivial)
    rw [Sieve.mem_ofObjects_iff] at hf
    obtain ⟨i, ⟨hUi⟩⟩ := hf
    have hxXi : x ∈ q.X i := (leOfHom hUi) hxU
    obtain ⟨V, ⟨r, rfl⟩, hxV, hVle⟩ :=
      (TopologicalSpace.Opens.isBasis_iff_nbhd.mp PrimeSpectrum.isBasis_basic_opens) hxXi
    exact ⟨r, ⟨i, hVle⟩, hxV⟩
  obtain ⟨t, htsub, htspan⟩ := (Ideal.span_eq_top_iff_finite G).mp hspanG
  exact ⟨t, htspan, fun r hr => htsub hr⟩

/-! ## Project-local Mathlib supplement — the over-site ↔ open-subspace sheaf equivalence

The gap1 slice-to-geometric bridge `lem:over_restrict_iso` (`overRestrictIso`) rests on an
equivalence of *sheaf* categories
`Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A`
induced by the equivalence of underlying sites
`Opens.overEquivalence U : Over U ≌ Opens ↥U`. Mathlib carries `Opens.overEquivalence` but leaves
the *continuity* of its two functors and the induced sheaf-category equivalence as an explicit TODO
(see `Mathlib/Topology/Sheaves/Over.lean`: "show that both functors of the equivalence
`overEquivalence U` are continuous and induce an equivalence between
`Sheaf ((Opens.grothendieckTopology X).over U) A` and `Sheaf (Opens.grothendieckTopology U) A`").

This section fills that TODO. The two cover-lifting (`IsCocontinuous`) facts are the substance:
a sieve covers in the Grothendieck-topology-over-`U` exactly when its image under the slice
forgetful functor covers in the ambient space, and that condition matches the pointwise covering
condition on the open subspace `↥U` because `Subtype.val : ↥U → X` is an injective open embedding.
From the two cocontinuities, `Equivalence.isDenseSubsite_inverse_of_isCocontinuous` produces the
dense-subsite hypothesis and `Equivalence.sheafCongr` produces the sheaf equivalence.

It is the foundational (purely topological / topos-theoretic) layer of the slice-to-geometric
transport; the remaining steps toward `overRestrictIso` (identifying the sliced structure sheaf
`O_X.over U` with the open subscheme's structure sheaf `U.toScheme.ringCatSheaf` under this
equivalence, then lifting to sheaves of modules via `pushforwardPushforwardEquivalence` and relating
to `Scheme.Modules.restrictFunctor U.ι`) are the geometric layer above it. -/

section OverSiteSheafEquivalence

open TopologicalSpace Topology

variable {X : Type u} [TopologicalSpace X] (U : Opens X)

/-- The functor of `Opens.overEquivalence U` is cocontinuous (cover-lifting) from the
`U`-slice of the ambient Grothendieck topology to the Grothendieck topology of the open
subspace `↥U`. Foundational layer of the gap1 slice-to-geometric bridge `overRestrictIso`;
fills the `Mathlib/Topology/Sheaves/Over.lean` TODO. Project-local. -/
instance overEquivalence_functor_isCocontinuous :
    (Opens.overEquivalence U).functor.IsCocontinuous
      ((Opens.grothendieckTopology X).over U) (Opens.grothendieckTopology ↥U) where
  cover_lift := by
    intro Y S hS
    rw [GrothendieckTopology.mem_over_iff]
    intro x hx
    have hxU : x ∈ U := leOfHom Y.hom hx
    have hmem : (⟨x, hxU⟩ : ↥U) ∈ (Opens.overEquivalence U).functor.obj Y := hx
    obtain ⟨V, h, hSh, hxV⟩ := hS ⟨x, hxU⟩ hmem
    have hVle : (V : Set ↥U) ⊆ Subtype.val ⁻¹' (Y.left : Set X) := leOfHom h
    set W : Opens X := ⟨Subtype.val '' (V : Set ↥U),
      (U.isOpenEmbedding'.isOpen_iff_image_isOpen).1 V.isOpen⟩ with hWdef
    have hWle : W ≤ Y.left := by
      intro y hy; obtain ⟨z, hzV, rfl⟩ := hy; exact hVle hzV
    refine ⟨W, homOfLE hWle, ?_, ⟨⟨x, hxU⟩, hxV, rfl⟩⟩
    rw [Sieve.overEquiv_iff]
    change S ((Opens.overEquivalence U).functor.map (Over.homMk (homOfLE hWle)))
    have hdomle :
        (Opens.overEquivalence U).functor.obj (Over.mk ((homOfLE hWle) ≫ Y.hom)) ≤ V := by
      intro z hz
      obtain ⟨z', hz'V, hz'eq⟩ := (hz : (z : X) ∈ (W : Set X))
      exact (Subtype.val_injective hz'eq) ▸ hz'V
    convert S.downward_closed hSh (homOfLE hdomle) using 1

/-- The inverse of `Opens.overEquivalence U` is cocontinuous (cover-lifting) from the
Grothendieck topology of the open subspace `↥U` to the `U`-slice of the ambient Grothendieck
topology. Foundational layer of the gap1 slice-to-geometric bridge `overRestrictIso`;
fills the `Mathlib/Topology/Sheaves/Over.lean` TODO. Project-local. -/
instance overEquivalence_inverse_isCocontinuous :
    (Opens.overEquivalence U).inverse.IsCocontinuous
      (Opens.grothendieckTopology ↥U) ((Opens.grothendieckTopology X).over U) where
  cover_lift := by
    intro W S hS
    rw [GrothendieckTopology.mem_over_iff] at hS
    intro y hy
    have hpy : (y : X) ∈ ((Opens.overEquivalence U).inverse.obj W).left := ⟨y, hy, rfl⟩
    obtain ⟨P, f, hSf0, hpP⟩ := hS (y : X) hpy
    rw [Sieve.overEquiv_iff] at hSf0
    have hPle : (P : Set X) ⊆ ((Opens.overEquivalence U).inverse.obj W).left := leOfHom f
    set V : Opens ↥U :=
      ⟨Subtype.val ⁻¹' (P : Set X), P.isOpen.preimage continuous_subtype_val⟩ with hVdef
    have hVle : V ≤ W := by
      intro z hz
      obtain ⟨z', hz'W, hz'eq⟩ := hPle (hz : (z : X) ∈ (P : Set X))
      exact (Subtype.val_injective hz'eq) ▸ hz'W
    refine ⟨V, homOfLE hVle, ?_, hpP⟩
    change S ((Opens.overEquivalence U).inverse.map (homOfLE hVle))
    have hdomle : ((Opens.overEquivalence U).inverse.obj V).left ≤ P := by
      intro p hp; obtain ⟨p', hp'V, rfl⟩ := hp; exact hp'V
    convert S.downward_closed hSf0 (Over.homMk (homOfLE hdomle) ?_) using 1
    · apply Subsingleton.elim

/-- The dense-subsite witness for the inverse of `Opens.overEquivalence U`, assembled from the two
cover-lifting facts above. Project-local glue for `overEquivalence_sheafCongr`. -/
instance overEquivalence_inverse_isDenseSubsite :
    (Opens.overEquivalence U).inverse.IsDenseSubsite
      (Opens.grothendieckTopology ↥U) ((Opens.grothendieckTopology X).over U) :=
  Equivalence.isDenseSubsite_inverse_of_isCocontinuous _ _ _

/-- The functor of `Opens.overEquivalence U` is continuous. Derived from the cocontinuity of the
inverse and the equivalence adjunction `inverse ⊣ functor`. Needed downstream of `overRestrictIso`
for `SheafOfModules.pushforwardPushforwardEquivalence`. Project-local. -/
instance overEquivalence_functor_isContinuous :
    (Opens.overEquivalence U).functor.IsContinuous
      ((Opens.grothendieckTopology X).over U) (Opens.grothendieckTopology ↥U) := by
  haveI : (Opens.overEquivalence U).symm.functor.IsCocontinuous
      (Opens.grothendieckTopology ↥U) ((Opens.grothendieckTopology X).over U) :=
    inferInstanceAs ((Opens.overEquivalence U).inverse.IsCocontinuous _ _)
  exact (Opens.overEquivalence U).symm.toAdjunction.isContinuous_of_isCocontinuous _ _

/-- The inverse of `Opens.overEquivalence U` is continuous. Derived from the cocontinuity of the
functor and the equivalence adjunction `functor ⊣ inverse`. Needed downstream of `overRestrictIso`
for `SheafOfModules.pushforwardPushforwardEquivalence`. Project-local. -/
instance overEquivalence_inverse_isContinuous :
    (Opens.overEquivalence U).inverse.IsContinuous
      (Opens.grothendieckTopology ↥U) ((Opens.grothendieckTopology X).over U) :=
  (Opens.overEquivalence U).toAdjunction.isContinuous_of_isCocontinuous _ _

/-- **The over-site ↔ open-subspace sheaf equivalence.** For a topological space `X`, an open
`U ⊆ X`, and any category `A`, the equivalence of sites
`Opens.overEquivalence U : Over U ≌ Opens ↥U`
lifts to an equivalence of sheaf categories
`Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A`.

This is exactly the equivalence left as a TODO in `Mathlib/Topology/Sheaves/Over.lean`. It is the
foundational layer of the gap1 slice-to-geometric bridge (`lem:over_restrict_iso`,
`overRestrictIso`): once the sliced structure sheaf `O_X.over U` is identified with the structure
sheaf of the open subscheme `U.toScheme` under this equivalence, a presentation of `M.over U`
transports (via `pushforwardPushforwardEquivalence` + `restrictFunctorIsoPullback`) to a geometric
presentation of `M|_U`. Project-local: Mathlib supplies only the underlying site equivalence. -/
noncomputable def overEquivalence_sheafCongr (A : Type*) [Category A] :
    Sheaf ((Opens.grothendieckTopology X).over U) A ≌ Sheaf (Opens.grothendieckTopology ↥U) A :=
  (Opens.overEquivalence U).sheafCongr
    ((Opens.grothendieckTopology X).over U) (Opens.grothendieckTopology ↥U) A

end OverSiteSheafEquivalence

/-! ## Project-local Mathlib supplement — the slice-to-geometric module bridge (gap1, C)

This section builds the geometric layer of the gap1 slice-to-geometric bridge
`lem:over_restrict_iso` on top of the topological `overEquivalence_sheafCongr` of the previous
section. It identifies, on the level of *sheaves of modules*, the abstract Grothendieck-slice
restriction `M.over U` (a sheaf of modules over the sliced structure sheaf `O_X.over U` on the slice
site `J.over U`) with the geometric restriction `(restrictFunctor U.ι).obj M` on the small Zariski
site of the open subscheme `U.toScheme`.

The key structural facts, all holding *definitionally* at the pinned commit, are:
* `(Opens.overEquivalence U).inverse ⋙ Over.forget U = U.ι.opensFunctor` (`rfl`): the inverse leg
  of the site equivalence, post-composed with the slice-forgetful functor, is the opens functor of
  the open immersion `U.ι`;
* consequently `U.toScheme.ringCatSheaf = (overEquivalence_sheafCongr U RingCat).functor.obj
  (X.ringCatSheaf.over U)` (`rfl`): the structure sheaf of the open subscheme is the transport of
  the sliced structure sheaf across the ring-valued sheaf equivalence (this is *step 2*, the
  geometric ring-sheaf identification, discharged by `rfl`).

From these, `SheafOfModules.pushforwardPushforwardEquivalence` lifts the site equivalence to an
equivalence of categories of sheaves of modules (`overRestrictEquiv`, *step 3*), under whose functor
the sliced module `M.over U` corresponds to the geometric restriction (`overRestrictIso`, *step 4*).

Mathlib (at the pinned commit) supplies only the underlying site equivalence and the
`pushforward`/`restrictFunctor` machinery; the assembly is project-local. -/

section OverRestrictBridge

open TopologicalSpace Topology

namespace Scheme.Modules

variable {X : Scheme.{u}} (U : X.Opens)

/-- **The slice-to-geometric equivalence of categories of sheaves of modules** (gap1, C, step 3).

For a scheme `X` and an open `U ⊆ X`, the category of sheaves of modules over the sliced structure
sheaf `O_X.over U` on the slice site `J.over U` is equivalent to the category `U.toScheme.Modules`
of sheaves of modules on the open subscheme `U.toScheme`. The equivalence is obtained by lifting the
topological site equivalence `Opens.overEquivalence U` (and its ring-valued sheaf congruence
`overEquivalence_sheafCongr`) to sheaves of modules via
`SheafOfModules.pushforwardPushforwardEquivalence`; the two ring-sheaf comparison morphisms it
consumes are the (co)unit of `Opens.overEquivalence U` whiskered into the structure presheaf, and
the identity (the geometric structure sheaf being *definitionally* the transport of the sliced one).

Project-local: it is the module-level layer of the gap1 bridge `lem:over_restrict_iso`; Mathlib
supplies only the underlying site equivalence. -/
noncomputable def overRestrictEquiv :
    SheafOfModules.{u} (X.ringCatSheaf.over U) ≌ U.toScheme.Modules :=
  letI eqv := Opens.overEquivalence U
  (SheafOfModules.pushforwardPushforwardEquivalence
      (J := (Opens.grothendieckTopology ↥X).over U) (K := Opens.grothendieckTopology ↥U) eqv
    (S := X.ringCatSheaf.over U) (R := U.toScheme.ringCatSheaf)
    (Sheaf.Hom.mk (Functor.whiskerRight (NatTrans.op eqv.unitIso.inv) (X.ringCatSheaf.over U).obj))
    (Sheaf.Hom.mk (𝟙 _))
    (by ext : 2
        simp only [Sheaf.Hom.mk, Functor.comp_obj, Functor.whiskerLeft_app,
          Functor.whiskerRight_app, NatTrans.op_app, NatTrans.id_app,
          ObjectProperty.homMk_hom, NatTrans.comp_app]
        exact congrArg (Sheaf.over X.ringCatSheaf U).obj.map
          (congrArg Quiver.Hom.op (Equivalence.unitInv_app_inverse eqv _).symm))
    (by ext : 2
        simp only [Sheaf.Hom.mk, Functor.whiskerLeft_app, Functor.whiskerRight_app,
          NatTrans.op_app, ObjectProperty.homMk_hom, NatTrans.comp_app, NatTrans.id_app,
          Functor.comp_obj]
        erw [Category.id_comp, ← Functor.map_comp]
        rename_i x
        have h : (eqv.unitIso.inv.app (Opposite.unop x)).op ≫ (eqv.unit.app (Opposite.unop x)).op
            = 𝟙 _ := by
          rw [← op_comp]
          simp
        exact (congrArg (Sheaf.over X.ringCatSheaf U).obj.map h).trans
          (CategoryTheory.Functor.map_id _ _))).symm

/-- **Step-4 functor identification of the gap1 bridge.** The composite of `SheafOfModules.over · U`
with the slice-to-geometric equivalence `overRestrictEquiv U` is the geometric restriction functor
`restrictFunctor U.ι` along the open immersion `U.ι`. Both are pushforwards along the immersion's
opens functor (`(Opens.overEquivalence U).inverse ⋙ Over.forget U = U.ι.opensFunctor`, `rfl`); the
two ring-sheaf comparison morphisms agree, so the identification is `pushforwardComp` followed by
`pushforwardCongr`. Project-local. -/
noncomputable def overRestrictFunctorIso :
    (SheafOfModules.pushforward (S := X.ringCatSheaf.over U) (𝟙 _)) ⋙
        (overRestrictEquiv U).functor ≅ restrictFunctor U.ι :=
  haveI : ((Opens.overEquivalence U).inverse ⋙ Over.forget U).IsContinuous
      (Opens.grothendieckTopology ↥U) (Opens.grothendieckTopology ↥X) :=
    Functor.isContinuous_comp (Opens.overEquivalence U).inverse (Over.forget U)
      (Opens.grothendieckTopology ↥U) ((Opens.grothendieckTopology ↥X).over U)
      (Opens.grothendieckTopology ↥X)
  SheafOfModules.pushforwardComp _ _ ≪≫ SheafOfModules.pushforwardCongr (by cat_disch)

/-- **The slice-to-geometric isomorphism on an object** (gap1, C, step 4): for a sheaf of modules
`M` on `X`, the transport of the abstract Grothendieck-slice restriction `M.over U` under the
slice-to-geometric equivalence `overRestrictEquiv U` is canonically isomorphic to the geometric
restriction `(restrictFunctor U.ι).obj M`. This is the object-level form of
`overRestrictFunctorIso`; composed with `restrictFunctorIsoPullback` it lands the geometric
restriction as the pullback `U.ι^* M`. Project-local: the load-bearing slice-touching ingredient of
the gap1 transport `lem:over_restrict_iso`. -/
noncomputable def overRestrictIso (M : X.Modules) :
    (overRestrictEquiv U).functor.obj (M.over U) ≅ (restrictFunctor U.ι).obj M :=
  (overRestrictFunctorIso U).app M

/-- **The slice-to-geometric isomorphism in pullback form** (gap1, C, step 4'): the transport of the
abstract Grothendieck-slice restriction `M.over U` under `overRestrictEquiv U` is canonically
isomorphic to the inverse-image (pullback) `U.ι^* M` of `M` along the open immersion `U.ι`. This is
`overRestrictIso` composed with Mathlib's `restrictFunctorIsoPullback`; it is the form a
presentation of `M.over U` transports into a presentation of the geometric pullback `U.ι^* M`.
Project-local. -/
noncomputable def overRestrictPullbackIso (M : X.Modules) :
    (overRestrictEquiv U).functor.obj (M.over U) ≅ (Scheme.Modules.pullback U.ι).obj M :=
  overRestrictIso U M ≪≫ (restrictFunctorIsoPullback U.ι).app M

end Scheme.Modules

end OverRestrictBridge

/-! ## Project-local Mathlib supplement — slice-to-geometric presentation transport (gap1, P1)

This section builds the geometric milestone of the gap1 per-element transport
`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (P1): a `SheafOfModules.Presentation` of the
abstract Grothendieck-slice restriction `M.over U` is transported, across the slice-to-geometric
bridge `overRestrictPullbackIso` (gap1, C), into a `SheafOfModules.Presentation` of the *geometric*
restriction `(Scheme.Modules.pullback U.ι).obj M = U.ι^* M` on the open subscheme `U.toScheme`.

The load-bearing ingredient is the unit-iso `overRestrictUnitIso`: the slice-to-geometric
equivalence functor `(overRestrictEquiv U).functor` (definitionally a `SheafOfModules.pushforward`
along the equivalence-of-sites inverse with the *identity* ring comparison) sends the
structure-sheaf module `unit` to `unit`. This is exactly the `F.obj (unit R) ≅ unit S` datum that
`SheafOfModules.Presentation.map` consumes; once it is in hand, `Presentation.map` +
`Presentation.ofIsIso` (across `overRestrictPullbackIso`) realise the transport. The unit-iso rests
on the general fact `isIso_unitToPushforwardObjUnit_of_isIso'`: the canonical map
`unit S ⟶ (pushforward ψ).obj (unit R)` is an iso whenever the ring-sheaf comparison `ψ` is
(here `ψ = 𝟙`).

Mathlib (at the pinned commit) supplies `SheafOfModules.unitToPushforwardObjUnit` and proves it iso
only under a finality hypothesis on the site functor (`PullbackFree.lean`); the
`IsIso ψ ⟹ IsIso (unitToPushforwardObjUnit ψ)` route used here, and the slice transport, are
project-local. -/

section SliceGeometricPresentation

open CategoryTheory Limits TopologicalSpace Topology

/-- **`unitToPushforwardObjUnit` is an isomorphism when the ring-sheaf comparison is.**

For a continuous functor `F` of sites and a morphism of ring sheaves
`ψ : S ⟶ (F.sheafPushforwardContinuous …).obj R` that is an isomorphism, the canonical map
`unitToPushforwardObjUnit ψ : unit S ⟶ (pushforward ψ).obj (unit R)` is an isomorphism. Its
component on each object is `(forget₂ RingCat AddCommGrpCat).map (ψ.hom.app _)`, iso as `ψ` is;
the conclusion follows by the reflect-isomorphism functors `SheafOfModules.toSheaf` and
`sheafToPresheaf` together with `NatTrans.isIso_iff_isIso_app`.

Project-local: Mathlib proves `unitToPushforwardObjUnit` iso only under a finality hypothesis on `F`
(`SheafOfModules.PullbackFree`); this `IsIso ψ`-driven form is the one the slice-to-geometric
unit-iso `overRestrictUnitIso` (gap1, P1) consumes (with `ψ = 𝟙`). -/
private theorem isIso_unitToPushforwardObjUnit_of_isIso' {C : Type u} [Category.{u} C]
    {D : Type u} [Category.{u} D]
    {J : GrothendieckTopology C} {K : GrothendieckTopology D} {Fu : C ⥤ D}
    {S : Sheaf J RingCat.{u}} {Rr : Sheaf K RingCat.{u}} [Fu.IsContinuous J K]
    (ψ : S ⟶ (Fu.sheafPushforwardContinuous RingCat.{u} J K).obj Rr)
    [J.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    [K.HasSheafCompose (forget₂ RingCat.{u} AddCommGrpCat.{u})]
    (hψ : IsIso ψ) :
    IsIso (SheafOfModules.unitToPushforwardObjUnit ψ) := by
  haveI := hψ
  haveI hmap : IsIso ((sheafToPresheaf J RingCat).map ψ) := inferInstance
  rw [NatTrans.isIso_iff_isIso_app] at hmap
  rw [← isIso_iff_of_reflects_iso _ (SheafOfModules.toSheaf _)]
  rw [← isIso_iff_of_reflects_iso _ (sheafToPresheaf _ _)]
  rw [NatTrans.isIso_iff_isIso_app]
  intro V
  haveI hiso : IsIso (ψ.hom.app V) := hmap V
  haveI : IsIso ((forget₂ RingCat AddCommGrpCat).map (ψ.hom.app V)) := inferInstance
  convert this using 1

namespace Scheme.Modules

variable {X : Scheme.{u}}

/-- **The slice-to-geometric equivalence functor sends `unit` to `unit`** (gap1, P1).

For an open `U ⊆ X`, the functor of the slice-to-geometric equivalence `overRestrictEquiv U`
(definitionally `SheafOfModules.pushforward` along `(Opens.overEquivalence U).inverse` with the
identity ring comparison) carries the sliced structure-sheaf module `unit (O_X.over U)` to the
structure-sheaf module `unit (U.toScheme.ringCatSheaf)` of the open subscheme. This is the
`F.obj (unit R) ≅ unit S` datum consumed by `SheafOfModules.Presentation.map` in
`overRestrictPresentation`. Project-local. -/
noncomputable def overRestrictUnitIso (U : X.Opens) :
    (overRestrictEquiv U).functor.obj (SheafOfModules.unit (X.ringCatSheaf.over U)) ≅
      SheafOfModules.unit U.toScheme.ringCatSheaf := by
  unfold overRestrictEquiv
  dsimp only [Equivalence.symm_functor]
  refine (@asIso _ _ _ _ (SheafOfModules.unitToPushforwardObjUnit
      (F := (Opens.overEquivalence U).inverse) (J := Opens.grothendieckTopology ↥U)
      (S := U.toScheme.ringCatSheaf) (R := X.ringCatSheaf.over U)
      (ObjectProperty.homMk (𝟙 _)))
    (isIso_unitToPushforwardObjUnit_of_isIso' _ ?hpsi)).symm
  exact inferInstanceAs (IsIso (𝟙 U.toScheme.ringCatSheaf))

/-- **Slice presentation ⟹ geometric-restriction presentation** (gap1, P1).

Given a sheaf of modules `M` on `X`, an open `U ⊆ X`, and a `SheafOfModules.Presentation` of the
abstract Grothendieck-slice restriction `M.over U`, there is a `SheafOfModules.Presentation` of the
*geometric* restriction `(pullback U.ι).obj M = U.ι^* M` on the open subscheme `U.toScheme`. The
transport is `Presentation.map` along the slice-to-geometric equivalence functor (using the unit-iso
`overRestrictUnitIso`) followed by `Presentation.ofIsIso` across the bridge
`overRestrictPullbackIso` (gap1, C).

This closes the slice-touching step of the gap1 per-element transport
`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (P1): with `U = q.X i` and
`P = q.presentation i` it produces a global presentation of `U.ι^* M`; the remaining geometric step
restricts further to a basic affine `D(r) ≅ Spec R_r` and concludes via
`isIso_fromTildeΓ_of_presentation`. Project-local. -/
noncomputable def overRestrictPresentation (U : X.Opens) (M : X.Modules)
    (P : (M.over U).Presentation) : ((Scheme.Modules.pullback U.ι).obj M).Presentation :=
  SheafOfModules.Presentation.ofIsIso.{u} (overRestrictPullbackIso U M).hom
    (SheafOfModules.Presentation.map.{u} P (overRestrictEquiv U).functor (overRestrictUnitIso U))

set_option maxHeartbeats 2000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- **Geometric restriction to a cover member is globally presented** (gap1, P1).

For a sheaf of modules `M` on `X` with quasi-coherence data `q` and an index `i`, the geometric
restriction `(pullback (q.X i).ι).obj M = (q.X i).ι^* M` of `M` to the open subscheme
`(q.X i).toScheme` admits a `SheafOfModules.Presentation`. It is `overRestrictPresentation` applied
to the slice presentation `q.presentation i : (M.over (q.X i)).Presentation` supplied by the
quasi-coherence datum.

This is the per-cover-member output that feeds the affine descent of the gap1 transport
`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (P1): for `D(r) ≤ q.X i` one further restricts this
presentation to the basic affine `D(r) ≅ Spec R_r` and concludes via
`isIso_fromTildeΓ_of_presentation`. The heartbeat headroom tames the slice-site
`IsRightAdjoint`/`HasSheafify` synthesis blow-up that `Presentation.map` triggers across the
equivalence functor (the same `backward.isDefEq.respectTransparency false` incantation Mathlib's own
`QuasicoherentData.bind` uses). Project-local. -/
noncomputable def presentationPullbackιOfQuasicoherentData (M : X.Modules)
    (q : M.QuasicoherentData) (i : q.I) :
    ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj M).Presentation :=
  overRestrictPresentation (q.X i) M (q.presentation i)

end Scheme.Modules

end SliceGeometricPresentation

/-! ## Project-local Mathlib supplement — basic-open presentation descent (gap1, P1 keystone)

This section assembles the gap1 per-element keystone
`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`
(`isIso_fromTildeΓ_restrict_basicOpen`): on a basic open `D(r)` contained in a cover member
`q.X i` of the quasi-coherence data, the restricted sheaf `M|_{D(r)}` is a geometric tilde, i.e.
its `fromTildeΓ` counit is an isomorphism.

The route follows the affine descent of the recipe, building on the slice-to-geometric presentation
transport of the previous section:

1. `presentationPullbackιOfQuasicoherentData M q i` is a *global* `Presentation` of the geometric
   restriction `N := (q.X i).ι^* M` on the open subscheme `Z := (q.X i).toScheme`.
2. For any open `W ⊆ Z`, the global presentation `PN` slices to a slice presentation `N.over W` via
   the single `Presentation.map` of the over-functor `pushforward (𝟙 …)` (the
   `QuasicoherentData.ofPresentation` template — no iterated-slice equivalence is needed because
   `PN` is already a global presentation on the genuine scheme `Z`).
3. `overRestrictPresentation W N PNW` transports it to a global presentation of the geometric
   restriction `(pullback W.ι).obj N` on the open subscheme `W.toScheme`.
4. For `W` *affine*, `IsAffineOpen.isoSpec` identifies `W.toScheme ≅ Spec Γ(Z, W)`; transporting the
   presentation across this iso (whose `Opens.map` is `Final`, so `pullbackObjUnitToUnit` is an iso)
   lands a global presentation on the genuine affine `Spec Γ(Z, W)`.
5. A global presentation forces `fromTildeΓ` to be an isomorphism
   (`isIso_fromTildeΓ_of_presentation`).

Mathlib (at the pinned commit) carries no `QCoh(Spec R) ≃ Mod R` essential-image bridge; this descent
is project-local. -/

section BasicOpenPresentationDescent

open CategoryTheory Limits TopologicalSpace Topology

namespace Scheme.Modules

variable {X : Scheme.{u}}

set_option maxHeartbeats 2000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- **Presentation of the geometric restriction of `M` to an open `W` of a cover member** (gap1, P1).

For a sheaf of modules `M` on `X` with quasi-coherence data `q`, an index `i`, and *any* open
`W ⊆ (q.X i).toScheme` of the cover-member subscheme, the geometric restriction
`(pullback W.ι).obj ((pullback (q.X i).ι).obj M)` of `M` (pulled back to `Z := (q.X i).toScheme`,
then to `W`) admits a `SheafOfModules.Presentation` on the open subscheme `W.toScheme`.

It slices the *global* presentation `presentationPullbackιOfQuasicoherentData M q i` of
`N := (q.X i).ι^* M` on `Z` down to the slice `N.over W` (a single `Presentation.map` of the
over-functor — the `QuasicoherentData.ofPresentation` template, no iterated-slice equivalence
needed since `PN` is global on the genuine scheme `Z`), then geometrizes via
`overRestrictPresentation`. Project-local: feeds the affine descent of the gap1 keystone
`isIso_fromTildeΓ_restrict_basicOpen`. -/
noncomputable def presentationPullbackιRestrict (M : X.Modules)
    (q : M.QuasicoherentData) (i : q.I) (W : (show X.Opens from q.X i).toScheme.Opens) :
    ((Scheme.Modules.pullback (Scheme.Opens.ι W)).obj
      ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj M)).Presentation :=
  overRestrictPresentation W ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj M)
    (SheafOfModules.Presentation.map.{u}
      (presentationPullbackιOfQuasicoherentData M q i)
      (SheafOfModules.pushforward
        (𝟙 ((show X.Opens from q.X i).toScheme.ringCatSheaf.over W))) (by rfl))

/-- **The opens functor of an iso of schemes is an equivalence of opens sites.** For `φ : Y ≅ Z`,
the inverse-image functor `Opens.map φ.inv.base : Opens ↥Y ⥤ Opens ↥Z` is an equivalence (with
inverse `Opens.map φ.hom.base`), assembled from the pseudofunctoriality isos `Opens.mapComp` /
`Opens.mapId`. Its purpose is to supply the `Final` instance that makes `pullbackObjUnitToUnit` an
isomorphism in `pullbackSchemeIsoUnitIso`. Project-local. -/
noncomputable def opensMapEquivOfIso {Y Z : Scheme.{u}} (φ : Y ≅ Z) :
    TopologicalSpace.Opens ↥Y ≌ TopologicalSpace.Opens ↥Z where
  functor := Opens.map φ.inv.base
  inverse := Opens.map φ.hom.base
  unitIso := (Opens.mapId _).symm ≪≫
      Opens.mapIso (𝟙 _) (φ.hom.base ≫ φ.inv.base)
        (show (𝟙 _) = φ.hom.base ≫ φ.inv.base by
          rw [← AlgebraicGeometry.Scheme.Hom.comp_base, φ.hom_inv_id]; rfl) ≪≫
      Opens.mapComp φ.hom.base φ.inv.base
  counitIso := (Opens.mapComp φ.inv.base φ.hom.base).symm ≪≫
      Opens.mapIso (φ.inv.base ≫ φ.hom.base) (𝟙 _)
        (show φ.inv.base ≫ φ.hom.base = 𝟙 _ by
          rw [← AlgebraicGeometry.Scheme.Hom.comp_base, φ.inv_hom_id]; rfl) ≪≫
      Opens.mapId _

/-- **The opens functor of an iso of schemes is final.** Immediate from
`opensMapEquivOfIso` (an equivalence is final); the `Final` fact needed by
`pullbackObjUnitToUnit`. Supplied via `haveI` at use sites (instance resolution cannot invert
`φ.inv.base`). Project-local. -/
theorem opensMap_final_of_schemeIso {Y Z : Scheme.{u}} (φ : Y ≅ Z) :
    (Opens.map φ.inv.base).Final := by
  haveI : (Opens.map φ.inv.base).IsEquivalence := (opensMapEquivOfIso φ).isEquivalence_functor
  infer_instance

/-- **Pullback along an iso of schemes sends the unit module to the unit module** (gap1, P1).

For an isomorphism of schemes `φ : Y ≅ Z`, the pullback functor along `φ.inv : Z ⟶ Y` carries the
structure-sheaf (unit) module of `Y` to that of `Z`. The underlying canonical comparison
`pullbackObjUnitToUnit` is an isomorphism because the site functor `Opens.map φ.inv.base` of an iso
of schemes is `Final` (`opensMap_final_of_schemeIso`). This is the `F.obj (unit R) ≅ unit S` datum
consumed by `Presentation.map` along `pullback φ.inv` in `presentationPullbackOfSchemeIso`.
Project-local. -/
noncomputable def pullbackSchemeIsoUnitIso {Y Z : Scheme.{u}} (φ : Y ≅ Z) :
    (Scheme.Modules.pullback φ.inv).obj (SheafOfModules.unit Y.ringCatSheaf) ≅
      SheafOfModules.unit Z.ringCatSheaf :=
  haveI := opensMap_final_of_schemeIso φ
  asIso (SheafOfModules.pullbackObjUnitToUnit (φ.inv.toRingCatSheafHom))

end Scheme.Modules

end BasicOpenPresentationDescent

end AlgebraicGeometry
