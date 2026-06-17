# lean-auditor — iter-031

Audit the following Lean files as Lean (no strategy bias). Report per-file checklist
(outdated comments, suspect/circular definitions, dead-end proofs, bad practice,
docstrings that overstate "sorry-free" when a decl is transitively sorry-backed) plus
a flagged-issues block with severities.

Files (absolute paths):
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/GrassmannianCells.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
- /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Cohomology/FlatBaseChange.lean

Focus areas:
- GrassmannianCells.lean: 8 new decls this iter — `cocyclePhiId`, `chartTransition'_cocycle`,
  `theGlueData`, `scheme`, and private helpers `rotMid`, `transitionInvImageMatrix`,
  `transitionInvPair`, `awayMulCommEquiv_comp_awayInclLeft`. Verify the cocycle/glue proofs are
  genuine (not `sorry`/`admit`/circular), and that `scheme := (theGlueData).glued` is honest.
  Note: `chartTransition'_cocycle` uses `set_option maxHeartbeats 1600000` — flag if abused.
- QuotScheme.lean: 4 new defs `overRestrictEquiv`, `overRestrictFunctorIso`, `overRestrictIso`,
  `overRestrictPullbackIso`. Verify genuine, axiom-clean, non-circular. The 4 pre-existing
  `sorry` stubs (hilbertPolynomial @123, QuotFunctor @161, Grassmannian @198,
  Grassmannian.representable @225) are known/out-of-scope.
- FlatBaseChange.lean: 4 sorries remain (`_legs` @~1472, `gstar_transpose` @~1844, affine @~2025,
  FBC-B @~2047). Check the `_legs` proof advance (a new `simp only` before the sorry) is not a
  no-op or a misleading docstring. Verify "transitively sorry-backed" disclaimers are accurate.
