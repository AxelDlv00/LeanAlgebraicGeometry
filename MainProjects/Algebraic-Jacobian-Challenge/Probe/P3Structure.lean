import Mathlib
import AlgebraicJacobian.Picard.Pic0Et
import AlgebraicJacobian.Picard.GroupSchemeSmoothAlgClosed
import AlgebraicJacobian.Curve.GeometricallyReduced

set_option autoImplicit false
universe u
open CategoryTheory
namespace AlgebraicGeometry
namespace Probe3

variable {k : Type u} [Field k]

/-- PROBE 1: the kbar reduction, review-ajc's I-0944 claim (2). -/
theorem probe_geomReduced (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : IsReduced (Limits.pullback (Scheme.Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    GeometricallyReduced (Scheme.Pic0SchemeEt C).hom := by
  haveI : LocallyOfFiniteType (Scheme.Pic0SchemeEt C).hom := Scheme.Pic0Et.locallyOfFiniteType C
  letI : GrpObj (Over.mk (Scheme.Pic0SchemeEt C).hom) := (Scheme.Pic0Et.grpObj C).some
  haveI : Smooth (Scheme.Pic0SchemeEt C).hom :=
    smooth_of_grpObj_of_isReduced_algebraicClosureBaseChange _ h
  infer_instance

/-- PROBE 2: is QuasiCompact of Pic0SchemeEt available (the valuative criterion's
side condition)? -/
theorem probe_quasiCompact (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C] :
    QuasiCompact (Scheme.Pic0SchemeEt C).hom :=
  (GroupScheme.IdentityComponent.isFiniteTypeGeometricallyIrreducible
    (Scheme.PicSchemeEt C)).2.1

/-- PROBE 3: universal closedness from the valuative criterion, etale side. -/
theorem probe_univClosed (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : ValuativeCriterion.Existence (Scheme.Pic0SchemeEt C).hom) :
    UniversallyClosed (Scheme.Pic0SchemeEt C).hom := by
  haveI : QuasiCompact (Scheme.Pic0SchemeEt C).hom := probe_quasiCompact C
  exact UniversallyClosed.of_valuativeCriterion _ h

/-- PROBE 4: does the fpqc kbar descent of UniversallyClosed transfer to the ETALE
Pic0? The board says this is UNMEASURED. -/
theorem probe_univClosed_baseChange (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : UniversallyClosed (Limits.pullback.snd (Scheme.Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k)))))) :
    UniversallyClosed (Scheme.Pic0SchemeEt C).hom :=
  MorphismProperty.of_pullback_snd_of_descendsAlong
    (Q := @Surjective ⊓ @Flat ⊓ @QuasiCompact)
    ⟨⟨inferInstance, inferInstance⟩, inferInstance⟩ h

/-- PROBE 5: full properness of the etale Pic0 from the valuative existence alone. -/
theorem probe_proper (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : ValuativeCriterion.Existence (Scheme.Pic0SchemeEt C).hom) :
    IsProper (Scheme.Pic0SchemeEt C).hom := by
  haveI : IsSeparated (Scheme.Pic0SchemeEt C).hom := Scheme.Pic0Et.isSeparated C
  haveI : LocallyOfFiniteType (Scheme.Pic0SchemeEt C).hom :=
    Scheme.Pic0Et.locallyOfFiniteType C
  haveI := probe_univClosed C h
  constructor

-- PROBE 6 MEASURED NEGATIVE: `IsProper` has NO DescendsAlong instance for
-- (@Surjective ⊓ @Flat ⊓ @QuasiCompact) at mathlib v4.31, so properness itself does
-- not fpqc-descend here. Only the UniversallyClosed conjunct does (probe 4).

/-- PROBE 7: the CONVERSE of probe 1 — does GeometricallyReduced give back IsReduced
over kbar? If yes the reduction is LOSSLESS, not a weakening. -/
theorem probe_converse (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : GeometricallyReduced (Scheme.Pic0SchemeEt C).hom) :
    IsReduced (Limits.pullback (Scheme.Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) := by
  haveI := h
  infer_instance

/-- PROBE 8: converse for properness — UniversallyClosed base-changes down. -/
theorem probe_converse_uc (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]
    (h : UniversallyClosed (Scheme.Pic0SchemeEt C).hom) :
    UniversallyClosed (Limits.pullback.snd (Scheme.Pic0SchemeEt C).hom
      (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) := by
  haveI := h
  infer_instance

/-- CONTROL: must fire sorryAx. -/
theorem controlSorry (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C] :
    GeometricallyReduced (Scheme.Pic0SchemeEt C).hom :=
  Scheme.Pic0Et.geometricallyReduced C

end Probe3
end AlgebraicGeometry
