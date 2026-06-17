# Iter-258 objectives — per-lane detail

## Lane SHARED ROOT — `Picard/SheafOverEquivalence.lean` (NEW; PRIMARY) [prove]

**Goal:** build `SheafOfModules.overEquivalence` + the 3 consumer isos. Closes the engine `chartOverIso`
AND the dual `sliceDualTransport` (both NEXT iter, as one-liners).

**Recipe (`analogies/overeq258.md`, all Mathlib names confirmed file:line):**
- `e := TopologicalSpace.Opens.overEquivalence U : Over U ≌ Opens ↥U` (`Topology/Sheaves/Over.lean:41`).
- Continuity: FREE. `[IsContinuous e.functor J K]` + `[IsContinuous e.inverse K J]` both infer
  (`IsDenseSubsite ⇒ IsContinuous` priority-900 `Sites/DenseSubsite/Basic.lean:548`; equivalence auto
  `e.functor.IsDenseSubsite` from `[e.inverse.IsDenseSubsite]` `Sites/Equivalence.lean:106`; the project's
  `overEquivInverseIsDenseSubsite` `Vestigial.lean:689` supplies the inverse leg). Do NOT hand-prove.
- `φ` (the genuine content, ring-level): `X.ringCatSheaf.over U ⟶ (e.functor.sheafPushforwardContinuous
  RingCat J K).obj (↑U).ringCatSheaf`; sectionwise at `V : Over U` it is `O_X(V.left) ⟶ O_{↥U}(e.functor V)`,
  the open-immersion structure-sheaf iso, built from `U.ι.appIso` (the SAME datum
  `Scheme.Modules.restrictFunctor` uses inline, `Modules/Sheaf.lean:320`). `ψ` symmetric.
  `Scheme.ringCatSheaf = sheafCompose (forget₂ CommRingCat RingCat) X.sheaf` (`Modules/Presheaf.lean:34`).
- `H₁/H₂`: ring-presheaf nat-trans equalities; naturality free on the thin poset; hom-equalities from
  `φ/ψ` mutual-inverse via the `appIso` round-trip (`Sheaf.hom_ext`/`ext`). Skippable in the functor-only shape.
- `overEquivalence := SheafOfModules.pushforwardPushforwardEquivalence e φ ψ H₁ H₂`
  (`PushforwardContinuous.lean:305`).
- `restrictOverIso M`: `M.restrict U.ι` IS `pushforward` along `U.ι.opensFunctor` (`Sheaf.lean:319-322`);
  compose with `pushforward φ` via `SheafOfModules.pushforwardComp` (`= Iso.refl`, `:101`), then
  `pushforwardNatIso` (`:188`) along the `eqToIso` of the two `Over U ⥤ Opens X` functors (both `V ↦ V.left`).
  Verbatim mirror of `restrictFunctorAdjCounitIso` (`Sheaf.lean:335-340`).
- `unitOverIso`: pushforward-of-unit up to `φ` (cf. `pullbackObjUnitToUnitIso` pattern).
- `chartOverIso M U e := (restrictOverIso M).symm ≪≫ overEquivalence.functor.mapIso e ≪≫ unitOverIso`.

**Bar:** `overEquivalence` + `restrictOverIso` + `unitOverIso` axiom-clean (genuine content); `chartOverIso`
follows. Functor-only fallback (bare `pushforward φ` + 2 object isos, skip `ψ/H₁/H₂`) sanctioned if the
full-equivalence coherences resist.
**Reversing signal:** a continuity instance does NOT infer, or `pushforwardPushforwardEquivalence`'s
hypotheses don't match → STOP, report the exact failing instance/goal; do NOT hand-roll a parallel equivalence.

## Lane D3′ — `Picard/TensorObjSubstrate.lean` [prove]

**Goal:** add the presheaf-level **Sq2b** lemma (monoidality of `PresheafOfModules.pullbackComp`), then
close `pullbackTensorMap_restrict`.

**Recipe (`analogies/d3sq2b258.md`):** η→δ port of the COMPILING `pullbackObjUnitToUnit_comp` (L910), stated
at PresheafOfModules level.
- State Sq2b about `pullbackComp φ'_f φ'_h` (Pullback.lean:131) using the composite ring-map spelling
  `φ'_f ≫ F.op ◁ φ'_h` (NOT bare `(toRingCatSheafHom (h≫f)).hom` — this dissolves friction (2)). Take δ
  w.r.t. `presheafPullbackOplaxMonoidal` (L1146), binding `φ'` as `pullbackTensorMap` does at L1217-1218
  (this dissolves friction (1), the forget₂ pin — no Scheme/forget₂ reasoning enters Sq2b).
- Proof skeleton (η→δ of L915-1000):
  `apply (pullbackPushforwardAdjunction (φ'_f ≫ F.op ◁ φ'_h)).homEquiv _ _ |>.injective`;
  LHS rewrite δ via `Adjunction.leftAdjointOplaxMonoidal_δ` (δ is a Mathlib def — no project lemma needed);
  RHS transpose `pullbackComp.inv/.hom` via `Adjunction.conjugateEquiv_leftAdjointCompIso_inv` +
  `unit_conjugateEquiv` + `comp_unit_app`; residual = lax-μ composition coherence of `pushforward` across
  `pushforwardComp` (concrete, expected `rfl`/short `ext` — cf. η-twin `unitToPushforwardObjUnit_comp` L881,
  `pushforwardComp_hom_app_app = 𝟙` Sheaf.lean:214); two-arg `tensorHom`/`δ_natural` bookkeeping copied
  line-for-line from `Adjunction.isMonoidal_comp` (Functor.lean:995-999); `erw` (not `rw`) for the
  `Category.assoc`/`Functor.map_comp` steps (η-twin gotcha L906-909).
- Then 4-square assembly (Sq1 `sheafificationCompPullback`-comp, Sq3 `sheafifyTensorUnitIso`, Sq4
  `pullbackValIso`-comp) + the `rfl` reconcile `toRingCatSheafHom_comp_hom_reconcile` (L2121, CLOSED) close
  `pullbackTensorMap_restrict`.

**Bar:** close Sq2b axiom-clean; then attempt the full `pullbackTensorMap_restrict`. Do NOT touch
`exists_tensorObj_inverse` (L715); keep D1′/D2′ GREEN.
**Reversing signal:** a step in the η→δ port with NO analog in the compiling η-twin → leave the typed
sorry + report the exact failing step; do NOT stack a new abstract helper layer.

## HELD this iter
- `Picard/LineBundleCoherence.lean` — 5→1; `chartOverIso` one-liner closes NEXT iter once the shared root
  lands (redirect the local sorry-def to the general `Scheme.Modules.chartOverIso`).
- `Picard/TensorObjSubstrate/DualInverse.lean` — `sliceDualTransport` closes NEXT iter as a consumer of
  `overEquivalence`; HELD removes the iter-257 cross-lane compile race. Clean aud257 stale comments
  (L18/L207/L639) when re-opened.
