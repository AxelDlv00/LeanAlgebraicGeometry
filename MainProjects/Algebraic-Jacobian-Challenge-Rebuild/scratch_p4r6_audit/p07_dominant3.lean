import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse

theorem controlSorry : True := by sorry
#print axioms AlgebraicGeometry.Jacobian

open CategoryTheory Limits Opposite TopologicalSpace
namespace AlgebraicGeometry
universe u

theorem isDominant_of_irreducible {X : Scheme.{u}} [IrreducibleSpace X]
    (V : X.Opens) (hV : Nonempty V) : IsDominant (V.ι) := by
  rw [isDominant_iff]
  have hr : (Set.range (V.ι).base) = (V : Set X) := V.range_ι
  have hop : IsOpen (V : Set X) := V.isOpen
  rw [DenseRange, hr]
  exact hop.dense_iff_nonempty.mpr (hV.elim fun x => ⟨x.1, x.2⟩)

end AlgebraicGeometry
