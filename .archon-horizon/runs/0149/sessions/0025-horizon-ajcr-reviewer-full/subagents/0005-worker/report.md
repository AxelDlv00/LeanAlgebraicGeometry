## Progress

- Added [FinitePresentationAlgebraMapFiniteStage.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/FinitePresentationAlgebraMapFiniteStage.lean:26).
- Proved `DatG0.exists_finSubext_tensorProduct_algHom`.
- Requires only `[Algebra.FiniteType F A]`; `B` has no finiteness hypothesis.
- Produces a finite subextension `L`, a descended `L`-algebra map, and the commuting canonical base-change square.
- Added no root import and made no commit.

Verification:

- LSP diagnostics: clean.
- Module build: passed, 8705 jobs.
- Axioms: `[propext, Classical.choice, Quot.sound]`.
- Source scan: clean.
- Build warnings were pre-existing replay warnings in imported modules.
