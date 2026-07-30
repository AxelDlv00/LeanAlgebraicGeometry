import AlgebraicJacobian.Picard.Pic0ChartSeamCollapse
import Mathlib.AlgebraicGeometry.Morphisms.Separated
set_option autoImplicit false
set_option maxSynthPendingDepth 3
universe u
open CategoryTheory Limits Opposite
namespace AlgebraicGeometry
namespace DropTest
theorem controlSorry : True := by sorry
theorem probe {X : Scheme.{u}}
    [IsReduced X]
    [X.IsSeparated]
    (V : X.Opens)

    (r : X ⟶ (V : Scheme.{u})) (hr : V.ι ≫ r = 𝟙 _) :
    V = ⊤ := by
  haveI : IsIso (V.ι) := by
    refine ⟨r, hr, ?_⟩
    refine ext_of_isDominant (X := X) (Y := X) (W := (V : Scheme.{u})) (V.ι) ?_
    rw [← Category.assoc, hr, Category.id_comp, Category.comp_id]
  have hsurj : Function.Surjective (V.ι).base :=
    (TopCat.homeoOfIso (asIso (Scheme.forgetToTop.map (V.ι)))).surjective
  refine top_le_iff.mp fun x _ => ?_
  obtain ⟨y, rfl⟩ := hsurj x
  exact y.2
end DropTest
end AlgebraicGeometry
