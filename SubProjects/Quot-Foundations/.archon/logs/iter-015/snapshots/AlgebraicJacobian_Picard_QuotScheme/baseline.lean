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

/-! ## Project-local Mathlib supplement — graded Hilbert–Serre rationality -/

namespace AlgebraicGeometry

open PowerSeries Polynomial in
private lemma coeff_invOneSubPow_one_mul (F : ℚ⟦X⟧) (n : ℕ) :
    ((PowerSeries.invOneSubPow ℚ 1).val * F).coeff n
      = ∑ k ∈ Finset.range (n + 1), F.coeff k := by
  have h1 : (PowerSeries.invOneSubPow ℚ 1).val = PowerSeries.mk (fun _ => (1 : ℚ)) := by
    have := PowerSeries.invOneSubPow_val_succ_eq_mk_add_choose (S := ℚ) (d := 0)
    simpa using this
  rw [h1, PowerSeries.coeff_mul, Finset.Nat.sum_antidiagonal_eq_sum_range_succ_mk]
  simp only [PowerSeries.coeff_mk, one_mul]
  rw [← Finset.sum_range_reflect (fun k => F.coeff k) (n + 1)]
  apply Finset.sum_congr rfl
  intro x _
  congr 1

open PowerSeries Polynomial in
/-- **Antidifference step for rational Hilbert series.** If the first difference
`H (n+1) - H n` is, for `n ≫ 0`, the `n`-th coefficient of the rational series
`q · (1-X)^{-e}`, then `H` itself is, for `n ≫ 0`, the `n`-th coefficient of
`p · (1-X)^{-(e+1)}` for an explicit polynomial `p`. This is the power-series
heart of the inductive step in graded Hilbert–Serre (Stacks 00K1). Project-local:
Mathlib supplies only the converse extraction `Polynomial.existsUnique_hilbertPoly`. -/
private lemma rationalHilbert_antidiff
    (H δ : ℕ → ℚ) (q : Polynomial ℚ) (e N : ℕ)
    (hδ : ∀ n, N < n → δ n = ((q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ e).val).coeff n)
    (hH : ∀ n, N < n → H (n + 1) - H n = δ (n + 1)) :
    ∃ (p : Polynomial ℚ), ∀ n, N < n →
      H n = ((p : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ (e + 1)).val).coeff n := by
  set F : ℚ⟦X⟧ := (q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ e).val with hF
  -- Partial-sum identity: the order-`(e+1)` series accumulates the order-`e` coefficients.
  have hsum : ∀ m, ((q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ (e + 1)).val).coeff m
      = ∑ k ∈ Finset.range (m + 1), F.coeff k := by
    intro m
    have hmul : (q : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ (e + 1)).val
        = (PowerSeries.invOneSubPow ℚ 1).val * F := by
      rw [hF, show (e + 1) = 1 + e from by omega, PowerSeries.invOneSubPow_add, Units.val_mul]
      ring
    rw [hmul, coeff_invOneSubPow_one_mul]
  -- Telescoping `H` from its first differences, expressed via `F`.
  have hstep : ∀ n, N < n → H (n + 1) - H n = F.coeff (n + 1) := by
    intro n hn
    rw [hH n hn, hδ (n + 1) (by omega)]
  have htel : ∀ j, H (N + 1 + j)
      = H (N + 1) + ∑ i ∈ Finset.range j, F.coeff (N + 2 + i) := by
    intro j
    induction j with
    | zero => simp
    | succ j ih =>
        rw [Finset.sum_range_succ, show N + 2 + j = N + 1 + (j + 1) from by omega]
        have hs := hstep (N + 1 + j) (by omega)
        rw [show (N + 1 + j) + 1 = N + 1 + (j + 1) from by omega] at hs
        linarith [hs, ih]
  -- Constant-absorption: a constant function is the order-`(e+1)` coefficient of `C·(1-X)^e`.
  have hCconst : ∀ (c : ℚ),
      c • (PowerSeries.invOneSubPow ℚ 1).val
        = ((Polynomial.C c * (1 - Polynomial.X) ^ e : Polynomial ℚ) : ℚ⟦X⟧)
            * (PowerSeries.invOneSubPow ℚ (e + 1)).val := by
    intro c
    have hkey : (1 - PowerSeries.X : ℚ⟦X⟧) ^ e * (PowerSeries.invOneSubPow ℚ (e + 1)).val
        = (PowerSeries.invOneSubPow ℚ 1).val := by
      rw [Nat.add_comm e 1]
      exact PowerSeries.one_sub_pow_mul_invOneSubPow_val_add_eq_invOneSubPow_val ℚ 1 e
    rw [Polynomial.coe_mul, Polynomial.coe_C, Polynomial.coe_pow, Polynomial.coe_sub,
      Polynomial.coe_one, Polynomial.coe_X, mul_assoc, hkey, PowerSeries.smul_eq_C_mul]
  have hcoeff1 : ∀ m, (PowerSeries.invOneSubPow ℚ 1).val.coeff m = 1 := by
    intro m
    have h1 : (PowerSeries.invOneSubPow ℚ 1).val = PowerSeries.mk (fun _ => (1 : ℚ)) := by
      have := PowerSeries.invOneSubPow_val_succ_eq_mk_add_choose (S := ℚ) (d := 0)
      simpa using this
    rw [h1, PowerSeries.coeff_mk]
  -- Assemble the polynomial numerator.
  set B : ℚ := ∑ k ∈ Finset.range (N + 2), F.coeff k with hB
  set C0 : ℚ := H (N + 1) - B with hC0
  refine ⟨Polynomial.C C0 * (1 - Polynomial.X) ^ e + q, ?_⟩
  intro n hn
  -- Rewrite `H n` via the telescoping identity at `j = n - (N+1)`.
  obtain ⟨j, rfl⟩ : ∃ j, n = N + 1 + j := ⟨n - (N + 1), by omega⟩
  rw [htel j]
  -- The tail sum is an `Ico`-window of `F`.
  have htail : ∑ i ∈ Finset.range j, F.coeff (N + 2 + i)
      = ∑ k ∈ Finset.Ico (N + 2) (N + 2 + j), F.coeff k := by
    rw [Finset.sum_Ico_eq_sum_range]
    simp
  rw [htail]
  -- Split `range (n+1) = range (N+2) ∪ Ico (N+2) (n+1)` in the partial-sum identity.
  have hsplit : ∑ k ∈ Finset.range (N + 1 + j + 1), F.coeff k
      = B + ∑ k ∈ Finset.Ico (N + 2) (N + 2 + j), F.coeff k := by
    rw [hB, Finset.range_eq_Ico, Finset.range_eq_Ico,
      show N + 1 + j + 1 = N + 2 + j from by omega,
      ← Finset.sum_Ico_consecutive _ (Nat.zero_le (N + 2)) (by omega : N + 2 ≤ N + 2 + j)]
  -- Now compute the target coefficient and match.
  rw [show ((Polynomial.C C0 * (1 - Polynomial.X) ^ e + q : Polynomial ℚ) : ℚ⟦X⟧)
        = ((Polynomial.C C0 * (1 - Polynomial.X) ^ e : Polynomial ℚ) : ℚ⟦X⟧) + (q : ℚ⟦X⟧)
      from by push_cast; ring,
    add_mul, map_add, ← hCconst C0]
  rw [show (C0 • (PowerSeries.invOneSubPow ℚ 1).val).coeff (N + 1 + j)
        = C0 * (PowerSeries.invOneSubPow ℚ 1).val.coeff (N + 1 + j)
      from by rw [map_smul]; rfl, hcoeff1, mul_one,
    hsum (N + 1 + j), hsplit, hC0]
  ring

open PowerSeries Polynomial in
/-- Internal predicate for graded Hilbert–Serre: `f : ℕ → ℚ` is, for `n ≫ 0`, the
`n`-th coefficient of the rational power series `p · (1-X)^{-d}` for some numerator
polynomial `p`. The closure lemmas below (`bump`, `sub`, `shiftRight`, `antidiff`,
`ofEventuallyZero`) are the inductive toolkit for the rationality proof. -/
private def IsRatHilb (f : ℕ → ℚ) (d : ℕ) : Prop :=
  ∃ (p : Polynomial ℚ) (N : ℕ), ∀ n, N < n →
    f n = ((p : ℚ⟦X⟧) * (PowerSeries.invOneSubPow ℚ d).val).coeff n

/-- An eventually-zero Hilbert function is rational of order `0` (numerator `0`). -/
private lemma IsRatHilb.ofEventuallyZero {f : ℕ → ℚ} (N : ℕ) (hf : ∀ n, N < n → f n = 0) :
    IsRatHilb f 0 := by
  refine ⟨0, N, fun n hn => ?_⟩
  rw [hf n hn]
  simp

open PowerSeries Polynomial in
/-- The order of a rational Hilbert function may be raised by one (multiply the
numerator by `(1-X)`); this lets two series be brought to a common denominator. -/
private lemma IsRatHilb.bump {f : ℕ → ℚ} {d : ℕ} (h : IsRatHilb f d) :
    IsRatHilb f (d + 1) := by
  obtain ⟨p, N, hp⟩ := h
  refine ⟨p * (1 - Polynomial.X), N, fun n hn => ?_⟩
  rw [hp n hn]
  congr 1
  have hkey : (1 - PowerSeries.X : ℚ⟦X⟧) ^ 1 * (PowerSeries.invOneSubPow ℚ (d + 1)).val
      = (PowerSeries.invOneSubPow ℚ d).val :=
    PowerSeries.one_sub_pow_mul_invOneSubPow_val_add_eq_invOneSubPow_val ℚ d 1
  rw [pow_one] at hkey
  rw [Polynomial.coe_mul, Polynomial.coe_sub, Polynomial.coe_one, Polynomial.coe_X,
    mul_assoc, hkey]

open PowerSeries Polynomial in
/-- Rational Hilbert functions of the same order are closed under pointwise difference. -/
private lemma IsRatHilb.sub {f g : ℕ → ℚ} {d : ℕ} (hf : IsRatHilb f d) (hg : IsRatHilb g d) :
    IsRatHilb (fun n => f n - g n) d := by
  obtain ⟨p, Np, hp⟩ := hf
  obtain ⟨q, Nq, hq⟩ := hg
  refine ⟨p - q, max Np Nq, fun n hn => ?_⟩
  simp only
  rw [hp n (lt_of_le_of_lt (le_max_left _ _) hn), hq n (lt_of_le_of_lt (le_max_right _ _) hn),
    Polynomial.coe_sub, sub_mul, map_sub]

open PowerSeries Polynomial in
/-- Right-shift closure: if `f` is rational of order `d`, so is `n ↦ f (n-1)`
(multiply the numerator by `X`). -/
private lemma IsRatHilb.shiftRight {f : ℕ → ℚ} {d : ℕ} (h : IsRatHilb f d) :
    IsRatHilb (fun n => f (n - 1)) d := by
  obtain ⟨p, N, hp⟩ := h
  refine ⟨Polynomial.X * p, N + 1, fun n hn => ?_⟩
  obtain ⟨m, rfl⟩ : ∃ m, n = m + 1 := ⟨n - 1, by omega⟩
  simp only [Nat.add_sub_cancel]
  rw [hp m (by omega), Polynomial.coe_mul, Polynomial.coe_X, mul_assoc,
    PowerSeries.coeff_succ_X_mul]

/-- The antidifference step, packaged for the predicate: if `g` is rational of order
`e` and `H (n+1) - H n = g (n+1)` eventually, then `H` is rational of order `e+1`. -/
private lemma IsRatHilb.antidiff {H g : ℕ → ℚ} {e N : ℕ} (hg : IsRatHilb g e)
    (hH : ∀ n, N < n → H (n + 1) - H n = g (n + 1)) : IsRatHilb H (e + 1) := by
  obtain ⟨q, Ng, hq⟩ := hg
  obtain ⟨p, hp⟩ := rationalHilbert_antidiff H g q e (max N Ng)
    (fun n hn => hq n (lt_of_le_of_lt (le_max_right _ _) hn))
    (fun n hn => hH n (lt_of_le_of_lt (le_max_left _ _) hn))
  exact ⟨p, max N Ng, hp⟩

/-- **Inductive-step engine for graded Hilbert–Serre (Stacks 00K1).** The entire
power-series side of the inductive step: if the Hilbert function `hM` of `M` has
first difference matching the alternating sum `hC (n+1) - hK n` of the Hilbert
functions of the cokernel `C = M/xM` and kernel `K = ker(x : M → M(1))` — the
content of the degreewise short exact sequence `0 → K_n → M_n → M_{n+1} → C_{n+1} → 0`
— and both `hC, hK` are rational of order `d`, then `hM` is rational of order `d+1`.
The only remaining (graded-algebra) obligation in the rationality proof is to produce
`hK, hC` with this difference identity and apply the induction hypothesis. -/
private lemma IsRatHilb.ofDiffEq {hM hC hK : ℕ → ℚ} {d N : ℕ}
    (hC' : IsRatHilb hC d) (hK' : IsRatHilb hK d)
    (hdiff : ∀ n, N < n → hM (n + 1) - hM n = hC (n + 1) - hK n) :
    IsRatHilb hM (d + 1) := by
  have hg : IsRatHilb (fun n => hC n - hK (n - 1)) d := hC'.sub hK'.shiftRight
  refine IsRatHilb.antidiff (g := fun n => hC n - hK (n - 1)) (N := N) hg ?_
  intro n hn
  simp only [Nat.add_sub_cancel]
  exact hdiff n hn

end AlgebraicGeometry
