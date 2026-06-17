# lean-vs-blueprint-checker — GrassmannianCells (iter-035)

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_GrassmannianCells.tex

Report:
(a) Lean -> blueprint: any fake/placeholder statement, signature mismatch with a \lean{} pin,
    or new declaration with no blueprint block (1-to-1 coverage debt). The iter-035 additions to
    this file are new and may be uncovered.
(b) blueprint -> Lean: any \lean{} pin pointing at a non-existent / renamed declaration, any block
    whose informal proof is too thin to have guided the formalization, broken \uses{}.

Specifics for this file:
- New decls (7) under sec:gr_proper have no blueprint blocks yet. lem:gr_proper pins \lean{...isProper} which is NOT built (reduced to ValuativeCriterion.Existence). Confirm the pin is honestly unbuilt and list the coverage gaps.
