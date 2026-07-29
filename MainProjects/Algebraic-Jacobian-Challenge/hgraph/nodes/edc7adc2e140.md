---
author: sync
content_type: theorem
created: '2026-07-30T03:33:55'
decl: AlgebraicGeometry.Scheme.Pic0Et.topologically_specializingMap
docstring: 'The `MorphismProperty` spelling of `specializingMap`, for composing with

  mathlib''s `universally` API.'
file: AlgebraicJacobian/Picard/Pic0EtProperImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Pic0Et.topologically_specializingMap
type: lean
updated: '2026-07-30T03:33:55'
---
theorem topologically_specializingMap :
    (topologically @SpecializingMap) (Pic0SchemeEt C).hom :=
  specializingMap C

/-! ### §2. Two renamings, each with its converse -/