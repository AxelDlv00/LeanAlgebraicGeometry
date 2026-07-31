---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.sectionLocalEquations_eqn
file: AlgebraicJacobian/Picard/SectionsToDivisorsClass.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.BasicOpenCocycleDatum.sectionLocalEquations_eqn
type: lean
updated: '2026-07-31T20:15:28'
---
lemma sectionLocalEquations_eqn (y : relCurve C B) :
    (D.sectionLocalEquations s 𝒲 σ hσ hreg).eqn y
      = (relCurve C B).resHom (hσ y) (D.component s (σ y)) :=
  rfl