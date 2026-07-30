/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0ChartRationalGraph
import Mathlib.AlgebraicGeometry.Sites.Fpqc

/-!
# Legal chart indices after finite base change

This file supplies the positive replacement for a base-field genus divisor-degree assumption.
Every challenge curve has a closed point; its residue field is a finite extension over which the
curve has a rational point.  The graph of that point then produces a legal chart index at every
natural parameter, in particular at the genus.  No separability claim is made: over an imperfect
field, even a smooth curve can have inseparable closed points, and finite faithful-flat descent
does not require the extension to be separable.

## Main declarations

* `AlgebraicGeometry.exists_finite_point` — every challenge curve acquires a point over a
  finite extension, obtained from a closed point and its residue field.
* `AlgebraicGeometry.baseChangePoint` — the fibre-product lift of an extension-valued point to
  a rational point of the base-changed curve.
* `AlgebraicGeometry.overSpecFieldExtension_mem_fpqcTopology` — a field extension is an fpqc
  singleton cover of the base field.
* `AlgebraicGeometry.exists_fpqc_chartIndex` — the finite cover and a legal chart index are
  produced together.
* `AlgebraicGeometry.exists_finite_chartIndex` — every natural parameter has a legal
  chart index after one finite base change.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency true
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory
open TopologicalSpace Opposite

namespace AlgebraicGeometry

open AlgebraicJacobian

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]

noncomputable section

variable (C) in
/-- Every challenge curve acquires a rational point over a finite extension.

Choose a closed point of the integral Jacobson scheme `C`.  Its residue field is finite over
`k` because the corresponding point morphism is finite.  The canonical residue-field point then
gives the required morphism.  In particular, this is a producer from the standing curve
assumptions, not a new point hypothesis. -/
theorem exists_finite_point :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (_ : Module.Finite k L),
      Nonempty (overSpec k L ⟶ C) := by
  haveI : IsIntegral C.left := isIntegral_left_of_geometricallyReduced C
  haveI : JacobsonSpace C.left := LocallyOfFiniteType.jacobsonSpace C.hom
  obtain ⟨x, _, hx⟩ := nonempty_inter_closedPoints
    (Z := (Set.univ : Set C.left)) Set.univ_nonempty isOpen_univ.isLocallyClosed
  have hxclosed : IsClosed ({x} : Set C.left) := mem_closedPoints_iff.mp hx
  let L := Over.testPointField x
  letI : Field L := inferInstance
  letI : Algebra k L := inferInstance
  haveI hfinite : Module.Finite k L := by
    haveI : LocallyOfFiniteType (C.left.fromSpecResidueField x) :=
      isClosed_singleton_iff_locallyOfFiniteType.mp hxclosed
    haveI : LocallyOfFiniteType
        (C.left.fromSpecResidueField x ≫ C.hom) := inferInstance
    haveI : IsFinite (C.left.fromSpecResidueField x ≫ C.hom) :=
      isFinite_iff_locallyOfFiniteType_of_jacobsonSpace.mpr inferInstance
    rw [← RingHom.finite_algebraMap]
    apply (IsFinite.SpecMap_iff _).mp
    rw [Spec.map_preimage]
    exact inferInstance
  exact ⟨L, inferInstance, inferInstance, hfinite, ⟨Over.testPoint x⟩⟩

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
/-- The identity of `Spec L`, typed from the `L`-relative affine test to the same affine
scheme regarded as a `k`-relative test. -/
noncomputable def overSpecLeftChangeBase (L : Type u) [Field L] [Algebra k L] :
    (overSpec L L).left ⟶ (overSpec k L).left :=
  𝟙 (Spec (.of L))

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
/-- The change-of-base identity is the structure morphism of `overSpec L L`. -/
lemma overSpecLeftChangeBase_eq (L : Type u) [Field L] [Algebra k L] :
    overSpecLeftChangeBase (k := k) L = (overSpec L L).hom := by
  change 𝟙 (Spec (.of L)) = (overSpec L L).hom
  exact overSpec_self_hom.symm

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (C) in
/-- A point of `C` over an extension field `L` is canonically an `L`-rational point of the
base-changed curve.  Its underlying morphism is the lift of the point and the identity of
`Spec L` into the defining fibre product. -/
noncomputable def baseChangePoint {L : Type u} [Field L] [Algebra k L]
    (p : overSpec k L ⟶ C) : overSpec L L ⟶ baseChangeBundle C L :=
  show overSpec L L ⟶ Over.mk (pullback.snd C.hom (overSpec k L).hom) from
    Over.homMk
      (pullback.lift (overSpecLeftChangeBase (k := k) L ≫ p.left)
        (overSpecLeftChangeBase (k := k) L) (by rw [Category.assoc, p.w]))
      ((pullback.lift_snd _ _ _).trans (overSpecLeftChangeBase_eq (k := k) L))

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (L : Type u) [Field L] [Algebra k L] in
/-- The spectrum map of a field extension is surjective. -/
instance instSurjectiveOverSpecFieldExtension : Surjective (overSpec k L).hom := by
  rw [overSpec_hom]
  apply ((flat_and_surjective_SpecMap_iff
    (CommRingCat.ofHom (algebraMap k L))).mpr ?_).2
  rw [CommRingCat.hom_ofHom, RingHom.faithfullyFlat_algebraMap_iff]
  infer_instance

omit [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom] in
variable (L : Type u) [Field L] [Algebra k L] in
/-- A field extension gives a singleton fpqc cover of the base field. -/
theorem overSpecFieldExtension_mem_fpqcTopology :
    Sieve.generate (Presieve.singleton (overSpec k L).hom) ∈
      Scheme.fpqcTopology (Spec (.of k)) :=
  Precoverage.generate_mem_toGrothendieck
    (overSpec k L).hom.singleton_mem_fpqcPrecoverage

/-! The raw second-projection instances, re-keyed on the bundled base-change spelling. -/

variable (C) (L : Type u) [Field L] [Algebra k L] in
/-- Smooth relative dimension one, keyed on the bundled base-changed curve. -/
instance instSmoothOfRelativeDimensionBaseChangeBundle :
    SmoothOfRelativeDimension 1 (baseChangeBundle C L).hom :=
  instSmoothOfRelativeDimensionSndLeft C L

variable (C) (L : Type u) [Field L] [Algebra k L] in
/-- Properness, keyed on the bundled base-changed curve. -/
instance instIsProperBaseChangeBundle : IsProper (baseChangeBundle C L).hom :=
  instIsProperSndLeft C L

variable (C) (L : Type u) [Field L] [Algebra k L] in
/-- Geometric irreducibility, keyed on the bundled base-changed curve. -/
instance instGeometricallyIrreducibleBaseChangeBundle :
    GeometricallyIrreducible (baseChangeBundle C L).hom :=
  instGeometricallyIrreducibleSndLeft C L

variable (C) in
/-- Every natural chart parameter becomes legal on a finite fpqc cover.

The cover and the chart index are returned in one package.  This is the producer-facing form
for descent: the caller does not need to recover fpqc coverhood from the finite field extension. -/
theorem exists_fpqc_chartIndex (n : ℕ) :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (_ : Module.Finite k L),
      Sieve.generate (Presieve.singleton (overSpec k L).hom) ∈
          Scheme.fpqcTopology (Spec (.of k)) ∧
        ∃ (m : ℕ)
          (Z : ((baseChangeBundle C L) ⊗ overSpec L L).left.CurveDivisor),
          Scheme.CurveDivisor.deg L Z =
            (m : ℤ) * classDeg L (thetaCechClass (baseChangeBundle C L)) - (n : ℤ) := by
  obtain ⟨L, hLfield, hkL, hfinite, ⟨p⟩⟩ := exists_finite_point C
  letI : Field L := hLfield
  letI : Algebra k L := hkL
  letI : Module.Finite k L := hfinite
  exact ⟨L, inferInstance, inferInstance, inferInstance,
    overSpecFieldExtension_mem_fpqcTopology (k := k) L,
    exists_chartIndex_of_point (baseChangeBundle C L) (baseChangePoint C p) n⟩

variable (C) in
/-- Every natural chart parameter becomes legal after one finite base change.

The extension is produced by `exists_finite_point`; no divisor-degree or rational-point
assumption is added.  This is the positive input for constructing genus charts over a cover
before descending the resulting restricted atlas to the base field. -/
theorem exists_finite_chartIndex (n : ℕ) :
    ∃ (L : Type u) (_ : Field L) (_ : Algebra k L)
      (_ : Module.Finite k L),
      ∃ (m : ℕ)
        (Z : ((baseChangeBundle C L) ⊗ overSpec L L).left.CurveDivisor),
        Scheme.CurveDivisor.deg L Z =
          (m : ℤ) * classDeg L (thetaCechClass (baseChangeBundle C L)) - (n : ℤ) := by
  obtain ⟨L, hLfield, hkL, hfinite, _, hindex⟩ := exists_fpqc_chartIndex C n
  exact ⟨L, hLfield, hkL, hfinite, hindex⟩

end

end AlgebraicGeometry
