---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedQsmul_mul
docstring: The action of a product.
file: AlgebraicJacobian/Cohomology/GluedSheafQcoh.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.gluedQsmul_mul
type: lean
updated: '2026-08-01T09:44:09'
---
lemma gluedQsmul_mul {V W : X.Opens} (hWV : W ≤ V) (r r' : Γ(X, V))
    (s : ↥(gluedSubmodule k U g W)) :
    gluedQsmul k U g hWV (r * r') s =
      gluedQsmul k U g hWV r (gluedQsmul k U g hWV r' s) :=
  Subtype.ext (funext fun j => by
    simp only [gluedQsmul_coe]
    rw [map_mul, mul_assoc])