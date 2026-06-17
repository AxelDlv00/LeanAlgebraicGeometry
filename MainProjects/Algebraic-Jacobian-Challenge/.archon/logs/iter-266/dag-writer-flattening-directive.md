# Blueprint-writer directive — Picard_FlatteningStratification.tex

## Target file
`blueprint/src/chapters/Picard_FlatteningStratification.tex`

## Problem (why dispatched)
`thm:flattening_stratification_exists` (≈L204) is a leandag **∞-node**: it has a
full three-part statement (Nitsure §4) and the chapter splits the proof into
sub-lemmas below it, but the **theorem environment has no `\begin{proof}`
block**, so leandag sees an empty proof body. Add a `\begin{proof}` that
assembles the existing sub-lemmas into a coherent informal proof with a complete
`\uses{}` set.

## What to do
- Insert a `\begin{proof} ... \end{proof}` for
  `thm:flattening_stratification_exists` (immediately after `\end{theorem}`, or
  after the short "The proof is long; we split it into sub-lemmas below"
  paragraph while still attaching to the theorem).
- The proof should follow the chapter's own decomposition: the special case
  `n = 0` (`lem:flat_locus_open`), the non-flat-locus properness
  (`lem:nonflat_locus_proper`), the Noetherian-induction reduction
  (`lem:noetherian_induction_strata`), generic flatness (`thm:generic_flatness`
  / `thm:generic_flatness_algebraic`), and the cohomology/base-change inputs the
  chapter names (uniform higher-cohomology vanishing of `\F(m)` for `m ≫ 0`, and
  base-change isomorphisms for `\pi_* \F(m)`). Assemble parts (i) finiteness of
  the Hilbert-polynomial set, (ii) existence + universal property of the strata,
  (iii) closure-of-strata ordering — each citing the matching sub-lemma.
- `\uses{}` must list every label invoked. Inspect the chapter and include the
  exact sub-lemma labels: `lem:flat_locus_open`, `lem:nonflat_locus_proper`,
  `lem:noetherian_induction_strata`, `thm:generic_flatness`, plus any
  cohomology/base-change lemma labels present (and `def:coherent_sheaf_flat`).

## Hard constraints
- Purely mathematical prose; no Lean code/tactics.
- **Do NOT add `\leanok`.**
- Do not change the theorem statement or any `% SOURCE`/`% SOURCE QUOTE` block.
- Faithfully follow Nitsure §4; do not invent steps absent from the chapter's
  sub-lemma decomposition.

## References (already cited in-chapter; cite verbatim)
- `references/nitsure-hilbert-quot-src/nitsure-hilbert-quot.tex` — §4
  "flattening stratification" theorem (L1811–1841) and its proof sub-parts
  (L1849+).
- Parallel pointer: Stacks tag 052H (text not bundled; keep the existing
  pointer comment, do not fabricate a quote).

## Out of scope
- Do not touch other chapters.
- Do not modify the sub-lemma statements themselves; only add the assembling
  proof to the top-level existence theorem (and, if any sub-lemma the proof
  depends on is itself an empty-proof ∞-node, add a short proof there too —
  but only if it blocks the assembly; report any such case).
