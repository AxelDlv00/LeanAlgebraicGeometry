import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroUnique
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroRep

open CategoryTheory AlgebraicGeometry

section
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π] {n : ℕ}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

-- (A1) Is DivFunctorObjSubsingleton PROVABLE at n = 0 unconditionally (general R)?
example : DivFunctorObjSubsingleton C π 0 := by
  exact fun _ => inferInstance

-- (A2) Even more directly: general-R instance exists?
example (R : Type u) [CommRing R] [Algebra k R] : Subsingleton (DivFamZar C R π 0) :=
  inferInstance

-- (A3) at arbitrary n: does inferInstance work?
example (R : Type u) [CommRing R] [Algebra k R] : Subsingleton (DivFamZar C R π n) := by
  exact inferInstance
end
