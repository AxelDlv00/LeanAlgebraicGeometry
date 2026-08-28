---
author: sync
content_type: lemma
created: '2026-07-16T21:33:28'
decl: CategoryTheory.Over.sigmaExtension_obj
file: AlgebraicJacobian/Picard/OverSigmaExtension.lean
generated: lean
lean_status: lean_ok
title: CategoryTheory.Over.sigmaExtension_obj
type: lean
updated: '2026-08-01T09:44:15'
---
lemma sigmaExtension_obj (T : Cᵒᵖ) :
    (sigmaExtension S F).obj T = Σ a : T.unop ⟶ S, F.obj (op (Over.mk a)) :=
  rfl