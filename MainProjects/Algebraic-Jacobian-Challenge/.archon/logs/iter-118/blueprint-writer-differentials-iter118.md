# Blueprint Writer Report

## Slug
differentials-iter118

## Status
COMPLETE

## Target chapter
`blueprint/src/chapters/Differentials.tex`

## Summary
Rewrote the smoothness-criterion content of the chapter to match the
iter-118 correctness fix: the iff form is mathematically false; the
forward direction is the only deliverable. Section 1 (presheaf
definition + section lemma + comparison remark) is preserved
verbatim. The old iff theorem is replaced by a forward-direction
theorem with a verified five-step Mathlib chain. A dedicated new
section discloses the converse-direction-is-false content with an
explicit counterexample, the three hypotheses of the Mathlib
converse lemma, and a Stacks 02G1 cross-reference. The
out-of-autonomous-loop trimmed-content section is preserved
verbatim.

## Changes Made
- **Revised chapter intro paragraph 2** — re-framed the downstream
  role as the *forward direction* of the standard smoothness
  criterion; added forward pointer to the new converse-out-of-scope
  section.
- **Renamed Section 2** to `Smoothness criterion for $\Omega_{X/S}$
  (forward direction)` and rewrote its intro paragraph to match.
- **Replaced** the `thm:smooth_iff_locally_free_omega` theorem
  block with a new forward-direction theorem:
  - new label: `thm:smooth_locally_free_omega` (no `_iff_` infix)
  - new `\lean{...}` hint: `AlgebraicGeometry.Scheme.smooth_locally_free_omega`
  - new statement: forward implication only (drops `LocallyOfFinitePresentation`
    hypothesis, drops `↔`)
  - `\uses{def:relative_kaehler_presheaf, lem:relative_kaehler_presheaf_obj}`
    preserved.
- **Replaced the proof sketch** with a five-step chain referencing
  the verified Mathlib chain from the directive:
  1. `AlgebraicGeometry.smoothOfRelativeDimension_iff`
     (auto-generated `mk_iff` on the `SmoothOfRelativeDimension`
     class; confirmed by `@[mk_iff]` attribute at
     `Mathlib/AlgebraicGeometry/Morphisms/Smooth.lean:134`)
  2. `Algebra.IsStandardSmoothOfRelativeDimension.isStandardSmooth`
     (lemma; `Mathlib/RingTheory/Smooth/StandardSmooth.lean:102`)
  3. `Algebra.IsStandardSmooth.free_kaehlerDifferential`
     (instance; `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`)
  4. `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential`
     (theorem; same file)
  5. project-local `relativeDifferentialsPresheaf_obj_kaehler`
     (Lemma `lem:relative_kaehler_presheaf_obj`).
  Each step includes a `[verified]` annotation, source file
  reference, and explanation of role. The proof also documents the
  `Nontrivial B` side condition required by Step 4 and how it is
  discharged via `x ∈ U`.
- **Added remark** `rem:smooth_class_naming` — notes that the
  Lean class is `SmoothOfRelativeDimension` and that
  `IsSmoothOfRelativeDimension` is the deprecated alias the
  iter-117 file used.
- **Added new section** `Converse direction --- out of autonomous-loop
  scope` (`\label{sec:converse-out-of-scope}`) with three remarks:
  - `rem:converse_counterexample` — the explicit
    `f : Spec k → Spec k[t]`, `t ↦ 0` counterexample, with both
    sides of the (now-broken) equivalence checked.
  - `rem:converse_lemma_hypotheses` — cites
    `Algebra.IsStandardSmooth.of_basis_kaehlerDifferential`
    (`Mathlib/RingTheory/Smooth/StandardSmoothOfFree.lean`),
    documents its three hypotheses (FinitePresentation,
    `Subsingleton (Algebra.H1Cotangent A B)`, basis-in-range-of-D),
    flags `Algebra.H1Cotangent` (verified to exist in Mathlib as an
    `abbrev` at `Mathlib/RingTheory/Extension/Cotangent/Basic.lean`)
    as the missing project-side input.
  - `rem:stacks_02G1` — Stacks Tag 02G1 cross-reference; explains
    that the proved forward direction corresponds to the easy
    direction of the standard biconditional and that the missing
    direction is precisely the flatness conjunct.
- **Preserved** the `\section{Content out of autonomous-loop scope}`
  trimmed-content itemised list (now Section 4) verbatim.

## Lean-side changes implied (NOT made by me)
- The Lean file still names the (sorry-bodied) theorem
  `smooth_iff_locally_free_omega` with an iff signature, and uses
  the deprecated `IsSmoothOfRelativeDimension` alias. After my
  edits the blueprint references `smooth_locally_free_omega` (no
  `_iff_`) and `SmoothOfRelativeDimension` (no `Is`). The refactor
  agent must rename + re-sign the Lean declaration to match. The
  theorem signature is NOT listed in `archon-protected.yaml`, so
  this refactor is allowed.

## Cross-references introduced
- `Section~\ref{sec:converse-out-of-scope}` from chapter intro and
  Section 2 intro — resolves to the new section label.
- `Remark~\ref{rem:converse_counterexample}` from
  `rem:converse_lemma_hypotheses` — same chapter.
- `Remark~\ref{rem:converse_lemma_hypotheses}` from `rem:stacks_02G1`
  — same chapter.
- `Theorem~\ref{thm:smooth_locally_free_omega}` from `rem:stacks_02G1`
  — same chapter.
- `Lemma~\ref{lem:relative_kaehler_presheaf_obj}` from the proof
  body and from the Mathlib-name-summary — same chapter,
  pre-existing label.

## Macros needed (if any)
None new. The chapter uses only macros already defined in
`blueprint/src/macros/common.tex` (`\Spec`, `\struct`, `\rank`,
`\Jac`, etc.).

## Reference-retriever dispatches (if any)
None. All directive-named Mathlib lemmas and the Stacks Tag 02G1
reference were sufficient with already-on-disk material; the
Lean LSP `lean_local_search` + a direct `Grep` against the Mathlib
sources in `.lake/packages/mathlib/` confirmed every `[verified]`
name before I wrote it into the prose.

## Markers
I did not add or remove any `\leanok` or `\mathlibok` markers.
Pre-existing markers on Section 1 blocks (def, lem proof, etc.)
remain unchanged at their original positions. The new theorem,
proof, and remarks have no `\leanok` — `sync_leanok` will
recompute markers after the refactor agent renames the Lean
declaration.

## Notes for Plan Agent
- **Refactor handoff.** The Lean theorem name changed shape
  (`smooth_iff_locally_free_omega` → `smooth_locally_free_omega`)
  and the iff dropped. The refactor agent must:
  1. Rename the Lean declaration to `smooth_locally_free_omega`.
  2. Drop the `↔` and the `LocallyOfFinitePresentation` hypothesis;
     the new statement is a forward-implication-only `→`.
  3. Switch from the deprecated `IsSmoothOfRelativeDimension` to
     `SmoothOfRelativeDimension` (resolves the existing deprecation
     warning at `AlgebraicJacobian/Differentials.lean:76`).
  The declaration is not in `archon-protected.yaml`, so the
  rename/re-sign is permitted.
- **`sync_leanok` interaction.** Because the `\lean{...}` hint
  in the new theorem block names a Lean declaration that does
  NOT yet exist (the Lean file still has the iff-named version),
  `sync_leanok` will likely not add `\leanok` to the new block
  this iter. After the refactor agent's pass, the next iter's
  `sync_leanok` should add the marker.
- **Lean-vs-blueprint review117 minor.** The directive flagged a
  cosmetic "Type _ equality vs module equality" prose issue in
  the existing `lem:relative_kaehler_presheaf_obj` block (the
  current proof says `rfl` but the equality is between underlying
  types, not modules). I left this untouched as the directive
  marked it "not a must-fix"; flagging here so a future
  iter can clean it up if desired.
- **No strategy-modifying findings** were uncovered while
  writing. The iter-118 finding (iff is false) was already part
  of the directive's premise and I am implementing the agreed
  correction.

## Strategy-modifying findings
None. The strategy-level decision to demote the iff to a forward
implication was already made in the directive; this writer
faithfully reflects that decision in the prose. No further
strategy change is implied by the rewrite.
