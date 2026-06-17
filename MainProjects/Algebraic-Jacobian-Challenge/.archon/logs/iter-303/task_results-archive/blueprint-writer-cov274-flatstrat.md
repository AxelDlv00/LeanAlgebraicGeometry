# Blueprint Writer Report

## Slug
cov274-flatstrat

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_FlatteningStratification.tex

## Changes Made
Added a new subsection `\subsection{Lean-side encodings of the sub-lemmas}`
(`\label{sec:flatstrat_lean_helpers}`) just before `\section{Universal property
of the strata}`, holding three additive coverage blocks — one per uncovered
lean-aux node. No external-source citation blocks were added (these are internal
project helpers, as the directive specified). No existing prose was rewritten.

- **Added lemma** `\lemma`/`\label{lem:flat_locus_stratification_lean}`/`\lean{AlgebraicGeometry.flatLocusStratification}`
  — the special case `n = 0`: an `ℕ`-indexed family of immersions `ι_e : S_e → S`,
  pairwise disjoint, covering `|S|`, with `ι_e^* F` flat over each `S_e`.
  - Proof body: "Proved directly in Lean." (proof env present, not an ∞ hole)
  - Statement-level `\uses{def:coherent_sheaf_flat}`.
- **Added lemma** `\lemma`/`\label{lem:flat_locus_reduction_lean}`/`\lean{AlgebraicGeometry.flatLocusReduction}`
  — the Noetherian-induction reduction: finitely many immersions `ι_i : V_i → S`,
  disjoint, covering `|S|`, with `F` flat on `X ×_S V_i`.
  - Proof body: "Proved directly in Lean."
  - Statement-level `\uses{def:coherent_sheaf_flat, thm:generic_flatness}`.
- **Added lemma** `\lemma`/`\label{lem:flat_locus_assembly_lean}`/`\lean{AlgebraicGeometry.flatLocusAssembly}`
  — the assembly step: finite index set `I`, immersions `ι_f : S_f → S`, disjoint,
  covering, with injective polynomial label `P : I → (ℕ → ℤ)` and `F` flat on each
  `X ×_S S_f`.
  - Proof body: "Proved directly in Lean."
  - Statement-level `\uses{def:coherent_sheaf_flat, lem:flat_locus_stratification_lean, lem:flat_locus_reduction_lean}`.

## Cross-references introduced
All statement-level `\uses{}` resolve (leandag reports zero `unknown_uses` for the
new labels):
- `lem:flat_locus_stratification_lean` → `def:coherent_sheaf_flat` (covered, real Lean).
- `lem:flat_locus_reduction_lean` → `def:coherent_sheaf_flat`, `thm:generic_flatness` (both covered, real Lean).
- `lem:flat_locus_assembly_lean` → `def:coherent_sheaf_flat`, `lem:flat_locus_stratification_lean`, `lem:flat_locus_reduction_lean`.

Each new block carries an outgoing statement-level edge to an already-covered
node, so none is isolated. `leandag query --isolated --chapter
Picard_FlatteningStratification` returns 0 results after the edit. No existing
consumer block needed a `\uses{}` hoist (the new blocks self-connect to covered
nodes).

## Verification (leandag)
- `leandag build --json`: all three target lean-aux nodes
  (`AlgebraicGeometry.flatLocusStratification`, `.flatLocusReduction`,
  `.flatLocusAssembly`) now carry chapter "Flattening Stratification of a Coherent
  Sheaf" — uncovered lean-aux count for the file dropped to zero.
- No `unknown_uses` entries for any new label.
- Project-wide isolated count dropped 160 → 151; the chapter has zero isolated nodes.

## References consulted
None — internal project helpers, no external source (per directive). No citation
blocks were written.

## Macros needed (if any)
None. Used only existing `\F`, `\OO`, `\Z`, `\Q`, `\cref` and core `\mathbb{N}`.

## Notes for Plan Agent
- Two pre-existing blocks in this chapter still pin non-existent Lean names and
  show up in leandag `unmatched_lean` (out of scope for this directive):
  `lem:flat_locus_open` → `AlgebraicGeometry.TODO.flatLocusOpen` and
  `lem:nonflat_locus_proper` → `AlgebraicGeometry.TODO.nonflatLocusProper`. These
  prose blocks are the math-source-cited mathematical statements of the same
  sub-lemmas now realised by the real Lean declarations
  `flatLocusStratification` / `flatLocusReduction`. A future cleanup could either
  re-pin those `TODO.*` blocks to the real names (merging) or leave the new
  Lean-helper blocks as the canonical `\lean{}` pins; I left both in place since
  re-pinning existing source-cited blocks was outside this directive's scope.
- `lem:noetherian_induction_strata` likewise pins `TODO.noetherianInductionStrata`
  (the assembly step now realised by `flatLocusAssembly`); same consideration.
