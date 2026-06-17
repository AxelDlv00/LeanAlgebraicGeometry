# Session 40 — Iter-031 Phase A Step 6 *Path 2* / Cover-totality Source-Object Identification

## Metadata

- **Archon iteration**: 031 (canonical, per dispatcher invocation header).
- **Session number**: 40 (prover-round counter; counts prover rounds independent of the iteration counter).
- **Stage**: prover (refactor + prover sub-phase collapse — fourteenth consecutive substantive occurrence).
- **Sorry count before this session**: 9 (5 `Jacobian.lean` + 3 `AbelJacobi.lean` + 1 `Picard/Functor.lean`).
- **Sorry count after this session**: 9 (no transient — body is a probe-confirmed term-mode one-liner; no scaffold `sorry` was ever introduced).
- **Targets attempted (proof obligations)**: 1 — one `noncomputable def` carrying the natural iso `(presheafToSheaf J _).obj ((yoneda ⋙ whiskeringRight … (ModuleCat.free k)).obj T) ≅ (constantSheaf J _).obj (ModuleCat.of k k)` for terminal `T`.
- **Edits made by the prover**: 1 (single Edit appending a new `section CoverTotality` between `end AffineCoverMVSquare` and `end AlgebraicGeometry.Scheme`).
- **New `axiom` declarations**: 0. The new declaration carries kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`).
- **Files edited**: 1 — `AlgebraicJacobian/Cohomology/MayerVietoris.lean` (677 → 720 LOC, +43 LOC for the new declaration plus its multi-line docstring; +18 over the dispatcher's +25 estimate, attributable entirely to the explanatory docstring describing the three-piece composition).
- **`archon-protected.yaml`**: untouched (no protected declarations live in `Cohomology/MayerVietoris.lean`).

## Context

Iter-031 is the fourth concrete step of the multi-iteration **Serre-finiteness chain** (Phase A step 6 *Path 2*) that `smoothOfRelativeDimension_genus` (`Jacobian.lean`) will eventually consume. Iter-028 landed the bundled `Scheme.AffineCoverMVSquare` structure and accessor; iter-029 added six companion declarations (four `@[simp]` corner-identification lemmas plus the sheaf-parameterised LES specialisation `HModule'_sequence` and its exactness lemma `HModule'_sequence_exact`); iter-030 landed the curve-specific `toModuleKSheaf` specialisation (Step 2.5); iter-031 (this session) lands the **source-object half of Step 3** — the cover-totality identification at the sheaf level.

The plan-agent's pre-prover `lean_run_code` probe had verified end-to-end that the body — composing `Functor.isoWhiskerRight ⟨yoneda(T) ≅ const PUnit⟩ (ModuleCat.free k) ≪≫ Functor.constComp _ PUnit (ModuleCat.free k) ≪≫ (Functor.const Cᵒᵖ).mapIso (Finsupp.LinearEquiv.finsuppUnique k k PUnit).toModuleIso` under `(presheafToSheaf J _).mapIso` — typechecks against the post-iter-030 file with `{success: true, diagnostics: []}`. The prover landed the probe-confirmed body in a single Edit — no fallback, no corrective Edit.

Iter-031 plan-agent decomposition decision recap (per the iter-031 plan-agent re-probe documented in the blueprint chapter L807–815): rather than tackle the full `LinearEquiv` on cohomology (which conflates source-iso construction, Ext-transport, and universe handling), iter-031 closes *only* the source-object iso at the sheaf level. Three obstructions surfaced on re-probe: (1) universe mismatch between `HModule k F n : Type (u+1)` and `HModule' k F n X : Type u`; (2) Mathlib's analog is an explicit TODO in `Mathlib/CategoryTheory/Sites/SheafCohomology/Basic.lean` lines 31–34; (3) the proof body is multi-step. The Ext-transport step plus universe handling are deferred to iter-032+.

## Target 1: `Scheme.HModule'_top_sourceIso` (`noncomputable def`)

### Approach

Term-mode body composed of three Mathlib pieces under `(presheafToSheaf J _).mapIso`:

1. terminal-collapse `yoneda.obj T ≅ (Functor.const Cᵒᵖ).obj PUnit` via `NatIso.ofComponents` + `Equiv.toIso` + `IsTerminal.from`/`IsTerminal.hom_ext`,
2. `Functor.constComp _ PUnit.{u+1} (ModuleCat.free k)` (whisker right + collapse),
3. `(Functor.const Cᵒᵖ).mapIso (Finsupp.LinearEquiv.finsuppUnique k k PUnit).toModuleIso`.

```lean
noncomputable def HModule'_top_sourceIso
    (k : Type u) [Field k]
    {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C}
    [HasWeakSheafify J (Type u)] [HasSheafify J (ModuleCat.{u} k)]
    {T : C} (hT : IsTerminal T) :
    (presheafToSheaf J _).obj
        ((yoneda ⋙ (Functor.whiskeringRight _ _ _).obj (ModuleCat.free k)).obj T)
      ≅ (constantSheaf J (ModuleCat.{u} k)).obj (ModuleCat.of k k) :=
  (presheafToSheaf J _).mapIso
    (Functor.isoWhiskerRight
        (NatIso.ofComponents
          (fun _ => Equiv.toIso { toFun := fun _ => PUnit.unit
                                  invFun := fun _ => hT.from _
                                  left_inv := fun _ => hT.hom_ext _ _
                                  right_inv := fun _ => rfl })
          (fun _ => by ext; rfl))
        (ModuleCat.free k) ≪≫
      Functor.constComp _ PUnit.{u+1} (ModuleCat.free k) ≪≫
      (Functor.const Cᵒᵖ).mapIso
        (Finsupp.LinearEquiv.finsuppUnique k k PUnit).toModuleIso)
```

### Result

RESOLVED on first try (Edit 1). `lean_diagnostic_messages` returned `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}` immediately after the Edit. `lean_verify` confirmed kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`) — the `local instance` warning at L179 is pre-existing (iter-009 cohort).

### Key insights

- **`noncomputable` is load-bearing** because `presheafToSheaf` is itself `noncomputable`. (Same propagation pattern as iter-030.)
- **`Functor.isoWhiskerRight` (qualified) is required** — bare `isoWhiskerRight` is not in scope under the project's open declarations.
- **`PUnit.{u+1}` explicit universe annotation** forces the right level for the Yoneda-Type universe, matching `(yoneda ⋙ free k).obj T : Cᵒᵖ ⥤ ModuleCat.{u} k` whose codomain is `ModuleCat.{u} k = ... Type u → ... → ... Type (u+1)` after sheafification.
- **In-namespace short form `HModule'_top_sourceIso`** (rather than fully-qualified or sub-namespaced) avoids the iter-029 sub-namespace shadowing trap and the iter-030 dot-notation requirement — it's a top-level `Scheme.*` declaration that consumes no `Scheme`-typed receiver, so neither the parent-namespace bare-name resolution issue (iter-029) nor the dot-notation pattern (iter-030) applies.
- **The body composition mirrors `constantSheaf J D = Functor.const Cᵒᵖ ⋙ presheafToSheaf J D`** structurally (per `Mathlib/CategoryTheory/Sites/ConstantSheaf.lean` line 65). The composition factors through the presheaf-level iso first, then sheafifies.

## Verification (this session)

1. **`lean_diagnostic_messages` on `Cohomology/MayerVietoris.lean`** (post-Edit 1): `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}`. Zero errors, zero warnings.
2. **`lean_verify AlgebraicGeometry.Scheme.HModule'_top_sourceIso`**: `{axioms: [propext, Classical.choice, Quot.sound], warnings: [{line: 179, pattern: "local instance"}]}` — kernel-only; the `local instance` warning at L179 is pre-existing (iter-009 cohort).
3. **Sorry count** via `sorry_analyzer.py`: `9 total across 3 file(s)` — unchanged. Trajectory `9 → 9 → 9` (no transient scaffold `sorry`s; body is a term-mode one-liner).
4. **No new `axiom` declarations** in `AlgebraicJacobian/`.
5. **Section/namespace integrity**: the new declaration sits inside a fresh `section CoverTotality` (L677 → L718) inside the existing `namespace AlgebraicGeometry.Scheme` (opened L44, closed at the new L720). Boundary moved from L677 → L720 by exactly the +43 LOC append.
6. **Protected file unchanged**: `archon-protected.yaml` not touched — no protected declarations live in this file.
7. **LOC check**: `Cohomology/MayerVietoris.lean` 677 → 720 LOC (+43). Above the dispatcher's +25 estimate, but the delta is entirely the multi-line explanatory docstring (~18 lines documenting the three-piece composition); the body itself is a term-mode one-liner. File still under typical large-file threshold (~750 LOC).

## Pre-processed event data (`attempts_raw.jsonl`)

`current_session/attempts_raw.jsonl` (14 lines): 1 summary header + 13 events. Highlights:

- 2 `Read` events on `Cohomology/MayerVietoris.lean` (orientation passes before the Edit; ts `17:45:33` and `17:45:36`).
- 1 `Bash` `ls .../blueprint/src/chapters/` and 1 `Bash` `wc -l .../Cohomology_MayerVietoris.tex` (843 LOC; verifying the iter-031 chapter section is present).
- 1 `Grep` for `iter-031|sourceIso|CoverTotality|cover-totality` on the chapter file — returned the L805 subsection header and obstruction list.
- **Edit** (log line 21, ts `17:46:20.800Z`) — replaced `end AffineCoverMVSquare\n\nend AlgebraicGeometry.Scheme` with the new section + declaration + namespace closer (~2201 char new text). No fallback, no corrective Edit.
- 1 `ToolSearch` (no result preview) — likely loading `lean_diagnostic_messages` schema.
- `lean_diagnostic_messages` after the Edit (log line 27, ts `17:46:32.554Z`): `{errors: [], warnings: [], error_count: 0, warning_count: 0, clean: true}` — first-try clean.
- 1 `lean_verify` call (log line 30, ts `17:46:51.003Z`): kernel-only axioms confirmed — `axioms: [propext, Classical.choice, Quot.sound], warnings: [{line: 179, pattern: "local instance"}]`.
- 1 `Bash` `wc -l` (log line 33, ts `17:46:55.368Z`): `720 AlgebraicJacobian/Cohomology/MayerVietoris.lean`.
- 1 `Grep` for `sorry` and 1 `Bash` `sorry_analyzer.py` (log lines 35, 37): `9 total across 3 file(s)`.
- 1 `Write` of `task_results/MayerVietoris.lean.md` recording the closure (log line 40, ts `17:47:33.139Z`).

The summary header confirms: `total_events: 13, edits: 1, goal_checks: 0, diagnostic_checks: 1, builds: 0, lemma_searches: 0, files_edited: ["...MayerVietoris.lean"], total_errors: 0, clean_diagnostics: 1`. **Single-Edit closure with no fallback** — fourteenth consecutive substantive occurrence (sessions 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 37, 38, 39, 40).

## Blueprint markers updated

The plan agent had already added the iter-031 § *Cover-totality source-object identification (iter-031)* to `blueprint/src/chapters/Cohomology_MayerVietoris.tex` (L805 onward) with a `\label{def:Scheme_HModule_prime_top_sourceIso}`, a `\lean{AlgebraicGeometry.Scheme.HModule'_top_sourceIso}` macro, a `\uses{def:Scheme_HModule_prime}` cross-reference, and `\leanok` already inside the `\begin{proof}` block (L831). The `\begin{definition}` block (L817–L828) was unmarked. Post-prover-closure, this review agent added:

| Chapter | Block | Marker added | Notes |
|---|---|---|---|
| `Cohomology_MayerVietoris.tex` | `def:Scheme_HModule_prime_top_sourceIso` (statement) | `\leanok` | `noncomputable def`; declaration exists at the named full path, file compiles, kernel-only axioms. |
| `Cohomology_MayerVietoris.tex` | `def:Scheme_HModule_prime_top_sourceIso` (proof block) | (already present) | The plan agent had pre-added `\leanok` on L831 in anticipation of single-Edit closure. Verified valid: term-mode body, no `sorry`, kernel-only axioms. |

Marker delta this session: **+1 statement `\leanok`** (the proof `\leanok` was already present per the plan agent's chapter write). No `\notready` markers exist anywhere. No `\lean{...}` macro renames needed — the prover used the exact name listed (`HModule'_top_sourceIso`).

## Key findings / proof patterns discovered

- **Top-level `Scheme.*` declarations sidestep both the iter-029 and iter-030 namespace traps.** *(Added iter-031.)* The iter-029 trap (sub-namespace bare-name shadowing → use `_root_.X.Y.Z`) and the iter-030 fix (sub-namespace method call → use dot-notation `S.foo`) both arise inside *sub-namespaced* declarations like `def AffineCoverMVSquare.foo`. A top-level `def Scheme.foo` consuming no `Scheme`-typed receiver — like `HModule'_top_sourceIso`, parameterised by `(k : Type u) {C : Type v} [Category.{u, v} C] {J : GrothendieckTopology C} {T : C} (hT : IsTerminal T)` — has neither problem because the body resolves names against the parent namespace by default and there is no receiver-type-driven dispatch to interfere. Three cases now well-documented:
  - sub-namespaced declaration body invokes parent-namespace declaration whose short name collides → `_root_.X.Y.Z` (iter-029).
  - sub-namespaced declaration body invokes sub-namespace method on its expected receiver type → `S.foo` dot-notation (iter-030).
  - top-level parent-namespace declaration body → no qualification needed (iter-031, this session).
- **Multi-piece sheafification iso construction pattern**: assemble three small Mathlib pieces — `NatIso.ofComponents` for terminal-collapse, `Functor.constComp` for whiskering collapse, `(Functor.const Cᵒᵖ).mapIso` for `LinearEquiv.toModuleIso` lift — at the presheaf level, then apply `(presheafToSheaf J _).mapIso` once to land at the sheaf level. The `≪≫` chain pattern is reusable for any "factor through presheaves, then sheafify" construction. *(Added iter-031.)*
- **`Functor.constComp _ PUnit.{u+1} (ModuleCat.free k)` requires explicit `PUnit` universe annotation** to align with `(yoneda ⋙ free k).obj T` typing. The Mathlib API does not synthesize the universe automatically when the surrounding context has multiple `Type _` slots. *(Added iter-031.)*
- **`Finsupp.LinearEquiv.finsuppUnique k k PUnit` lifts to a `ModuleCat`-iso via `.toModuleIso`** — this is the canonical "single-element-index free module ≃ ground field" iso. Reusable whenever a Yoneda-at-terminal collapse meets `ModuleCat.free k`. *(Added iter-031.)*
- **Probe-vs-prover semantic alignment is now ~100% on the iter-031 surface** — confirmed by single-Edit closure with no corrective edits. Fourteenth consecutive substantive single-Edit closure (sessions 25, 26, 27, 28, 29, 30, 31, 32, 34, 35, 37, 38, 39, 40). The iter-031 body uses neither dot-notation nor `_root_.`-qualified names, so the probe-vs-prover surface is congruent by default (no namespace-resolution divergence is even possible).
- **Probe-confirmed term-mode bodies adopted verbatim continue to land at ~100% reliability** at both the semantic and syntactic level. The iter-031 close cost +18 LOC over estimate, but every additional line is docstring narrative, not body code.
- **Plan-agent pre-marking of `\leanok` inside `\begin{proof}` is acceptable when the body is probe-confirmed end-to-end** — it pre-stages the marker so the review agent only adds the statement-block marker post-closure. Cleaner than two-step marker addition. *(Added iter-031.)*

## Recommendations for next session

See `recommendations.md` (sibling file in this folder) for the full iter-032 plan-agent guidance. Briefly:

- **Track 1 (primary, iter-032 prover lane)**: build the **Ext-transport step** consuming `HModule'_top_sourceIso` — turn the source-object iso into a `LinearEquiv` `HModule' k F n T ≃ₗ[k] HModule k F n` for terminal `T`. The universe handling (`HModule k F n : Type (u+1)` vs `HModule' k F n X : Type u`) is the principal new technical obstruction; expect a `ULift` or `LinearEquiv.ulift` insertion at the type level. Plausibly single-iteration if Mathlib's `Abelian.Ext.linearEquivOfIso` or similar applies; possibly multi-iteration if a fresh universe-lift LinearEquiv API needs to be assembled.
- **Track 1 alternative (heavier)**: **the affine-vanishing input** `Scheme.HModule'_zero_of_isAffineOpen`: `H^{>0}(Spec A, F) = 0`. Mathlib state on this should be re-probed at iter-032 plan-agent time (Serre-vanishing-on-affines is a substantial Mathlib deliverable; status unknown).
- **Track 2 (parallel low-coupling)**: still none recommended. Polish backlog remains empty.
- **Hard avoid**: `representable`, the 8 remaining protected sorries, direct `LineBundle` refinement, and any of the closed scaffold sites (iter-014 → iter-026 + iter-028 + iter-029 + iter-030 + iter-031).
- **Mathlib gating watch**: re-probe affine-vanishing API state at iter-032 plan-agent time. Re-probe Čech-vs-derived-functor comparison API.
- **Pre-specify `_root_.` qualification or dot-notation or top-level form** in any iter-032 directive that defines a new declaration; the iter-029 / iter-030 / iter-031 trichotomy is now well-documented.

## Session-40 task_results status

- `.archon/task_results/MayerVietoris.lean.md`: complete (prover task result, ~52 lines).
- The iter-032 plan agent should:
  1. Migrate the iter-031 cohort entry to `task_done.md` (one new entry: `Scheme.HModule'_top_sourceIso`).
  2. Update `task_pending.md` to remove iter-031 candidates and queue the iter-032+ next-step candidates (Ext-transport `LinearEquiv` with universe handling, affine vanishing, finite-dimensional `H^0`).
  3. Update PROGRESS.md / STRATEGY.md narrative labels: Step 3-source (cover-totality source-object iso) is now complete; Step 3-rest (Ext-transport `LinearEquiv` with universe lift), Step 4 (affine vanishing), Step 5 (finite-dimensional `H^0`) remain.
  4. Append `AlgebraicGeometry.Scheme.HModule'_top_sourceIso` to `blueprint/lean_decls`.
  5. Re-probe Mathlib for affine-vanishing, Čech-vs-derived-functor, and universe-lift LinearEquiv APIs.

## Process drift status

- **Refactor + prover sub-phase collapse**: fourteenth consecutive substantive occurrence (iter-015 → iter-022, iter-023, iter-026, iter-028, iter-029, iter-030, iter-031).
- **Iteration-counter desync**: still resolved (drift counter 0; in sync).
- **`attempts_raw.jsonl` freshness**: this iteration refreshed it (13 events, all timestamped `2026-05-08T17:45…17:47Z`). No stale-data carryover.
- **`archon-protected.yaml` discipline**: this session's plan-agent invocation re-probed the file before assigning the prover objective and confirmed the iter-031 target sits entirely outside the protected list.
- **Probe-vs-prover alignment**: this iteration confirms the iter-029/iter-030 lessons by avoiding both — the iter-031 body uses neither dot-notation nor `_root_.`-qualified names because it is a top-level `Scheme.*` declaration. Probe correctness rate at ~100% under this discipline.
