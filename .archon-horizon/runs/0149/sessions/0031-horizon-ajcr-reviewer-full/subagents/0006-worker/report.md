Implemented [Pic0FiniteStageGluingBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageGluingBaseChange.lean) with:

- `baseChangeGluingIso`
- `gluingChartIso`
- `overlapBaseChangeIso`

Verification:

- Pre-edit target LSP: file absent as expected; imported `Pic0FiniteStageChartBaseChange.lean` had zero diagnostics.
- Post-edit/final LSP: zero diagnostics.
- `lake build AlgebraicJacobian.Picard.Pic0FiniteStageGluingBaseChange`: exit 0, built 9376 jobs in 62s. Imported modules emitted pre-existing warnings; none came from the new file.
- All three declarations depend exactly on `propext`, `Classical.choice`, and `Quot.sound`; no `sorryAx`.
- Source scan found no `sorry`, `admit`, or `axiom`.

No other file was edited, and no commit was made.
