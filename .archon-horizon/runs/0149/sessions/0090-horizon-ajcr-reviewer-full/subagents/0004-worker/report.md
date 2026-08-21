Implemented [FiniteGaloisQuotientGeometry.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/FiniteGaloisQuotientGeometry.lean) with:

- `IsGaloisQuotient.locallyOfFiniteType` via fpqc descent along `Spec L ⟶ Spec K`.
- `IsGaloisQuotient.quasiCompact` via compactness of `X` and the surjective projection `w.e.inv ≫ pullback.fst g p`.

Verification passed:

- LSP diagnostics: clean before prototyping and after the edit.
- `lake env lean AlgebraicJacobian/Descent/FiniteGaloisQuotientGeometry.lean`
- `lake build AlgebraicJacobian.Descent.FiniteGaloisQuotientGeometry` (`2908/2908`)
- Both theorems have axioms exactly `[propext, Classical.choice, Quot.sound]`.

The file is untracked and uncommitted as requested.
