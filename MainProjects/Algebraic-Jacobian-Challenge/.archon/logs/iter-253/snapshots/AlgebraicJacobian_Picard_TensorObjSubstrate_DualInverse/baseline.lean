/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import AlgebraicJacobian.Picard.TensorObjSubstrate
import AlgebraicJacobian.Picard.TensorObjSubstrate.PresheafInternalHom

/-!
# Dual-inverse parallel lane (A.1.c.SubT §Dual, iter-251)

This file holds the **dual-inverse chain** that feeds `exists_tensorObj_inverse` in
`TensorObjSubstrate.lean`:

1. `dual_restrict_iso` — restriction along an open immersion commutes with the sheaf-level
   dual (blueprint `lem:dual_restrict_iso`; the C-bridge).  **PARTIAL** (iter-251): Steps 1–3
   (`restrictFunctorIsoPullback`/`sheafificationCompPullback`/strip) + H1
   (`pushforwardPushforwardAdj`∘`leftAdjointUniq`) are in place; one `sorry` remains at the
   identified Step-4 presheaf residual
   `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`
   (the genuine new "pushforward-along-a-ring-iso commutes with dual" build, sectionwise via
   `InternalHom.restrictScalarsRingIsoDualEquiv`).
2. `dual_isLocallyTrivial` — the dual of a locally-trivial module is locally trivial
   (blueprint `lem:dual_isLocallyTrivial`).  **TRANSITIVELY PARTIAL** (depends on
   `dual_restrict_iso` Step-4 sorry at ~L254): the three-step chart-chase
   `dual_restrict_iso ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso` is assembled and compiles, but it
   inherits the `dual_restrict_iso` residual axiomatically.  The third leg `dual_unit_iso`
   and its presheaf core `presheafDualUnitIso` (= the §0 `dualUnitIsoGen`, the eval-at-`1`
   `dual 𝟙_ ≅ 𝟙_`) are built axiom-clean.
3. `homOfLocalCompat` — a compatible family of local `𝒪_X`-module morphisms over an open
   cover glues to a unique global morphism (blueprint `lem:sheafofmodules_hom_of_local_compat`;
   the A-bridge).  **OPEN** (`sorry`); the multi-piece sheaf-of-homs gluing engine.

The prover lane for this file works **in parallel** with the D1′/D3′/D4′ lane in
`TensorObjSubstrate.lean`.

Blueprint chapter: `blueprint/src/chapters/Picard_TensorObjSubstrate.tex`.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits MonoidalCategory

/-! ## §0. Presheaf-level: the dual of the monoidal unit is the unit

Project-local supplement to `PresheafInternalHom.lean`: `PresheafOfModules.dual 𝟙_ ≅ 𝟙_`
(the evaluation-at-`1` isomorphism `ℋom(𝟙_, 𝟙_) ≅ 𝟙_`), built over a general single-universe
base category.  It feeds `Scheme.Modules.dual_unit_iso` (below) at `R₀ := Y.presheaf`. -/

namespace PresheafOfModules

open InternalHom Opposite

variable {D : Type u} [Category.{u, u} D] {R₀ : Dᵒᵖ ⥤ CommRingCat.{u}}

/-- **Section equivalence for the dual of the unit.** At an object `X`, endomorphisms of the
(restricted) unit `restr X 𝟙_ ⟶ restr X 𝟙_` are identified `R₀(X)`-linearly with `R₀(X)` itself,
via evaluation at `1`; the inverse is multiplication by a global scalar (`globalSMul`). The
substantive content is `left_inv`: every endomorphism of the unit is multiplication by its value
at `1` (proved from `φ`-naturality toward the terminal object of the slice). -/
noncomputable def unitDualSectionEquiv (X : Dᵒᵖ) :
    letI := internalHomObjModule X.unop
      (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
      (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    (restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) ⟶
        restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))))
      ≃ₗ[(R₀.obj (op X.unop) : Type u)] (R₀.obj (op X.unop) : Type u) := by
  letI := internalHomObjModule X.unop
    (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
    (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
  exact
    { toFun := fun φ =>
        evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) X φ
          (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      map_add' := fun φ φ' => rfl
      map_smul' := fun c φ => by
        exact DFunLike.congr_fun (evalLin_smul _ X c φ)
          (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      invFun := fun r =>
        globalSMul Over.mkIdTerminal
          (restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))) r
      left_inv := fun φ => by
        ext Y
        dsimp only
        erw [globalSMul_hom_apply]
        have hnat := PresheafOfModules.naturality_apply φ (Over.mkIdTerminal.from Y.unop).op
          (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
        erw [PresheafOfModules.unit_map_one] at hnat
        erw [hnat, smul_eq_mul, mul_one]
        rfl
      right_inv := fun r => by
        change ((globalSMul Over.mkIdTerminal
            (restr X.unop
              (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))) r).app
            (op (Over.mk (𝟙 X.unop)))).hom
            (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u)) = r
        rw [globalSMul_hom_apply, termRingMap_terminal]
        exact mul_one r }

/-- **The presheaf dual of the monoidal unit is the unit**, `PresheafOfModules.dual 𝟙_ ≅ 𝟙_`,
assembled sectionwise from `unitDualSectionEquiv` with the evaluation-at-`1` naturality (mirroring
`InternalHom.internalHomEval`'s naturality at `M = 𝟙_`). -/
noncomputable def dualUnitIsoGen :
    PresheafOfModules.dual (R₀ := R₀)
        (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))
      ≅ 𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)) :=
  PresheafOfModules.isoMk (fun X => (unitDualSectionEquiv X).toModuleIso)
    (fun {X Y} f => by
      refine ModuleCat.hom_ext (LinearMap.ext fun φ => ?_)
      change evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) Y
            ((PresheafOfModules.dual
              (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map f φ)
            (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj Y : Type u))
          = ((𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))).map f).hom
              (evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) X φ
                (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u)))
      have key := PresheafOfModules.naturality_apply
        (φ : restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) ⟶
          restr X.unop (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))))
        (Over.homMk f.unop : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op
        (1 : ((R₀ ⋙ forget₂ CommRingCat RingCat).obj X : Type u))
      have hrm : (restr X.unop
            (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map
          (Over.homMk f.unop : Over.mk f.unop ⟶ Over.mk (𝟙 X.unop)).op
          = (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))).map f := rfl
      rw [hrm] at key
      erw [PresheafOfModules.unit_map_one] at key
      have hAB : (op (Over.mk (𝟙 Y.unop ≫ f.unop)) : (Over X.unop)ᵒᵖ) = op (Over.mk f.unop) :=
        congrArg op (congrArg Over.mk (Category.id_comp f.unop))
      have homAppHEq : ∀ {A B : (Over X.unop)ᵒᵖ} (_ : A = B), HEq (φ.app A) (φ.app B) := by
        intro A B h; subst h; rfl
      have hdt : evalLin (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat))) Y
          ((PresheafOfModules.dual
            (𝟙_ (_root_.PresheafOfModules.{u} (R₀ ⋙ forget₂ CommRingCat RingCat)))).map f φ)
          = (φ.app (op (Over.mk f.unop))).hom :=
        congrArg ModuleCat.Hom.hom (eq_of_heq (homAppHEq hAB))
      exact (DFunLike.congr_fun hdt _).trans key)

end PresheafOfModules

namespace AlgebraicGeometry

namespace Scheme

namespace Modules

/-! ## §A. The C-bridge: restriction commutes with the sheaf-level dual -/

/-- **Restriction along an open immersion commutes with the sheaf-level dual (C-bridge).**

Blueprint `lem:dual_restrict_iso` (§`sec:tensorobj_dual_bridge`).  For an open immersion
`f : Y ⟶ X` and `M : X.Modules`, there is a canonical isomorphism of `𝒪_Y`-modules
```
  (dual M).restrict f  ≅  dual (M.restrict f)
```
natural in `M`, between the restriction of the sheaf-level dual and the dual of the
restriction.

/- Planner strategy:
   Blueprint label: lem:dual_restrict_iso (~L5374).

   Proof-sketch (blueprint §5.4):
   The proof runs at the PRESHEAF-OF-MODULES level (Step 3 of the tensorObj_restrict_iso
   H1∘H2 recipe already strips the outer sheafification).  Three ingredients:

   (a) Per-V slice equivalence: for each V ≤ U (= image of f), the opens functor
       `f.opensFunctor` is fully faithful with image = {W ≤ U}, so
       `Over_Y V ≃ Over_X (f.opensFunctor V)`.  This is the per-open shadow of
       `TopologicalSpace.Opens.overEquivalence` (CLOSED in Vestigial.lean via
       `overSliceSheafEquiv`).

   (b) Agreement of codomain: the structure sheaf of Y agrees with that of X under (a).

   (c) Ring-iso transport of module structure:
       `lem:restrictscalars_ringiso_dualequiv` (CLOSED in PresheafInternalHom.lean as
       `restrictScalarsRingIsoDualEquiv`):
         `RingEquiv e → Dual(restrictScalars e.toRingHom A) ≃ restrictScalars e.toRingHom (Dual A)`
       applies sectionwise at each V to transport the `𝒪_X(fV)`-module structure on
       `(dual M)|_f(V)` to the `𝒪_Y(V)`-module structure via the ring iso
       `β_V = (f.appIso V).inv : 𝒪_X(fV) ≅ 𝒪_Y(V)`.

   High-level recipe (mirrors tensorObj_restrict_iso Steps 1–4 with `dual` in place of `⊗`):
   Step 1: `(Scheme.Modules.restrictFunctorIsoPullback f).app (dual M)` — reduce `restrict`
           to abstract pullback.
   Step 2: `SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom` — move pullback
           inside sheafification.
   Step 3: strip the outer sheafification via `(sheafification …).mapIso`.
   Step 4 (the genuine new build):  close the residual presheaf goal
             `pushforward β (PresheafOfModules.dual M.val)
                 ≅ PresheafOfModules.dual ((pushforward β).obj M.val)`
           The ROUTE: sectionwise, at each V ≤ U, the value of the LHS is
           `Hom_{Over_X(fV)}(restr(fV) M.val, restr(fV) 𝟙_X)` and the value of the RHS is
           `Hom_{Over_Y V}(restr V (pushforward β M.val), restr V 𝟙_Y)`.
           The slice equivalence (a) identifies these indexing categories; the agreement (b)
           identifies the codomain `𝟙`; the ring-iso transport (c) via
           `restrictScalarsRingIsoDualEquiv` reconciles the module structures.
           Naturality in V is automatic on the thin poset `Opens X` by `Subsingleton.elim`.

   ⚠ WARM-CONTEXT WARNING (progress-critic pc251):
   The residual presheaf goal (Step 4) is a GENUINE NEW BUILD — NOT covered by
   `overSliceSheafEquiv` (outcome (ii) of the iter-230 C-wiring diagnostic, confirmed by
   live `change`):
     • `overSliceSheafEquiv` is a `Sheaf`-category equivalence; the residual (after Step 3)
       is a `PresheafOfModules`-level iso (different categories).
     • `overSliceSheafEquiv` has a fixed value category `A`; the dual's per-V value uses the
       VARYING ring `𝒪_Y(V)` — a fixed-value-cat site equivalence does NOT transport the
       varying module structure for free.
     • The per-V slice comparison is over a FINER slicing (single open V) than the whole-U
       slice site `(gt X).over U` the root is built over.
   If the sectionwise ring-iso build resists, consult:
     (i)  the iter-230 C-wiring diagnostic in TensorObjSubstrate.lean (~L613–656) for the
          precise decomposition of the missing presheaf+module ingredient;
     (ii) a targeted mathlib-analogist query on the "dual of pushforward along a ring iso"
          pattern (do NOT thrash — this is a genuine new build, not a missing import).

   Named CLOSED base lemmas this stub consumes:
   - `PresheafOfModules.dual` (PresheafInternalHom.lean) — presheaf-level dual.
   - `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207) — sheaf-level dual.
   - `InternalHom.restrictScalarsRingIsoDualEquiv` (PresheafInternalHom.lean ~L234) — the
     ring-iso / dual commutation at the `ModuleCat` level.
   - `Scheme.Modules.restrictFunctorIsoPullback` (Mathlib) — Step 1 iso.
   - `SheafOfModules.sheafificationCompPullback` (Mathlib) — Step 2 iso.
   - `PresheafOfModules.pushforwardPushforwardAdj` (PresheafInternalHom.lean) — H1.
   - `PresheafOfModules.restrictScalarsMonoidalOfBijective` (PresheafInternalHom.lean) — H2
     (not directly needed for `dual`, but the same `β`-bijectivity is used).
-/
-/
noncomputable def dual_restrict_iso {X Y : Scheme.{u}} (f : Y ⟶ X)
    [IsOpenImmersion f] (M : X.Modules) :
    (dual M).restrict f ≅ dual (M.restrict f) := by
  -- Step 1. Reduce `restrict` to `pullback` along the open immersion `f`.
  refine (Scheme.Modules.restrictFunctorIsoPullback f).app (dual M) ≪≫ ?_
  -- Step 2. Sheafification commutes with pullback.
  refine (SheafOfModules.sheafificationCompPullback f.toRingCatSheafHom).app
      (PresheafOfModules.dual (R₀ := X.presheaf) M.val) ≪≫ ?_
  -- Step 3. Strip the outer sheafification, descending to the presheaf residual.
  refine (PresheafOfModules.sheafification (R := Y.ringCatSheaf)
      (𝟙 Y.ringCatSheaf.obj)).mapIso ?_
  -- Step 4 (RESIDUAL): the presheaf goal
  --   `(pullback φ).obj (dual M.val) ≅ dual ((M.restrict f).val)`.
  -- H1: replace `pullback φ` with `pushforward β` (β the open-immersion structure ring iso).
  let φR := (Scheme.Hom.toRingCatSheafHom f).hom
  let α : Y.presheaf ⟶ f.opensFunctor.op ⋙ X.presheaf :=
    { app := fun U => (f.appIso U.unop).inv }
  let β : Y.ringCatSheaf.obj ⟶ f.opensFunctor.op ⋙ X.ringCatSheaf.obj :=
    Functor.whiskerRight α (forget₂ CommRingCat RingCat)
  have hadj : PresheafOfModules.pushforward β ⊣ PresheafOfModules.pushforward φR :=
    PresheafOfModules.pushforwardPushforwardAdj f.isOpenEmbedding.isOpenMap.adjunction β φR
      (by ext U x; exact congr($((f.app_appIso_inv _).symm).hom x))
      (by ext U x; exact congr($(f.appIso_inv_app_presheafMap U.unop) x))
  let H1 := hadj.leftAdjointUniq (PresheafOfModules.pullbackPushforwardAdjunction φR)
  refine (H1.app (PresheafOfModules.dual (R₀ := X.presheaf) M.val)).symm ≪≫ ?_
  -- Residual: `(pushforward β).obj (dual M.val) ≅ dual ((pushforward β).obj M.val)`.
  sorry

/-! ## §B. Local triviality of the dual -/

/-- **Presheaf-level: the dual of the monoidal unit is the unit.**
`PresheafOfModules.dual 𝟙_ = ℋom(𝟙_, 𝟙_) ≅ 𝟙_`, the evaluation-at-`1` isomorphism.
Local supplement (the `PresheafOfModules`-level ingredient of `dual_unit_iso`). -/
noncomputable def presheafDualUnitIso {Y : Scheme.{u}} :
    PresheafOfModules.dual (R₀ := Y.presheaf)
        (𝟙_ (_root_.PresheafOfModules.{u} (Y.presheaf ⋙ forget₂ CommRingCat RingCat)))
      ≅ 𝟙_ (_root_.PresheafOfModules.{u} (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) :=
  PresheafOfModules.dualUnitIsoGen (R₀ := Y.presheaf)

/-- **The dual of the structure sheaf is the structure sheaf.** `dual 𝒪_Y ≅ 𝒪_Y`.
The presheaf-level dual of the monoidal unit `𝟙_` is the unit (evaluation at `1`),
sheafified and identified with the (already-sheaf) unit by the sheafification counit.
Mirrors `tensorObj_unit_iso` with the presheaf left unitor replaced by
`presheafDualUnitIso`. The third leg of the `dual_isLocallyTrivial` chain. -/
noncomputable def dual_unit_iso {Y : Scheme.{u}} :
    dual (SheafOfModules.unit Y.ringCatSheaf) ≅ SheafOfModules.unit Y.ringCatSheaf :=
  (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).mapIso
      (presheafDualUnitIso (Y := Y)) ≪≫
    (asIso (PresheafOfModules.sheafificationAdjunction (𝟙 Y.ringCatSheaf.val)).counit).app
      (SheafOfModules.unit Y.ringCatSheaf)

/-- **The dual of a locally-trivial `𝒪_X`-module is locally trivial.**

Blueprint `lem:dual_isLocallyTrivial` (~L5472).  If `L : X.Modules` satisfies
`LineBundle.IsLocallyTrivial L`, then `dual L` is also locally trivial.

/- Planner strategy:
   Blueprint label: lem:dual_isLocallyTrivial (~L5472).
   Uses (dual_restrict_iso is PARTIAL — Step-4 sorry at ~L254; all other deps CLOSED):
     lem:internal_hom_isSheaf  → `Scheme.Modules.dual` (TensorObjSubstrate.lean ~L207)
     lem:dual_restrict_iso     → `dual_restrict_iso` (this file, §A above — PARTIAL, Step-4 sorry)
     def:scheme_modules_dual_iso_of_iso → `Scheme.Modules.dualIsoOfIso`
                                          (TensorObjSubstrate.lean ~L218)
     lem:restrictscalars_ringiso_dualequiv → `restrictScalarsRingIsoDualEquiv`
                                             (PresheafInternalHom.lean ~L234)

   Proof-sketch (blueprint §5.4, three-step chain):
   Unpack `hL : LineBundle.IsLocallyTrivial L`:  for each `x : X` choose an affine open
   `U` with `x ∈ U`, `IsAffineOpen U`, and `eL : L.restrict U.ι ≅ SheafOfModules.unit _`.
   It suffices to exhibit `(dual L).restrict U.ι ≅ SheafOfModules.unit _`.
   The three-step chain (blueprint §5.4):

   Step 1 — `dual_restrict_iso U.ι L`:
     `(dual L).restrict U.ι  ≅  dual (L.restrict U.ι)`

   Step 2 — `dualIsoOfIso eL` (contravariant):
     `dual (L.restrict U.ι)  ≅  dual (SheafOfModules.unit (U : Scheme).ringCatSheaf)`

   Step 3 — `dual_unit_iso` (the dual of the unit is the unit):
     `dual (SheafOfModules.unit _)  ≅  SheafOfModules.unit _`
     The dual of `𝒪_U` is `ℋom(𝒪_U, 𝒪_U) ≅ 𝒪_U` via evaluation-at-1; this should be
     derivable from `InternalHom.internalHomEval` (PresheafInternalHom.lean) + the
     presheaf-level left unitor `λ_ (𝟙_)`.

   Composing Steps 1–3 gives the trivialisation of `(dual L)|_U`.
   Since x was arbitrary, `dual L` is locally trivial.

   Implementation note: the pattern is identical to `tensorObj_isLocallyTrivial`
   (TensorObjSubstrate.lean ~L526), with `dual_restrict_iso` playing the role of
   `tensorObj_restrict_iso` and `dualIsoOfIso` the role of `tensorObjIsoOfIso`.
   Use `intro x; obtain ⟨U, hxU, hU_aff, ⟨eL⟩⟩ := hL x` to unpack, then
   `exact ⟨U, hxU, hU_aff, ⟨dual_restrict_iso U.ι L ≪≫ dualIsoOfIso eL ≪≫ dual_unit_iso⟩⟩`.
   The `dual_unit_iso` is a missing sub-lemma; the prover may need to build it inline or
   as a separate declaration (it is a small sorry if needed, NOT blocked).

   Named CLOSED base lemmas:
   - `Scheme.Modules.dualIsoOfIso` (TensorObjSubstrate.lean ~L218).
   - `dual_restrict_iso` (this file §A — must be proved first).
   - `SheafOfModules.unit` (Mathlib).
   - `InternalHom.internalHomEval` (PresheafInternalHom.lean) — for `dual_unit_iso`.
-/
-/
lemma dual_isLocallyTrivial {X : Scheme.{u}} {L : X.Modules}
    (hL : LineBundle.IsLocallyTrivial L) :
    LineBundle.IsLocallyTrivial (dual L) := by
  -- Mirrors `tensorObj_isLocallyTrivial`: trivialise the dual on each affine open `U`
  -- where `L` is trivial, via the three-step chain
  --   `(dual L)|_U ≅ dual (L|_U) ≅ dual 𝒪_U ≅ 𝒪_U`.
  intro x
  obtain ⟨U, hxU, hU_aff, ⟨eL⟩⟩ := hL x
  refine ⟨U, hxU, hU_aff, ⟨?_⟩⟩
  exact dual_restrict_iso U.ι L ≪≫ (dualIsoOfIso eL).symm ≪≫ dual_unit_iso

/-! ## §C. The A-bridge: compatible local morphisms glue to a global morphism -/

open Opposite TopologicalSpace in
/-- **The local section of the hom-sheaf manufactured from `f i`** (the load-bearing piece
of `homOfLocalCompat`, blueprint `localSection`).  Working with the underlying `Ab`-presheaves
`F = M.val.presheaf`, `G = N.val.presheaf`, the presheaf of types
`presheafHom F G` (`Mathlib.CategoryTheory.Sites.SheafHom`) sends an open `W` to the morphisms of
the restrictions of `F`, `G` to the slice `Over W`.  Its value at `U i` is built from the
components of `f i`, conjugated by `eqToHom` along the down-set identity
`(U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ V) = V` (valid for `V ≤ U i`).  The naturality field — the genuine
coherence risk — is automatic on the thin poset `Opens X` once the `eqToHom`-conjugation is
peeled, via `Subsingleton.elim` on the hom-sets. -/
noncomputable def homLocalSection {X : Scheme.{u}} {M N : X.Modules} {ι : Type*}
    (U : ι → X.Opens) (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι) (i : ι) :
    (CategoryTheory.presheafHom M.val.presheaf N.val.presheaf).obj (op (U i)) where
  app W :=
    haveI hle : W.unop.left ≤ U i := W.unop.hom.le
    haveI himg : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ W.unop.left) = W.unop.left := by
      simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
      exact inf_eq_right.mpr hle
    M.val.presheaf.map (eqToHom (congrArg op himg.symm)) ≫
      ((PresheafOfModules.toPresheaf _).map (f i).val).app (op ((U i).ι ⁻¹ᵁ W.unop.left)) ≫
      N.val.presheaf.map (eqToHom (congrArg op himg))
  naturality := by
    intro A B φ
    have hBA : (unop B).left ≤ (unop A).left := ((Over.forget (U i)).map φ.unop).le
    let κ : (U i).ι ⁻¹ᵁ (unop B).left ⟶ (U i).ι ⁻¹ᵁ (unop A).left :=
      (Opens.map (U i).ι.base).map (homOfLE hBA)
    have himgA : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ (unop A).left) = (unop A).left := by
      simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
      exact inf_eq_right.mpr (unop A).hom.le
    have himgB : (U i).ι ''ᵁ ((U i).ι ⁻¹ᵁ (unop B).left) = (unop B).left := by
      simp only [Scheme.Hom.image_preimage_eq_opensRange_inf, Scheme.Opens.opensRange_ι]
      exact inf_eq_right.mpr (unop B).hom.le
    -- naturality of the underlying ab-presheaf morphism of `f i`
    have hm := ((PresheafOfModules.toPresheaf _).map (f i).val).naturality κ.op
    -- the two thin-poset square edges agree (`Opens X` is a thin poset)
    have hsubM : ((Over.forget (U i)).map φ.unop).op ≫ eqToHom (congrArg op himgB.symm)
        = eqToHom (congrArg op himgA.symm) ≫ ((U i).ι.opensFunctor.map κ).op :=
      Subsingleton.elim _ _
    have hsubN : ((U i).ι.opensFunctor.map κ).op ≫ eqToHom (congrArg op himgB)
        = eqToHom (congrArg op himgA) ≫ ((Over.forget (U i)).map φ.unop).op :=
      Subsingleton.elim _ _
    -- M-side: the φ-restriction followed by the `eqToHom` is the `eqToHom` followed by `κ`
    have hML : M.val.presheaf.map ((Over.forget (U i)).map φ.unop).op ≫
          M.val.presheaf.map (eqToHom (congrArg op himgB.symm))
        = M.val.presheaf.map (eqToHom (congrArg op himgA.symm)) ≫
          (M.restrict (U i).ι).val.presheaf.map κ.op := by
      rw [(M.val.presheaf.map_comp _ _).symm, hsubM]
      exact M.val.presheaf.map_comp _ _
    -- N-side analogue
    have hNR : N.val.presheaf.map ((U i).ι.opensFunctor.map κ).op ≫
          N.val.presheaf.map (eqToHom (congrArg op himgB))
        = N.val.presheaf.map (eqToHom (congrArg op himgA)) ≫
          N.val.presheaf.map ((Over.forget (U i)).map φ.unop).op := by
      rw [(N.val.presheaf.map_comp _ _).symm, hsubN]
      exact N.val.presheaf.map_comp _ _
    dsimp only [Functor.comp_map, Functor.op_map, Functor.op_obj, Functor.comp_obj]
    rw [← Category.assoc, hML]
    erw [Category.assoc, reassoc_of% hm, hNR]
    simp only [Category.assoc]
    rfl

/-- **A-bridge: compatible local `𝒪_X`-module morphisms glue to a global morphism.**

Blueprint `lem:sheafofmodules_hom_of_local_compat` (~L5592).  Let `X` be a scheme,
`M N : X.Modules`, and `{U i}` an indexed open cover of `X`.  If for each `i` we have a
morphism `f i : M.restrict (U i).ι ⟶ N.restrict (U i).ι` in `Scheme.Modules (U i)` such
that for all `i j` the restrictions of `f i` and `f j` to `U i ⊓ U j` are equal (as
morphisms in `Scheme.Modules (U i ⊓ U j)`, compared via `HEq` since the double-restriction
routes give propositionally but not definitionally equal source/target objects), then there
is a unique global morphism `M ⟶ N` in `X.Modules` whose restriction to each `U i` is `f i`.

The compatibility hypothesis `hf` uses `HEq` (heterogeneous equality) to compare the two
restricted morphisms: the LHS `(restrictFunctor (resLE i)).map (f i)` has source
`(M.restrict (U i).ι).restrict (resLE i)` and the RHS has source
`(M.restrict (U j).ι).restrict (resLE j)`, which are propositionally equal (both equal
`M.restrict (U i ⊓ U j).ι` via `restrictFunctorComp`+`restrictFunctorCongr`) but not
definitionally equal.  The prover should establish `HEq` by first proving the types equal
via `congr`+`restrictFunctorComp`, then `heq_of_eq`.

/- Planner strategy:
   Blueprint label: lem:sheafofmodules_hom_of_local_compat (~L5592).
   Uses (all CLOSED):
     def:scheme_modules_homMk → `Scheme.Modules.homMk` (TensorObjSubstrate.lean ~L598)
     lem:open_immersion_slice_sheaf_equiv → `Vestigial.overSliceSheafEquiv`
                                            (TensorObjSubstrate/Vestigial.lean ~L715)

   Proof-sketch (blueprint §5.4, two-step):

   Step (i) — Glue the underlying ab-sheaf morphism:
   Forget M, N to their underlying sheaves of abelian groups.  The presheaf
   `H(W) = Hom_{Ab-preshvs}(M.val.presheaf|_W, N.val.presheaf|_W)` is a sheaf of TYPES:
   this is `Presheaf.IsSheaf.hom` (Mathlib), consuming the sheaf condition of N.
   Convert each `f i` to a local section `s i ∈ H(U i)` via the open-immersion slice
   transport `overSliceSheafEquiv` (Vestigial.lean):
     - `s i` at a pair `(V, h : V ≤ U i)` is `(f i).val.app` at the corresponding open of
       `(U i : Scheme)`, conjugated by `eqToHom` identifications from the down-set identity
       `ι_i(ι_i⁻¹(V)) = V` for `V ≤ U i`.  The naturality of `s i` in V is the
       section-direction slice of `overSliceSheafEquiv` and is automatic on the thin poset
       `Opens X` by `Subsingleton.elim`.
   Apply `TopCat.Sheaf.existsUnique_gluing` (or `Presheaf.IsSheaf.existsUnique_gluing`) to
   amalgamate the compatible family `(s i)_i` into a unique global section
   `s ∈ H(⊤) = (M.val.presheaf ⟶ N.val.presheaf)`.
   Convert the amalgamated `s` to an ab-presheaf morphism `g : M.val.presheaf ⟶ N.val.presheaf`
   via `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv`.

   Step (ii) — Promote to `𝒪_X`-linear via `homMk`:
   The linearity `g(r • m) = r • g(m)` holds on each `U i` (since `g|_{U i}` comes from
   the module morphism `f i`), and the two sides agree globally because the ambient presheaf
   is separated.  Apply `Scheme.Modules.homMk g (sectionwise-linearity proof)` to produce
   `M ⟶ N` in `X.Modules`.

   Key sub-lemma to build first (most fragile piece):
   The naturality field of `s i` — that the `eqToHom`-conjugated components of `f i` commute
   across morphisms of the slice `Over (U i)` — is dominated by `overSliceSheafEquiv` and
   should be extracted as a standalone axiom-clean lemma before the full gluing assembly.

   Named CLOSED base lemmas:
   - `Scheme.Modules.homMk` (TensorObjSubstrate.lean ~L598).
   - `Vestigial.overSliceSheafEquiv` (TensorObjSubstrate/Vestigial.lean ~L715).
   - `TopCat.Presheaf.IsSheaf.hom` (Mathlib) — hom into a sheaf is a sheaf.
   - `TopCat.Sheaf.existsUnique_gluing` (Mathlib) — gluing of compatible sections.
   - `presheafHomSectionsEquiv` / `sheafHomSectionsEquiv` (Mathlib) — top-section ↔ morphism.

   Implementation note: this is a MULTI-PIECE BUILD dominated by the `s i` naturality field.
   Build `s i` (and its naturality) as a standalone verified lemma FIRST, before assembling
   the full gluing.  The step does NOT invoke any tensor stalk — it is purely about gluing
   morphisms of sheaves.
-/
-/
noncomputable def homOfLocalCompat {X : Scheme.{u}} {M N : X.Modules}
    {ι : Type*} (U : ι → X.Opens) (hU : ∀ x : X, ∃ i, x ∈ U i)
    (f : ∀ i, M.restrict (U i).ι ⟶ N.restrict (U i).ι)
    (hf : ∀ i j,
        HEq ((Scheme.Modules.pullback
                (Scheme.Hom.resLE (𝟙 X) (U i) (U i ⊓ U j) inf_le_left)).map (f i))
            ((Scheme.Modules.pullback
                (Scheme.Hom.resLE (𝟙 X) (U j) (U i ⊓ U j) inf_le_right)).map (f j))) :
    M ⟶ N := by
  -- Step (i): glue the underlying ab-sheaf morphism.  The morphisms-presheaf
  -- `presheafHom M.val.presheaf N.val.presheaf` (`Mathlib.CategoryTheory.Sites.SheafHom`) is a
  -- sheaf of types because `N` is a sheaf (`Presheaf.IsSheaf.hom`, consuming `N.isSheaf`).
  let H : TopCat.Sheaf (Type u) (X : TopCat) :=
    ⟨CategoryTheory.presheafHom M.val.presheaf N.val.presheaf,
      Presheaf.IsSheaf.hom M.val.presheaf N.val.presheaf N.isSheaf⟩
  -- The cover `{U i}` exhausts `X`, so `iSup U = ⊤`.
  have hsup : iSup U = ⊤ := by
    rw [eq_top_iff]
    intro x _
    obtain ⟨i, hi⟩ := hU x
    exact TopologicalSpace.Opens.mem_iSup.mpr ⟨i, hi⟩
  -- The compatible family `homLocalSection U f` (its naturality is the load-bearing field,
  -- proved axiom-clean above) glues via `existsUnique_gluing` to a unique global section of `H`
  -- over `iSup U = ⊤`.  `hglue` records the unique-gluing engine fed with these local sections;
  -- it still requires the `IsCompatible` datum, which is exactly the assumed overlap agreement
  -- `hf` (transported through `Vestigial.overSliceSheafEquiv`).
  have hglue := H.existsUnique_gluing U (fun i => homLocalSection U f i)
  -- RESIDUAL (the remaining blueprint sub-steps (i.a)/(i.b)/(ii)):
  --   (a) `IsCompatible H.1 U (homLocalSection U f)` — the cocycle condition, = `hf` on the
  --       overlaps `U i ⊓ U j` (HEq-comparison of the two double-restrictions of `f i`, `f j`);
  --   (b) convert the amalgamated section over `op ⊤` (terminal in `Opens X`) to a morphism
  --       `g : M.val.presheaf ⟶ N.val.presheaf` of the underlying ab-presheaves
  --       (`presheafHomSectionsEquiv`/the `⊤`-section identification);
  --   (c) the sectionwise `𝒪_X`-linearity `hg` of `g`, then `Scheme.Modules.homMk g hg : M ⟶ N`.
  -- The load-bearing local-section construction `homLocalSection` (incl. naturality) is complete;
  -- what remains is the gluing/conversion/linearity bookkeeping.
  sorry

end Modules

end Scheme

end AlgebraicGeometry
