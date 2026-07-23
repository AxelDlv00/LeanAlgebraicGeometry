---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv_app_apply
docstring: '**Clean pointwise form of the reverse-transport component.**  The `app`
  component of

  `sliceDualTransportInv` at `W''''`, evaluated at `z`, is the four-leg composite
  of the def reduced by

  `rfl`.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv_app_apply
type: lean
updated: '2026-07-16T21:14:28'
---
lemma sliceDualTransportInv_app_apply {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ)
    (β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj)
    (hβ : ∀ (P : TopologicalSpace.Opens ↥Y),
        ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
    (ψ : (((PresheafOfModules.pushforward β).obj M.val).dual.obj V : Type u))
    (W'' : (Over ((Hom.opensFunctor f).obj (unop V)))ᵒᵖ)
    (hPV : f ⁻¹ᵁ (unop W'').left ≤ unop V)
    (he : f ''ᵁ (f ⁻¹ᵁ (unop W'').left) = (unop W'').left)
    (z : (M.val.obj (op (unop W'').left) : Type u)) :
    (ModuleCat.Hom.hom ((sliceDualTransportInv f M V β hβ ψ).app W'')) z
      = (unitRelabelSwap (congrArg op he.symm)).hom
          ((dualUnitRingSwapHom f (f ⁻¹ᵁ (unop W'').left)).hom
            ((ψ.app (op (Over.mk (homOfLE hPV)))).hom
              ((M.val.map (eqToHom (congrArg op he.symm))).hom z))) := rfl

set_option maxHeartbeats 800000 in
-- The `refine LinearEquiv.toModuleIso` carrier + the iter-307 `restrictScalarsLaxε.naturality`
-- (`hε`) term in the `naturality` field involve heavy `whnf` on `restrictScalars`/internal-hom
-- terms; the default 200000 heartbeats is insufficient for this single declaration.
open PresheafOfModules InternalHom Opposite in