import Mathlib
import AlgebraicJacobian.Picard.PicEtDescentExistence
import AlgebraicJacobian.Picard.EtaleFieldCover
import AlgebraicJacobian.Curve.GaloisLevelRationalPoint

open CategoryTheory AlgebraicGeometry Limits
open AlgebraicGeometry.Scheme.PicScheme
universe u
namespace Probe

-- Does the sieve identification need ANY hypothesis on k'/k beyond Algebra?
#check @AlgebraicGeometry.Scheme.PicScheme.generate_singleton_coverMap_eq

-- p3's producer, to see the shape of the level it hands over
#check @AlgebraicGeometry.Scheme.exists_finiteGalois_level_hasRationalPoint_of_geometricallyIntegral
end Probe
