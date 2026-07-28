import AlgebraicJacobian.Picard.Pic0AbelianVariety
open CategoryTheory AlgebraicGeometry AlgebraicGeometry.Scheme
universe u
namespace AlgebraicGeometry.Scheme.Pic0

/-- Does `Smooth` give back `GeometricallyReduced`? If yes the run-0067
"reduction" is a logical EQUIVALENCE, not a shrink. -/
theorem probe_smooth_converse {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (h : Smooth (Pic0Scheme C).hom) :
    GeometricallyReduced (Pic0Scheme C).hom := by
  haveI := h; infer_instance

/-- Same for properness. -/
theorem probe_proper_converse {k : Type u} [Field k]
    (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [HasPicScheme C]
    [PicScheme.PicSchemeLocallyOfFiniteType C]
    (h : IsProper (Pic0Scheme C).hom) :
    UniversallyClosed (Pic0Scheme C).hom := by
  haveI := h; infer_instance

end AlgebraicGeometry.Scheme.Pic0
#print axioms AlgebraicGeometry.Scheme.Pic0.probe_smooth_converse
#print axioms AlgebraicGeometry.Scheme.Pic0.probe_proper_converse
