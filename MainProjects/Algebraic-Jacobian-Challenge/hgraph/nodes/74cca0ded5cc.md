---
author: sync
content_type: theorem
created: '2026-07-16T21:14:27'
decl: AlgebraicGeometry.pullback_app_isoTensor_baseMap_sectionLinearEquiv
docstring: "**Section-level LinearEquiv via the Tilde route** (iter-188 Lane F NAMED\n\
  HELPER, iter-189 unbundling refactor).\n\nThe substantive transport-and-intertwining\
  \ helper: given a morphism `g : Y ⟶ X`\nof schemes, a quasi-coherent module `N`\
  \ on `X`, and affine opens\n`V ⊆ X`, `U ⊆ Y` with `U ⊆ g⁻¹ V`, produces:\n- a `Γ(Y,\
  \ U)`-linear equiv between `TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V)`\n  and `Γ((pullback\
  \ g).obj N, U)`, and\n- a proof that this equiv sends `1 ⊗ x` to `pullback_app_isoTensor_baseMap\
  \ g N e x`\n  (the Beck-Chevalley compatibility).\n\nThe construction follows the\
  \ iter-187 analogist-licensed Tilde route\n(`analogies/quotscheme-isbasechange-tilde.md`):\n\
  \  Step 1: identify `N|_V ≅ tilde Γ(N, V)` on `Spec Γ(X, V)` using\n    `[N.IsQuasicoherent]`\
  \ (extract a presentation on the affine open\n    after transporting via `hV.isoSpec`).\n\
  \  Step 2: pull back via `Spec.map φ : Spec Γ(Y, U) ⟶ Spec Γ(X, V)`,\n    where\
  \ `φ = g.appLE V U e`; apply `pullback_tildeIso` to obtain\n    `(pullback (Spec.map\
  \ φ)).obj (tilde Γ(N, V)) ≅\n      tilde (Γ(Y, U) ⊗ Γ(N, V))` on `Spec Γ(Y, U)`.\n\
  \  Step 3: transport via `hU.isoSpec` back to `U`-sections of\n    `(pullback g).obj\
  \ N`.\n  Step 4: evaluate at `⊤` via `tilde.isoTop` to extract the section-level\n\
  \    linear equiv.\n  Step 5: verify the intertwining via naturality of the adjunction\
  \ unit\n    (the Beck-Chevalley compatibility check; ~30-50 LOC).\n\nThe substantive\
  \ Mathlib gap content (Stacks 01HQ \"pullback of tilde =\ntilde of base change\"\
  , plus the affine-open / Spec transport) is now\nfully assembled in the body from\
  \ `pullback_tildeIso`,\n`tildeIso_of_isQuasicoherent_isAffineOpen`,\n`pullback_of_openImmersion_iso_restrict`,\
  \ and the N1-N4 naturality\nhelpers — all sorry-free. This helper is closed axiom-clean."
file: AlgebraicJacobian/Picard/QuotScheme.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.pullback_app_isoTensor_baseMap_sectionLinearEquiv
type: lean
updated: '2026-07-16T21:14:27'
---
theorem pullback_app_isoTensor_baseMap_sectionLinearEquiv
    {X Y : Scheme.{u}} (g : Y ⟶ X) (N : X.Modules) [N.IsQuasicoherent]
    {U : Y.Opens} {V : X.Opens}
    (_hU : IsAffineOpen U) (_hV : IsAffineOpen V)
    (e : U ≤ g ⁻¹ᵁ V) :
    letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
    letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
      Module.compHom _ (g.appLE V U e).hom
    Nonempty {f : TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) ≃ₗ[Γ(Y, U)]
                Γ((Scheme.Modules.pullback g).obj N, U) //
      ∀ x : Γ(N, V),
        f (1 ⊗ₜ[Γ(X, V)] x) = pullback_app_isoTensor_baseMap g N e x} := by
  letI : Algebra Γ(X, V) Γ(Y, U) := (g.appLE V U e).hom.toAlgebra
  letI : Module Γ(X, V) Γ((Scheme.Modules.pullback g).obj N, U) :=
    Module.compHom _ (g.appLE V U e).hom
  -- iter-189 Lane F unbundle (per `analogies/lane-f-isbasechange.md`
  -- Decision 4): three Mathlib gaps are now pinned as separately-named
  -- typed sorries; the body of `_sectionLinearEquiv` is reduced to
  -- compositional bookkeeping over the chain.
  --
  -- Step 1 (Stacks 01I8 — `tildeIso_of_isQuasicoherent_isAffineOpen`):
  --   `N|_{Spec Γ(X, V)} ≅ tilde Γ(N, V)`  on  `Spec Γ(X, V)`.
  -- Pulling back along `Spec.map φ : Spec Γ(Y, U) ⟶ Spec Γ(X, V)`
  -- (where `φ = g.appLE V U e`) and applying Step 2 (`pullback_tildeIso`,
  -- Stacks 01HQ) gives `(Spec.map φ)^* tilde Γ(N, V) ≅
  --   tilde (Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V))`.
  -- Identifying the two compositions via the commutative square
  -- `hU.fromSpec ≫ g = Spec.map φ ≫ hV.fromSpec` and applying Step 3
  -- transport (`pullback_of_openImmersion_iso_restrict`) brings the
  -- section back to `U` itself. Evaluating tilde at `⊤` via
  -- `tilde.isoTop` extracts the section-level data; the underlying
  -- module of `tilde (Γ(Y, U) ⊗ Γ(N, V))` at `⊤` is exactly
  -- `Γ(Y, U) ⊗_{Γ(X, V)} Γ(N, V)`. The intertwining at `1 ⊗ x` (the
  -- Beck-Chevalley check) follows from naturality of the adjunction
  -- unit `pullback_app_isoTensor_unitAtV`.
  obtain ⟨⟨step1, _step1_apply⟩⟩ :=
    tildeIso_of_isQuasicoherent_isAffineOpen N _hV
  obtain ⟨⟨step2, _step2_apply⟩⟩ :=
    pullback_tildeIso (g.appLE V U e) (ModuleCat.of Γ(X, V) Γ(N, V))
  obtain ⟨⟨step3, _step3_symm_apply⟩⟩ :=
    pullback_of_openImmersion_iso_restrict
      ((Scheme.Modules.pullback g).obj N) _hU
  -- iter-193 Lane F: assemble the iso chain at the sheaf level.
  -- The commutative square `hU.fromSpec ≫ g = Spec.map φ ≫ hV.fromSpec`
  -- (where `φ = g.appLE V U e`) comes from Mathlib's
  -- `IsAffineOpen.SpecMap_appLE_fromSpec`.
  have h_eq : _hU.fromSpec ≫ g = Spec.map (g.appLE V U e) ≫ _hV.fromSpec :=
    (IsAffineOpen.SpecMap_appLE_fromSpec g _hV _hU e).symm
  -- Sheaf-level iso chain (5-step compositional transport):
  --   (pullback hU.fromSpec).obj ((pullback g).obj N)
  -- = (pullback g ⋙ pullback hU.fromSpec).obj N                         [defeq]
  -- ≅ (pullback (hU.fromSpec ≫ g)).obj N             [pullbackComp]
  -- ≅ (pullback (Spec.map φ ≫ hV.fromSpec)).obj N    [pullbackCongr h_eq]
  -- ≅ (pullback (Spec.map φ)).obj ((pullback hV.fromSpec).obj N)
  --                                                   [(pullbackComp).symm]
  -- ≅ (pullback (Spec.map φ)).obj (tilde Γ(N, V))    [step1 (Stacks 01I8)]
  -- ≅ tilde (TensorProduct Γ(X,V) Γ(Y,U) Γ(N,V))     [step2 (Stacks 01HQ)]
  let composedIso :=
    ((Scheme.Modules.pullbackComp _hU.fromSpec g).app N ≪≫
      (Scheme.Modules.pullbackCongr h_eq).app N ≪≫
      ((Scheme.Modules.pullbackComp (Spec.map (g.appLE V U e)) _hV.fromSpec).app N).symm ≪≫
      (Scheme.Modules.pullback (Spec.map (g.appLE V U e))).mapIso step1 ≪≫
      step2)
  -- iter-193 Lane F partial: the AddEquiv from sheaf-level `composedIso` at
  -- ⊤-sections is established below. The remaining residual (iter-194+) is:
  -- (a) chain `topAdd` with `tilde.isoTop.symm` to land in TensorProduct;
  -- (b) upgrade AddEquiv → Γ(Y, U)-LinearEquiv via Hom.app_smul + ΓSpecIso;
  -- (c) compose with `step3` to reach Γ((pullback g).obj N, U);
  -- (d) verify the Beck-Chevalley intertwining `1 ⊗ x ↦ baseMap g N e x`
  --     using naturality of the adjunction unit `pullback_app_isoTensor_unitAtV`.
  let topAdd :=
    { toFun := fun x => (Scheme.Modules.Hom.app composedIso.hom ⊤).hom x
      invFun := fun y => (Scheme.Modules.Hom.app composedIso.inv ⊤).hom y
      left_inv := fun x => by
        simp only [← AddCommGrpCat.comp_apply,
          ← Scheme.Modules.Hom.comp_app, composedIso.hom_inv_id,
          Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id, AddMonoidHom.id_apply]
      right_inv := fun y => by
        simp only [← AddCommGrpCat.comp_apply,
          ← Scheme.Modules.Hom.comp_app, composedIso.inv_hom_id,
          Scheme.Modules.Hom.id_app, AddCommGrpCat.hom_id, AddMonoidHom.id_apply]
      map_add' := fun x y =>
        (Scheme.Modules.Hom.app composedIso.hom ⊤).hom.map_add x y
      : Γ((Scheme.Modules.pullback _hU.fromSpec).obj ((Scheme.Modules.pullback g).obj N), ⊤) ≃+ _ }
  -- iter-194 Lane F LinearEquiv extraction (PUSH-BEYOND, axiom-clean):
  -- (a) Upgrade `topAdd` to a `Γ(Y, U)`-LinearEquiv via `Hom.app_smul` and the
  --     `Module.compHom _ (Scheme.ΓSpecIso _).inv.hom` recipe.
  -- (b) Compose with `(tilde.isoTop _).symm.toLinearEquiv` to land in the
  --     TensorProduct module (the underlying type is the same as
  --     `(modulesSpecToSheaf.obj (tilde _)).presheaf.obj (.op ⊤)`, and the
  --     `Γ(Y, U)`-module structures agree by `Module.compHom`/`restrictScalars`
  --     defeq).
  -- (c) Compose with `step3` to land in `Γ((pullback g).obj N, U)`.
  -- (d) Beck-Chevalley intertwining: typed sorry (see ARCHITECTURAL NOTE below).
  -- Introduce a local alias for the target ModuleCat to avoid Γ-notation
  -- ambiguity inside type ascriptions.
  let TR : ModuleCat (Γ(Y, U)) :=
    ModuleCat.of (Γ(Y, U)) (TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V))
  letI algSpecΓ : Algebra Γ(Y, U) Γ((Spec Γ(Y, U)), ⊤) :=
    (Scheme.ΓSpecIso _).inv.hom.toAlgebra
  letI modTilde : Module Γ(Y, U) Γ(tilde TR, ⊤) :=
    Module.compHom _ (Scheme.ΓSpecIso Γ(Y, U)).inv.hom
  -- We also need the same Module.compHom-instance on the source of `topAdd`,
  -- matching the one used by `step3` (it is set up there via a `letI` inside
  -- the theorem signature; we restate it here so it is in scope for `topLin`).
  letI modSrc : Module Γ(Y, U) Γ((Scheme.Modules.pullback _hU.fromSpec).obj
      ((Scheme.Modules.pullback g).obj N), ⊤) :=
    Module.compHom _ (Scheme.ΓSpecIso Γ(Y, U)).inv.hom
  -- Step (a): upgrade `topAdd` to Γ(Y, U)-linear via `Hom.app_smul`.
  let topLin : Γ((Scheme.Modules.pullback _hU.fromSpec).obj
        ((Scheme.Modules.pullback g).obj N), ⊤)
        ≃ₗ[Γ(Y, U)] Γ(tilde TR, ⊤) := by
    refine topAdd.toLinearEquiv ?_
    intro r x
    -- Module.compHom on both sides: r • _ = (ΓSpecIso _).inv.hom r • _.
    change (Scheme.Modules.Hom.app composedIso.hom ⊤).hom
      ((Scheme.ΓSpecIso _).inv.hom r • x) =
      (Scheme.ΓSpecIso _).inv.hom r • (Scheme.Modules.Hom.app composedIso.hom ⊤).hom x
    exact Scheme.Modules.Hom.app_smul composedIso.hom _ x
  -- Step (b): chain with `(tilde.isoTop _).symm.toLinearEquiv`.
  let toTensor : Γ((Scheme.Modules.pullback _hU.fromSpec).obj
        ((Scheme.Modules.pullback g).obj N), ⊤) ≃ₗ[Γ(Y, U)]
        TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) :=
    topLin.trans (tilde.isoTop TR).symm.toLinearEquiv
  -- Step (c): compose with `step3`.
  let f : TensorProduct Γ(X, V) Γ(Y, U) Γ(N, V) ≃ₗ[Γ(Y, U)]
          Γ((Scheme.Modules.pullback g).obj N, U) :=
    toTensor.symm.trans step3
  refine ⟨⟨f, ?_⟩⟩
  intro x
  -- Step (d): Beck-Chevalley intertwining at `1 ⊗ₜ x`.
  --
  -- ARCHITECTURAL UPDATE (iter-195 Σ-pair refactor). With `step1` and
  -- `step2` now carrying iso-characterizing identities `_step1_apply`
  -- and `_step2_apply` as Σ-pair components (the iter-195 plan-phase
  -- refactor `lane-f-step12-sigma-pair`), the LHS unfolds in 6 stages:
  --
  --   Stage 1 (closed via `_step2_apply` + inv_hom_id):
  --     (step2.inv .app ⊤) (tilde.toOpen TR ⊤ (1 ⊗ x))
  --       = baseMap (Spec.map φ) (tilde Γ(N,V)) le_top (tilde.toOpen Γ(N,V) ⊤ x).
  --   Stage 2 ((N1) baseMap naturality + `_step1_apply`):
  --     ((pullback (Spec.map φ)).map step1.inv .app ⊤) (stage 1's RHS)
  --       = baseMap (Spec.map φ) ((pullback _hV.fromSpec) N) le_top
  --         (baseMap _hV.fromSpec N _ x).
  --   Stage 3 ((N2) baseMap composition via pullbackComp):
  --     ((pullbackComp (Spec.map φ) _hV.fromSpec) N .hom .app ⊤) (stage 2's RHS)
  --       = baseMap (Spec.map φ ≫ _hV.fromSpec) N _ x.
  --   Stage 4 ((N3) baseMap transport via pullbackCongr h_eq):
  --     ((pullbackCongr h_eq) N .inv .app ⊤) (stage 3's RHS)
  --       = baseMap (_hU.fromSpec ≫ g) N _ x.
  --   Stage 5 ((N2) baseMap composition via pullbackComp, again):
  --     ((pullbackComp _hU.fromSpec g) N .inv .app ⊤) (stage 4's RHS)
  --       = baseMap _hU.fromSpec ((pullback g) N) le_top' (baseMap g N e x).
  --   Stage 6 ((N4) step3 inversion of baseMap _hU.fromSpec on open imm):
  --     step3 (baseMap _hU.fromSpec ((pullback g) N) le_top' y) = y.
  --
  -- The four substrate helpers (N1)-(N4) are PROVED (T12, 2026-07-03):
  --   (N1) `pullback_app_isoTensor_baseMap_naturality`,
  --   (N2) `pullback_app_isoTensor_baseMap_comp`,
  --   (N3) `pullback_app_isoTensor_baseMap_congr`,
  --   (N4) the Σ-pair characterization `_step3_symm_apply` of
  --        `pullback_of_openImmersion_iso_restrict`.
  -- The stages are assembled below as `congrArg`/`Eq.trans` chains.
  --
  -- Local abbreviations:
  --   ΓNV := ModuleCat.of ↑Γ(X, V) ↑Γ(N, V)
  --   φ := Scheme.Hom.appLE g V U e
  --   ι1 := (pullbackComp _hU.fromSpec g) .app N
  --   ι2 := (pullbackCongr h_eq) .app N
  --   ι3 := ((pullbackComp (Spec.map φ) _hV.fromSpec) .app N).symm
  --   ι4 := (pullback (Spec.map φ)).mapIso step1
  --   ι5 := step2
  -- composedIso = ι1 ≪≫ ι2 ≪≫ ι3 ≪≫ ι4 ≪≫ ι5.
  --
  -- ## Stage 1: invert `_step2_apply` via `step2.hom_inv_id` elementwise.
  have hcancel2 : ∀ (w : Γ((Scheme.Modules.pullback (Spec.map (g.appLE V U e))).obj
      (tilde (ModuleCat.of Γ(X, V) Γ(N, V))), ⊤)),
      (Scheme.Modules.Hom.app step2.inv ⊤).hom
        ((Scheme.Modules.Hom.app step2.hom ⊤).hom w) = w := fun w =>
    congrArg (fun (k : (Scheme.Modules.pullback (Spec.map (g.appLE V U e))).obj
        (tilde (ModuleCat.of Γ(X, V) Γ(N, V))) ⟶
        (Scheme.Modules.pullback (Spec.map (g.appLE V U e))).obj
        (tilde (ModuleCat.of Γ(X, V) Γ(N, V)))) =>
      (Scheme.Modules.Hom.app k ⊤).hom w) step2.hom_inv_id
  have h1 := (congrArg (fun w => (Scheme.Modules.Hom.app step2.inv ⊤).hom w)
    (_step2_apply x).symm).trans (hcancel2 _)
  -- ## Stage 2: (N1) naturality along `step1.inv`, then `_step1_apply`.
  -- (The `⊤`-opens must be pinned explicitly: a bare `le_top` collapses
  -- `Spec.map φ ⁻¹ᵁ ⊤` to `⊤` and leaves the lemma's opens as metavariables.)
  have h2 := (pullback_app_isoTensor_baseMap_naturality (Spec.map (g.appLE V U e))
      step1.inv (U := (⊤ : (Spec Γ(Y, U)).Opens)) (V := (⊤ : (Spec Γ(X, V)).Opens))
      le_top ((tilde.toOpen (ModuleCat.of Γ(X, V) Γ(N, V)) ⊤).hom x)).trans
    (congrArg (fun w => pullback_app_isoTensor_baseMap (Spec.map (g.appLE V U e))
      ((Scheme.Modules.pullback _hV.fromSpec).obj N)
      (U := (⊤ : (Spec Γ(Y, U)).Opens)) (V := (⊤ : (Spec Γ(X, V)).Opens))
      le_top w) (_step1_apply x))
  -- ## Stage 3: (N2) composition through `pullbackComp (Spec.map φ) hV.fromSpec`.
  have eTU3 : (⊤ : (Spec Γ(Y, U)).Opens) ≤
      (Spec.map (g.appLE V U e) ≫ _hV.fromSpec) ⁻¹ᵁ V := by
    rw [Scheme.Hom.comp_preimage, _hV.fromSpec_preimage_self]
    exact le_top
  have h3 := pullback_app_isoTensor_baseMap_comp (Spec.map (g.appLE V U e)) _hV.fromSpec N
    (le_of_eq _hV.fromSpec_preimage_self.symm) le_top eTU3 x
  -- ## Stage 4: (N3) transport along `pullbackCongr h_eq.symm`.
  have eTU4 : (⊤ : (Spec Γ(Y, U)).Opens) ≤ (_hU.fromSpec ≫ g) ⁻¹ᵁ V := by
    rw [Scheme.Hom.comp_preimage]
    exact le_trans (le_of_eq _hU.fromSpec_preimage_self.symm) (fun a ha => e ha)
  have h4 := pullback_app_isoTensor_baseMap_congr h_eq.symm N eTU3 eTU4 x
  -- ## Stage 5: (N2) inverted, through `pullbackComp hU.fromSpec g`.
  have h5' := pullback_app_isoTensor_baseMap_comp _hU.fromSpec g N e
    (le_of_eq _hU.fromSpec_preimage_self.symm) eTU4 x
  have hcancel1 : ∀ (w : Γ((Scheme.Modules.pullback _hU.fromSpec).obj
      ((Scheme.Modules.pullback g).obj N), ⊤)),
      (Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackComp _hU.fromSpec g).hom.app N) ⊤).hom w) = w :=
    fun w => congrArg (fun (k : (Scheme.Modules.pullback g ⋙
        Scheme.Modules.pullback _hU.fromSpec).obj N ⟶
        (Scheme.Modules.pullback g ⋙ Scheme.Modules.pullback _hU.fromSpec).obj N) =>
      (Scheme.Modules.Hom.app k ⊤).hom w)
      (Iso.hom_inv_id_app (Scheme.Modules.pullbackComp _hU.fromSpec g) N)
  have h5 := (congrArg (fun w =>
    (Scheme.Modules.Hom.app
      ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom w)
    h5'.symm).trans (hcancel1 _)
  -- ## Stage 6: (N4) `step3` inversion via `_step3_symm_apply`.
  have h6 := (congrArg (fun w => step3 w)
    (_step3_symm_apply (pullback_app_isoTensor_baseMap g N e x)).symm).trans
    (step3.apply_symm_apply (pullback_app_isoTensor_baseMap g N e x))
  -- ## Assembly: decompose `f (1 ⊗ x)` through the iso chain and chain the stages.
  show step3
    ((Scheme.Modules.Hom.app
        ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom
      ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackCongr h_eq).inv.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackComp (Spec.map (g.appLE V U e))
              _hV.fromSpec).hom.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
              ((Scheme.Modules.pullback (Spec.map (g.appLE V U e))).map step1.inv) ⊤).hom
            ((Scheme.Modules.Hom.app step2.inv ⊤).hom
              ((tilde.toOpen TR ⊤).hom (1 ⊗ₜ[Γ(X, V)] x))))))) =
    pullback_app_isoTensor_baseMap g N e x
  exact (congrArg (fun w => step3
      ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackCongr h_eq).inv.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
              ((Scheme.Modules.pullbackComp (Spec.map (g.appLE V U e))
                _hV.fromSpec).hom.app N) ⊤).hom
            ((Scheme.Modules.Hom.app
                ((Scheme.Modules.pullback (Spec.map (g.appLE V U e))).map
                  step1.inv) ⊤).hom w))))) h1).trans
    ((congrArg (fun w => step3
      ((Scheme.Modules.Hom.app
          ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom
        ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackCongr h_eq).inv.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
              ((Scheme.Modules.pullbackComp (Spec.map (g.appLE V U e))
                _hV.fromSpec).hom.app N) ⊤).hom w)))) h2).trans
      ((congrArg (fun w => step3
        ((Scheme.Modules.Hom.app
            ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom
          ((Scheme.Modules.Hom.app
              ((Scheme.Modules.pullbackCongr h_eq).inv.app N) ⊤).hom w))) h3).trans
        ((congrArg (fun w => step3
          ((Scheme.Modules.Hom.app
              ((Scheme.Modules.pullbackComp _hU.fromSpec g).inv.app N) ⊤).hom w))
            h4).trans
          ((congrArg (fun w => step3 w) h5).trans h6))))