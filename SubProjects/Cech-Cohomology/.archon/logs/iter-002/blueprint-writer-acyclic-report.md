# Blueprint Writer Report

## Slug
acyclic

## Status
COMPLETE

All six required items were addressed. The chapter still proves "an acyclic resolution
computes $R^nG$", but every proof now rests only on (a) the three existing faithful
Mathlib anchors, (b) a new `\mathlibok` anchor for the complex-level homology long exact
sequence / connecting map, and (c) an explicitly-declared to-build horseshoe sub-lemma.
No proof references a non-existent `rightDerived`-level $\delta$-functor.

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex

## Changes Made

- **Added Mathlib dependency anchor** `\lemma`/`\label{lem:homology_long_exact_sequence}`/
  `\lean{CategoryTheory.ShortComplex.ShortExact.homology_exact₃}`/`\mathlibok` — the
  complex-level homology long exact sequence and connecting map $\delta$ for a short exact
  sequence `0 → S.X₁ → S.X₂ → S.X₃ → 0` of cochain complexes (`HomologicalComplex`) in an
  abelian category. Prose names `ShortComplex.ShortExact.δ`. **Verified via loogle**: the
  name exists in `Mathlib.Algebra.Homology.HomologySequence` with a matching signature
  (exactness of `Hⁱ(S.X₂) → Hⁱ(S.X₃) →^δ Hʲ(S.X₁)` with `hS.δ i j hij` as connecting map),
  so the `\mathlibok` mark is faithful.

- **Added to-build declaration block (horseshoe lift)** `\lemma`/
  `\label{lem:injective_resolution_of_ses}`/
  `\lean{CategoryTheory.InjectiveResolution.ofShortExact}` [speculative — confirm-or-rename
  at scaffold time] — given `0→A→B→C→0` exact, there exist injective resolutions and a
  **degreewise-split** short exact sequence of complexes `0→I_A→I_B→I_C→0` with
  `I_B^n ≅ I_A^n ⊕ I_C^n`. New section "Lifting a short exact sequence to injective
  resolutions" introduces it as the single genuinely-new project obligation. Informal proof
  is the dual Horseshoe Lemma (degreewise direct sums + injective lifting). Weibel,
  *An Introduction to Homological Algebra*, Lemma 2.2.8 is mentioned in prose only as a
  pointer (no `% SOURCE QUOTE` / `\textit{Source:}` apparatus — Weibel is not in
  `references/`, and this is an Archon-to-build result for which no external verbatim quote
  is required). `\uses{lem:right_derived_injective_resolution}` (statement + proof).

- **Recast** `lem:acyclic_dimension_shift` (kernel: SES-acyclicity-propagation) — kept the
  statement, its `\label`, `\lean{CategoryTheory.Functor.rightDerivedShiftIsoOfAcyclic}`,
  and the verbatim Stacks Tag 015D statement quote. **Replaced the proof body**: it now
  *constructs* the `rightDerived`-level long exact sequence by (i) horseshoe-lifting
  `0→A→J→Z→0` to a degreewise-split SES of injective resolutions, (ii) applying the additive
  $G$ degreewise (degreewise-splitness ⇒ `0→G(I_A)→G(I_J)→G(I_Z)→0` is still a SES of
  complexes even though $G$ is not exact), (iii) reading off the homology LES via
  `lem:homology_long_exact_sequence`, and (iv) identifying `Hⁿ(G(I_•)) ≅ (RⁿG)(•)` via
  `isoRightDerivedObj` (`lem:right_derived_injective_resolution`). Acyclicity of $J$ then
  kills the relevant terms, giving the shift isos (k≥1) and the `(R¹G)(A) ≅ coker` identity.
  Proof `\uses{def:right_acyclic, lem:right_derived_zero_iso_self,
  lem:right_derived_injective_resolution, lem:homology_long_exact_sequence,
  lem:injective_resolution_of_ses}`.
  - **Removed the Stacks Tag 015D `% SOURCE QUOTE PROOF:`** (the $D^+$ $\delta$-functor
    argument). The project's proof deliberately follows a different, Mathlib-feasible route,
    so transcribing the source's proof would misrepresent what is formalized. Replaced it
    with an explanatory `%` comment recording why the route differs and that no external
    verbatim proof quote is attached. The statement quote (Tag 015D) is preserved.

- **Rewrote the proof of** `lem:acyclic_resolution_computes_derived` — the staircase
  dimension-shift is now the main proof body (it already was, in substance). Folded the old
  closing "Remark on the base case and the Mathlib seed" (which invoked the phantom
  `rightDerived`-level $\delta$-functor) into an honest closing paragraph that grounds every
  long exact sequence used on the kernel → horseshoe + complex-level homology LES →
  `isoRightDerivedObj` chain. Updated both statement-level and proof-level `\uses{}` to add
  `lem:homology_long_exact_sequence` and `lem:injective_resolution_of_ses` alongside the
  kernel and the existing anchors.

- **Kept unchanged**: `def:right_acyclic` and the three existing faithful Mathlib anchors
  (`lem:right_derived_injective_resolution`, `lem:right_derived_vanishes_injective`,
  `lem:right_derived_zero_iso_self`) — including their `\lean{}` targets and Stacks quotes.

## Cross-references introduced
- `\uses{lem:homology_long_exact_sequence}` in `lem:acyclic_dimension_shift` (proof) and
  `lem:acyclic_resolution_computes_derived` (statement + proof) — target is the new anchor
  in this same chapter.
- `\uses{lem:injective_resolution_of_ses}` in the same two blocks — target is the new
  horseshoe block in this same chapter.
- `\uses{lem:right_derived_injective_resolution}` added to `lem:acyclic_dimension_shift`
  proof and `lem:injective_resolution_of_ses` (existing anchor in this chapter).

leandag verification: `unknown_uses: []`, no isolated blueprint blocks from this chapter
(the only 4 isolated nodes are pre-existing `lean_aux` declarations with no blueprint
counterpart). 11 `\begin`/11 `\end`; no bare `REF`; no interleaved math delimiters.

## References consulted
- `references/homological-acyclic.md` — contents map / tag index for the Stacks sources.
- `references/homological-acyclic-derived.tex` (Stacks derived.tex) — re-read Tags 015C
  (L5594), 015D (L5619, statement quote preserved), 015E (Leray, L5692) and 05TA
  (proposition-enough-acyclics proof L5813) to ground the recast kernel and the staircase
  proof. The 015D statement quote already in the chapter was checked against L5619–5636.

## Macros needed (if any)
None. The chapter uses only standard commands (`\operatorname`, `\ker`, `\oplus`, `\cong`,
`\xrightarrow`) already in use elsewhere.

## Reference-retriever dispatches (if any)
None — all needed source material was already local.

## Notes for Plan Agent
- **Speculative Lean names to confirm at scaffold time**: `lem:homology_long_exact_sequence`
  → `CategoryTheory.ShortComplex.ShortExact.homology_exact₃` is **verified to exist** (loogle,
  module `Mathlib.Algebra.Homology.HomologySequence`); the full LES is assembled from
  `homology_exact₁/₂/₃` + `.δ`, so the scaffolder may need the sibling lemmas too.
  `lem:injective_resolution_of_ses` → `CategoryTheory.InjectiveResolution.ofShortExact` is a
  **guess for a to-build declaration** (Mathlib does not appear to ship the horseshoe lift);
  rename if a different convention is chosen when `AcyclicResolution.lean` is scaffolded.
- The horseshoe lift (`lem:injective_resolution_of_ses`) is the one genuinely-novel project
  dependency. Its informal proof sketch references the complex-level homology LES anchor for
  the exactness check; that creates a `\uses` edge from the horseshoe into the homology
  anchor only implicitly (I wired the horseshoe's `\uses` to
  `lem:right_derived_injective_resolution` for the resolution machinery). If the scaffolder
  wants the exactness-via-LES edge recorded, add `lem:homology_long_exact_sequence` to the
  horseshoe's `\uses` — I left it out to avoid a circular-looking edge, since in practice the
  horseshoe construction does not need to be proved *via* the LES (the direct-sum
  construction is acyclic by inspection).
- Cross-chapter: `Cohomology_CechHigherDirectImage.tex` (edited by a separate writer this
  iter) applies this theorem with `G = f_*`. I did not touch it. Its `\uses` of
  `lem:acyclic_resolution_computes_derived` remains valid — only the proof internals here
  changed, not the theorem statement or its `\lean{}` target.

## Strategy-modifying findings
None. The recast confirms the strategy-critic's picture: the SES-acyclicity-propagation
kernel is buildable from Mathlib's complex-level homology LES + an isoRightDerivedObj
identification, with the horseshoe as the sole new construction. The chapter now records that
gap honestly rather than resting on a phantom `rightDerived`-level $\delta$-functor.
