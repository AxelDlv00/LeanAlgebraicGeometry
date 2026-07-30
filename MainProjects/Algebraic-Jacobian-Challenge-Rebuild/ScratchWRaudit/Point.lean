import AlgebraicJacobian.Albanese.Genus0VanishingDatum
import AlgebraicJacobian.Curve.P1H1Vanishing

open AlgebraicGeometry CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
universe u
variable (k : Type u) [Field k]

-- does the tree have a rational point of P1 as an Over-morphism from the unit?
example : Nonempty (𝟙_ (Over (Spec (CommRingCat.of k))) ⟶ P1.asOver k) := by
  exact? says sorry
