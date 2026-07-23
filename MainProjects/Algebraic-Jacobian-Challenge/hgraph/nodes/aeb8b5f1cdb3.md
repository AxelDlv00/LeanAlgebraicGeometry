---
author: sync
content_type: definition
created: '2026-07-16T21:14:26'
decl: AlgebraicGeometry.modulesOverOpensEquivalence
docstring: '**The general-opens restrict–over bridge engine** (port of

  `modulesOverBasicOpenEquivalence`): the equivalence between modules on the open
  subscheme

  `W.toScheme` and sheaves of modules on the over-site `X.ringCatSheaf.over W`.'
file: AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.modulesOverOpensEquivalence
type: lean
updated: '2026-07-16T21:14:26'
---
noncomputable def modulesOverOpensEquivalence :
    W.toScheme.Modules ≌ SheafOfModules.{u} (X.ringCatSheaf.over W) :=
  SheafOfModules.pushforwardPushforwardEquivalence (Opens.overEquivalence W)
    (overOpensRingHom W) (overOpensRingInvHom W)
    (by
      refine NatTrans.ext (funext fun (V' : (Opens ↥W)ᵒᵖ) => ?_)
      simp only [overOpensRingHom, overOpensRingInvHom, NatTrans.comp_app,
        Functor.whiskerRight_app, NatTrans.op_app, Functor.whiskerLeft_app, Functor.comp_obj,
        Functor.op_obj]
      erw [← Functor.map_comp]
      exact congrArg X.ringCatSheaf.val.map (Subsingleton.elim _ _))
    (by
      refine NatTrans.ext (funext fun (V' : (Over W)ᵒᵖ) => ?_)
      simp only [overOpensRingHom, overOpensRingInvHom, NatTrans.comp_app,
        Functor.whiskerRight_app, NatTrans.op_app, Functor.whiskerLeft_app, Functor.comp_obj,
        Functor.op_obj, NatTrans.id_app, overOpensForgetInvIso, Iso.refl_inv]
      erw [← Functor.map_comp, ← Functor.map_comp]
      exact (congrArg X.ringCatSheaf.val.map (Subsingleton.elim _ (𝟙 _))).trans
        (X.ringCatSheaf.val.map_id _))

set_option backward.isDefEq.respectTransparency false in