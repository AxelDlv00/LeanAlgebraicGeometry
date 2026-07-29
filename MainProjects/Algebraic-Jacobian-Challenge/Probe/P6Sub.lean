import Mathlib
open CategoryTheory AlgebraicGeometry
universe u

-- etaleTopology is subcanonical, from proetale by of_le
instance : Scheme.etaleTopology.{u}.Subcanonical :=
  GrothendieckTopology.Subcanonical.of_le Scheme.etaleTopology_le_proetaleTopology

-- and the localisation to (Sch/k)
example (k : Type u) [Field k] :
    (Scheme.etaleTopology.over (Spec (CommRingCat.of k))).Subcanonical := by
  infer_instance
