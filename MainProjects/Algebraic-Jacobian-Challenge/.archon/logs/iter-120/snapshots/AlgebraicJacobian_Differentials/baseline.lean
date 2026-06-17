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
  sorry

end AlgebraicGeometry.Scheme
