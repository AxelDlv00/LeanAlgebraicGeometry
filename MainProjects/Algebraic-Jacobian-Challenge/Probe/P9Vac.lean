import Mathlib
import AlgebraicJacobian.Picard.PicEtSubcanonical

open CategoryTheory AlgebraicGeometry

universe u

-- 1. AXIOMS of the four new results
#print axioms AlgebraicGeometry.Scheme.subcanonical_etaleTopology
#print axioms AlgebraicGeometry.Scheme.PicScheme.isIso_picEtComparison_of_isSheaf
#print axioms AlgebraicGeometry.Scheme.PicScheme.relPresheaf_isSheaf_of_representableBy
#print axioms AlgebraicGeometry.Scheme.picSharp_representableBy_picEt_transport
#print axioms AlgebraicGeometry.Scheme.hasPicSchemeEt_of_picSharp_representability
#print axioms AlgebraicGeometry.Scheme.isIso_picEtComparison_of_picSharp_representability

-- 2. NON-VACUITY: the conclusion is NOT provable without the hypothesis.
--    If picEt were representable unconditionally this would close; it must FAIL.
example {k : Type u} [Field k] (C : Over (Spec (CommRingCat.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] :
    IsIso (Scheme.PicScheme.picEtComparison C) := by
  infer_instance
