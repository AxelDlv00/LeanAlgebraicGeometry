# Blueprint-writer directive — NEW chapter `Cohomology_HigherDirectImage.tex`

## Chapter
Create `blueprint/src/chapters/Cohomology_HigherDirectImage.tex` (this file only).

## Strategy context
Per the USER parallelism directive + the strategy-critic's "de-gate the engine foundations"
finding, the A.2.c representability engine foundations are being seeded for parallel prover
lanes, independent of the (separate) group-law substrate. `R^i f_*` (i≥1) is the single
deepest un-blueprinted root: CM-regularity, semicontinuity, and the FGA m-regularity bound all
depend on it. This chapter blueprints it so a future prover lane can scaffold + attack it.

Declare coverage at the top:
`% archon:covers AlgebraicJacobian/Cohomology/HigherDirectImage.lean`

## Required content (follow this skeleton; classical cohomology-sheaf formulation, NOT derived
## category; Čech approach to match `Cohomology_FlatBaseChange`)

1. `\definition{def:higher_direct_image}` — `R^i f_* \mathcal{F}` as the i-th right derived
   functor of pushforward for a quasi-coherent `\mathcal{F}` on a quasi-compact quasi-separated
   `f : X → S`. `\lean{AlgebraicGeometry.higherDirectImage}` [expected].
2. `\lemma{lem:higher_direct_image_quasi_coherent}` — `R^i f_*\mathcal{F}` is quasi-coherent
   (`f` qcqs, `\mathcal{F}` qc). `\lean{AlgebraicGeometry.higherDirectImage_isQuasiCoherent}`.
   Source: Stacks Tag 02KE.
3. `\lemma{lem:higher_direct_image_affine_vanishing}` — for `f` affine and `i ≥ 1`,
   `R^i f_*\mathcal{F} = 0`. `\lean{AlgebraicGeometry.higherDirectImage_affine_eq_zero}`.
   Source: Stacks Tag 02KG.
4. `\theorem{thm:flat_base_change_higher}` — flat base change for `R^i f_*`: the canonical map
   `g^*(R^i f_*\mathcal{F}) → R^i f'_*(g'^*\mathcal{F})` is an iso when `g` is flat.
   `\lean{AlgebraicGeometry.flatBaseChange_higherDirectImage_isIso}`. Source: Stacks Tag 02KH
   (i≥1 case).

`\uses` skeleton:
- `thm:flat_base_change_higher` uses `lem:higher_direct_image_quasi_coherent`,
  `def:higher_direct_image`, `def:pushforward_base_change_map` (from `Cohomology_FlatBaseChange`).
- `lem:higher_direct_image_affine_vanishing` uses `def:higher_direct_image`.
- `lem:higher_direct_image_quasi_coherent` uses `def:higher_direct_image`.

Proof strategy (in the theorem's proof prose): reduce flat base change to the affine-target
case via quasi-coherence of `R^i f_*`; in the affine case reduce to algebra via the Čech
complex (as in the i=0 case); use flatness of `g` to commute `- ⊗_A B` through Čech cohomology.

## Citation discipline
Quote verbatim from `references/stacks-coherent.tex` (Tags 02KE, 02KG, 02KH — Cohomology of
Schemes). Each block gets `% SOURCE: <tag> (read from references/stacks-coherent.tex)` +
`% SOURCE QUOTE:` verbatim + a visible `\textit{Source: …}` line. You have `references/**` in
write-domain for a child retriever if needed; otherwise quote only what is on disk.

## Out of scope
- Do NOT write CMRegularity or SemiContinuity (separate chapters, deferred).
- Do NOT add `\leanok`/`\mathlibok`.
- Do NOT edit other chapters or `content.tex` (the planner wires the `\input`).
