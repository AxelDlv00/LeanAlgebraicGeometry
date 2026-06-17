/-
Copyright (c) 2026 Christian Merten. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Christian Merten
-/
import Mathlib
import AlgebraicJacobian.Cohomology.PresheafCech
import AlgebraicJacobian.Cohomology.FreePresheafComplex

/-!
# Form-B absolute cohomology `H^p(U, F) := Ext^p(jShriekOU U, F)` (P5b input)
-/

universe u

open CategoryTheory Limits CategoryTheory.Abelian

namespace AlgebraicGeometry

variable {X : Scheme.{u}}

/-! ## Project-local Mathlib supplement — Form-B absolute cohomology -/

noncomputable def jShriekOU (U : TopologicalSpace.Opens X) : X.Modules :=
  (PresheafOfModules.sheafification (𝟙 X.ringCatSheaf.obj)).obj
    ((PresheafOfModules.free X.ringCatSheaf.obj).obj (yoneda.obj U))

#check @Ext.homEquiv₀
#check @Ext.eq_zero_of_injective
#check @Ext.covariant_sequence_exact₁
#check @Ext.covariant_sequence_exact₂
#check @Ext.covariant_sequence_exact₃
#check @HasExt.standard
#check @PresheafOfModules.sheafificationAdjunction
#check @freeYonedaHomAddEquiv

end AlgebraicGeometry
