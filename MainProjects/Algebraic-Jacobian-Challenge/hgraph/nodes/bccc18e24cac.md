---
author: sync
content_type: definition
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv
docstring: "**Reverse slice transport (the `invFun` of `sliceDualTransport`), extracted\
  \ top-level.**\n\nGiven a dual section `ψ : restr V ((pushforward β).obj M.val)\
  \ ⟶ restr V \U0001D7D9_Y` over `Over V`,\nthis produces the X-slice dual section\
  \ `restr fV M.val ⟶ restr fV \U0001D7D9_X` over `Over fV`\n(`fV = f.opensFunctor.obj\
  \ V.unop`), the mirror of `sliceDualTransport`'s forward `toFun`.\n\nFor `W'' :\
  \ (Over fV)ᵒᵖ`, set `P := f⁻¹ᵁ W''.left` (so `f.opensFunctor.obj P = W''.left` only\n\
  propositionally, via `image_preimage_of_le` since `fV ⊆ range f`).  The component\
  \ at `W''` is the\nX-slice mirror of the forward component, conjugated by the `eqToHom`s\
  \ from `image_preimage_of_le`\n(mirror of `homLocalSection`):\n`eqToHom … ≫ (restrictScalars\
  \ (f.appIso P).hom.hom).map (ψ.app (op (Over.mk (homOfLE hPV)))) ≫\n  dualUnitRingSwapHom\
  \ f P`,\nthe codomain swap being `dualUnitRingSwapHom = inv (ε (restrictScalars\
  \ (f.appIso P).hom.hom))`\n(the `.hom`-direction `inv ε`)."
file: AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sliceDualTransportInv
type: lean
updated: '2026-07-25T12:32:38'
---
noncomputable def sliceDualTransportInv {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) (V : (TopologicalSpace.Opens ↥Y)ᵒᵖ)
    (β : Y.ringCatSheaf.obj ⟶ (Hom.opensFunctor f).op ⋙ X.ringCatSheaf.obj)
    -- This identifies the two successive scalar restrictions in the reverse component.
    (hβ : ∀ (P : TopologicalSpace.Opens ↥Y),
        ((β.app (op P)).hom).comp ((Scheme.Hom.appIso f P).hom.hom) = RingHom.id _)
    (ψ : (((PresheafOfModules.pushforward β).obj M.val).dual.obj V : Type u)) :
    (((PresheafOfModules.pushforward β).obj M.val.dual).obj V : Type u) := by
  refine { app := fun W'' => ?_, naturality := ?_ }
  · -- For `W' ≤ fV`, transport through `P = f⁻¹ᵁ W'` and its image equality.
    set W' := (unop W'').left with hW'
    have hW'fV : W' ≤ f ''ᵁ (unop V) := (unop W'').hom.le
    have hPV : f ⁻¹ᵁ W' ≤ unop V :=
      le_trans ((TopologicalSpace.Opens.map f.base).monotone hW'fV)
        (le_of_eq (f.preimage_image_eq (unop V)))
    have he : f ''ᵁ (f ⁻¹ᵁ W') = W' := by
      rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
      exact inf_eq_right.mpr (hW'fV.trans (f.image_le_opensRange (unop V)))
    -- First reindex `ψ` and transport the unit through the structure-ring isomorphism.
    have core := (ModuleCat.restrictScalars (Scheme.Hom.appIso f (f ⁻¹ᵁ W')).hom.hom).map
        (ψ.app (op (Over.mk (homOfLE hPV)))) ≫ dualUnitRingSwapHom f (f ⁻¹ᵁ W')
    -- The relabel is semilinear, so map the in-fiber composite through `restrictScalars`.
    refine M.val.map (eqToHom (congrArg op he.symm)) ≫
      (ModuleCat.restrictScalars ((X.ringCatSheaf.obj.map (eqToHom (congrArg op he.symm))).hom)).map
        (?collapse ≫ core) ≫ ?unit
    case collapse =>
      -- Collapse the two scalar restrictions using `hβ`.
      exact (ModuleCat.restrictScalarsId'App _ (hβ (f ⁻¹ᵁ W'))
            (M.val.obj (op (f ''ᵁ f ⁻¹ᵁ W')))).inv ≫
        (ModuleCat.restrictScalarsComp'App ((Scheme.Hom.appIso f (f ⁻¹ᵁ W')).hom.hom)
            ((β.app (op (f ⁻¹ᵁ W'))).hom) _ rfl (M.val.obj (op (f ''ᵁ f ⁻¹ᵁ W')))).hom
    case unit =>
      -- Transport the unit back across the section-ring relabel.
      exact unitRelabelSwap (congrArg op he.symm)
  · -- Naturality is the extracted pointwise square for the same four transports.
    intro X₁ Y₁ f₁
    apply ModuleCat.hom_ext
    refine LinearMap.ext fun z => ?_
    exact sliceDualTransportInv_naturality_apply f M V β hβ ψ f₁ z
      (le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop X₁).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V))))
      (by rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
          exact inf_eq_right.mpr ((unop X₁).hom.le.trans (f.image_le_opensRange (unop V))))
      (le_trans ((TopologicalSpace.Opens.map f.base).monotone (unop Y₁).hom.le)
        (le_of_eq (f.preimage_image_eq (unop V))))
      (by rw [Scheme.Hom.image_preimage_eq_opensRange_inf]
          exact inf_eq_right.mpr ((unop Y₁).hom.le.trans (f.image_le_opensRange (unop V))))

open PresheafOfModules InternalHom Opposite in