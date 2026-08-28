Implemented and committed the corrected curve-divisor unit.

- `4c91211995`: `Chapter4Curves.lean`
- Defines general `PointDivisor` and restricted `CurveDivisor k X` for algebraically closed, integral, smooth relative-dimension-one, proper curves.
- Adds inherited additive/order structures, unweighted `degree`, `degreeHom`, and the requested zero/add/neg/sub/single lemmas.
- LSP diagnostics clean.
- Foreground `lake env lean HartshorneLib/Chapter4Curves.lean` passed.
- No `sorry`, `admit`, or project axioms; ledger path/content verification passed.
