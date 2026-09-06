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

end AlgebraicGeometry.DatG0.FiniteStageData
