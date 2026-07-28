---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.psiRestrict
docstring: 'The ring morphism along `U.ι.opensFunctor` underlying `Scheme.Modules.restrictFunctor
  U.ι`;

  reconstructed so that `restrictFunctor U.ι = SheafOfModules.pushforward (psiRestrict
  U)` holds

  definitionally (verbatim from `restrictFunctor`''s internals).'
file: AlgebraicJacobian/Picard/SheafOverEquivalence.lean
generated: lean
lean_status: lean_ok
private: true
title: AlgebraicGeometry.Scheme.Modules.psiRestrict
type: lean
updated: '2026-07-28T13:22:17'
---
private noncomputable def psiRestrict :
    (↑U : Scheme).ringCatSheaf ⟶
    (U.ι.opensFunctor.sheafPushforwardContinuous RingCat
        (Opens.grothendieckTopology ↥(↑U : Scheme)) (Opens.grothendieckTopology ↥X)).obj
        X.ringCatSheaf :=
  letI α : (↑U : Scheme).presheaf ⟶ U.ι.opensFunctor.op ⋙ X.presheaf :=
    { app := fun W => (U.ι.appIso W.unop).inv }
  ⟨Functor.whiskerRight α (forget₂ CommRingCat RingCat)⟩