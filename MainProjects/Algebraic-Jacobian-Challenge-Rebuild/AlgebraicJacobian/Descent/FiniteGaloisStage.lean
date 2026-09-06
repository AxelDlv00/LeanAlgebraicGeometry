/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.FiniteStageData
import Mathlib.FieldTheory.Galois.Basic

/-!
# Galois enlargement of finite stages

The normal closure of a finite intermediate field is again finite. In a Galois
ambient extension it is Galois over the ground field and contains the original
stage. This gives an enlargement retaining all previously chosen coefficients.

`FiniteStageData.normalClosure` uses Mathlib's normal closure as its exact
intermediate field. Its inclusion is the ordinary `IntermediateField.inclusion`
associated to `FiniteStageData.le_normalClosure`.

For a finite tower of ground fields, `exists_le_isGalois_of_tower` normalizes
over the original field while retaining the stage as an intermediate field
over the larger ground field.
-/

set_option autoImplicit false

universe u

namespace AlgebraicGeometry.DatG0.FiniteStageData

variable {F K : Type u} [Field F] [Field K] [Algebra F K]

/-- The finite stage given by the normal closure in the ambient field. -/
noncomputable def normalClosure (S : FiniteStageData F K) : FiniteStageData F K := by
  letI : FiniteDimensional F S.stage := S.finiteWitness
  exact {
    stage := IntermediateField.normalClosure F S.stage K
    finiteWitness := inferInstance }

/-- Every finite stage lies in its normal closure, retaining its coefficients. -/
theorem le_normalClosure (S : FiniteStageData F K) :
    S.stage ≤ S.normalClosure.stage :=
  IntermediateField.le_normalClosure S.stage

instance normalClosure_normal [Normal F K] (S : FiniteStageData F K) :
    Normal F S.normalClosure.stage := by
  change Normal F (IntermediateField.normalClosure F S.stage K)
  infer_instance

instance normalClosure_isGalois [IsGalois F K] (S : FiniteStageData F K) :
    IsGalois F S.normalClosure.stage := by
  change IsGalois F (IntermediateField.normalClosure F S.stage K)
  infer_instance

/-- In a Galois ambient field, any finite stage admits a finite Galois enlargement. -/
theorem exists_le_isGalois [IsGalois F K] (S : FiniteStageData F K) :
    ∃ T : FiniteStageData F K, S.stage ≤ T.stage ∧ IsGalois F T.stage :=
  ⟨S.normalClosure, S.le_normalClosure, inferInstance⟩

section Tower

variable (F) {M : Type u} [Field M] [Algebra F M] [Algebra M K]
  [IsScalarTower F M K] [FiniteDimensional F M] [IsGalois F K]

/-- A finite stage over a finite extension of the ground field can be enlarged
to one that is Galois over the original ground field.

The normal closure is taken over `F` and viewed as an intermediate field over
`M` using the inclusion of the original stage. Both descriptions have the same
underlying subfield of `K`. -/
theorem exists_le_isGalois_of_tower (S : FiniteStageData M K) :
    ∃ T : FiniteStageData M K, S.stage ≤ T.stage ∧ IsGalois F T.stage := by
  letI : FiniteDimensional M S.stage := S.finiteWitness
  letI : FiniteDimensional F S.stage := FiniteDimensional.trans F M S.stage
  letI : FiniteDimensional F (S.stage.restrictScalars F) :=
    inferInstanceAs (FiniteDimensional F S.stage)
  let N := IntermediateField.normalClosure F (S.stage.restrictScalars F) K
  have hSN : S.stage.restrictScalars F ≤ N :=
    IntermediateField.le_normalClosure (S.stage.restrictScalars F)
  let T : IntermediateField M K := N.toSubfield.toIntermediateField
    fun x => hSN (S.stage.algebraMap_mem x)
  letI : FiniteDimensional F T := inferInstanceAs (FiniteDimensional F N)
  letI : FiniteDimensional M T := FiniteDimensional.right F M T
  refine ⟨⟨T, inferInstance⟩, hSN, ?_⟩
  exact inferInstanceAs (IsGalois F N)

end Tower

end AlgebraicGeometry.DatG0.FiniteStageData
