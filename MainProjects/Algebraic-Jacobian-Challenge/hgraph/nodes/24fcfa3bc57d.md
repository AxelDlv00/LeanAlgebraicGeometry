---
author: sync
content_type: theorem
created: '2026-07-27T20:42:16'
decl: AlgebraicGeometry.Adelic.rigidPushforward_isLocallyTrivial
docstring: '**The B3 rank-one corollary, unconditional** (Kleiman §5).  If in addition
  `h⁰ ≡ 1` then

  `q_* L` is an invertible sheaf on `Spec A`.  This is the implemented route from
  a line bundle on

  the family to the rigidified data the Picard campaign consumes.'
file: AlgebraicJacobian/Picard/RigidPushforwardGammaBaseChange.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Adelic.rigidPushforward_isLocallyTrivial
type: lean
updated: '2026-07-27T20:42:16'
---
theorem rigidPushforward_isLocallyTrivial
    (hL : LineBundle.IsLocallyTrivial L)
    (h1 : ∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).FiberH1Vanishing L t)
    (h0 : ∀ t : Spec (CommRingCat.of A),
      (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A)))).fiberH0 L t = 1) :
    LineBundle.IsLocallyTrivial
      ((Scheme.Modules.pushforward
        (pullback.snd C.hom (Spec.map (CommRingCat.ofHom (algebraMap k A))))).obj L) :=
  Scheme.pushforward_isLocallyTrivial_of_h1_vanishing C A L hL h1 h0