---
author: sync
content_type: lemma
created: '2026-08-03T16:37:46'
decl: AlgebraicGeometry.ProjectiveSpace.over_terminal_comp
file: AlgebraicJacobian/Projective/RelativeProjectiveSpace.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ProjectiveSpace.over_terminal_comp
type: lean
updated: '2026-08-03T16:37:46'
---
lemma over_terminal_comp :
    (ℙ(n; S) ↘ S) ≫ terminal.from S = toProjInt n S ≫ terminal.from (Proj 𝒫[n]) :=
  pullback.condition

section GradeZero