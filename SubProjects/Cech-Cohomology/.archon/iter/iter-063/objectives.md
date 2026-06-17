# Iter-063 objectives (per-lane detail)

Both lanes `mathlib-build`, both HARD-GATE CLEARED on the consolidated chapter
`Cohomology_CechHigherDirectImage.tex`. Both routes CHURNING entering — correctives (blueprint
decomposition/rewrite) executed THIS plan phase; these are the build-the-fully-specified-assembly
dispatches the progress-critic blessed.

## Lane 1 — `CechSectionIdentification.lean` — CSI Stub 2 L2 `q_*`-coherence chain
- Build `pushPull_binary_leg_coherence` (★: `pushPullMap F overInl = (pushforward q).map u₀ ≫ idiso₀.hom`)
  → `pushPull_binary_coprod_prod` (canonical `asIso (prod.lift (pushPullMap …))`, matched vs chainIso)
  → `pushPull_coprod_prod` (finite induction) → close `pushPull_sigma_iso` (Stub 2, line 810).
- Recipe: blueprint `lem:pushPull_binary_coprod_prod` (expanded) + `lem:pushPull_binary_leg_coherence` (new)
  + the in-file comment block above `coprodDecompMap` (complete prover reduction: chainIso, idiso₀/idiso₁).
- Done (do NOT rebuild): `isIso_modules_of_toPresheaf`, `isIso_coprodDecompMap`,
  `isIso_map_prodLift_of_isLimit`, `cechBackbone_left_sigma`.
- Housekeeping: delete 3 stale comment blocks (lines ~553–580, ~814–842, ~666–700); annotate `set_option`
  at ~363.
- PARTIAL bar: build the ★ + binary assembly first; push induction + specialization; close Stub 2 if
  reachable, else precise handoff. `lake env lean` only.

## Lane 2 — `OpenImmersionPushforward.lean` — comparison-iso chain → close `hqc`
- Build `pushforward_slice_two_adjunction` (`pushforward φ'' ⊣ pushforward ψ_r`, `φ'' = sliceStructureSheafHom
  φ.symm Vᵢ`, threading the `Over.map(unitIso.inv)` correction) → `pushforwardSlicePullbackIso`
  (`leftAdjointUniq` + section identity) → `pushforward_iso_preserves_qcoh` → `case hqc` (line 670).
- Recipe: blueprint `lem:pushforward_slice_two_adjunction` (new) + `lem:pushforward_slice_pullback_iso`
  (rewritten) + `lem:pushforward_iso_preserves_qcoh` + the in-file `hqc`-case comment (lines ~650–669).
- Done (do NOT rebuild): `sliceStructureSheafHom` + 4 instances; `pushforward_iso_qcoh_of_slice_qcoh`.
- DEAD (do NOT use): the unit-only `pullbackObjUnitToUnit` sketch (handles only the unit, not general H);
  the `pushforwardPushforwardEquivalence` quadruple.
- PARTIAL bar: build (1)→(2)→(3); close `hqc`. If `_acyclic` closes, attempt `_comp` (line 736) +
  EnoughInjectives connector. If the `Over.map`-correction coherence stalls, precise handoff (no brute-force).
  `lake env lean` only.

## Reversal signal (iter-064)
If either lane returns FLAT (4th consecutive flat iter on that route): do NOT bare-re-dispatch. Blueprint is
fully decomposed + verified correct → escalate (mathlib-analogist cross-domain on the coherence pattern, or
single-lane focus session, or assembly refactor).
