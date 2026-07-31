---
author: sync
content_type: lemma
created: '2026-07-24T17:02:46'
decl: AlgebraicGeometry.Scheme.TwoCoverPairData.end₀_apply
file: AlgebraicJacobian/Cohomology/RigidEngine4Assembly.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.TwoCoverPairData.end₀_apply
type: lean
updated: '2026-07-31T20:15:18'
---
lemma end₀_apply {W : X.Opens} (hW : W ≤ U₀) (m : F.obj.obj (op W)) :
    dat.end₀ hW m = Scheme.QcohOn.qsmul hW dat.g₀ m := rfl

@[simp]