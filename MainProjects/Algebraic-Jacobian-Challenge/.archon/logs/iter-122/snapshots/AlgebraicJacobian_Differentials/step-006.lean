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
`(relativeDifferentialsPresheaf f).obj (.op V) : ModuleCat _`); in the
stub we introduce it via a `sorry`-ed `letI` so the type checks, and the
prover will replace this with the canonical transport-of-instance when
they refine the construction. -/
noncomputable def relativeDifferentialsPresheaf_equiv_kaehler_appLE
    (f : X ⟶ S)
    {U : S.Opens} {V : X.Opens} (_hU : IsAffineOpen U) (_hV : IsAffineOpen V)
    (e : V ≤ f ⁻¹ᵁ U) :
    letI : Algebra Γ(S, U) Γ(X, V) :=
      (Scheme.Hom.appLE f U V e).hom.toAlgebra
    letI : Module Γ(X, V) ((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) :=
      inferInstanceAs (Module Γ(X, V)
        (((relativeDifferentialsPresheaf f).obj (.op V)) : Type _))
    ((relativeDifferentialsPresheaf f).presheaf.obj (.op V)) ≃ₗ[Γ(X, V)]
      CommRingCat.KaehlerDifferential (Scheme.Hom.appLE f U V e) := by
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
