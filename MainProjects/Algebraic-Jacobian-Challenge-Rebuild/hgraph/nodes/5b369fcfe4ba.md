---
author: sync
content_type: definition
created: '2026-08-16T20:15:44'
decl: AlgebraicGeometry.pic0FiniteStageRestrictionRight
docstring: 'Restriction from the right chart to its exact pairwise overlap, as an
  algebra map over

  the separably closed ground field.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageOverlapRings.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageRestrictionRight
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def pic0FiniteStageRestrictionRight
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageChartRing C V →ₐ[k] Pic0FiniteStageOverlapRing C U V := by
  let J := (pic0_sepClosed_representableBy (C := C)).1
  letI : J.left.Over (Spec (.of k)) := ⟨J.hom⟩
  exact
    { J.left.resHom (pic0FiniteStageAffineOverlap_le_right C U V) with
      commutes' := fun r =>
        J.left.overAlgebraMap_apply_res k
          (homOfLE (pic0FiniteStageAffineOverlap_le_right C U V)).op r }