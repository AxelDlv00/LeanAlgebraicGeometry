/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneNativePresentation

/-!
# The rank-one evaluation zero-locus comparison

The canonical inverse is cut out by the evaluation counit, while the existing divisor engine
consumes the tied cocycle datum's local equations.  This file proves the section-level comparison
between those two descriptions before any Noetherian or regularity hypothesis is introduced.

For a tied local presentation, transporting a datum section through `module_iso.inv` commutes
with restriction to every open.  Since every component of the sheaf isomorphism is injective,
restriction vanishes on the module side exactly when it vanishes on the datum side.  Applying
this to the canonical unit-lift through the evaluation counit identifies its restriction-
vanishing predicate with that of `datumSection`.  The final theorem specializes the comparison
to `PicRankOneNativePresentation`, whose converted module is definitionally the native module.

This is a base-ring-linear section zero predicate, expressed through
`toModuleKSheafOfModules`.  It is not an isomorphism of `O_X`-modules and does not identify the
local equation ideals of the native line bundle.  That O-linear ideal comparison is still needed
before the datum-side equations can be shown to cut out the intrinsic evaluation divisor.  This
file also does not assert regularity, construct a family-level divisor, or manufacture the
still-missing arbitrary-affine presentation producer.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory
  CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {A : Type u} [CommRing A] [Algebra k A]
variable {pi : C.left ⟶ P1 k} [IsFinite pi]
variable {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}

namespace PicRankOneLocalPresentation

/-- Transport through the tied sheaf isomorphism commutes with restriction on sections. -/
theorem module_iso_inv_restrict
    (P : PicRankOneLocalPresentation pi lam)
    {U V : (relCurve C P.cover.Carrier).Opens} (h : V ≤ U)
    (s : P.datum.sheaf.obj.obj (op U)) :
    (((Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)))
        P.module).obj.map (homOfLE h).op).hom
      ((P.module_iso.inv.hom.app (op U)).hom s)) =
      (P.module_iso.inv.hom.app (op V)).hom
        ((P.datum.sheaf.obj.map (homOfLE h).op).hom s) := by
  exact congrArg (fun z => z.hom s)
    (P.module_iso.inv.hom.naturality (homOfLE h).op).symm

/-- Restriction vanishes after transport to the base-ring module exactly when the datum restriction
vanishes.  This is a pointwise section comparison supplied by `module_iso`; it is not a statement
about the native `O_X`-module ideal and needs no Noetherian hypothesis. -/
theorem module_iso_inv_restrict_eq_zero_iff
    (P : PicRankOneLocalPresentation pi lam)
    {U V : (relCurve C P.cover.Carrier).Opens} (h : V ≤ U)
    (s : P.datum.sheaf.obj.obj (op U)) :
    (((Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)))
        P.module).obj.map (homOfLE h).op).hom
      ((P.module_iso.inv.hom.app (op U)).hom s) = 0) ↔
      ((P.datum.sheaf.obj.map (homOfLE h).op).hom s = 0) := by
  rw [P.module_iso_inv_restrict h s]
  exact map_eq_zero_iff _
    (CategoryTheory.ConcreteCategory.bijective_of_isIso
      (P.module_iso.inv.hom.app (op V))).1

/-- The evaluation counit sends the canonical H⁰ unit-lift to the module section obtained
from the tied datum class. -/
theorem evaluation_evaluationLiftOfH0_eq_moduleSectionsEquiv
    (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    (Scheme.Modules.Hom.app P.evaluation
      ((relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⁻¹ᵁ
        (⊤ : (Spec (.of P.cover.Carrier)).Opens))).hom
      (P.evaluationLiftOfH0 y) = P.moduleSectionsEquiv y := by
  calc
    _ = P.pushforwardSectionOfH0 y := P.evaluation_evaluationLiftOfH0 y
    _ = P.moduleSectionsEquiv y := rfl

/-- The canonical evaluation section and the tied datum section have the same restriction-
vanishing predicate on every open of the relative curve.

This is the immediate consumer of `module_iso_inv_restrict_eq_zero_iff`: the evaluated section
is first identified with `moduleSectionsEquiv y`, then with the inverse image of
`datumSection y` under the presentation's sheaf isomorphism. -/
theorem evaluationLift_restrict_eq_zero_iff
    (P : PicRankOneLocalPresentation pi lam)
    {V : (relCurve C P.cover.Carrier).Opens} (h : V ≤ ⊤)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    (((Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)))
        P.module).obj.map (homOfLE h).op).hom
      ((Scheme.Modules.Hom.app P.evaluation
        ((relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⁻¹ᵁ
          (⊤ : (Spec (.of P.cover.Carrier)).Opens))).hom
        (P.evaluationLiftOfH0 y)) = 0) ↔
      ((P.datum.sheaf.obj.map (homOfLE h).op).hom
        (P.datumSection y) = 0) := by
  rw [P.evaluation_evaluationLiftOfH0_eq_moduleSectionsEquiv y]
  rw [← P.module_iso_inv_datumSection y]
  exact P.module_iso_inv_restrict_eq_zero_iff h (P.datumSection y)

end PicRankOneLocalPresentation

namespace PicRankOneNativePresentation

/-- Native specialization of the evaluation/datum zero-locus comparison.

`toLocalPresentation.module` is definitionally `P.datum.nativeModule`, so this theorem is the
consumer-facing native base-ring section comparison rather than a second choice of line bundle.
The native `O_X`-linear ideal comparison remains a separate producer obligation. -/
theorem evaluationLift_restrict_eq_zero_iff
    (P : PicRankOneNativePresentation pi lam)
    {V : (relCurve C P.toLocalPresentation.cover.Carrier).Opens} (h : V ≤ ⊤)
    (y : Sheaf.HModule P.toLocalPresentation.datum.sheaf 0) :
    (((Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C P.toLocalPresentation.cover.Carrier ↘
        Spec (.of P.toLocalPresentation.cover.Carrier)))
        P.toLocalPresentation.module).obj.map (homOfLE h).op).hom
      ((Scheme.Modules.Hom.app P.toLocalPresentation.evaluation
        ((relCurve C P.toLocalPresentation.cover.Carrier ↘
          Spec (.of P.toLocalPresentation.cover.Carrier)) ⁻¹ᵁ
          (⊤ : (Spec (.of P.toLocalPresentation.cover.Carrier)).Opens))).hom
        (P.toLocalPresentation.evaluationLiftOfH0 y)) = 0) ↔
      ((P.toLocalPresentation.datum.sheaf.obj.map (homOfLE h).op).hom
        (P.toLocalPresentation.datumSection y) = 0) := by
  exact P.toLocalPresentation.evaluationLift_restrict_eq_zero_iff h y

end PicRankOneNativePresentation

end AlgebraicGeometry
