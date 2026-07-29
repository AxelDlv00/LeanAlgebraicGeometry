---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.picEt.glueValue_spec
file: AlgebraicJacobian/Picard/Pic0ZariskiSheaf.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.picEt.glueValue_spec
type: lean
updated: '2026-07-29T15:26:33'
---
lemma glueValue_spec (W : T.left.affineOpens) : IsGlueValue O v W (glueValue hcov hv W) :=
  (exists_isGlueValue hcov hv W).choose_spec