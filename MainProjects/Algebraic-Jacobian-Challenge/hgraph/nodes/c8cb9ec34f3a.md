---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.pushPullLegIso
docstring: 'The canonical leg iso for the push–pull of an over-morphism with open-immersion

  underlying map (replica of the Base `private pushPullCoprodLegIso`, whose proof
  never

  uses the coproduct structure of its ambient scheme).'
file: AlgebraicJacobian/Cohomology/CechSectionIdentificationLegMid1.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.pushPullLegIso
type: lean
updated: '2026-07-24T03:02:09'
---
noncomputable def pushPullLegIso {A C' : Scheme.{u}} (q : A ⟶ X)
    (c : C' ⟶ A) [IsOpenImmersion c] (pC : C' ⟶ X) (wC : c ≫ q = pC) (F : X.Modules) :
    (pushforward q).obj ((pushforward c).obj
        (((Scheme.Modules.pullback q).obj F).restrict c)) ≅
      pushPullObj F (Over.mk pC) :=
  (pushforward q).mapIso ((pushforward c).mapIso
    ((Scheme.Modules.restrictFunctorIsoPullback c).app ((Scheme.Modules.pullback q).obj F) ≪≫
      (Scheme.Modules.pullbackComp c q).app F ≪≫
      (Scheme.Modules.pullbackCongr wC).app F)) ≪≫
  eqToIso (congrArg (fun p' => (pushforward p').obj ((Scheme.Modules.pullback pC).obj F)) wC)

-- The final `rfl` discharges the proof-irrelevant `eqToHom` over-triangle transports against
-- concrete pushforward/pullback objects, whose `whnf` exceeds the default heartbeat budget.