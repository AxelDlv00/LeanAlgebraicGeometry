import AlgebraicJacobian.Picard.Pic0SigmaSheaf

set_option autoImplicit false
set_option maxSynthPendingDepth 3
set_option maxHeartbeats 1000000

universe u
open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
variable [GeometricallyIrreducible C.hom] [GeometricallyReduced C.hom]

-- PROBE: at the EMPTY index type, `hf` is vacuous: no `rep`, no `IsChartUniv`.
-- If this elaborates, the ONLY remaining hypothesis of the whole seam is
-- local surjectivity of `Sigma.desc` at the empty family.
noncomputable example
    (X : PEmpty.{u+1} → Scheme.{u})
    (f : ∀ i : PEmpty.{u+1}, yoneda.obj (X i) ⟶ (pic0SigmaSheaf C).1)
    [Presheaf.IsLocallySurjective Scheme.zariskiTopology (Sigma.desc f)] :
    Nonempty ((pic0TypeFunctor C).RepresentableBy
      (Over.mk ((Scheme.LocalRepresentability.representableBy
        (fun i => PEmpty.elim i : ∀ i, IsOpenImmersion.presheaf (f i))).homEquiv
        (𝟙 (Scheme.LocalRepresentability.glueData
          (fun i => PEmpty.elim i : ∀ i, IsOpenImmersion.presheaf (f i))).glued)).1)) :=
  ⟨pic0RepresentableByOfCharts C f (fun i => PEmpty.elim i)⟩

end AlgebraicGeometry
