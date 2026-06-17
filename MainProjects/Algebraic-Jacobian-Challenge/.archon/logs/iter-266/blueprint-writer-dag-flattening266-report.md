# Blueprint Writer Report

## Slug
dag-flattening266

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made
- **Added proof** for `thm:flattening_stratification_exists` (Existence of the
  flattening stratification) — inserted a `\begin{proof}...\end{proof}` block
  immediately after `\end{theorem}` (safest leanblueprint attachment point,
  before the "The proof is long..." splitting paragraph). Resolves the leandag
  ∞-node: the theorem had a full three-part statement but no proof body.
  - The assembled proof follows the chapter's own decomposition, in three parts
    matching the theorem's (i)/(ii)/(iii):
    - **(i) finiteness of the Hilbert-polynomial set** — cites
      `lem:nonflat_locus_proper` (Noetherian-induction reduction to the flat
      case, whose step invokes `thm:generic_flatness`) + local constancy of the
      Hilbert polynomial on flat families, with flatness in the sense of
      `def:coherent_sheaf_flat`.
    - **(ii) existence + universal property of the strata** — uniform
      cohomology vanishing / base-change for `\pi_*\F(m)` (m ≫ 0, named in the
      chapter's statements (B)/(C)), then `lem:noetherian_induction_strata`
      iterating the n=0 mechanism `lem:flat_locus_open` on `E_i = \pi_*\F(N+i)`;
      re-indexing tuples by Hilbert polynomial, the closed-subscheme refinement
      `S_f ⊆ W_f`, flatness of `i^*\F`, and the unique factorisation via the
      local-freeness universal property of `lem:flat_locus_open`.
    - **(iii) closure of strata** — reduces to upper-semicontinuity from the
      n=0 case (`lem:flat_locus_open`) applied to a single `\pi_*\F(p)`, p ≫ 0.
  - Added a `% SOURCE QUOTE PROOF:` block immediately before the proof env,
    verbatim from `nitsure-hilbert-quot.tex` L1844–L1900 (the "It is enough to
    prove the theorem for open subschemes..." gluing remark + the "idea of the
    proof is as follows" g.c.d.-of-flattening-stratifications overview). Noted
    that the full body L1844–L2090 is distributed across the existing
    sub-lemmas, each of which already carries its own verbatim
    `% SOURCE QUOTE PROOF`.

## Cross-references introduced
- `\uses{def:coherent_sheaf_flat, lem:flat_locus_open, lem:nonflat_locus_proper,
  lem:noetherian_induction_strata, thm:generic_flatness}` on the new proof.
  All five labels exist in this same chapter; `leandag build --json` reports
  `unknown_uses: []`.

## Constraints honoured
- Did NOT add `\leanok` (the statement already carries one, untouched; managed by
  sync_leanok).
- Did not alter the theorem statement or any `% SOURCE`/`% SOURCE QUOTE` block.
- No Lean code/tactics; purely mathematical prose in project notation.
- No sub-lemma statement was modified; none of the depended-on sub-lemmas was an
  empty-proof ∞-node (each already has a `\begin{proof}`), so no auxiliary proof
  insertion was needed.

## References consulted
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` (L1840–2000) —
  verbatim source for the `% SOURCE QUOTE PROOF` overview of the existence
  theorem proof; confirmed the chapter's (A)/(B)/(C) statements and the
  `E_i = \pi_*\F(N+i)` assembly match the source.

## Verification (leandag)
- `leandag build --json`: `unknown_uses: []` (no broken refs introduced).
- `leandag query --isolated --chapter Picard_FlatteningStratification`: no
  flat-related isolated nodes — the existence theorem is now wired to its
  sub-lemmas via the new proof.

## Notes for Plan Agent
- The directive's prose mapped `lem:nonflat_locus_proper` to "the non-flat-locus
  properness" and `lem:noetherian_induction_strata` to the
  "Noetherian-induction reduction"; in the chapter the labels are actually the
  reverse (`lem:nonflat_locus_proper` = "Noetherian induction reduction to the
  flat case"; `lem:noetherian_induction_strata` = "Assembly of the strata"). I
  wired `\uses{}` to the labels as they exist in the chapter, and the proof
  prose cites each by its actual role. No label was renamed.
- The cohomology vanishing / base-change inputs ("statements (B)/(C)") are not
  separate blueprint blocks — they live inside the proof of
  `lem:noetherian_induction_strata`, citing [Hartshorne] III.12 / [Stacks] tag
  02KH. So there were no extra cohomology/base-change labels to add to `\uses{}`.
  If the plan wants these as first-class nodes (e.g. a Serre-vanishing /
  cohomology-and-base-change Mathlib anchor), that would be a separate chapter
  edit.

## Strategy-modifying findings
(none)
