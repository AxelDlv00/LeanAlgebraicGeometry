# Recommendations for the next plan iteration (post iter-041)

## HIGH — blueprint must-fix before re-dispatching `tile_section_localization`
From `lean-vs-blueprint-checker-qts` (must-fix-this-iter):
- **`lem:tile_section_localization`'s proof sketch is inadequate.** It still says the powers of `f̄`
  "correspond to" powers of `f` with NO mechanism, and it omits the base-ring descent entirely. The
  prover proved the naive `restrict_obj`-rfl wiring recipe is UNSOUND (concrete defeq failure). Dispatch a
  **blueprint-writer** on `Cohomology_CechHigherDirectImage.tex` to rewrite this sketch around the correct
  two-ingredient route: (A) the `modulesSpecToSheaf ∘ restrict` section comparison (Sub-lemma B, the real
  ~100–150 LOC piece) + opens identities (Sub-lemma A), and (B) the base-ring descent
  `isLocalizedModule_powers_restrictScalars_of_algebraMap`. Until this is fixed, do NOT re-dispatch the tile
  lemma (HARD GATE).
- Report: `.archon/task_results/lean-vs-blueprint-checker-qts.md`.

## HIGH — coverage debt (DAG `unmatched`): 2 new uncovered Lean decls + restate the 3rd
`archon dag-query unmatched` = 3 nodes (1 pre-existing dead + 2 new this iter):
- **`AlgebraicGeometry.isLocalizedModule_powers_restrictScalars_of_algebraMap`** (`QcohTildeSections.lean`)
  — substantive base-ring-descent lemma, NO blueprint block, absent from all `\uses{}`. Add a blueprint
  lemma (suggested label `lem:isLocalizedModule_base_descent`) with `\lean{...}` and wire it into
  `lem:tile_section_localization`'s `\uses{}`. Lean proof depends on: `IsLocalizedModule` clauses,
  `Module.End.isUnit_iff`, `algebraMap_smul`, `map_pow`, `IsScalarTower`. (lvb-checker MAJOR.)
- **`AlgebraicGeometry.res_trans_apply`** (private, `QcohTildeSections.lean`) — restriction functoriality
  helper for `qcoh_section_equalizer`. Bundle its `\lean{...}` coverage under `lem:qcoh_section_equalizer`
  (a `% NOTE` already records this; the planner should fold the name into that block's `\lean{}` list).
- **`AlgebraicGeometry.CechAcyclic.affine`** (pre-existing dead, `has_sorry: true`) — deferred (protected
  file references it); unchanged from prior iters.

## HIGH — closest-to-completion: the keystone is one real lane from assembly
The re-routed keystone `qcoh_section_isLocalizedModule` now has 3 of 4 ingredients DONE:
- `qcoh_section_equalizer` ✔ (this iter, axiom-clean, more general than blueprinted)
- `section_isLocalizedModule_of_presentation` ✔ + `presentationModulesRestrictBasicOpen` (B4) ✔
- `isLocalizedModule_powers_restrictScalars_of_algebraMap` ✔ (this iter — ingredient #4 of the tile lemma)
- `IsLocalizedModule.map_exact` (Mathlib) ✔
**The only remaining frontier work is `tile_section_localization` (Sub-lemma A + Sub-lemma B), then the
kernel comparison, then the keystone wrapper.** Next iter's ready lane (after the blueprint fix) is
Sub-lemma A + Sub-lemma B inside `QcohTildeSections.lean` (mathlib-build).

## DO NOT retry as "wiring" — structural change required first
- **`tile_section_localization`** must NOT be re-dispatched with the `restrict_obj`-rfl premise. The
  carriers `↥((modulesSpecToSheaf.obj (modulesRestrictBasicOpen g F)).presheaf.obj (op ⊤))` and
  `↥((modulesSpecToSheaf.obj F).presheaf.obj (op (specBasicOpen g)))` are NOT defeq (`run_code`-verified).
  `modulesSpecToSheaf.obj` (global ring `R`) does not commute with `restrict` definitionally. The
  structural prerequisite is the section-comparison Sub-lemma B; build it FIRST as its own decl. (This is
  the project memory note `keystone-tile-reconciliation-not-rfl`, now confirmed in Lean — see
  PROJECT_STATUS.md Known Blockers.)

## Reusable proof patterns discovered (see PROJECT_STATUS.md Knowledge Base)
- Degree-0/1 sheaf-axiom equalizer of a `SheafOfModules` on `Spec R` from the sheaf axiom alone
  (`existsUnique_gluing'` + `section_ext` + `IsCompatible`; sheaf condition is `.2`, NOT deprecated `.cond`).
- Base-ring descent of `IsLocalizedModule` (converse of Mathlib's `of_restrictScalars`) via
  `Module.End.isUnit_iff` + scalar-tower `algebraMap_smul`.

## Minor (no action this iter)
- lean-auditor `iter041`: several `simp only []` no-op calls in private helpers — cosmetic, no soundness
  impact; clean up opportunistically (`.archon/task_results/lean-auditor-iter041.md`).
- blueprint-doctor: clean.
