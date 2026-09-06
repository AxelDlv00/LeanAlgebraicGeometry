/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtTensorStageFaceCompatibility
import AlgebraicJacobian.Picard.PicEtTensorStageMapCompatibility

/-!
# Nested finite tensor stages for Picard classes

An ambient descent class is represented by an etale-plus Picard class at a finite
tensor stage over the intermediate field, compatibly with extension to the ambient field.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
-- Selecting the class compares the canonical polynomial-quotient cover carriers.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- An ambient descent class is the extension of an etale-plus Picard class at one
finite tensor stage over the intermediate field. -/
theorem exists_picEtAff_nested_tensorStage
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [Algebra.IsAlgebraic F K] [CommRing B] [Algebra F B]
    (M : DatG0.FinSubext F K) (C : Over (Spec (.of M.1)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIrreducible C.hom] :
    let R := M.1 ⊗[F] B
    let TK := K ⊗[F] B
    let iota : R →ₐ[F] TK := Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
    letI : Algebra R TK := iota.toRingHom.toAlgebra
    ∀ (E : Algebra.EtaleCover R) (ξ : descentClasses C (E.baseChange TK)),
      ∃ (S : DatG0.FiniteStageData M.1 K) (z : PicEtAff C (S.stage ⊗[M.1] R)),
        PicEtAff.mapAlg (k := M.1) C
            (DatG0.tensorStageNestedAmbientMapOverIntermediate M S) z =
          PicEtAff.mk (k := M.1) C (E.baseChange TK) ξ := by
  dsimp only
  let iota : M.1 ⊗[F] B →ₐ[F] K ⊗[F] B :=
    Algebra.TensorProduct.map M.1.val (AlgHom.id F B)
  letI : Algebra (M.1 ⊗[F] B) (K ⊗[F] B) := iota.toRingHom.toAlgebra
  intro E ξ
  obtain ⟨S, q, hmap, hfaces⟩ := exists_tensorStageData_class_faces (B := B) M C E ξ
  exact ⟨S, _, tensorStageData_map_descentClass (B := B) M C E S ξ q hmap hfaces⟩

end

end AlgebraicGeometry

