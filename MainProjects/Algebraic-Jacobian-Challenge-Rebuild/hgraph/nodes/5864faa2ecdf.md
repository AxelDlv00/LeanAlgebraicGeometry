---
author: sync
content_type: lemma
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.mem_gluedSubalgebra_iff
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.AffAdaptation.mem_gluedSubalgebra_iff
type: lean
updated: '2026-07-31T20:15:24'
---
lemma mem_gluedSubalgebra_iff {x : A.chartProd} :
    x ∈ gluedSubalgebra A ↔ x ∈ A.gluedSubmodule :=
  Iff.rfl