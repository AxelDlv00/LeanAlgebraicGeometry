---
author: sync
content_type: lemma
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPull_transport_cancel
docstring: '**Over-triangle transport cancellation for the push–pull tail** (kernel-cheap

  generalised form). The morphism map `pushPullMap` glues its pullback-comparison
  leg

  to the target object `pushPullObj F Y₂` by two `eqToHom` coercions along the

  over-triangle `g.left ≫ Y₁.hom = Y₂.hom`. Cancelling those coercions *in situ*

  (at the concrete pushforward/pullback objects) provokes a kernel `whnf` blow-up.

  This lemma states the cancellation **with the over-triangle equality as a free

  hypothesis** `h : gl ≫ p₁ = p₂`, so the proof is a single `subst h` (after which

  the transports become `eqToHom rfl = 𝟙` and vanish — kernel-cheap) followed by

  `simp`. Applying it to `pushPullMap` via `rw` rewrites the tail without forcing
  the

  kernel to unfold the comparison objects: the over-triangle leg

  `eqToHom ≫ (pushforward p₂).map (pullbackComp).hom ≫ eqToHom` collapses to the

  transport-light `(pushforward (gl ≫ p₁)).map (pullbackComp).hom ≫ eqToHom`, the

  single residual `eqToHom` carrying the unavoidable object identification of the

  codomain `pushPullObj F Y₂`. Reusable pre-coherence brick for `pushPullMap_comp`.'
file: AlgebraicJacobian/Cohomology/CechHigherDirectImage.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPull_transport_cancel
type: lean
updated: '2026-07-16T21:14:26'
---
lemma pushPull_transport_cancel {Y₁ Y₂ : Scheme.{u}}
    (gl : Y₂ ⟶ Y₁) (p₁ : Y₁ ⟶ X) (p₂ : Y₂ ⟶ X)
    (h : gl ≫ p₁ = p₂) (F : X.Modules) :
    eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback gl).obj ((Scheme.Modules.pullback p₁).obj F))) h) ≫
      (Scheme.Modules.pushforward p₂).map ((Scheme.Modules.pullbackComp gl p₁).hom.app F) ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pushforward p₂).obj
        ((Scheme.Modules.pullback q).obj F)) h) =
    (Scheme.Modules.pushforward (gl ≫ p₁)).map
        ((Scheme.Modules.pullbackComp gl p₁).hom.app F) ≫
      eqToHom (congrArg (fun q => (Scheme.Modules.pushforward q).obj
        ((Scheme.Modules.pullback q).obj F)) h) := by
  subst h
  simp <;> rfl