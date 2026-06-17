# Iter 028 — Objectives (per-lane detail)

Three import-independent prover lanes; all chapters gate-cleared by blueprint-reviewer `iter028`
(complete+correct, 0 must-fix).

## Lane 1 — FBC `Cohomology/FlatBaseChange.lean` [prove]
- **Target:** `lem:base_change_mate_inner_eCancel_assemble` = the `sorry` @~1413 inside
  `base_change_mate_fstar_reindex_legs` (the step-(iii) telescoping). Cascade once closed:
  `fstar_reindex` → `inner_value_eq` → `gstar_transpose` @~1829.
- **Route (post-subst `_legs`, live):** `erw [..._unitExpand …]` (defeq) → term-mode `_gammaDistribute` →
  unfold `codomain_read_legs` → cancel 3 atoms + `pushforwardComp_hom_eq_id` → survivor → Seam 1 → ρ.
  Inline pre-subst route WALLED (do not retry). Memory `fbc-subst-legs-literal-form-lock`.
- **Rider:** fix 3 stale .lean docstrings (auditor iter-026: ~235–247, ~1575–1577, ~1848–1852/~1917–1919).
- **Stall plan:** leave the distributed-but-uncancelled goal; iter-029 → mathlib-analogist telescoping
  consult (NOT a 3rd helper round).
- **Prior critic:** progress-critic CHURNING (mechanical) — corrective (blueprint reroute) executed this iter.

## Lane 2 — QUOT `Picard/QuotScheme.lean` [mathlib-build]
- **Target:** `Scheme.Modules.isLocalizedModule_basicOpen_of_isQuasicoherent` (G1-core), **Route F** =
  module analogue of `isLocalization_basicOpen_of_qcqs` (3-field constructor, no equalizer/flat-descent).
- **First target:** Step 1 — finite basic-open tilde cover from `QuasicoherentData` (the manual core) +
  `map_units` (cheap). Then `surj`/`exists_of_eq` by `compact_open_induction_on` + sheaf Mayer–Vietoris.
- **Recipe:** `analogies/g1core-affine-descent.md`; blueprint `lem:qcoh_affine_section_localization`.
  Name fix: `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation` (no `Modules.`).
- **Discipline:** axiom-clean, no sorry; if blocked, hand off the named-ingredient decomposition.
- **Prior critic:** UNCLEAR (analogist-first was the right move — done).

## Lane 3 — GR `Picard/GrassmannianCells.lean` [mathlib-build]
- **Target:** `Grassmannian.scheme` via `Scheme.GlueData` — build `t'` (orderSwap via `awayMulCommEquiv`),
  `t_fac` (leg lemmas + `ringHom_ext`), `cocycle` (telescope to `lem:gr_cocycle`), then `.glued`.
- **Min bar (progress-critic watch):** land t_id/t'/t_fac axiom-clean; hand off remaining field if `.glued`
  doesn't close. Dead-end: never plug the heavy chart ring into `IsScalarTower`/tensor synthesis (timeout).
- **Recipe:** iter-026 GR task_result decomposition + blueprint `def:gr_glued_scheme` construction paragraph.
- **Prior critic:** UNCLEAR (fresh GR-glue sub-phase; volume task, all inputs DONE).
