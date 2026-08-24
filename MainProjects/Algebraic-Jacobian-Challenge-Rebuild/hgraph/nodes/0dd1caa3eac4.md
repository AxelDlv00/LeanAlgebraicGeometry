---
author: sync
content_type: definition
created: '2026-08-17T13:21:30'
decl: AlgebraicGeometry.pic0FiniteStageTripleTransition
docstring: The ring map dual to cyclic rotation of the triple intersection.
file: AlgebraicJacobian/Picard/Pic0FiniteStageTripleTransitions.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0FiniteStageTripleTransition
type: lean
updated: '2026-08-18T20:51:05'
---
noncomputable def pic0FiniteStageTripleTransition
    (U V W : Pic0FiniteStageChartIndex C) :
    Pic0FiniteStageTripleRing C V W U →ₐ[k]
      Pic0FiniteStageTripleRing C U V W := by
  let J := (pic0_sepClosed_representableBy (C := C)).1
  letI : J.left.Over (Spec (.of k)) := ⟨J.hom⟩
  exact
    { J.left.resHom (pic0FiniteStageTripleOpen_le_rotate C U V W) with
      commutes' := fun r => J.left.overAlgebraMap_apply_res k
        (homOfLE (pic0FiniteStageTripleOpen_le_rotate C U V W)).op r }