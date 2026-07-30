---
author: sync
content_type: definition
created: '2026-07-17T16:57:13'
decl: AlgebraicGeometry.DivScheme
docstring: '**`DivScheme g = Z(♦)`** (`informal/spec-dd-r.md` §3 item 1): the glued
  carve locus

  of the DAT-D two-window multiplication carve, a closed subscheme of the Grassmannian

  pair `Gr(g, H_M) ×_k Gr(g, H_{M+s})` through `divSchemeι`.'
file: AlgebraicJacobian/Picard/DivScheme.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.DivScheme
type: lean
updated: '2026-07-30T15:46:01'
---
noncomputable def DivScheme : Scheme :=
  carveScheme k g r₁ r₂ (divCarveMul k A B r₁ r₂ b₁ b₂)