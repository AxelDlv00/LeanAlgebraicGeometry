/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Picard.TensorObjSubstrate.Vestigial

/-!
# Sheaf-of-modules over-equivalence (shared slice root)

This file constructs the modules-level lift of the site equivalence
`TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U` to an equivalence of
sheaf-of-modules categories

```
overEquivalence U :
  SheafOfModules (↑U : Scheme).ringCatSheaf ≌ SheafOfModules (X.ringCatSheaf.over U)
```

together with two consumer isomorphisms and the engine corollary `chartOverIso` that
closes the outstanding sorry in `AlgebraicJacobian/Picard/LineBundleCoherence.lean`.

This is the **shared-root** that both the engine consumer (`LineBundleCoherence.chartOverIso`)
and the dual-lane consumers (`dual_restrict_iso`, `sliceDualTransport`) in
`TensorObjSubstrate/DualInverse.lean` consume. The construction assembles three existing
Mathlib primitives; the only genuine content is the ring morphism `φ`.

Blueprint: `blueprint/src/chapters/Picard_SheafOverEquivalence.tex`,
chapters `sec:soe_equivalence`, `sec:soe_consumers`, `sec:soe_chart`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

variable {X : Scheme.{u}} (U : X.Opens)

/-! ## §1. The equivalence (`def:sheafofmodules_over_equivalence`) -/

/- Planner strategy (steps 1–4 from `analogies/overeq258.md`):

   Set `e := TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U`
   (`Topology/Sheaves/Over.lean:41`); C = Over U with J = (Opens.grothendieckTopology X).over U,
   D = Opens ↥U with K = Opens.grothendieckTopology ↥U.
   The result orientation: `SheafOfModules R ≌ SheafOfModules S` with R = (↑U).ringCatSheaf (on D),
   S = X.ringCatSheaf.over U (on C) — so the functor goes
     SheafOfModules (↑U).ringCatSheaf ⥤ SheafOfModules (X.ringCatSheaf.over U). ✓

   STEP 1 — Continuity (free, no work):
   `pushforwardPushforwardEquivalence` (PushforwardContinuous.lean:305) needs
   `[IsContinuous eqv.functor J K]` AND `[IsContinuous eqv.inverse K J]`.
   These resolve by typeclass inference via the chain:
   · `overEquivInverseIsDenseSubsite` (`Vestigial.lean:689`) gives
       `(overEquivalence U).inverse.IsDenseSubsite K J`
     — the project already builds this instance.
   · `Functor.IsDenseSubsite → IsContinuous` is a priority-900 instance
       (`CategoryTheory/Sites/DenseSubsite/Basic.lean:548`).
   · For an equivalence, `[e.inverse.IsDenseSubsite K J] ⇒ e.functor.IsDenseSubsite J K`
       automatically (`CategoryTheory/Sites/Equivalence.lean:106–108`).
   Both legs are free; the Mathlib TODO at `Topology/Sheaves/Over.lean:19–22` is
   discharged for this case by the project's existing dense-subsite instance.

   STEP 2 — The ring morphism φ (the real content):
   `φ : (X.ringCatSheaf.over U) ⟶ (e.functor.sheafPushforwardContinuous RingCat J K).obj (↑U : Scheme).ringCatSheaf`
   Sectionwise at `V : Over U` this is `O_X(V.left) ⟶ O_{↥U}(e V)` — the structure-sheaf
   comparison of the open immersion `U.ι`. Build from `(U.ι.appIso V.left).inv`; this is the
   IDENTICAL datum that `Scheme.Modules.restrictFunctor` already uses inline
   (`AlgebraicGeometry/Modules/Sheaf.lean:320`: `α U := (f.appIso U.unop).inv`).
   `Scheme.ringCatSheaf = sheafCompose (forget₂ CommRingCat RingCat) X.sheaf`
   (`AlgebraicGeometry/Modules/Presheaf.lean:34`).
   Package sectionwise in V to obtain `φ`; `ψ` is the symmetric inverse using `.hom`.

   STEP 3 — H₁, H₂ (coherences):
   Equalities of ring-presheaf nat-transes expressing that φ and ψ are mutual inverses.
   NOT Subsingleton (thinness of Opens does not kill hom equalities); prove from the
   `appIso` round-trips via `Sheaf.hom_ext` / `ext` sectionwise.
   (Can be skipped in the functor-only fallback of Decision 2 from the analogist.)

   STEP 4 — Assembly:
   `overEquivalence X U := pushforwardPushforwardEquivalence e φ ψ H₁ H₂`
   (`Mathlib/Algebra/Category/ModuleCat/Sheaf/PushforwardContinuous.lean:305`).
   Underlying functor = `SheafOfModules.pushforward φ` (PushforwardContinuous.lean:44). -/
/- Continuity of both legs of `Opens.overEquivalence U`.

   The site of `(↑U : Scheme).ringCatSheaf` is `Opens.grothendieckTopology ↥(↑U : Scheme)`,
   where `↥(↑U : Scheme)` is the carrier of the open subscheme reached via the
   `Scheme → TopCat → Type` coercion. This is *definitionally* the subtype `↥U`, but it
   keys differently in the instance discrimination tree, so typeclass search does not find
   the project's dense-subsite instance `overEquivInverseIsDenseSubsite` (stated for the
   bare topological space `↥U`). We therefore state the two continuity instances on the
   scheme-carrier form and discharge them by `show`-converting to the subtype form, where
   `overEquivInverseIsDenseSubsite` + the priority-900 `IsDenseSubsite → IsContinuous` and
   the equivalence's functor-density propagation resolve them. -/

/-- Continuity of the inverse leg of `overEquivalence U`. -/
instance overEquivInverseIsContinuous :
    (TopologicalSpace.Opens.overEquivalence U).inverse.IsContinuous
      (Opens.grothendieckTopology ↥(↑U : Scheme)) ((Opens.grothendieckTopology ↥X).over U) := by
  change (TopologicalSpace.Opens.overEquivalence U).inverse.IsContinuous
      (Opens.grothendieckTopology ↥U) ((Opens.grothendieckTopology ↥X).over U)
  infer_instance

/-- Continuity of the functor leg of `overEquivalence U`. -/
instance overEquivFunctorIsContinuous :
    (TopologicalSpace.Opens.overEquivalence U).functor.IsContinuous
      ((Opens.grothendieckTopology ↥X).over U) (Opens.grothendieckTopology ↥(↑U : Scheme)) := by
  change (TopologicalSpace.Opens.overEquivalence U).functor.IsContinuous
      ((Opens.grothendieckTopology ↥X).over U) (Opens.grothendieckTopology ↥U)
  infer_instance

/-- The open-immersion image of the reindexed open `e.functor V = ι⁻¹(V.left)` is `V.left`
itself, since `V.left ≤ U`. This is the equality that identifies the two structure-sheaf
presheaves underlying the over-equivalence's ring morphism `φ`. -/
private lemma image_overEquiv_functor_obj (V : Over U) :
    U.ι ''ᵁ ((TopologicalSpace.Opens.overEquivalence U).functor.obj V) = V.left := by
  apply TopologicalSpace.Opens.ext
  ext y
  simp only [Scheme.Hom.coe_image, SetLike.mem_coe]
  constructor
  · rintro ⟨x, hx, rfl⟩; exact hx
  · intro hy
    exact ⟨⟨y, leOfHom V.hom hy⟩, hy, rfl⟩

/-- The structure-sheaf ring morphism underlying the over-equivalence: at `V : Over U` it
is the identification `𝒪_X(V.left) ≅ 𝒪_{↥U}(ι⁻¹ V.left)` of the structure sheaves, which on
the nose is `X.ringCatSheaf.val.map` of the open equality `image_overEquiv_functor_obj`
(the two presheaves agree definitionally via `toScheme_presheaf_obj`). -/
private noncomputable def phiOver :
    X.ringCatSheaf.over U ⟶
    ((TopologicalSpace.Opens.overEquivalence U).functor.sheafPushforwardContinuous RingCat
        ((Opens.grothendieckTopology ↥X).over U)
        (Opens.grothendieckTopology ↥(↑U : Scheme))).obj (↑U : Scheme).ringCatSheaf :=
  ⟨{ app := fun V => X.ringCatSheaf.val.map (eqToHom (image_overEquiv_functor_obj U V.unop)).op
     naturality := by
       intro a b f
       simp only [Functor.sheafPushforwardContinuous_obj_obj_map]
       erw [← Functor.map_comp, ← Functor.map_comp]
       congr 1 }⟩

/-- The left component of the inverse reindexing `e.inverse W` (i.e. the image of `W` in
`X` under the open immersion) is `U.ι ''ᵁ W`. Symmetric counterpart of
`image_overEquiv_functor_obj`. -/
private lemma left_overEquiv_inverse_obj (W : TopologicalSpace.Opens ↥(↑U : Scheme)) :
    ((TopologicalSpace.Opens.overEquivalence U).inverse.obj W).left = U.ι ''ᵁ W := by
  apply TopologicalSpace.Opens.ext
  ext y
  simp only [Scheme.Hom.coe_image, SetLike.mem_coe]
  rfl

/-- The inverse ring morphism `ψ`, symmetric to `phiOver`. -/
private noncomputable def psiOver :
    (↑U : Scheme).ringCatSheaf ⟶
    ((TopologicalSpace.Opens.overEquivalence U).inverse.sheafPushforwardContinuous RingCat
        (Opens.grothendieckTopology ↥(↑U : Scheme))
        ((Opens.grothendieckTopology ↥X).over U)).obj (X.ringCatSheaf.over U) :=
  ⟨{ app := fun W => X.ringCatSheaf.obj.map (eqToHom (left_overEquiv_inverse_obj U W.unop)).op
     naturality := by
       intro a b f
       simp only [Functor.sheafPushforwardContinuous_obj_obj_map]
       rw [show (↑U : Scheme).ringCatSheaf.obj.map f
             = X.ringCatSheaf.obj.map (U.ι.opensFunctor.op.map f) from rfl]
       show (forget₂ CommRingCat RingCat).map _ ≫ (forget₂ CommRingCat RingCat).map _
           = (forget₂ CommRingCat RingCat).map _ ≫ (forget₂ CommRingCat RingCat).map _
       rw [← (forget₂ CommRingCat RingCat).map_comp, ← (forget₂ CommRingCat RingCat).map_comp]
       congr 1
       exact congrArg _ (Subsingleton.elim _ _) }⟩

noncomputable def overEquivalence :
    SheafOfModules ((↑U : Scheme).ringCatSheaf) ≌ SheafOfModules (X.ringCatSheaf.over U) := by
  refine SheafOfModules.pushforwardPushforwardEquivalence
    (TopologicalSpace.Opens.overEquivalence U) (phiOver U) (psiOver U) ?H₁ ?H₂
  · exact sorry
  · exact sorry

/-! ## §2. Consumer isomorphisms (`lem:sheafofmodules_restrict_over_iso`, `lem:sheafofmodules_unit_over_iso`) -/

/- Planner strategy (step 5 from `analogies/overeq258.md`):

   Consumer iso (A) — restrict ↦ over:
   Goal: `(overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U`.

   Route: `M.restrict U.ι = (restrictFunctor U.ι).obj M` is ITSELF a
   `SheafOfModules.pushforward` along `U.ι.opensFunctor` (the open-immersion functor
   `Opens (↑U) → Opens X`): by construction in `AlgebraicGeometry/Modules/Sheaf.lean:319–322`,
   `restrictFunctor f := SheafOfModules.pushforward ⟨α⟩` where `α U := (f.appIso U.unop).inv`
   and the underlying functor is `f.opensFunctor`.

   The functor underlying `(overEquivalence U).functor` is `SheafOfModules.pushforward φ`
   (PushforwardContinuous.lean:44). Their composite is a pushforward along
   `f.opensFunctor ⋙ e.functor`, identified by `SheafOfModules.pushforwardComp`
   (PushforwardContinuous.lean:101); here `pushforwardComp = Iso.refl _` since the φ-round-trip
   cancels (the composite ring morphism is `𝟙`-equivalent).

   Then `SheafOfModules.pushforwardNatIso` (PushforwardContinuous.lean:188) along the
   `eqToIso` of the equality of the two underlying functors `Over U ⥤ Opens X`
   (both are `V ↦ V.left`) transports the composite to `M.over U`.

   This mirrors step-for-step `Scheme.Modules.restrictFunctorAdjCounitIso`
   (`AlgebraicGeometry/Modules/Sheaf.lean:335–340`). -/
noncomputable def restrictOverIso (M : X.Modules) :
    (overEquivalence U).functor.obj (M.restrict U.ι) ≅ M.over U :=
  sorry

/- Planner strategy (step 6 from `analogies/overeq258.md`):

   Consumer iso (B) — unit ↦ unit:
   Goal: `(overEquivalence U).functor.obj (SheafOfModules.unit (↑U : Scheme).ringCatSheaf)
          ≅ SheafOfModules.unit (X.ringCatSheaf.over U)`.

   The functor underlying `(overEquivalence U).functor` is `SheafOfModules.pushforward φ`.
   The pushforward of a unit module along a morphism φ of ringed sites is the unit module
   of the codomain ring sheaf: `pushforward φ (unit R) ≅ unit S`, because φ is exactly the
   open-immersion identification of the two structure ring sheaves, so `pushforward φ` sends
   the `𝒪_U`-unit to the `𝒪_{X,over U}`-unit. φ being an isomorphism makes this a genuine
   iso (cf. the project's `pullbackObjUnitToUnitIso` pattern in `DualInverse.lean`). -/
noncomputable def unitOverIso :
    (overEquivalence U).functor.obj (SheafOfModules.unit (↑U : Scheme).ringCatSheaf) ≅
    SheafOfModules.unit (X.ringCatSheaf.over U) :=
  sorry

/-! ## §3. Engine corollary (`lem:chart_over_iso`) -/

/- Planner strategy (step 7 from `analogies/overeq258.md`):

   One-liner once steps 1–3 land. Three-step composite:
   1. `(restrictOverIso U M).symm`
         : M.over U ≅ (overEquivalence U).functor.obj (M.restrict U.ι)
   2. `(overEquivalence U).functor.mapIso e`
         : ... ≅ (overEquivalence U).functor.obj (SheafOfModules.unit (↑U : Scheme).ringCatSheaf)
   3. `unitOverIso U`
         : ... ≅ SheafOfModules.unit (X.ringCatSheaf.over U)

   Each factor is an isomorphism; the composite has the required type.

   This is the general form of the engine's local `chartOverIso` sorry-def at
   `AlgebraicJacobian/Picard/LineBundleCoherence.lean:203–206`.
   **Next iter**: redirect `LineBundleCoherence.chartOverIso` to this declaration, closing
   the last open sorry in the coherence engine.
   The dual-lane consumers `sliceDualTransport` / `dual_restrict_iso` in
   `TensorObjSubstrate/DualInverse.lean` consume the same three pieces. -/
noncomputable def chartOverIso (M : X.Modules)
    (e : M.restrict U.ι ≅ SheafOfModules.unit (↑U : Scheme).ringCatSheaf) :
    M.over U ≅ SheafOfModules.unit (X.ringCatSheaf.over U) :=
  (restrictOverIso U M).symm ≪≫ (overEquivalence U).functor.mapIso e ≪≫ unitOverIso U

end Modules

end Scheme

end AlgebraicGeometry
