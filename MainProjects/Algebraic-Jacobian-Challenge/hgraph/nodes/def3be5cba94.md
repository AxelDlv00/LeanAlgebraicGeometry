---
author: sync
content_type: lemma
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.toULiftIntLinearMap_apply
file: AlgebraicJacobian/Picard/SectionGradedRing.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.toULiftIntLinearMap_apply
type: lean
updated: '2026-07-24T03:02:12'
---
@[simp] private lemma toULiftIntLinearMap_apply {M N : Type u} [AddCommGroup M]
    [AddCommGroup N] (φ : M →+ N) (x : M) : toULiftIntLinearMap φ x = φ x := rfl