## Progress

- AJC has no `Challenge.lean`; its headline is [Jacobian.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Jacobian.lean:848).
- The AJC headline still reaches five open leaves: FGA representability, geometric reducedness, universal closedness, relative dimension, and Albanese. Each kernel query reports `[propext, sorryAx, Classical.choice, Quot.sound]`.
- AJCR’s `rankOneAbelIso`, canonical rank-one iso, separably closed representer, separably closed `JacobianData`, and conditional finite-Galois descent all query clean with exactly `[propext, Classical.choice, Quot.sound]`.
- No declaration named `pic0_representableBy` exists. The arbitrary-field endpoint remains only a target named in [Pic0CriticalPath.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0CriticalPath.lean:292).
- Commit `679c29ec6d` added a clean, root-reachable H-quasi-projective orbit-affineness theorem, but it currently has no consumer and closes no headline leaf.

## Issues

Recent AJCR commits close the conditional path from an exact finite-stage representation and immersion to descended representability. They still do not produce either required input. Descended quotient LFT/QC certificates are also absent, so bare representability does not yet yield arbitrary-field `JacobianData`.

AJCR representability cannot directly discharge AJC’s FGA leaf: AJCR represents the degree-zero functor with LFT/QC, while AJC requests the full étale Picard functor with LFT/separatedness. Both projects also declare the same Lake package and module namespace.

The direct AJCR wiring is import-cyclic:

`Challenge → Pic0CriticalPath → DivRepAffChallenge → ChiCurve → Challenge`.

## Next

Finish the exact finite-stage representation and immersion, descend LFT/QC, and construct one arbitrary-field `jacobianData`. Then split foundational `Curve`/`genus`/`baseChange` declarations out of AJCR `Challenge.lean` before replacing its projection-level sorries. Port or extract that endpoint into AJC; smoothness dimension, properness, geometric irreducibility, and Albanese remain independent mathematics.

No files were edited and no full build was run; verification used narrow cached kernel queries only.
