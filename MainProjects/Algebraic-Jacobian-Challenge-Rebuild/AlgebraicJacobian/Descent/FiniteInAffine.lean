/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Descent.SemilinearAction
import Mathlib.AlgebraicGeometry.Morphisms.Affine

/-!
# Finite subsets in affine opens

`Scheme.FiniteInAffine X` is the action-free geometric condition behind the
finite-Galois quotient construction: every finite subset of `X` lies in one
affine open.  For a finite Galois extension, this immediately supplies
`SemilinearGalAction.OrbitsInAffineOpen` for every action on `X`.

The property is stated independently of Picard data.  In particular, it is a
conclusion to be proved for a representing scheme, not an additional field of
the representability datum.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open AlgebraicJacobian.GaloisDescent

namespace AlgebraicGeometry.Scheme

/-- Every finite subset of a scheme is contained in a single affine open. -/
def FiniteInAffine (X : Scheme.{u}) : Prop :=
  ∀ s : Set X, s.Finite → ∃ U : X.affineOpens, s ⊆ U.1

/-- An affine scheme satisfies `FiniteInAffine`. -/
theorem finiteInAffine_of_isAffine (X : Scheme.{u}) [IsAffine X] :
    FiniteInAffine X :=
  fun _ _ ↦ ⟨⟨⊤, isAffineOpen_top X⟩, fun _ _ ↦ trivial⟩

/-- `FiniteInAffine` is invariant under isomorphism. -/
theorem finiteInAffine_of_iso {X Y : Scheme.{u}} (e : X ≅ Y)
    (h : FiniteInAffine X) : FiniteInAffine Y := by
  intro s hs
  obtain ⟨U, hU⟩ := h (e.hom.base ⁻¹' s)
    (hs.preimage (TopCat.homeoOfIso ((Scheme.forgetToTop).mapIso e)).injective.injOn)
  refine ⟨⟨e.hom ''ᵁ U.1, U.2.image_of_isOpenImmersion e.hom⟩, ?_⟩
  intro y hy
  exact ⟨e.inv.base y, hU (by simpa using hy), by simp⟩

/-- `FiniteInAffine` descends along an affine morphism. -/
theorem finiteInAffine_of_isAffineHom {X Y : Scheme.{u}} (f : X ⟶ Y)
    [IsAffineHom f] (h : FiniteInAffine Y) : FiniteInAffine X := by
  intro s hs
  obtain ⟨U, hU⟩ := h (f.base '' s) (hs.image _)
  exact ⟨⟨f ⁻¹ᵁ U.1, U.2.preimage f⟩, fun x hx ↦ hU ⟨x, hx, rfl⟩⟩

/-- An object affine over a field spectrum satisfies `FiniteInAffine`. -/
theorem finiteInAffine_left_of_isAffineHom {k : Type u} [Field k]
    (X : Over (Spec (CommRingCat.of k))) [IsAffineHom X.hom] :
    FiniteInAffine X.left :=
  haveI := isAffine_of_isAffineHom X.hom
  finiteInAffine_of_isAffine _

/-- `FiniteInAffine` supplies the orbit condition for every finite-Galois
semilinear action on the scheme. -/
theorem orbitsInAffineOpen_of_finiteInAffine
    {K L : Type u} [Field K] [Field L] [Algebra K L]
    [FiniteDimensional K L] [IsGalois K L]
    {X : Scheme.{u}} {f : X ⟶ Spec (CommRingCat.of L)}
    (rho : SemilinearGalAction K L X f) (h : FiniteInAffine X) :
    rho.OrbitsInAffineOpen where
  exists_affineOpen x := by
    obtain ⟨U, hU⟩ :=
      h (Set.range fun gamma : L ≃ₐ[K] L ↦ (rho.act gamma).hom.base x)
        (Set.finite_range _)
    exact ⟨U, fun gamma ↦ hU ⟨gamma, rfl⟩⟩

end AlgebraicGeometry.Scheme
