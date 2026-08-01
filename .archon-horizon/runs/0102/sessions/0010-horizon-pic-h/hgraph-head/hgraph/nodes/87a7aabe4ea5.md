---
author: sync
content_type: lemma
created: '2026-07-17T08:41:24'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.baseChange_unit_coe
file: AlgebraicJacobian/Cohomology/GluedSheafDatumBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.baseChange_unit_coe
type: lean
updated: '2026-08-01T09:44:09'
---
lemma baseChange_unit_coe (i j : D.index) :
    (((D.baseChange B').unit i j :
        Γ(relCurve C B',
          (D.baseChange B').pieces i ⊓ (D.baseChange B').pieces j)ˣ) :
      Γ(relCurve C B', (D.baseChange B').pieces i ⊓ (D.baseChange B').pieces j)) =
      D.toBasicOpenCoverData.overlapMap B' i j
        ((D.unit i j : Γ(relCurve C B, D.pieces i ⊓ D.pieces j))) := rfl

/-! ## The componentwise comparison of glued sections -/

section SectionsMap

variable {W : (relCurve C B).Opens} {W' : (relCurve C B').Opens}