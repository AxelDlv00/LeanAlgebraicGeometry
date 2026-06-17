# Blueprint Writer Report

## Slug
Picard_SheafOverEquivalence-cov273

## Status
COMPLETE — all 10 uncovered Lean declarations now have exactly one `\lean{}`-pinned
blueprint block, each wired into the chapter's dependency cone; no isolated nodes,
no unknown `\uses{}`, no unmatched Lean names (verified with `leandag`).

## Target chapter
blueprint/src/chapters/Picard_SheafOverEquivalence.tex

## Changes Made

Added one block per uncovered declaration (label + `\lean{}`):

- **Added definition** `def:over_equiv_inverse_is_continuous` — `\lean{…Modules.overEquivInverseIsContinuous}` — continuity of the inverse leg of the over-equivalence (subspace → slice topology).
- **Added definition** `def:over_equiv_functor_is_continuous` — `\lean{…Modules.overEquivFunctorIsContinuous}` — continuity of the functor leg (slice → subspace topology).
- **Added lemma** `lem:image_overequiv_functor_obj` — `\lean{…Modules.image_overEquiv_functor_obj}` — the open-immersion image of the reindexed open `e.functor V` is `V.left`.
- **Added lemma** `lem:left_overequiv_inverse_obj` — `\lean{…Modules.left_overEquiv_inverse_obj}` — `(e.inverse W).left = ι∗ W` (symmetric counterpart).
- **Added definition** `def:phi_over` — `\lean{…Modules.phiOver}` — the structure-sheaf ring morphism φ.
- **Added definition** `def:psi_over` — `\lean{…Modules.psiOver}` — the inverse ring morphism ψ.
- **Added definition** `def:psi_restrict` — `\lean{…Modules.psiRestrict}` — the ring morphism along `ι.opensFunctor` underlying `restrictFunctor ι`.
- **Added lemma** `lem:restrict_functor_eq_pushforward_psi_restrict` — `\lean{…Modules.restrictFunctor_eq_pushforward_psiRestrict}` — `restrictFunctor ι = pushforward psiRestrict` (definitional).
- **Added definition** `def:over_forget_nat_iso` — `\lean{…Modules.overForgetNatIso}` — index-reconciliation nat-iso `Over.forget U ≅ e.functor ⋙ ι.opensFunctor`.
- **Added definition** `def:linebundle_chart_over_iso` — `\lean{…LineBundle.chartOverIso}` — the engine's local over↔restrict bridge, redirecting to the general `Modules.chartOverIso`.

Each new block carries a `\begin{proof} Proved directly in Lean. … \end{proof}`
(helper internal lemmas; no external SOURCE citation required — none restates a
Mathlib result verbatim).

## Cross-references introduced (wiring)

In-edges added to existing public blocks:
- `def:sheafofmodules_over_equivalence` (proof) — added `\uses{def:over_equiv_functor_is_continuous, def:over_equiv_inverse_is_continuous, def:phi_over, def:psi_over}` (the continuity prereqs and the two ring morphisms feeding `pushforwardPushforwardEquivalence`).
- `lem:sheafofmodules_restrict_over_iso` (proof) — added `\uses{def:phi_over, def:psi_restrict, lem:restrict_functor_eq_pushforward_psi_restrict, def:over_forget_nat_iso, def:over_equiv_functor_is_continuous}`.

Out-edges from new blocks (to their own sub-lemmas):
- `def:over_equiv_functor_is_continuous` → `def:over_equiv_inverse_is_continuous` (density propagates along the equivalence).
- `def:phi_over` → `lem:image_overequiv_functor_obj`.
- `def:psi_over` → `lem:left_overequiv_inverse_obj`.
- `def:over_forget_nat_iso` → `lem:image_overequiv_functor_obj`.
- `lem:restrict_functor_eq_pushforward_psi_restrict` → `def:psi_restrict`.
- `def:linebundle_chart_over_iso` → `lem:chart_over_iso`.

Net effect: the chapter's public results (`lem:chart_over_iso`,
`def:sheafofmodules_over_equivalence`, `lem:sheafofmodules_restrict_over_iso`)
transitively `\uses{}` all ten helpers; `leandag query --isolated --chapter
Picard_SheafOverEquivalence` returns 0 results.

## Literal-REF placeholders fixed
0 — the chapter contained no literal `REF` placeholders (verified by grep).

## leandag verification
- `unknown_uses`: `[]`
- `unmatched_lean` for the 10 new decls: none
- isolated nodes in chapter: 0

## References consulted
None — all ten declarations are Archon-original substrate helpers proved
sorry-free in Lean; no external source material was cited (no `% SOURCE` blocks
written). Statements drawn directly from the Lean source signatures/docstrings in
`AlgebraicJacobian/Picard/SheafOverEquivalence.lean` and (for `LineBundle.chartOverIso`)
`AlgebraicJacobian/Picard/LineBundleCoherence.lean`.

## Macros needed
None new. Used existing `\Scheme`, plus standard `\mathtt`/`\mathrm`/`\cref`.
Notation `ι∗ W` for the open-immersion image is rendered as `\iota_{\ast} W`.

## Notes for Plan Agent
- `AlgebraicGeometry.Scheme.LineBundle.chartOverIso` physically lives in
  `LineBundleCoherence.lean` (chapter `Picard_LineBundleCoherence.tex`), not in
  `SheafOverEquivalence.lean`. Per the directive it is now covered in THIS chapter
  via `def:linebundle_chart_over_iso`. If `leandag` attributes it to the
  `LineBundleCoherence` chapter instead, the pin may want to move there in a future
  pass; it is a thin definitional redirect to `lem:chart_over_iso` either way.

## Strategy-modifying findings
None.
