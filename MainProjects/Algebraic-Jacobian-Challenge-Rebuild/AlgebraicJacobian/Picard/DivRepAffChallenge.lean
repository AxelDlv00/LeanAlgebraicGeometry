/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepChartClassUnivAffRepresentable
import AlgebraicJacobian.RiemannRoch.ChiCurve

/-! # Widened divisor representability for the challenge curve -/

set_option autoImplicit false
set_option quotPrecheck false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 8

universe u

open CategoryTheory

namespace AlgebraicGeometry

open Scheme

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

section Curve

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

/-- A representer for the widened divisor functor at the genus of a challenge curve.  The finite
dominant map to `P1`, the cohomology finiteness instances, and the Euler-characteristic identities
are all chosen internally from the curve assumptions. -/
noncomputable def divFunctorAffGenusRepresenter :
    Σ D : Over (Spec (.of k)), (divFunctorAff C (genus C)).RepresentableBy D := by
  classical
  letI : C.left.Over (Spec (.of k)) := .ofHom C.hom
  haveI : SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (SmoothOfRelativeDimension 1 C.hom)
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  haveI : LocallyOfFiniteType (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (LocallyOfFiniteType C.hom)
  haveI : QuasiCompact (C.left ↘ Spec (.of k)) :=
    inferInstanceAs (QuasiCompact C.hom)
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0) :=
    moduleFinite_hModule_zero C
  haveI : Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1) :=
    moduleFinite_hModule_one C
  let pi : C.left ⟶ P1 k := (exists_isFinite_isDominant_toP1 (C := C)).choose
  letI : IsFinite pi := (exists_isFinite_isDominant_toP1 (C := C)).choose_spec.1
  letI : IsDominant pi := (exists_isFinite_isDominant_toP1 (C := C)).choose_spec.2.1
  have hpi : pi ≫ P1.structureMap k = C.left ↘ Spec (.of k) :=
    (exists_isFinite_isDominant_toP1 (C := C)).choose_spec.2.2
  exact divFunctorAffRepresenter C hpi (genus C)
    (h0_moduleKSheaf C) (chi_moduleKSheaf C)

/-- A chosen scheme representing the widened divisor functor at the curve's genus. -/
noncomputable def divRepAffGenusScheme : Over (Spec (.of k)) :=
  (divFunctorAffGenusRepresenter C).1

/-- The widened divisor functor at the genus of a challenge curve is representable, with no
additional hypotheses. -/
noncomputable def divFunctorAff_genus_representableBy :
    (divFunctorAff C (genus C)).RepresentableBy (divRepAffGenusScheme C) :=
  (divFunctorAffGenusRepresenter C).2

end Curve

end AlgebraicGeometry
