import AlgebraicJacobian.Picard.Pic0ChartSubsingletonCollapse
import AlgebraicJacobian.Picard.DivisorFamilyDegreeZeroRep

open CategoryTheory AlgebraicGeometry

section
variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsAffineHom π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom]

-- THE HYPOTHESIS IS UNCONDITIONALLY PROVABLE AT n = 0 (pic-g general-R, no field, no assumption)
theorem probe_zero_unconditional : DivFunctorObjSubsingleton C π 0 :=
  divFunctorObjSubsingleton_of_forall_ring C π 0 (fun _ _ _ => inferInstance)

-- via the section-level instance too
theorem probe_zero_unconditional' : DivFunctorObjSubsingleton C π 0 :=
  fun T => instSubsingletonDivFamZarSectionZero T.unop
end

#print axioms probe_zero_unconditional
#print axioms probe_zero_unconditional'
