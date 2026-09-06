/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtAffMap
import AlgebraicJacobian.Picard.RelPicCoverInjective
import AlgebraicJacobian.Picard.RelPicFaithfullyFlatInjective

/-!
# Faithfully flat injectivity of the affine Picard plus construction

For a proper, geometrically irreducible and geometrically reduced curve, restriction of
an affine Picard plus class along a faithfully flat extension of test rings is injective.
After passing to the tensor product with a representing cover, a plus class is the unit
of its relative Picard representative. Injectivity of the unit and faithfully flat
injectivity of relative Picard classes then reflect triviality of that representative.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))

namespace PicEtAff

/-- A representative becomes a unit after a refinement into the target test algebra. -/
theorem map_mk_eq_unit_of_refinement {A B : Type u} [CommRing A] [CommRing B]
    [Algebra k A] [Algebra k B] [Algebra A B] [IsScalarTower k A B]
    {E : Algebra.EtaleCover A} (x : descentClasses C E) (f : E.Carrier →ₐ[A] B) :
    map C B (mk C E x) = unit C B (relPicAlgMap C (f.restrictScalars k) x) := by
  have hval : (descentBaseChange C B E x : relPic C (overSpec k (E.baseChange B).Carrier))
      = relPicAlgMap C ((Algebra.ofId B (E.baseChange B).Carrier).restrictScalars k)
          (relPicAlgMap C (f.restrictScalars k) x) := by
    rw [descentBaseChange_coe, ← relPicAlgMap_comp]
    exact relPicAlgMap_congr C (E.baseChangeInclude B)
      (((Algebra.ofId B (E.baseChange B).Carrier).restrictScalars A).comp f) x.2
  rw [map_mk, unit_eq_mk C (E.baseChange B) (relPicAlgMap C (f.restrictScalars k) x)]
  exact congrArg (mk C (E.baseChange B)) (Subtype.ext hval)

/-- Faithfully flat restriction is injective on affine Picard plus classes for a proper,
geometrically irreducible and geometrically reduced curve. -/
theorem map_faithfullyFlat_injective {A B : Type u} [CommRing A] [CommRing B]
    [Algebra k A] [Algebra k B] [Algebra A B] [IsScalarTower k A B]
    [IsProper C.hom] [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]
    [Module.FaithfullyFlat A B] : Function.Injective (map (A := A) C B) := by
  rw [injective_iff_map_eq_one]
  intro z hz
  induction z using ind with
  | _ E x =>
    let D := E.Carrier ⊗[A] B
    letI : Algebra B D := Algebra.TensorProduct.rightAlgebra
    haveI : IsScalarTower k B D := .of_algebraMap_eq fun a => by
      rw [IsScalarTower.algebraMap_apply k A D,
        IsScalarTower.algebraMap_apply k A B, IsScalarTower.algebraMap_apply A B D]
    have hD : map C D (mk C E x) = 1 := by
      rw [← map_map C B D, hz, map_one]
    rw [map_mk_eq_unit_of_refinement C x
      (Algebra.TensorProduct.includeLeft : E.Carrier →ₐ[A] D)] at hD
    have hrel : relPicAlgMap C
        ((Algebra.ofId E.Carrier D).restrictScalars k) x = 1 := by
      apply unit_injective C D
      have hinc : (Algebra.TensorProduct.includeLeft : E.Carrier →ₐ[A] D).restrictScalars k
          = (Algebra.ofId E.Carrier D).restrictScalars k := by
        ext a
        exact (Algebra.TensorProduct.algebraMap_apply a).symm
      rw [hinc] at hD
      simpa only [map_one] using hD
    have hx : (x : relPic C (overSpec k E.Carrier)) = 1 := by
      apply relPicAlgMap_faithfullyFlat_injective (A := E.Carrier) (B := D) C
      simpa only [map_one] using hrel
    rw [show x = 1 from Subtype.ext hx, mk_one]

end PicEtAff

end AlgebraicGeometry
