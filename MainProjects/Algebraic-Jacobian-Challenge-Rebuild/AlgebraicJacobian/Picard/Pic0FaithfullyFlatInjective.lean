/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtAffFaithfullyFlatInjective
import AlgebraicJacobian.Picard.Pic0Functor
import Mathlib.AlgebraicGeometry.Morphisms.Affine
import Mathlib.AlgebraicGeometry.Morphisms.Flat

/-!
# Faithfully flat reflection on arbitrary Picard tests

Affine faithfully flat morphisms reflect equality of Picard classes on arbitrary
test schemes. The proof applies affine reflection to the inverse image of each
affine open; it imposes no quasi-compactness condition on the test scheme.
-/

set_option autoImplicit false

universe u

open CategoryTheory

namespace AlgebraicGeometry

attribute [local instance] Over.sectionsAlgebra

/-- The section map above an affine open of an affine faithfully flat morphism
is faithfully flat. -/
theorem Scheme.Hom.faithfullyFlat_app_of_isAffineHom
    {X Y : Scheme.{u}} (f : X ⟶ Y) [IsAffineHom f] [Flat f] [Surjective f]
    (U : Y.Opens) (hU : IsAffineOpen U) : (f.app U).hom.FaithfullyFlat := by
  rw [Scheme.Hom.app_eq_appLE, RingHom.FaithfullyFlat.iff_flat_and_comap_surjective]
  refine ⟨f.flat_appLE hU (hU.preimage f) le_rfl, ?_⟩
  intro p
  obtain ⟨y, hy⟩ := hU.isoSpec.hom.surjective p
  obtain ⟨x, hx⟩ := f.surjective y.1
  have hxU : x ∈ f ⁻¹ᵁ U := by change f x ∈ U; rw [hx]; exact y.2
  refine ⟨(hU.preimage f).primeIdealOf ⟨x, hxU⟩, ?_⟩
  rw [IsAffineOpen.comap_primeIdealOf_appLE U hU _ (hU.preimage f) le_rfl hxU]
  rw [show (⟨f x, hxU⟩ : U) = y from Subtype.ext hx]
  exact hy

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Affine faithfully flat restriction reflects equality of Picard classes on
every test scheme, without a finiteness assumption on the test. -/
theorem picEtMap_affine_faithfullyFlat_injective [GeometricallyReduced C.hom]
    {T T' : Over (Spec (.of k))} (f : T' ⟶ T)
    [IsAffineHom f.left] [Flat f.left] [Surjective f.left] :
    Function.Injective (picEtMap C f) := by
  intro x y hxy
  apply picEt.ext
  intro U
  let V : T'.left.affineOpens := ⟨f.left ⁻¹ᵁ U.1, U.2.preimage f.left⟩
  let phi := Over.appLEAlgHom f U.1 V.1 le_rfl
  have hphi : phi.toRingHom.FaithfullyFlat := by
    simpa only [phi, V, Over.appLEAlgHom, Scheme.Hom.app_eq_appLE] using
      f.left.faithfullyFlat_app_of_isAffineHom U.1 U.2
  letI : Algebra Γ(T.left, U.1) Γ(T'.left, V.1) := phi.toRingHom.toAlgebra
  haveI : IsScalarTower k Γ(T.left, U.1) Γ(T'.left, V.1) :=
    .of_algebraMap_eq fun r => (phi.commutes r).symm
  haveI : Module.FaithfullyFlat Γ(T.left, U.1) Γ(T'.left, V.1) := hphi
  apply PicEtAff.map_faithfullyFlat_injective (B := Γ(T'.left, V.1)) C
  change PicEtAff.mapAlg C phi (x.1 U) = PicEtAff.mapAlg C phi (y.1 U)
  have h := congrArg (fun z : picEt C T' => z.1 V) hxy
  simpa only [picEtMap_val,
    picEtMapVal_eq_mapAlg C f _ (W := V) (V := U) le_rfl] using h

/-- Affine faithfully flat restriction reflects equality of degree-zero classes
on arbitrary test schemes. -/
theorem pic0Map_affine_faithfullyFlat_injective [SmoothOfRelativeDimension 1 C.hom]
    {T T' : Over (Spec (.of k))} (f : T' ⟶ T)
    [IsAffineHom f.left] [Flat f.left] [Surjective f.left] :
    Function.Injective (pic0Map C f) := by
  intro x y hxy
  apply Subtype.ext
  exact picEtMap_affine_faithfullyFlat_injective C f (congrArg Subtype.val hxy)

end AlgebraicGeometry
