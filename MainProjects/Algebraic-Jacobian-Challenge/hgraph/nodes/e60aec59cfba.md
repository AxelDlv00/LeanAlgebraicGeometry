---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.pushforward_locallyFree_of_h1_vanishing
docstring: '**B3 headline, local-freeness half** (extraction from the gate): for an

  invertible `L` on `C_A` with fibrewise `h¹ = 0` at all scheme points, the

  pushforward `q_* L` is, near every `t : Spec A`, free of rank

  `h⁰(C_t, L_t) = χ(L_t)`.'
file: AlgebraicJacobian/Picard/RigidPushforward.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.pushforward_locallyFree_of_h1_vanishing
type: lean
updated: '2026-07-16T21:14:27'
---
theorem pushforward_locallyFree_of_h1_vanishing [HasRigidPushforward C]
    (L : (Limits.pullback C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).Modules)
    (hL : LineBundle.IsLocallyTrivial L)
    (h1 : ∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).FiberH1Vanishing L t)
    (t : Spec (CommRingCat.of A)) :
    ∃ U : (Spec (CommRingCat.of A)).Opens, t ∈ U ∧
      Nonempty ((Scheme.Modules.pullback U.ι).obj
          ((Scheme.Modules.pushforward
            (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj L) ≅
        _root_.SheafOfModules.free (R := U.toScheme.ringCatSheaf)
          (ULift.{u} (Fin ((pullback.snd C.hom
            (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t)))) :=
  HasRigidPushforward.locallyFree A L hL h1 t