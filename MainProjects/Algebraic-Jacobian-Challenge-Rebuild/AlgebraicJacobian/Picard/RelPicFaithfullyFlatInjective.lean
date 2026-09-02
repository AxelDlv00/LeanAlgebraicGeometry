/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.CechKernelLemma

/-!
# Faithfully flat injectivity of relative Picard base change

For a proper, geometrically irreducible and geometrically reduced curve, pullback on the
relative Picard group along a faithfully flat extension of affine test rings is injective.
This is the quotient-level corollary of the Čech kernel lemma: a class that becomes a base
class after pullback already comes from the original base.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory Opposite
open AlgebraicGeometry.Scheme (CechPic)

namespace AlgebraicGeometry

variable {k : Type u} [Field k]
variable {A B : Type u} [CommRing A] [CommRing B]
  [Algebra k A] [Algebra k B] [Algebra A B] [IsScalarTower k A B]
variable (C : Over (Spec (.of k)))

/-- Pullback on the relative Picard group along a faithfully flat extension of affine test
rings is injective for a proper, geometrically irreducible and geometrically reduced curve. -/
theorem relPicAlgMap_faithfullyFlat_injective
    [IsProper C.hom] [GeometricallyIrreducible C.hom]
    [GeometricallyReduced C.hom] [Module.FaithfullyFlat A B] :
    Function.Injective
      (relPicAlgMap C ((Algebra.ofId A B).restrictScalars k)) := by
  rw [injective_iff_map_eq_one]
  intro x hx
  induction x using relPic.ind with
  | mk L =>
    rw [relPicAlgMap, relPicMap_mk] at hx
    have hmem : Scheme.CechPic.map
        (C ◁ Over.overSpecMap ((Algebra.ofId A B).restrictScalars k)).left L
        ∈ picFromBase C (overSpec k B) :=
      (QuotientGroup.eq_one_iff _).mp hx
    obtain ⟨N₀, hN₀⟩ := (mem_picFromBase_iff (C := C)).mp hmem
    obtain ⟨M, hM⟩ := Over.exists_cechPic_map_snd_eq_of_ker C
      (fun E hE => Over.exists_cechPic_map_snd_of_ker_whiskerLeft C E hE)
      L N₀ hN₀
    exact (QuotientGroup.eq_one_iff L).mpr ⟨M, hM⟩

end AlgebraicGeometry
