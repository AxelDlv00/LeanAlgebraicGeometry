# Session 37 — Iter-028 Phase A Step 6 *Path 2* / Serre-Finiteness Scaffolding Kickoff

## Metadata

- **Archon iteration**: 028 (canonical, per dispatcher invocation header).
- **Session number**: 37 (prover-round counter; counts prover rounds independent of the iteration counter).
- **Stage**: prover (single-Edit collapse — refactor + prover sub-phases collapsed; ten consecutive substantive occurrences now eleven).
- **Sorry count before this session**: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`).
- **Sorry count after this session**: 9 (single-Edit landed the body directly; transient 9 → 10 → 9 trajectory avoided).
- **Targets attempted (proof obligations)**: 2 — `Scheme.AffineCoverMVSquare` (structure) and `Scheme.AffineCoverMVSquare.toMayerVietorisSquare` (`noncomputable def`).
- **Edits made by the prover**: 1 (single Edit appending both declarations into the existing `namespace AlgebraicGeometry.Scheme` block, wrapped in a fresh `section AffineCoverMVSquare`).
- **New `axiom` declarations**: 0.
- **Files edited**: 1 — `AlgebraicJacobian/Cohomology/MayerVietoris.lean` (559 → 600 LOC, +41 LOC for the structure + accessor + section markers + docstrings).
- **`archon-protected.yaml`**: untouched (no protected declarations live in `Cohomology/MayerVietoris.lean`).

## Context

Iter-028 is the first concrete step of the multi-iteration **Serre-finiteness chain** that `smoothOfRelativeDimension_genus` (`Jacobian.lean`) will eventually consume. The Path-2 Mayer-Vietoris LES build-out completed at iter-026; iter-027 split the cohort into its own module `Cohomology/MayerVietoris.lean`. Iter-028 begins the **specialisation** of that abstract LES to a concrete 2-affine cover with affine intersection — the geometric input shape Serre-finiteness on a proper `k`-curve consumes.

The plan agent's pre-prover probe re-confirmed (this pass) that Mathlib's Čech-vs-derived-functor comparison API is still gated, so iter-028 took the **Option B** route from the session-36 recommendations: the lighter MV-square specialisation `Scheme.AffineCoverMVSquare`. The plan-agent `lean_run_code` probe verified end-to-end that a clean two-declaration scaffold compiles against the post-iter-027 file with `{success: true, diagnostics: []}` and the four corner-equality `rfl`-smoke checks pass. The prover then landed the probe-confirmed body verbatim in a single Edit.

## Target 1: `Scheme.AffineCoverMVSquare` (structure, new)

### Approach

Verbatim copy of the plan-agent probe-confirmed body block — six fields:

| Field | Type | Role |
|---|---|---|
| `U₁` | `X.Opens` | First affine open of the cover |
| `U₂` | `X.Opens` | Second affine open of the cover |
| `isAffineOpen_U₁` | `IsAffineOpen U₁` | Affineness of `U₁` |
| `isAffineOpen_U₂` | `IsAffineOpen U₂` | Affineness of `U₂` |
| `isAffineOpen_inf` | `IsAffineOpen (U₁ ⊓ U₂)` | Affineness of the pairwise intersection |
| `cover` | `U₁ ⊔ U₂ = ⊤` | Total-cover hypothesis |

Inserted into the existing `namespace AlgebraicGeometry.Scheme` block (already opened at L44 of the file, now closed at L600 post-edit).

### Result

RESOLVED on first try. No proof obligation (pure `structure`). The structure encodes the data Mathlib's abstract `MayerVietorisSquare` does not capture: scheme-flavored affineness conditions plus the cover-totality hypothesis (load-bearing for downstream Serre-finiteness work, where it identifies the `MayerVietorisSquare` corner `X₄` with the whole scheme).

## Target 2: `Scheme.AffineCoverMVSquare.toMayerVietorisSquare` (`noncomputable def`, new)

### Approach

Term-mode body `Opens.mayerVietorisSquare S.U₁ S.U₂` per the plan-agent probe-confirmed instructions. The `noncomputable` modifier is load-bearing because Mathlib's `Opens.mayerVietorisSquare` is itself `noncomputable`. The signature:

```lean
noncomputable def AffineCoverMVSquare.toMayerVietorisSquare {X : Scheme.{u}}
    (S : X.AffineCoverMVSquare) :
    (Opens.grothendieckTopology X.toTopCat).MayerVietorisSquare :=
  Opens.mayerVietorisSquare S.U₁ S.U₂
```

### Result

RESOLVED on first try. Bridge from the geometric input (an `AffineCoverMVSquare`) to the categorical input (a `MayerVietorisSquare` for `Opens.grothendieckTopology X.toTopCat`) the abstract MV-LES theorem `HModule'_sequence_exact` consumes.

## Verification (this session)

1. **`lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean`** (post-Edit): `{success: true, items: [], failed_dependencies: []}`. Zero errors, zero warnings. (Recorded in `attempts_raw.jsonl` log line 29.)
2. **Plan-agent `lean_run_code` probe** (this pass): `{success: true, diagnostics: []}` on the two-declaration scaffold against the post-iter-027 file. (Recorded in `attempts_raw.jsonl` log line 32.)
3. **Four corner `rfl`-equalities probed via `lean_run_code`** (plan-agent pre-prover probe; transcribed from probe output in the prover task result):
   - `S.toMayerVietorisSquare.toSquare.X₁ = S.U₁ ⊓ S.U₂` by `rfl` ✓
   - `S.toMayerVietorisSquare.toSquare.X₂ = S.U₁` by `rfl` ✓
   - `S.toMayerVietorisSquare.toSquare.X₃ = S.U₂` by `rfl` ✓
   - `S.toMayerVietorisSquare.toSquare.X₄ = S.U₁ ⊔ S.U₂` by `rfl` ✓
4. **Sorry count** (post-Edit, project-wide): 9 actual `sorry` tokens (5 `Jacobian.lean` lines 77/88/97/104/114, 3 `AbelJacobi.lean` lines 35/41/53, 1 `Picard/Functor.lean` line 190). The transient `9 → 10 → 9` trajectory was **avoided** because the body was inlined directly (no scaffold `sorry` ever introduced).
5. **No new `axiom` declarations** in `AlgebraicJacobian/`.
6. **Section/namespace integrity**: wrapped the two declarations in a `section AffineCoverMVSquare` … `end AffineCoverMVSquare` block placed before the file-final `end AlgebraicGeometry.Scheme`. The file's `namespace AlgebraicGeometry.Scheme` (L44) and `end AlgebraicGeometry.Scheme` (now L600) both stand unchanged in their roles; the section header is purely organisational and adds no namespacing.
7. **Protected file unchanged**: `archon-protected.yaml` not touched — no protected declarations live in this file.
8. **LOC check**: `Cohomology/MayerVietoris.lean` 559 → 600 LOC (+41); `Cohomology/StructureSheafModuleK.lean` 299 LOC unchanged. No file crossed any size threshold this session.

## Pre-processed event data (`attempts_raw.jsonl`)

`current_session/attempts_raw.jsonl` (12 events): 1 summary header + 11 events. Highlights:
- 3 `Read` events on `Cohomology/MayerVietoris.lean` (orientation pass before Edit).
- 1 `Bash` listing `blueprint/src/chapters/` (confirming the iter-028 chapter target).
- 1 `Bash` `grep` for iter-028 markers in the blueprint chapter (confirming the plan-agent already wrote the iter-028 section).
- 1 `Bash` `grep` of `archon-protected.yaml` (confirming no protected declarations live in the target file).
- 1 `Edit` — single, replacing the file's tail `(seq.zero 1) ≫ end-of-namespace` block with the same one-liner plus the new `section AffineCoverMVSquare … end AffineCoverMVSquare` block. (Old: `... .zero 1\n\nend AlgebraicGeometry.Scheme`. New: `... .zero 1\n\nsection AffineCoverMVSquare\n...\nend AffineCoverMVSquare\n\nend AlgebraicGeometry.Scheme`.)
- 1 `lean_diagnostic_messages` post-Edit returning clean: `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}`.
- 1 `lean_run_code` (re-confirming clean diagnostics): `{success: true, diagnostics: []}`.
- 1 `Bash` `grep -rn "sorry" ...` reporting 9 hits (5 + 3 + 1).
- 1 `Write` of `task_results/MayerVietoris.lean.md` recording the closure.

The summary header confirms: `total_events: 12, edits: 1, goal_checks: 0, diagnostic_checks: 1, builds: 0, lemma_searches: 0, files_edited: ["...MayerVietoris.lean"], total_errors: 0, clean_diagnostics: 1`. No goal-state checks were necessary because both targets are non-proof declarations (a `structure` and a term-mode `noncomputable def`).

## Blueprint markers updated

The plan agent had already added the iter-028 section *§ 2-affine cover Mayer-Vietoris square (iter-028)* to `blueprint/src/chapters/Cohomology_MayerVietoris.tex` with three labels: `def:Scheme_AffineCoverMVSquare`, `def:Scheme_AffineCoverMVSquare_toMayerVietorisSquare`, and `lem:Scheme_AffineCoverMVSquare_corners`. The two definitions had no `\leanok` markers when this session began. Post-prover-closure, this review agent added:

| Chapter | Block | Marker added | Notes |
|---|---|---|---|
| `Cohomology_MayerVietoris.tex` | `def:Scheme_AffineCoverMVSquare` | `\leanok` (statement) | Structure declaration, file compiles, no `sorry`. No proof block to mark. |
| `Cohomology_MayerVietoris.tex` | `def:Scheme_AffineCoverMVSquare_toMayerVietorisSquare` | `\leanok` (statement) | Term-mode `noncomputable def`, file compiles, no `sorry`. No proof block to mark. |
| `Cohomology_MayerVietoris.tex` | `lem:Scheme_AffineCoverMVSquare_corners` | (no marker) | Per the prover's task result: the four `rfl`-equalities are documented but **not formalised as named Lean lemmas**. The blueprint already records this in the parenthetical at L667 ("they are not formalised as named lemmas but are recorded here for downstream consumers' definitional unfolding"). No `\lean{...}` macro on this block, so no `\leanok` is appropriate. |

Marker delta this session: **+2 statement `\leanok`** (no proof-block markers, since both targets are pure definitions). All other iter-016 → iter-026 markers in the chapter remain unchanged. No `\notready` markers exist anywhere (verified: none in `Cohomology_MayerVietoris.tex` or any other chapter, confirmed at iter-027).

## Key findings / proof patterns discovered

- **Bundled-structure pattern for "geometric data the abstract Mathlib categorical structure does not capture"**: a `structure Foo (X : Scheme.{u})` packaging predicates (here: three `IsAffineOpen` proofs + one `⊔ = ⊤` total-cover equation) plus the data fields (here: two `X.Opens`) the abstract `MayerVietorisSquare` does not record. The downstream accessor delegates to the Mathlib constructor and inherits all `rfl`-corner equations. *(Added iter-028.)*
- **`Opens.mayerVietorisSquare U₁ U₂` is the canonical Mathlib idiom** for producing a `(Opens.grothendieckTopology X.toTopCat).MayerVietorisSquare` from two opens; the four corners `X₁/X₂/X₃/X₄ = U₁ ⊓ U₂ / U₁ / U₂ / U₁ ⊔ U₂` are definitionally true (`rfl`-checks). *(Added iter-028.)*
- **`noncomputable` propagates through `Opens.mayerVietorisSquare`-style delegations**. Even though the body is a single function call, the `noncomputable` modifier is load-bearing because Mathlib's source declaration is itself `noncomputable`. *(Re-confirmed iter-028.)*
- **`section <Name>` headers are purely organisational** within an existing `namespace`. They scope local notations / `open` directives but contribute no namespacing. The iter-028 single-Edit added one such section without breaking the surrounding `namespace AlgebraicGeometry.Scheme` boundaries. *(Re-confirmed iter-028.)*
- **Single-Edit closure with probe-confirmed body** continues to be the preferred mode for narrow scaffold work in unprotected territory: **eleventh consecutive substantive occurrence** (sessions 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 37 — iter-027 was a refactor-only round, not counted). The probe-confirmed body landed verbatim with no semantic deviation; the predicted `9 → 10 → 9` transient was avoided because the body was inlined directly.
- **`structure` declarations are inert under sorry-counting** but still register cleanly with `lean_diagnostic_messages`. There is no kernel axiom risk with structure declarations alone (the `propext` / `Classical.choice` / `Quot.sound` floor is not exceeded, and no new `axiom` is introduced). *(Re-confirmed iter-028.)*
- **Plan-agent `lean_run_code` probes are *highly* predictive but not infallible** continues — sessions 5, 6, 12, 13, 14, 15, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 37. Probe correctness rate ~100% for this session's pure-data structure + term-mode delegation pair. The probe verified both diagnostic cleanliness *and* the four corner-equality `rfl`-smoke checks; both predictions held verbatim post-Edit.

## Recommendations for next session

See `recommendations.md` (sibling file in this folder) for the full iter-029 plan-agent guidance. Briefly:

- **Track 1 (primary, iter-029 prover lane)**: build the first downstream consumer of `Scheme.AffineCoverMVSquare` — the simp-companion lemma `Scheme.AffineCoverMVSquare.cover_top` identifying `S.toMayerVietorisSquare.toSquare.X₄` with `⊤` via `S.cover` (or the dual: identifying it with `(S.U₁ : X.Opens) ⊔ S.U₂`). This is the smallest concrete iter-029 target that consumes the iter-028 scaffold and starts threading `S.cover` into the LES instantiation.
- **Track 1 alternative**: pre-stage `Scheme.AffineCoverMVSquare.HModule'_apply` — apply `HModule'_sequence_exact` to `S.toMayerVietorisSquare` and `toModuleKSheaf C` to produce the 5-term LES on a concrete `C.AffineCoverMVSquare`. Heavier but a single self-contained scaffold.
- **Track 2 (parallel low-coupling)**: still none recommended. Polish backlog remains empty.
- **Hard avoid**: `representable`, the 8 remaining protected sorries, direct `LineBundle` refinement, and any of the closed scaffold sites (iter-014 → iter-026 + iter-028).
- **Mathlib gating watch**: re-probe the Čech-vs-derived-functor comparison API at iter-029 plan-agent time. If now ungated, that opens **Option A** (the deeper affine-finiteness primitive) as an alternative to the `cover_top` simp-companion.

## Session-37 task_results status

- `.archon/task_results/MayerVietoris.lean.md`: complete (prover task result, 80 lines).
- The iter-028 plan agent should:
  1. Migrate the iter-028 scaffold entries to `task_done.md` (two new entries: `Scheme.AffineCoverMVSquare` and `Scheme.AffineCoverMVSquare.toMayerVietorisSquare`).
  2. Update `task_pending.md` to remove the iter-028 candidates and queue the iter-029+ next-step candidates (cover_top simp companion, then HModule'_apply, then affine-vanishing input, then `Module.Finite`).
  3. Update PROGRESS.md / STRATEGY.md narrative labels to reflect that the Serre-finiteness chain has commenced.
  4. Optionally append `AlgebraicGeometry.Scheme.AffineCoverMVSquare` and `AlgebraicGeometry.Scheme.AffineCoverMVSquare.toMayerVietorisSquare` to `blueprint/lean_decls` (the auto-curated declaration manifest); these correspond to the new `\lean{...}` macros added to `Cohomology_MayerVietoris.tex`.

## Process drift status

- **Refactor + prover sub-phase collapse**: eleventh consecutive substantive occurrence (iter-015 → iter-022, iter-023, iter-026, iter-028 — iter-027 was a refactor-only round, a different mode). The dispatcher correctly invoked the prover phase for iter-028 because the iteration's content is a substantive scaffold addition (not a pure structural refactor).
- **Iteration-counter desync**: still resolved (drift counter 0; in sync).
- **`attempts_raw.jsonl` freshness**: this iteration refreshed it (12 events, all timestamped `2026-05-08T16:04…16:06`Z), distinct from the iter-027 stale-data behaviour journaled in session 36.
- **`archon-protected.yaml` discipline**: this session's plan-agent invocation re-probed the file before assigning the prover objective and confirmed the iter-028 targets sit entirely outside the protected list. The probe-then-implement pattern (added iter-027) continues to be the canonical pre-prover step for unprotected-territory scaffolds.
