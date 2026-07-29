---
author: sync
content_type: lemma
created: '2026-07-17T08:41:25'
decl: AlgebraicGeometry.Scheme.LocalEquations.divEq_refl
file: AlgebraicJacobian/Picard/DivisorFamily.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.LocalEquations.divEq_refl
type: lean
updated: '2026-07-29T15:31:43'
---
lemma divEq_refl (d : X.LocalEquations) : DivEq d d :=
  ⟨d.cover, le_rfl, le_rfl, fun _ => ⟨1, by rw [Units.val_one, one_mul]⟩⟩