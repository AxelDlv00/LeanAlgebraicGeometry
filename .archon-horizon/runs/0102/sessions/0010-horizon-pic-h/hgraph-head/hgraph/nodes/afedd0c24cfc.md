---
author: sync
content_type: definition
created: '2026-07-16T21:33:28'
decl: AlgebraicGeometry.pic0SigmaFunctor
docstring: '**The big-site carrier of the slice trick**: the Σ-extension of the type-valued

  degree-zero Picard functor, `T ↦ Σ (a : T ⟶ Spec k), pic⁰(Over.mk a)`.  Reducible
  so

  that the stage-2 `sigmaExtension` calculus applies syntactically.'
file: AlgebraicJacobian/Picard/Pic0SigmaSheaf.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pic0SigmaFunctor
type: lean
updated: '2026-08-01T09:44:16'
---
noncomputable abbrev pic0SigmaFunctor : Scheme.{u}ᵒᵖ ⥤ Type u :=
  Over.sigmaExtension (Spec (.of k)) (pic0TypeFunctor C)

variable [GeometricallyReduced C.hom]

set_option maxHeartbeats 800000 in
-- The amalgamation seams unify the `forget₂ ⋙ forget` massage of `pic0Functor`
-- against the Σ-extension calculus by unfolding; within the DAT-2/PicEtMap 1600000
-- precedent.