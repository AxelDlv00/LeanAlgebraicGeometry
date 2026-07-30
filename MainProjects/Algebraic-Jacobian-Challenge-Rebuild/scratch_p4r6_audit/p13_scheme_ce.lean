import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
universe u

-- Target: a REDUCED SEPARATED scheme X with an open V, V ≠ ⊤, and a retraction of V.ι.
-- Candidate: X = Spec k ⨿ Spec k, V = range of inl.
noncomputable example : True := by
  let k : Type := ULift.{0} Bool  -- placeholder
  trivial

variable (R : CommRingCat.{u}) [Nontrivial R] [IsReduced (Spec R)]

noncomputable def XX : Scheme.{u} := (Spec R) ⨿ (Spec R)

noncomputable def VV : (XX R).Opens := (coprod.inl : Spec R ⟶ XX R).opensRange

#check @Scheme.Hom.opensRange
example : IsOpenImmersion (coprod.inl : Spec R ⟶ XX R) := inferInstance
example : IsReduced (XX R) := inferInstance
example : (XX R).IsSeparated := inferInstance

end AlgebraicGeometry
