---
author: sync
content_type: definition
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.Scheme.Modules.glueTripleFactorIso
docstring: '**Object-level triple-overlap base change in pullback form**: the `β_ipq`
  of

  `glueTripleBaseChangeIso`, evaluated at a sheaf `N` on the pair overlap `V_pq` and

  conjugated through `restrictFunctorIsoPullback` on both sides. Triple analogue of

  `glueOverlapFactorIso`. Project-local.'
file: AlgebraicJacobian/Picard/GlueDescent.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.glueTripleFactorIso
type: lean
updated: '2026-07-16T21:14:27'
---
noncomputable def glueTripleFactorIso (D : Scheme.GlueData.{0}) (i p q : D.J)
    (N : (D.V (p, q)).Modules) :
    (Scheme.Modules.pullback (D.ι i)).obj
        ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N)
      ≅ (Scheme.Modules.pushforward (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).obj
          ((Scheme.Modules.pullback
            (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).obj N) :=
  (restrictFunctorIsoPullback (D.ι i)).symm.app
      ((Scheme.Modules.pushforward (D.f p q ≫ D.ι p)).obj N) ≪≫
    (glueTripleBaseChangeIso D i p q).app N ≪≫
    (Scheme.Modules.pushforward (pullback.fst (D.f i p) (D.f i q) ≫ D.f i p)).mapIso
      ((restrictFunctorIsoPullback (D.t' i p q ≫ pullback.fst (D.f p q) (D.f p i))).app N)