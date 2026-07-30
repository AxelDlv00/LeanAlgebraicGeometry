import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite TopologicalSpace
namespace AlgebraicGeometry
universe u

#check @AlgebraicGeometry.isDominant_iff
#check @Scheme.Hom.opensRange
example : True := trivial

-- CLAIM under audit: on an irreducible scheme every nonempty open V has IsDominant V.ι
theorem isDominant_of_irreducible {X : Scheme.{u}} [IrreducibleSpace X]
    (V : X.Opens) (hV : Nonempty V) : IsDominant (V.ι) := by
  rw [isDominant_iff]
  constructor
  have : (Set.range (V.ι).base) = (V : Set X) := V.range_ι
  rw [this]
  exact (V.2.dense_iff_nonempty.mpr (by exact hV.elim fun x => ⟨x.1, x.2⟩)).closure_eq

end AlgebraicGeometry
