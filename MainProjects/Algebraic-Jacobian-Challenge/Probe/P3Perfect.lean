import AlgebraicJacobian.Picard.Pic0EtStructure

set_option autoImplicit false
universe u
open CategoryTheory
namespace AlgebraicGeometry
namespace Probe3P

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]

/-- PROBE A: over a PERFECT field, does reducedness of Pic0SchemeEt ITSELF (no base
change) give smoothness? The translation argument in smooth_of_grpObj_of_isAlgClosed'
uses dense_smoothLocus_of_perfectField, which takes [IsReduced X] over a perfect
field -- but it also uses pointEquivClosedPoint, which may need alg closed. -/
theorem probe_perfect [PerfectField k]
    (h : IsReduced (Scheme.Pic0SchemeEt C).left) :
    Smooth (Scheme.Pic0SchemeEt C).hom := by
  haveI : LocallyOfFiniteType (Scheme.Pic0SchemeEt C).hom :=
    Scheme.Pic0Et.locallyOfFiniteType C
  letI : GrpObj (Over.mk (Scheme.Pic0SchemeEt C).hom) := (Scheme.Pic0Et.grpObj C).some
  haveI := h
  exact smooth_of_grpObj_of_isAlgClosed' _

/-- PROBE B: is the kbar pullback's reducedness derivable from reducedness of the
scheme itself over a perfect field? (IsReduced descends/ascends along k -> kbar?) -/
theorem probe_ascend [PerfectField k]
    (h : IsReduced (Scheme.Pic0SchemeEt C).left) :
    IsReduced (Limits.pullback (Scheme.Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) := by
  haveI := h
  sorry

-- PROBE C (source-level reducedness from GeometricallyReduced) NOT PURSUED: it is a
-- side question, not one of the two obligations, and `infer_instance` does not close
-- it. Recorded so nobody reads its absence as a measurement.

/-- PROBE D: ajc-p2's claim (I-1040) that headline obligation 4 IMPLIES obligation 2,
i.e. my geometricallyReduced target is a sub-problem of leaf B rather than a peer.
Verifying it myself rather than taking it on report. -/
theorem probe_p2_claim
    (hB : SmoothOfRelativeDimension (genus C) (Scheme.Pic0SchemeEt C).hom) :
    GeometricallyReduced (Scheme.Pic0SchemeEt C).hom :=
  SmoothOfRelativeDimension.geometricallyReduced (genus C) _

/-- PROBE E: and therefore obligation 4 discharges my whole smoothness half. -/
theorem probe_p2_smooth
    (hB : SmoothOfRelativeDimension (genus C) (Scheme.Pic0SchemeEt C).hom) :
    Smooth (Scheme.Pic0SchemeEt C).hom :=
  Scheme.Pic0Et.smooth_of_geometricallyReduced C (probe_p2_claim C hB)

end Probe3P
end AlgebraicGeometry
