# Lean Audit Report

## Slug
ts222

## Iteration
222

## Scope
- files audited: 1 (directive-scoped to one file)
- files skipped per directive: 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged (fragile `rfl`)
- **excuse-comments**: 0 flagged (borderline phrasing noted under Minor)
- **notes**:
  - **L37–47 (file header `## Status (current)`)**: Lists three sorry residuals — `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`, `isLocallyInjective_whiskerLeft_of_W` — and says "the dual block (`InternalHom.internalHom`, `dual`, `evalLin`/`internalHomEvalApp`) is built axiom-clean toward closing them." The file now contains a **fourth** sorry: `internalHomEval` (L1449–1455), added this iter. The header was not updated to reflect it, leaving the sorry count at 3 when the actual count is 4. This actively misleads any reader using the header to triage the project state.
  - **L1434–1437 (`restr_map_homMk`, `rfl` proof)**: The proof is `rfl`, relying on kernel-level `whnf` defeq between `(restr X.unop N).map (Over.homMk f.unop).op` and `N.map f` (unfolding `restr` as `pushforward₀ (Over.forget X.unop)` and then `Over.forget`'s action on `Over.homMk`). The docstring correctly calls this a "heavy `whnf` defeq" and explains the isolation motive (budget). The `rfl` is correct at the current Lean/Mathlib pin but is fragile: any change to `pushforward₀`'s definitional unfolding or `Over.forget`'s map computation would silently break it. The `private` designation limits blast radius but also prevents upstreaming a more robust form. The lemma is one-of-a-kind rather than generalisable — its sole purpose is to isolate this particular defeq — which is acceptable, but the fragility should be noted.
  - **L1439–1455 (`internalHomEval`)**: The sorry at L1455 (naturality field) is **honestly flagged** in the docstring. The docstring explicitly states: "the naturality field is held as a typed `sorry`" and "The complete worked proof and three concrete whnf-free fixes (generalize the unit; use `pushforward_obj_map_apply'`; close elementwise) are recorded in `task_results`." This is correct behaviour — the proof has been moved to task_results, not buried in a source comment. The sorry is not laundered; the docstring correctly explains the technical obstacle (whnf heartbeat bomb at `maxHeartbeats 3200000`).
  - **No large in-source `WORKED-OUT NATURALITY PROOF` block**: The directive asked whether such a block exists in source. Answer: it does **not**. The `internalHomEval` docstring references task_results for the worked proof, and a full scan of all `/- ... -/` block comment spans finds nothing resembling a multi-screen proof attempt in source. The worked proof has been correctly placed in task_results. No finding.
  - **No `set_option maxHeartbeats` in source**: Zero occurrences of `set_option maxHeartbeats` in the file code. The value `3200000` appears only inside a `/-- ... -/` docstring comment (L1445) as descriptive context for why the sorry exists. No stray or large heartbeat budgets are active in the compiled file.
  - **Three other sorries** (L634, L1887, L1931): `isLocallyInjective_whiskerLeft_of_W`, `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`. All three carry detailed, technically accurate docstrings explaining the mathematical and infrastructure obstacles. Each is correctly listed in the header's sorry-residual count. No additional action required for these.
  - **`set_option backward.isDefEq.respectTransparency false`**: Used locally on three definitions (L302, L318, L335) to disable the transparency wall for `isDefEq` during the presheaf lax-monoidal assembly. This is a targeted pragmatic option, not a global `maxHeartbeats` raise. Acceptable.

---

## Must-fix-this-iter

*(zero findings)*

No finding reached the must-fix bar. The sorry at `internalHomEval` is not currently consumed by any downstream proof in the file (both `exists_tensorObj_inverse` and `addCommGroup_via_tensorObj` are independent sorry'd stubs); it is therefore not load-bearing in the code-graph sense at this iteration. The header omission is a documentation error, not a wrong definition.

---

## Major

- `TensorObjSubstrate.lean:37–47` — **Header `## Status (current)` misreports sorry count.** Lists exactly three sorry residuals and describes the dual block as "axiom-clean", but `internalHomEval` (L1449, blueprint `lem:internal_hom_eval`) carries a sorry in its naturality field and is not mentioned anywhere in the header. Any reader using the header to gauge the project's sorry count will under-count by one. The header should either list `internalHomEval` under sorry residuals or note it parenthetically beside the "axiom-clean" sentence for the dual block.

- `TensorObjSubstrate.lean:1449–1455` — **`internalHomEval` carries a sorry on a blueprint-pinned declaration.** `internalHomEval` is pinned in the blueprint as `lem:internal_hom_eval` and is the evaluation morphism `ev_M : M ⊗ M^∨ ⟶ R` that the dual/inverse lane will ultimately consume. The sorry is technically justified (whnf heartbeat bomb documented, fix strategy documented in task_results) and honestly flagged. However, the declaration is nominally complete (`noncomputable def` with a body), and the sorry is inside the body rather than a placeholder stub — which means it will typecheck `internalHomEval`'s TYPE but its PROOF is absent. This must be resolved before `exists_tensorObj_inverse` can make progress.

---

## Minor

- `TensorObjSubstrate.lean:1434–1437` — **`restr_map_homMk` `rfl` proof relies on deep `whnf` defeq.** The `private lemma restr_map_homMk` proves its claim by `rfl`, exploiting definitional equality between `(restr X.unop N).map (Over.homMk f.unop).op` and `N.map f`. The docstring honestly labels this a "heavy `whnf` defeq". This is correct at the current Lean/Mathlib pin, but the `rfl` is brittle: a change to `pushforward₀`'s definitional behaviour or `Over.forget`'s map unfolding would silently break it. The isolation motive (run the heavy defeq once in its own heartbeat budget) is sound design. A note that the `rfl` relies on `pushforward₀ (Over.forget U) ▸ M.map` chain would make the fragility explicit. Not urgent as long as the Mathlib pin is stable.

- `TensorObjSubstrate.lean:1446` — **"to keep the build GREEN" phrasing is borderline excuse-comment.** The `internalHomEval` docstring says "the naturality field is held as a typed `sorry` to keep the build GREEN." The surrounding text is technically thorough (names the obstacle, names the fix, points to task_results), so this does NOT rise to a proper excuse-comment. However, the phrase "to keep the build GREEN" without a budget/deadline signal could be read as "this sorry is permanent infrastructure" rather than "this sorry is actively being resolved". A note like "blocked on whnf cost reduction; expected to resolve once `pushforward_obj_map_apply'` is available" would be cleaner.

---

## Excuse-comments (always called out separately)

*(zero proper excuse-comments)*

The phrasing at L1446 ("to keep the build GREEN") is noted under Minor but does not meet the excuse-comment bar: the surrounding docstring provides a full technical explanation, names a concrete path forward, and cites the task_results location of the worked proof. No declaration in the file carries a "TODO: replace with real def" / "placeholder" / "temporary wrong def" comment.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: File is in acceptable condition with honest sorry bookkeeping, but the file-header `## Status` block is stale — it omits `internalHomEval` from the sorry-residual list, leaving the advertised sorry count at 3 while the actual count is 4; this should be corrected before the next iter to prevent misleading plan-phase sorry accounting.
