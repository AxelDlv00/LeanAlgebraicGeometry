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

/-- Forward direction of the Jacobian criterion (algebra-Kähler form).
If `f : X → S` is smooth of relative dimension `n`, then for every
point `x ∈ X` there exist affine opens `U ⊆ S` and `V ⊆ X` with
`f V ⊆ U` and `x ∈ V`, on which the Kähler differential module
`Ω[Γ(X, V) ⁄ Γ(S, U)]` (over the appLE algebra structure) is a free
module of rank `n` over `Γ(X, V)`.

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
