---
author: sync
content_type: lemma
created: '2026-07-16T21:14:28'
decl: AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict
docstring: "**D3′ — composition coherence of the sheaf-level pullback–tensor comparison\
  \ `pullbackTensorMap`**\n(blueprint `lem:pullback_tensor_map_basechange`).\n\nThis\
  \ is the *tensorator* analog of the unit composition coherence\n`pullbackObjUnitToUnit_comp`:\
  \ for composable scheme morphisms `h : Z ⟶ Y`, `f : Y ⟶ X` and\narbitrary `M N :\
  \ X.Modules`, the comparison `δ_sheaf = pullbackTensorMap (h ≫ f)` of the composite\n\
  factors through the comparisons of `f` and `h` and the pullback pseudofunctor coherence\n\
  `pullbackComp`:\n`pullbackTensorMap (h≫f) M N = (pullbackComp h f).inv ≫ (pullback\
  \ h).map (pullbackTensorMap f) ≫\n  pullbackTensorMap h (f^*M) (f^*N) ≫ tensorObjIsoOfIso\
  \ (pullbackComp h f) (pullbackComp h f)`.\n\n  The base-change-square form of the\
  \ blueprint (`f ∘ j' = j ∘ g` with `j, j'` open immersions) is the\n  specialisation\
  \ `h := j'`, `f`, applied to the two factorisations `j' ≫ f = g ≫ j` of the equal\n\
  \  underlying morphisms; the displayed identity of the restricted comparisons follows\
  \ by equating the\n  two instances of this coherence. Consumed by D4′ `pullbackTensorIsoOfLocallyTrivial`.\n\
  \nMathlib-absent at the pinned commit; NOT a sectionwise statement (the left-adjoint\
  \ pullback exposes\nno sectionwise value). Proved by the mate calculus through the\
  \ oplax comparison `δ` of a composite of\nleft adjoints (`Functor.OplaxMonoidal.comp_δ`)\
  \ and the adjunction-mate identity\n`conjugateEquiv_pullbackComp_inv` (`pullbackComp`\
  \ for the left adjoints ↔ `pushforwardComp` for the\nright adjoints), exactly mirroring\
  \ `pullbackObjUnitToUnit_comp`."
file: AlgebraicJacobian/Picard/TensorObjSubstrate.lean
generated: lean
lean_status: sorry
title: AlgebraicGeometry.Scheme.Modules.pullbackTensorMap_restrict
type: lean
updated: '2026-07-25T00:32:28'
---
lemma pullbackTensorMap_restrict {X Y Z : Scheme.{u}} (h : Z ⟶ Y) (f : Y ⟶ X)
    (M N : X.Modules) :
    pullbackTensorMap (h ≫ f) M N =
      (Scheme.Modules.pullbackComp h f).inv.app (tensorObj M N) ≫
      (Scheme.Modules.pullback h).map (pullbackTensorMap f M N) ≫
      pullbackTensorMap h ((Scheme.Modules.pullback f).obj M)
        ((Scheme.Modules.pullback f).obj N) ≫
      (tensorObjIsoOfIso ((Scheme.Modules.pullbackComp h f).app M)
        ((Scheme.Modules.pullbackComp h f).app N)).hom := by
  -- ROADMAP (iter-256 handoff). Unfolding `pullbackTensorMap` on both sides (verified) exposes the
  -- four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4` with
  --   S1 = (sheafificationCompPullback φ_{·}).app (M.val ⊗ₚ N.val) .hom,
  --   S2 = a_·.map (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback φ'_{·}) M.val N.val),
  --   S3 = (sheafifyTensorUnitIso (Fp M.val) (Fp N.val)).hom,
  --   S4 = a_·.map (forget(pullbackValIso · M).hom ⊗ₘ forget(pullbackValIso · N).hom).
  -- Unlike D1′ (naturality, a 4-square *paste*), this is a 4-square *composition*-coherence: the LHS
  -- is the composite-morphism `· = h ≫ f` instance, the RHS interleaves the `f` instance (pushed
  -- forward by `(pullback h).map`) with the `h` instance (on the pulled-back modules `(pullback f).obj`),
  -- all conjugated by the pseudofunctoriality iso `pullbackComp h f`.
  --
  -- **Why the unit-analog mirror does NOT transfer.** `pullbackObjUnitToUnit_comp` (L907) works because
  -- `pullbackObjUnitToUnit` is BY DEFINITION an adjunction transpose, so its composition coherence is
  -- obtained by transposing through `pullbackPushforwardAdjunction.homEquiv` and invoking the bridge
  -- `pullbackPushforwardAdjunction_homEquiv_pullbackObjUnitToUnit`. `pullbackTensorMap` is NOT a
  -- transpose — it is the hand-built 4-fold composite above — and there is NO analogous
  -- `…homEquiv_pullbackTensorMap` bridge. Hence the mirror's very first move
  -- (`(pullbackPushforwardAdjunction (h≫f)).homEquiv.injective`) leaves an un-evaluable transpose of a
  -- concrete composite and stalls. This is the planner's anticipated "genuinely new obstacle beyond the
  -- unit-analog pattern" — per the iter-256 reversing signal, the scaffolded statement is retained with
  -- this typed `sorry` rather than forcing a non-applicable device.
  --
  -- **The genuine route (four composition-coherence squares; each its own sub-lemma).**
  --  • Sq2 (the δ core): `δ (PresheafOfModules.pullback φ'_{h≫f})` decomposes via
  --    `CategoryTheory.Functor.OplaxMonoidal.comp_δ` once `pullback φ'_{h≫f}` is identified with
  --    `pullback φ'_f ⋙ pullback φ'_h` through the Mathlib presheaf coherence
  --    `PresheafOfModules.pullbackComp φ'_f ψ` (verified to exist; composite ring map
  --    `φ'_f ≫ F.op.whiskerLeft ψ`), which requires the ring-map reconciliation
  --    `(toRingCatSheafHom (h≫f)).hom = φ'_f ≫ (Opens.map f.base).op.whiskerLeft φ'_h` (functoriality
  --    of `toRingCatSheafHom` under `≫`).  `PresheafOfModules.{pullbackId, pullback_assoc}` are the
  --    coherence-bookkeeping lemmas.
  --  • Sq1 (sheafification ↔ pullback): the composition coherence of
  --    `SheafOfModules.sheafificationCompPullback` across `h≫f` (analog of `pullbackComp` for the
  --    `sheafification ⋙ pullback` natural iso) — Mathlib-absent, a project sub-lemma.
  --  • Sq3: `sheafifyTensorUnitIso` carried through the same `pullbackComp` identification.
  --  • Sq4 (the connecting iso): a Scheme-level `pullbackValIso` composition coherence relating
  --    `pullbackValIso (h≫f) M` to `(pullback h).map (pullbackValIso f M)`, `pullbackValIso h (f^*M)`
  --    and `(pullbackComp h f).app M` — Mathlib-absent, the second project sub-lemma; it is the
  --    bookkeeping that produces the final `tensorObjIsoOfIso (pullbackComp h f) (pullbackComp h f)`.
  -- The two project sub-lemmas (Sq1, Sq4 composition coherences) + the Sq2 ring-map reconciliation are
  -- the missing ingredients; they are the iter-257 work items (each ~40-120 LOC, mate-calculus style).
  --
  -- ITER-257 FINDINGS (prover):
  --  (1) The Sq2 RING-MAP RECONCILIATION IS DEFINITIONAL — `toRingCatSheafHom_comp_hom_reconcile`
  --      (just above) closes by `rfl`: `(toRingCatSheafHom (h≫f)).hom =
  --      (toRingCatSheafHom f).hom ≫ (Opens.map f.base).op.whiskerLeft (toRingCatSheafHom h).hom`.
  --      The blueprint's "non-trivial because the two sides live in functor categories that agree only
  --      up to Opens.map_comp" is in fact a `rfl` (the `Opens.map`/`Scheme` comp defeqs hold). This
  --      means `PresheafOfModules.pullbackComp φ'_f φ'_h` lands in `pullback φ'_{h≫f}` ON THE NOSE.
  --  (2) The genuine Sq2 content is "Sq2b": the MONOIDALITY of `pullbackComp` — that `δ` of the single
  --      `pullback φ'_{h≫f}` (leftAdjoint-oplax of the composite adjunction) transports, through
  --      `pullbackComp`, to `δ` of the composite functor `pullback φ'_f ⋙ pullback φ'_h`
  --      (`Functor.OplaxMonoidal.comp_δ`). Mathlib has NO ready lemma for the δ-transport of
  --      `Adjunction.leftAdjointCompIso` (searched: no `leftAdjointOplaxMonoidal`-of-composite lemma).
  --      It must be proved by the mate calculus (mirror `Adjunction.isMonoidal_comp`, Functor.lean:990).
  --  (3) STATEMENT-LEVEL FRICTION to budget for: (a) `Functor.OplaxMonoidal.δ (pullback φ')` needs the
  --      CommRingCat/forget₂ monoidal-instance pinning (the D1′ `show … from`/`let φ' : … ⋙ forget₂`
  --      device — bare `δ (pullback (toRingCatSheafHom f).hom)` leaves `MonoidalCategory` metavars
  --      stuck); (b) `pullbackComp φ'_f φ'_h` pins `(F := Opens.map f.base ⋙ Opens.map h.base)` with the
  --      morphism `φ'_f ≫ whiskerLeft (Opens.map f.base).op φ'_h`, and unifying the standalone δ's
  --      pullback against that codomain needs explicit `(F := …)` + the associativity defeq
  --      `(F⋙G).op⋙T = F.op⋙(G.op⋙T)` — write the LHS δ over `pullback (F := _ ⋙ _) (toRingCatSheafHom
  --      (h≫f)).hom` (typechecks) and bridge the RHS connecting object by `eqToHom` via finding (1).
  -- ITER-261 (prover): the proof is now OPENED to the paste-ready form.  `simp only` unfolds
  -- `pullbackTensorMap` on BOTH sides into the four-fold composite `S1 ≫ a.map δ ≫ S3 ≫ S4`; the RHS
  -- `(pullback h).map (S1_f ≫ … ≫ S4_f)` is distributed by `Functor.map_comp` and everything
  -- right-associated.  The goal is then the explicit 4-vs-10 factor identity
  --   S1_{hf} ≫ a_Z.map δ_{hf} ≫ S3_{hf} ≫ S4_{hf}
  --     = R0 ≫ (pullback h).map S1_f ≫ (pullback h).map (a_Y.map δ_f) ≫ (pullback h).map S3_f
  --        ≫ (pullback h).map S4_f ≫ S1_h ≫ a_Z.map δ_h ≫ S3_h ≫ S4_h ≫ a_Z.mapIso(pbComp ⊗ pbComp).hom
  -- with R0 = (pullbackComp h f).inv.app (M⊗N).  This is the four-square *composition* paste:
  --   • Sq1 (the S1 connecting iso):  `sheafificationCompPullback_comp` (stated+opened just above —
  --     the foundational Mathlib-absent coherence; LHS already reduced to the unit identity).
  --   • Sq2b (the δ core):           `pullbackComp_δ` (CLOSED, axiom-clean) under `a_Z.map`.
  --   • Sq3 (the unit iso):          `sheafifyTensorUnitIso` carried through `pullbackComp`.
  --   • Sq4 (the connecting iso):    a `pullbackValIso` composition coherence (Mathlib-absent; it
  --     factors through Sq1 since `pullbackValIso = sheafCompPb.symm ≪≫ pullback.mapIso counit`).
  -- The squares INTERLEAVE (e.g. `S1_h` here acts on `tensorObj ((pullback f).obj M) …`, NOT on
  -- `PrPb_f (M⊗N)`), so the paste slides factors past each other by `δ_natural` / NatTrans naturality
  -- exactly as the D1′ naturality paste (`pullbackTensorMap_natural`, L2007) does — merging
  -- `a.map δ ≫ S3 ≫ S4` into a single `a.map Ψ` to move S1 by its mate coherence.  The remaining work
  -- is: finish Sq1's unit reassembly, build Sq4, then run the interleaved merge.  Typed sorry retained
  -- (race-safe: file compiles; `DualInverse.lean` imports it).
  simp only [pullbackTensorMap, tensorObjIsoOfIso]
  rw [Functor.map_comp, Functor.map_comp, Functor.map_comp]
  simp only [Category.assoc]
  -- ITER-013 (prover) — PREFIX RE-CANONICALIZED.  The iter-006 prefix spliced `h1` via
  -- `erw [reassoc_of% h1]`, which introduced a NON-`Category.toCategoryStruct` boundary `≫` separating
  -- the cancellable pair `D = aZ.map (PrPbComp.hom.app P)` (last factor of the expanded S1) from
  -- `E = aZ.map (pb.inv.app P)` (head of the `hδ` group); no canonical-assoc tactic could bring them
  -- adjacent.  We now KEEP S1 FOLDED in the goal and discharge step (i) through the clean combined
  -- brick `hcancel : S1 ≫ E = R0 ≫ R1 ≫ R5` proved in a fresh `have`-context (where `rw [h1]` +
  -- `Category.assoc` stay canonical and `sheafifyMap_pullbackComp_hom_inv_id` cancels `D ≫ E`).  No
  -- `reassoc_of%`, so no instance drift.
  have h1 := sheafificationCompPullback_comp h f (PresheafOfModules.Monoidal.tensorObj M.val N.val)
  letI instMSX : MonoidalCategoryStruct (_root_.PresheafOfModules (X.presheaf ⋙ forget₂ CommRingCat RingCat)) :=
    inferInstance
  letI instMSZ : MonoidalCategoryStruct (_root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat)) :=
    inferInstance
  -- ITER-013 (prover): `aZ`/`pb` are spelled out EXPLICITLY below (no `let`-fvar) so that `hδ`'s `E`,
  -- `h1`'s `D`, the Brick-1 lemma `sheafifyMap_pullbackComp_hom_inv_id`, and `hcancel` ALL share the
  -- identical sheafification/pullbackComp spelling — `cod D = dom E` then matches SYNTACTICALLY and a
  -- plain `rw [Category.assoc]` reassociates the `D ≫ E` cancellation (a `let`-fvar `aZ.obj …` vs
  -- explicit `(sheafification …).obj …` mismatch was what blocked the keyed `rw`/`simp` and forced the
  -- `whnf`-bombing `erw [Category.assoc]`).
  let φfh := (Hom.toRingCatSheafHom (h ≫ f)).hom
  let φf := (Hom.toRingCatSheafHom f).hom
  let φh := (Hom.toRingCatSheafHom h).hom
  let pb := PresheafOfModules.pullbackComp φf φh
  let δfh := Functor.OplaxMonoidal.δ
    (F := PresheafOfModules.pullback
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map (h ≫ f).base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom (h ≫ f)).hom))
    M.val N.val
  let δcomp := Functor.OplaxMonoidal.δ
    (F := PresheafOfModules.pullback
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom f).hom) ⋙
      PresheafOfModules.pullback
        (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
            (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
          from (Hom.toRingCatSheafHom h).hom))
    M.val N.val
  let tcomp :=
    MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat))
      (pb.hom.app M.val) (pb.hom.app N.val)
  have hδ :
      (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δfh =
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map
            ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
              (Hom.toRingCatSheafHom h).hom).inv.app
              (PresheafOfModules.Monoidal.tensorObj M.val N.val)) ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δcomp ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map tcomp := by
    -- RESOLVED (iter-006): the Sq2b content is exactly the CLOSED `pullbackComp_δ` under
    -- `congrArg aZ.map`.  The forward `rw [Functor.map_comp] at` route does NOT fire (the inner
    -- `≫` carries a distinct inferred instance for the presheaf category); instead FOLD the goal's
    -- RHS by `← Functor.map_comp` (the explicit `aZ.map _ ≫
    -- aZ.map _` heads match syntactically) and close by defeq against the congrArg image
    -- (`show`-pinned ring maps are defeq to the bare `(Hom.toRingCatSheafHom ·).hom`, and
    -- `φfh = φf ≫ whiskerLeft φh` is `rfl` by `toRingCatSheafHom_comp_hom_reconcile`).
    have hd := pullbackComp_δ
      (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom f).hom)
      (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
          (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
        from (Hom.toRingCatSheafHom h).hom) M.val N.val
    rw [← Functor.map_comp, ← Functor.map_comp]
    exact congrArg (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map hd
  -- ── STEP (i) — the combined `S1 ≫ a.map δfh` brick (`hmain`), proved in a CLEAN context ──
  -- iter-015 root-cause: in the *main* goal `S1` came from `simp only [pullbackTensorMap]`, whose
  -- internal spelling is defeq-but-not-syntactic to `h1`'s LHS, so `rw [h1]` could not fire there and
  -- `erw [h1]` left a non-canonical `D ≫ E` boundary that `Category.assoc` could not cross.  The fix is
  -- to AVOID splicing `h1` into the unfolded main goal: state `hmain` with `S1`/`a.map δfh` written
  -- *verbatim* as `h1`/`hδ`'s LHS, so inside `hmain` plain `rw [h1, hδ]` fires (syntactic match) and the
  -- connecting `≫` stays the canonical `SheafOfModules Z` comp.  Then `simp only [Category.assoc]`
  -- flattens, `reassoc_of% sheafifyMap_pullbackComp_hom_inv_id` cancels the now-adjacent `D ≫ E`, and the
  -- WHOLE brick is spliced into the main goal by `erw [reassoc_of% hmain]` (defeq matching crosses the
  -- main goal's hidden-instance `S1` — verified to land the canonical step-(i) form in iter-015).
  have hmain :
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app
          (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δfh =
      (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom f) (Hom.toRingCatSheafHom h)).inv.app
          ((PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)) ≫
        (SheafOfModules.pullback (Hom.toRingCatSheafHom h)).map
          ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj
            (PresheafOfModules.Monoidal.tensorObj M.val N.val))).hom ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map δcomp ≫
        (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map tcomp := by
    -- `rw [h1]` cannot fire: `h1` is the lemma `sheafificationCompPullback_comp` applied with `P`
    -- substituted, so its LHS instance differs (defeq, not syntactic) from the goal's `S1`.  Re-state it
    -- as `h1'` with a FRESHLY-elaborated type (accepted from `h1` up to defeq) so its LHS matches the
    -- goal's `S1` syntactically and plain `rw` fires, keeping every `≫` the canonical `SheafOfModules Z`
    -- comp.  Then `simp [Category.assoc]` flattens and `reassoc_of% (D ≫ E = 𝟙)` cancels the now-adjacent
    -- pair.
    have h1' :
        ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom (h ≫ f))).app
            (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom =
          (SheafOfModules.pullbackComp (Hom.toRingCatSheafHom f) (Hom.toRingCatSheafHom h)).inv.app
              ((PresheafOfModules.sheafification (𝟙 (X.ringCatSheaf.obj))).obj
                (PresheafOfModules.Monoidal.tensorObj M.val N.val)) ≫
            (SheafOfModules.pullback (Hom.toRingCatSheafHom h)).map
              ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom f)).app
                (PresheafOfModules.Monoidal.tensorObj M.val N.val)).hom ≫
            ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj
                (PresheafOfModules.Monoidal.tensorObj M.val N.val))).hom ≫
            (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map
              ((PresheafOfModules.pullbackComp (Hom.toRingCatSheafHom f).hom
                (Hom.toRingCatSheafHom h).hom).hom.app
                (PresheafOfModules.Monoidal.tensorObj M.val N.val)) := h1
    -- Expose `S1` (via `h1'`) and `a.map δfh` (via `erw [hδ]`) as the explicit `(R0 ≫ R1 ≫ R5 ≫ D) ≫
    -- (E ≫ a.map δcomp ≫ a.map tcomp)`.  The cancelling pair `D ≫ E` is now in place but buried under a
    -- DEFEQ-but-not-syntactic `SheafOfModules` instance boundary, so no `rw/simp [Category.assoc]` can
    -- bring it adjacent.  `comp_cancel_mid` does the reassociation+cancellation generically (one
    -- instance) and is `exact`-applied: `exact` unifies up to defeq, crossing the instance gap that
    -- blocks `rw`, and `sheafifyMap_pullbackComp_hom_inv_id` supplies `D ≫ E = 𝟙`.
    rw [h1']
    erw [hδ]
    exact comp_cancel_mid _ _ _ _ _ _
      (sheafifyMap_pullbackComp_hom_inv_id h f (PresheafOfModules.Monoidal.tensorObj M.val N.val))
  -- Splice the step-(i) brick into the main goal; lands the canonical
  -- `R0 ≫ R1 ≫ R5 ≫ a.map δcomp ≫ a.map tcomp ≫ S3 ≫ S4` form.
  erw [reassoc_of% hmain]
  -- ── STEP (i) CLOSED (iter-015). ───────────────────────────────────────────────────────────────
  -- The long-standing `D ≫ E = 𝟙` cancellation wall (blocking iters 012–015) is GONE: `hmain` packages
  -- `S1 ≫ a.map δfh = R0 ≫ R1 ≫ R5 ≫ a.map δcomp ≫ a.map tcomp` and is spliced by `erw [reassoc_of%
  -- hmain]`.  The breakthrough is the instance-agnostic skeleton `comp_cancel_mid` applied by `exact`
  -- (not `rw`): the `sheafificationCompPullback`/`pullbackComp` `.app`-components compose through
  -- DEFEQ-but-not-syntactic `SheafOfModules` instances, which defeats every `rw/simp [Category.assoc]`
  -- and bombs `erw [Category.assoc]` (mate-`whnf`); `exact` unifies up to defeq and crosses it cleanly.
  --
  -- ── REMAINING: steps (ii) + (iii) — the interleaved four-square merge. ─────────────────────────
  -- The goal is now `R0 ≫ R1 ≫ R5 ≫ a.map δcomp ≫ a.map tcomp ≫ S3 ≫ S4 = RHS`, where the RHS is the
  -- distributed `(pullback h).map (S1_f ≫ a_Y.map δ_f ≫ S3_f ≫ S4_f) ≫ S1_h ≫ a.map δ_h ≫ S3_h ≫ S4_h ≫
  -- a.mapIso(pbComp ⊗ pbComp).hom` (R0 cancels on both sides).  To finish:
  --   (ii) split `a.map δcomp` via `Functor.OplaxMonoidal.comp_δ` (δcomp = `δ (pullback φf ⋙ pullback φh)
  --        M.val N.val`) into `(pullback φh).map (δ_f) ≫ δ_h`, then `Functor.map_comp` under `a.map`.
  --        Support: `pullbackComp_δ` (L2282, CLOSED) already gives the `δ`-twin; the friction is the
  --        monoidal-instance pinning (iter-257 finding (3)).
  --   (iii) the Sq3/Sq4 bricks DO NOT EXIST as Lean decls yet — they must be built first:
  --        • `sheafifyTensorUnitIso_comp` (Sq3, blueprint `lem:sheafify_tensor_unit_iso_comp`): hom-leg
  --          is one `a.map (η ⊗ η)` via `sheafifyTensorUnitIso_hom_eq'` (L1860, EXISTS), reduces to
  --          η-naturality vs `PrPbComp` recombined by `⊗` bifunctoriality.
  --        • `pullbackValIso_comp` (Sq4, blueprint `lem:pullback_val_iso_comp`): substitute
  --          `pullbackValIso = sheafCompPb.symm ≪≫ pullback.mapIso counit`; `sheafCompPb⁻¹` parts
  --          reassemble by `sheafificationCompPullback_comp` (now usable — see step (i) device), counit
  --          parts by counit naturality.
  --        Then interleave (slide `S1_h` past the `f`-block by `δ_natural` + `sheafificationCompPullback h`
  --          naturality, exactly as the D1′ paste `pullbackTensorMap_natural`).  Every splice is `erw`
  --          across the underlying `Z.ringCatSheaf.obj` carrier.  The `comp_cancel_mid`-`exact` device generalises to
  --          any further instance-boundary cancellation in this merge.
  -- STEP (ii) SPLICED (this iter): split `a_Z.map δcomp` by the `comp_δ` brick
  -- `sheafifyMap_δcomp_split` (`erw` unfolds the `δcomp` let to match the brick's unfolded LHS).
  -- Goal now reads `R0 ≫ R1 ≫ R5 ≫ a.map ((pullback φh).map δ_f) ≫ a.map δ_h ≫ a.map tcomp ≫ S3 ≫ S4
  --   = RHS`, the paste-ready form for the step-(iii) interleave.
  erw [sheafifyMap_δcomp_split h f M N]
  -- ── STEP (iii) — REMAINING: the interleaved four-square merge. ─────────────────────────────────
  -- Exact post-step-(ii) goal (extracted iter-016 via a forced type-mismatch). Writing
  --   a? = sheafification, Fp_· = PresheafOfModules.pullback φ'_·, S1_· = sheafCompPb · .app _ .hom,
  --   δ_· = Functor.OplaxMonoidal.δ (Fp_·), S3_· = sheafifyTensorUnitIso _ _ .hom,
  --   S4_· = a.map (forget (pullbackValIso · _).hom ⊗ₘ forget (pullbackValIso · _).hom):
  --
  -- LHS = R0 ≫ R1 ≫ R5 ≫ aZ.map (Fp_h.map δ_f) ≫ aZ.map δ_h' ≫ aZ.map tcomp ≫ S3_g ≫ S4_g
  --   R0 = (SheafOfModules.pullbackComp φf φh).inv.app (aX (M.val⊗N.val))
  --   R1 = (pullback h).map (S1_f at (M.val⊗N.val)),  R5 = S1_h at (Fp_f (M.val⊗N.val))
  --   δ_h' = δ_h (Fp_f M.val) (Fp_f N.val),  tcomp = (pb.hom.app M.val ⊗ₘ pb.hom.app N.val),
  --     pb = PresheafOfModules.pullbackComp φf φh
  --   S3_g = sheafifyTensorUnitIso (Fp_{h≫f} M.val) (Fp_{h≫f} N.val) .hom
  --   S4_g = aZ.map (forget(pullbackValIso (h≫f) M).hom ⊗ₘ forget(pullbackValIso (h≫f) N).hom)
  -- RHS = R0' ≫ (pullback h).map S1_f ≫ (pullback h).map (aY.map δ_f) ≫ (pullback h).map S3_f
  --        ≫ (pullback h).map S4_f ≫ S1_h'' ≫ aZ.map δ_h'' ≫ S3_h ≫ S4_h ≫ Tfinal
  --   R0' = (pullbackComp h f).inv.app (M.tensorObj N)  [Scheme.Modules spelling of R0, defeq]
  --   S3_f = sheafifyTensorUnitIso (Fp_f M.val) (Fp_f N.val) .hom  [over Y]
  --   S1_h'' = S1_h at (Monoidal.tensorObj ((pullback f).obj M).val ((pullback f).obj N).val)
  --   δ_h'' = δ_h ((pullback f).obj M).val ((pullback f).obj N).val
  --   S3_h = sheafifyTensorUnitIso (Fp_h ((pullback f).obj M).val) (Fp_h ((pullback f).obj N).val) .hom
  --   S4_h = aZ.map (forget(pullbackValIso h ((pullback f).obj M)).hom ⊗ₘ forget(pullbackValIso h …N).hom)
  --   Tfinal = (aZ.mapIso (forget.mapIso (pullbackComp h f .app M) ⊗ᵢ forget.mapIso (pullbackComp h f .app N))).hom
  --
  -- NEXT CONCRETE STEP (the first slide, mirroring the D1′ paste): R0/R1 match the RHS heads (defeq,
  -- SheafOfModules vs Scheme.Modules spelling).  The LHS middle `R5 ≫ aZ.map (Fp_h.map δ_f)` is the RHS
  -- of the `sheafCompPb h` NATURALITY square at `δ_f`:
  --   (pullback h).map (aY.map δ_f) ≫ (S1_h at (Fp_f M ⊗ Fp_f N))  =  R5 ≫ aZ.map (Fp_h.map δ_f),
  -- which slides S1_h from before δ to after it (`(sheafificationCompPullback (toRingCatSheafHom h)).hom.naturality δ_f`,
  -- `erw` to bridge the `have this:=` ascription on δ_f).  After the slide the residual is exactly
  -- Sq3 (`sheafifyTensorUnitIso_comp`) + Sq4 (`pullbackValIso_comp`) + bifunctoriality, whose arguments
  -- on the RHS use the SHEAF-pullback underlying presheaf `((pullback f).obj M).val` while the LHS uses the
  -- PRESHEAF pullback `Fp_f M.val`; the two are bridged by `pullbackValIso f` (the S4_f factor) — this is
  -- why Sq3/Sq4 are *interleaved* (not separately pluggable) and must be discharged together with the slide.
  -- RISK flag (progress-critic conv016): the `pullbackValIso`-bridged Sq3/Sq4 entanglement is a NEW class
  -- of boundary beyond the `comp_cancel_mid` device — flagged for the next pass per the escalation protocol.
  -- FIRST-SLIDE ATTEMPT (iter-016, FAILED — exact failing tactic recorded for the next pass):
  --   simp only [Category.assoc]
  --   erw [← reassoc_of% ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality
  --     (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback (show … from (Hom.toRingCatSheafHom f).hom))
  --       M.val N.val))]
  -- → `rewrite failed: Did not find an occurrence of the pattern` (NOT a whnf-bomb — benign mismatch).
  -- Cause: the naturality RHS pattern is `(sheafCompPb h).hom.app P ≫ (pullback φ'_h ⋙ a_Z).map δ_f`, but
  -- the goal carries `R5 = ((sheafCompPb h).app P).hom` (the `.app _ .hom` spelling, not `.hom.app _`) and
  -- `a_Z.map (Fp_h.map δ_f)` (the `Functor.comp_map`-UNFOLDED form `G.map (F.map δ_f)`, not `(F⋙G).map δ_f`).
  -- FIX for next pass: state the slide as a bespoke `have hslide : R5 ≫ a_Z.map (Fp_h.map δ_f) =
  --   (pullback h).map (a_Y.map δ_f) ≫ (sheafCompPb h .app (Fp_f M ⊗ Fp_f N)).hom` in the goal's EXACT
  --   `.app _ .hom`/unfolded spelling (proved from `.hom.naturality` + `Functor.comp_map` + the NatIso
  --   `.app.hom = .hom.app` defeq), then `erw [reassoc_of% hslide]` — mirrors how D1′
  --   `pullbackTensorMap_natural` discharges its S1 square via the `.hom.naturality_assoc` forward form.
  -- SLIDE (iter-016, bespoke `hslide` in the goal's exact spelling, proved by `.symm` of the naturality
  -- up to defeq): moves `S1_h` from before `δ_f` to after it.
  have hslide :
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
            ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj
              (PresheafOfModules.Monoidal.tensorObj M.val N.val))).hom ≫
          (PresheafOfModules.sheafification (𝟙 (Z.ringCatSheaf.obj))).map
            ((PresheafOfModules.pullback
                (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
                    (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
                  from (Hom.toRingCatSheafHom h).hom)).map
              (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback
                (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
                    (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
                  from (Hom.toRingCatSheafHom f).hom)) M.val N.val))
        = (SheafOfModules.pullback (Hom.toRingCatSheafHom h)).map
              ((PresheafOfModules.sheafification (𝟙 (Y.ringCatSheaf.obj))).map
                (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback
                  (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
                      (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
                    from (Hom.toRingCatSheafHom f).hom)) M.val N.val)) ≫
            ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).app
              (PresheafOfModules.Monoidal.tensorObj
                ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)
                ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val))).hom :=
    ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality
      (Functor.OplaxMonoidal.δ (PresheafOfModules.pullback
        (show (X.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
            (TopologicalSpace.Opens.map f.base).op ⋙ (Y.presheaf ⋙ forget₂ CommRingCat RingCat)
          from (Hom.toRingCatSheafHom f).hom)) M.val N.val)).symm
  -- `hslide` TYPECHECKS (the `.symm`-of-naturality term has the stated goal-spelling type by defeq), so
  -- the slide equation is PROVEN.  The remaining gap is purely splicing it: `rw`/`erw [reassoc_of% hslide]`
  -- (even after `simp only [Category.assoc]`) reports `Did not find an occurrence of the pattern`, i.e. the
  -- post-`sheafifyMap_δcomp_split` goal does not present `R5 ≫ a_Z.map (Fp_h.map δ_f)` in `hslide`'s LHS
  -- spelling.  NEXT PASS: re-extract the post-split goal (forced type-mismatch) and adjust `hslide`'s LHS to
  -- the verbatim goal spelling so `erw [reassoc_of% hslide]` keys; then continue the interleave with Sq3/Sq4.
  -- ── STEP (iii)a — THE SLIDE IS SPLICED (this iter). ────────────────────────────────────────────
  -- The `S1^h` slide is now landed in the main goal via the generic nested-slide device
  -- `comp_slide_nested` applied by `refine … hslide ?_`.  The breakthrough over iters 016–017: EVERY
  -- keyed-matching tactic (`simp only [Category.assoc]`, `rw`/`erw [reassoc_of% hslide]`) whnf-BOMBS on
  -- the post-step-(ii) goal — the `erw [sheafifyMap_δcomp_split]` of step (ii) introduced a
  -- defeq-but-not-syntactic `SheafOfModules Z` instance boundary that the discrimination-tree matcher
  -- whnf-loops across.  `comp_slide_nested` sidesteps it: its conclusion mirrors the goal's *literal*
  -- nesting `(r0 ≫ r1 ≫ r5 ≫ (p ≫ q) ≫ rtc) ≫ s3 ≫ s4`, so `refine` unifies by metavariable
  -- *assignment only* (no whnf), and the slide `rw` runs on the lemma's own clean `[Category C]` vars.
  -- (NB: `hslide` MUST keep its `show … from` ring-map ascriptions — the `have this := …; this` spelling
  -- makes its `:= …naturality.symm` defeq-check whnf-bomb.)
  refine comp_slide_nested _ _ _ _ _ _ _ _ _ _ _ hslide ?_
  -- ── STEP (iii)b — REMAINING: the merged Sq3/Sq4 core (post-slide goal, extracted this iter). ────
  -- After the slide, R0, R1, U match the RHS heads (defeq):
  --   R0 = (pullbackComp φf φh).inv.app (aX (M⊗N))                = R0' (Scheme.Modules spelling)
  --   R1 = (pullback h).map (S1_f at M⊗N)                          = (pullback h).map S1_f
  --   U  = (pullback h).map (a_Y.map δ_f)                          = (pullback h).map (a_Y.map δ_f)
  -- so the residual core (after cancelling R0 ≫ R1 ≫ U on both sides) is:
  --   V ≫ a_Z.map δ_h' ≫ a_Z.map tcomp ≫ S3_g ≫ S4_g
  --     = (pullback h).map S3_f ≫ (pullback h).map S4_f ≫ S1_h'' ≫ a_Z.map δ_h'' ≫ S3_h ≫ S4_h ≫ Tfinal
  -- where (KEY MISMATCH, the `pullbackValIso` bridge — blueprint "merged Sq3/Sq4 chase"):
  --   • V       = S1_h on the *presheaf*-pullback tensor args  (sheafCompPb h).app (Fp_f M ⊗ Fp_f N) .hom
  --   • S1_h''  = S1_h on the *sheaf*-pullback   tensor args  (sheafCompPb h).app (((pb f).obj M).val ⊗ …) .hom
  --     V ≠ S1_h'' — bridged by `pullbackValIso f` (the (pullback h).map S4_f / S4 factors).
  --   • a_Z.map δ_h'  has presheaf args (Fp_f M.val)(Fp_f N.val); a_Z.map δ_h'' has sheaf args
  --     (((pb f).obj M).val)(((pb f).obj N).val) — same `pullbackValIso f` bridge.
  --   • S3_g = sheafifyTensorUnitIso (Fp_{h≫f} M)(Fp_{h≫f} N).hom; S4_g = a_Z.map (forget(pVI (h≫f) M) ⊗ₘ …);
  --     Tfinal = (a_Z.mapIso (forget.mapIso(pbComp.app M) ⊗ᵢ forget.mapIso(pbComp.app N))).hom.
  -- This is the genuine D1′-style naturality paste of `pullbackTensorMap_natural` (L2007), now for the
  -- *composition* coherence: slide V (=S1_h, presheaf-args) rightward past `(pullback h).map S3_f ≫
  -- (pullback h).map S4_f` by the naturality of `sheafificationCompPullback h` (converting presheaf→sheaf
  -- args, i.e. realigning V to S1_h''), then fold `a.map δ ≫ S3 ≫ S4` into a single `a.map Ψ` on each side
  -- and reduce to a presheaf identity closed by `presheaf_pullback_oplaxmonoidal` (δ-naturality) +
  -- `sheafifyTensorUnitIso_hom_eq'` (L1860) + the `pullbackValIso` factorisation (`def:pullback_val_iso`).
  -- DEVICE THAT CROSSES THE BOUNDARY: continue with generic single-`[Category C]` lemmas whose conclusions
  -- mirror the goal nesting, applied by `refine`/`exact` (assignment-only unification) — NOT `simp`/`rw`/
  -- `erw`, which all whnf-bomb here.  The slide above is the worked template.
  -- STEP (iii)b.1 — cancel the R0 ≫ R1 ≫ U prefix (defeq to R0' ≫ m1 ≫ m2) via the generic
  -- L/R-cancellation device; the three `rfl`s discharge the SheafOfModules-vs-Scheme.Modules leaf defeqs.
  refine comp_cancel_three_lr _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ rfl rfl rfl ?_
  -- THE PURE MERGED Sq3/Sq4 CORE (post-prefix-cancellation):
  --   V ≫ a_Z.map δ_h' ≫ a_Z.map tcomp ≫ S3_g ≫ S4_g
  --     = (pullback h).map S3_f ≫ (pullback h).map S4_f ≫ S1_h'' ≫ a_Z.map δ_h'' ≫ S3_h ≫ S4_h ≫ Tfinal
  -- (notation as in the STEP (iii)b block above).  This is the D1′-style naturality paste of
  -- `pullbackTensorMap_natural`, now for the composition coherence and `pullbackValIso`-bridged.  Next:
  -- slide V (=S1_h on presheaf args) rightward past `(pullback h).map (S3_f ≫ S4_f)` by the naturality
  -- of `sheafificationCompPullback h`, realigning it to S1_h'' (sheaf args); then fold each side's
  -- `a.map δ ≫ S3 ≫ S4` tail into a single `a.map Ψ` and reduce to a presheaf identity closed by
  -- `presheaf_pullback_oplaxmonoidal` + `sheafifyTensorUnitIso_hom_eq'` + the `pullbackValIso` factn.
  -- ── STEP (iii)b.2 — THE SLIDE OF V (S1_h presheaf-args → S1_h'' sheaf-args). ──────────────────
  -- The RHS prefix `m3 ≫ m4 ≫ vv = (pullback h).map S3_f ≫ (pullback h).map S4_f ≫ S1_h''` is, by the
  -- naturality of the connecting iso `sheafificationCompPullback h` at the presheaf morphism `gg`
  -- (`a_Y.map gg = S3_f ≫ S4_f`), equal to `v ≫ a_Z.map (Fp_h.map gg)` with `v = S1_h` on the PRESHEAF
  -- args.  Splicing this (`hcomb`) via the generic `comp_slide_three` leaves the folded presheaf core
  -- `hcore2 : a.map δ_h' ≫ a.map tcomp ≫ S3_g ≫ S4_g = a_Z.map (Fp_h.map gg) ≫ a.map δ_h'' ≫ S3_h ≫ S4_h
  --   ≫ Tfinal`, all `a_Z.map`-foldable.  `gg = (η ⊗ η) ≫ (forget pVI_M ⊗ forget pVI_N)` over Y.
  set gg :
      PresheafOfModules.Monoidal.tensorObj
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val) ⟶
        PresheafOfModules.Monoidal.tensorObj ((pullback f).obj M).val ((pullback f).obj N).val :=
    MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val))
        ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val)) ≫
      MonoidalCategory.tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
        ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)
    with hgg
  -- `a_Y.map gg = S3_f ≫ S4_f` (first factor by `sheafifyTensorUnitIso_hom_eq'`, second is `S4_f`).
  have hg :
      (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map gg
        = (sheafifyTensorUnitIso
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val)
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val)).hom ≫
          (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
            (MonoidalCategory.tensorHom
              (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
              ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)) := by
    -- Split `a_Y.map (A ≫ B)` as a defeq `exact` (the `≫` in `gg` lives in the `forget₂`-carrier
    -- monoidal instance, defeq-but-not-syntactic to `a_Y`'s domain — bridged by `exact`, not `rw`).
    have hsplit :
        (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map gg
          = (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
              (MonoidalCategory.tensorHom
                (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
                ((PresheafOfModules.sheafificationAdjunction
                  (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
                  ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val))
                ((PresheafOfModules.sheafificationAdjunction
                  (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
                  ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val))) ≫
            (PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map
              (MonoidalCategory.tensorHom
                (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
                ((SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)) := by
      rw [hgg]
      exact (PresheafOfModules.sheafification
        (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map_comp _ _
    rw [hsplit]
    congr 1
    exact (sheafifyTensorUnitIso_hom_eq' _ _).symm
  -- Splice the slide: `m3 ≫ m4 ≫ vv = v ≫ a_Z.map (Fp_h.map gg)` from `hg` + naturality of
  -- `sheafificationCompPullback h` at `gg`.
  refine comp_slide_three _ _ _ _ _ _ _ _ _ _ _ _
    ((PresheafOfModules.sheafification (R := Z.ringCatSheaf) (𝟙 Z.ringCatSheaf.obj)).map
      ((PresheafOfModules.pullback (Hom.toRingCatSheafHom h).hom).map gg)) ?_ ?_
  · -- hcomb : m3 ≫ m4 ≫ vv = v ≫ a_Z.map (Fp_h.map gg).  The merge/reassoc runs inside the abstract
    -- `map_comp_slide` (clean vars), then naturality of `sheafificationCompPullback h` at `gg` closes it.
    exact map_comp_slide (Scheme.Modules.pullback h) _ _
      ((PresheafOfModules.sheafification (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).map gg)
      _ _ hg
      ((SheafOfModules.sheafificationCompPullback (Hom.toRingCatSheafHom h)).hom.naturality gg)
  · -- ── STEP (iii)b.3 — THE FOLDED Sq3/Sq4 PRESHEAF CORE (the sole remaining residual). ──────────
    -- Verbatim goal (extracted iter-018 via forced type-mismatch); a_Z = sheafification over Z,
    -- Fp_· = PresheafOfModules.pullback φ'_·, δ_· = Functor.OplaxMonoidal.δ (Fp_·):
    --   a_Z.map (δ_h (Fp_f M.val) (Fp_f N.val))                       -- δ_h'  (presheaf-f args)
    --     ≫ a_Z.map tcomp                                              -- tcomp = pb.hom.app M.val ⊗ₘ pb.hom.app N.val
    --     ≫ (sheafifyTensorUnitIso (Fp_{h≫f} M.val) (Fp_{h≫f} N.val)).hom        -- S3_g
    --     ≫ a_Z.map (forget (pVI (h≫f) M).hom ⊗ₘ forget (pVI (h≫f) N).hom)        -- S4_g
    --   = a_Z.map (Fp_h.map gg)                                        -- vtail (the slid factor)
    --     ≫ a_Z.map (δ_h ((pb f).obj M).val ((pb f).obj N).val)        -- δ_h'' (sheaf-f args)
    --     ≫ (sheafifyTensorUnitIso (Fp_h ((pb f).obj M).val) (Fp_h ((pb f).obj N).val)).hom    -- S3_h
    --     ≫ a_Z.map (forget (pVI h ((pb f).obj M)).hom ⊗ₘ forget (pVI h ((pb f).obj N)).hom)   -- S4_h
    --     ≫ (a_Z.mapIso (forget.mapIso (pbComp h f .app M) ⊗ᵢ forget.mapIso (pbComp h f .app N))).hom  -- Tfinal
    -- RECIPE (D1′-mirror, `pullback_tensor_map_natural` L1984): fold each side into one `a_Z.map Ψ`
    -- (`sheafifyTensorUnitIso_hom_eq'` turns S3_g,S3_h into `a_Z.map (η⊗η)`; `Tfinal =
    -- a_Z.map (tensorHom (forget pbComp.app M)(forget pbComp.app N))`; the δ's,tcomp,S4's,vtail are
    -- already `a_Z.map`), MERGE via `← Functor.map_comp` (as a defeq `exact`/generic lemma — NOT `rw`,
    -- which whnf-bombs the instance boundary, cf. `map_comp_slide`), `congr 1` to the PRESHEAF identity
    -- `Ψ_L = Ψ_R` over Z, and close it by δ-naturality (`presheaf_pullback_oplaxmonoidal` / `δ_natural`
    -- of `δ_h` at `gg`) + `MonoidalCategory.tensorHom_comp_tensorHom` bifunctoriality + the
    -- `pullbackValIso` factorisation (`def:pullback_val_iso`: `pVI = sheafCompPb.symm ≪≫ pullback.mapIso
    -- counit`) reconciling `pVI (h≫f)`, `pVI h`, `pVI f`, and `pbComp h f`.
    rw [sheafifyTensorUnitIso_hom_eq', sheafifyTensorUnitIso_hom_eq']
    simp only [Functor.mapIso_hom, MonoidalCategory.tensorIso_hom]
    refine map_comp4_eq_comp5 _ _ _ _ _ _ _ _ _ _ ?_
    -- Now the pure PRESHEAF identity `Ψ_L = Ψ_R` over `Z`. Expose `gg = u ⊗ v` (`u`, `v` the per-leg
    -- composites `η ≫ forget pVI_f`) and apply δ-naturality of `δ_h = δ (pullback φh)` at `gg`,
    -- aligning both heads to `δ_h (Fp_f M.val) (Fp_f N.val)`.
    have hgg2 : gg =
        MonoidalCategory.tensorHom
          (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat))
          ((PresheafOfModules.sheafificationAdjunction
              (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val) ≫
            (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
          ((PresheafOfModules.sheafificationAdjunction
              (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
              ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val) ≫
            (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom) := by
      rw [hgg]
      exact MonoidalCategory.tensorHom_comp_tensorHom
        (C := _root_.PresheafOfModules (Y.presheaf ⋙ forget₂ CommRingCat RingCat)) _ _ _ _
    rw [hgg2]
    -- δ-naturality of `δ_h` at the legs `u`, `v` as a CONCRETE fully-applied equation (the
    -- `OplaxMonoidal` instance on `pullback φh` is resolved ONCE here via the `show … from` pin), so the
    -- subsequent `rw` matches syntactically and never re-synthesises the instance under the matcher
    -- (which whnf-bombs `erw [reassoc_of% δ_natural]`).
    have hδnat := Functor.OplaxMonoidal.δ_natural
      (F := PresheafOfModules.pullback
        (show (Y.presheaf ⋙ forget₂ CommRingCat RingCat) ⟶
            (TopologicalSpace.Opens.map h.base).op ⋙ (Z.presheaf ⋙ forget₂ CommRingCat RingCat)
          from (Hom.toRingCatSheafHom h).hom))
      ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj M.val) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f M).hom)
      ((PresheafOfModules.sheafificationAdjunction
          (R := Y.ringCatSheaf) (𝟙 Y.ringCatSheaf.obj)).unit.app
          ((PresheafOfModules.pullback (Hom.toRingCatSheafHom f).hom).obj N.val) ≫
        (SheafOfModules.forget Y.ringCatSheaf).map (pullbackValIso f N).hom)
    erw [← reassoc_of% hδnat]
    -- Both sides now share the head `δ_h (Fp_f M.val) (Fp_f N.val)`; cancel it and expose `tcomp` as a
    -- `tensorHom`.  Every remaining factor is a `tensorHom`, so bifunctoriality collapses each side to a
    -- single `tensorHom` of per-leg composites; `congr 1` then splits into the two per-leg identities.
    rw [show tcomp = MonoidalCategory.tensorHom
      (C := _root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat))
      (pb.hom.app M.val) (pb.hom.app N.val) from rfl]
    congr 1
    refine tensorHom_collapse_3_4
      (C := _root_.PresheafOfModules (Z.presheaf ⋙ forget₂ CommRingCat RingCat))
      _ _ _ _ _ _ _ _ _ _ _ _ _ _ ?_ ?_
    · -- per-leg M (the `pullbackValIso` composition coherence, Sq4): the canonical "unit into the
      -- pullback's underlying presheaf" composes pseudofunctorially across `h ≫ f`.
      exact pullbackValIso_comp_leg h f M
    · exact pullbackValIso_comp_leg h f N


/-! ## v4.31.0 recovery — re-ported δ/η-collapse machinery (dropped by the bump).
Ported verbatim from v4.30 `117100c4` (L4077–4768) + the transitive dep
`restrictScalars_δ_app_tmul` (v4.30 L2130). Unblocks K1 + B1. -/

set_option backward.isDefEq.respectTransparency false in