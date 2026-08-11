## Progress

- Added [AwayNaturality](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducerAwayNaturality.lean), proving canonical-away compatibility from actual local equations. Final commit: `ea93364818`.
- Added [FiniteGlue](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducerFiniteGlue.lean), gluing the actual rank-one evaluation divisors over a finite Noetherian presentation cover. Commit: `a04e410147`.
- Narrow Lean replays passed without warnings. Axiom audits contain only `propext`, `Classical.choice`, and `Quot.sound`.
- Recorded the blocked status, roadmap pins, and integration handoff through `I-1927` in metadata commit `27762bcdfb`.

## Issues

The arbitrary-scheme `PicRankOneOpen.FibrePresented` producer is not yet constructed. The remaining gap is genuine descent and presentation independence over the étale presentation overlap `B ⊗[A] B`. The current certification route also fundamentally uses Noetherian induction.

The existing [conditional assembly](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0RankOneFibrePresentedProducer.lean) consumes a genuine pullback square and immediately invokes `picRankOneOpen_isOpen_of_fibrePresented`, but does not produce that square.

## Why I Stopped

The task is genuinely blocked at the descent boundary. I did not assume `FibrePresented`, introduce a fieldwise witness, or modify protected files. No full project build was run.

## Next

Prove common-refinement/faithfully-flat descent for the glued intrinsic divisor, replace the Noetherian-only certification step for arbitrary rings, then instantiate `EvaluationDivisorPullback` and discharge `picRankOneOpen_isOpen_of_fibrePresented`.
