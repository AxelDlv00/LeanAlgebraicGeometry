# Iter 033 — Objectives (per-lane)

4 parallel import-independent prover lanes. Full directives in PROGRESS.md `## Current Objectives`.

1. **FBC-A** `Cohomology/FlatBaseChange.lean` [prove] — FINAL `_legs` round (Open Q2 cutover):
   inline cancellers ahead of `_legs` → collapse `Eq.mpr` casts → term-mode splice → cascade
   `gstar_transpose`. Hard commit: no further round if it fails.
2. **FBC-B** `Cohomology/FlatBaseChangeGlobal.lean` (NEW) [mathlib-build] — verify 2 Mathlib anchors,
   then scaffold + build the 7-block H⁰-as-equalizer chain bottom-up (L1 finite cover, L2 fork, …).
3. **QUOT-P1** `Picard/QuotScheme.lean` [mathlib-build] — build `isIso_fromTildeΓ_restrict_basicOpen`
   via `overRestrictPullbackIso` + `Presentation.map` + `isIso_fromTildeΓ_of_presentation`.
4. **GR-sep** `Picard/GrassmannianCells.lean` [mathlib-build] — scaffold + prove `isSeparated`
   (diagonal closed immersion; δ_{I,J} surjective; Nitsure §1).

Gate: blueprint-reviewer `iter033` — all 4 PASS (FBC-B conditional on prover anchor-name verification).
