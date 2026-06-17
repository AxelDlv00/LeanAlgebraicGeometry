# Blueprint Writer Report

## Slug
AbelianVarietyRigidity-cov273b2

## Status
COMPLETE — all 16 uncovered helper decls now have a `\lean{}`-pinned block, each wired into
the chapter cone (zero isolated nodes in this chapter).

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Changes Made

### New blocks added (label + `\lean{}`)
RigidityLemma helpers (inserted after `rmk:rigidity_lemma_decomposition`):
- **lemma** `\label{lem:rigidity_snd_lift}` / `\lean{AlgebraicGeometry.rigidity_snd_lift}` — cartesian-monoidal collapse identity `snd ≫ lift(...) = retract`.
- **lemma** `\label{lem:snd_left_isClosedMap}` / `\lean{AlgebraicGeometry.snd_left_isClosedMap}` — Bridge 1: completeness of `X` makes the projection a closed map. `\uses{lem:projectiveLineBar_isProper}`.
- **lemma** `\label{lem:rigidity_core}` / `\lean{AlgebraicGeometry.rigidity_core}` — scheme-level gluing core `f = retract ≫ f`. `\uses{lem:rigidity_eqOn_dense_open}`.

Pointed-core helper (after proof of `prop:morphism_P1_to_AV_constant`):
- **lemma** `\label{lem:morphism_P1_to_grpScheme_const_aux}` / `\lean{AlgebraicGeometry.morphism_P1_to_grpScheme_const_aux}` — basepoint-normalised `𝔾ₘ`-scaling core. `\uses{lem:hom_additivity_over_product, lem:gmScaling_fixes_zero, lem:iotaGm_isDominant}`.

`𝔾ₘ ↪ ℙ¹` chain (new subsection at end of `sec:genus0_helpers`):
- **lemma** `\label{lem:iotaGm_r_1_range_subset}` / `\lean{...iotaGm_r_1_range_subset}` — `\uses{def:p1bar_one}`.
- **definition** `\label{def:iotaGm_r_1}` / `\lean{...iotaGm_r_1}` — `\uses{lem:iotaGm_r_1_range_subset, def:p1bar_one}`.
- **lemma** `\label{lem:iotaGm_r_1_fac}` / `\lean{...iotaGm_r_1_fac}` — `\uses{def:iotaGm_r_1}`.
- **definition** `\label{def:kbarChart1Ring}` / `\lean{...kbarChart1Ring}` — `\uses{def:hlaway_to_mvpoly}`.
- **lemma** `\label{lem:kbarChart1Ring_specMap_fac}` / `\lean{...kbarChart1Ring_specMap_fac}` — `\uses{def:kbarChart1Ring, lem:iotaGm_r_1_fac}`.
- **lemma** `\label{lem:iotaGm_r_1_eq_specMap}` / `\lean{...iotaGm_r_1_eq_specMap}` — `\uses{def:iotaGm_r_1, def:kbarChart1Ring, lem:kbarChart1Ring_specMap_fac}`.
- **lemma** `\label{lem:iotaGm_inner_lift_compat}` / `\lean{...iotaGm_inner_lift_compat}` — `\uses{def:p1bar_one}`.
- **definition** `\label{def:iotaGm_chart1_section}` / `\lean{...iotaGm_chart1_section}` — `\uses{lem:iotaGm_inner_lift_compat, def:iotaGm_r_1, lem:iotaGm_r_1_fac}`.
- **lemma** `\label{lem:iotaGm_chart1_composition_isOpenImmersion}` / `\lean{...iotaGm_chart1_composition_isOpenImmersion}` — `\uses{def:iotaGm_chart1_section, lem:iotaGm_chart1_appIso_eval}`.
- **lemma** `\label{lem:iotaGm_isOpenImmersion}` / `\lean{...iotaGm_isOpenImmersion}` — `\uses{def:iotaGm_chart1_section, lem:iotaGm_inner_lift_compat, lem:iotaGm_chart1_composition_isOpenImmersion}`.
- **lemma** `\label{lem:iotaGm_range_isOpen}` / `\lean{...iotaGm_range_isOpen}` — `\uses{lem:iotaGm_isOpenImmersion}`.
- **lemma** `\label{lem:iotaGm_isDominant}` / `\lean{...iotaGm_isDominant}` — `\uses{lem:iotaGm_range_isOpen, lem:projectiveLineBar_geomIrred}`.

### Statement-level `\uses{}` edges added to existing blocks (the wiring)
- `thm:rigidity_lemma`: added `lem:rigidity_core, lem:rigidity_snd_lift` (Lean proof calls both; `rigidity_eqOn_dense_open` kept as transitive).
- `lem:rigidity_eqOn_dense_open`: added `lem:snd_left_isClosedMap` (Lean proof calls `snd_left_isClosedMap`).
- `prop:morphism_P1_to_AV_constant`: added `lem:morphism_P1_to_grpScheme_const_aux` (the public `morphism_P1_to_grpScheme_const` calls the private aux).
- `lem:iotaGm_chart1_appIso_eval`: added `lem:iotaGm_r_1_eq_specMap` (its Lean proof `simp only [iotaGm_r_1_eq_specMap]`).

All edges mirror the real Lean call graph (verified by grepping callers in
`AbelianVarietyRigidity.lean` / `RigidityLemma.lean`). Each `\uses{}` is on a single line.

### REF fixes
None needed — no literal `REF`/`Theorem~REF`/`Lemma~REF` placeholders exist in the chapter
(verified `grep -n REF` → empty).

## Cross-references introduced
All `\uses{}` targets resolve to labels in THIS chapter:
`lem:projectiveLineBar_isProper`, `lem:rigidity_eqOn_dense_open`, `lem:hom_additivity_over_product`,
`lem:gmScaling_fixes_zero`, `def:p1bar_one`, `def:hlaway_to_mvpoly`, `lem:iotaGm_chart1_appIso_eval`,
`lem:projectiveLineBar_geomIrred` — all confirmed present.

## Verification
- `leandag query --isolated --chapter AbelianVarietyRigidity` → **none**.
- `leandag build --json`: `unknown_uses` = 3, all in OTHER chapters (Quot/Picard:
  `thm:quot_canonical_basechange_app_app_isIso`, `def:quot_pullback_app_isoTensor`); **none from my edits**.
- All 16 new `\lean{}` pins are unique project-wide (each appears exactly once).
- All 16 new labels present exactly once; LaTeX `\begin`/`\end` balanced (lemma 81/81, definition 41/41).
- No `\leanok` added (descriptor-forbidden; the deterministic `sync_leanok` phase owns it).

## References consulted
None — all 16 are project-internal Lean helpers (no external `% SOURCE` required per directive).
The Mumford/Milne `% SOURCE QUOTE` material already present on the parent blocks was left untouched.

## Macros needed (if any)
None. `\fatsemi` is already `\providecommand`'d at the chapter head.

## Notes for Plan Agent
- The chapter is now ~3850 lines; the new `𝔾ₘ ↪ ℙ¹` subsection cleanly groups the `iotaGm_*`/
  `kbarChart1Ring*` helpers. If a future split is desired, `sec:genus0_helpers` is the natural seam.
- `lem:rigidity_core` and `lem:rigidity_snd_lift` describe helpers whose parent `thm:rigidity_lemma`
  is already `\leanok` (chain closed iter-162); `sync_leanok` should mark the new helper blocks
  accordingly on its next run.
- The 3 pre-existing `unknown_uses` (Quot/Picard chapters) are outside my write-domain — flagging
  only; not addressed.

## Strategy-modifying findings
None.
