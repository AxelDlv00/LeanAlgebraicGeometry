import AlgebraicJacobian.Picard.Pic0ChartRestrictedFibre

set_option autoImplicit false
universe u
open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory
namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

/-- Is `pic0SigmaFunctor C` a subsingleton at an EMPTY test? Unfolded, an element is a
Sigma: a structure map `S ⟶ Spec k` plus a pic^0 class over it. On an empty `S` the
structure map is unique by initiality; the fibre component is the open question. -/
example (S : Scheme.{u}) (hS : IsEmpty S)
    (a b : (pic0SigmaSheaf C).1.obj (op S)) : a = b := by
  have hi : IsInitial S := (isInitial_iff_isEmpty.mpr hS).some
  obtain ⟨a1, a2⟩ := a
  obtain ⟨b1, b2⟩ := b
  obtain rfl : a1 = b1 := hi.hom_ext _ _
  congr 1

end AlgebraicGeometry
