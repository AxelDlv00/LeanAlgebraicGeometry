# Blueprint Writer Report

## Slug
rrformula-h0h1split

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/RiemannRoch_RRFormula.tex

## Changes Made

- **Added subsection** `\subsection*{Substrate lemmas for the proof of the \(\chi\)-identity}` immediately after the §4 header — intro paragraph explaining that the parent theorem's proof decomposes into three substantive substrate lemmas, factored from the Hartshorne~IV.1.3 inductive argument.

- **Added lemma** `\label{lem:euler_char_shortExact_add}` / `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_shortExact_add}` — additivity of \(\chi\) on a short exact sequence of \(\Module\bar k\)-valued sheaves on the curve. Statement form `χ(F₂) = χ(F₁) + χ(F₃)`. Carries Hartshorne IV.1 p.~296 verbatim citation (the parent-proof "Now the Euler characteristic is additive on short exact sequences (III, Ex. 5.1)" line). Proof sketch added (Y): the project-side `Module k̄`-flavoured Ext-LES of `Abelian.Ext.covariantSequence` truncated by Grothendieck vanishing in degrees ≥ 2 to a six-term exact sequence, with rank-counting via iterated `Submodule.finrank_quotient_add_finrank` yielding the alternating identity. Tagged with **`% NOTE: gated on project-side LES carrier + finiteness machinery`** documenting the three substrate pieces required (LES carrier, Grothendieck vanishing at Ext level, six-term rank-counting) — per directive R-3.

- **Added lemma** `\label{lem:euler_char_iso}` / `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_iso}` — iso-invariance of \(\chi\): `F ≅ G ⟹ χ(F) = χ(G)`. Marked as **project-bespoke** (Archon-original packaging of the Mathlib `Ext`-postcomposition API; no external source named), per the iter-186 axiom-clean closure. Proof sketch added (Y): the post-composition-by-`Ext.mk₀ e.hom` / `Ext.mk₀ e.inv` linear-equivalence construction at each degree, with `LinearEquiv.finrank_eq` transporting `k̄`-dimensions.

- **Added lemma** `\label{lem:euler_char_skyscraperSheaf}` / `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_skyscraperSheaf}` — `χ(k(P)) = 1` for the closed-point skyscraper sheaf. Carries Hartshorne IV.1 p.~296 verbatim citation (the "and `χ(k(P)) = 1`" inline citation). **Proof sketch split into named H⁰ and H¹ sub-paragraphs** (per directive R-2):
  - *H⁰ half* — `dim_{k̄} H⁰(C, k(P)) = 1`, closed against the project's existing three-step `k̄`-linear-equivalence chain `HModule_zero_linearEquiv → constantSheafGammaHom_linearEquiv → SheafGammaObj_linearEquiv_top`. Labeled axiom-clean closure projection (~30-60 LOC) and identified as the iteration-87+-natural target.
  - *H¹ half* — `dim_{k̄} H¹(C, k(P)) = 0`. Mathematical input: skyscraper sheaf is flasque, flasque sheaves have vanishing higher cohomology (Hartshorne III.2.5). Tagged with **`% NOTE: gated on Mathlib flasque cohomology`** annotation documenting that Mathlib `b80f227` does not ship `H^n(X, F) = 0 for flasque F` at the `ModuleCat`/`Abelian.Ext`-cohomology level, with the two unblocking options (Mathlib upstream PR vs. project-side ~150-300 LOC bridge) — per directive R-2.

- **Added subsection** `\subsection*{The main \(\chi\)-identity}` immediately before the main theorem environment opening (visual section break after the three substrate lemmas).

- **Revised** `thm:euler_char_eq_deg_plus_one_minus_genus` proof block:
  - Added `\uses{def:eulerChar_curve, def:l_invariant, lem:euler_char_shortExact_add, lem:euler_char_iso, lem:euler_char_skyscraperSheaf}` directive at the top of the proof body.
  - Inductive step prose extended to explicitly route through the three new lemmas: a parenthetical note that the tensor `O_C(-[P]) ⊗ O_C(D+[P]) ≅ O_C(D)` is transported via `lem:euler_char_iso`; the additivity equation gives `\uses` `lem:euler_char_shortExact_add` with the Hartshorne IV.1.3 citation inline; the `χ(k(P)) = 1` input is supplied by `lem:euler_char_skyscraperSheaf` with a sentence describing the H⁰/H¹ split so the prover sees the decomposition without re-reading the lemma body.
  - Replaced the old "Lean reference note on `χ`-additivity" trailing paragraph with a new "Lean reference note on the three substrate lemmas" paragraph that enumerates the three pins, summarises each one's substrate-closure status (additivity gated, iso closed iter-186, skyscraper split into H⁰ + H¹ halves), and notes Mathlib's `Mathlib.Algebra.Homology.EulerCharacteristic` API does not ship the additivity statement at the `Module k̄`-flavoured sheaf-cohomology level the project consumes.

## Cross-references introduced

- `lem:euler_char_shortExact_add` — new label, defined in this chapter; consumed by `\uses{...}` in `thm:euler_char_eq_deg_plus_one_minus_genus` (proof block) and by an inline `REF` in the inductive step.
- `lem:euler_char_iso` — new label, defined in this chapter; consumed by `\uses{...}` in the parent proof block and by an inline `REF` in the tensor-vs-iso transport sentence.
- `lem:euler_char_skyscraperSheaf` — new label, defined in this chapter; consumed by `\uses{...}` in the parent proof block and by an inline `REF` near the `χ(k(P)) = 1` substitution.
- All three new lemma blocks reference `\uses{def:eulerChar_curve}` (the chapter-internal Euler-characteristic definition).
- The parent theorem proof's `\uses{...}` directive now lists 5 labels (2 pre-existing chapter labels + 3 new ones); all 5 labels exist in the chapter.

## References consulted

- `references/hartshorne-algebraic-geometry.pdf` (PDF pages 312-313, book pages 295-296) — verbatim source for the Hartshorne IV.1.3 inductive step: "Now the Euler characteristic is additive on short exact sequences (III, Ex.~5.1), and \(\chi(k(P)) = 1\), so we have \(\chi(\mathscr L(D + P)) = \chi(\mathscr L(D)) + 1\)". Used as the `% SOURCE QUOTE:` block for `lem:euler_char_shortExact_add` and `lem:euler_char_skyscraperSheaf` (the same passage cites both substrate inputs).
- `blueprint/src/chapters/Picard_LineBundlePullback.tex` (sibling chapter L88-L110, L99-L110, L161-L166) — read to confirm the `% NOTE: gated on ...` annotation style used as the model for the new R-2 / R-3 annotations.
- `blueprint/src/macros/common.tex` — read to confirm `\Module`, `\Ext`, `\HModule`, `\hom`, `\Sch` are defined as macros; confirmed `\inv` is NOT a macro (avoided in the new prose by writing `e.\mathtt{inv}` instead).
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean` (L322-L415) — read the substantive type signatures of the three private helpers to ensure the `\lean{...}` pins resolve to actual declarations: `AlgebraicGeometry.Scheme.eulerCharacteristic_shortExact_add` (L322), `_iso` (L347), `_skyscraperSheaf` (L405).

## Macros needed (if any)

None. All math symbols used (`\Module`, `\Ext`, `\HModule`, `\hom`, `\Sch`, `\mathtt{...}`, etc.) are either project macros already defined in `blueprint/src/macros/common.tex` or standard LaTeX. The earlier draft used `\mathop{\mathrm{op}}\top` which is awkward but valid; I simplified it to plain prose in the H⁰ half (writing "evaluates at the top open" instead of typesetting `op ⊤`) to avoid notation that doesn't appear elsewhere in the chapter.

## Reference-retriever dispatches (if any)

None. The Hartshorne IV.1 source material was already available locally (`references/hartshorne-algebraic-geometry.pdf`) and the relevant pages (PDF 312-313 / book 295-296) covered all the verbatim citations the new lemma blocks require.

## Notes for Plan Agent

- **Private declarations + `\lean{...}` pins.** The three sub-helpers in `RRFormula.lean` (L322, L347, L405) are declared `private theorem Scheme.eulerCharacteristic_...`. The blueprint `\lean{AlgebraicGeometry.Scheme.eulerCharacteristic_shortExact_add}` etc. pins assume `leanblueprint` can resolve `private` declarations by their public FQN. If the next `leanblueprint` regeneration of `lean_decls` reports unresolved pins, the plan agent will need to either (a) drop the `private` modifier in `RRFormula.lean` (a one-character edit per declaration) or (b) prefix the `\lean{...}` argument with the internal `_private.<file>...` mangle. The same concern applies to `Scheme.finrank_H0_toModuleKSheaf_eq_one` at L231 (currently no blueprint pin but conceptually a substrate lemma of the same shape); a future iteration may want to pin it too.
- **Duplicated Hartshorne quote.** The parent theorem's `% SOURCE QUOTE PROOF:` already verbatim-quotes the same Hartshorne IV.1 inductive-step passage that the new `lem:euler_char_shortExact_add` and `lem:euler_char_skyscraperSheaf` blocks quote. This duplication is intentional (each block stands as a self-contained citation per the citation discipline rules) but visually noticeable; the plan agent may wish to confirm the duplication is acceptable, or fold the redundant quotes into a single chapter-level comment.
- **R-3 satisfied informally; R-1/R-2 fully satisfied.** R-3 requested that the substrate gap for `eulerCharacteristic_shortExact_add` cite a specific substrate sketch — the `% NOTE` annotation in `lem:euler_char_shortExact_add`'s proof block lists all three components (LES carrier / Grothendieck vanishing / six-term rank-counting) and references `Submodule.finrank_quotient_add_finrank` per the directive. The body of `lem:euler_char_iso` is identified as project-bespoke (Archon-original) since the directive did not name an external source for the iso-invariance lemma specifically.

## Strategy-modifying findings

None. The blueprint expansion is a pure decomposition of an already-substantive monolithic proof body — it does not raise new dependencies, surface new substrate gaps that STRATEGY.md doesn't already track, or invalidate any iter-186 closure. The three substrate lemmas decompose the Tier-3 sorry burden into three smaller pieces, two of which (`eulerCharacteristic_iso` closed iter-186; the H⁰ half of `eulerCharacteristic_skyscraperSheaf`) are off the critical-substrate path and one of which (H¹ half + additivity) remains tracked on the STRATEGY.md row "Genus-0 RR.2 — RR formula for genus 0".
