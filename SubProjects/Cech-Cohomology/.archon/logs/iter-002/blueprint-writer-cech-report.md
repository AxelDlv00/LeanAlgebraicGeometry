# Blueprint Writer Report

## Slug
cech

## Status
COMPLETE

Both flagged nodes fixed. The missing Stacks "Cohomology" chapter source was retrieved
successfully, so both citation gaps are closed with verbatim quotes (no retrieval
failure, no fabricated quotes).

## Target chapter
blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex

## Changes Made

### Item 1 — `lem:cech_to_cohomology_on_basis` (statement citation)
- **Revised** `lem:cech_to_cohomology_on_basis` — rewrote the `% SOURCE:` pointer to name
  the now-local retrieved file: `[Stacks Project], Cohomology, Tag 01EO, Lemma
  lemma-cech-vanish-basis (read from references/stacks-cohomology.tex, L1695--1714)`, and
  added a verbatim `% SOURCE QUOTE:` of the standalone statement of
  `lemma-cech-vanish-basis` (the basis-comparison criterion with its three numbered
  conditions: (1) basis closed under finite intersection of cover members, (2) cofinality
  of the chosen covers, (3) Čech vanishing on the basis ⇒ \(H^p(U,\mathcal{F})=0\) on the
  basis), copied character-for-character from `references/stacks-cohomology.tex`. The prior
  note "the standalone statement is not yet retrieved" is removed (it now is). The existing
  `% SOURCE QUOTE PROOF:` (application context from `stacks-coherent.tex`, L157--173) and
  the honest "general basis-comparison criterion … not yet available in Mathlib — to-build
  dependency" prose remark were left untouched, per directive.

### Item 2 — `lem:cech_term_pushforward_acyclic` (two implicit dependencies promoted)
- **Added lemma** `\lemma`/`\label{lem:higher_direct_image_presheaf}`/`\lean{AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology}` [expected]
  — the presheaf description of higher direct images: \(R^k f_*\mathcal{G}\) is the
  sheafification of \(V \mapsto H^k(f^{-1}(V),\mathcal{G}|_{f^{-1}(V)})\), reducing
  \(f_*\)-acyclicity to absolute cohomology vanishing on affine preimages.
  - Mathlib check (item 2a): I searched Mathlib via the Lean LSP (`lean_leansearch`) for a
    derived/higher-direct-image presheaf description on `Scheme.Modules`. Mathlib provides
    only the degree-0 `Scheme.Modules.pushforward` (e.g.
    `AlgebraicGeometry.Scheme.Modules.pushforward_obj_presheaf_map`); there is **no**
    Mathlib result giving \(R^k f_*\) as the sheafification of the cohomology presheaf for
    the relative `Scheme.Modules` setting. So this is declared as a **to-build sub-lemma**,
    NOT a `\mathlibok` anchor (directive-confirmed expectation).
  - Source: Stacks Cohomology, Tag 01XJ (`lemma-describe-higher-direct-images`), verbatim
    `% SOURCE QUOTE:` from `references/stacks-cohomology.tex` L591--603. Short informal
    proof added (injective resolution → objectwise cohomology sheaf → sheafification).
- **Added lemma** `\lemma`/`\label{lem:open_immersion_pushforward_comp}`/`\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` [expected]
  — affine-open-immersion vanishing + composition degeneration: for \(j : U \hookrightarrow X\)
  the immersion of an affine open into a separated \(X\), (1) \(R^q j_* = 0\) for \(q \geq 1\),
  and (2) \(R^k f_*(j_*\mathcal{H}) \cong R^k (f\circ j)_*\mathcal{H}\).
  - Sources: Stacks Cohomology of Schemes `lemma-relative-affine-vanishing`
    (`references/stacks-coherent.tex` L180--199, verbatim quote already used elsewhere) for
    the affine vanishing, and Stacks Cohomology `lemma-relative-Leray`
    (`references/stacks-cohomology.tex` L2295--2306, newly retrieved) for the
    Grothendieck/relative-Leray composition spectral sequence whose degeneration gives the
    composition identity. Two verbatim `% SOURCE QUOTE:` blocks. Short informal proof added
    (affine morphism ⇒ relative vanishing via the presheaf description and Serre vanishing;
    then \(E_2^{p,q} = R^p f_*(R^q j_*\mathcal{H})\) concentrated on the \(q=0\) row).
- **Fixed dependencies** `lem:cech_term_pushforward_acyclic` — added
  `lem:higher_direct_image_presheaf` and `lem:open_immersion_pushforward_comp` to the
  `\uses{}` on BOTH the lemma statement block and its proof block. (Previously these two
  steps were invoked in the proof prose but neither in `\uses{}` nor separately blueprinted.)

## Cross-references introduced
- `\uses{def:higher_direct_image}` in `lem:higher_direct_image_presheaf` (statement + proof)
  — `def:higher_direct_image` is `\label`'d in sibling chapter
  `Cohomology_HigherDirectImage.tex:25` (verified present). Legitimate cross-chapter edge;
  not edited.
- `\uses{lem:affine_serre_vanishing, lem:higher_direct_image_presheaf}` in
  `lem:open_immersion_pushforward_comp` (statement + proof) — both labels live in this
  chapter (`lem:affine_serre_vanishing` at L570).
- `\uses{… lem:higher_direct_image_presheaf, lem:open_immersion_pushforward_comp}` added to
  `lem:cech_term_pushforward_acyclic` (statement + proof).
- `leandag build --json` after the edits: `unknown_uses = 0`, `isolated = 0` (neither new
  block is isolated, no broken refs). The two new `\lean{...}` names appear under
  `unmatched_lean` — expected, as they are to-build declarations not yet in the `.lean`
  file (`\lean{...}` [expected]); no Lean declaration was claimed as done.

## References consulted
- `references/stacks-cohomology.tex` (newly retrieved this session, see dispatch below) —
  verbatim `% SOURCE QUOTE:` for `lemma-cech-vanish-basis` (Tag 01EO, L1695--1714, item 1),
  `lemma-describe-higher-direct-images` (Tag 01XJ, L591--603, item 2a), and
  `lemma-relative-Leray` (L2295--2306, item 2b composition degeneration).
- `references/stacks-coherent.tex` — confirmed verbatim text of
  `lemma-relative-affine-vanishing` (L180--199) reused for item 2b; confirmed the existing
  `% SOURCE QUOTE PROOF:` (application context, L157--173) for item 1 is correct and left
  in place.
- `references/summary.md` — index of existing sources (the retriever appended the new
  `stacks-cohomology` row).

## Macros needed (if any)
None. All commands used (`\check{}`, `\mathcal{}`, `\operatorname{}`, `\v{}`, enumerate)
are already in use elsewhere in the chapter.

## Reference-retriever dispatches (if any)
- slug `stacks-cohomology`: requested Stacks Project "Cohomology" chapter LaTeX source
  (`cohomology.tex`) for the verbatim statements of `lemma-cech-vanish-basis` (Tag 01EO),
  `lemma-describe-higher-direct-images` (Tag 01XJ), and (used opportunistically)
  `lemma-relative-Leray`. Status: **COMPLETE** — downloaded
  `references/stacks-cohomology.tex` (TeX, ~508 KB, 14535 lines), verified, pointer
  `references/stacks-cohomology.md` written, `references/summary.md` row appended. Key
  locations: `lemma-describe-higher-direct-images` at L591--603;
  `lemma-cech-vanish-basis` at L1695--1714; `lemma-relative-Leray` at L2295--2306.

## Notes for Plan Agent
- The two new sub-lemmas are **to-build** (`\lean{...}` [expected] names; no Lean
  declaration exists yet in `CechHigherDirectImage.lean`). They carry real DAG edges now,
  so the prover lane will see them as obligations feeding `lem:cech_term_pushforward_acyclic`.
  If a lean-scaffolder pass is run, the expected names are
  `AlgebraicGeometry.higherDirectImage_isSheafify_presheafCohomology` and
  `AlgebraicGeometry.higherDirectImage_openImmersion_comp`.
- Out-of-scope blocks (push–pull sub-graph, `lem:cech_acyclic_affine`,
  `lem:affine_serre_vanishing`, `lem:cech_augmented_resolution`,
  `lem:cech_computes_cohomology`) were NOT touched beyond adding the two `\uses{}` labels to
  `lem:cech_term_pushforward_acyclic`, as directed. No `\leanok` added or removed.

## Strategy-modifying findings
None. The fixes are citation/dependency-graph completions only; nothing surfaced that
contradicts the Route-A acyclic-resolution strategy.
