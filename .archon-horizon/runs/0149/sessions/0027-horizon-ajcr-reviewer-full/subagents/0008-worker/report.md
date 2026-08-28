Implemented [TensorProductPushoutBaseChange.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/TensorProductPushoutBaseChange.lean).

It provides the commutative-ring `K`-algebra equivalence, forward/inverse homomorphisms, and pure-tensor computation lemmas without field or flatness assumptions.

Verification passed:

- Narrow build: 1250 jobs
- LSP diagnostics: clean
- Axioms: `[propext, Classical.choice, Quot.sound]`
- No `sorry`, `admit`, `axiom`, or `unsafe`
- `git diff --check`: clean

No commit or integration-root edits were made.
