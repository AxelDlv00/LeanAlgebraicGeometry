## Progress

- Audited [Pic0RankOneAbelInverse.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneAbelInverse.lean:181): `rankOneAbelIso` is already sorry-free and kernel-clean.
- Audited [Pic0RankOneCanonicalEvaluation.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneCanonicalEvaluation.lean:259): `canonicalRankOneAbelIso` and `canonicalRankOneEvaluationDivisorData` are already sorry-free and kernel-clean.
- `lake env lean` passed for both owned files. `lean_verify` reports only `[propext, Classical.choice, Quot.sound]`; source warnings are pre-existing local-instance warnings.
- LSP diagnostics were attempted before edits but timed out during server initialization because of the import-heavy project. No files were modified and no commit was created.

## Blocker

There is no arbitrary-field `pic0_representableBy` declaration to prove. The available route remains conditional:

- [Pic0FiniteGaloisRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteGaloisRepresentable.lean:35) requires a finite-level `RepresentableBy` witness and `OrbitsInAffineOpen`.
- [Pic0FiniteStageStableAffineCover.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageStableAffineCover.lean:93) supplies only conditional finite-stage consumers.
- [Pic0SepClosedRepresentable.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0SepClosedRepresentable.lean:426) proves only the separably closed-field representer.
- [Pic0RepresentableColimit.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RepresentableColimit.lean:28) consumes an arbitrary locally-finitely-presented representer; it does not produce one.

The precise missing mathematics is finite-stage object/universal-equivalence descent, followed by the finite-level representative and orbit-affineness input. This matches ledger commit `c9b4c7c383`; I left the working tree untouched.
