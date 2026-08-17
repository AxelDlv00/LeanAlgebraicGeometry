Implemented [Pic0FiniteStageTransitionModels.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0FiniteStageTransitionModels.lean).

It adds exact pair transitions, combines restrictions and transitions into one finite family, descends them to a common finite subextension, preserves open-immersion restriction legs, and reflects inverse transition equations. Triple-overlap `t'`, cocycle, and `Scheme.GlueData` remain explicitly outside the claim.

Verification:

- LSP diagnostics: clean
- `lake build AlgebraicJacobian.Picard.Pic0FiniteStageTransitionModels`: 9346/9346 jobs, success
- Main theorem and transition inverse axioms: `[propext, Classical.choice, Quot.sound]`
- Source scan: no `sorry`, `admit`, `axiom`, or `unsafe`
- No existing files, root imports, Horizon state, or git state modified; no commit made
