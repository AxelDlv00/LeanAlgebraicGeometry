import AlgebraicJacobian.Picard.Pic0ChartPair

set_option autoImplicit false
set_option maxSynthPendingDepth 3
set_option maxHeartbeats 1000000

universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

-- CONFIRM: no NONEMPTY test scheme has a point of the empty open subscheme.
-- Hence `yoneda.obj (⊥ : X.Opens)` has empty sections over every nonempty T,
-- so its maps into any presheaf are injective for free.
example {X : Scheme.{u}} (T : Scheme.{u}) (t : ↥T)
    (h : T ⟶ (((⊥ : X.Opens)) : Scheme.{u})) : False :=
  (h.base t).2

end AlgebraicGeometry
