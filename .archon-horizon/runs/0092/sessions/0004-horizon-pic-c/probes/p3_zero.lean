import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroRep

open CategoryTheory AlgebraicGeometry

section
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

-- Is the file's own hypothesis UNCONDITIONALLY PROVABLE at n = 0, at general R?
example : DivFunctorObjSubsingleton C π 0 :=
  divFunctorObjSubsingleton_of_forall_ring C π 0 (fun _ _ _ => inferInstance)

-- and directly through pic-g's section instance
example : DivFunctorObjSubsingleton C π 0 := fun T => instSubsingletonDivFamZarSectionZero T

-- so is the fork-answer theorem now UNCONDITIONAL at n = 0?
example {D : Over (Spec (.of k))}
    (rep : (divFunctor C π 0).RepresentableBy D)
    (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (0 : ℤ)) (T : Scheme.{u}ᵒᵖ) :
    Function.Injective ((abelSigmaChart C π 0 rep m Z hdeg).app T) :=
  injective_abelSigmaChart_of_subsingleton rep m Z hdeg
    (divFunctorObjSubsingleton_of_forall_ring C π 0 (fun _ _ _ => inferInstance)) T
end
