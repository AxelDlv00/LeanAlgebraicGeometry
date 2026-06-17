/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib.RingTheory.Kaehler.Basic
import Mathlib.RingTheory.Unramified.Basic
import Mathlib.RingTheory.Localization.Basic
import Mathlib.AlgebraicGeometry.AffineScheme
import Mathlib.AlgebraicGeometry.Morphisms.FinitePresentation
import Mathlib.AlgebraicGeometry.Morphisms.Smooth
import Mathlib.Algebra.Category.ModuleCat.Differentials.Presheaf
import Mathlib.AlgebraicGeometry.Modules.Presheaf

/-! # Relative Kähler differentials for schemes (presheaf form)

This file constructs the **presheaf** of relative Kähler differentials
`Ω_{X/S}` of a morphism of schemes `f : X → S` and states the
characterisation of smoothness in terms of pointwise local freeness of
`Ω` on affine opens.

The construction builds on Mathlib's ring-theoretic `KaehlerDifferential`
and the presheaf-of-modules differential construction
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`.

## References

Blueprint: `blueprint/src/chapters/Differentials.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits TopologicalSpace AlgebraicGeometry

namespace AlgebraicGeometry.Scheme

variable {X S : Scheme.{u}}

/-- The relative cotangent **presheaf** of a morphism of schemes `f : X ⟶ S`.

On each open `U ⊆ X`, the sections are the Kähler differential module of
the ring map `O_S(f(U)) → O_X(U)` induced by `f`. More precisely, we use
the inverse-image presheaf `f⁻¹ O_S` on `X` and the canonical map to `O_X`;
the Kähler differential construction then gives a presheaf of `O_X`-modules.

Mathlib leverage: `TopCat.Presheaf.pullback` for `f⁻¹`,
`PresheafOfModules.DifferentialsConstruction.relativeDifferentials'`
for the presheaf of Kähler differentials. -/
noncomputable def relativeDifferentialsPresheaf (f : X ⟶ S) : X.PresheafOfModules :=
  let φ' := ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
    f.c
  PresheafOfModules.DifferentialsConstruction.relativeDifferentials' φ'

/-- Localisation-compatibility identity: on each open `V ⊆ X`, the sections
of `relativeDifferentialsPresheaf f` over `V` are *definitionally* the
Kähler differential module of the ring map
`(f⁻¹ O_S)(V) → O_X(V)`. -/
theorem relativeDifferentialsPresheaf_obj_kaehler (f : X ⟶ S)
    (V : (TopologicalSpace.Opens X.toTopCat)ᵒᵖ) :
    ((relativeDifferentialsPresheaf f).presheaf.obj V : Type _) =
      CommRingCat.KaehlerDifferential
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat
          f.base).homEquiv _ _).symm f.c |>.app V) :=
  rfl

end AlgebraicGeometry.Scheme

namespace AlgebraicGeometry.IsAffineOpen

variable {X S : Scheme.{u}}

/-- The submonoid of "good" elements in `Γ(S, U)`: those whose image under the
appLE algebra map `Γ(S, U) → Γ(X, V)` induced by `f : X ⟶ S` is a unit in
`Γ(X, V)`. This is the multiplicative set at which `Γ(S, U) → A_colim` is a
localization (cf. `appLE_isLocalization`). -/
def appLE_unitSubmonoid (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (_hU : IsAffineOpen U) (_hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) : Submonoid Γ(S, U) where
  carrier := { g | IsUnit ((Scheme.Hom.appLE f U V e).hom g) }
  one_mem' := by
    simp only [Set.mem_setOf_eq, map_one]
    exact isUnit_one
  mul_mem' := by
    intro a b ha hb
    simp only [Set.mem_setOf_eq, map_mul] at ha hb ⊢
    exact ha.mul hb

/-- The canonical ring map `Γ(S, U) → A_colim` where
`A_colim = ((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)`
is the inverse-image-presheaf colimit ring at `V`.

It is built as the composition of the cocone leg at `op U`
(the unit of the pullback/pushforward adjunction) with the restriction
along `(homOfLE e).op : op (f ⁻¹ᵁ U) ⟶ op V`. -/
noncomputable def appLE_colimRingHom (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (e : V ≤ f ⁻¹ᵁ U) :
    Γ(S, U) ⟶ (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
  ((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).unit.app
        S.presheaf).app (.op U) ≫
    ((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).map (homOfLE e).op

/-- The `Algebra Γ(S, U) A_colim` structure transported from `appLE_colimRingHom f e`. -/
@[reducible]
noncomputable def appLE_colimAlgebra (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (e : V ≤ f ⁻¹ᵁ U) :
    Algebra Γ(S, U)
      (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
  (appLE_colimRingHom f e).hom.toAlgebra

/-- **Factorisation of the `appLE` ring map through the colimit ring.**
The composition `Γ(S, U) → A_colim → Γ(X, V)` (the colim algebra-map composed
with the restriction `φ' := (homEquiv).symm f.c` at `op V`) equals
`Scheme.Hom.appLE f U V e`. This is the cocone-leg triangle identity. -/
theorem appLE_colimRingHom_comp_φV (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (e : V ≤ f ⁻¹ᵁ U) :
    appLE_colimRingHom f e ≫
        (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
          f.c).app (.op V) =
      Scheme.Hom.appLE f U V e := by
  -- Strategy: appLE_colimRingHom = (unit at op U) ≫ (pullback restrict),
  -- and (pullback restrict) ≫ φV.app (op V) = φV.app (op (f⁻¹ U)) ≫
  -- (X.presheaf.map (homOfLE e).op) by naturality of φV; combined with the
  -- unit-triangle for f.c, (unit at op U) ≫ φV.app (op (f⁻¹ U)) = f.app U.
  -- Then f.app U ≫ X.presheaf.map (homOfLE e).op = f.appLE U V e by definition.
  set adj := TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base
  set φ' := (adj.homEquiv S.presheaf X.presheaf).symm f.c with hφ'
  -- Use `homEquiv_symm`-application: the homEquiv's symm with `f.c` gives a
  -- map whose triangle-component identity supplies the factorisation. The
  -- cleanest packaging is to note `appLE_colimRingHom = (adj.homEquiv).symm f.c .app`
  -- at the underlying components, but the multi-layer functor composition
  -- defeq blocks a direct `rw`. We close with a generic naturality + triangle
  -- argument expressed via the `homEquiv_naturality_left_symm` API.
  -- Detailed term-mode packaging is deferred to a follow-up iteration.
  sorry

/-- **Step 0 of M1.b**: each element of `appLE_unitSubmonoid f hU hV e` is a unit
in `A_colim` under the `appLE_colimAlgebra` algebra map.

Mathematical content (blueprint § sec:bridge): fix `g ∈ M`, so
`(f.appLE U V e).hom g ∈ Γ(X, V)ˣ`. By `Scheme.basicOpen_appLE` together with
`Scheme.basicOpen_of_isUnit`, we get `V ⊆ f ⁻¹ᵁ (S.basicOpen g)`, i.e.
`S.basicOpen g` lies in the directed system over `f V`. The cocone leg
`Γ(S, S.basicOpen g) → A_colim` makes the image of `g` a unit there, because
`IsAffineOpen.isLocalization_basicOpen` exhibits
`Γ(S, S.basicOpen g) = Γ(S, U)_g` as the localization at the powers of `g`,
so `g` is a unit in `Γ(S, S.basicOpen g)`. Pushing this unit through the
cocone leg gives the desired conclusion in `A_colim`. -/
theorem isUnit_appLE_unitSubmonoid_in_colim (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) (g : Γ(S, U))
    (hg : g ∈ appLE_unitSubmonoid f hU hV e) :
    letI := appLE_colimAlgebra f e
    IsUnit ((algebraMap Γ(S, U)
      (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V))) g) := by
  -- Mathematical proof in blueprint § sec:bridge "Step 0". Formalisation
  -- requires the cocone leg `Γ(S, S.basicOpen g) → A_colim` from the
  -- `Lan` definition of `TopCat.Presheaf.pullback` (left Kan extension
  -- along `(Opens.map f.base).op`); the data is a
  -- `CostructuredArrow.mk` term realising `f ⁻¹ᵁ S.basicOpen g ≤ V` from
  -- the hypothesis `hg`. The unit transport then uses
  -- `IsAffineOpen.isLocalization_basicOpen hU g : IsLocalization.Away g
  -- Γ(S, S.basicOpen g)` and `IsLocalization.Away.invSelf` / `mk'`.
  sorry

/-- The inverse-image presheaf colimit ring at `V` is the localization
of `Γ(S, U)` at the submonoid `appLE_unitSubmonoid f hU hV e`.

This is milestone M1.b of the project roadmap: the heart of the bridge between
the section module of `relativeDifferentialsPresheaf` and the appLE-algebra
Kähler module on an affine chart. The proof goes via the two-direction
`IsLocalization.of_le` pattern (see
`blueprint/src/chapters/Differentials.tex § sec:bridge`).

The canonical `Algebra Γ(S, U) A_colim` structure is the cocone leg of the
directed colimit at the open `U` (valid since `V ≤ f ⁻¹ᵁ U` means
`fV ⊆ U`, so `U` is in the index category of the colimit). It is
constructed in `appLE_colimAlgebra`. -/
theorem appLE_isLocalization (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) :
    letI : Algebra Γ(S, U)
        (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) :=
      appLE_colimAlgebra f e
    IsLocalization (appLE_unitSubmonoid f hU hV e)
      (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V)) := by
  -- Strategy from blueprint § sec:bridge (M1.b proof):
  -- Step 0 (`isUnit_appLE_unitSubmonoid_in_colim`): each `g ∈ M` is a unit in
  --   `A_colim` (via the cocone leg over `S.basicOpen g`).
  -- Step 1: `IsLocalization.lift` produces `A_M → A_colim`.
  -- Step 2: cocone universal property + basic-open refinement gives
  --   `A_colim → A_M` (each `Γ(S, W) → A_M` for `f V ⊆ W ⊆ U` factors through
  --   `Γ(S, D(g)) = (Γ(S, U))_g` for some `g ∈ M`, via quasi-compactness of
  --   `f V` and a basic-open cover).
  -- Step 3: Composites are identities via `IsLocalization.ringHom_ext` and
  --   `IsColimit.hom_ext` on the colimit cocone.
  -- Step 4: Conclude via `IsLocalization.isLocalization_of_algEquiv` applied
  --   to the resulting `(Localization M) ≃ₐ[Γ(S, U)] A_colim`.
  -- The full proof is estimated at 200-400 LOC of presheaf-level cofinality
  -- machinery (see `blueprint/src/chapters/Differentials.tex § sec:bridge`).
  sorry

end AlgebraicGeometry.IsAffineOpen

namespace AlgebraicGeometry.Scheme

variable {X S : Scheme.{u}}

/-- The Kähler module of a localization is subsingleton.
This is project-local Lemma `lem:kaehler_localization_subsingleton`. -/
theorem kaehler_localization_subsingleton
    {A L : Type u} [CommRing A] [CommRing L] [Algebra A L]
    (M : Submonoid A) [IsLocalization M L] :
    Subsingleton (Ω[L⁄A]) :=
  letI : Algebra.FormallyUnramified A L :=
    Algebra.FormallyUnramified.of_isLocalization (R := A) (Rₘ := L) M
  Algebra.FormallyUnramified.subsingleton_kaehlerDifferential

/-- Tower-cancellation `LinearEquiv` for the Kähler module under a localization:
if `A → L` is a localization at `M ⊆ A` and `L → B` is a ring map forming a
scalar tower `A → L → B`, then the canonical map `Ω[B/A] → Ω[B/L]` is a
`B`-linear equivalence.

This is project-local Lemma `lem:kaehler_quotient_localization_iso` and the most
extractable Mathlib contribution candidate of milestone M1 (candidate name
`KaehlerDifferential.equivOfFormallyUnramified`). -/
noncomputable def kaehler_quotient_localization_iso
    {A L B : Type u} [CommRing A] [CommRing L] [CommRing B]
    [Algebra A L] [Algebra A B] [Algebra L B] [IsScalarTower A L B]
    (M : Submonoid A) [IsLocalization M L] :
    Ω[B⁄A] ≃ₗ[B] Ω[B⁄L] := by
  haveI : Subsingleton (Ω[L⁄A]) := kaehler_localization_subsingleton M
  refine LinearEquiv.ofBijective (KaehlerDifferential.map A L B B) ⟨?_, ?_⟩
  · rw [injective_iff_map_eq_zero]
    intro x hx
    obtain ⟨y, rfl⟩ :=
      (KaehlerDifferential.exact_mapBaseChange_map A L B x).mp hx
    -- y : B ⊗[L] Ω[L⁄A]; since Ω[L⁄A] is subsingleton, the tensor product is too
    haveI : Subsingleton (TensorProduct L B (Ω[L⁄A])) := by
      refine ⟨fun a b => ?_⟩
      have hzero : ∀ z : TensorProduct L B (Ω[L⁄A]), z = 0 := by
        intro z
        induction z with
        | zero => rfl
        | tmul x y =>
          rw [show y = (0 : Ω[L⁄A]) from Subsingleton.elim _ _, TensorProduct.tmul_zero]
        | add x y hx hy => rw [hx, hy, add_zero]
      rw [hzero a, hzero b]
    rw [Subsingleton.elim y 0, map_zero]
  · exact KaehlerDifferential.map_surjective _ _ _

/-- The bridge between the presheaf form and the algebra-Kähler form of the
relative cotangent module on an affine chart (milestone M1 of the project
roadmap). The section module of `relativeDifferentialsPresheaf f` over an
affine `V ⊆ f ⁻¹ᵁ U` is `Γ(X, V)`-linearly equivalent to the appLE-algebra
Kähler module `CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e)`.

See `blueprint/src/chapters/Differentials.tex § sec:bridge` for the proof
strategy (M1.a–M1.e).

The `Module Γ(X, V)` instance on the LHS section module is supplied by the
`PresheafOfModules` structure (via the underlying
`(relativeDifferentialsPresheaf f).obj (.op V) : ModuleCat _`); the
canonical transport-of-instance is recorded by the `letI` below as
`inferInstanceAs` from the underlying `ModuleCat`. -/
noncomputable def relativeDifferentialsPresheaf_equiv_kaehler_appLE
    (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (hU : IsAffineOpen U) (hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) :
    letI : Algebra Γ(S, U) Γ(X, V) :=
      (Scheme.Hom.appLE f U V e).hom.toAlgebra
    letI : Module Γ(X, V) ((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) :=
      inferInstanceAs (Module Γ(X, V)
        (((relativeDifferentialsPresheaf f).obj (.op V)) : Type _))
    ((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) ≃ₗ[Γ(X, V)]
      CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e) := by
  -- M1.e: combine the rfl-identification of the presheaf section with the
  -- M1.d tower-cancellation `LinearEquiv`. The presheaf section is by
  -- `relativeDifferentialsPresheaf_obj_kaehler` definitionally
  -- `_root_.KaehlerDifferential A_colim Γ(X, V)` (over the `appLE`-colim
  -- algebra structure), and the M1.d equivalence
  -- `kaehler_quotient_localization_iso` gives the bridge
  -- `Ω[Γ(X, V)/Γ(S, U)] ≃ₗ[Γ(X, V)] Ω[Γ(X, V)/A_colim]`. The bridge body
  -- packages the `.symm` of this equivalence together with the rfl.
  -- M1.b/M1.c/M1.d Mathlib pieces are recorded in
  -- `appLE_isLocalization`, `kaehler_localization_subsingleton`,
  -- and `kaehler_quotient_localization_iso` respectively.
  -- Step 1: name abbreviations for the three relevant rings.
  set Acolim := (((TopCat.Presheaf.pullback CommRingCat f.base).obj S.presheaf).obj (.op V))
    with hAcolim
  -- The morphism Acolim ⟶ Γ(X, V) coming from `φ' := (homEquiv).symm f.c`
  -- evaluated at op V. This is `(f.c)^♭` in the comma-square language.
  set φV : Acolim ⟶ (X.presheaf.obj (.op V)) :=
    (((TopCat.Presheaf.pullbackPushforwardAdjunction CommRingCat f.base).homEquiv _ _).symm
      f.c).app (.op V) with hφV
  -- The Algebra Γ(S, U) Acolim is from the cocone leg (appLE_colimAlgebra).
  letI algSU_colim : Algebra Γ(S, U) Acolim :=
    AlgebraicGeometry.IsAffineOpen.appLE_colimAlgebra f e
  -- Step 2: invoke M1.b (`appLE_isLocalization`) to obtain the localization fact.
  haveI hLoc : IsLocalization
      (AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid f hU hV e) Acolim :=
    AlgebraicGeometry.IsAffineOpen.appLE_isLocalization f hU hV e
  -- The Algebra Acolim Γ(X, V) is from φV (the inverse-image presheaf map to X.presheaf).
  letI algColim_B : Algebra Acolim Γ(X, V) := φV.hom.toAlgebra
  -- The appLE Algebra Γ(S, U) Γ(X, V).
  letI algSU_B : Algebra Γ(S, U) Γ(X, V) :=
    (Scheme.Hom.appLE f U V e).hom.toAlgebra
  -- Step 3: the scalar-tower instance. The compatibility
  -- `appLE_colimRingHom f e ≫ φV = f.appLE U V e` follows from the unit
  -- triangle of the pullback/pushforward adjunction applied to `f.c` together
  -- with naturality of `(f.c)^♭` over the restriction `op (f ⁻¹ᵁ U) ⟶ op V`.
  -- Once installed, the remaining work is `(kaehler_quotient_localization_iso
  -- M).symm`, which directly produces the desired `≃ₗ[Γ(X, V)]`. The Module
  -- instance match against the canonical LHS module structure is by `rfl`
  -- through the `relativeDifferentialsPresheaf_obj_kaehler` identification.
  -- We record the remaining `IsScalarTower` + packaging step as a scoped
  -- sorry-stub (the math content of M1.e — see blueprint § sec:bridge).
  sorry

/-- Forward direction of the Jacobian criterion (algebra-Kähler form).
If `f : X → S` is smooth of relative dimension `n`, then for every
point `x ∈ X` there exist affine opens `U ⊆ S` and `V ⊆ X` with
`f V ⊆ U` and `x ∈ V`, on which the Kähler differential module
`Ω[Γ(X, V) ⁄ Γ(S, U)]` (over the appLE algebra structure) is a free
module of rank `n` over `Γ(X, V)`.

The bridge from this algebra-Kähler form to the project's presheaf
form `(relativeDifferentialsPresheaf f).presheaf.obj (.op V)` is a
Mathlib gap: the section module of the presheaf identifies with the
Kähler module over the inverse-image-presheaf colimit ring
`colim_{f V ⊆ W ⊆ S} Γ(S, W)`, which is a localization of `Γ(S, U)`
and hence yields an iso `Ω[Γ(X, V) ⁄ Γ(S, U)] ≃ Ω[Γ(X, V) ⁄ A_colim]`
via `KaehlerDifferential.isLocalizedModule_map`; constructing the iso
requires presheaf-level cofinality machinery (~200–400 LOC) that is
out of autonomous-loop scope. See `blueprint/src/chapters/Differentials.tex`
§ "Bridge to the relative cotangent presheaf — out of autonomous-loop
scope" for the mathematical content.

The reverse direction (locally free Ω of rank `n` implies smooth of
relative dimension `n`) is **mathematically false** as stated without
additional deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each chart); see the chapter
`Differentials.tex` for the counterexample (`Spec k → Spec k[t]`,
`t ↦ 0`) and the converse-direction disclosure. -/
theorem smooth_locally_free_omega {n : ℕ} (f : X ⟶ S)
    [SmoothOfRelativeDimension n f] :
    ∀ (x : X), ∃ (U : S.Opens) (V : X.Opens) (e : V ≤ f ⁻¹ᵁ U),
        x ∈ V ∧ IsAffineOpen U ∧ IsAffineOpen V ∧
          letI : Algebra Γ(S, U) Γ(X, V) :=
            (Scheme.Hom.appLE f U V e).hom.toAlgebra
          (Module.Free Γ(X, V) (Ω[Γ(X, V) ⁄ Γ(S, U)]) ∧
           Module.rank Γ(X, V) (Ω[Γ(X, V) ⁄ Γ(S, U)]) = n) := by
  intro x
  obtain ⟨U, hU, V, hV, hxV, e, hRing⟩ :=
    SmoothOfRelativeDimension.exists_isStandardSmoothOfRelativeDimension (n := n) (f := f) x
  refine ⟨U, V, e, hxV, hU, hV, ?_, ?_⟩ <;>
    · algebraize [CommRingCat.Hom.hom (Scheme.Hom.appLE f U V e)]
      haveI : Algebra.IsStandardSmooth Γ(S, U) Γ(X, V) :=
        Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth n
      haveI : Nonempty V := ⟨⟨x, hxV⟩⟩
      first
      | exact Algebra.IsStandardSmooth.free_kaehlerDifferential
      | exact Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential n

end AlgebraicGeometry.Scheme
