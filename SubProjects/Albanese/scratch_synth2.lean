import Mathlib

set_option maxSynthPendingDepth 3

universe u

open AlgebraicGeometry CategoryTheory

set_option pp.universes true in
set_option trace.Meta.synthInstance.instances true in
noncomputable example {kbar : Type u} [Field kbar]
    {X : Over (AlgebraicGeometry.Spec (.of kbar))}
    [IsIntegral X.left] (z : X.left) :
    ValuativeCommSq (𝟙 (AlgebraicGeometry.Spec (.of kbar))) :=
  { R := X.left.presheaf.stalk z
    K := X.left.functionField
    i₁ := sorry
    i₂ := sorry
    commSq := sorry }
