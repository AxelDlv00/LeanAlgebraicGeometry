# Iter-046 objectives

## Prover lane (1)

### `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — `tile_section_localization` via restrictScalars carrier  [prover-mode: mathlib-build]
- **Target:** build the NEW decl `tile_section_localization` (does not yet exist; no-sorry mathlib-build).
- **PRIMARY RECIPE:** `analogies/tile-descent-instance-shape.md` (mathlib-analogist iter-046, ALIGN_WITH_MATHLIB).
  Route the descent's `M N` through `(ModuleCat.restrictScalars (algebraMap R R_g)).obj (tile-section)` so
  `Module R`/`Module R_g`/`IsScalarTower R R_g` are ALL `inferInstance`-structural (kills W1/W2). One tiny Prop
  `IsScalarTower` instance; final transport via `IsLocalizedModule.of_linearEquiv(_right)` + `eqToLinearEquiv`;
  `show`/`change` staging for residual W3. Descent lemma `isLocalizedModule_powers_restrictScalars_of_algebraMap`
  stays verbatim.
- **Plus two in-file cleanups (HIGH-2/HIGH-3):** mangle the sync-fooling commented `lemma tile_section_localization`
  sketch (~L1046–1066) so it no longer carries that literal; delete the stale "no math wall / full assembly now
  unblocked" block (~L1068–1108) that contradicts the W1–W3 block.
- **Dead ends (do NOT retry):** `letI`/`have` any `Spec`-dependent instance (W1); single giant inline `@…` term
  (W3-fragile); F-side-carrier-alone reshape (symmetric wall); bundled-`modulesSpecToSheaf.obj`-level restrictScalars.
- **Blueprint:** `chapters/Cohomology_CechHigherDirectImage.tex` — `lem:tile_section_localization` (Step 4/5
  rewritten to the restriction-of-scalars descent this iter; HARD GATE satisfied).

## Subagents dispatched
- mathlib-analogist `tile-descent` (api-alignment) → ALIGN_WITH_MATHLIB (restrictScalars carrier; `analogies/tile-descent-instance-shape.md`)
- progress-critic `routeb` → CHURNING-but-converging, dispatch=OK (corrective = analogist consult, executed)
- blueprint-writer `coverage-debt` → 5 companion blocks (`unmatched` 6→1)
- blueprint-writer `step4` → Step 4/5 rewritten to restriction-of-scalars descent
- blueprint-clean `tsl` → purified
- blueprint-reviewer `iter046` → complete+correct after 1 must-fix (`\uses` edge added by planner + dag-query verified)

## Skips
- strategy-critic — substance unchanged since iter-041; prior SOUND; no live CHALLENGE (see plan.md).
