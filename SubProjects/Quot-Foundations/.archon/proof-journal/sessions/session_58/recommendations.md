# Recommendations — next plan iter (post iter-058)

## Closest-to-completion (prioritize)
1. **GF `genericFlatness` `flatV` STEP-3 (FlatteningStratification.lean:3585) — ONE equation left.**
   Close `l (c•x) = c•l x` (the ρ-agreement) via `Scheme.Modules.map_smul` + the `map_appLE`/`appLE_map`
   square (identical to the COMPILING `hsquare` of STEP 1). ~40-60 LOC, NO Mathlib gap, no design
   decision. This is the cheapest project headline to close — single prove-mode lane, NOT escalation.
   Reuse the in-code recipe comment (FlatteningStratification.lean:3563-3584). Do NOT re-decompose.

## Promising / needs structural work before prover
2. **SNAP `relTensorProj.naturality` (SectionGradedRing.lean:658) — needs net-new infra, BLUEPRINT FIRST.**
   The blocker is concrete and named: `forget₂ CommRingCat→RingCat` carrier mismatch between the
   relative-tensor base ring and the apex restriction. Two viable routes — (a) a
   `restrictScalars`/`forget₂` carrier-transport lemma, or (b) prove naturality on the `ModuleCat`
   presheaf BEFORE forgetting to `Ab` (where `PresheafOfModules.Monoidal.tensorObj_map_tmul` applies
   directly). Route (b) is likely cleaner. **Effort-break + blueprint-expand `lem:relativeTensor_as_coequalizer`
   step-2 to spell out the carrier obstacle BEFORE dispatching a prover** (lvb snap-iter058 §recommended-
   chapter-actions #3). Do NOT re-queue a bare prover round — the carrier wall is structural.
3. **GR-quot bundle cocycle** — chapter written this iter (`def:gr_bundleTransition`,
   `lem:gr_bundleCocycle_id/_mul`); scaffold + prover deferred to iter-059 per the planner. Full-review
   the fresh cocycle chapter before scaffolding.

## Blueprint coverage debt (planner: author prose, do NOT let provers consume uncovered helpers)
leandag `unmatched` = 11. New this iter needing `\lean{}` blocks (all axiom-clean, exist in Lean):
- **FlatteningStratification.lean:** `flat_of_ringEquiv_semilinear` (flatness analogue of
  `lem:module_free_of_ringEquiv`; §B1.x), `flat_localization_models` (model-independence of localization
  flatness; beside `lem:gf_flat_localizedModule_sameBase`), `gf_flat_isLocalizedModule_sameBase` (B1′,
  corollary of `lem:gf_flat_localizedModule_sameBase`), `isLocalizedModule_powers_restrictScalars`
  (scalar-tower descent; "Transport helpers"). Statements in lvb flat-iter058 §recommended #1-4.
- **SectionGradedRing.lean:** `relTensorActR` (parallel `def:relTensorActR` to `def:relTensorActL`),
  `relTensorProj` (`def:relTensorProj`, with the carrier-obstacle proof-sketch note). Statements in lvb
  snap-iter058 §recommended #1-2.
- **Private helpers (acceptable, no block needed):** `objRestrict`, `objRestrict_apply`,
  `objRestrict_id`, `objRestrict_comp`, `opensTopology`.

## Stale `.lean` comments — refactor/prover cleanup next iter (review agent cannot edit `.lean`)
lean-auditor iter058 + lvb flagged (all major; misleading, not incorrect code):
- `FlatteningStratification.lean:1957` — `genericFlatnessAlgebraic` module doc says "Surviving residue
  (`sorry` this iter)" but the proof (L1989-2142) is fully sorry-free. REMOVE.
- `FlatteningStratification.lean:47-53` — claims the polynomial-ring core is missing; both
  `exists_free_localizationAway_polynomial` and `exists_localizationAway_finite_mvPolynomial` exist in
  the file. UPDATE.
- `FlatteningStratification.lean:21-24, 3344` — partially stale (minor).
- `SectionGradedRing.lean:660-712` — entire "DEFERRED" block describes `relTensorActL`/`relTensorActR`
  as blocked; both are proved directly above it. REMOVE/REWRITE.
- `SectionGradedRing.lean:715-796` — labeled "superseded", still noisy (minor).

## Blueprint sketch under-specification (blueprint-writer)
- `thm:generic_flatness` STEP-3: add the semilinearity argument (call `flat_of_ringEquiv_semilinear` with
  `RingEquiv.refl` + the presheaf map iso; semilinearity via `map_smul` + `appLE` square). lvb flat #5.
- `lem:relativeTensor_as_coequalizer` step-2: name the `forget₂ CommRingCat RingCat` coercion as the
  source of the projection-row naturality friction. lvb snap #3.
- `def:relTensorTriplePresheaf`: `\uses{lem:relativeTensor_as_coequalizer}` is backwards (the triple
  presheaf is an INPUT to the coequalizer); fix direction. (planner iter-058 sidecar already flagged.)

## Infra-hygiene (low priority)
- 9 SNAP private decls carry public-name `\lean{}` pins (`unitModule`, `sheafificationCounitIso`,
  `tensorObjUnitIso`, `tensorObjRightUnitor`, `tensorBraiding`, `tensorPow_zero`, `tensorPow_succ`,
  `moduleTensorPow_zero`, `MonoidalPresheaf`) — potential `sync_leanok` blind spot if a sorry is later
  introduced (private mangled names). Consider de-privatizing or noting in the chapter. lvb snap #5.
- `sync_leanok` multi-pin-block gap: it appears to mark `\leanok` off only the FIRST pin of a multi-pin
  `\lean{...}` list (`lem:relativeTensor_objectwise_coequalizer` had all 21 pins sorry-free but no
  `\leanok` until manual override this iter). Worth a deterministic-script fix.

## Do NOT retry without a structural change
- SNAP element-level `TensorProduct.map_tmul` on the nested triple/projection forms — the middle ring
  factor's rfl-defeq-but-syntactically-distinct `Module ℤ` instance defeats the `map_tmul` motive. Use
  the LinearMap-level collapse (functoriality) or `change`-to-reduced-form (actL/R) instead.
