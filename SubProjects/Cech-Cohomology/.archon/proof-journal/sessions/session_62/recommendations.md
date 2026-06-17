# Recommendations for the next plan iteration (post iter-062)

## TOP PRIORITY — both active routes are now "large final assembly + thin/incomplete blueprint". Do NOT bare-re-dispatch either.

Sorry has been FLAT at 9 for two consecutive iters (061, 062). Both lanes added genuine axiom-clean
infrastructure but closed no sorry. This is the CHURNING/OVER_BUDGET pattern the progress-critic has
flagged. The correct structural action this time is **effort-break + blueprint completion BEFORE any
prover round**, on both routes. Re-run progress-critic; expect CHURNING on both — the corrective below
is the response, not another helper round.

### Route A — CSI L2 `pushPull_binary_coprod_prod` (the real remaining work, NOT a leaf)
- **Reset the planner's model:** the iter-061 handoff "`isIso_coprodDecompMap` is the ONLY residual of
  L2" was **WRONG**. The leaf is now proved (axiom-clean), but L2 is a `q_*`-pushforward coherence
  assembly (≈200–300 LOC). Do not treat L2 as a one-shot prover target.
- **Action 1 — `effort-breaker` on `lem:pushPull_binary_coprod_prod`** (fine granularity). Split along
  the prover's worked-out reduction (CSI task_result + the in-file comment block above `coprodDecompMap`):
  1. `idiso₀`/`idiso₁` leg isos — `innerIso = restrictFunctorIsoPullback ≪≫ pullbackComp ≪≫
     pullbackCongr w` pushed forward, + `eqToIso (congrArg (·_*(·^*F)) w)` transport. (KEY DEFEQ:
     `q_*(inl_* N) = (pushforward (inl ≫ q)).obj N` is `rfl` — `pushforwardComp` identity-on-objects.)
  2. **Per-leg coherence (★)** — `pushPullMap F overInl = (pushforward q).map u₀ ≫ idiso₀.hom`, via
     `pushPullMap_eq_raw` + `rawPushPullMap_self_gen` (CechHigherDirectImage.lean:373) +
     `Adjunction.unit_leftAdjointUniq_hom_app` (Mathlib `Adjunction/Unique.lean:51`). This is the actual
     proof obligation; collapse to `eqToHom = eqToHom` via `Functor.map_comp` + `eqToHom_map`.
  3. `chainIso` assembly (`(pushforward q).mapIso (asIso coprodDecompMap) ≪≫ PreservesLimitPair.iso …
     ≪≫ prod.mapIso idiso₀ idiso₁`).
  4. `pushPull_coprod_prod` (finite induction) + `pushPull_sigma_iso` (Stub 2 specialization).
- **MANDATORY framing constraint:** define `pushPull_binary_coprod_prod := asIso (prod.lift (pushPullMap
  F overInl) (pushPullMap F overInr))` — the canonical prod.lift, proving `IsIso` by `prod.hom_ext`
  against `chainIso.hom`. Stubs 4/5 (next) require `.hom` to literally be the `pushPullMap` comparison;
  a non-canonical chain iso that merely kills Stub 2's sorry is a dead end (prover-flagged).
- **Action 2 — `blueprint-writer`** on `lem:pushPull_binary_coprod_prod` + `lem:pushPull_coprod_prod`:
  the lvb-csi must-fix is that these `\lean{}`-named decls don't exist; the blueprint proof detail is
  the limiting factor for the assembly. Have the writer spell out the per-leg coherence (★) and the
  induction so the prover formalizes a complete sketch, not a stub.

### Route B — OpenImm comparison iso `pushforwardSlicePullbackIso` (blueprint is INCOMPLETE — fix first)
- **Gate: the blueprint proof of `lem:pushforward_slice_pullback_iso` is mathematically incomplete**
  (lvb-openimm must-fix #5): its `pullbackObjUnitToUnit`-only sketch handles the unit module, not
  general `H`. **`blueprint-writer` MUST complete it BEFORE a prover round.** Retarget the proof to the
  route the prover already identified and de-risked:
  `pullback ψ_r ≅ pushforward φ''` via `Adjunction.leftAdjointUniq (pullbackPushforwardAdjunction ψ_r)
  (pushforwardPushforwardAdj adj φ'' ψ_r H₁ H₂)`, then `pushforward φ'' (H.over Uᵢ) ≅ (Φ H).over Vᵢ` is
  a `rfl`-clean section identity. `φ''` = the reverse slice ring map = `sliceStructureSheafHom φ.symm Vᵢ`
  (constructible from this iter's `sliceStructureSheafHom`).
- **Then `effort-breaker`** on the eqToHom coherence: the genuine ≈100–150 LOC work is the
  `Over.postEquiv`-inverse `Over.map (unitIso.inv)` correction forced by the non-`rfl` open identity
  `φ.hom⁻¹ᵁ φ.inv⁻¹ᵁ Uᵢ = Uᵢ` (verified non-`rfl`), threading bookkeeping through `φ''`/`H₁`/`H₂`. Split
  off the open-identity correction as its own sub-lemma.
- Warm-start blocks already verified by the prover: `eOpens := Opens.mapMapIso (Scheme.forgetToTop.mapIso
  φ).symm`, `Over.postEquiv (X := Uᵢ) eOpens`, `pushforwardPushforwardAdj`. Note: `IsIso
  φ.inv.toRingCatSheafHom` does NOT `infer_instance` (no Mathlib `pushforward`-fully-faithful instance),
  so a fully-faithful shortcut is unavailable — the `leftAdjointUniq` route is the way.
- Once `pushforwardSlicePullbackIso` lands, the per-slice qcoh obligation at OpenImm:670 closes and
  `hqc` is done; `higherDirectImage_openImmersion_comp` (line 736) is a separate downstream target.

## Coverage debt — 7 unmatched `lean_aux` nodes (6 new this iter + 1 dead). Blueprint these.
The planner should restore 1-to-1 correspondence (bundle the helper names into a related decl's
`\lean{...}`; do NOT author informal prose for these in review):
- `AlgebraicGeometry.isIso_coprodDecompMap` (CSI, `private`) — `IsIso (coprodDecompMap M)`. Relies on
  `TopCat.Sheaf.isProductOfDisjoint`, `SheafOfModules.evaluation`, `forget₂ (ModuleCat _) Ab`,
  `isCompl_opensRange_inl_inr`, `Scheme.Hom.image_preimage_eq_opensRange_inf`. Fold into
  `lem:pushPull_binary_coprod_prod`'s `\lean{}` once L2 lands.
- `AlgebraicGeometry.isIso_map_prodLift_of_isLimit` (CSI, `private`) — general helper. Relies on
  `prodComparison_fst/snd`, `isIso_prodLift_of_isLimit`, `IsIso.of_isIso_comp_right`. Same home.
- `AlgebraicGeometry.opensMapInvBase_isEquivalence` (OpenImm) — relies on `Opens.mapMapIso`,
  `Scheme.forgetToTop.mapIso`.
- `AlgebraicGeometry.overPost_slice_isContinuous` (OpenImm) — relies on `coverPreserving_opens_map`,
  `CoverPreserving.overPost`, `compatiblePreservingOfFlat`.
- `AlgebraicGeometry.sliceStructureSheafHom_pre_isRightAdjoint` (OpenImm) — relies on
  `PresheafOfModules.pullbackObjIsDefined_eq_top`, `isRightAdjoint_of_leftAdjointObjIsDefined_eq_top`.
- `AlgebraicGeometry.sliceStructureSheafHom_isRightAdjoint` (OpenImm) — relies on the Mathlib
  `SheafOfModules.pushforward _.IsRightAdjoint` instance + sliced-site sheafify instances.
  → The 4 OpenImm instances are supporting infra for `lem:slice_structureSheaf_hom`; bundle their names
    into that lemma's `\lean{...}` (lvb-openimm major #7 asks for exactly this).
- `AlgebraicGeometry.CechAcyclic.affine` — dead/known; carry as-is.

## Hygiene (MEDIUM, not blocking) — schedule a `.lean` comment cleanup
lean-auditor flagged 3 major stale-comment blocks in CSI (cannot be fixed in review — no `.lean` write):
stale planner-strategy blocks above the already-proved `cechBackbone_left_sigma` (553–580) and
`pushPull_leg_sections` (814–842); an iter-062 handoff block (666–700) that belongs in PROGRESS. Plus 6
minors (heartbeat-bump comment formatting, `show`-vs-`change`). Fold a cleanup into the next prover/
refactor touch on these files; do not spawn a dedicated iter for it.

## Do NOT retry without structural change
- **Do NOT re-dispatch CSI L2 or OpenImm comparison-iso as bare prover targets.** Both have been
  understood-but-large for ≥1 iter; bare re-dispatch will churn. Effort-break + blueprint-complete first
  (above). This is the explicit progress-critic corrective, pre-applied.
- The iter-061 "leaf is the only residual" handoff overestimated CSI readiness; trust the iter-062
  prover's full-assembly reduction instead.
