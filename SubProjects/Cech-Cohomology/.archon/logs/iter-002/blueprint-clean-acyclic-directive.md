# Blueprint Clean Directive

## Target chapter
blueprint/src/chapters/Cohomology_AcyclicResolution.tex

## Context
This chapter was just rewritten (iter-002) to route the acyclic-resolution comparison theorem
proofs through the comparison-of-resolutions / SES-acyclicity-propagation kernel instead of a
phantom `rightDerived`-level δ-functor. New blocks: a `\mathlibok` anchor
`lem:homology_long_exact_sequence` (`ShortComplex.ShortExact.homology_exact₃`) and a to-build
horseshoe block `lem:injective_resolution_of_ses`.

## Tasks
Apply your standard purity/citation/LaTeX pass. In particular:
- Strip any Lean-implementation leakage or project-history phrasing ("phantom δ-functor",
  "the project's proof deliberately follows a different route", "Mathlib-feasible", iter
  references) — recast as timeless mathematics. The mathematical reason the proof uses
  injective resolutions + the complex-level homology sequence is legitimate content; keep the
  MATH but drop any meta-commentary about Lean/Mathlib feasibility or what changed.
- Verify citation discipline on the Stacks-derived blocks (Tags 0157/015C/015D/015E/05TA from
  references/homological-acyclic-derived.tex). The `\mathlibok` anchors carry "Provided by
  Mathlib" lines, not external SOURCE quotes — that is correct, leave them.
- The horseshoe block is Archon-to-build (no external source); a prose pointer to Weibel is
  fine but it needs no verbatim quote.
