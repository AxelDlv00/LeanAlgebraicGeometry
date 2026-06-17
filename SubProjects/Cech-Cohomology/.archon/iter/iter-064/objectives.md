# Iter-064 objectives

2 prover lanes, both **[prover-mode: fine-grained]** (the progress-critic-prescribed mode-switch — the NEW
structural element vs iters 061–063's mathlib-build re-dispatches). Each terminal chain is now a sequence of
individually-named atomic sub-lemmas in `Cohomology_CechHigherDirectImage.tex`.

## Lane 1 — `CechSectionIdentification.lean` (CSI Stub 2, P5a-resolution)
Build the 6 atomic induction-chain sub-lemmas (create each — they do not yet exist), then close Stub 2:
- `pushPullObjCongr` (~6 LOC) → `over_sigmaOptionIso` (~15) → `piOptionIso` (~15) →
  `pushPull_coprod_prod_empty` (~20–30, initial-scheme terminality) → `pushPull_coprod_prod`
  (`induction_empty_option`) → close `pushPull_sigma_iso` (Stub 2, line 951).
- If Stub 2 closes: attempt Stub 4 `pushPull_eval_prod_iso` (line 1042, low-difficulty).
- Housekeeping: prune the stale ~695–729 planning block.
- Done (do NOT rebuild): `isIso_modules_of_toPresheaf`, `isIso_coprodDecompMap`, `pushPull_binary_coprod_prod`,
  `pushPull_binary_leg_coherence`, `sigmaOptionIso`, `cechBackbone_left_sigma`.

## Lane 2 — `OpenImmersionPushforward.lean` (P5a-consumer `hqc`)
Build the comparison-iso chain (create each — they do not yet exist), then discharge `case hqc` (line 795):
- `slice_reverse_ring_map` (φ'', **CORRECTED**: object-level correction-FREE = over-pullback of
  `φ.hom.toRingCatSheafHom`; do NOT use `sliceStructureSheafHom φ.symm` — verified type-mismatch) →
  `pushforwardSliceAdjunctionH1`/`H2` (`eqToHom = eqToHom`) → `pushforwardSliceTwoAdjunction`
  (`pushforwardPushforwardAdj`) → `pushforwardSlicePullbackIso` (`leftAdjointUniq`) →
  `pushforward_iso_preserves_qcoh` → close `hqc`.
- If `hqc` closes → `_acyclic` closes → attempt `_comp` (line 861) + EnoughInjectives connector (~6 LOC).
- Done (do NOT rebuild): ψ_r infra, `sliceOversEquiv` + both continuity instances, `pushforward_iso_qcoh_of_slice_qcoh`.

## Reversal signal
5th flat iter on either lane ⟹ re-break the ONE stalling sub-lemma sentence-by-sentence (or mathlib-analogist
cross-domain on OpenImm H₁/H₂). Do NOT re-dispatch a lane whole.
