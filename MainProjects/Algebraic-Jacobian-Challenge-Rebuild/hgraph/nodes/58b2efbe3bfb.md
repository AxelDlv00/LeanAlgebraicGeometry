---
author: sync
content_type: definition
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.BasicOpenCocycleDatum.component
docstring: 'The `j`-th **component** of a global section of the datum''s glued sheaf,
  as a

  section of the trivializing basic-open piece `D(h_j)` (the `⊤ ⊓ pieces j`-to-`pieces
  j`

  restriction of the matching family''s `j`-th entry).'
file: AlgebraicJacobian/Picard/SectionsToDivisors.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.BasicOpenCocycleDatum.component
type: lean
updated: '2026-07-31T20:14:44'
---
noncomputable def component (s : ↥(gluedSubmodule B D.pieces D.unit ⊤))
    (j : D.index) : Γ(relCurve C B, D.pieces j) :=
  (relCurve C B).resHom (le_inf le_top le_rfl) (s.val j)