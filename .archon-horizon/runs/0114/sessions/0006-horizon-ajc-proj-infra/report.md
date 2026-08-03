Implemented and committed the demanded Grassmannian projective infrastructure:

- Plücker charts, gluing, local/global immersion: [Projective modules](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Projective/GrassmannianPlucker.lean:34)
- Relative projective-space lift and projectivity/HQP over `Spec Z`: [GrassmannianProjective.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Projective/GrassmannianProjective.lean:31)
- Unconditional field-representer HQP consumer: [Grassmannian.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Projective/Grassmannian.lean:131)
- Demand ledger now points directly to real producers: [DemandLedger.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Projective/DemandLedger.lean:105)

Commits: `0c8cd28814`, `a2a9285bfe`, `2273350a86`, `11ca92188a`, `650b9f291c`, `b1204b49ff`, `66d774585c`.

Verification passed:

- `lake build AlgebraicJacobian.Projective.DemandLedger` completed successfully, 8,786 jobs.
- `#print axioms` checked all 29 declarations. All use only `propext`, `Classical.choice`, and `Quot.sound`, except the explicitly open `pointedPicSharpQuasiProjectivePieces_demand`, which has `sorryAx`.
- Reviewer independently accepted the source, roadmap, and exact 13-node graph checkpoints.
- A clean private-index audit found zero owned disk/HEAD deltas at captured HEAD `80e43977a6`; all seven commits are ancestors.
- The polluted shared index remains untouched. The full umbrella build was not run.

The Grassmannian leaf and ledger rows are done. Relative Proj and ampleness remain consumer-gated, and existing `IsHQuasiProjectiveWith` remains the very-ample vocabulary. The parent stays active only for the independent pointed-Picard representation producer; geometric producer movement is `+1`, strict PicEt and seam movement remain `+0`.
