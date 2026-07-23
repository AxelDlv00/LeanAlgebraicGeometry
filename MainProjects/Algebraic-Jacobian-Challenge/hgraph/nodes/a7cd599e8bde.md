---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.sheafPullbackUnit_forget_eq
docstring: '**Part III of the B1-crux: the sheaf pullback unit, transported by `forget`,
  factors as the

  presheaf pullback unit followed by sheafification and the `pullbackValIso` comparison.**


  For an open immersion `f`, the unit of the *sheaf*-level adjunction `pullback f
  ⊣ pushforward f`

  (`SheafOfModules`), pushed through the forgetful functor to presheaves, equals the
  *presheaf*-level

  pullback–pushforward unit composed with the sheafification unit `η` and the sheaf
  comparison

  `pullbackValIso f M` (transported through `forget`).  This is the genuine sheafification-boundary

  content of the B1 crux `H1inv_app_eq_pullbackVal_restrict`; the remaining legs of
  that crux

  (restriction-side `unit_leftAdjointUniq`, the `forget`/`pushforward` functoriality)
  are formal.


  Proof route: both sides are maps `M.val ⟶ (pushforward φ'').obj (forget ((pullback
  f).obj M))`.

  The RHS is `unit ≫ (pushforward φ'').map (η ≫ forget pbv) = homEquiv (η ≫ forget
  pbv)` for the

  presheaf pullback adjunction, so by `homEquiv`-injectivity it suffices to show

  `homEquiv.symm (forget (sheaf-unit)) = η ≫ forget pbv`, a presheaf-level counit/unit
  identity in

  the sheafification–pullback square.'
file: AlgebraicJacobian/Picard/TensorObjInverse.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.Scheme.Modules.sheafPullbackUnit_forget_eq
type: lean
updated: '2026-07-24T03:02:12'
---
private lemma sheafPullbackUnit_forget_eq {X Y : Scheme.{u}} (f : Y ⟶ X) [IsOpenImmersion f]
    (M : X.Modules) :
    letI φ' : (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
        (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat) :=
        (f.toRingCatSheafHom).hom
    (SheafOfModules.forget X.ringCatSheaf).map ((pullbackPushforwardAdjunction f).unit.app M)
      = (PresheafOfModules.pullbackPushforwardAdjunction φ').unit.app M.val
        ≫ (PresheafOfModules.pushforward φ').map
            ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                (𝟙 Y.ringCatSheaf.val)).unit.app ((PresheafOfModules.pullback φ').obj M.val)
              ≫ (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom) := by
  -- iter-052 RESTRUCTURE.  The genuine content is to compute the *opaque* sheaf pullback unit
  -- `(pullbackPushforwardAdjunction f).unit.app M` (built by `Adjunction.ofIsRightAdjoint`).
  -- Mathlib's `pullbackIso φ = leftAdjointUniq (pullbackPushforwardAdjunction φ)
  -- (PullbackConstruction.adjunction φ)` relates it to the CONCRETE
  -- `PullbackConstruction.adjunction φ` (same right adjoint `pushforward φ`), whose unit is
  -- computable from its explicit `homEquiv`.  The unit triangle gives
  --   `u_sheaf = PC.unit ≫ pushforward.map (pullbackIso.inv.app M)`;
  -- transporting through `forget` and reading off `PC.unit` lands the LHS on the presheaf composite
  --   `u_pre ≫ pushforward.map (η ≫ forget (pullbackIso.inv.app M))`.
  -- The residual `hKEY` identifies `pullbackIso.inv.app M` with `(pullbackValIso f M).hom`.
  set φ := Hom.toRingCatSheafHom f with hφ
  -- Step A: the `pullbackIso` unit triangle, solved for the opaque sheaf unit.
  have htri : (SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M
        ≫ (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).hom.app M)
      = (SheafOfModules.PullbackConstruction.adjunction φ).unit.app M :=
    Adjunction.unit_leftAdjointUniq_hom_app _ _ M
  -- `pushforward.map ρ.hom ≫ pushforward.map ρ.inv = 𝟙` (term mode: the `SheafOfModules` `≫` is
  -- defeq-but-not-syntactic, so every category-lemma step is applied via `:=`/`Eq.trans`).
  have hcancel : (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).hom.app M)
        ≫ (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).inv.app M) = 𝟙 _ :=
    (CategoryTheory.Functor.map_comp (SheafOfModules.pushforward φ) _ _).symm.trans
      ((congrArg (SheafOfModules.pushforward φ).map
        (Iso.hom_inv_id_app (SheafOfModules.pullbackIso φ) M)).trans
        (CategoryTheory.Functor.map_id (SheafOfModules.pushforward φ) _))
  have hA : (pullbackPushforwardAdjunction f).unit.app M
      = (SheafOfModules.PullbackConstruction.adjunction φ).unit.app M
        ≫ (SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).inv.app M) := by
    rw [← htri]
    exact (Eq.trans (Category.assoc _ _ _)
      (Eq.trans (congrArg (fun t => (SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M ≫ t)
        hcancel) (Category.comp_id _))).symm
  -- Step B/C: compute `forget (PC.unit.app M)` from the explicit `PullbackConstruction.homEquiv`
  -- (`= sheafAdj_Y.homEquiv ∘ pullbackPPAdj_pre.homEquiv ∘ forget.homEquiv.symm`).  Reading off the
  -- two `homEquiv_unit`s and `forget ∘ forget.homEquiv.symm = id` yields the presheaf-level
  -- `u_pre ≫ pushforward.map η_Y`.
  have hUNIT : (SheafOfModules.forget X.ringCatSheaf).map
        ((SheafOfModules.PullbackConstruction.adjunction φ).unit.app M)
      = (PresheafOfModules.pullbackPushforwardAdjunction φ.hom).unit.app M.val
        ≫ (PresheafOfModules.pushforward φ.hom).map
            ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                (𝟙 Y.ringCatSheaf.val)).unit.app
              ((PresheafOfModules.pullback φ.hom).obj M.val)) := by
    simp only [SheafOfModules.PullbackConstruction.adjunction, Adjunction.mkOfHomEquiv_unit_app]
    -- The `Equiv.trans` coercion only matches up to defeq, so drive the unfold with `erw`:
    -- two `Equiv.trans_apply`, then the two `homEquiv_unit`s (inner sheafification unit, outer
    -- presheaf pullback unit), collapse `map (𝟙)`, and `forget ∘ forget.preimage = id`.
    erw [Equiv.trans_apply, Equiv.trans_apply, Adjunction.homEquiv_unit, Adjunction.homEquiv_unit,
      CategoryTheory.Functor.map_id, Category.comp_id,
      (SheafOfModules.fullyFaithfulForget X.ringCatSheaf).map_preimage]
    rfl
  -- RESIDUAL `hKEY` (the sole content of the B1 crux still open): the Mathlib `pullbackIso φ` and
  -- the project `pullbackValIso f M` (built from `sheafificationCompPullback` + the X-side
  -- sheafification counit) are the SAME iso `a_Y (pullback φ' M.val) ≅ pullback f M`.  Both are
  -- `leftAdjointUniq`-comparisons onto `pushforward φ`; the identity is the compatibility of
  -- `pullbackIso` with `sheafificationCompPullback` across the X-counit `c_aX.app M`.
  have hKEY : (SheafOfModules.pullbackIso φ).inv.app M = (pullbackValIso f M).hom := by
    -- Transpose along the CONCRETE `PullbackConstruction` adjunction (`homEquiv` injective):
    -- `pullbackIso.inv.app M = (leftAdjointUniq PC pullbackPPAdj_sheaf).hom.app M`
    -- (`leftAdjointUniq_inv_app`), and `homEquiv_leftAdjointUniq_hom_app` sends its `PC.homEquiv`
    -- image to the opaque sheaf unit `pullbackPPAdj_sheaf.unit.app M`.  This reduces `hKEY` to the
    -- unit-comparison `hA2`.
    rw [show (SheafOfModules.pullbackIso φ).inv.app M
          = ((SheafOfModules.PullbackConstruction.adjunction φ).leftAdjointUniq
              (SheafOfModules.pullbackPushforwardAdjunction φ)).hom.app M
        from Adjunction.leftAdjointUniq_inv_app _ _ M]
    apply (SheafOfModules.PullbackConstruction.adjunction φ).homEquiv M
      ((SheafOfModules.pullback φ).obj M) |>.injective
    rw [Adjunction.homEquiv_leftAdjointUniq_hom_app, Adjunction.homEquiv_unit]
    -- GOAL `hA2`: `pullbackPPAdj_sheaf.unit.app M
    --                = PC.unit.app M ≫ (pushforward φ).map (pullbackValIso f M).hom`.
    -- This is the genuine sheafification-intertwining content of the B1 crux.  It is NOT provable by
    -- further transposition (every `homEquiv` route is circular — `hKEY`/`hA2`/the parent `G0` are
    -- all logically equivalent).  The sole non-circular input is the DEFINITION of
    -- `sheafificationCompPullback` as `leftAdjointUniq A B` (root
    -- `sheafificationCompPullback_eq_leftAdjointUniq`), with
    --   A = sheafAdj_X.comp pullbackPPAdj_sheaf,   B = pullbackPPAdj_pre.comp sheafAdj_Y.
    -- Route (mate calculus, ~80–150 LOC, the planner's flagged residual):
    --  (1) naturality of `η_s := pullbackPPAdj_sheaf.unit` along the X-counit iso
    --      `ε := sheafAdj_X.counit.app M : a_X M.val ⟶ M` rewrites `η_s.app M` as
    --      `ε⁻¹ ≫ η_s.app (a_X M.val) ≫ (pushforward).map (pullback_sheaf.map ε)`.
    --  (2) `Adjunction.unit_leftAdjointUniq_hom_app A B M.val` + `Adjunction.comp_unit_app` pin
    --      `forget (η_s.app (a_X M.val))` against `sheafCompPullback.hom.app M.val` and
    --      `B.unit.app M.val = u_pre ≫ (pushforward).map η_Y` (which is `forget (PC.unit.app M)`,
    --      i.e. the already-proven `hUNIT`).
    --  (3) `pullbackValIso.hom = sheafCompPullback.inv.app M.val ≫ pullback_sheaf.map ε`; the two
    --      `ε`/`pullback_sheaf.map ε` legs cancel, leaving exactly the `sheafCompPullback` unit
    --      identity from (2).  ESCALATION (per PROGRESS iter-052): mathlib-analogist cross-domain on
    --      `ofIsRightAdjoint`-unit transparency / the `pullbackIso ↔ sheafificationCompPullback`
    --      coherence (NO Mathlib API relates these two un-lemma'd `leftAdjointUniq` defs).
    -- Scaffolding for the route (both genuine non-circular inputs typecheck):
    --   `hnat` — naturality of the sheaf unit along the X-counit `ε`.
    --   `hpin` — the `sheafificationCompPullback` definition as `unit_leftAdjointUniq` of A vs B.
    have hnat := (SheafOfModules.pullbackPushforwardAdjunction φ).unit.naturality
      ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
        (𝟙 X.ringCatSheaf.val)).counit.app M)
    have hpin := Adjunction.unit_leftAdjointUniq_hom_app
      ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).comp (SheafOfModules.pullbackPushforwardAdjunction φ))
      ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
        (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.val)))
      M.val
    -- Telescope (analogist Analogue 1, ported): transpose to the presheaf world via forget
    -- faithfulness, then chase the opaque sheaf unit `η_s.app M` through the X-counit `ε` (hnat),
    -- the `A`-unit comp formula (`comp_unit_app`), `hpin` (= sheafCompPullback unit triangle), and
    -- the `B`-unit comp formula, landing on the presheaf composite `u_pre ≫ pushforward.map η_Y`.
    apply (SheafOfModules.fullyFaithfulForget X.ringCatSheaf).map_injective
    -- RHS: split forget over the sheaf composite (erw past the SheafOfModules ≫ seam), insert hUNIT.
    erw [CategoryTheory.Functor.map_comp]
    rw [hUNIT]
    -- LHS telescope (P1): forget(hnat) split + the X-sheafification triangle.
    have hfn := congrArg (SheafOfModules.forget X.ringCatSheaf).map hnat
    erw [CategoryTheory.Functor.map_comp, CategoryTheory.Functor.map_comp] at hfn
    have htri2 := (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
      (𝟙 X.ringCatSheaf.val)).right_triangle_components (Y := M)
    simp only [Functor.id_obj, Functor.id_map, Functor.comp_map, restrictScalarsId_map] at hfn htri2
    -- Cleanly-typed sheafification triangle (`(forget⋙restrict).obj M` is defeq `M.val`).
    have htri2' : (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).unit.app M.val
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).counit.app M)
        = 𝟙 M.val := htri2
    -- ε-cancelled LHS: solve `forget(hnat)` for `forget(η_s M)` via the triangle.
    have hLHS : (SheafOfModules.forget X.ringCatSheaf).map
          ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M)
        = (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).unit.app M.val
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app
                (((SheafOfModules.forget X.ringCatSheaf ⋙
                      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)) ⋙
                    PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj M))
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pushforward φ).map
                ((SheafOfModules.pullback φ).map
                  ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                    (𝟙 X.ringCatSheaf.val)).counit.app M))) := by
      rw [show (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M)
            = 𝟙 M.val ≫ (SheafOfModules.forget X.ringCatSheaf).map
                ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app M)
          from (Category.id_comp _).symm, ← htri2']
      exact (Category.assoc _ _ _).trans
        (congrArg (fun t => (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
          (𝟙 X.ringCatSheaf.val)).unit.app M.val ≫ t) hfn)
    rw [hLHS]
    -- `η ≫ (forget η_s)` is, on the nose, the composite-adjunction unit `A.unit` (proved before
    -- the `set` so the bare `rfl` can still zeta-unfold the `Adjunction.comp`).
    have hAcomp : (PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).unit.app M.val
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pullbackPushforwardAdjunction φ).unit.app
                (((SheafOfModules.forget X.ringCatSheaf ⋙
                      PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)) ⋙
                    PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.val)).obj M))
        = ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).comp
            (SheafOfModules.pullbackPushforwardAdjunction φ)).unit.app M.val := rfl
    -- `A.unit` solved by the inverse `leftAdjointUniq` unit triangle (`B.leftAdjointUniq A`):
    -- `A.unit = B.unit ≫ R.map((A.leftAdjointUniq B)⁻¹)`.
    have hAcancel : ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
            (𝟙 X.ringCatSheaf.val)).comp
          (SheafOfModules.pullbackPushforwardAdjunction φ)).unit.app M.val
        = ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
              (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                (𝟙 Y.ringCatSheaf.val))).unit.app M.val
          ≫ (SheafOfModules.pushforward φ ⋙ SheafOfModules.forget X.ringCatSheaf ⋙
              PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)).map
              ((((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                    (𝟙 X.ringCatSheaf.val)).comp
                  (SheafOfModules.pullbackPushforwardAdjunction φ)).leftAdjointUniq
                ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
                  (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                    (𝟙 Y.ringCatSheaf.val)))).inv.app M.val) := by
      rw [Adjunction.leftAdjointUniq_inv_app]
      exact (Adjunction.unit_leftAdjointUniq_hom_app _ _ M.val).symm
    -- `pullbackValIso.hom = sheafCompPullback⁻¹ ≫ pullback.map (X-counit)`.
    have hpbv : (pullbackValIso f M).hom
        = (SheafOfModules.sheafificationCompPullback φ).inv.app M.val
          ≫ (SheafOfModules.pullback φ).map
              ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                (𝟙 X.ringCatSheaf.val)).counit.app M) := by
      rw [pullbackValIso, Iso.trans_hom, Iso.symm_hom, Functor.mapIso_hom]
      rfl
    -- The `scp⁻¹`/`pullbackValIso` reconciliation (last leg).
    have hFINAL : (SheafOfModules.pushforward φ ⋙ SheafOfModules.forget X.ringCatSheaf ⋙
            PresheafOfModules.restrictScalars (𝟙 X.ringCatSheaf.val)).map
            ((((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                  (𝟙 X.ringCatSheaf.val)).comp
                (SheafOfModules.pullbackPushforwardAdjunction φ)).leftAdjointUniq
              ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
                (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
                  (𝟙 Y.ringCatSheaf.val)))).inv.app M.val)
          ≫ (SheafOfModules.forget X.ringCatSheaf).map
              ((SheafOfModules.pushforward φ).map
                ((SheafOfModules.pullback φ).map
                  ((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
                    (𝟙 X.ringCatSheaf.val)).counit.app M)))
        = (SheafOfModules.forget X.ringCatSheaf).map
            ((SheafOfModules.pushforward φ).map (pullbackValIso f M).hom) := by
      -- Bridge the explicit `leftAdjointUniq` back to `sheafificationCompPullback` (defeq through the
      -- `set φ := Hom.toRingCatSheafHom f`, so a `rw` of the lemma at `f` would miss).
      have hscp_eq : (((PresheafOfModules.sheafificationAdjunction (R := X.ringCatSheaf)
              (𝟙 X.ringCatSheaf.val)).comp
            (SheafOfModules.pullbackPushforwardAdjunction φ)).leftAdjointUniq
          ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
            (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
              (𝟙 Y.ringCatSheaf.val))))
          = SheafOfModules.sheafificationCompPullback φ :=
        (sheafificationCompPullback_eq_leftAdjointUniq f).symm
      rw [hpbv, hscp_eq]
      erw [CategoryTheory.Functor.map_comp, CategoryTheory.Functor.map_comp]
      rfl
    -- Assemble: reassociate, recognise `A.unit`, cancel via the inverse triangle, merge the last leg.
    refine Eq.trans (Category.assoc _ _ _).symm ?_
    rw [hAcomp, hAcancel]
    -- `(B.unit ≫ R.map scp⁻¹) ≫ last`; reassociate and merge the last leg via `hFINAL` (term mode,
    -- so the final `B.unit = ppP.unit ≫ pushforward.map η_Y` step is discharged by defeq).
    exact Eq.trans (Category.assoc _ _ _)
      (congrArg (fun t => ((PresheafOfModules.pullbackPushforwardAdjunction φ.hom).comp
        (PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
          (𝟙 Y.ringCatSheaf.val))).unit.app M.val ≫ t) hFINAL)
  -- Assemble: rewrite the opaque unit, split `forget` over `≫` (term mode for the `SheafOfModules`
  -- seam), insert `hUNIT`/`hKEY`, then merge the two presheaf `pushforward.map` legs.
  rw [hA]
  refine Eq.trans (CategoryTheory.Functor.map_comp (SheafOfModules.forget X.ringCatSheaf)
    ((SheafOfModules.PullbackConstruction.adjunction φ).unit.app M)
    ((SheafOfModules.pushforward φ).map ((SheafOfModules.pullbackIso φ).inv.app M))) ?_
  rw [hUNIT, hKEY]
  refine Eq.trans (Category.assoc _ _ _) ?_
  exact (congrArg (fun t => (PresheafOfModules.pullbackPushforwardAdjunction φ.hom).unit.app M.val ≫ t)
    (CategoryTheory.Functor.map_comp (PresheafOfModules.pushforward φ.hom)
        ((PresheafOfModules.sheafificationAdjunction (R := Y.ringCatSheaf)
            (𝟙 Y.ringCatSheaf.val)).unit.app ((PresheafOfModules.pullback φ.hom).obj M.val))
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom))).symm

-- The `homEquiv`/`leftAdjointUniq` unfolding over the heavy sheafification-laden adjunctions is
-- heartbeat-heavy; bump past the default.
set_option maxHeartbeats 1600000 in