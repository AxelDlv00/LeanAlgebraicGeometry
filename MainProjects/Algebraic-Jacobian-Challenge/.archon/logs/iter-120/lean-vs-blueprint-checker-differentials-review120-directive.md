# Lean ↔ Blueprint Checker Directive

## Slug
differentials-review120

## Lean file
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean

## Blueprint chapter
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex

## Known issues
- Iter-120 closed `smooth_locally_free_omega` (L91, body L99–L109) via the verified 6-step Mathlib chain. Audit the new proof body against the chapter's `\begin{proof}` for `thm:smooth_locally_free_omega` (Steps 1–4.5 expected).
- The chapter's `sec:bridge-out-of-scope` (`rem:bridge_relative_kaehler_iso_appLE`) is documented as a Mathlib gap with NO `\lean{...}` hint — this is intentional, not a chapter inadequacy. Do NOT flag absence of a Lean side for the bridge remark.
- The chapter's `sec:converse-out-of-scope` (`rem:converse_counterexample` / `rem:converse_lemma_hypotheses` / `rem:stacks_02G1`) is documented as out of autonomous-loop scope with the counterexample `Spec k → Spec k[t]`. Do NOT flag absence of a Lean side for the converse.
- `relativeDifferentialsPresheaf` and `relativeDifferentialsPresheaf_obj_kaehler` are infrastructure definitions; their `\lean{...}` hints should still resolve.
- The iter-118 deprecated alias `IsSmoothOfRelativeDimension → SmoothOfRelativeDimension` migration already landed; the chapter and Lean should both use the un-aliased class.

## Focus
- Bidirectional verification of `thm:smooth_locally_free_omega`:
  - Lean signature L91-L98 vs. chapter informal statement (algebra-Kähler form).
  - Lean proof body L99-L109 vs. chapter `\begin{proof}` Steps 1-4.5.
  - All `\lean{...}` hints in the chapter resolve to the right declarations.
- `relativeDifferentialsPresheaf` (L49-L52) and `relativeDifferentialsPresheaf_obj_kaehler` (L58-L64): blueprint coverage adequate?
- Markers for the freshly-closed theorem: blueprint chapter should be ready for `\leanok` on both the statement block and the proof block (the deterministic `sync_leanok` phase ran just before you; just check whether the chapter has `\lean{...}` hints pinning the right names so the script can succeed).
