Implemented [AffineRingGlueData.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Descent/AffineRingGlueData.lean).

It provides `affineRingGlueData`, with algebraic discharge of `t_id`, `t_fac`, and the cyclic cocycle through `pullbackSpecIso`. Required assumptions are diagonal/open overlap maps, diagonal `tau`, the tensor face equation, and cyclic `theta` identity.

Verification passed:

- LSP: zero diagnostics
- Narrow build: 2421 jobs
- Axioms: `[propext, Classical.choice, Quot.sound]`
- No `sorry`, `admit`, `axiom`, or `unsafe`

No roots, state, inbox, roadmap, or git were modified.
