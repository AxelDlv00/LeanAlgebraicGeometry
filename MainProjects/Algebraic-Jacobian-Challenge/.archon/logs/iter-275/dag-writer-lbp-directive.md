# Blueprint Writer Directive

## Slug
cov275-lbp

## Target chapter
blueprint/src/chapters/Picard_LineBundlePullback.tex

## Strategy context
This chapter covers `AlgebraicJacobian/Picard/LineBundlePullback.lean` (Route A,
line bundles on a product `C ×_S T`). Strict 1-to-1 Lean ↔ blueprint
correspondence. Two `OnProduct` helpers currently have NO blueprint entry. Add one
additive, faithful 1-to-1 coverage block per declaration. Purely additive.

## Required content
Read each Lean signature from LineBundlePullback.lean, then add a block for:

- `abbrev` `AlgebraicGeometry.Scheme.LineBundle.OnProduct.carrier`
  (LineBundlePullback.lean:135) — the underlying `(pullback πC πT).Modules`
  carrier of an `OnProduct` line bundle (first component / forget of the
  invertibility data).
- `lemma` `AlgebraicGeometry.Scheme.LineBundle.OnProduct.isLocallyTrivial`
  (line 139) — the carrier of an `OnProduct` is locally trivial (the invertibility
  witness, second component).

Note: `OnProduct` itself (the type, line 130) is already covered — only these two
projections/helpers are missing.

## Proof notes
- Proved sorry-free in Lean: one-line `\begin{proof} Proved directly in Lean. \end{proof}`.

## Wiring (critical — leandag quirk)
leandag builds edges ONLY from **statement-level** `\uses{}`. Each block must
carry a statement-level `\uses{}` to the existing `OnProduct` definition block in
this chapter (both are projections of it), so neither lands isolated. After
writing, run `leandag build --json` and
`leandag query --isolated --chapter Picard_LineBundlePullback`; ensure no new isolated nodes.

## Out of scope
- Do NOT touch existing blocks. Do NOT add `\leanok`. Do NOT cover TensorObj/Modules helpers.

## References
- None needed — these are project-internal projections of the `OnProduct` carrier;
  "proved directly in Lean" with no external citation. Do NOT fabricate a citation.

## Expected outcome
Two additive 1-to-1 coverage blocks for `OnProduct.carrier` and
`OnProduct.isLocallyTrivial`, statement-level-wired to `OnProduct`, not isolated,
no broken `\uses{}`.
