/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ResidueDegree
import HartshorneLib.Chapter4P1FinitenessAPI

/-!
# Residue maps at closed points of a curve

Morphisms over the ground field respect its maps to residue fields. Over an
algebraically closed field, the residue map of any such morphism is surjective
at a closed point of a smooth integral curve.
-/

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace

namespace AlgebraicGeometry

noncomputable section

variable {k : Type u} [Field k]
variable {X Y : Scheme.{u}} [X.Over (Spec (CommRingCat.of k))]
  [Y.Over (Spec (CommRingCat.of k))]

/-- The ground-field map to a residue field commutes with a morphism over
the ground field. -/
theorem Scheme.Hom.residueFieldMap_residueOverAlgebraMap
    (f : X ⟶ Y)
    (hf : f ≫ (Y ↘ Spec (CommRingCat.of k)) = X ↘ Spec (CommRingCat.of k))
    (x : X) (c : k) :
    (f.residueFieldMap x).hom (Y.residueOverAlgebraMap k (f x) c) =
      X.residueOverAlgebraMap k x c := by
  change (f.residueFieldMap x).hom (Y.Γevaluation (f x)
    (Y.overAlgebraMap k ⊤ c)) = X.Γevaluation x (X.overAlgebraMap k ⊤ c)
  rw [Scheme.Γevaluation_naturality_apply]
  congr 1
  convert f.appLE_overAlgebraMap hf (U := ⊤) (V := ⊤) le_top c using 1
  simp [Scheme.Hom.appLE]

/-- At a non-generic point of a smooth integral curve over an algebraically
closed field, the residue map of every ground-field morphism is surjective. -/
theorem Scheme.Hom.residueFieldMap_surjective_of_smoothCurve
    [IsAlgClosed k] [IsIntegral X]
    [SmoothOfRelativeDimension 1 (X ↘ Spec (CommRingCat.of k))]
    (f : X ⟶ Y)
    (hf : f ≫ (Y ↘ Spec (CommRingCat.of k)) = X ↘ Spec (CommRingCat.of k))
    (x : X) (hx : x ≠ genericPoint X) :
    Function.Surjective (f.residueFieldMap x).hom := by
  letI : Smooth (X ↘ Spec (CommRingCat.of k)) :=
    SmoothOfRelativeDimension.smooth 1 _
  letI : Module k (X.residueField x) := X.residueFieldOverModule k x
  letI := Scheme.residueDeg_finite (K := k) hx
  letI : Algebra k (X.residueField x) := (X.residueOverAlgebraMap k x).toAlgebra
  letI : Algebra.IsIntegral k (X.residueField x) := Algebra.IsIntegral.of_finite k _
  have hsurj : Function.Surjective (X.residueOverAlgebraMap k x) :=
    IsAlgClosed.algebraMap_bijective_of_isIntegral.surjective
  intro z
  obtain ⟨c, rfl⟩ := hsurj z
  exact ⟨Y.residueOverAlgebraMap k (f x) c,
    f.residueFieldMap_residueOverAlgebraMap hf x c⟩

end
end AlgebraicGeometry
