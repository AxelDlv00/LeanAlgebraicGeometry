import AlgebraicJacobian.Picard.JacobianDataQcFromRep
import AlgebraicJacobian.Challenge

/-! Axiom audit: every declaration of the new file, against a control that MUST fire sorryAx. -/

open AlgebraicGeometry

-- CONTROL: this must print sorryAx, else the probe measures nothing.
#print axioms AlgebraicGeometry.Jacobian

#print axioms AlgebraicGeometry.abelOfPic0Class
#print axioms AlgebraicGeometry.abelOfPic0Class_left
#print axioms AlgebraicGeometry.abelOfPic0Class_comp_class
#print axioms AlgebraicGeometry.comp_abelOfPic0Class_eq_testPoint
#print axioms AlgebraicGeometry.residueField_lift_of_pic0_class
#print axioms AlgebraicGeometry.quasiCompact_of_pic0_class_surjective
#print axioms AlgebraicGeometry.surjective_of_extensionTolerant_lift
#print axioms AlgebraicGeometry.quasiCompact_of_extensionTolerant_lift
#print axioms AlgebraicGeometry.extensionTolerant_of_kappaPinned
#print axioms AlgebraicGeometry.compactSpace_of_pic0_class_surjective
#print axioms AlgebraicGeometry.JacobianData.ofPic0ClassSurjective
#print axioms AlgebraicGeometry.JacobianData.ofPic0ClassSurjective_J
