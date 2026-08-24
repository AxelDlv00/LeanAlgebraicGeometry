---
author: sync
content_type: definition
created: '2026-08-04T10:53:20'
decl: AlgebraicGeometry.pic0SigmaEtaleSheafIso
docstring: The same canonical comparison bundled in the category of big-etale sheaves.
file: AlgebraicJacobian/Picard/Pic0SigmaEtaleSheafificationComparison.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0SigmaEtaleSheafIso
type: lean
updated: '2026-08-18T20:51:06'
---
noncomputable def pic0SigmaEtaleSheafIso :
    pic0SigmaEtaleSheaf C ≅ pic0SigmaEtaleSheafification C :=
  sheafificationIso (pic0SigmaEtaleSheaf C)

/-- The underlying hom of the comparison is exactly the sheafification unit. -/
@[simp]