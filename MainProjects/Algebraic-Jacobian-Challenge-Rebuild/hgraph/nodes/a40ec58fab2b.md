---
author: sync
content_type: theorem
created: '2026-07-24T17:02:46'
decl: is
file: AlgebraicJacobian/Picard/Pic0ChartLocusIsOpen.lean
generated: lean
lean_status: sorry
title: is
type: lean
updated: '2026-07-28T13:42:32'
---
theorem is real mathematics (it is the three transports plus the dictionary), and the
hypothesis is a single, precisely stated obligation which the GAP-1 mul/tensor brick will
discharge.

Writing it the other way round — stating `isOpen_chartLocus` unconditionally with a `sorry`
— would hide the fact that the missing input is a *construction*, not a proof.

## Main declarations

* `AlgebraicGeometry.IsChartDatumPresentation` — the residue, named.
* `AlgebraicGeometry.chartLocus_eq_cechWitnessLocus_of_presentation` — the identification of
  `chartLocus` over an affine test with the landed class-indexed witness locus.  This is
  transports (0) and (iii) discharged.
* `AlgebraicGeometry.isOpen_chartLocus_of_presentation` — **the keystone, conditionally**:
  `chartLocus` is open over an affine test given the presentation.
-/

set_option autoImplicit false
/- Statements mix `relCurve C L` with the product spelling `(C ⊗ overSpec k L).left`. -/
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

open scoped TensorProduct

namespace AlgebraicGeometry

open AlgebraicJacobian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

/-! ## The residue of the chain, named -/

variable (C π) in