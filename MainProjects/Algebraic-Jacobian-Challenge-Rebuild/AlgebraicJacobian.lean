import AlgebraicJacobian.Curve.GeometricallyReduced
import AlgebraicJacobian.Curve.Basic
import AlgebraicJacobian.Curve.Sections
import AlgebraicJacobian.Curve.P1
import AlgebraicJacobian.Curve.P1Charts
import AlgebraicJacobian.Curve.MapToP1
import AlgebraicJacobian.Cohomology.ModuleKSheaf
import AlgebraicJacobian.Cohomology.AffineCech
import AlgebraicJacobian.Cohomology.AffineVanishing
import AlgebraicJacobian.Challenge

/-!
# AlgebraicJacobian — library root

Aggregator for the Jacobian-challenge rebuild. The single statement file
`AlgebraicJacobian.Challenge` fixes the mathematician-owned signatures; every other module
added here builds the infrastructure that discharges them. Keep this import list in
dependency order and keep each imported file under 500 lines.
-/
