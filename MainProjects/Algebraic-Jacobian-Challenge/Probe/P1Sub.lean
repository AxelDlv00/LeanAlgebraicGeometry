import Mathlib
import AlgebraicJacobian.Picard.PicEtSheaf

open CategoryTheory AlgebraicGeometry

universe u

-- Q1: is the big etale topology on Scheme subcanonical?
example : Scheme.etaleTopology.{u}.Subcanonical := by infer_instance
