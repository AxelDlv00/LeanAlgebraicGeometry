---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare
docstring: '**The unit square** (blueprint `lem:eta_bridge_unit_square`, the assembly
  target). The

  sheafified presheaf unit comparison `a_Y.map (η F)`, conjugated by the canonical
  isos

  `pullbackValIso` and `sheafifyUnitIso`, equals the sheaf-level structure-unit comparison

  `pullbackObjUnitToUnit φ`. The proof transposes the square across the *sheaf* pullback–pushforward

  adjunction `pullbackPushforwardAdjunction φ` (`homEquiv.injective`); the right-hand
  side image is

  `unitToPushforwardObjUnit φ` by `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`,

  reducing the square to the concrete pushforward-side identity (∗∗), which telescopes
  through the

  already-closed `compHomEquivFactor` (step 3), `leftAdjointUniqUnitEta` (step 4)
  and

  `presheafUnit_comp_map_eta` (step 6). Project-local.'
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.pullbackEtaUnitSquare
type: lean
updated: '2026-07-24T03:02:12'
---
lemma pullbackEtaUnitSquare {X Y : Scheme.{u}} (f : Y ⟶ X) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (pullbackValIso f (SheafOfModules.unit X.ringCatSheaf)).inv ≫
        (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)).map
          (Functor.OplaxMonoidal.η (PresheafOfModules.pullback φ')) ≫ sheafifyUnitIso.hom
        = SheafOfModules.pullbackObjUnitToUnit f.toRingCatSheafHom := by
  letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
      (f.toRingCatSheafHom).hom
  set φ := f.toRingCatSheafHom with hφ
  -- Transpose across the sheaf pullback–pushforward adjunction.
  apply ((SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv
    (SheafOfModules.unit X.ringCatSheaf) (SheafOfModules.unit Y.ringCatSheaf)).injective
  rw [SheafOfModules.pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit]
  -- We keep the goal in `homEquiv` form (NOT unfolding via `homEquiv_unit`), driving the
  -- telescope through the closed mate-lemmas `compHomEquivFactor`, `leftAdjointUniqUnitEta`,
  -- `presheafUnit_comp_map_eta` and the `rfl`-linchpin `sheafificationCompPullback_eq_leftAdjointUniq`.
  -- Step 1: decompose `pullbackValIso.inv` into `(pullback φ).map c⁻¹ ≫ (sheafificationCompPullback φ).hom`
  -- where `c = (asIso (sheafification-counit_X)).app 𝒪_X`.
  simp only [pullbackValIso, Iso.trans_inv, Iso.symm_inv, Functor.mapIso_inv]
  rw [Category.assoc]
  -- Step 2: pull the leading `(pullback φ).map c⁻¹` out of `homEquiv` (`homEquiv_naturality_left`),
  -- then peel off the trailing `rest = a_Y.map (η F) ≫ sheafifyUnitIso.hom` (`homEquiv_naturality_right`).
  erw [Adjunction.homEquiv_naturality_left, Adjunction.homEquiv_naturality_right]
  -- Steps 3+4: rewrite `sheafAdj.homEquiv (sheafificationCompPullback φ).hom.app 𝟙ᵖ` via the
  -- composite-adjunction factorisation `compHomEquivFactor` and then `leftAdjointUniqUnitEta`.
  have hkey :
      (SheafOfModules.pullbackPushforwardAdjunction φ).homEquiv _ _
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
            (SheafOfModules.unit X.ringCatSheaf).val).hom
        = ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).homEquiv _ _).symm
            (((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).comp
                (SheafOfModules.pullbackPushforwardAdjunction φ)).homEquiv _ _
              ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
                (SheafOfModules.unit X.ringCatSheaf).val).hom) := by
    rw [Equiv.eq_symm_apply, ← compHomEquivFactor]
  erw [hkey, leftAdjointUniqUnitEta f]
  -- Fold the trailing `(pushforward φ).map rest` into the X-side `homEquiv.symm`
  -- (`homEquiv_naturality_right_symm`): `symm(x) ≫ k = symm(x ≫ R_X.map k)`.
  erw [← Adjunction.homEquiv_naturality_right_symm]
  -- X-triangle (`right_triangle_components`): the sheafification unit/counit on the sheaf `𝒪_X`
  -- cancel, collapsing `homEquiv (c.hom ≫ unitToPushforwardObjUnit φ)` to `(unitToPushforwardObjUnit φ).val`.
  have hXtri : (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).unit.app
        (SheafOfModules.unit X.ringCatSheaf).val ≫
      (PresheafOfModules.restrictScalars (𝟙 (Sheaf.val X.ringCatSheaf))).map
        ((SheafOfModules.forget X.ringCatSheaf).map
          ((asIso (PresheafOfModules.sheafificationAdjunction
              (𝟙 (Sheaf.val X.ringCatSheaf))).counit).app (SheafOfModules.unit X.ringCatSheaf)).hom)
      = 𝟙 _ := by
    have h := (PresheafOfModules.sheafificationAdjunction
        (𝟙 (Sheaf.val X.ringCatSheaf))).right_triangle_components (SheafOfModules.unit X.ringCatSheaf)
    simp only [Iso.app_hom, asIso_hom, Functor.comp_map] at h ⊢
    exact h
  have hrhs : ((PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).homEquiv
        (SheafOfModules.unit X.ringCatSheaf).val
        ((SheafOfModules.pushforward φ).obj (SheafOfModules.unit Y.ringCatSheaf)))
      (((asIso (PresheafOfModules.sheafificationAdjunction (𝟙 (Sheaf.val X.ringCatSheaf))).counit).app
          (SheafOfModules.unit X.ringCatSheaf)).hom ≫ SheafOfModules.unitToPushforwardObjUnit φ)
      = (SheafOfModules.forget X.ringCatSheaf ⋙
          PresheafOfModules.restrictScalars (𝟙 (Sheaf.val X.ringCatSheaf))).map
          (SheafOfModules.unitToPushforwardObjUnit φ) := by
    rw [Adjunction.homEquiv_unit]
    simp only [Functor.comp_map, Functor.map_comp]
    exact (Category.assoc _ _ _).symm.trans (hXtri ▸ Category.id_comp _)
  -- Move `c⁻¹` to the RHS (`Iso.inv_comp_eq`), transpose the X-side `homEquiv.symm`
  -- (`Equiv.symm_apply_eq`), and collapse via `hrhs`, reducing to a PRESHEAF-level equation
  -- whose RHS is `(unitToPushforwardObjUnit φ).val`.
  rw [Iso.inv_comp_eq, Equiv.symm_apply_eq]
  refine Eq.trans ?_ hrhs.symm
  -- REMAINING (∗∗): the concrete pushforward-side presheaf identity.  Substep (i): split the `.val`
  -- of `g = a_Y.map (η F) ≫ sheafifyUnitIso.hom` and reduce `R_X.map ((pushforward φ).map g)`.
  simp only [Functor.comp_map, SheafOfModules.forget_map, SheafOfModules.pushforward_map_val,
    SheafOfModules.comp_val]
  -- Strip the two `restrictScalars (𝟙)` wrappers SYNTACTICALLY via `restrictScalarsId_map`, landing
  -- the goal in the syntactic presheaf category (no `whnf` on `rs`-over-sheafification — that is
  -- catastrophic).  This succeeds and leaves the CLEAN presheaf goal
  --   `(u ≫ pf₁.map toSheafify_Y) ≫ pf₂.map ((a_Y.map (η F)).val ≫ sheafifyUnitIso.hom.val)
  --      = (unitToPushforwardObjUnit (Hom.toRingCatSheafHom f)).val`,
  -- where `pf₁ = pushforward (Hom.toRingCatSheafHom f).hom` and `pf₂ = pushforward φ.hom` are DEFEQ
  -- but spelled differently (`Hom.toRingCatSheafHom f` from `leftAdjointUniqUnitEta` vs the `set`-local
  -- `φ`).  The remaining math is exactly: merge the two `pushforward`-images via `Functor.map_comp`,
  -- fold `toSheafify_Y ≫ (a_Y.map (η F)).val ≫ sheafifyUnitIso.hom.val = η F` by the (closed)
  -- `pullbackSheafifyUnitEtaTriangle f`, then `presheafUnit_comp_map_eta f` and (closed)
  -- `epsilonPresheafToSheafUnit f` collapse to `(unitToPushforwardObjUnit φ).val`.
  rw [restrictScalarsId_map, restrictScalarsId_map]
  -- Reassociate and merge the two `pushforward φ'`-images via `erw` (keyed-defeq matching tolerates the
  -- `pf₁`/`pf₂` zeta-spelling at the connecting object), fold the argument to `η F` (ii), and collapse
  -- to `(unitToPushforwardObjUnit φ).val` via (6) `presheafUnit_comp_map_eta` + (iii) `epsilonPresheafToSheafUnit`.
  erw [Category.assoc, ← Functor.map_comp, pullbackSheafifyUnitEtaTriangle f,
    presheafUnit_comp_map_eta f, epsilonPresheafToSheafUnit f]