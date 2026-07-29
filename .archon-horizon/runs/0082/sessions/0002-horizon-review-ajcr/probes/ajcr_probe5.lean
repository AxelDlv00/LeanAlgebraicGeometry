import AlgebraicJacobian.Picard.Pic0ChartLocalSurjectivity

set_option autoImplicit false
set_option maxSynthPendingDepth 3
set_option maxHeartbeats 1000000

universe u
open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- At the EMPTY index the sup sieve is the BOTTOM sieve.
example (X : PEmpty.{u+1} → Scheme.{u})
    (f : ∀ i : PEmpty.{u+1}, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    (T : Scheme.{u}) (s : (pic0SigmaSheaf C).1.obj (op T)) :
    (⨆ i, Presheaf.imageSieve (f i) s) = ⊥ := by
  simpa using iSup_of_empty (fun i : PEmpty.{u+1} => Presheaf.imageSieve (f i) s)

end AlgebraicGeometry
