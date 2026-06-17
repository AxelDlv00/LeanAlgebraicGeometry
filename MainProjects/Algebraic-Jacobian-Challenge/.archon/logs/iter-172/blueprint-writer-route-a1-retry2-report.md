# Blueprint Writer Report

## Slug
route-a1-retry2

## Status
COMPLETE — chapter on disk at 449 lines with all 6 required declaration blocks and
verbatim `% SOURCE QUOTE:` blocks copied character-for-character from
`references/stacks-constructions.tex`. One TODO placeholder remains for the proof of
Theorem `\thm:relative_spec_univ` (Stacks `lemma-spec` proof, ~50 lines; the structural
body is restated in project notation).

## Target chapter
`blueprint/src/chapters/Picard_RelativeSpec.tex` (NEW — created this iter).

## Changes Made

- **Added section** "Setup and motivation" (\S~\ref{sec:relspec_setup}) — one paragraph
  motivating RelativeSpec as the A.1.a building block of the relative Picard functor.
- **Added definition** `\definition` / `\label{def:qc_sheaf_of_algebras}` /
  `\lean{AlgebraicGeometry.Scheme.QcohAlgebra}` — quasi-coherent sheaf of
  $\mathcal{O}_X$-algebras, with verbatim `% SOURCE QUOTE:` from Stacks
  `situation-relative-spec` (L312-L318 of local file).
- **Added theorem** `\theorem` / `\label{thm:relative_spec_exists}` /
  `\lean{AlgebraicGeometry.Scheme.RelativeSpec}` — existence + properties (1)-(2) of
  $\pi : \underline{\Spec}_X(\mathcal{A}) \to X$. Verbatim quote from Stacks
  `lemma-glue-relative-spec` (L381-L405). Proof sketch added: gluing principle with
  the verbatim Stacks `proof` quote attached.
- **Added theorem** `\theorem` / `\label{thm:relative_spec_univ}` /
  `\lean{AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty}` — universal property
  in functor-of-points form. Verbatim quotes from Stacks `section-spec` setup
  (L427-L466) and `lemma-spec` statement (L547-L551). Proof sketch added; the
  multi-page Stacks proof body is summarised in project notation with a
  `% SOURCE QUOTE PROOF: TODO retrieve...` placeholder marking the un-quoted section.
- **Added theorem** `\theorem` / `\label{thm:relative_spec_affine_base}` /
  `\lean{AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff}` — affine-base
  reduction $\underline{\Spec}_X(\mathcal{A}) \cong \Spec(\Gamma(X,\mathcal{A}))$.
  Verbatim statement quote from Stacks `lemma-spec-affine` (L491-L497); verbatim
  partial proof quote (L500-L520 in local file).
- **Added theorem** `\theorem` / `\label{thm:relative_spec_base_change}` /
  `\lean{AlgebraicGeometry.Scheme.RelativeSpec.base_change}` — base-change isomorphism
  $T \times_X \underline{\Spec}_X(\mathcal{A}) \cong \underline{\Spec}_T(g^*\mathcal{A})$.
  Verbatim quotes from Stacks `lemma-spec-base-change` (L467-L489) and
  `lemma-spec-properties` part~(2) (L670-L673). Verbatim proof quote attached.
- **Added theorem** `\theorem` / `\label{thm:relative_spec_functorial}` /
  `\lean{AlgebraicGeometry.Scheme.RelativeSpec.functor}` — RelativeSpec as a
  contravariant functor from quasi-coherent $\mathcal{O}_X$-algebras to affine
  $X$-schemes, with the $\pi_*\mathcal{O} \cong \mathcal{A}$ inverse. Verbatim quotes
  from Stacks `definition-relative-spec` (L641-L656) and `lemma-spec-properties`
  part~(3) (L674-L682). Proof sketch added.
- **Added section** "Lean encoding" (\S~\ref{sec:relspec_lean_encoding}) — one
  paragraph naming `Scheme.GlueData` / `AffineScheme.glueOpens` /
  `IsAffineOpen.toScheme` / `CategoryTheory.Functor.RepresentableBy` as the
  implementation backbone.
- **Added section** "Out of scope" (\S~\ref{sec:relspec_out_of_scope}) — one
  paragraph listing the four out-of-scope sibling constructions.
- **Top-of-chapter declaration** `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean`
  immediately under `\chapter{Relative Spec}` / `\label{chap:Picard_RelativeSpec}`.

## Cross-references introduced

- `\uses{def:qc_sheaf_of_algebras}` in every theorem block.
- `\uses{def:qc_sheaf_of_algebras, thm:relative_spec_exists}` in `\thm:relative_spec_univ`.
- `\uses{def:qc_sheaf_of_algebras, thm:relative_spec_exists}` in `\thm:relative_spec_affine_base`
  and `\thm:relative_spec_base_change`.
- `\uses{def:qc_sheaf_of_algebras, thm:relative_spec_exists, thm:relative_spec_univ}` in
  `\thm:relative_spec_functorial`.
- Proof `\uses{}` blocks cross-link the four theorem labels into a coherent dependency
  graph: `\thm:relative_spec_univ` proof uses
  `{thm:relative_spec_exists, thm:relative_spec_affine_base, thm:relative_spec_base_change}`,
  `\thm:relative_spec_functorial` proof uses
  `{thm:relative_spec_exists, thm:relative_spec_univ, thm:relative_spec_affine_base}`.

All cross-references are internal to this chapter — every `thm:relative_spec_*` label
is defined within the same file.

## References consulted

- `references/stacks-constructions.tex` — read L305-L760 (Section "Relative spectrum
  via glueing" through Section "Affine n-space"). Verbatim quotes extracted for all 6
  declaration blocks. This is the Stacks Project local mirror chapter "Constructions
  of Schemes"; the tag-name correspondence is `situation-relative-spec`/01LL,
  `lemma-spec-affine`/01LO, `lemma-spec-base-change`/01LS, `lemma-glue-relative-spec`/01LQ,
  `definition-relative-spec`/01LR, `lemma-spec-properties` (multi-part), confirmed by
  the iter-171 retry log's tag inventory.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` (read header only) —
  consulted to match the project's chapter-opening format (`% archon:covers`,
  STRATEGY NOTE block).
- `blueprint/src/macros/common.tex` (read first 40 lines) — confirmed `\Spec`, `\Pic`,
  `\Hom` macros are already defined.
- `.archon/logs/iter-171/blueprint-writer-route-a1-decompose-directive.md` — full
  iter-171 directive reused as the structural recipe.

I did NOT open `references/hartshorne-algebraic-geometry.pdf` this session due to the
"prioritise WRITING over deep source-quotation exploration" guidance in this iter's
directive. The Hartshorne reference is cited as a secondary `\textit{Source: ...}`
pointer (II~Ex.~5.17(a)/(b)) but NOT used as the verbatim-quote source for any block;
all six verbatim `% SOURCE QUOTE:` blocks are character-for-character from
`references/stacks-constructions.tex`, which is in the local tree and which I did open
this session.

## Macros needed (if any)

None new. The chapter uses only `\Spec`, `\Pic`, `\Hom`, `\Sch` (all defined in
`blueprint/src/macros/common.tex`), standard LaTeX, and the standard theorem/definition
environments.

## Reference-retriever dispatches (if any)

None. All required verbatim text was found in the existing
`references/stacks-constructions.tex`; no retrieval was needed.

## Notes for Plan Agent

1. **`content.tex` update needed.** The new chapter file
   `blueprint/src/chapters/Picard_RelativeSpec.tex` must be `\input`-ed from
   `blueprint/src/content.tex` for `leanblueprint` to pick it up. That edit is the
   plan agent's responsibility (the writer's write-domain excludes `content.tex`).
   Suggested position: somewhere before the existing Jacobian/Picard-adjacent chapters
   so the dependency graph reads top-down, but the exact ordering is a plan-agent call.

2. **Lean file scaffold target.** The chapter declares
   `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean`. That file does NOT
   yet exist on disk (confirmed by the directive). iter-173's prover lane can scaffold
   it from the chapter's six `\lean{...}` hints:
   `AlgebraicGeometry.Scheme.QcohAlgebra`,
   `AlgebraicGeometry.Scheme.RelativeSpec`,
   `AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty`,
   `AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff`,
   `AlgebraicGeometry.Scheme.RelativeSpec.base_change`,
   `AlgebraicGeometry.Scheme.RelativeSpec.functor`.
   A bare-skeleton file with `def`/`theorem` signatures + `:= sorry` bodies is the
   smallest first step; the bodies decompose into the standard `Scheme.GlueData`
   workflow flagged in the "Lean encoding" section.

3. **One verbatim-quote gap.** The proof of `\thm:relative_spec_univ` references Stacks
   `lemma-spec` whose proof body (L553-L600 of `references/stacks-constructions.tex`,
   ~50 lines) is too long to inline as a single `% SOURCE QUOTE PROOF:` block. I
   inserted a `% SOURCE QUOTE PROOF: TODO retrieve...` placeholder and restated the
   structural argument in project notation. If full-verbatim coverage is wanted, the
   plan agent can split `\thm:relative_spec_univ` into three sub-lemmas (Zariski sheaf
   property; subfunctor representability via affine base; subfunctors are open and
   cover) per the citation-discipline guidance for multi-page proofs. For now the
   chapter is prover-ready as written.

4. **Naming convention.** I used `AlgebraicGeometry.Scheme.RelativeSpec.functor` (lower
   `f`) for the functoriality theorem per the directive. If the project's Mathlib-side
   convention prefers capital `Functor`, the `\lean{...}` hint is the only place it
   needs to change.

5. **Hartshorne II Ex 5.17.** Cited as a secondary `\textit{Source: ...}` pointer in
   two blocks (`\thm:relative_spec_exists`, `\thm:relative_spec_functorial`). I did
   NOT extract a verbatim quote from the PDF this iter (time-budget). If verbatim
   Hartshorne text is wanted as a back-up citation, a follow-up
   `reference-retriever` dispatch on `references/hartshorne-algebraic-geometry.pdf`
   pages around II~Ex.~5.17 could supply it. Lower priority since the Stacks verbatim
   already covers all six statements.

## Strategy-modifying findings

None. The chapter as written is consistent with the iter-172 STRATEGY.md framing of
Route A.1.a (relative-spectrum functor as the smallest Mathlib-gap entry point) and
introduces no new strategic constraints. Mathlib's existing `Scheme.GlueData` and
`AffineScheme.glueOpens` machinery is sufficient as the implementation backbone — no
upstream-Mathlib detour is required.
