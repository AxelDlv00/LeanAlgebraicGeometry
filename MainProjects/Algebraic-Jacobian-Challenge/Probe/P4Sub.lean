import Mathlib
open CategoryTheory AlgebraicGeometry
universe u

-- try proetale
example : Scheme.proetaleTopology.{u}.Subcanonical := by infer_instance
