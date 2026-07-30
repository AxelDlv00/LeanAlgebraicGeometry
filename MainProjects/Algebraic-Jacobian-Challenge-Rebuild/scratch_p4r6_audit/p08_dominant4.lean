import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite TopologicalSpace
namespace AlgebraicGeometry
universe u

theorem isDominant_of_irreducible {X : Scheme.{u}} [IrreducibleSpace X]
    (V : X.Opens) (hV : Nonempty V) : IsDominant (V.ι) := by
  rw [isDominant_iff, DenseRange, Scheme.Opens.range_ι]
  exact IsOpen.dense (s := (V : Set X)) V.2 (hV.elim fun x => ⟨x.1, x.2⟩)

end AlgebraicGeometry
