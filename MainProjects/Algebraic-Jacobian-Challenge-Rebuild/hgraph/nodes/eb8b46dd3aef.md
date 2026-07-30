---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.sectionLocalEquations_eqn
file: AlgebraicJacobian/Picard/SectionsToDivisorsClass.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.sectionLocalEquations_eqn
type: lean
updated: '2026-07-30T15:28:05'
---
lemma sectionLocalEquations_eqn (y : relCurve C B) :
    (D.sectionLocalEquations s 𝒲 σ hσ hreg).eqn y
      = (relCurve C B).resHom (hσ y) (D.component s (σ y)) :=
  rfl