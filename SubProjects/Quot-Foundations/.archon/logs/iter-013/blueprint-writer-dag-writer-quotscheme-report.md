# Blueprint Writer Report

## Slug
dag-writer-quotscheme

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_QuotScheme.tex

## Changes Made

### Rationality machinery (`IsRatHilb` cluster) — new subsection `\subsection{The rationality toolkit ...}` (`\label{subsec:isRatHilb}`), inserted after the `lem:gradedHilbertSerre_rational` proof
- **Added lemma** `\label{lem:coeff_invOneSubPow_one_mul}` / `\lean{AlgebraicGeometry.coeff_invOneSubPow_one_mul}` — multiplication by `(1−X)^{−1}` is the partial-sum operator on coefficient sequences. `\uses{lem:invOneSubPow_mathlib}`. "Proved directly in Lean" note.
- **Added lemma** `\label{lem:rationalHilbert_antidiff}` / `\lean{AlgebraicGeometry.rationalHilbert_antidiff}` — the power-series antidifference lemma: partial-sum series of `q·(1−X)^{−e}` equals `p·(1−X)^{−(e+1)}` up to a polynomial. `\uses{lem:coeff_invOneSubPow_one_mul, lem:invOneSubPow_mathlib}`. Proof sketch added (telescoping + constant absorption).
- **Added definition** `\label{def:ratHilb}` / `\lean{AlgebraicGeometry.IsRatHilb}` — the predicate `IsRatHilb f d`: `f` eventually equals the coefficient sequence of `p·(1−X)^{−d}`. `\uses{lem:invOneSubPow_mathlib}`. Optional `\textit{Source: Stacks 00K1.}` pointer added (predicate only, per directive).
- **Added lemma** `\label{lem:ratHilb_ofEventuallyZero}` / `\lean{...IsRatHilb.ofEventuallyZero}` — base case (eventually-zero ⇒ order 0). `\uses{def:ratHilb}`.
- **Added lemma** `\label{lem:ratHilb_bump}` / `\lean{...IsRatHilb.bump}` — raise pole order by one. `\uses{def:ratHilb, lem:invOneSubPow_mathlib}`.
- **Added lemma** `\label{lem:ratHilb_sub}` / `\lean{...IsRatHilb.sub}` — closure under pointwise difference. `\uses{def:ratHilb}`.
- **Added lemma** `\label{lem:ratHilb_shiftRight}` / `\lean{...IsRatHilb.shiftRight}` — closure under right shift `n↦f(n−1)`. `\uses{def:ratHilb}`.
- **Added lemma** `\label{lem:ratHilb_antidiff}` / `\lean{...IsRatHilb.antidiff}` — predicate-level antidifference step. `\uses{def:ratHilb, lem:rationalHilbert_antidiff}`. Proof sketch added.
- **Added lemma** `\label{lem:ratHilb_ofDiffEq}` / `\lean{...IsRatHilb.ofDiffEq}` — inductive-step engine from the degreewise SES first-difference identity (cokernel `M/xM` minus shifted kernel). `\uses{def:ratHilb, lem:ratHilb_antidiff, lem:ratHilb_sub, lem:ratHilb_shiftRight}`. Proof sketch added.

### Schematic-support helpers (`Scheme.Modules`)
- **Added lemma** `\label{lem:modules_annihilator_ideal_le}` / `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` — `Ann(F)(U) ⊆ Ann_{O(U)}(F(U))` on affine opens (the `ofIdeals` direction). `\uses{def:modules_annihilator}`. "Proved directly in Lean".
- **Added definition** `\label{def:schematic_support_immersion}` / `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` — the closed immersion `schematicSupport F ⟶ X`. `\uses{def:schematic_support, def:modules_annihilator}`. "Proved directly in Lean".

### Wiring of existing blocks (only `\uses{}` edges added, no statements altered)
- **`lem:gradedHilbertSerre_rational`** (statement + proof `\uses`) — added `def:ratHilb, lem:ratHilb_ofEventuallyZero, lem:ratHilb_ofDiffEq, lem:ratHilb_bump` (kept existing `lem:finrank_ses_additive_mathlib, lem:invOneSubPow_mathlib`).
- **`def:schematic_support`** — added `lem:modules_annihilator_ideal_le, def:schematic_support_immersion` (kept `def:modules_annihilator`).
- **`def:has_proper_support`** — added `def:schematic_support_immersion` (kept `def:schematic_support, lem:isProper_mathlib`).

## Cross-references introduced
All `\uses{}` targets resolve (leandag `unknown_uses` = 0). New intra-cluster edges:
- `lem:ratHilb_ofDiffEq` → `lem:ratHilb_antidiff`, `lem:ratHilb_sub`, `lem:ratHilb_shiftRight` (matches Lean proof of `IsRatHilb.ofDiffEq`).
- `lem:ratHilb_antidiff` → `lem:rationalHilbert_antidiff` (matches Lean).
- `lem:rationalHilbert_antidiff` → `lem:coeff_invOneSubPow_one_mul`.
- Mathlib anchors reused via `\uses{}`: `lem:invOneSubPow_mathlib`, `lem:finrank_ses_additive_mathlib` (no re-authoring).

## References consulted
None opened this session for verbatim quotes: all 11 added blocks are project-internal, Archon-original helpers (no external `% SOURCE QUOTE:` required per directive). `references/hilbert-serre.md` confirmed present on disk and cited only as the optional one-line `\textit{Source: Stacks 00K1.}` pointer on `def:ratHilb`; no verbatim quote drawn from it.

## leandag verification (after edits)
- `unknown_uses`: 0
- `unmatched_lean` for this cluster: 0 — all 11 new `\lean{}` names matched their Lean declarations (`AlgebraicGeometry.IsRatHilb`, `.ofEventuallyZero`, `.bump`, `.sub`, `.shiftRight`, `.antidiff`, `.ofDiffEq`, `coeff_invOneSubPow_one_mul`, `rationalHilbert_antidiff`, `Scheme.Modules.annihilator_ideal_le`, `Scheme.Modules.schematicSupportι`).
- `leandag query --isolated --chapter Picard_QuotScheme`: none.
- One project-wide isolated node remains (`lean:AlgebraicGeometry.base_change_mate_inner_value`, a `lean_aux` decl in `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`) — outside this chapter and outside scope.

## Macros needed (if any)
None. Used only `\subsection`, `\texorpdfstring`, `\hookrightarrow`, `\mathrm`, all already in use in the project preamble/chapter.

## Notes for Plan Agent
- The added `IsRatHilb` blocks carry no `\leanok` (per descriptor; `sync_leanok` will set them — the underlying Lean helpers are `private` but axiom-clean per the iter-012 note already in the chapter). The `\lean{}` pins use the fully-qualified names (`AlgebraicGeometry.IsRatHilb...`); leandag matched all of them, so the `private` modifier does not block name resolution.
- `lem:gradedHilbertSerre_rational` is still not a live Lean decl (blocked on the graded-quotient/kernel/regrading Mathlib gap documented in the existing `% NOTE (iter-012)`); the new `\uses{}` edges to the `IsRatHilb` cluster record the intended dependency for when that reduction lands. The cluster itself is fully formalized and now visible in the DAG.

## Strategy-modifying findings
None.
