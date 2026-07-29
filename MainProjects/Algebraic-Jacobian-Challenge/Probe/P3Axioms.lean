import AlgebraicJacobian.Picard.Pic0EtStructure

/-!
Axiom + non-vacuity audit of `Picard/Pic0EtStructure.lean`, run 0085 r1 (ajc-p3).
-/

open AlgebraicGeometry CategoryTheory

-- (A) AXIOMS AS IMPLICATIONS. Expect [propext, Classical.choice, Quot.sound] only.
#print axioms AlgebraicGeometry.Scheme.Pic0Et.quasiCompact
#print axioms
  AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced_of_isReduced_algebraicClosureBaseChange
#print axioms AlgebraicGeometry.Scheme.Pic0Et.smooth_of_isReduced_algebraicClosureBaseChange
#print axioms
  AlgebraicGeometry.Scheme.Pic0Et.isReduced_algebraicClosureBaseChange_of_geometricallyReduced
#print axioms
  AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced_iff_isReduced_algebraicClosureBaseChange
#print axioms AlgebraicGeometry.Scheme.Pic0Et.universallyClosed_of_valuativeCriterion
#print axioms AlgebraicGeometry.Scheme.Pic0Et.proper_of_valuativeCriterion
#print axioms AlgebraicGeometry.Scheme.Pic0Et.universallyClosed_of_baseChange
#print axioms AlgebraicGeometry.Scheme.Pic0Et.universallyClosed_baseChange_of_universallyClosed
#print axioms AlgebraicGeometry.Scheme.Pic0Et.universallyClosed_iff_baseChange
#print axioms AlgebraicGeometry.Scheme.Pic0Et.proper_of_baseChange
#print axioms AlgebraicGeometry.Scheme.Pic0Et.isAbelianVariety_of_baseChange
#print axioms AlgebraicGeometry.Scheme.Pic0Et.isAbelianVariety_of_valuativeCriterion

-- (B) FIRING CONTROLS. These MUST report sorryAx, or (A) means nothing.
#print axioms AlgebraicGeometry.Scheme.Pic0Et.geometricallyReduced
#print axioms AlgebraicGeometry.Scheme.Pic0Et.universallyClosed
#print axioms AlgebraicGeometry.Scheme.fgaPicardRepresentability
#print axioms AlgebraicGeometry.Scheme.instHasPicSchemeEt

-- (C) NON-VACUITY OF THE HYPOTHESES: neither antecedent may synthesize on its own.
-- Both `example`s below are EXPECTED TO FAIL. If either succeeds, the corresponding
-- reduction is vacuous (the hypothesis was free) and must be reported as such.
section Vacuity
variable {k : Type u_1} [Field k] (C : Over (Spec (.of k)))
    [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
    [GeometricallyIntegral C.hom] [Scheme.HasPicSchemeEt C]

/-- Does reducedness over `k̄` come for free? -/
example : IsReduced (Limits.pullback (Scheme.Pic0SchemeEt C).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) := by
  infer_instance

/-- Does universal closedness over `k̄` come for free? -/
example : UniversallyClosed (Limits.pullback.snd (Scheme.Pic0SchemeEt C).hom
    (Spec.map (CommRingCat.ofHom (algebraMap k (AlgebraicClosure k))))) := by
  infer_instance

/-- Does `GeometricallyReduced` of the etale Pic0 synthesize? -/
example : GeometricallyReduced (Scheme.Pic0SchemeEt C).hom := by infer_instance

/-- Does the valuative existence hypothesis come for free? -/
example : ValuativeCriterion.Existence (Scheme.Pic0SchemeEt C).hom := by infer_instance

end Vacuity
