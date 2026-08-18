---
author: sync
content_type: definition
created: '2026-08-18T08:27:19'
decl: AlgebraicGeometry.Pic0FiniteStageGluePackage.restrictionBaseChangeAlgHom
docstring: 'The scalar-extended descended restriction, with its chart and overlap
  types

  fixed opaquely for use by the affine base-change API.'
file: AlgebraicJacobian/Picard/Pic0FiniteStageRestrictionBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Pic0FiniteStageGluePackage.restrictionBaseChangeAlgHom
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def restrictionBaseChangeAlgHom
    {F : Type u} [Field F] [Algebra F k] [Algebra.IsAlgebraic F k]
    (P : Pic0FiniteStageGluePackage C F)
    (U V : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U →ₐ[P.N.1]
      Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V :=
  (pic0FiniteStageRestrictionBaseChange
      C P.L P.n P.m P.relation P.M P.mapM P.N U V :
    Pic0FiniteStageChartBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U →ₐ[P.N.1]
      Pic0FiniteStageOverlapBaseChangeRing
        C P.L P.n P.m P.relation P.M P.N U V)