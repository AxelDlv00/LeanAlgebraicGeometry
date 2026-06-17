# Lean Audit Report

## Slug
iter024

## Iteration
024

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/CechBridge.lean`

- **outdated comments**: 4 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

**notes**:
- Line 59: Module docstring still lists `ses_cech_h1` as `(planned)` — but `ses_cech_h1` is fully proved in this very file (lines 655–822). Actively misleads a reader about the file's state.
- Lines 54, 56: Module docstring describes `injective_cech_acyclic` as "gated on Lane-1 `cechFreeComplex_quasiIso`". Lane-1 is now closed (`cechFreeComplex_quasiIso` proved in `FreePresheafComplex.lean`). The gate is lifted; the description is stale.
- Lines 73–116: Orphaned "Planner strategy" open-comment block (`/- … -/`) for `cechComplex_hom_identification`. That declaration is proved at line 263. The strategy block was useful scaffolding but is now historical debris.
- Lines 270–271, 331, 353, 413: Inline docstring references inside proved declarations still use future-tense phrasing ("once Lane 1 provides …", "once Lane 1 lands"). Now that Lane-1 is closed these are mild anachronisms; not misleading about correctness, just stale.

**Correctness of `ses_cech_h1` (lines 655–822)**:
- Statement is genuine: takes `fι`, `gπ`, sheaf conditions, exactness assumptions, `hH1 : IsZero (sectionCechComplex U F).homology 1`, local lifts `sLoc`, and concludes global surjectivity. No weakening detected.
- Proof: follows the standard sheaf-cohomology descent argument (build G-difference 1-cocycle → lift to F-cocycle → coboundary extraction via `sectionCech_one_coboundary_of_isZero_homology` → corrected sections → glue → separatedness of H). Every step is justified by a named lemma.
- `classical` usage (line 672): appropriate for a non-constructive surjectivity statement.
- No `sorry`. Axiom check returned `[]` (no custom axioms; may be a stale LSP cache, but both earlier session memories and direct source inspection confirm no sorry/axiom shim).

**`set_option maxHeartbeats 1600000` on `ses_cech_h1` (line 634)**:
- 4× the default (400,000). The proof body is ~150 lines and contains multiple `erw`/`ConcreteCategory.comp_apply`/`G.presheaf.map_comp` rewrites, each of which can be expensive in concrete-category mode. No single obviously pathological tactic was identified by visual inspection. Assessed as legitimately large rather than masking a structural issue. Worth profiling (lean_profile_proof) in a later pass to find any hotspot.

**Private helpers (lines 170–630)**: All checked. Each is a genuine mathematical lemma used in the proof of the surrounding declaration. No no-op wrappers. Noteworthy:
- `pi_mapIso_hom_eq` (line 171) — body `:= rfl`; the comment "by definition" is accurate.
- `homCechCosimplicial_δ` (line 286) — body `:= rfl`; comment "holds definitionally" is accurate.
- `restr_op_unique` (line 575) — uses `Quiver.Hom.unop_inj (Subsingleton.elim _ _)` to discharge a poset-uniqueness goal; correct.
- `restr_g'_transport` (line 586) — uses `subst` for a propositional-but-not-definitional tuple equality; correct technique.

---

### `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none

**notes**:
- Lines 44–100: Orphaned "Planner strategy" open-comment block (`/- … -/`) for `cechFreePresheafComplex` and `cechFreeComplex_quasiIso`. Both are proved; the block contains DEAD END warnings and build-path recommendations that are now historical. Not an excuse-comment (doesn't claim the current code is wrong), but stale internal scaffolding.
- Lines 74, 98 (within the above): "DEAD END — do NOT hand-roll…" and "DEAD END — do NOT route through…" — these warn against approaches that were NOT taken. Accurate as written, but stale since the decision is already reflected in the code.
- Lines 810–812, 846, 893–894, 916, 942 (docstrings of engine lemmas): reference `FreeCechEngine.*` names in forward-describing prose ("port of `FreeCechEngine.combDifferential`", etc.). Accurate.

**Correctness of `cechFreeComplex_quasiIso` (lines 1439–1448)**:
- Statement: `QuasiIso (cechFreeComplexAug 𝒰)`. No weakening. Augmentation of the free Čech complex to the cover structure presheaf concentrated in degree 0.
- Proof: `quasiIso_of_evaluation` reduces to a per-open-V check; `by_cases` splits into empty (`cechFreeEval_quasiIso_of_isEmpty`) and nonempty (`cechFreeEval_quasiIso_of_nonempty`). Each case is independently proved.
- Axiom check: `["propext","Classical.choice","Quot.sound"]` — the standard Lean 4 + classical math axioms. No custom `axiom` declarations.
- No `sorry`. No shims.

**`cechFreeEvalEngineIso` (lines 1150–1160)**: The previously identified "sole remaining blocker" (the differential comm-square) is resolved. `cechFreeEvalEngine_comm` (line 1108) discharges the comm-square by `cancel_epi`, sigma-ext, and a case split on `V ≤ coverInterOpen 𝒰 σ`. Proof is genuine.

**`FreeCechEngine` namespace (lines 451–558)**:
- `combSign_flip` (line 506): used at line 866 in `cechEngineD_comp`. Genuine.
- `cons_comp_succAbove_succ` (line 472): used at line 938 in `cechEnginePrepend_spec`. Genuine.
- `combDifferential` / `combHomotopy` / `combHomotopy_zero` / `combHomotopy_spec` / `combDifferential_eq_of_cocycle` / `combDifferential_comp` / `combDifferential_exact` (lines 458–557): internally self-consistent chain; `combDifferential_comp` is called by `combDifferential_exact` but **no proof tactic outside `FreeCechEngine` calls these**. The engine complex proofs (`cechEngineD_comp`, `cechEngineD_exact`, `cechEnginePrepend_spec`) redo the same combinatorial computations directly via `combSign_flip` and `cons_comp_succAbove_succ`. These seven declarations are dead exports from the proof-use perspective.

**Private helpers (selected)**:
- `sigma_ι_eqToHom_transport` (line 148) — body `subst e; simp`. Genuine.
- `cechFreeEvalEngine_comm` (line 1108) — the key differential comm-square; body is ~25 lines with `cancel_epi`, sigma-ext, two cases; genuine.
- `cechFreeAug_eval_eq` (line 1326) — augmentation identification; genuine.
- `coverStructurePresheafEval_iso_hom` (line 1392) — body `:= rfl`. Docstring says "Degree-`0` component of `coverStructurePresheafEval_iso`: the evaluated image inclusion." That is exactly what `rfl` asserts (definitional equality). Genuine.

---

## Must-fix-this-iter

None. No `sorry`, no custom `axiom`, no weakened statements, no excuse-comments on any declaration.

---

## Major

- `CechBridge.lean:59` — Module docstring bullet `"- \`ses_cech_h1\` (planned): ..."` is stale: `ses_cech_h1` is **proved in this file** (lines 655–822). A reader skimming declarations will incorrectly believe this theorem is unformalized.

- `CechBridge.lean:54` — Module docstring describes `injective_cech_acyclic` as "gated on Lane-1 `cechFreeComplex_quasiIso`". Lane-1 is closed: `cechFreeComplex_quasiIso` is proved (axiom-clean) in `FreePresheafComplex.lean`. The stated gate is lifted; the description no longer reflects the project state.

---

## Minor

- `CechBridge.lean:73–116` — Orphaned "Planner strategy" block for `cechComplex_hom_identification` (proved at line 263). Strategic planning debris; does not misrepresent correctness but adds 44 lines of noise.

- `CechBridge.lean:634` — `set_option maxHeartbeats 1600000` on `ses_cech_h1`. 4× the default. Assessed as plausibly legitimate for a ~150-line concrete-category sheaf-gluing proof, but no profiling has been done. Recommend `lean_profile_proof` to identify hotspots before accepting the budget.

- `CechBridge.lean:270,331,353,413` — Inline docstrings for proved declarations still use future-tense phrasing ("once Lane 1 lands / provides …"). Now anachronistic but do not misrepresent the proofs.

- `FreePresheafComplex.lean:44–100` — Orphaned "Planner strategy" block with DEAD END warnings. Historical, accurate about choices made, but now stale scaffolding in a completed file.

- `FreePresheafComplex.lean:458–557` — `FreeCechEngine.combDifferential`, `combHomotopy`, `combHomotopy_zero`, `combHomotopy_spec`, `combDifferential_eq_of_cocycle`, `combDifferential_comp`, `combDifferential_exact` are dead exports: no proof tactic outside the `FreeCechEngine` namespace calls them. `combSign_flip` and `cons_comp_succAbove_succ` ARE used (lines 866, 938). The unused seven are mathematically correct and well-stated, but they add ~100 lines of code that are unreachable from current downstream proofs.

---

## Excuse-comments (always called out separately)

None found. No declaration in either file carries a comment admitting its body or definition is wrong.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 5
- **excuse-comments**: 0

**Overall verdict**: Both files are mathematically clean — `ses_cech_h1` and `cechFreeComplex_quasiIso` are genuine, complete, axiom-clean proofs with no sorry or weakening. The two major findings are pure documentation staleness: the module docstring in `CechBridge.lean` still describes `ses_cech_h1` as unbuilt and `injective_cech_acyclic` as blocked on a gate that is now lifted. These should be corrected in the next plan or review pass to keep the docstring accurate for future readers.
