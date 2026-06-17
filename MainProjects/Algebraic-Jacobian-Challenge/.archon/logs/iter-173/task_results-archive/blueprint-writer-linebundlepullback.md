# Blueprint Writer Report

## Slug
linebundlepullback

## Status
COMPLETE — `blueprint/src/chapters/Picard_LineBundlePullback.tex` written; 5 `\lean{...}` pins, 5 `% SOURCE:` + 5 `% SOURCE QUOTE:` blocks, 4 `\uses{...}` cross-refs forming a connected dependency chain rooted in this chapter and rooted-to `\cref{chap:Picard_RelativeSpec}` for context. All verbatim quotes are character-by-character copies of `references/kleiman-picard-src/kleiman-picard.tex` L1274–L1318 (Defs.~`df:aPf` and `df:Pfs`), which I opened and read in this session.

## Target chapter
`blueprint/src/chapters/Picard_LineBundlePullback.tex` (new file).

## Changes Made

- **Added definition** `\definition`/`\label{def:line_bundle_on_product}`/`\lean{AlgebraicGeometry.Scheme.LineBundle.OnProduct}` — invertible $\mathcal{O}_{C \times_k T}$-module on a relative curve; cited Kleiman §2 `df:aPf` verbatim.
- **Added definition** `\definition`/`\label{def:pullback_along_projection}`/`\lean{AlgebraicGeometry.Scheme.LineBundle.pullbackAlongProjection}` — the pullback map $\pi_T^* \colon \Pic(T) \to \Pic(C \times_k T)$; cited Kleiman §2 `df:aPf` + ``prepared presheaf'' paragraph verbatim. `\uses{def:line_bundle_on_product}`.
- **Added lemma** `\lemma`/`\label{lem:pullback_compose}`/`\lean{AlgebraicGeometry.Scheme.LineBundle.pullback_pullback_eq}` — pullback composition $g_C^* \circ \pi_T^* = \pi_{T'}^* \circ g^*$ via the canonical pullback square; cited Kleiman §2 `df:aPf` (functor structure) verbatim, with Stacks 01HG named as `cf.` cross-reference.
  - Proof sketch added: Y — square is a fibre-product square; pullback functoriality via Mathlib `Module.pullback_comp`. `\uses{def:pullback_along_projection}`.
- **Added theorem** `\theorem`/`\label{thm:relative_pic_quotient_well_defined}`/`\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.preimage_subgroup}` — set-valued quotient $\Pic^\sharp_{C/k}(T) := \Pic(C \times_k T) / \pi_T^*\Pic(T)$ is well-defined; cited Kleiman §2 `df:Pfs` verbatim.
  - Proof sketch added: Y — $\pi_T^*$ is a group hom, hence its image is a subgroup; the quotient set is therefore well defined (Set-valued per planner directive). `\uses{def:pullback_along_projection}`.
- **Added theorem** `\theorem`/`\label{thm:pullback_natural}`/`\lean{AlgebraicGeometry.Scheme.RelPicPresheaf.functorial}` — for $g : T' \to T$, the pullback $g_C^*$ descends through the quotient to give a functorial $g^\sharp \colon \Pic^\sharp_{C/k}(T) \to \Pic^\sharp_{C/k}(T')$; cited Kleiman §2 `df:aPf` + `df:Pfs` verbatim.
  - Proof sketch added: Y — diagram chase using `\cref{lem:pullback_compose}` + universal property of quotient set; identity / composition laws follow from $\mathrm{id}^* = \mathrm{id}$ and $(g \circ h)^* = h^* \circ g^*$. `\uses{lem:pullback_compose, thm:relative_pic_quotient_well_defined}`.

Plus structural sections: `\section{Setup and motivation}`, `\section{Lean encoding}` (target Lean declarations mapped to Mathlib backbones), `\section{Out of scope}` (A.1.c group structure, comparison theorem, representability, $\Pic^0$, Albanese — all deferred to planned future chapters and *not* `\uses`-targeted from this chapter), and a closing `\section{Internal-consistency check}` enumerating the `\uses` chain.

## Cross-references introduced
- `\uses{def:line_bundle_on_product}` in `def:pullback_along_projection` — declared in this chapter (root).
- `\uses{def:pullback_along_projection}` in `lem:pullback_compose` and in proof of `thm:relative_pic_quotient_well_defined`.
- `\uses{lem:pullback_compose, thm:relative_pic_quotient_well_defined}` in `thm:pullback_natural` + its proof.
- `\cref{chap:Picard_RelativeSpec}` in the strategy note, Lean-encoding section, and consistency-check section — label declared on `Picard_RelativeSpec.tex` L2 (verified).
- No `\uses{...}` pointer in this chapter references a label declared in `Picard_RelPicFunctor.tex` or `Picard_FGA_FlatteningStratification.tex` (neither chapter is on disk; both are named only in `\section{Out of scope}` as planned-future, never as `\uses` targets).

## References consulted
- `references/kleiman-picard.md` — citation card; cross-checked the §2 location at source L1266 (`\section{The several Picard functors}`).
- `references/kleiman-picard-src/kleiman-picard.tex` — opened and read L1266–L1716 (the `df:aPf` definition, the "prepared presheaf" paragraph, `df:Pfs`, the comparison theorem `th:cmp`, and the rigidification lemmas). Every `% SOURCE QUOTE:` block in the new chapter is a character-by-character copy of text from this file, specifically:
  - `def:line_bundle_on_product` (block @ L60): quote of L1274–L1279 (`df:aPf`).
  - `def:pullback_along_projection` (block @ L100): quote of L1274–L1290 (`df:aPf` + "prepared presheaf" paragraph).
  - `lem:pullback_compose` (block @ L140): quote of L1274–L1279 (`df:aPf` functor signature).
  - `thm:relative_pic_quotient_well_defined` (block @ L211): quote of L1311–L1318 (`df:Pfs`).
  - `thm:pullback_natural` (block @ L271): quote of L1274–L1318 spanning `df:aPf` + `df:Pfs`.
- `references/summary.md` — index, used to confirm Kleiman is the appropriate primary source for the relative Picard quotient definition.
- `references/fga-explained.md` — citation card; confirmed FGA Explained Ch.9 §9.2 (book numbering) is the same content as Kleiman arXiv §2; no fresh quote pulled from FGA Explained since we already have Kleiman's standalone source.
- `references/hartshorne-algebraic-geometry.md` — citation card; confirmed Hartshorne II §6 (Divisors) and II §7 (Projective Morphisms) are at doc pages 129 / 149 but the PDF is scanned-image (no text layer), so no verbatim quote was pulled from Hartshorne. Hartshorne mentions are limited to `cf.` cross-references in prose.
- `references/stacks-constructions.tex` — confirmed (via grep) that tags 01HG / 01HH / 01HK are NOT in `stacks-constructions.tex` (which is Stacks chapter 27); they live in Stacks chapter 17 ("Modules"), which the project does not yet have on disk.
- `blueprint/src/chapters/Picard_RelativeSpec.tex` — opened and read in full; the new chapter's style + `% SOURCE:` / `% SOURCE QUOTE:` / `\textit{Source: …}` block discipline matches its conventions, and the new chapter's `\cref{chap:Picard_RelativeSpec}` cross-references are verified-by-label-search against this file.

## Macros needed (if any)
- `\Sch` — already in use in `Picard_RelativeSpec.tex` and other chapters (assumed defined in `blueprint/src/macros/common.tex`). Reused as-is.
- `\Pic` — same; reused.
- `\Spec` — same; reused.
- `\Hom` — same; reused.
- `\cref` — same; reused.

No new macros introduced.

## Reference-retriever dispatches (if any)
- slug `stacks-modules`: directive at `.archon/logs/iter-173/linebundlepullback/reference-retriever-stacks-modules-directive.md`. Requested verbatim Stacks tag bodies for 01HG / 01HH / 01HK from the Stacks Project chapter `modules.tex` (chapter 17, "Sheaves of Modules"), for citation-discipline reinforcement of `def:line_bundle_on_product`, `def:pullback_along_projection`, and `lem:pullback_compose`.
- **Status: DISPATCHED-BUT-INCOMPLETE.** The retriever process started (banner observed in its stdout) but produced no report file within the writer round — see `/tmp/claude-1001/.../tasks/bkdxokwqk.output`: only the Archon banner is present, no further activity. No `references/stacks-modules.tex` / `references/stacks-modules.md` was written, and `.archon/task_results/blueprint-writer-linebundlepullback/reference-retriever-stacks-modules.md` does not exist.
- **Impact on this chapter: zero.** The chapter's five `% SOURCE QUOTE:` blocks are all grounded in `references/kleiman-picard-src/kleiman-picard.tex` L1274–L1318 (read this session); the Stacks tags appear only as `cf.` cross-references in `\textit{Source: …}` prose and in the chapter body's textbook prose, not in any `% SOURCE QUOTE:` block. Citation-discipline rule is satisfied as written.
- **Suggested follow-up (for plan agent):** if a future iter wants stronger citation for `def:pullback_along_projection` / `lem:pullback_compose` specifically (i.e. verbatim Stacks 01HG/01HH/01HK rather than a `cf.` cross-reference), re-dispatch the retriever with the same directive — there is no contradictory state on disk to clean up. Alternative: the same content is in Hartshorne II Proposition II.6.13 (pullback preserves invertibility) and Proposition II.7.1 (line-bundle pullback functoriality), but those would require manually transcribing from the scanned-image PDF (no text layer).

## Notes for Plan Agent
- **Sibling-chapter inconsistency I did not touch** (writer-domain hygiene): `Picard_RelativeSpec.tex` §"Out of scope" L442–443 says ``Picard\_LineBundlePullback.tex (planned)'' — this is now stale, since the chapter exists as of this iter. A `% NOTE:` or a small prose edit on `Picard_RelativeSpec.tex` would correct this; it is OUT of my write-domain so I am flagging only.
- **`% archon:covers` covers a not-yet-existing Lean file.** The chapter's first-line cover marker is `% archon:covers AlgebraicJacobian/Picard/LineBundlePullback.lean`, but `AlgebraicJacobian/Picard/LineBundlePullback.lean` does not exist on disk yet (the `AlgebraicJacobian/Picard/` directory is empty). This matches the pattern used by `Picard_RelativeSpec.tex` (its target file also did not exist when the chapter landed iter-172, and is now on the iter-173 prover dispatch list). The next planner round should either dispatch a prover file-skeleton lane for `LineBundlePullback.lean` or note that the covers-marker is forward-looking.
- **Mathlib API uncertainty.** Mathlib's invertible-module / `LineBundle` namespace (mentioned in the Lean-encoding section) was last surveyed in the iter-172 RelativeSpec chapter; the exact namespace is `Mathlib.AlgebraicGeometry.Modules.Invertible` and the predicate is named `Module.IsInvertible` or `Sheaf.Invertible` depending on Mathlib snapshot. The chapter's Lean-encoding section talks generically about "the Mathlib invertible-module predicate" rather than naming a specific symbol, leaving the file-skeleton prover to pick the correct one. This is intentional per the directive's "do NOT pull A.1.c forward".
- **No new core axiom anticipated.** The chapter is a structural construction over Mathlib `Module.pullback`, `Quotient.map`, and the relative-spectrum chapter; no `axiom` keyword is contemplated.
- **Set-valued vs group-valued choice.** Documented in a `% NOTE:` after the strategy note (chapter header). Rationale: matches the planner directive + the iter-173 blueprint-reviewer recommendation; the group structure (and étale-sheafification step) is deferred to the planned A.1.c chapter `Picard_RelPicFunctor.tex` so this chapter remains short and decoupled from any Mathlib `AddCommGrp` étale-sheafification gap.

## Strategy-modifying findings
*(none)* — the chapter writes cleanly against the existing strategy (Route A.1.b → A.1.c → A.2.* → A.3 → A.4). Nothing in drafting surfaced a need to revise STRATEGY.md.
