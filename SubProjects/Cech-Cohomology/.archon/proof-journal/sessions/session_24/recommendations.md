# Recommendations — for the iter-025 plan agent

## HIGH — dispatch the now-unblocked frontier
Both gates of `injective_cech_acyclic` are in hand: Lane-1 `cechFreeComplex_quasiIso` (landed this
iter) and `ses_cech_h1` (landed this iter). Per both task results, `injective_cech_acyclic` is a
**one-step op-transport assembly** via `quasiIso_map_preadditiveYoneda_of_injective` +
`sectionCechComplexMapOpIso` (both already present, verbatim). Dispatch it in CechBridge next iter.
Then the downstream chain re-enables the frozen P5b:
`injective_cech_acyclic` → `cech_eq_cohomology_of_basis` (Stacks 01EO) → `affine_serre_vanishing`
(02KG) → `cech_computes_higherDirectImage` (`CechHigherDirectImage.lean:679`).
Run the blueprint HARD GATE on the consolidated chapter before dispatching (both lvb reports this
iter cleared the file content; only coverage-debt blocks are missing).

## HIGH — stale module docstrings in CechBridge.lean (needs a prover; review cannot edit .lean)
lean-auditor flagged 2 major stale-docstring issues, both in `CechBridge.lean`:
- module header still lists `ses_cech_h1` as **"(planned)"** — it is now proved (lines 655–822);
- module header still describes `injective_cech_acyclic` as **"gated on Lane-1"** — the gate is now
  lifted.
Queue a one-line prover/refactor docstring fix when CechBridge is next opened (e.g. alongside the
`injective_cech_acyclic` dispatch). Not blocking, but it will mislead the next planner if left.

## MEDIUM — blueprint coverage debt (32 unmatched `lean_aux` nodes)
`archon dag-query unmatched` = 32 nodes (accumulated iters 022–024). The review agent does NOT
author prose; the planner should bundle each name into a related decl's `\lean{...}` list (private
does NOT exempt from `unmatched`). Both lvb reports independently flagged this as **major**. Group
them:

**A. ses_cech_h1 cluster → append to `lem:ses_cech_h1`'s `\lean{...}` (CechBridge):**
`restr_trans`, `restr_inj_of_eq`, `restr_op_unique`, `restr_g'_transport`,
`fι_sectionCechFaceRestr`, `coverConst_iInf`, `coverPair_iInf`, `pair_comp_δ0`, `pair_comp_δ1`.

**B. Čech-H¹ heart (CechBridge) — substantive public theorems, give their own blueprint blocks
(or fold into `lem:ses_cech_h1`):**
`sectionCech_objD_exact_of_isZero_homology`, `sectionCech_one_coboundary_of_isZero_homology`.

**C. Engine-augmentation cluster (FreePresheafComplex) — add a new
`lem:cech_engine_aug_quasiIso` block (lvb/freepresheaf's recommendation) covering:**
`cechEngineComplexAug_quasiIso`, `cechEngineComplexAug`, `cechEngineComplexAug_f_zero`,
`cechEngineComplex_exactAt`, `cechEngineAug0`, `cechEngineAug0_split`, `cechEngineAug0_ι`,
`cechEngineD_comp_aug`, `coverStructurePresheafEval_iso`, `cechFreeAug_eval_eq`,
`epi_cechEngineAug0`, `cechFreeEvalEngineIso_hom_f`, `coverStructurePresheafEval_iso_hom`.

**D. Free-eval engine-iso helpers (FreePresheafComplex, from iters 022–023) → fold into
`lem:cech_free_eval_engine_iso` / `lem:cech_engine_complex`:**
`cechFreeEvalEngine_X_inv_hom_ι`, `cechFreeEvalEngine_comm`, `cechFreeEvalEngine_map_ι`,
`cechFreeEval_X_ι_inv`, `cechFree_d_ι`, `freeYonedaAug_app_comp`,
`freeYonedaEval_iso_of_le_hom_eq_aug`, `freeYonedaEval_iso_of_le_natural`.

## MEDIUM — three lemmas missing `\leanok` despite complete Lean (sync_leanok investigation)
lvb/CechBridge noted `lem:cech_complex_hom_identification`, `lem:cech_complex_op_identification`,
`lem:hom_into_injective_exact` lack `\leanok` though their Lean is complete — a likely `sync_leanok`
artifact from a `private` helper bundled in their `\lean{...}` list (sync requires every bundled
name to resolve + be sorry-free). `\leanok` is sync-owned (not review-editable); the planner should
check whether a bundled private name is mismatched/renamed and fix the `\lean{...}` list so sync
can mark them.

## LOW — cleanups (next time FreePresheafComplex is opened)
- Orphaned planner-strategy block at lines 44–100 (lean-auditor minor).
- Dead `FreeCechEngine.*` exports (`combDifferential`, `combHomotopy_spec`, `combDifferential_exact`,
  …): internally correct but unused outside the namespace (only `combSign_flip` and
  `cons_comp_succAbove_succ` are called). Consider pruning or `private`-ing.
- `ses_cech_h1` `set_option maxHeartbeats 1600000`: legitimately large proof, but a profiling/golf
  pass could lower it (lean-auditor minor).

## Do NOT re-assign (intentional / frozen)
- `CechAcyclic.lean:110` `affine` — superseded relative-form, blueprint-authorized `% NOTE`. The
  live result is the section-form `sectionCech_affine_vanishing` (closed iter-022).
- `CechHigherDirectImage.lean:679` — frozen P5b; re-enable only after the 01EO/02KG chain lands.

## Reusable proof patterns discovered (also in PROJECT_STATUS Knowledge Base)
- **Route-B quasi-iso transfer** (no Homotopy repackaging): `quasiIso_of_arrow_mk_iso` along an
  `Arrow.isoMk'` whose comm-square reduces via `ChainComplex.toSingle₀Equiv.injective` + `Subtype.ext`
  to a single degree-0 identity. The contracting-homotopy content lives in the engine's degree-0
  `descOpcycles` inverse (`ShortComplex.quasiIso_iff_isIso_descOpcycles` + an explicit splitting).
- **`erw` for defeq-carrier / functor-coercion mismatches**: ShortComplex/`single`/evaluation-functor
  `map_comp` rewrites routinely fail under `rw`; `erw` + `reassoc_of%` + `erw [eqToHom_refl]` (to
  collapse `singleObjXSelf`) is the reliable path.
- **LSP staleness**: trust only `lake env lean <file>` / `lean_run_code` mid-session; file-level LSP
  diagnostics can report stale "no errors" after edits.
- **Heterogeneous tuple-index transport** (`![i,j]∘δ` vs `fun _=>·`): `subst` the tuple equality as a
  hypothesis (variables ⇒ no motive-not-type-correct), then `restr_op_unique`.
