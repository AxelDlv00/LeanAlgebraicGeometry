# lean-vs-blueprint-checker — QuotScheme (iter-035)

Bidirectionally verify ONE Lean file against ONE blueprint chapter.

- Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

Report:
(a) Lean -> blueprint: any fake/placeholder statement, signature mismatch with a \lean{} pin,
    or new declaration with no blueprint block (1-to-1 coverage debt). The iter-035 additions to
    this file are new and may be uncovered.
(b) blueprint -> Lean: any \lean{} pin pointing at a non-existent / renamed declaration, any block
    whose informal proof is too thin to have guided the formalization, broken \uses{}.

Specifics for this file:
- New keystone isLocalizedModule_basicOpen_descent_of_cover (non-private) is NOT covered: the block lem:section_localization_descent pins \lean{...isLocalizedModule_basicOpen_descent} (named form, NOT built). A review % NOTE was added (iter-035). Confirm the pin/coverage situation and flag the 5 private helpers' coverage status (private convention).
