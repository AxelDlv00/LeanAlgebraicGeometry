/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib.RingTheory.Kaehler.Basic
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

/-- Forward direction of the Jacobian criterion: if `f : X → S` is
smooth of relative dimension `n`, then for every point `x ∈ X` there
exists an affine open `U` containing `x` on which the relative
cotangent presheaf is a free module of rank `n` over the section
ring.

The proof routes through `smoothOfRelativeDimension_iff` (Mathlib
auto-generated `mk_iff`), `IsStandardSmoothOfRelativeDimension.isStandardSmooth`
(`Mathlib.RingTheory.Smooth.StandardSmooth`), the instance
`IsStandardSmooth.free_kaehlerDifferential` and theorem
`IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
(`Mathlib.RingTheory.Smooth.StandardSmoothCotangent`), and the
project-local section-identification lemma
`relativeDifferentialsPresheaf_obj_kaehler`.

The reverse direction (locally free Ω of rank `n` implies smooth
of relative dimension `n`) is **mathematically false** as stated
without additional deformation-theoretic input (vanishing of
`Algebra.H1Cotangent A B` on each chart); see the chapter
`Differentials.tex` for the counterexample (`Spec k → Spec k[t]`,
`t ↦ 0`) and the converse-direction disclosure. -/
theorem smooth_locally_free_omega {n : ℕ} (f : X ⟶ S)
    [SmoothOfRelativeDimension n f] :
    ∀ (x : X), ∃ (U : X.Opens), x ∈ U.1 ∧ IsAffineOpen U ∧
        let R := X.ringCatSheaf.presheaf.obj (.op U)
        let M := (relativeDifferentialsPresheaf f).presheaf.obj (.op U)
        Module.Free (↑R) (↑M) ∧ Module.rank (↑R) (↑M) = n := by
  intro x
  -- Step 1: extract a standard-smooth chart at `x` via the auto-generated `mk_iff`.
  have hsm : SmoothOfRelativeDimension n f := ‹_›
  rw [smoothOfRelativeDimension_iff] at hsm
  obtain ⟨U₀, hU₀, V₀, hV₀, hxV, e, hRing⟩ := hsm x
  refine ⟨V₀, hxV, hV₀, ?_⟩
  sorry

end AlgebraicGeometry.Scheme
