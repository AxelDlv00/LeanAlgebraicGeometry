---
author: sync
content_type: lemma
created: '2026-07-16T21:33:27'
decl: AlgebraicGeometry.gluedQsmul_smul
docstring: 'The action commutes with the `k`-module structure (the `smul_qsmul` datum
  of the

  two-cover pair).'
file: AlgebraicJacobian/Cohomology/GluedSheafQcoh.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.gluedQsmul_smul
type: lean
updated: '2026-07-29T15:26:31'
---
lemma gluedQsmul_smul {V W : X.Opens} (hWV : W ≤ V) (r : Γ(X, V)) (c : k)
    (s : ↥(gluedSubmodule k U g W)) :
    gluedQsmul k U g hWV r (c • s) = c • gluedQsmul k U g hWV r s :=
  Subtype.ext (funext fun j => by
    have hcs : ((c • s : ↥(gluedSubmodule k U g W))).val j = c • s.val j := rfl
    have hcs' : ((c • gluedQsmul k U g hWV r s :
        ↥(gluedSubmodule k U g W))).val j = c • (gluedQsmul k U g hWV r s).val j := rfl
    rw [hcs', gluedQsmul_coe, gluedQsmul_coe, hcs, Scheme.overModule_smul_def,
      Scheme.overModule_smul_def, mul_left_comm])