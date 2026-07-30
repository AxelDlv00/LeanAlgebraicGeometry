import AlgebraicJacobian.Albanese.Genus0VanishingDatum
import AlgebraicJacobian.Curve.P1H1Vanishing

open AlgebraicGeometry CategoryTheory Limits MonoidalCategory
universe u
variable (k : Type u) [Field k]

-- (A) JacobianData at P1 from vanishing alone?
noncomputable example
    (h : ∀ T : Over (Spec (.of k)), Subsingleton (pic0Subgroup (P1.asOver k) T)) :
    JacobianData (P1.asOver k) :=
  jacobianData_of_subsingleton (P1.asOver k) h

-- (B) is Surjective (P1.asOver k).hom free now (via GeometricallyIrreducible)?
example : Surjective (P1.asOver k).hom := by infer_instance
