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
    (SheafOfModules.pullback (φ.inv.toRingCatSheafHom)).obj (SheafOfModules.unit Y.ringCatSheaf) ≅
      SheafOfModules.unit Z.ringCatSheaf := by
  haveI : (Opens.map φ.inv.base).Final := opensMap_final_of_schemeIso φ
  haveI : (SheafOfModules.pushforward (φ.inv.toRingCatSheafHom)).IsRightAdjoint := inferInstance
  exact asIso (SheafOfModules.pullbackObjUnitToUnit (φ.inv.toRingCatSheafHom))

set_option maxHeartbeats 2000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- **A presentation transports across the pullback by an iso of schemes** (gap1, P1, step 4).

Given an isomorphism of schemes `φ : Y ≅ Z` and a `SheafOfModules.Presentation` of a module `N` on
`Y`, the geometric pullback `(pullback φ.inv).obj N` of `N` to `Z` admits a presentation. It is
`Presentation.map` along the colimit-preserving pullback functor `pullback φ.inv`, using the unit-iso
`pullbackSchemeIsoUnitIso φ`. This is the affine-identification transport step of the gap1 keystone:
applied with `φ` the `IsAffineOpen.isoSpec` of the affine restriction, it moves the presentation onto
a genuine `Spec`. Project-local. -/
noncomputable def presentationPullbackOfSchemeIso {Y Z : Scheme.{u}} (φ : Y ≅ Z)
    (N : Y.Modules) (P : N.Presentation) :
    ((Scheme.Modules.pullback φ.inv).obj N).Presentation :=
  haveI : PreservesColimitsOfSize.{u, u, u, u, u + 1, u + 1} (Scheme.Modules.pullback φ.inv) :=
    (Scheme.Modules.pullbackPushforwardAdjunction φ.inv).leftAdjoint_preservesColimits
  SheafOfModules.Presentation.map.{u} P (Scheme.Modules.pullback φ.inv)
    (pullbackSchemeIsoUnitIso φ)

set_option maxHeartbeats 2000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- **Quasi-coherent restricts to a tilde on every affine open of a cover member** (gap1, P1).

For a sheaf of modules `M` on `X` with quasi-coherence data `q`, an index `i`, and an *affine* open
`W ⊆ (q.X i).toScheme` of the cover-member subscheme, the geometric restriction of `M` to the affine
`Spec Γ((q.X i).toScheme, W) ≅ W` (pulled back to `Z := (q.X i).toScheme`, then to `W`, then across
the affine identification `IsAffineOpen.isoSpec`) has an isomorphism `fromTildeΓ` counit — i.e. it is
a geometric tilde.

This is the geometric heart of the gap1 per-element transport: the slice presentation supplied by
the quasi-coherence datum geometrizes (`presentationPullbackιRestrict`) to a global presentation on
`W.toScheme`, which transports across the affine iso (`presentationPullbackOfSchemeIso`) to a global
presentation on the genuine affine `Spec Γ(Z, W)`; a global presentation forces `fromTildeΓ` to be an
isomorphism (`isIso_fromTildeΓ_of_presentation`). Project-local: Mathlib has no
`QCoh(Spec R) ≃ Mod R` essential-image bridge. -/
theorem isIso_fromTildeΓ_presentationPullback (M : X.Modules)
    (q : M.QuasicoherentData) (i : q.I)
    (W : (show X.Opens from q.X i).toScheme.Opens) (hW : IsAffineOpen W) :
    IsIso ((Scheme.Modules.pullback hW.isoSpec.inv).obj
      ((Scheme.Modules.pullback (Scheme.Opens.ι W)).obj
        ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj M))).fromTildeΓ :=
  isIso_fromTildeΓ_of_presentation _
    (presentationPullbackOfSchemeIso hW.isoSpec
      ((Scheme.Modules.pullback (Scheme.Opens.ι W)).obj
        ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj M))
      (presentationPullbackιRestrict M q i W))

set_option maxHeartbeats 2000000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option backward.isDefEq.respectTransparency false in
/-- **Quasi-coherent restricts to a tilde on each basic open of the cover** (gap1, P1 keystone,
`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`).

Let `M` be a sheaf of modules on `Spec R` with quasi-coherence data `q`, and let `r : R` with
`D(r) ≤ q.X i` for some cover member. Then the geometric restriction of `M` to the affine basic open
`D(r)` — realised as the preimage `W := (q.X i).ι ⁻¹ᵁ D(r)` inside the cover-member subscheme
`Z := (q.X i).toScheme`, transported across the affine identification `W ≅ Spec Γ(Z, W)` (which is
`Spec R_r` since `D(r)` is affine) — has an isomorphism `fromTildeΓ` counit, i.e. `M|_{D(r)}` is a
geometric tilde.

This is the per-element step of gap1: it is the affine instance `W = (q.X i).ι ⁻¹ᵁ D(r)` of
`isIso_fromTildeΓ_presentationPullback`, with affineness of `W` from
`IsAffineOpen.Spec_basicOpen` (`D(r)` is affine in `Spec R`) and
`IsAffineOpen.preimage_of_isOpenImmersion` (its preimage under the open immersion `(q.X i).ι` is
affine, using `D(r) ≤ q.X i = (q.X i).ι.opensRange`). Project-local. -/
theorem isIso_fromTildeΓ_restrict_basicOpen {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (r : R) (i : q.I)
    (hr : (PrimeSpectrum.basicOpen r : (Spec R).Opens) ≤ q.X i) :
    IsIso (@Scheme.Modules.fromTildeΓ
      (Γ(↑(q.X i), (Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen r)))
      ((Scheme.Modules.pullback
          (((IsAffineOpen.Spec_basicOpen r).preimage_of_isOpenImmersion (Scheme.Opens.ι (q.X i))
            (by rw [Scheme.Opens.opensRange_ι]; exact hr)).isoSpec.inv)).obj
        ((Scheme.Modules.pullback (Scheme.Opens.ι
            ((Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen r)))).obj
          ((Scheme.Modules.pullback (Scheme.Opens.ι (q.X i))).obj M)))) :=
  isIso_fromTildeΓ_presentationPullback M q i
    ((Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen r))
    ((IsAffineOpen.Spec_basicOpen r).preimage_of_isOpenImmersion (Scheme.Opens.ι (q.X i))
      (by rw [Scheme.Opens.opensRange_ι]; exact hr))

/-! ## Project-local Mathlib supplement — gap1-D: the section-localization descent

The keystone `isLocalizedModule_basicOpen_descent` reduces (Hartshorne II.5.3 / Stacks
`lemma-invert-f-sections`) to a finite-cover sheaf-gluing argument.  The single geometric input
is the **per-cover-element** fact that on each `D(r)` of a finite cover `{D(r_j)}` of `Spec R`
(with `D(r_j) ≤ q.X i`), the basic-open restriction `Γ(M, D(r)) → Γ(M, D(f) ⊓ D(r))` is a
localization at `powers f` — this is exactly the P1 local-tilde data transported to sections, and
is the gated hypothesis `Hfr` below.  Given `Hfr` (for every `r` whose `D(r)` sits inside a cover
member, hence also for the overlaps `D(r r')`), the descent is pure sheaf theory: separatedness
gives the `exists_of_eq` field, gluing the patched compatible family gives `surj'`, and the global
`map_units` field holds for arbitrary `M` (`map_units_restrict_basicOpen`). -/

/-- A finite family `t` spanning `R` gives a basic-open cover of `Spec R`: the supremum of the
`D(r)` over `r ∈ t` is `⊤`.  Project-local glue feeding the sheaf-gluing reduction of the
section-localization descent. -/
private lemma iSup_basicOpen_subtype_eq_top {R : CommRingCat.{u}} {t : Finset R}
    (hspan : Ideal.span (t : Set R) = ⊤) :
    (⨆ r : {x // x ∈ t}, (PrimeSpectrum.basicOpen (r : R) : (Spec R).Opens)) = ⊤ := by
  rw [iSup_subtype]
  have h := (PrimeSpectrum.iSup_basicOpen_eq_top_iff' (s := (t : Set R))).mpr hspan
  simpa using h

/-- Restriction maps of `modulesSpecToSheaf.obj M` compose: restricting `A → B → C` equals the
direct restriction `A → C`.  Poset-hom uniqueness makes the two intermediate morphisms compose to
the direct one.  Project-local bookkeeping for the section-localization descent. -/
private lemma res_comp {R : CommRingCat.{u}}
    (F : TopCat.Sheaf (ModuleCat.{u} ↑R) ↑(Spec R).toPresheafedSpace)
    {A B C : (Spec R).Opens} (hBA : B ≤ A) (hCB : C ≤ B) (hCA : C ≤ A)
    (y : ToType (F.presheaf.obj (.op A))) :
    (F.presheaf.map (homOfLE hCB).op).hom ((F.presheaf.map (homOfLE hBA).op).hom y)
      = (F.presheaf.map (homOfLE hCA).op).hom y := by
  rw [← ModuleCat.comp_apply, ← Functor.map_comp, ← op_comp]; rfl

/-- **Separatedness/torsion field of the section-localization descent.**  Given the
per-cover-element localization data `Hfr` (on each `D(r)` of a finite basic-open cover `{D(r)}` of
`Spec R`, the restriction `Γ(M, D(r)) → Γ(M, D(f) ⊓ D(r))` is a localization at `powers f`), any
global section `x` that restricts to `0` on `D(f)` is killed by a power of `f`.  This is the
`exists_of_eq` engine of `isLocalizedModule_basicOpen_descent`: per cover element a power of `f`
kills `x|_{D(r)}` (`IsLocalizedModule.exists_of_eq` of `Hfr`), the finite sup of these powers kills
every `x|_{D(r)}`, and sheaf separatedness over the cover (`TopCat.Sheaf.eq_of_locally_eq'`) lifts
this to `f^n • x = 0`.  Project-local: the geometric content (`Hfr`) is the gated P1 tilde data. -/
private lemma descent_smul_eq_zero {R : CommRingCat.{u}} (M : (Spec R).Modules) (f : R)
    (t : Finset R) (hspan : Ideal.span (t : Set R) = ⊤)
    (Hfr : ∀ r ∈ t, IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right :
          PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen r)).op).hom)
    (x : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op ⊤)))
    (hx : ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x = 0) :
    ∃ n : ℕ, f ^ n • x = 0 := by
  classical
  have key : ∀ r : {x // x ∈ t}, ∃ k : ℕ, f ^ k •
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom x = 0 := by
    rintro ⟨r, hr⟩
    have e1 := res_comp (modulesSpecToSheaf.obj M)
        (A := ⊤) (B := PrimeSpectrum.basicOpen r)
        (C := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r) le_top inf_le_right le_top x
    have e2 := res_comp (modulesSpecToSheaf.obj M)
        (A := ⊤) (B := PrimeSpectrum.basicOpen f)
        (C := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r) le_top inf_le_left le_top x
    have hzero := e1.trans (e2.symm.trans
      ((congrArg (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left :
            PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
              ≤ PrimeSpectrum.basicOpen f)).op).hom) hx).trans
        (map_zero _)))
    obtain ⟨c, hc⟩ := (Hfr r hr).exists_of_eq (hzero.trans (map_zero _).symm)
    obtain ⟨k, hk⟩ := c.2
    have hk' : f ^ k = (c : R) := hk
    refine ⟨k, ?_⟩
    have h2 : c • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom x) = 0 :=
      hc.trans (smul_zero c)
    rw [hk']; exact h2
  choose k hk using key
  refine ⟨Finset.univ.sup k, ?_⟩
  refine TopCat.Sheaf.eq_of_locally_eq' (modulesSpecToSheaf.obj M)
    (fun r : {x // x ∈ t} => (PrimeSpectrum.basicOpen (r:R) : (Spec R).Opens)) ⊤
    (fun r => homOfLE le_top) (le_of_eq (iSup_basicOpen_subtype_eq_top hspan).symm)
    (f ^ Finset.univ.sup k • x) 0 ?_
  intro r
  have hle : k r ≤ Finset.univ.sup k := Finset.le_sup (Finset.mem_univ r)
  set g := ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom with hg
  have hms : g (f ^ Finset.univ.sup k • x) = f ^ Finset.univ.sup k • g x := LinearMap.map_smul g _ x
  have hsplit : f ^ Finset.univ.sup k • g x
      = f ^ (Finset.univ.sup k - k r) • (f ^ (k r) • g x) := by
    rw [← mul_smul, ← pow_add, Nat.sub_add_cancel hle]
  have hzero : g (f ^ Finset.univ.sup k • x) = 0 :=
    hms.trans (hsplit.trans ((congrArg (fun y => f ^ (Finset.univ.sup k - k r) • y) (hk r)).trans
      (smul_zero _)))
  change g (f ^ Finset.univ.sup k • x) = g 0
  rw [hzero, map_zero]

/-- **Overlap agreement for the surjectivity field.**  If a section `br` on `D(r)` satisfies the
normalized identity `ρ[D(r), D(f) ⊓ D(r)] br = f^N • (y|_{D(f) ⊓ D(r)})`, then for any open
`U ≤ D(r)` its restriction to `U`, pushed down to `D(f) ⊓ U`, equals `f^N • (y|_{D(f) ⊓ U})`.
Specializing `U` to an overlap `D(r) ⊓ D(r')` shows the normalized sections of two cover members
agree there after restriction to `D(f) ⊓ (D(r) ⊓ D(r'))`, which (via the per-overlap localization)
makes a common `f`-power glue them.  Project-local bookkeeping for `descent_surj`. -/
private lemma descent_overlap_agree {R : CommRingCat.{u}} (M : (Spec R).Modules) (f : R) (r : R)
    (N : ℕ) (U : (Spec R).Opens) (hUr : U ≤ PrimeSpectrum.basicOpen r)
    (y : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op (PrimeSpectrum.basicOpen f))))
    (br : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op (PrimeSpectrum.basicOpen r))))
    (hbr : ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen r)).op).hom br
        = f ^ N • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen f)).op).hom y)) :
    ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ U ≤ U)).op).hom
      (((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hUr).op).hom br)
    = f ^ N • (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ U
          ≤ PrimeSpectrum.basicOpen f)).op).hom y) := by
  have hCB : PrimeSpectrum.basicOpen f ⊓ U
      ≤ PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r := inf_le_inf_left _ hUr
  have e1 := res_comp (modulesSpecToSheaf.obj M)
      (A := PrimeSpectrum.basicOpen r) (B := U) (C := PrimeSpectrum.basicOpen f ⊓ U)
      hUr inf_le_right (inf_le_right.trans hUr) br
  have e2 := res_comp (modulesSpecToSheaf.obj M) (A := PrimeSpectrum.basicOpen r)
      (B := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r)
      (C := PrimeSpectrum.basicOpen f ⊓ U) inf_le_right hCB (inf_le_right.trans hUr) br
  have e3 := res_comp (modulesSpecToSheaf.obj M) (A := PrimeSpectrum.basicOpen f)
      (B := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r)
      (C := PrimeSpectrum.basicOpen f ⊓ U) inf_le_left hCB inf_le_left y
  have hms := LinearMap.map_smul ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hCB).op).hom
      (f ^ N) (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
          ≤ PrimeSpectrum.basicOpen f)).op).hom y)
  exact e1.trans (e2.symm.trans ((congrArg _ hbr).trans (hms.trans (congrArg (f ^ N • ·) e3))))

/-- **Surjectivity field of the section-localization descent.**  With the per-cover-element (and
per-overlap) localization data `Hfr`, every section `y` over `D(f)` becomes, after multiplying by a
power of `f`, the restriction of a global section.  The classical Hartshorne II.5.3 argument: each
`D(r)` of a finite basic-open cover `{D(r)}` of `Spec R`, `y|_{D(f) ⊓ D(r)}` is `f^{-N}` times the
restriction of a section `b_r` on `D(r)` (`IsLocalizedModule.surj` of `Hfr` at `D(r)`, with a common
power `N`); on overlaps the `b_r` agree after a further power `f^P` (`descent_overlap_agree` +
`IsLocalizedModule.exists_of_eq` of `Hfr` at `D(r) ⊓ D(r')`), so `f^P • b_r` glue
(`TopCat.Sheaf.existsUnique_gluing'`) to a global `x` with `x|_{D(f)} = f^{N+P} • y` (by sheaf
separatedness over the cover `{D(f) ⊓ D(r)}` of `D(f)`).  Project-local: `Hfr` is the gated P1
local-tilde data. -/
private lemma descent_surj {R : CommRingCat.{u}} (M : (Spec R).Modules) (f : R)
    (t : Finset R) (hspan : Ideal.span (t : Set R) = ⊤)
    (Hfr : ∀ U : (Spec R).Opens, (∃ s : R, U = PrimeSpectrum.basicOpen s) →
      (∃ r ∈ t, U ≤ PrimeSpectrum.basicOpen r) →
      IsLocalizedModule (Submonoid.powers f)
        ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ U ≤ U)).op).hom)
    (y : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op (PrimeSpectrum.basicOpen f)))) :
    ∃ (x : ToType ((modulesSpecToSheaf.obj M).presheaf.obj (.op ⊤))) (n : ℕ),
      f ^ n • y = ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x := by
  classical
  -- Stage 1: per cover element a section `a r` and a power `m r`.
  have perr : ∀ r : {x // x ∈ t}, ∃ (a : ToType ((modulesSpecToSheaf.obj M).presheaf.obj
        (.op (PrimeSpectrum.basicOpen (r:R))))) (m : ℕ),
        f ^ m • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
            ≤ PrimeSpectrum.basicOpen f)).op).hom y)
        = ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
            ≤ PrimeSpectrum.basicOpen (r:R))).op).hom a := by
    rintro ⟨r, hr⟩
    have hloc := Hfr (PrimeSpectrum.basicOpen r) ⟨r, rfl⟩ ⟨r, hr, le_refl _⟩
    obtain ⟨⟨a, s⟩, hs⟩ := hloc.surj (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen f)).op).hom y)
    obtain ⟨m, hm⟩ := s.2
    refine ⟨a, m, ?_⟩
    have hsR : (s : R) • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen f)).op).hom y)
        = ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen r
            ≤ PrimeSpectrum.basicOpen r)).op).hom a := hs
    rw [← hm] at hsR; exact hsR
  choose a m hm using perr
  -- Stage 2: common power N and normalized sections b r := f^(N - m r) • a r.
  set N := Finset.univ.sup m with hN
  have hb : ∀ r : {x // x ∈ t},
      ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
            ≤ PrimeSpectrum.basicOpen (r:R))).op).hom (f ^ (N - m r) • a r)
        = f ^ N • (((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
            ≤ PrimeSpectrum.basicOpen f)).op).hom y) := by
    intro r
    have hle : m r ≤ N := Finset.le_sup (Finset.mem_univ r)
    set g := ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
            ≤ PrimeSpectrum.basicOpen (r:R))).op).hom with hg
    have hms : g (f ^ (N - m r) • a r) = f ^ (N - m r) • g (a r) := LinearMap.map_smul g _ (a r)
    rw [hms, ← hm r, ← mul_smul, ← pow_add, Nat.sub_add_cancel hle]
  -- Stage 3: overlaps — common further power exists pairwise.
  have hover : ∀ i j : {x // x ∈ t}, ∃ p : ℕ,
      f ^ p • ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (i:R))).op).hom (f ^ (N - m i) • a i)
      = f ^ p • ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (j:R))).op).hom (f ^ (N - m j) • a j) := by
    intro i j
    have ai := descent_overlap_agree M f i N
      (PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)) inf_le_left y _ (hb i)
    have aj := descent_overlap_agree M f j N
      (PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)) inf_le_right y _ (hb j)
    have hloc := Hfr (PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R))
      ⟨(i:R) * (j:R), (PrimeSpectrum.basicOpen_mul (i:R) (j:R)).symm⟩ ⟨i, i.2, inf_le_left⟩
    obtain ⟨c, hc⟩ := hloc.exists_of_eq (ai.trans aj.symm)
    obtain ⟨p, hp⟩ := c.2
    have hp' : f ^ p = (c : R) := hp
    exact ⟨p, by rw [hp']; exact hc⟩
  choose p hp using hover
  -- Stage 4: global further power P, glue the compatible family.
  set P := Finset.univ.sup (fun i => Finset.univ.sup (fun j => p i j)) with hP
  have hPle : ∀ i j : {x // x ∈ t}, p i j ≤ P := fun i j =>
    le_trans (Finset.le_sup (f := fun j => p i j) (Finset.mem_univ j))
      (Finset.le_sup (f := fun i => Finset.univ.sup (fun j => p i j)) (Finset.mem_univ i))
  have hcompat : TopCat.Presheaf.IsCompatible (modulesSpecToSheaf.obj M).presheaf
      (fun r : {x // x ∈ t} => (PrimeSpectrum.basicOpen (r:R) : (Spec R).Opens))
      (fun r => f ^ P • (f ^ (N - m r) • a r)) := by
    intro i j
    change ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (i:R))).op).hom (f ^ P • (f ^ (N - m i) • a i))
      = ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (j:R))).op).hom (f ^ P • (f ^ (N - m j) • a j))
    have ms_i := LinearMap.map_smul ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (i:R))).op).hom (f ^ P) (f ^ (N - m i) • a i)
    have ms_j := LinearMap.map_smul ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (j:R))).op).hom (f ^ P) (f ^ (N - m j) • a j)
    have X : f ^ P • ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (i:R))).op).hom (f ^ (N - m i) • a i)
      = f ^ P • ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen (i:R) ⊓ PrimeSpectrum.basicOpen (j:R)
          ≤ PrimeSpectrum.basicOpen (j:R))).op).hom (f ^ (N - m j) • a j) := by
      rw [← Nat.sub_add_cancel (hPle i j), pow_add, mul_smul, mul_smul, hp i j]
    exact ms_i.trans (X.trans ms_j.symm)
  obtain ⟨x, hx, -⟩ := TopCat.Sheaf.existsUnique_gluing' (modulesSpecToSheaf.obj M)
    (fun r : {x // x ∈ t} => (PrimeSpectrum.basicOpen (r:R) : (Spec R).Opens)) ⊤
    (fun r => homOfLE le_top) (le_of_eq (iSup_basicOpen_subtype_eq_top hspan).symm)
    (fun r => f ^ P • (f ^ (N - m r) • a r)) hcompat
  -- Stage 5: x|_{D(f)} = f^(N+P) • y, by separatedness over the cover {D(f) ⊓ D(r)} of D(f).
  refine ⟨x, P + N, ?_⟩
  have hcoverDf : (PrimeSpectrum.basicOpen f : (Spec R).Opens)
      ≤ ⨆ r : {x // x ∈ t}, (PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)) := by
    rw [← inf_iSup_eq, iSup_basicOpen_subtype_eq_top hspan, inf_top_eq]
  refine TopCat.Sheaf.eq_of_locally_eq' (modulesSpecToSheaf.obj M)
    (fun r : {x // x ∈ t} => (PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)))
    (PrimeSpectrum.basicOpen f) (fun r => homOfLE inf_le_left) hcoverDf
    (f ^ (P + N) • y)
    (((modulesSpecToSheaf.obj M).presheaf.map
      (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x) ?_
  intro r
  -- LHS = f^(N+P) • (y|_{D(f) ⊓ D(r)})
  change ((modulesSpecToSheaf.obj M).presheaf.map
      (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
        ≤ PrimeSpectrum.basicOpen f)).op).hom (f ^ (P + N) • y)
    = ((modulesSpecToSheaf.obj M).presheaf.map
      (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
        ≤ PrimeSpectrum.basicOpen f)).op).hom
      (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x)
  -- compute the right-hand side via x|_{D(r)} = f^P • b r
  have ex := res_comp (modulesSpecToSheaf.obj M) (A := ⊤) (B := PrimeSpectrum.basicOpen f)
      (C := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R))
      le_top inf_le_left le_top x
  have ex2 := res_comp (modulesSpecToSheaf.obj M) (A := ⊤) (B := PrimeSpectrum.basicOpen (r:R))
      (C := PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R))
      le_top inf_le_right le_top x
  have hxr : ((modulesSpecToSheaf.obj M).presheaf.map
      (homOfLE (le_top : PrimeSpectrum.basicOpen (r:R) ≤ ⊤)).op).hom x
      = f ^ P • (f ^ (N - m r) • a r) := hx r
  -- ρ[D(f),Dfr] (x|_{D(f)}) = ρ[⊤,Dfr] x = ρ[D(r),Dfr] (x|_{D(r)}) = ρ[D(r),Dfr] (f^P • b r)
  have hRHS : ((modulesSpecToSheaf.obj M).presheaf.map
      (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
        ≤ PrimeSpectrum.basicOpen f)).op).hom
      (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom x)
    = f ^ (P + N) • (((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_left : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen (r:R)
          ≤ PrimeSpectrum.basicOpen f)).op).hom y) :=
    ex.trans (ex2.symm.trans ((congrArg _ hxr).trans
      ((LinearMap.map_smul _ (f ^ P) (f ^ (N - m r) • a r)).trans
        ((congrArg (f ^ P • ·) (hb r)).trans
          ((mul_smul (f ^ P) (f ^ N) _).symm.trans (congrArg (· • _) (pow_add f P N).symm))))))
  exact (LinearMap.map_smul _ (f ^ (P + N)) y).trans hRHS.symm

/-- **Section-localization descent from a local-tilde cover (gap1 keystone, D), cover form.**  Let
`M` be a sheaf of modules on `Spec R` and `f : R`.  Suppose `{D(r)}_{r ∈ t}` is a finite basic-open
cover of `Spec R` (`Ideal.span t = ⊤`) and for every open `U` contained in some cover member `D(r)`
(in particular each `D(r)` and each overlap `D(r) ⊓ D(r')`) the basic-open restriction
`Γ(M, U) → Γ(M, D(f) ⊓ U)` is a localization at `powers f` (`Hfr` — the gated P1 local-tilde data).
Then the section restriction `Γ(M, ⊤) → Γ(M, D(f))` is `IsLocalizedModule (powers f)` over `R`.

This is the project-internal finite-equalizer/flatness descent of Stacks `lemma-invert-f-sections`
(Hartshorne II.5.3), built without the global affine `QCoh(Spec R) ≃ Mod R` equivalence (which is
gap1 itself): `map_units` holds for arbitrary `M` (`map_units_restrict_basicOpen`), `surj'` is
`descent_surj`, and `exists_of_eq` is `descent_smul_eq_zero`.  The named gap1 keystone
`isLocalizedModule_basicOpen_descent` for quasi-coherent `M` is this lemma instantiated at the cover
`exists_finite_basicOpen_cover_le_quasicoherentData` once `Hfr` is produced from
`isIso_fromTildeΓ_restrict_basicOpen` (the slice→Spec-`R_r` section transport, the remaining gated
step).  Project-local. -/
theorem isLocalizedModule_basicOpen_descent_of_cover {R : CommRingCat.{u}} (M : (Spec R).Modules)
    (f : R) (t : Finset R) (hspan : Ideal.span (t : Set R) = ⊤)
    (Hfr : ∀ U : (Spec R).Opens, (∃ r ∈ t, U ≤ PrimeSpectrum.basicOpen r) →
      IsLocalizedModule (Submonoid.powers f)
        ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ U ≤ U)).op).hom) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom where
  map_units := map_units_restrict_basicOpen M f
  surj y := by
    obtain ⟨x, n, hxn⟩ := descent_surj M f t hspan (fun U _ hcov => Hfr U hcov) y
    exact ⟨⟨x, ⟨f ^ n, n, rfl⟩⟩, hxn⟩
  exists_of_eq {x₁ x₂} h := by
    have hθ : ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom (x₁ - x₂) = 0 := by
      rw [map_sub, h, sub_self]
    obtain ⟨n, hn⟩ := descent_smul_eq_zero M f t hspan
      (fun r hr => Hfr (PrimeSpectrum.basicOpen r) ⟨r, hr, le_refl _⟩) (x₁ - x₂) hθ
    exact ⟨⟨f ^ n, n, rfl⟩, sub_eq_zero.mp ((smul_sub (f ^ n) x₁ x₂).symm.trans hn)⟩

/-- **Section-localization descent from a local-tilde cover, basic-open hypothesis form.**

Same conclusion as `isLocalizedModule_basicOpen_descent_of_cover`, but the per-cover-element
localization data `Hfr` need only be supplied for *basic* opens `D(s) ≤ D(r)` (rather than every
open `U ≤ D(r)`).  This is the **instantiable** form of the cover-descent: the per-element P1
transport produces a localization only on the basic opens of the affine slice `Spec R_r` — a general
open of `Spec R_r` need not be quasi-compact, so the global Stacks `lemma-invert-f-sections` is
unavailable for it — while the sheaf-gluing engines `descent_surj`/`descent_smul_eq_zero` only ever
consult `Hfr` at the basic opens `D(r)` and the overlaps `D(r) ⊓ D(r') = D(r·r')`.

It rebuilds the three `IsLocalizedModule` fields directly: `map_units` is
`map_units_restrict_basicOpen` (holds for arbitrary `M`), `surj` is `descent_surj` fed the basic-open
`Hfr` (the open `U` it consults is always `D(s)`, so `Hfr s` supplies the datum after `U = D(s)` is
substituted), and `exists_of_eq` is `descent_smul_eq_zero` fed `Hfr` at each `D(r)`.  Project-local:
the named gap1 keystone `isLocalizedModule_basicOpen_descent` for quasi-coherent `M` is this lemma
instantiated at the cover `exists_finite_basicOpen_cover_le_quasicoherentData`, with the basic-open
`Hfr` produced from the P1 transport `isIso_fromTildeΓ_restrict_basicOpen`. -/
theorem isLocalizedModule_basicOpen_descent_of_basicOpen_cover {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (f : R) (t : Finset R) (hspan : Ideal.span (t : Set R) = ⊤)
    (Hfr : ∀ s : R, (∃ r ∈ t, (PrimeSpectrum.basicOpen s : (Spec R).Opens)
        ≤ PrimeSpectrum.basicOpen r) →
      IsLocalizedModule (Submonoid.powers f)
        ((modulesSpecToSheaf.obj M).presheaf.map
          (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s
            ≤ PrimeSpectrum.basicOpen s)).op).hom) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom where
  map_units := map_units_restrict_basicOpen M f
  surj y := by
    obtain ⟨x, n, hxn⟩ := descent_surj M f t hspan
      (fun U hbo hcov => by obtain ⟨s, rfl⟩ := hbo; exact Hfr s hcov) y
    exact ⟨⟨x, ⟨f ^ n, n, rfl⟩⟩, hxn⟩
  exists_of_eq {x₁ x₂} h := by
    have hθ : ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom (x₁ - x₂) = 0 := by
      rw [map_sub, h, sub_self]
    obtain ⟨n, hn⟩ := descent_smul_eq_zero M f t hspan
      (fun r hr => Hfr r ⟨r, hr, le_refl _⟩) (x₁ - x₂) hθ
    exact ⟨⟨f ^ n, n, rfl⟩, sub_eq_zero.mp ((smul_sub (f ^ n) x₁ x₂).symm.trans hn)⟩

/-! ## Project-local Mathlib supplement — `IsLocalizedModule` transport for gap1-D Hfr

The section-transport iso `gammaPullbackImageIso` is only an additive-group (`Ab`) isomorphism,
semilinear over the *source-scheme* section ring, whereas the `Hfr` hypothesis of
`isLocalizedModule_basicOpen_descent_of_cover` is an `IsLocalizedModule` statement `R`-linear over
the base ring `R`. Two Mathlib-absent transport ingredients bridge the gap:

* **(I)** `isLocalizedModule_of_ringEquiv_semilinear` — transport `IsLocalizedModule S g` across a
  ring-iso-`σ`-semilinear `AddEquiv` pair. Mathlib only has the same-ring `of_linearEquiv` /
  `of_linearEquiv_right`; the section iso crosses a ring iso, so this is the genuine gap.
* **(II)** `isLocalizedModule_restrictScalars_powers_algebraMap` — a localization at
  `powers (algebraMap R Rr f)` over a base-changed ring `Rr` (here `R` localized at `r`) is, after
  restriction of scalars, a localization at `powers f` over `R`.

Both are pure module algebra and Mathlib-absent at the pinned commit; project-bespoke. -/

/-- **(I) Ring-iso-semilinear `IsLocalizedModule` transport.** Given a ring isomorphism
`σ : R ≃+* R'`, two `σ`-semilinear additive isomorphisms `e₁ : M₁ ≃+ N₁`, `e₂ : M₂ ≃+ N₂` (i.e.
`eᵢ (a • x) = σ a • eᵢ x`), and an `R'`-linear map `h : N₁ →ₗ[R'] N₂` intertwining a localization
map `g` with the `eᵢ` (`h (e₁ x) = e₂ (g x)`), the map `h` is a localization at the image submonoid
`S.map σ`. Mathlib only provides the same-ring `IsLocalizedModule.of_linearEquiv`; this crosses a
ring iso, the form needed to turn the `Ab`/semilinear section iso `gammaPullbackImageIso` into the
`R`-linear `Hfr` data. Project-local. -/
theorem isLocalizedModule_of_ringEquiv_semilinear
    {R R' : Type*} [CommRing R] [CommRing R'] (σ : R ≃+* R')
    {M₁ M₂ N₁ N₂ : Type*}
    [AddCommGroup M₁] [Module R M₁] [AddCommGroup M₂] [Module R M₂]
    [AddCommGroup N₁] [Module R' N₁] [AddCommGroup N₂] [Module R' N₂]
    (S : Submonoid R)
    (g : M₁ →ₗ[R] M₂) [IsLocalizedModule S g]
    (e₁ : M₁ ≃+ N₁) (e₂ : M₂ ≃+ N₂)
    (he₁ : ∀ (a : R) (x : M₁), e₁ (a • x) = σ a • e₁ x)
    (he₂ : ∀ (a : R) (x : M₂), e₂ (a • x) = σ a • e₂ x)
    (h : N₁ →ₗ[R'] N₂)
    (hh : ∀ x, h (e₁ x) = e₂ (g x)) :
    IsLocalizedModule (S.map (σ : R →+* R')) h where
  map_units x := by
    obtain ⟨s, hs, hsx⟩ := x.2
    rw [Module.End.isUnit_iff]
    have hsrc := IsLocalizedModule.map_units g ⟨s, hs⟩
    rw [Module.End.isUnit_iff] at hsrc
    have hfun : (⇑(algebraMap R' (Module.End R' N₂) (↑x : R')))
        = ⇑e₂ ∘ ⇑(algebraMap R (Module.End R M₂) (⟨s, hs⟩ : S)) ∘ ⇑e₂.symm := by
      funext y
      rw [Module.algebraMap_end_apply, Function.comp_apply, Function.comp_apply,
        Module.algebraMap_end_apply, he₂, e₂.apply_symm_apply]
      congr 1
      exact hsx.symm
    rw [hfun]
    exact e₂.bijective.comp (hsrc.comp e₂.symm.bijective)
  surj y := by
    obtain ⟨⟨x, s⟩, hx⟩ := IsLocalizedModule.surj S g (e₂.symm y)
    refine ⟨⟨e₁ x, ⟨σ ↑s, ↑s, s.2, rfl⟩⟩, ?_⟩
    have he : e₂ ((↑s : R) • e₂.symm y) = e₂ (g x) := congrArg e₂ hx
    rw [he₂, e₂.apply_symm_apply, ← hh] at he
    exact he
  exists_of_eq {y₁ y₂} heq := by
    have h1 : e₂ (g (e₁.symm y₁)) = e₂ (g (e₁.symm y₂)) := by
      rw [← hh, ← hh, e₁.apply_symm_apply, e₁.apply_symm_apply]; exact heq
    obtain ⟨c, hc⟩ := IsLocalizedModule.exists_of_eq (S := S) (f := g) (e₂.injective h1)
    refine ⟨⟨σ ↑c, ↑c, c.2, rfl⟩, ?_⟩
    have hc' : (↑c : R) • e₁.symm y₁ = (↑c : R) • e₁.symm y₂ := hc
    have hcc := congrArg e₁ hc'
    rw [he₁, he₁, e₁.apply_symm_apply, e₁.apply_symm_apply] at hcc
    exact hcc

/-- **(II) Localization at a base-changed submonoid descends to the base ring.** If `g` is
`Rr`-linear and exhibits a localization at `powers (algebraMap R Rr f)` over a base-changed ring
`Rr` (an algebra over `R` — here `R` localized at some `r`), then its restriction of scalars to `R`
is a localization
at `powers f` over `R`. This lets the `R_r`-level localization that P1 (`IsIso fromTildeΓ`) produces
on the slice `Spec R_r` be read back as the `R`-level `Hfr` data the cover-form descent consumes.
Mathlib-absent; project-local. -/
theorem isLocalizedModule_restrictScalars_powers_algebraMap
    {R Rr : Type*} [CommRing R] [CommRing Rr] [Algebra R Rr]
    {M₁ M₂ : Type*} [AddCommGroup M₁] [Module R M₁] [Module Rr M₁] [IsScalarTower R Rr M₁]
    [AddCommGroup M₂] [Module R M₂] [Module Rr M₂] [IsScalarTower R Rr M₂]
    (f : R) (g : M₁ →ₗ[Rr] M₂)
    [IsLocalizedModule (Submonoid.powers (algebraMap R Rr f)) g] :
    IsLocalizedModule (Submonoid.powers f) (g.restrictScalars R) where
  map_units x := by
    obtain ⟨n, hn⟩ := x.2
    have hn' : f ^ n = ↑x := hn
    rw [Module.End.isUnit_iff]
    have hmem : (algebraMap R Rr f) ^ n ∈ Submonoid.powers (algebraMap R Rr f) := ⟨n, rfl⟩
    have hsrc := IsLocalizedModule.map_units g ⟨_, hmem⟩
    rw [Module.End.isUnit_iff] at hsrc
    have hfun : ⇑(algebraMap R (Module.End R M₂) (↑x : R))
        = ⇑(algebraMap Rr (Module.End Rr M₂) ((algebraMap R Rr f) ^ n)) := by
      funext z
      rw [Module.algebraMap_end_apply, Module.algebraMap_end_apply, ← hn', ← map_pow,
        algebraMap_smul]
    rw [hfun]; exact hsrc
  surj y := by
    obtain ⟨⟨x, s⟩, hx⟩ := IsLocalizedModule.surj (Submonoid.powers (algebraMap R Rr f)) g y
    obtain ⟨n, hn⟩ := s.2
    have hn' : (algebraMap R Rr f) ^ n = ↑s := hn
    refine ⟨⟨x, ⟨f ^ n, n, rfl⟩⟩, ?_⟩
    have hsmul : (f ^ n : R) • y = (↑s : Rr) • y := by
      rw [← hn', ← map_pow, algebraMap_smul]
    change (f ^ n : R) • y = (g.restrictScalars R) x
    rw [hsmul, LinearMap.coe_restrictScalars]; exact hx
  exists_of_eq {x₁ x₂} heq := by
    obtain ⟨c, hc⟩ := IsLocalizedModule.exists_of_eq (S := Submonoid.powers (algebraMap R Rr f))
      (f := g) heq
    obtain ⟨n, hn⟩ := c.2
    have hn' : (algebraMap R Rr f) ^ n = ↑c := hn
    refine ⟨⟨f ^ n, n, rfl⟩, ?_⟩
    have e1 : (f ^ n : R) • x₁ = (↑c : Rr) • x₁ := by rw [← hn', ← map_pow, algebraMap_smul]
    have e2 : (f ^ n : R) • x₂ = (↑c : Rr) • x₂ := by rw [← hn', ← map_pow, algebraMap_smul]
    change (f ^ n : R) • x₁ = (f ^ n : R) • x₂
    rw [e1, e2]; exact hc

/-! ## Project-local Mathlib supplement — gap1-D Hfr: pullback-section transport

The remaining gated ingredient of the named gap1 keystone
`isLocalizedModule_basicOpen_descent` is the **section-level** analogue of P1's object-level
transport: for an open immersion `f : X ⟶ Y` and a sheaf of modules `M` on `Y`, the sections of the
geometric pullback `(pullback f).obj M` over an open `U ⊆ X` are canonically identified with the
sections of `M` over the image `f ''ᵁ U`.

The construction is `Γ(-, U)` applied to the inverse of Mathlib's `restrictFunctorIsoPullback f`
(`restrictFunctor f ≅ pullback f`) at `M`, using the *definitional* identity
`Γ((restrictFunctor f).obj M, U) = Γ(M, f ''ᵁ U)` (`Scheme.Modules.restrict_obj`, `rfl`). Because
both sides are `Γ(-, U)` of a single fixed module isomorphism, naturality in `U` (intertwining the
presheaf restriction maps) is free: it is the naturality of the underlying abelian-presheaf
morphism. Mathlib-absent at the pinned commit; project-bespoke. -/

/-- **Global sections of a pullback along an open immersion are sections over the image**
(gap1, Hfr section transport, general open). For an open immersion `f : X ⟶ Y`, a sheaf of modules
`M` on `Y`, and an open `U ⊆ X`, the additive groups of sections satisfy
`Γ((pullback f).obj M, U) ≅ Γ(M, f ''ᵁ U)`. This is `Γ(-, U)` of `(restrictFunctorIsoPullback f)⁻¹`
at `M`; the codomain is `Γ((restrictFunctor f).obj M, U) = Γ(M, f ''ᵁ U)` definitionally. Naturality
in `U` is `gammaPullbackImageIso_hom_naturality`. -/
noncomputable def gammaPullbackImageIso {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f]
    (M : Y.Modules) (U : X.Opens) :
    Γ((Scheme.Modules.pullback f).obj M, U) ≅ Γ(M, f ''ᵁ U) :=
  (Scheme.Modules.toPresheaf X ⋙ (CategoryTheory.evaluation _ _).obj (Opposite.op U)).mapIso
    ((Scheme.Modules.restrictFunctorIsoPullback f).symm.app M)

/-- **The pullback-section comparison intertwines the restriction maps** (gap1, Hfr, naturality).
For opens `V ≤ U` of `X`, `gammaPullbackImageIso` commutes with the presheaf restriction maps of
`(pullback f).obj M` and of `M` (along the image inclusion `f ''ᵁ V ≤ f ''ᵁ U`). This is the
naturality of the underlying morphism of abelian presheaves. -/
theorem gammaPullbackImageIso_hom_naturality {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f]
    (M : Y.Modules) {U V : X.Opens} (i : V ⟶ U) :
    ((Scheme.Modules.pullback f).obj M).presheaf.map i.op ≫ (gammaPullbackImageIso f M V).hom
      = (gammaPullbackImageIso f M U).hom ≫ M.presheaf.map (f.opensFunctor.map i).op := by
  exact (((Scheme.Modules.restrictFunctorIsoPullback f).symm.app M).hom.mapPresheaf).naturality i.op

/-- **Global sections of a pullback along an open immersion are sections over the range**
(gap1, Hfr section transport). The `U = ⊤` instance of `gammaPullbackImageIso`:
`Γ((pullback f).obj M, ⊤) ≅ Γ(M, f.opensRange)`, using `f ''ᵁ ⊤ = f.opensRange`. Once this lands the
named-form descent `isLocalizedModule_basicOpen_descent` and gap1 follow. -/
noncomputable def gammaPullbackTopIso {X Y : Scheme.{u}} (f : X ⟶ Y) [IsOpenImmersion f]
    (M : Y.Modules) :
    Γ((Scheme.Modules.pullback f).obj M, ⊤) ≅ Γ(M, f.opensRange) :=
  gammaPullbackImageIso f M ⊤ ≪≫ eqToIso (by rw [Scheme.Hom.image_top_eq_opensRange])

/-- **Open-immersion structure-sheaf ring iso on an image open** (gap1, Hfr semilinearity).
For an open immersion `j : X ⟶ Y` and an open `V ⊆ X`, the immersion is an isomorphism onto its
image `j ''ᵁ V`, so pulling structure-sheaf sections back gives a ring isomorphism
`σ_V : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V)`. This is `(j.appIso V)⁻¹` packaged as a `RingEquiv`; it is the
`σ` along which `gammaPullbackImageIso_hom_semilinear` is semilinear, the form bridge (I)
`isLocalizedModule_of_ringEquiv_semilinear` consumes.

The direction is source `→` image (so `σ_V a` lands in `Γ(Y, j ''ᵁ V)` for `a : Γ(X, V)`, the
section ring acting on the pullback module's sections). Project-local. -/
noncomputable def gammaImageRingEquiv {X Y : Scheme.{u}} (j : X ⟶ Y) [IsOpenImmersion j]
    (V : X.Opens) : Γ(X, V) ≃+* Γ(Y, j ''ᵁ V) :=
  (j.appIso V).commRingCatIsoToRingEquiv.symm

/-- **Semilinearity of the pullback section transport** (gap1 semilinearity wall). The forward map
of `gammaPullbackImageIso` is `σ_V`-semilinear (`σ_V = gammaImageRingEquiv`): for `a : Γ(X, V)` a
section of the structure sheaf and `x` a section of the pullback module,
`hom (a • x) = σ_V a • hom x`. The pullback-side action is the structure-sheaf action through
the pullback's `mapPresheaf`; the action on the `M` side is `M`'s action through `σ_V`.
Project-local. -/
theorem gammaPullbackImageIso_hom_semilinear {X Y : Scheme.{u}} (j : X ⟶ Y) [IsOpenImmersion j]
    (M : Y.Modules) (V : X.Opens) (a : Γ(X, V))
    (x : Γ((Scheme.Modules.pullback j).obj M, V)) :
    (gammaPullbackImageIso j M V).hom (a • x)
      = gammaImageRingEquiv j V a • (gammaPullbackImageIso j M V).hom x := by
  -- `gammaPullbackImageIso j M V`'s forward map is `Γ(-, V)` of the `Ab`-morphism
  -- `ψ := ((restrictFunctorIsoPullback j).symm.app M).hom`, i.e. the section map `ψ.app V`.
  simp only [gammaPullbackImageIso, Functor.mapIso_hom, Functor.comp_map,
    Scheme.Modules.toPresheaf_map, CategoryTheory.evaluation_obj_map,
    Scheme.Modules.mapPresheaf_app]
  -- `ψ.app V` is `Γ(X, V)`-linear (`Hom.app_smul`): `ψ.app V (a • x) = a • ψ.app V x`, the
  -- `Γ(X, V)`-action being `restrictFunctor`'s `restrictScalars`-action along `(j.appIso V).inv`.
  erw [Scheme.Modules.Hom.app_smul]
  -- The `restrictScalars` action `a •_{restrict} m` is defeq to `(j.appIso V).inv a •_M m`,
  -- and `σ_V a = gammaImageRingEquiv j V a = (j.appIso V).inv a`, so the two sides agree by `rfl`.
  rfl

/-! ## Project-local Mathlib supplement — gap1-D Hfr: combined algebra transport

The two `IsLocalizedModule` bridges (I) `isLocalizedModule_of_ringEquiv_semilinear` and (II)
`isLocalizedModule_restrictScalars_powers_algebraMap` are chained into a single transport lemma:
the localization that P1 (`IsIso fromTildeΓ`) produces on the slice `Spec R_r` (a localization at
`powers f'` over the section ring `S`) is read back, across the `σ`-semilinear section isos and the
base change `R → A` (`A = R_r`), as a localization at `powers f` over the base ring `R`. -/

/-- **(I)+(II) combined: ring-iso-semilinear localization transport descending to the base ring.**

Given a base ring `R`, an `R`-algebra `A`, a ring iso `σ : S ≃+* A` carrying `f' : S` to
`algebraMap R A f`, a localization `g` at `powers f'` over `S`, two `σ`-semilinear additive
isomorphisms `e₁, e₂` onto `A`-modules (also `R`-modules via the scalar tower `R → A`), and an
`A`-linear map `h` intertwining `g` with the `eᵢ` (`h (e₁ x) = e₂ (g x)`), the restriction of
scalars of `h` to `R` is a localization at `powers f` over `R`.

This is the algebra core of the gap1 `Hfr` transport: bridge (I)
(`isLocalizedModule_of_ringEquiv_semilinear`) moves the localization across the ring iso to
`powers (algebraMap R A f)` over `A`, then bridge (II)
(`isLocalizedModule_restrictScalars_powers_algebraMap`) descends it to `powers f` over `R`.
Project-local. -/
theorem isLocalizedModule_powers_transport
    {R A S : Type*} [CommRing R] [CommRing A] [CommRing S] [Algebra R A]
    (σ : S ≃+* A) (f : R) (f' : S) (hf : σ f' = algebraMap R A f)
    {M₁ M₂ N₁ N₂ : Type*}
    [AddCommGroup M₁] [Module S M₁] [AddCommGroup M₂] [Module S M₂]
    [AddCommGroup N₁] [Module A N₁] [Module R N₁] [IsScalarTower R A N₁]
    [AddCommGroup N₂] [Module A N₂] [Module R N₂] [IsScalarTower R A N₂]
    (g : M₁ →ₗ[S] M₂) [IsLocalizedModule (Submonoid.powers f') g]
    (e₁ : M₁ ≃+ N₁) (e₂ : M₂ ≃+ N₂)
    (he₁ : ∀ (a : S) (x : M₁), e₁ (a • x) = σ a • e₁ x)
    (he₂ : ∀ (a : S) (x : M₂), e₂ (a • x) = σ a • e₂ x)
    (h : N₁ →ₗ[A] N₂)
    (hh : ∀ x, h (e₁ x) = e₂ (g x)) :
    IsLocalizedModule (Submonoid.powers f) (h.restrictScalars R) := by
  have hI : IsLocalizedModule ((Submonoid.powers f').map (σ : S →+* A)) h :=
    isLocalizedModule_of_ringEquiv_semilinear σ (Submonoid.powers f') g e₁ e₂ he₁ he₂ h hh
  have key : (Submonoid.powers f').map (σ : S →+* A) = Submonoid.powers (algebraMap R A f) := by
    rw [Submonoid.map_powers]; exact congrArg Submonoid.powers hf
  rw [key] at hI
  haveI := hI
  exact isLocalizedModule_restrictScalars_powers_algebraMap f h

/-- **`IsIso M.fromTildeΓ` is invariant under isomorphism of modules.** If `M ≅ M'` as sheaves of
modules on `Spec R` and `M.fromTildeΓ` is an isomorphism, then so is `M'.fromTildeΓ`.

Immediate from `isIso_fromTildeΓ_iff` (`IsIso M.fromTildeΓ ↔ M ∈ essImage (tilde.functor R)`) and the
fact that the essential image is closed under isomorphism (`Functor.essImage.ofIso`). This is the
transport that lets P1's `IsIso fromTildeΓ` for the iterated-pullback module
`(pullback isoSpec.inv).obj ((pullback ι_W).obj ((pullback ι).obj M))` be carried to the pullback
`(pullback j).obj M` along the single composite open immersion `j = isoSpec.inv ≫ ι_W ≫ ι` (which is
isomorphic to the iterated one via the `pullbackComp` coherences). Project-local. -/
theorem isIso_fromTildeΓ_of_iso {R : CommRingCat.{u}} {M M' : (Spec R).Modules}
    (e : M ≅ M') [IsIso M.fromTildeΓ] : IsIso M'.fromTildeΓ := by
  rw [isIso_fromTildeΓ_iff] at *
  exact Functor.essImage.ofIso e ‹_›

/-! ## Project-local Mathlib supplement — gap1 section-transport producer

The geometric producer chain manufacturing the basic-open `Hfr` datum from the per-element P1
transport. See blueprint subsection "Section-transport producer for the basic-open Hfr". -/

/-- **Composite open immersion `j : Spec Γ(q.X i, ι⁻¹ᵁ D(s)) ⟶ Spec R`** identifying the affine
slice with the basic open `D(s)`.  It is `isoSpec.inv ≫ ι_W ≫ ι_{q.X i}` where
`W := ι_{q.X i}⁻¹ᵁ D(s)`; the domain is the genuine affine `Spec` of the slice's section ring.
Project-local: the geometric backbone of the section-transport producer. -/
noncomputable def compositeBasicOpenImmersion {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i) :
    Spec Γ(↑(q.X i), (Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)) ⟶ Spec R :=
  ((IsAffineOpen.Spec_basicOpen s).preimage_of_isOpenImmersion (Scheme.Opens.ι (q.X i))
      (by rw [Scheme.Opens.opensRange_ι]; exact hs)).isoSpec.inv ≫
    Scheme.Opens.ι ((Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)) ≫
    Scheme.Opens.ι (q.X i)

/-- **(producer, a) `fromTildeΓ` iso of the composite-immersion pullback.** For a quasi-coherent
`M` on `Spec R` and a basic open `D(s) ≤ q.X i`, the pullback module `(pullback j).obj M` along the
composite immersion `j = compositeBasicOpenImmersion` has an isomorphism `fromTildeΓ` counit.

The geometric content is the P1 keystone `isIso_fromTildeΓ_restrict_basicOpen`, which supplies
`IsIso fromTildeΓ` for the *iterated* pullback
`(pullback isoSpec.inv).obj ((pullback ι_W).obj ((pullback ι_{q.X i}).obj M))`; the iterated and the
composite pullbacks are identified by the `pullbackComp` pseudofunctor coherences, and
`isIso_fromTildeΓ_of_iso` transports the isomorphism across. Project-local: the critical first
ingredient of the section-transport producer. -/
theorem pullback_composite_immersion_isIso_fromTildeΓ {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i) :
    IsIso (@Scheme.Modules.fromTildeΓ
      (Γ(↑(q.X i), (Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)))
      ((Scheme.Modules.pullback (compositeBasicOpenImmersion M q s i hs)).obj M)) := by
  exact @isIso_fromTildeΓ_of_iso _ _ _
    ((Scheme.Modules.pullback (((IsAffineOpen.Spec_basicOpen s).preimage_of_isOpenImmersion
          (Scheme.Opens.ι (q.X i))
          (by rw [Scheme.Opens.opensRange_ι]; exact hs)).isoSpec.inv)).mapIso
        ((Scheme.Modules.pullbackComp
          (Scheme.Opens.ι ((Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)))
          (Scheme.Opens.ι (q.X i))).app M) ≪≫
      (Scheme.Modules.pullbackComp
        (((IsAffineOpen.Spec_basicOpen s).preimage_of_isOpenImmersion (Scheme.Opens.ι (q.X i))
          (by rw [Scheme.Opens.opensRange_ι]; exact hs)).isoSpec.inv)
        (Scheme.Opens.ι ((Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)) ≫
          Scheme.Opens.ι (q.X i))).app M)
    (isIso_fromTildeΓ_restrict_basicOpen M q s i hs)

/-- The composite immersion `j = compositeBasicOpenImmersion` is an open immersion (composite of an
iso and two open immersions). Needed for `.opensRange`, `''ᵁ`, and `gammaImageRingEquiv` on `j`. -/
instance compositeBasicOpenImmersion_isOpenImmersion {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i) :
    IsOpenImmersion (compositeBasicOpenImmersion M q s i hs) := by
  unfold compositeBasicOpenImmersion
  infer_instance

/-- **(producer, b) Range of the composite immersion is `D(s)`.** The open range of
`j = compositeBasicOpenImmersion` is exactly the basic open `D(s)`: `isoSpec.inv` is an iso (its
range is `⊤`), so the range is `ι_{q.X i} ''ᵁ (ι_{q.X i}⁻¹ᵁ D(s)) = (q.X i) ⊓ D(s) = D(s)` using
`D(s) ≤ q.X i`. Project-local image bookkeeping for the section-transport producer. -/
theorem compositeBasicOpenImmersion_opensRange {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i) :
    (compositeBasicOpenImmersion M q s i hs).opensRange
      = (PrimeSpectrum.basicOpen s : (Spec R).Opens) := by
  unfold compositeBasicOpenImmersion
  rw [Scheme.Hom.opensRange_comp_of_isIso,
    Scheme.Hom.opensRange_comp, Scheme.Opens.opensRange_ι,
    Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
  exact inf_eq_right.mpr hs

/-! ## Project-local Mathlib supplement — gap1 section-transport producer (b-flocus/c/d/TOP)

The remaining producer chain assembling the basic-open `Hfr` datum (consumed by
`isLocalizedModule_basicOpen_descent_of_basicOpen_cover`) from the per-element P1 transport
`pullback_composite_immersion_isIso_fromTildeΓ` via the algebra combiner
`isLocalizedModule_powers_transport`.  See blueprint "Section-transport producer for the basic-open
Hfr". -/

/-- **Image of an affine basic open under an open immersion of affines.** For an open immersion
`j : Spec S ⟶ Spec R` and `f' : S`, the image `j ''ᵁ D(f')` is the `Spec R` scheme basic open of the
transported global section `(j.appIso ⊤).inv ((ΓSpecIso S).inv f')`.  Pure geometry:
`basicOpen_eq_of_affine` turns `D(f')` into the scheme basic open of a global structure section of
`Spec S`, and `Scheme.image_basicOpen` transports it across `j`.  Stated with `j` opaque so the
`rw` does not unfold a concrete composite immersion.  Project-local. -/
theorem image_basicOpen_of_affine {S R : CommRingCat.{u}} (j : Spec S ⟶ Spec R)
    [IsOpenImmersion j] (f' : S) :
    j ''ᵁ (PrimeSpectrum.basicOpen f')
      = (Spec R).basicOpen ((j.appIso ⊤).inv ((Scheme.ΓSpecIso S).inv f')) := by
  rw [← basicOpen_eq_of_affine f', Scheme.image_basicOpen j ((Scheme.ΓSpecIso S).inv f')]

/-- **(producer, b-flocus, image of a basic open).** The image under
`j = compositeBasicOpenImmersion`
of a basic open `D(f')` of the affine slice is the `Spec R` basic open of the transported section
`(j.appIso ⊤).inv ((ΓSpecIso _).inv f')`.  Instantiates `image_basicOpen_of_affine` at the concrete
composite immersion.  Project-local. -/
theorem compositeBasicOpenImmersion_image_basicOpen {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i)
    (f' : Γ(↑(q.X i), (Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s))) :
    (compositeBasicOpenImmersion M q s i hs) ''ᵁ (PrimeSpectrum.basicOpen f')
      = (Spec R).basicOpen
          (((compositeBasicOpenImmersion M q s i hs).appIso ⊤).inv ((Scheme.ΓSpecIso _).inv f')) :=
  image_basicOpen_of_affine (compositeBasicOpenImmersion M q s i hs) f'

/-- **Image of an affine basic open as an intersection with the range.** If the appIso-transport of
`f'` agrees with the restriction to `j ''ᵁ ⊤` of a global section `g : Γ(Spec R, ⊤)`, then
`j ''ᵁ D(f') = (j ''ᵁ ⊤) ⊓ (Spec R).basicOpen g`.  Combines `image_basicOpen_of_affine` with the
structure-sheaf identity `Scheme.basicOpen_res`.  Project-local. -/
theorem image_basicOpen_eq_inf {S R : CommRingCat.{u}} (j : Spec S ⟶ Spec R)
    [IsOpenImmersion j] (f' : S) (g : Γ(Spec R, ⊤))
    (hfg : (j.appIso ⊤).inv ((Scheme.ΓSpecIso S).inv f')
        = (Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op g) :
    j ''ᵁ (PrimeSpectrum.basicOpen f') = (j ''ᵁ ⊤) ⊓ (Spec R).basicOpen g := by
  rw [image_basicOpen_of_affine, hfg, Scheme.basicOpen_res]

set_option maxHeartbeats 1600000 in
-- Large multi-step assembly (localization combiner + `eqToHom` open-transport); needs headroom.
/-- **(producer, TOP-aux) Basic-open `Hfr` along an abstract affine open immersion.**  For an open
immersion `j : Spec S ⟶ Spec R` with `IsIso (fromTildeΓ ((pullback j).obj M))` (the P1 datum), a
ring element `f : R` and a slice element `f' : S` whose appIso-transport is the restriction of `f`
(`hf'`), and target opens `U = j ''ᵁ ⊤`, `V = j ''ᵁ D(f')`, the section restriction
`Γ(M, U) → Γ(M, V)` is `IsLocalizedModule (powers f)` over `R`.

The proof assembles the P1 object-level `IsIso fromTildeΓ` into a section-level localization via the
algebra combiner `isLocalizedModule_powers_transport`: the engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ` localizes `Γ(M',⊤) → Γ(M', D(f'))` over the slice
ring `S`; the `σ`-semilinear section isos `e₁ = gammaPullbackImageIso ⊤`,
`e₂ = gammaPullbackImageIso D(f')` (over `σ = (ΓSpecIso S)⁻¹ ≪≫ gammaImageRingEquiv ⊤`) and the
restriction map `h` intertwine it, and the combiner descends the result to `powers f` over `R`.
Finally the `j ''ᵁ`-form opens are transported to `U` / `V` via `eT`, `eB`.  `j` is kept abstract so
the section-ring defeqs stay cheap.
Project-local: the abstract core of the gap1 keystone `Hfr` producer. -/
theorem section_localization_hfr_aux {R S : CommRingCat.{u}} (M : (Spec R).Modules)
    (j : Spec S ⟶ Spec R) [IsOpenImmersion j]
    (hP1 : IsIso (Scheme.Modules.fromTildeΓ ((Scheme.Modules.pullback j).obj M)))
    (f : R) (f' : S) (U V : (Spec R).Opens) (hUV : V ≤ U)
    (eT : (j ''ᵁ (⊤ : (Spec S).Opens)) = U)
    (eB : (j ''ᵁ (PrimeSpectrum.basicOpen f')) = V)
    (hf' : (j.appIso ⊤).inv ((Scheme.ΓSpecIso S).inv f')
        = (Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op
            ((Scheme.ΓSpecIso R).inv f)) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hUV).op).hom := by
  set M' := (Scheme.Modules.pullback j).obj M with hM'
  haveI : IsIso (Scheme.Modules.fromTildeΓ M') := hP1
  set A := Γ(Spec R, j ''ᵁ (⊤ : (Spec S).Opens)) with hA
  let algRA : (R : Type _) →+* (A : Type _) :=
    ((Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op).hom.comp
      (Scheme.ΓSpecIso R).inv.hom
  letI instAlg : Algebra (R : Type _) (A : Type _) := RingHom.toAlgebra algRA
  let σ : (S : Type _) ≃+* (A : Type _) :=
    (Scheme.ΓSpecIso S).symm.commRingCatIsoToRingEquiv.trans (gammaImageRingEquiv j ⊤)
  have hf : σ f' = algebraMap (R : Type _) (A : Type _) f := hf'
  let ii : (j ''ᵁ (PrimeSpectrum.basicOpen f') : (Spec R).Opens) ⟶ j ''ᵁ (⊤ : (Spec S).Opens) :=
    j.opensFunctor.map (homOfLE le_top)
  let N₁ := Γ(M, j ''ᵁ (⊤ : (Spec S).Opens))
  let N₂ := Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f'))
  letI iAN₂ : Module (A : Type _) (ToType N₂) :=
    Module.compHom (ToType N₂) ((Spec R).presheaf.map ii.op).hom
  letI iRN₁ : Module (R : Type _) (ToType N₁) :=
    Module.compHom _ (algebraMap (R : Type _) (A : Type _))
  letI iRN₂ : Module (R : Type _) (ToType N₂) :=
    Module.compHom _ (algebraMap (R : Type _) (A : Type _))
  haveI iST₁ : IsScalarTower (R : Type _) (A : Type _) (ToType N₁) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  haveI iST₂ : IsScalarTower (R : Type _) (A : Type _) (ToType N₂) :=
    IsScalarTower.of_algebraMap_smul (fun _ _ => rfl)
  let e₁ := (gammaPullbackImageIso j M ⊤).addCommGroupIsoToAddEquiv
  let e₂ := (gammaPullbackImageIso j M (PrimeSpectrum.basicOpen f')).addCommGroupIsoToAddEquiv
  let g := ((modulesSpecToSheaf.obj M').presheaf.map
    (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤)).op).hom
  haveI : IsLocalizedModule (Submonoid.powers f') g :=
    isLocalizedModule_restrict_of_isIso_fromTildeΓ M' f'
  let h : ToType N₁ →ₗ[(A : Type _)] ToType N₂ :=
    { toFun := fun m => (M.presheaf.map ii.op) m
      map_add' := fun x y => map_add _ x y
      map_smul' := fun a m => Scheme.Modules.map_smul M ii a m }
  have he₁ : ∀ (a : (S : Type _))
      (x : ToType ((modulesSpecToSheaf.obj M').presheaf.obj (.op ⊤))),
      e₁ (a • x) = σ a • e₁ x :=
    fun a x => gammaPullbackImageIso_hom_semilinear j M ⊤ ((Scheme.ΓSpecIso S).inv a) x
  have key0 := j.appIso_inv_naturality (U := (⊤ : (Spec S).Opens))
    (V := PrimeSpectrum.basicOpen f') (homOfLE le_top).op
  have he₂ : ∀ (a : (S : Type _))
      (x : ToType ((modulesSpecToSheaf.obj M').presheaf.obj (.op (PrimeSpectrum.basicOpen f')))),
      e₂ (a • x) = σ a • e₂ x := by
    intro a x
    have h1 := gammaPullbackImageIso_hom_semilinear j M (PrimeSpectrum.basicOpen f')
      ((Spec S).presheaf.map (homOfLE le_top).op ((Scheme.ΓSpecIso S).inv a)) x
    have key : (gammaImageRingEquiv j (PrimeSpectrum.basicOpen f'))
          ((Spec S).presheaf.map (homOfLE le_top).op ((Scheme.ΓSpecIso S).inv a))
        = ((Spec R).presheaf.map ii.op).hom (σ a) :=
      congrArg (fun φ => φ.hom ((Scheme.ΓSpecIso S).inv a)) key0
    exact h1.trans (congrArg (· • e₂ x) key)
  have hh : ∀ x, h (e₁ x) = e₂ (g x) := by
    intro x
    have hn := ConcreteCategory.congr_hom
      (gammaPullbackImageIso_hom_naturality j M
        (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤))) x
    simp only [CategoryTheory.comp_apply] at hn
    exact hn.symm
  have RESULT : IsLocalizedModule (Submonoid.powers f) (h.restrictScalars (R : Type _)) :=
    isLocalizedModule_powers_transport σ f f' hf g e₁ e₂ he₁ he₂ h hh
  -- transport the `j ''ᵁ`-form localization to the `D(s)` / `D(f) ⊓ D(s)` Hfr form
  -- the combiner's map is, by defeq, the `modulesSpecToSheaf` restriction along `ii`
  have RESULT' : IsLocalizedModule (Submonoid.powers f)
      (((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) := RESULT
  -- eqToHom open isos transporting `j ''ᵁ ⊤ → U` and `j ''ᵁ D(f') → V`
  have hUop : (Opposite.op U : (Spec R).Opensᵒᵖ)
      = Opposite.op (j ''ᵁ (⊤ : (Spec S).Opens)) := congrArg Opposite.op eT.symm
  have hVop : (Opposite.op V : (Spec R).Opensᵒᵖ)
      = Opposite.op (j ''ᵁ (PrimeSpectrum.basicOpen f')) := congrArg Opposite.op eB.symm
  let αU := (asIso ((modulesSpecToSheaf.obj M).presheaf.map (eqToHom hUop))).toLinearEquiv
  let αV := (asIso ((modulesSpecToSheaf.obj M).presheaf.map (eqToHom hVop))).toLinearEquiv
  haveI hRES := RESULT'
  have step1 : IsLocalizedModule (Submonoid.powers f)
      ((((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) ∘ₗ αU.toLinearMap) :=
    IsLocalizedModule.of_linearEquiv_right (S := Submonoid.powers f)
      (f := ((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) αU
  haveI hS1 := step1
  have step : IsLocalizedModule (Submonoid.powers f)
      (αV.symm.toLinearMap ∘ₗ
        ((((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) ∘ₗ αU.toLinearMap)) :=
    IsLocalizedModule.of_linearEquiv (S := Submonoid.powers f)
      (f := (((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) ∘ₗ αU.toLinearMap) αV.symm
  -- forward naturality square (uses only the forward eqToHom isos, both `rfl`-identified)
  have hsq : ((((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) ∘ₗ αU.toLinearMap)
      = (αV.toLinearMap ∘ₗ
          ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hUV).op).hom) := by
    rw [show αU.toLinearMap = ((modulesSpecToSheaf.obj M).presheaf.map (eqToHom hUop)).hom from rfl,
      show αV.toLinearMap = ((modulesSpecToSheaf.obj M).presheaf.map (eqToHom hVop)).hom from rfl,
      ← ModuleCat.hom_comp, ← ModuleCat.hom_comp, ← Functor.map_comp, ← Functor.map_comp]
    exact congrArg (fun m => ((modulesSpecToSheaf.obj M).presheaf.map m).hom)
      (Subsingleton.elim _ _)
  have hcancel : αV.symm.toLinearMap ∘ₗ αV.toLinearMap = LinearMap.id := by
    ext y; simp
  -- the transported composite equals the Hfr restriction map
  have hcomp : ((modulesSpecToSheaf.obj M).presheaf.map (homOfLE hUV).op).hom
      = αV.symm.toLinearMap ∘ₗ
        ((((modulesSpecToSheaf.obj M).presheaf.map ii.op).hom) ∘ₗ αU.toLinearMap) := by
    rw [hsq, ← LinearMap.comp_assoc, hcancel, LinearMap.id_comp]
  rw [hcomp]
  exact step

/-- **(producer, TOP) Basic-open `Hfr` from the per-element P1 transport.**  For a quasi-coherent
`M` on `Spec R`, a basic open `D(s) ≤ q.X i`, and `f : R`, the section restriction
`Γ(M, D(s)) → Γ(M, D(f) ⊓ D(s))` is `IsLocalizedModule (powers f)` over `R`.  This is the gated
basic-open `Hfr` datum consumed by `isLocalizedModule_basicOpen_descent_of_basicOpen_cover`.

Thin wrapper around `section_localization_hfr_aux`: it instantiates the abstract open immersion at
the concrete composite immersion `j = compositeBasicOpenImmersion`, supplies the P1 datum
`pullback_composite_immersion_isIso_fromTildeΓ`, picks `f' = σ⁻¹(algebraMap R A f)` (so `hf'` is
`σ.apply_symm_apply`), and identifies the `j ''ᵁ`-form opens with `D(s)` (`opensRange`) and
`D(f) ⊓ D(s)` (`image_basicOpen_eq_inf`).  Project-local: the geometric producer of the gap1
keystone `Hfr`. -/
theorem section_localization_hfr_basicOpen {R : CommRingCat.{u}}
    (M : (Spec R).Modules) (q : M.QuasicoherentData) (f s : R) (i : q.I)
    (hs : (PrimeSpectrum.basicOpen s : (Spec R).Opens) ≤ q.X i) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (inf_le_right : PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s
          ≤ PrimeSpectrum.basicOpen s)).op).hom := by
  set S := Γ(↑(q.X i), (Scheme.Opens.ι (q.X i)) ⁻¹ᵁ (PrimeSpectrum.basicOpen s)) with hS
  set j := compositeBasicOpenImmersion M q s i hs with hj
  set A := Γ(Spec R, j ''ᵁ (⊤ : (Spec S).Opens)) with hA
  let algRA : (R : Type _) →+* (A : Type _) :=
    ((Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op).hom.comp
      (Scheme.ΓSpecIso R).inv.hom
  letI instAlg : Algebra (R : Type _) (A : Type _) := RingHom.toAlgebra algRA
  let σ : (S : Type _) ≃+* (A : Type _) :=
    (Scheme.ΓSpecIso S).symm.commRingCatIsoToRingEquiv.trans (gammaImageRingEquiv j ⊤)
  let f' : (S : Type _) := σ.symm (algebraMap (R : Type _) (A : Type _) f)
  have hf' : (j.appIso ⊤).inv ((Scheme.ΓSpecIso S).inv f')
      = (Spec R).presheaf.map (homOfLE (le_top : (j ''ᵁ ⊤) ≤ ⊤)).op
          ((Scheme.ΓSpecIso R).inv f) := σ.apply_symm_apply _
  have eT : (j ''ᵁ (⊤ : (Spec S).Opens)) = PrimeSpectrum.basicOpen s :=
    (Scheme.Hom.image_top_eq_opensRange j).trans
      (compositeBasicOpenImmersion_opensRange M q s i hs)
  have eB : (j ''ᵁ (PrimeSpectrum.basicOpen f'))
      = PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s := by
    rw [image_basicOpen_eq_inf j f' ((Scheme.ΓSpecIso R).inv f) hf', eT, basicOpen_eq_of_affine]
    exact inf_comm _ _
  exact section_localization_hfr_aux M j
    (pullback_composite_immersion_isIso_fromTildeΓ M q s i hs) f f'
    (PrimeSpectrum.basicOpen s) (PrimeSpectrum.basicOpen f ⊓ PrimeSpectrum.basicOpen s)
    inf_le_right eT eB hf'

/-! ## Project-local Mathlib supplement — gap2 single-chart transport

The general-scheme keystone `lem:qcoh_section_localization_basicOpen`
(`isLocalizedModule_basicOpen`): for a quasi-coherent sheaf of modules `M` on an *arbitrary* scheme
`X`, an affine open `U`, and `f : Γ(X, U)`, the section restriction `Γ(M, U) → Γ(M, D(f))` is
`IsLocalizedModule (powers f)` over `Γ(X, U)`.

It is the single-chart affine transport on top of G1-core: pull `M` back along the affine immersion
`hU.fromSpec : Spec Γ(X, U) ⟶ X` (range `U`), so the pullback `M'` is quasi-coherent on
`Spec Γ(X, U)`, where gap1 gives `IsIso M'.fromTildeΓ`; the engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ` localizes the slice restriction over `Γ(X, U)`, and
the `σ`-semilinear section comparison `gammaPullbackImageIso` (bridge (I)
`isLocalizedModule_of_ringEquiv_semilinear`) transports it to the `M`-side restriction. No
cover-and-glue: `U` is already affine, so there is a single chart. -/

/-- **The `Γ(X,U)`-linear section restriction map of a sheaf of modules.** For `M : X.Modules` and
an inclusion of opens `i : V ⟶ U`, the presheaf restriction `Γ(M, U) → Γ(M, V)` is `Γ(X, U)`-linear
when `Γ(M, V)` carries the `Γ(X, U)`-module structure restricted along `X.presheaf.map i.op`
(`Module.compHom`). Linearity is `Scheme.Modules.map_smul`. Project-local: the linear-map packaging
of the section restriction needed to state `IsLocalizedModule` for a general scheme (Mathlib's
presheaf-of-modules restriction is semilinear, not bundled this way). -/
noncomputable def restrictₗ {X : Scheme.{u}} (M : X.Modules) {U V : X.Opens} (i : V ⟶ U) :
    letI : Module Γ(X, U) Γ(M, V) := Module.compHom _ (X.presheaf.map i.op).hom
    Γ(M, U) →ₗ[Γ(X, U)] Γ(M, V) :=
  letI : Module Γ(X, U) Γ(M, V) := Module.compHom _ (X.presheaf.map i.op).hom
  { toFun := fun x => M.presheaf.map i.op x
    map_add' := map_add _
    map_smul' := fun r x => Scheme.Modules.map_smul M i r x }

/-- **The `Γ(X,U)`-linear restriction of sections to a basic open `D(f)`** (`f : Γ(X, U)`). The
section restriction `Γ(M, U) → Γ(M, X.basicOpen f)` is `Γ(X, U)`-linear, where `Γ(M, X.basicOpen f)`
carries any `Γ(X, U)`-module structure compatible (via `IsScalarTower`) with its native
`Γ(X, X.basicOpen f)`-module structure and the canonical `Γ(X, U)`-algebra map
`Γ(X, U) → Γ(X, X.basicOpen f)` (the restriction `X.presheaf.map`). Linearity combines
`Scheme.Modules.map_smul` with the scalar tower. This is the consumer-facing shape of the gap2
keystone (instances supplied by the caller, matching `Module.annihilator_isLocalizedModule_eq_map`).
Project-local. -/
noncomputable def restrictBasicOpenₗ {X : Scheme.{u}} (M : X.Modules) {U : X.Opens} (f : Γ(X, U))
    [Module Γ(X, U) Γ(M, X.basicOpen f)]
    [IsScalarTower Γ(X, U) Γ(X, X.basicOpen f) Γ(M, X.basicOpen f)] :
    Γ(M, U) →ₗ[Γ(X, U)] Γ(M, X.basicOpen f) where
  toFun := fun x => M.presheaf.map (homOfLE (X.basicOpen_le f)).op x
  map_add' := map_add _
  map_smul' := fun r x => by
    change M.presheaf.map (homOfLE (X.basicOpen_le f)).op (r • x) = r • _
    rw [Scheme.Modules.map_smul M (homOfLE (X.basicOpen_le f)) r x,
      ← algebraMap_smul Γ(X, X.basicOpen f) r (M.presheaf.map (homOfLE (X.basicOpen_le f)).op x)]
    rfl

/-- **`fromSpec`-section coherence** (gap2 transport crux). For an affine open `U` of a scheme `X`,
the `eqToHom`-transport `Γ(X, hU.fromSpec ''ᵁ ⊤) → Γ(X, U)` (along the equality
`hU.fromSpec ''ᵁ ⊤ = U`) equals the composite ring iso
`(hU.fromSpec.appIso ⊤).hom ≫ (ΓSpecIso Γ(X, U)).hom`. Equivalently, the section ring iso
`σ = (ΓSpecIso)⁻¹ ≫ gammaImageRingEquiv (fromSpec) ⊤` underlying the gap2 section comparison is, up to
this `eqToHom` transport, the identity. This is the coherence needed to read the gap2-core
localization (over `Γ(X, hU.fromSpec ''ᵁ ⊤)`, at `powers (σ f)`) back as a localization over
`Γ(X, U)` at `powers f`. Proof: `fromSpec_app_self` + `appIso_hom'` + cancellation of the
`Spec Γ(X, U)`-presheaf maps (all between `⊤`, hence forced by `Subsingleton`). Project-local. -/
theorem fromSpec_image_top_section_coherence {X : Scheme.{u}} {U : X.Opens} (hU : IsAffineOpen U)
    (eT : hU.fromSpec ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) = U) :
    X.presheaf.map (eqToHom eT.symm).op
      = (hU.fromSpec.appIso (⊤ : (Spec Γ(X, U)).Opens)).hom ≫ (Scheme.ΓSpecIso Γ(X, U)).hom := by
  rw [← cancel_epi (X.presheaf.map (eqToHom eT).op),
    ← X.presheaf.map_comp, ← op_comp, eqToHom_trans, eqToHom_refl, op_id, X.presheaf.map_id]
  rw [Scheme.Hom.appIso_hom', Scheme.Hom.appLE]
  have hnat := hU.fromSpec.naturality (eqToHom eT).op
  simp only [Category.assoc]
  rw [reassoc_of% hnat, hU.fromSpec_app_self]
  simp only [eqToHom_unop, eqToHom_map, eqToHom_op]
  simp only [Category.assoc]
  rw [eqToHom_trans_assoc, ← eqToHom_map (Spec Γ(X, U)).presheaf,
    ← (Spec Γ(X, U)).presheaf.map_comp_assoc]
  · rw [Subsingleton.elim (eqToHom _ ≫ (homOfLE _).op)
      (𝟙 (Opposite.op (⊤ : (Spec Γ(X, U)).Opens))),
      (Spec Γ(X, U)).presheaf.map_id, Category.id_comp, Iso.inv_hom_id]
  · rw [eT, hU.fromSpec_preimage_self]

/-- **(gap2 core) Basic-open section localization along an abstract affine open immersion.** For an
open immersion `j : Spec S ⟶ X` with the P1 datum `IsIso (fromTildeΓ ((pullback j).obj M))`, a slice
element `f' : S`, and `f : Γ(X, j ''ᵁ ⊤)` with `σ f' = f` (`σ = (ΓSpecIso S)⁻¹ ≫ gammaImageRingEquiv
j ⊤`), the section restriction `Γ(M, j ''ᵁ ⊤) → Γ(M, j ''ᵁ D(f'))` is
`IsLocalizedModule (powers f)` over `Γ(X, j ''ᵁ ⊤)`.

The proof mirrors `section_localization_hfr_aux` but over an arbitrary ambient scheme `X` (so the
localization ring is the *local* section ring `A = Γ(X, j ''ᵁ ⊤)`, not a global `R`): the engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ` localizes the slice restriction `g` over `S`, the
`σ`-semilinear section comparisons `e₁, e₂` (`gammaPullbackImageIso`) intertwine `g` with the
`M`-side restriction `h = restrictₗ M ii`, and bridge (I)
`isLocalizedModule_of_ringEquiv_semilinear` transports the localization across `σ`, landing
`powers ((powers f').map σ) = powers (σ f') = powers f`. Because the base and target rings coincide
(`R = A`), no `restrictScalars` base-change (bridge II) is needed. Project-local. -/
theorem section_localization_hfr_aux_general {X : Scheme.{u}} {S : CommRingCat.{u}}
    (M : X.Modules) (j : Spec S ⟶ X) [IsOpenImmersion j]
    (hP1 : IsIso (Scheme.Modules.fromTildeΓ ((Scheme.Modules.pullback j).obj M)))
    (f : Γ(X, j ''ᵁ (⊤ : (Spec S).Opens))) (f' : S)
    (hf' : (gammaImageRingEquiv j ⊤) ((Scheme.ΓSpecIso S).inv f') = f) :
    letI : Module Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f')) :=
      Module.compHom _ (X.presheaf.map (j.opensFunctor.map (homOfLE le_top)).op).hom
    IsLocalizedModule (Submonoid.powers f)
      (show Γ(M, j ''ᵁ (⊤ : (Spec S).Opens)) →ₗ[Γ(X, j ''ᵁ (⊤ : (Spec S).Opens))]
          Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f')) from
        restrictₗ M (j.opensFunctor.map (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤)))) := by
  let M' := (Scheme.Modules.pullback j).obj M
  haveI : IsIso (Scheme.Modules.fromTildeΓ M') := hP1
  let σ : (S : Type _) ≃+* (Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) : Type _) :=
    (Scheme.ΓSpecIso S).symm.commRingCatIsoToRingEquiv.trans (gammaImageRingEquiv j ⊤)
  have hf : σ f' = f := hf'
  let ii : (j ''ᵁ (PrimeSpectrum.basicOpen f') : X.Opens) ⟶ j ''ᵁ (⊤ : (Spec S).Opens) :=
    j.opensFunctor.map (homOfLE le_top)
  letI iAN₂ : Module (Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) : Type _)
      (ToType Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f'))) :=
    Module.compHom _ (X.presheaf.map ii.op).hom
  let e₁ := (gammaPullbackImageIso j M ⊤).addCommGroupIsoToAddEquiv
  let e₂ := (gammaPullbackImageIso j M (PrimeSpectrum.basicOpen f')).addCommGroupIsoToAddEquiv
  let g := ((modulesSpecToSheaf.obj M').presheaf.map
    (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤)).op).hom
  haveI : IsLocalizedModule (Submonoid.powers f') g :=
    isLocalizedModule_restrict_of_isIso_fromTildeΓ M' f'
  let h : ToType Γ(M, j ''ᵁ (⊤ : (Spec S).Opens)) →ₗ[(Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)) : Type _)]
      ToType Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f')) :=
    { toFun := fun m => (M.presheaf.map ii.op) m
      map_add' := fun x y => map_add _ x y
      map_smul' := fun a m => Scheme.Modules.map_smul M ii a m }
  have he₁ : ∀ (a : (S : Type _))
      (x : ToType ((modulesSpecToSheaf.obj M').presheaf.obj (.op ⊤))),
      e₁ (a • x) = σ a • e₁ x :=
    fun a x => gammaPullbackImageIso_hom_semilinear j M ⊤ ((Scheme.ΓSpecIso S).inv a) x
  have key0 := j.appIso_inv_naturality (U := (⊤ : (Spec S).Opens))
    (V := PrimeSpectrum.basicOpen f') (homOfLE le_top).op
  have he₂ : ∀ (a : (S : Type _))
      (x : ToType ((modulesSpecToSheaf.obj M').presheaf.obj (.op (PrimeSpectrum.basicOpen f')))),
      e₂ (a • x) = σ a • e₂ x := by
    intro a x
    have h1 := gammaPullbackImageIso_hom_semilinear j M (PrimeSpectrum.basicOpen f')
      ((Spec S).presheaf.map (homOfLE le_top).op ((Scheme.ΓSpecIso S).inv a)) x
    have key : (gammaImageRingEquiv j (PrimeSpectrum.basicOpen f'))
          ((Spec S).presheaf.map (homOfLE le_top).op ((Scheme.ΓSpecIso S).inv a))
        = (X.presheaf.map ii.op).hom (σ a) :=
      congrArg (fun φ => φ.hom ((Scheme.ΓSpecIso S).inv a)) key0
    exact h1.trans (congrArg (· • e₂ x) key)
  have hh : ∀ x, h (e₁ x) = e₂ (g x) := by
    intro x
    have hn := ConcreteCategory.congr_hom
      (gammaPullbackImageIso_hom_naturality j M
        (homOfLE (le_top : PrimeSpectrum.basicOpen f' ≤ ⊤))) x
    simp only [CategoryTheory.comp_apply] at hn
    exact hn.symm
  have RESULT : IsLocalizedModule
      ((Submonoid.powers f').map (σ : S →+* Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)))) h :=
    isLocalizedModule_of_ringEquiv_semilinear σ (Submonoid.powers f') g e₁ e₂ he₁ he₂ h hh
  have key : (Submonoid.powers f').map (σ : S →+* Γ(X, j ''ᵁ (⊤ : (Spec S).Opens)))
      = Submonoid.powers f := by
    rw [Submonoid.map_powers]; exact congrArg Submonoid.powers hf
  rw [key] at RESULT
  exact RESULT

/-- **(gap1 keystone) Section-localization descent for quasi-coherent `M`.**  For a quasi-coherent
sheaf of modules `M` on `Spec R` and `f : R`, the global-to-`D(f)` section restriction
`Γ(M, ⊤) → Γ(M, D(f))` is `IsLocalizedModule (powers f)` over `R`.

Instantiates the cover-form descent `isLocalizedModule_basicOpen_descent_of_basicOpen_cover` at the
finite basic-open cover `exists_finite_basicOpen_cover_le_quasicoherentData` refining the
quasi-coherent data `q`, with the per-element basic-open `Hfr` supplied by the producer
`section_localization_hfr_basicOpen` (each cover overlap `D(s) ≤ D(r) ≤ q.X i` feeds the producer at
`i`).  Project-local: the named gap1 keystone (Hartshorne II.5.3 / Stacks
`lemma-invert-f-sections`), built without the global affine `QCoh ≃ Mod` equivalence. -/
theorem isLocalizedModule_basicOpen_descent {R : CommRingCat.{u}} (M : (Spec R).Modules)
    [hqc : M.IsQuasicoherent] (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom := by
  obtain ⟨q⟩ := hqc.nonempty_quasicoherentData
  obtain ⟨t, hspan, hcov⟩ := exists_finite_basicOpen_cover_le_quasicoherentData M q
  refine isLocalizedModule_basicOpen_descent_of_basicOpen_cover M f t hspan ?_
  intro s hs_ex
  obtain ⟨r, hr, hsr⟩ := hs_ex
  obtain ⟨i, hri⟩ := hcov r hr
  exact section_localization_hfr_basicOpen M q f s i (le_trans hsr hri)

/-- **(gap1) `IsIso M.fromTildeΓ` for quasi-coherent `M`.**  The tilde-Gamma counit of a
quasi-coherent sheaf of modules on `Spec R` is an isomorphism (equivalently, `M` lies in the
essential image of `tilde`).  This is the affine quasi-coherent ⟺ `tilde` bridge that Mathlib leaves
open at the pinned commit.

Immediate from the keystone `isLocalizedModule_basicOpen_descent` (per-basic-open section
localization for quasi-coherent `M`) via the section-to-counit assembly
`isIso_fromTildeΓ_of_isLocalizedModule_restrict`.  Project-local: closes gap1. -/
theorem isIso_fromTildeΓ_of_isQuasicoherent {R : CommRingCat.{u}} (M : (Spec R).Modules)
    [M.IsQuasicoherent] : IsIso M.fromTildeΓ :=
  isIso_fromTildeΓ_of_isLocalizedModule_restrict M
    (fun f => isLocalizedModule_basicOpen_descent M f)

/-- **G1-core: section-localization for a quasi-coherent sheaf on `Spec R`**
(`lem:qcoh_affine_section_localization`). For a quasi-coherent sheaf of modules `M` on `Spec R` and
`f : R`, the section restriction `Γ(M, ⊤) → Γ(M, D(f))` exhibits the target as the localized module
`(powers f)⁻¹ Γ(M, ⊤)`, i.e. it is `IsLocalizedModule (powers f)` over `R`.

This is the clean named form of gap1's downstream corollary: gap1
(`isIso_fromTildeΓ_of_isQuasicoherent`) makes `M.fromTildeΓ` an isomorphism, and the affine engine
`isLocalizedModule_restrict_of_isIso_fromTildeΓ` then delivers all three `IsLocalizedModule` fields
at once. Project-local: Mathlib has no `QCoh(Spec R) → section-localization` bridge. It is the
affine `X = Spec R`, `U = ⊤` instance of the general-scheme keystone
`isLocalizedModule_basicOpen` (gap2). -/
theorem isLocalizedModule_basicOpen_of_isQuasicoherent {R : CommRingCat.{u}}
    (M : (Spec R).Modules) [M.IsQuasicoherent] (f : R) :
    IsLocalizedModule (Submonoid.powers f)
      ((modulesSpecToSheaf.obj M).presheaf.map
        (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)).op).hom :=
  haveI := isIso_fromTildeΓ_of_isQuasicoherent M
  isLocalizedModule_restrict_of_isIso_fromTildeΓ M f

set_option maxHeartbeats 1600000 in
-- The multi-step eqToHom open-transport + bridge-(I) ring-iso assembly needs heartbeat headroom.
/-- **(gap2, Piece B — the eqToHom bridge)** Basic-open section localization from the gap2-core,
given the P1 datum directly.  For a sheaf of modules `M` on a scheme `X`, an affine open `U`, the P1
hypothesis `hP1 : IsIso (fromTildeΓ ((pullback hU.fromSpec).obj M))`, and `f : Γ(X, U)`, the
consumer-facing basic-open section restriction `restrictBasicOpenₗ M f` is
`IsLocalizedModule (powers f)` over `Γ(X, U)`.

This is the mechanical eqToHom bridge from `section_localization_hfr_aux_general` (instantiated at
the affine immersion `j = hU.fromSpec`, slice element `f' = f`, image section `f_im = σ f`) to
`restrictBasicOpenₗ`: the open identifications `j ''ᵁ ⊤ = U` (`eT`) and
`j ''ᵁ D(f) = X.basicOpen f` (`IsAffineOpen.fromSpec_image_basicOpen`) plus the section ring iso
`ρ = X.presheaf.map (eqToHom eT.symm).op : Γ(X, j ''ᵁ ⊤) ≃+* Γ(X, U)` transport the localization
across (bridge (I) `isLocalizedModule_of_ringEquiv_semilinear`), the only non-trivial coherence
being `ρ (σ f) = f`, supplied by the crux `fromSpec_image_top_section_coherence`.  Project-local:
separates the genuinely-new QC-pullback (Piece A) from the mechanical transport. -/
theorem isLocalizedModule_basicOpen_of_hP1 {X : Scheme.{u}} (M : X.Modules)
    {U : X.Opens} (hU : IsAffineOpen U)
    (hP1 : IsIso (Scheme.Modules.fromTildeΓ ((Scheme.Modules.pullback hU.fromSpec).obj M)))
    (f : Γ(X, U))
    [Module Γ(X, U) Γ(M, X.basicOpen f)]
    [IsScalarTower Γ(X, U) Γ(X, X.basicOpen f) Γ(M, X.basicOpen f)] :
    IsLocalizedModule (Submonoid.powers f) (restrictBasicOpenₗ M f) := by
  set j := hU.fromSpec with hj
  have eT : (j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)) = U :=
    (Scheme.Hom.image_top_eq_opensRange j).trans hU.opensRange_fromSpec
  have eB : (j ''ᵁ (PrimeSpectrum.basicOpen f)) = X.basicOpen f := hU.fromSpec_image_basicOpen f
  -- the image section `f_im = σ f` and the `hf'` discharge (rfl)
  set f_im : Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)) :=
    (gammaImageRingEquiv j ⊤) ((Scheme.ΓSpecIso Γ(X, U)).inv f) with hf_im
  have hf' : (gammaImageRingEquiv j ⊤) ((Scheme.ΓSpecIso Γ(X, U)).inv f) = f_im := rfl
  -- `ii : j ''ᵁ D(f) ⟶ j ''ᵁ ⊤` and the core localization over `A = Γ(X, j ''ᵁ ⊤)`
  set ii : (j ''ᵁ (PrimeSpectrum.basicOpen f) : X.Opens) ⟶ j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens) :=
    j.opensFunctor.map (homOfLE (le_top : PrimeSpectrum.basicOpen f ≤ ⊤)) with hii
  letI : Module Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens))
      Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f)) :=
    Module.compHom _ (X.presheaf.map ii.op).hom
  have core : IsLocalizedModule (Submonoid.powers f_im)
      (show Γ(M, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)) →ₗ[Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens))]
          Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f)) from restrictₗ M ii) :=
    section_localization_hfr_aux_general M j hP1 f_im f hf'
  -- the ring iso `ρ : Γ(X, j ''ᵁ ⊤) ≃+* Γ(X, U)`
  haveI : IsIso (X.presheaf.map (eqToHom eT.symm).op) := inferInstance
  set ρ : Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)) ≃+* Γ(X, U) :=
    (asIso (X.presheaf.map (eqToHom eT.symm).op)).commRingCatIsoToRingEquiv with hρ
  -- `ρ (σ f) = f`, the crux coherence
  have hρf : ρ f_im = f := by
    have hcrux := fromSpec_image_top_section_coherence hU eT
    change (X.presheaf.map (eqToHom eT.symm).op).hom f_im = f
    rw [hcrux, hf_im, CommRingCat.comp_apply]
    change (Scheme.ΓSpecIso Γ(X, U)).hom.hom ((j.appIso ⊤).hom.hom
        ((j.appIso ⊤).inv.hom ((Scheme.ΓSpecIso Γ(X, U)).inv.hom f))) = f
    rw [Iso.inv_hom_id_apply, Iso.inv_hom_id_apply]
  -- additive isos `e₁ : Γ(M, j ''ᵁ ⊤) ≃+ Γ(M, U)`, `e₂ : Γ(M, j ''ᵁ D(f)) ≃+ Γ(M, X.basicOpen f)`
  haveI : IsIso (M.presheaf.map (eqToHom eT.symm).op) := inferInstance
  haveI : IsIso (M.presheaf.map (eqToHom eB.symm).op) := inferInstance
  set e₁ := (asIso (M.presheaf.map (eqToHom eT.symm).op)).addCommGroupIsoToAddEquiv with he₁def
  set e₂ := (asIso (M.presheaf.map (eqToHom eB.symm).op)).addCommGroupIsoToAddEquiv with he₂def
  -- semilinearity of `e₁`, `e₂` over `ρ`
  have he₁ : ∀ (a : Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)))
      (x : ToType Γ(M, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens))),
      e₁ (a • x) = ρ a • e₁ x := by
    intro a x
    exact Scheme.Modules.map_smul M (eqToHom eT.symm) a x
  have he₂ : ∀ (a : Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)))
      (x : ToType Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f))),
      e₂ (a • x) = ρ a • e₂ x := by
    intro a x
    change (M.presheaf.map (eqToHom eB.symm).op).hom
        ((X.presheaf.map ii.op).hom a • x) = ρ a • e₂ x
    rw [Scheme.Modules.map_smul M (eqToHom eB.symm) ((X.presheaf.map ii.op).hom a) x,
      ← algebraMap_smul Γ(X, X.basicOpen f) (ρ a) (e₂ x)]
    refine congrArg (· • (e₂ x)) ?_
    change (X.presheaf.map (eqToHom eB.symm).op).hom ((X.presheaf.map ii.op).hom a)
      = (X.presheaf.map (homOfLE (X.basicOpen_le f)).op).hom (ρ a)
    change ((X.presheaf.map ii.op) ≫ (X.presheaf.map (eqToHom eB.symm).op)).hom a
      = ((X.presheaf.map (eqToHom eT.symm).op) ≫
          (X.presheaf.map (homOfLE (X.basicOpen_le f)).op)).hom a
    rw [← X.presheaf.map_comp, ← X.presheaf.map_comp]
    exact congrArg (fun m => (X.presheaf.map m).hom a) (Subsingleton.elim _ _)
  -- the intertwining `restrictBasicOpenₗ M f (e₁ x) = e₂ (g x)`
  have hh : ∀ x, restrictBasicOpenₗ M f (e₁ x)
      = e₂ ((show Γ(M, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)) →ₗ[Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens))]
          Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f)) from restrictₗ M ii) x) := by
    intro x
    change (M.presheaf.map (homOfLE (X.basicOpen_le f)).op).hom
        ((M.presheaf.map (eqToHom eT.symm).op).hom x)
      = (M.presheaf.map (eqToHom eB.symm).op).hom ((M.presheaf.map ii.op).hom x)
    change ((M.presheaf.map (eqToHom eT.symm).op) ≫
          (M.presheaf.map (homOfLE (X.basicOpen_le f)).op)).hom x
      = ((M.presheaf.map ii.op) ≫ (M.presheaf.map (eqToHom eB.symm).op)).hom x
    rw [← M.presheaf.map_comp, ← M.presheaf.map_comp]
    exact congrArg (fun m => (M.presheaf.map m).hom x) (Subsingleton.elim _ _)
  -- assemble bridge (I)
  haveI := core
  have RESULT : IsLocalizedModule ((Submonoid.powers f_im).map (ρ : _ →+* Γ(X, U)))
      (restrictBasicOpenₗ M f) :=
    isLocalizedModule_of_ringEquiv_semilinear ρ (Submonoid.powers f_im)
      (show Γ(M, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens)) →ₗ[Γ(X, j ''ᵁ (⊤ : (Spec Γ(X, U)).Opens))]
          Γ(M, j ''ᵁ (PrimeSpectrum.basicOpen f)) from restrictₗ M ii)
      e₁ e₂ he₁ he₂ (restrictBasicOpenₗ M f) hh
  have key : (Submonoid.powers f_im).map (ρ : _ →+* Γ(X, U)) = Submonoid.powers f := by
    rw [Submonoid.map_powers]; exact congrArg Submonoid.powers hρf
  rwa [key] at RESULT

/-! ## Project-local Mathlib supplement — pullback of QC along an open immersion (gap2, Piece A)

Route-1 chain L1–L6 building `isQuasicoherent_pullback_fromSpec`: the pullback of a quasi-coherent
sheaf of modules along the affine immersion `hU.fromSpec : Spec Γ(X, U) → X` is again quasi-coherent.
This is the QC-pullback input the gap2 final close `isLocalizedModule_basicOpen` feeds to gap1
(`isIso_fromTildeΓ_of_isQuasicoherent`). -/

/-- **(Piece A, L1) The inverse slice-equivalence functor sends `unit` to `unit`.**
Dual to `overRestrictUnitIso`: the inverse functor of `overRestrictEquiv V` carries the
structure-sheaf (unit) module of the open subscheme `V.toScheme` to the unit module of the
over-site `X.ringCatSheaf.over V`. Built by transport across the equivalence: apply the inverse
functor to `(overRestrictUnitIso V).symm`, then collapse the `functor ⋙ inverse` round trip via the
unit isomorphism of the equivalence. This avoids the `unitToPushforwardObjUnit`/`IsContinuous`
coercion friction of a direct construction. Project-local. -/
noncomputable def overRestrictUnitIsoInv (V : X.Opens) :
    (overRestrictEquiv V).inverse.obj (SheafOfModules.unit V.toScheme.ringCatSheaf) ≅
      SheafOfModules.unit (X.ringCatSheaf.over V) :=
  (overRestrictEquiv V).inverse.mapIso (overRestrictUnitIso V).symm ≪≫
    (overRestrictEquiv V).unitIso.symm.app _

/-- **(Piece A, L2) Geometric presentation back-transported to a slice presentation.**
Dual to `overRestrictPresentation`: a presentation of the geometric pullback `(V.ι^*) M` yields a
presentation of the abstract Grothendieck slice `M.over V`. Transport the given presentation across
`(overRestrictPullbackIso V M).inv` (`Presentation.ofIsIso`), `Presentation.map` along the inverse
slice-equivalence functor (using `overRestrictUnitIsoInv V`), then collapse the round trip across the
equivalence unit iso. Project-local. -/
noncomputable def overRestrictPresentationInv (V : X.Opens) (M : X.Modules)
    (P : ((Scheme.Modules.pullback V.ι).obj M).Presentation) : (M.over V).Presentation :=
  SheafOfModules.Presentation.ofIsIso.{u}
    ((overRestrictEquiv V).unitIso.symm.app (M.over V)).hom
    (SheafOfModules.Presentation.map.{u}
      (SheafOfModules.Presentation.ofIsIso.{u} (overRestrictPullbackIso V M).inv P)
      (overRestrictEquiv V).inverse (overRestrictUnitIsoInv V))

/-- **(Piece A helper) Pullback along an open immersion sends `unit` to `unit`.**
For an open immersion `k : A ⟶ B`, the pullback functor `pullback k` carries the structure-sheaf
(unit) module of `B` to that of `A`. The canonical comparison `pullbackObjUnitToUnit` is an iso
because the site functor `Opens.map k.base` is `Final` — it is a right adjoint, since `k.base` is an
open map (`IsOpenMap.adjunction`). Generalizes `pullbackSchemeIsoUnitIso` from isos to open
immersions. Project-local. -/
noncomputable def pullbackOpenImmersionUnitIso {A B : Scheme.{u}} (k : A ⟶ B) [IsOpenImmersion k] :
    (SheafOfModules.pullback k.toRingCatSheafHom).obj (SheafOfModules.unit B.ringCatSheaf) ≅
      SheafOfModules.unit A.ringCatSheaf := by
  haveI hopen : IsOpenMap k.base := k.isOpenEmbedding.isOpenMap
  haveI : (Opens.map k.base).Final :=
    haveI : (Opens.map k.base).IsRightAdjoint := hopen.adjunction.isRightAdjoint
    inferInstance
  haveI : (SheafOfModules.pushforward (k.toRingCatSheafHom)).IsRightAdjoint := inferInstance
  exact asIso (SheafOfModules.pullbackObjUnitToUnit (k.toRingCatSheafHom))

end Scheme.Modules

end BasicOpenPresentationDescent

end AlgebraicGeometry
