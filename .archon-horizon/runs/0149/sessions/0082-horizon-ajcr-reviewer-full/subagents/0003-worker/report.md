I couldn’t close any of the headline `sorry`s kernel-cleanly.

Blocker: every usable Jacobian producer I checked (`JacobianData`, `JacobianDataAbel`, `JacobianDataBaseChange`, `JacobianDataBaseChangeAbel`, `Pic0SepClosedJacobianData`, etc.) reaches `AlgebraicJacobian.Challenge` again through the degree/Riemann–Roch chain, so importing them into [`AlgebraicJacobian/Challenge.lean`](AlgebraicJacobian/Challenge.lean) would create a cycle. The current import graph shows paths like:

`Picard/JacobianData.lean → Picard/Pic0Functor.lean → RiemannRoch/… → Challenge.lean`

So the needed statements already exist in the datum layer, but not in a form that can be pulled back into the statement file without circularity.

I also checked that the nearby producer files are already `sorry`/`axiom`-free at source level; the obstacle is import structure, not missing proof text.

No files were changed, so there’s nothing to commit.
