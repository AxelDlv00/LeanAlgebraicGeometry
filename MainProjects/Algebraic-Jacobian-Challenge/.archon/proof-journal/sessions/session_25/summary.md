# Session 39 — Iter-030 Phase A Step 6 *Path 2* / `toModuleKSheaf` Specialisation on a Curve

## Metadata

- **Archon iteration**: 030 (canonical, per dispatcher invocation header).
- **Session number**: 39 (prover-round counter; counts prover rounds independent of the iteration counter).
- **Stage**: prover (refactor + prover sub-phase collapse — thirteenth consecutive substantive occurrence).
- **Sorry count before this session**: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`).
- **Sorry count after this session**: 9 (no transient — both new declarations have term-mode one-liner bodies, so no scaffold `sorry` was ever introduced).
- **Targets attempted (proof obligations)**: 2 — one `noncomputable def` binding the iter-029 sheaf-parameterised LES to the structure sheaf `toModuleKSheaf C`, and one `lemma` packaging the corresponding exactness companion.
- **Edits made by the prover**: 1 (single Edit appending the two declarations verbatim from the plan-agent's probe-confirmed body block).
- **New `axiom` declarations**: 0. Both new declarations carry kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`).
- **Files edited**: 1 — `AlgebraicJacobian/Cohomology/MayerVietoris.lean` (652 → 677 LOC, +25 LOC for the two new declarations + docstrings; +5 over the +20 estimate due to the explanatory dot-notation docstring on `HModule'_sequence_curve` documenting why dot-notation sidesteps the iter-029 sub-namespace shadowing trap).
- **`archon-protected.yaml`**: untouched (no protected declarations live in `Cohomology/MayerVietoris.lean`).

## Context

Iter-030 is the third concrete step of the multi-iteration **Serre-finiteness chain** (Phase A step 6 *Path 2*) that `smoothOfRelativeDimension_genus` (`Jacobian.lean`) will eventually consume. Iter-028 landed the bundled `Scheme.AffineCoverMVSquare` structure plus its `toMayerVietorisSquare` accessor; iter-029 added six companion declarations (four `@[simp]` corner-identification lemmas plus the sheaf-parameterised LES specialisation `HModule'_sequence` and its exactness lemma `HModule'_sequence_exact`); iter-030 (this session) lands the curve-specific specialisation by binding `F := Scheme.toModuleKSheaf C` to the iter-029 sheaf-parameterised LES.

The plan-agent's pre-prover `lean_run_code` probe verified end-to-end that the two-declaration cohort compiles against the post-iter-029 file with `{success: true, diagnostics: []}`. The prover landed the probe-confirmed body in a single Edit — no fallback, no corrective Edit. The probe-confirmed bodies use **dot-notation method-call form** (`S.HModule'_sequence`, `S.HModule'_sequence_exact`) which sidesteps the iter-029 sub-namespace shadowing trap because the receiver type `S : C.left.AffineCoverMVSquare` makes Lean's dot-notation dispatch resolve `S.HModule'_sequence` directly to `AffineCoverMVSquare.HModule'_sequence` rather than the auto-opened ambient short name.

## Target 1: `AffineCoverMVSquare.HModule'_sequence_curve` (`noncomputable def`)

### Approach

Term-mode body `S.HModule'_sequence k (Scheme.toModuleKSheaf C) n₀ n₁ h`. Bind the iter-029 sheaf-parameterised LES to the structure sheaf `Scheme.toModuleKSheaf C` for `C : Over (Spec (CommRingCat.of k))`.

```lean
noncomputable def AffineCoverMVSquare.HModule'_sequence_curve
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    ComposableArrows AddCommGrpCat 5 :=
  S.HModule'_sequence k (Scheme.toModuleKSheaf C) n₀ n₁ h
```

### Result

RESOLVED on first try (Edit 1). `lean_diagnostic_messages` returned `{success: true, items: [], failed_dependencies: []}` immediately after the Edit. `lean_verify` confirmed kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`).

### Key insight

The dot-notation form `S.HModule'_sequence` resolves cleanly because the receiver type `S : C.left.AffineCoverMVSquare` makes Lean's dot-notation dispatch find the method `AffineCoverMVSquare.HModule'_sequence` directly. The iter-029 sub-namespace shadowing trap that required `_root_.AlgebraicGeometry.Scheme.HModule'_sequence` qualification arose only because the abstract iter-029 declaration's body referenced an *ambient* (parent-namespace) bare name `HModule'_sequence`. In iter-030 we explicitly want the sub-namespace method, so dot-notation is both correct and idiomatic.

## Target 2: `AffineCoverMVSquare.HModule'_sequence_curve_exact` (`lemma`)

### Approach

Term-mode body `S.HModule'_sequence_exact k (Scheme.toModuleKSheaf C) n₀ n₁ h`. Bind the iter-029 abstract exactness lemma to the structure sheaf `Scheme.toModuleKSheaf C`.

```lean
lemma AffineCoverMVSquare.HModule'_sequence_curve_exact
    (k : Type u) [Field k] {C : Over (Spec (CommRingCat.of k))}
    (S : C.left.AffineCoverMVSquare)
    (n₀ n₁ : ℕ) (h : n₀ + 1 = n₁) :
    (S.HModule'_sequence_curve k n₀ n₁ h).Exact :=
  S.HModule'_sequence_exact k (Scheme.toModuleKSheaf C) n₀ n₁ h
```

### Result

RESOLVED on first try (Edit 1). Same Edit as Target 1. `lean_verify` confirmed kernel-only axioms.

### Key insight

The exactness companion is a tightly-coupled mirror of the iter-029 abstract `HModule'_sequence_exact` and consumes the iter-030 def via `S.HModule'_sequence_curve` dot-notation. No new tactic machinery, no new typeclass arguments — pure delegation through dot-notation method calls.

## Verification (this session)

1. **`lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean`** (post-Edit 1): `{success: true, items: [], failed_dependencies: []}`. Zero errors, zero warnings.
2. **`lean_verify AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_curve`**: `{axioms: [propext, Classical.choice, Quot.sound], warnings: [pre-existing "local instance" false-positive at L179]}` — kernel-only.
3. **`lean_verify AlgebraicGeometry.Scheme.AffineCoverMVSquare.HModule'_sequence_curve_exact`**: same kernel-only axioms.
4. **Sorry count** via `sorry_analyzer.py`: `9 total across 3 file(s)` — unchanged. Trajectory `9 → 9 → 9` (no transient scaffold `sorry`s; both bodies are term-mode one-liners).
5. **No new `axiom` declarations** in `AlgebraicJacobian/`.
6. **Section/namespace integrity**: the two new declarations sit inside the existing `section AffineCoverMVSquare` (opened iter-028). The file's `namespace AlgebraicGeometry.Scheme` boundaries (L44 / L677) stand unchanged.
7. **Protected file unchanged**: `archon-protected.yaml` not touched — no protected declarations live in this file.
8. **LOC check**: `Cohomology/MayerVietoris.lean` 652 → 677 LOC (+25). Within +5 of the +20 estimate due to the dot-notation explanatory docstring. Still well under the size threshold (~700 LOC).

## Pre-processed event data (`attempts_raw.jsonl`)

`current_session/attempts_raw.jsonl` (12 events): 1 summary header + 11 events. Highlights:

- 2 `Read` events on `Cohomology/MayerVietoris.lean` (orientation passes before the Edit).
- 1 `Bash` `wc -l` on `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (804 LOC; verifying the iter-030 blocks are present).
- 1 `Grep` for `iter-030|HModule_prime_sequence_curve|toModuleKSheaf specialisation|HModule'_sequence_curve`.
- 1 `ToolSearch` (no result preview).
- **Edit** (log line 24, ts `17:07:45.872Z`) — replaced the iter-029 tail (`_root_.AlgebraicGeometry.Scheme.HModule'_sequence_exact k S.toMayerVietorisSquare F n₀ n₁ h\n\nend AffineCoverMVSquare`) with the iter-029 tail + the two new iter-030 declarations (1436 chars new text). No fallback, no corrective Edit.
- `lean_diagnostic_messages` after the Edit (log line 28): `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}` — first-try clean.
- 2 `lean_verify` calls (log lines 31, 33): kernel-only axioms confirmed for both new declarations.
- 1 `Bash` `wc -l && sorry_analyzer.py` (log line 36): `677 LOC, 9 sorries across 3 file(s)`.
- 1 `Write` of `task_results/MayerVietoris.lean.md` recording the closure (log line 39).

The summary header confirms: `total_events: 11, edits: 1, goal_checks: 0, diagnostic_checks: 1, builds: 0, lemma_searches: 0, files_edited: ["...MayerVietoris.lean"], total_errors: 0, clean_diagnostics: 1`. **Single-Edit closure with no fallback** — the cleanest outcome shape since the iter-028 single-Edit close on the bundled structure.

## Blueprint markers updated

The plan agent had already added the iter-030 § *toModuleKSheaf specialisation on a curve (iter-030)* to `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (L775 onward) with two labels and `\lean{...}` macros for both declarations. Neither had `\leanok` markers when this session began. Post-prover-closure, this review agent added:

| Chapter | Block | Marker added | Notes |
|---|---|---|---|
| `Cohomology_MayerVietoris.tex` | `def:Scheme_AffineCoverMVSquare_HModule_prime_sequence_curve` | `\leanok` (statement) | `noncomputable def`, no proof block to mark; file compiles, kernel-only axioms. |
| `Cohomology_MayerVietoris.tex` | `thm:Scheme_AffineCoverMVSquare_HModule_prime_sequence_curve_exact` | `\leanok` (statement) + `\leanok` (proof) | Term-mode `lemma`, kernel-only axioms. |

Marker delta this session: **+2 statement `\leanok` and +1 proof `\leanok`** (no proof block on the `def`). All other iter-016 → iter-029 markers in the chapter remain unchanged. No `\notready` markers exist anywhere.

## Key findings / proof patterns discovered

- **Dot-notation method-call form (`S.foo`) sidesteps the iter-029 sub-namespace shadowing trap when the receiver type carries the expected method.** *(Added iter-030.)* The iter-029 lesson was that bare in-namespace short names (`foo`) inside the body of a sub-namespaced declaration `def Sub.foo` resolve to the deeper namespace and shadow parent-namespace names. The iter-029 fix was `_root_.X.Y.Z` qualification. The iter-030 lesson is **complementary**: when the body is conceptually invoking a *method* of a sub-namespace structure (i.e. `S.foo` for `S : Sub`), dot-notation makes Lean's elaborator find `Sub.foo` directly without consulting the auto-opened scope, and so works without `_root_` qualification. Two cases to remember:
  - Body wants to invoke a parent-namespace declaration whose short name collides with the current sub-namespace → need `_root_.X.Y.Z` (iter-029).
  - Body wants to invoke a sub-namespace method on a receiver of the sub-namespace's expected type → use `S.foo` dot-notation (iter-030, this session).
- **Probe-vs-prover semantic alignment is now ~100% on the iter-030 surface** — confirmed by single-Edit closure with no corrective edits. The iter-029 corrective Edit (a syntactic disambiguation) was the exception, and the dot-notation form used in iter-030 makes the probe-vs-prover surface fully congruent (the probe runs in a context where `S.HModule'_sequence` resolves the same way as inside the new declaration's body).
- **Two-declaration prover rounds in a single Edit when the cohort is a tightly-coupled `def + lemma` mirror pair on top of an existing abstract specialisation cohort** — added iter-030 (this session). Pattern: an iter-N-1 abstract cohort exposes `Foo` and `Foo_exact`; iter-N binds them by composition with a fixed sheaf flavour as `Foo_curve` and `Foo_curve_exact`. Bodies are term-mode one-liners with dot-notation method calls.
- **Thirteenth consecutive substantive single-Edit closure of probe-confirmed bodies** — sessions 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 37, 38, 39. Iter-029 was a single-Edit semantic close with one corrective syntactic Edit; iter-030 is a single-Edit close with no corrective Edit at all.
- **Probe-confirmed term-mode bodies adopted verbatim continue to land at ~100% reliability** at the semantic content level (and at ~100% syntactic level too when the body uses dot-notation method-call form rather than bare short names).
- **`noncomputable` propagates through structure-sheaf-binding delegations** — the iter-030 `HModule'_sequence_curve` is `noncomputable def` because its body references `Scheme.toModuleKSheaf C` (a sheafification, hence noncomputable). The exactness companion is a `lemma` (proposition-valued, no `noncomputable` needed). *(Added iter-030.)*

## Recommendations for next session

See `recommendations.md` (sibling file in this folder) for the full iter-031 plan-agent guidance. Briefly:

- **Track 1 (primary, iter-031 prover lane)**: build the next downstream consumer — most likely **the cover-totality identification on cohomology** `Scheme.AffineCoverMVSquare.HModule'_apply` (or similar): `HModule' k F n ⊤ ≃ₗ[k] HModule k F n` for each `n`. This is plausibly a single-iteration target, narrow scope, suitable for single-Edit closure. Heavier alternative: **the affine-vanishing input** `Scheme.HModule'_zero_of_isAffineOpen` (or similar): `H^{>0}(Spec A, F) = 0`, possibly multi-iteration depending on Mathlib state.
- **Track 2 (parallel low-coupling)**: still none recommended. Polish backlog remains empty.
- **Hard avoid**: `representable`, the 8 remaining protected sorries, direct `LineBundle` refinement, and any of the closed scaffold sites (iter-014 → iter-026 + iter-028 + iter-029 + iter-030).
- **Mathlib gating watch**: re-probe the Čech-vs-derived-functor comparison API state at iter-031 plan-agent time. Also probe the affine-vanishing API.
- **Pre-specify `_root_.` qualification or dot-notation** in any iter-031 directive that defines a new sub-namespaced declaration; the iter-029 / iter-030 dichotomy is now well-documented.

## Session-39 task_results status

- `.archon/task_results/MayerVietoris.lean.md`: complete (prover task result, ~95 lines).
- The iter-031 plan agent should:
  1. Migrate the iter-030 cohort entries to `task_done.md` (two new entries).
  2. Update `task_pending.md` to remove the iter-030 candidates and queue the iter-031+ next-step candidates (cover-totality identification, affine vanishing, finite-dimensional `H^0`).
  3. Update PROGRESS.md / STRATEGY.md narrative labels: Step 2.5 (toModuleKSheaf specialisation) is now complete; Step 3 (cover-totality identification on cohomology) and Step 4 (affine vanishing) and Step 5 (finite-dimensional `H^0`) remain.
  4. Append the two new declaration names to `blueprint/lean_decls`.
  5. Re-probe Mathlib for affine-vanishing and Čech-vs-derived-functor API state.

## Process drift status

- **Refactor + prover sub-phase collapse**: thirteenth consecutive substantive occurrence (iter-015 → iter-022, iter-023, iter-026, iter-028, iter-029, iter-030).
- **Iteration-counter desync**: still resolved (drift counter 0; in sync).
- **`attempts_raw.jsonl` freshness**: this iteration refreshed it (11 events, all timestamped `2026-05-08T17:06…17:08`Z). No stale-data carryover.
- **`archon-protected.yaml` discipline**: this session's plan-agent invocation re-probed the file before assigning the prover objective and confirmed the iter-030 targets sit entirely outside the protected list.
- **Probe-vs-prover alignment**: this iteration confirms the iter-029 lesson — when the body of a sub-namespaced declaration uses dot-notation method-call form on a receiver of the sub-namespace's expected type, the probe and the prover see identical resolution behaviour. Probe correctness rate for both *semantic* content and *syntactic* short-name resolution is at ~100% under this discipline.
