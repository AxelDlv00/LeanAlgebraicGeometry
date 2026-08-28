Read-only history handoff:

- Latest completed report: [0193/0002 report](/home/axel/LeanAlgebraicGeometry-Horizon/.archon-horizon/runs/0193/sessions/0002-horizon-fs-hartshorne/report.md). It landed sheaf/LRS, valuation/DVR, curve divisor/degree, and line-bundle foundations; the 2,594-job build passed without placeholders or project axioms.
- Interrupted `0181/0010` had already completed [Chapter2Sheaves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter2Sheaves.lean) and then stopped while investigating subsheaves and stalkwise exactness in Mathlib’s `Topology/Sheaves/Abelian.lean`. That exactness layer remains unfinished.
- Current intended frontier: sheaf consequences/exactness, principal divisors, and Picard/line-bundle APIs. There is no Hartshorne roadmap row; use task comments and hgraph.
- Current-session commit `f161d0c17f` has now added coefficient/effectivity and positive-degree lemmas to [Chapter4Curves.lean](/home/axel/LeanAlgebraicGeometry-Horizon/FormalizedSources/Curves/Hartshorne/HartshorneLib/Chapter4Curves.lean), so do not duplicate them.
- I-2067 remains open: most Lean declarations and frozen TeX nodes are still unlinked. Add only exact, source-faithful `\lean{}` bindings; do not broadly rewrite the frozen blueprint or mark partial coverage `\leanok`.

Pitfalls:

- `CurveDivisor` degree was deliberately restricted in `4c91211995` to proper smooth integral curves over an algebraically closed field. The earlier general form was corrected.
- The II.1 wrapper’s `germ` needs `[HasColimits C]`; an earlier duplicate root import was also removed.
- AJC’s `principal_degree_zero` is reusable as a proof pattern, but its algebraically closed assumptions are load-bearing and Hartshorne should not import AJC.
- Shared staging is polluted by hundreds of unrelated lock/tmp/index paths. Use explicit pathspec commits and do not clean live shared locks.
- Stale `.trace` without `.olean` can mislead diagnostics; check artifacts before blaming source.
- The standing `fs-hartshorne` task must remain running/queued after each verified unit.
