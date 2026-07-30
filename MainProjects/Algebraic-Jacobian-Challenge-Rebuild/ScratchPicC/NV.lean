import AlgebraicJacobian.Picard.Pic0VanishingFieldTest
import AlgebraicJacobian.Curve.P1H1Vanishing

set_option autoImplicit false
universe u
open CategoryTheory

namespace AlgebraicGeometry

/-- NON-VACUITY: the field-test vanishing fires at P1, an actual curve. -/
example (k : Type u) [Field k] (K : Type u) [Field K] [Algebra k K] :
    Subsingleton (pic0Subgroup (P1.asOver k) (overSpec k K)) :=
  subsingleton_pic0Subgroup_overSpec_field_of_genus_zero (P1.asOver k) K
    (P1.genus_asOver_eq_zero k)

end AlgebraicGeometry
