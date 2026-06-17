# Blueprint Writer Report

## Slug
cov275-lbp

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_LineBundlePullback.tex

## Changes Made
- **Added definition** `\definition`/`\label{def:OnProduct_carrier}`/`\lean{AlgebraicGeometry.Scheme.LineBundle.OnProduct.carrier}` — the underlying `(pullback πC πT).Modules` sheaf of a line bundle on the product, obtained by forgetting the local-triviality (invertibility) witness (first component of the `OnProduct` subtype). Statement-level `\uses{def:line_bundle_on_product, def:IsLocallyTrivial}`. No proof block (pure projection definition).
- **Added lemma** `\lemma`/`\label{lem:OnProduct_isLocallyTrivial}`/`\lean{AlgebraicGeometry.Scheme.LineBundle.OnProduct.isLocallyTrivial}` — the carrier of an `OnProduct` line bundle is locally trivial of rank one (second component / invertibility witness). Statement-level `\uses{def:line_bundle_on_product, def:OnProduct_carrier, def:IsLocallyTrivial}`.
  - Proof sketch added: Y — one-line "Proved directly in Lean: the local-triviality witness is the defining second component of the subtype."

Both blocks placed at the end of the `sec:lbp_isLocallyTrivial_substrate` section (after `lem:IsLocallyTrivial_pullback`), so that `def:IsLocallyTrivial` is already in scope for the `isLocallyTrivial` projection. Purely additive; no existing block was touched. No `\leanok` added. No external citation (project-internal projections of the `OnProduct` carrier, as directed).

## Cross-references introduced
- `\uses{def:line_bundle_on_product}` in both new blocks — `def:line_bundle_on_product` exists in this same chapter (line 60).
- `\uses{def:IsLocallyTrivial}` in both new blocks (and the proof of `lem:OnProduct_isLocallyTrivial`) — `def:IsLocallyTrivial` exists in this same chapter (line 142).
- `\uses{def:OnProduct_carrier}` in `lem:OnProduct_isLocallyTrivial` — newly added in this chapter.

## leandag verification
- `leandag build --json`: no conflicts, `unknown_uses` count = 0.
- `leandag query --isolated --chapter Picard_LineBundlePullback`: 0 results (neither new block is isolated).
- Both new `\lean{}` targets matched their Lean declarations (neither appears in `unmatched_lean`). The only `OnProduct` entry in `unmatched_lean` is the pre-existing `lem:pullback_compatible_with_tensorobj` → `OnProduct.pullback_tensorObj_iso`, which is a TensorObj helper explicitly out of scope per the directive.

## References consulted
- None. The two declarations are project-internal projections of the `OnProduct` carrier; per directive, "proved directly in Lean" with no external citation. No citation blocks were written.

## Macros needed (if any)
- None. Only standard macros (`\cref`, `\emph`, `\mathrm`, `\mathtt`, `\mathcal`) are used.

## Notes for Plan Agent
- The pre-existing unmatched-Lean node `lem:pullback_compatible_with_tensorobj` (`AlgebraicGeometry.LineBundle.OnProduct.pullback_tensorObj_iso`) suggests a namespace/name drift between blueprint and Lean for that TensorObj helper, but it is out of scope for this directive and was left untouched.

## Strategy-modifying findings
None.
