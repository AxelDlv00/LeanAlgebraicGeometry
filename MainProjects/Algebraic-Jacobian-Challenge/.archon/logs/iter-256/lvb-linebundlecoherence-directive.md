# lean-vs-blueprint — LineBundleCoherence.lean (iter-256)

Lean file (NEW this iter):
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/LineBundleCoherence.lean

Blueprint chapter (NEW this iter):
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Picard_LineBundleCoherence.tex

This is a fresh file-skeleton: 5 declarations as `sorry` stubs. Verify bidirectionally:
(a) each of the 5 Lean signatures matches its blueprint `\lean{...}` pin and the
    blueprint statement:
    - `IsLocallyTrivial.exists_trivializing_cover` (lem:lbc_trivializing_cover)
    - `IsLocallyTrivial.chartPresentation` (lem:lbc_chart_presentation)
    - `IsLocallyTrivial.isFinitePresentation` (thm:lbc_isFinitePresentation)
    - `IsLocallyTrivial.isFiniteType` (cor:lbc_isFiniteType)
    - `IsLocallyTrivial.chart_free_rank_one` (lem:lbc_rank_flat)
(b) is the blueprint chapter detailed enough to guide the PROOFS next iter (the bodies
    are all sorry now)? In particular: does the chapter give a real argument for
    `isFinitePresentation` (the main theorem), or only a statement? Flag any block whose
    prose is too thin to formalize.
(c) the prover flagged a possible missing 6th decl: `chartPresentation` finiteness
    (`(chartPresentation …).IsFinite`) is needed by `isFinitePresentation` but is not in
    the 5-pin set. Does the blueprint address where finiteness comes from?
