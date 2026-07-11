import AlgebraicJacobian.Algebra.TwoLattice
import AlgebraicJacobian.Curve.GeometricallyReduced
import AlgebraicJacobian.Curve.Basic
import AlgebraicJacobian.Curve.Sections
import AlgebraicJacobian.Curve.P1
import AlgebraicJacobian.Curve.P1Charts
import AlgebraicJacobian.Curve.DedekindSections
import AlgebraicJacobian.Curve.StalksDVR
import AlgebraicJacobian.Curve.P1Points
import AlgebraicJacobian.Curve.RationalToP1
import AlgebraicJacobian.Curve.MapToP1
import AlgebraicJacobian.AbelianVariety.Rigidity
import AlgebraicJacobian.AbelianVariety.RigidityCorollaries
import AlgebraicJacobian.Cohomology.ModuleKSheaf
import AlgebraicJacobian.Cohomology.AffineCech
import AlgebraicJacobian.Cohomology.AffineVanishing
import AlgebraicJacobian.Cohomology.OverOpen
import AlgebraicJacobian.Cohomology.MayerVietoris
import AlgebraicJacobian.Cohomology.TwoCover
import AlgebraicJacobian.Cohomology.FinitenessP1
import AlgebraicJacobian.Cohomology.Finiteness
import AlgebraicJacobian.Cohomology.SectionsBaseChange
import AlgebraicJacobian.Picard.UniversalSections
import AlgebraicJacobian.Picard.UnitsPresheaf
import AlgebraicJacobian.Picard.CechH1
import AlgebraicJacobian.Picard.UnitsCocycle
import AlgebraicJacobian.Picard.Pic
import AlgebraicJacobian.Descent.ModuleDescent
import AlgebraicJacobian.Descent.InvertibleModule
import AlgebraicJacobian.Challenge

/-!
# AlgebraicJacobian — library root

Aggregator for the Jacobian-challenge rebuild. The single statement file
`AlgebraicJacobian.Challenge` fixes the mathematician-owned signatures; every other module
added here builds the infrastructure that discharges them. Keep this import list in
dependency order and keep each imported file under 500 lines.
-/
