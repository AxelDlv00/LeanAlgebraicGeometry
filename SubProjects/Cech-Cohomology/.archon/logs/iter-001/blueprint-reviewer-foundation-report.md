# Blueprint Review Report

## Slug
foundation

## Iteration
001

## Top-level summaries

### Incomplete parts

- `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_functor`: the composition law `G(g ∘ h) = G(h) ∘ G(g)` is present in the prose but has NO corresponding Lean declaration — `AlgebraicGeometry.pushPullMap_comp` exists only as a block comment (`/- ... -/`) in the Lean file, not as a `lemma` statement. Until a stub or full declaration exists, the two functor laws cannot be tracked independently and `leandag` cannot gate the composition law separately from the identity law. The prose content is complete; the formalization target is broken.

### Proofs lacking detail

- `Cohomology_CechHigherDirectImage.tex` / `lem:cech_computes_cohomology` (proof): the spectral-sequence argument requires TWO infrastructure items absent from Mathlib for `Scheme.Modules` — the Čech-to-derived-functor spectral sequence and the Leray spectral sequence. The blueprint honestly acknowledges both gaps. However, the cumulative absence means the proof cannot be formalized with any near-term Mathlib state: building both spectral sequences for `Scheme.Modules` is a multi-iteration undertaking. Per the directive's audit note, this is flagged as a Lean-difficulty / completeness finding: an acyclic-resolution / universal δ-functor comparison route (using only `CechAcyclic.affine` + a single `rightDerived`-from-acyclic-resolution lemma) would likely be lighter and may be reachable with existing Mathlib infrastructure. Route-selection is deferred to the strategy auditor.

### Lean difficulty quality

- `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_functor` / `\lean{AlgebraicGeometry.pushPullMap_comp}`: **unmatched `\lean{}` target** (confirmed by `leandag build --json` field `unmatched_lean`). The declaration does not exist in Lean. The prover has no stub to fill, and `leandag` cannot track this law separately from `pushPullMap_id`. This is a hard formalization-target failure for the composition law.

### Dependency & isolation findings

- `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_functor` → `\lean{AlgebraicGeometry.pushPullMap_comp}`: unmatched `\lean{}` (no Lean declaration). **fix** — add `lemma pushPullMap_comp ... := sorry` stub to `CechHigherDirectImage.lean` (minimal), or split `lem:push_pull_functor` into `lem:push_pull_id` and `lem:push_pull_comp` with one `\lean{}` pin each (recommended for independent graph tracking). See focus area below.

**Isolated `lean_aux` nodes** (4 nodes, all `lean_aux` type, no blueprint entries):

| Lean name | Disposition |
|---|---|
| `AlgebraicGeometry.rawPushPullMap` | **keep** — generalised `pushPullMap` with free over-triangle hypothesis; scaffolding for `pushPullMap_comp`; will be consumed once the composition law is closed |
| `AlgebraicGeometry.pushPullMap_eq_raw` | **keep** — proves `pushPullMap = rawPushPullMap` by `rfl`; scaffolding brick for `pushPullMap_comp` |
| `AlgebraicGeometry.pushPull_unit_comp` | **keep** — solves `pushPull_unit_mate` for `η^{f≫p}`; scaffolding for `pushPullMap_comp` |
| `AlgebraicGeometry.pushforwardComp_hom_app_id` | **keep** — proves `pushforwardComp` is strict (`rfl`); scaffolding for `pushPullMap_comp` |

All four are uncovered Lean helpers for the still-open composition law. None is orphaned scaffolding. Once `pushPullMap_comp` is closed (or its stub added), these should each receive a blueprint entry or be subsumed by the composition-law lemma block.

## Per-chapter

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: partial
- **notes**:
  - **[must-fix]** `lem:push_pull_functor` / `\lean{AlgebraicGeometry.pushPullMap_comp}`: unmatched `\lean{}` target — `pushPullMap_comp` does not exist as a Lean declaration (only as a block comment). `leandag` reports this as `unmatched_lean`. As a side effect, the statement block's `\leanok` (placed by `sync_leanok` because `pushPullMap_id` is axiom-clean) over-states the formalization: the composition law has no stub at all.
  - **[must-fix — recommended fix]** Split `lem:push_pull_functor` into two blocks: `lem:push_pull_id` (`\lean{AlgebraicGeometry.pushPullMap_id}`) and `lem:push_pull_comp` (`\lean{AlgebraicGeometry.pushPullMap_comp}`), each with independent `\leanok` tracking. Minimal alternative: add `lemma pushPullMap_comp ... := sorry` stub to the Lean file so the `\lean{}` pin resolves. Note that the `cech_nerve ↔ push_pull_functor` cycle removed in iter-283 is confirmed GONE — the current `\uses` graph is acyclic.
  - **[soon — Lean-difficulty]** `lem:cech_computes_cohomology` proof depends on TWO spectral sequences absent from Mathlib for `Scheme.Modules`. The blueprint sketch is correctly structured (follows Stacks 02KE faithfully), but the proof is practically unformalizeable near-term via this route. An acyclic-resolution / δ-functor comparison route (consuming only `CechAcyclic.affine` + a `rightDerived`-from-acyclic-resolution lemma already in Mathlib's `Abelian` API) is likely a lighter path. Flag for strategy auditor.
  - **[informational]** `lem:push_pull_unit_mate` and `lem:push_pull_transport_cancel` are axiom-clean in Lean (confirmed by reading source) but carry no `\leanok` yet — `sync_leanok` has not run for iter-001. No writer action needed; these will be marked after the first prover round.
  - **[informational]** 4 `lean_aux` scaffolding declarations (`rawPushPullMap`, `pushPullMap_eq_raw`, `pushPull_unit_comp`, `pushforwardComp_hom_app_id`) have no blueprint entries. All are consumed by the pending `pushPullMap_comp` proof. Blueprint entries should be added when the composition law is closed.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

## Severity summary

**must-fix-this-iter** (1 finding — blocks prover dispatch to `CechHigherDirectImage.lean`):
1. `Cohomology_CechHigherDirectImage.tex` / `lem:push_pull_functor` — broken `\lean{AlgebraicGeometry.pushPullMap_comp}` (unmatched_lean per leandag); `correct: partial` on the consolidated chapter gates the whole `CechHigherDirectImage.lean` prover lane. Fix: split the block into `lem:push_pull_id` + `lem:push_pull_comp` (preferred), or add a sorry stub for `pushPullMap_comp` in the Lean file and patch the blueprint `\lean{}` pin.

**soon** (1 finding):
2. `Cohomology_CechHigherDirectImage.tex` / `lem:cech_computes_cohomology` — spectral-sequence proof infrastructure gap (two absent Mathlib items). Acyclic-resolution alternative may be materially lighter. Refer to strategy auditor for route decision before dispatching a prover to close this sorry.

**informational** (2 findings):
3. `lem:push_pull_unit_mate` and `lem:push_pull_transport_cancel` missing `\leanok` — `sync_leanok` artifact (iter-001, pre-prover); no action required.
4. 4 `lean_aux` helpers without blueprint entries — deferred until `pushPullMap_comp` is closed.

**HARD GATE**: `Cohomology_CechHigherDirectImage.lean` prover dispatch is **BLOCKED** (`correct: partial` on the consolidated chapter). `HigherDirectImage.lean` MAY proceed (its chapter is `complete + correct`).

---

Overall verdict: `Cohomology_CechHigherDirectImage.tex` is `correct: partial` due to a broken `\lean{pushPullMap_comp}` target (leandag-confirmed unmatched_lean) that must be resolved before prover dispatch; `Cohomology_HigherDirectImage.tex` is complete + correct; no unstarted phases.
