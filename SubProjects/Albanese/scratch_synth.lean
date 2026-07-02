import Mathlib

set_option maxSynthPendingDepth 3

universe u

open AlgebraicGeometry CategoryTheory

noncomputable example {kbar : Type u} [Field kbar]
    {X Y : Over (AlgebraicGeometry.Spec (.of kbar))}
    [IsIntegral X.left] (z : X.left)
    [IsDiscreteValuationRing (X.left.presheaf.stalk z)]
    (i₁ : Spec X.left.functionField ⟶ Y.left)
    (i₂ : Spec (X.left.presheaf.stalk z) ⟶ AlgebraicGeometry.Spec (.of kbar))
    (hcommSq : CommSq i₁
      (Spec.map (CommRingCat.ofHom
        (algebraMap (X.left.presheaf.stalk z) X.left.functionField)))
      Y.hom i₂) :
    ValuativeCommSq Y.hom :=
  { R := X.left.presheaf.stalk z
    K := X.left.functionField
    i₁ := i₁
    i₂ := i₂
    commSq := hcommSq }
