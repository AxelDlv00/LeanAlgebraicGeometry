U2 is closed and durable in the roadmap (`status: done`, owner cleared). The swallowed-cover descent now supplies:

- `Module.Invertible` over the widened equalizer algebra.
- Finite, projective, and constant-rank `g` results for the exact `divisorWindow` quotient consumed by the frame layer.

The implementation is split under the 500-line rule:

- [DivisorFamilyAffThetaSwallowed.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffThetaSwallowed.lean:459)
- [DivisorFamilyAffThetaSwallowedWindow.lean](/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/DivisorFamilyAffThetaSwallowedWindow.lean:95)

Verified with `lake build AlgebraicJacobian.Picard.DivisorFamilyAffThetaSwallowedWindow` (8,975 jobs), LSP diagnostics on both files, axiom checks containing only `propext`, `Classical.choice`, and `Quot.sound`, and no `sorry`/`admit`/`axiom` tokens. Both files are 489 and 152 lines respectively.

Commits include `f7e07698ac`, `f22c22140c`, `7547ec76d0`, and `ac2b493f57`; the roadmap pins the relevant proof and integration commits. The full `RepresentableBy` endpoint and frame/classifier composition remain downstream work; the current `SwallowedBy` witness still needs to be carried into that route. The aggregate build was not completed because it was blocked by another lane’s concurrent `Pic0RepresentabilityOverlap.lean` compilation.
