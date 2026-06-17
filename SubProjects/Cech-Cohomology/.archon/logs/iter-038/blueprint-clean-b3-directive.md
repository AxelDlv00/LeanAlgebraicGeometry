# Blueprint-clean directive — iter-038

A blueprint-writer round just edited `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
(Route B section). Clean ONLY that chapter.

## What changed (focus your purity pass here)
- New blocks near the "Route B: Mathlib dependency anchors" section: `lem:overEquivalence_mathlib`
  (`\mathlibok` anchor) and `lem:overEquivalence_isContinuous` (project block, 4-decl pin).
- Expanded proof sketch of `lem:restrict_over_compat` (B3) with a B3a/B3b/B3c decomposition.
- Tightened `\uses` of the `lem:presentation_over_basicOpen` (B2) proof block.
- Bundled `coversTop_iSup_eq_top` into `lem:qcoh_finite_presentation_cover`'s `\lean{}`.

## Your job
Strip any Lean syntax leakage (tactic strings, Lean identifiers used as prose where math notation belongs),
project-history/iteration verbosity, or non-mathematical scaffolding the writer may have introduced in the
edited region. The B3 sketch necessarily NAMES some Lean-side constructions (`appIso`, `restrictFunctor`,
`pushforwardPushforwardEquivalence`, `basicOpenIsoSpecAway`, `restrict_obj`) because they are the precise
mathematical bridge data the prover must realize — these named-construction references are acceptable and
SHOULD be kept (they are dependency anchors, not tactic leakage). Remove only genuine Lean *tactic* strings
or verbose project-narrative. Verify every `\uses{}`/`\ref{}` in the edited region resolves to a label that
exists in the chapter. Do NOT touch `\leanok`/`\mathlibok` markers.
