import AlgebraicJacobian

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {pi : C.left ⟶ P1 k} [IsAffineHom pi]

/- APPLICABILITY: does the producer actually feed a rep consumer?  Per
   axiom-clean-vs-applicable, an axiom-clean term whose binders cannot be met at a real
   consumer is not a producer.  This is the use-site test. -/

-- (1) feed pic-c's DivFunctorObjSubsingleton bridge, the named consumer of my instance
example : DivFunctorObjSubsingleton C pi 0 :=
  divFunctorObjSubsingleton_of_forall_ring C pi 0
    (fun _ _ _ => instSubsingletonDivFamZarZeroGeneral)

-- (2) feed the abelSigmaChart signature, which takes `rep` at exactly this shape
noncomputable example (m : ℕ) (Z : (C ⊗ overSpec k k).left.CurveDivisor)
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
    (hdeg : Scheme.CurveDivisor.deg k Z
      = (m : ℤ) * classDeg k (thetaCechClass C) - (0 : ℕ)) :
    yoneda.obj (Over.mk (𝟙 (Spec (CommRingCat.of k)))).left ⟶ (pic0SigmaSheaf C).1 :=
  abelSigmaChart C pi 0 divFunctorZeroRepresentableBy m Z hdeg

end AlgebraicGeometry
