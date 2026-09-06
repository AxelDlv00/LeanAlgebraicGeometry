/-
Copyright (c) 2026 The Hartshorne formalization authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Hartshorne Contributors
-/

import HartshorneLib.Chapter4ProjectiveMapProducer
import HartshorneLib.Chapter4DivisorModuleLocal

/-!
# Hartshorne IV.3.1: the tautological pullback interface

Mathlib's `Proj` API does not currently expose the Serre twist as a scheme
module.  This file therefore isolates the missing construction as explicit
data.  Once a target line bundle and its pullback isomorphism are supplied,
the line-bundle and chart-restriction consequences are proved without any
choice of local trivialization.

The interface is deliberately conditional: it is not an O(1) existence
theorem.  A future Serre-twist construction can instantiate it and discharge
the remaining source-facing bridge.
-/

set_option autoImplicit false

universe u

open CategoryTheory TopologicalSpace
open AlgebraicGeometry

namespace Hartshorne

noncomputable section

variable {k : Type u} [Field k] [IsAlgClosed k]
variable {X : Over (Spec (CommRingCat.of k))} [IsIntegral X.left]
  [SmoothOfRelativeDimension 1 X.hom] [IsProper X.hom]
variable {D : CurveDivisor k X}

/-- A target module equipped with the local-triviality property expected of
the projective tautological module.  The module itself is supplied by the
future Serre-twist construction. -/
structure ProjectiveTautologicalLineBundle (k : Type u) [Field k] (n : ℕ) where
  module : (projectiveSpace k n).Modules
  isLineBundle : IsLineBundle module

/-- A section-compatible pullback certificate for a projective map.  The
isomorphism is the precise global module comparison needed by the divisor
linear system.  Compatibility with local sections is obtained by restricting
this same isomorphism, rather than by choosing unrelated chart data. -/
structure ProjectiveMapTautologicalPullback
    (p : ProjectiveMapProducer D) where
  tautological : ProjectiveTautologicalLineBundle k p.n
  pullbackIso :
    (Scheme.Modules.pullback p.map).obj tautological.module ≅ divisorModule D

namespace ProjectiveMapTautologicalPullback

/-- The pullback of the supplied tautological module is a line bundle. -/
theorem isLineBundle_pullback
    {p : ProjectiveMapProducer D}
    (c : ProjectiveMapTautologicalPullback (D := D) p) :
    IsLineBundle ((Scheme.Modules.pullback p.map).obj c.tautological.module) := by
  exact IsLineBundle.pullback p.map c.tautological.isLineBundle

/-- The divisor module inherits local triviality from its tautological
pullback comparison. -/
theorem isLineBundle_divisorModule
    {p : ProjectiveMapProducer D}
    (c : ProjectiveMapTautologicalPullback (D := D) p) :
    IsLineBundle (divisorModule D) := by
  exact (IsLineBundle.pullback p.map c.tautological.isLineBundle).of_iso
    c.pullbackIso

/-- Restriction of the global pullback comparison to an arbitrary open of the
curve.  This is the chart-level compatibility used by a future O(1) gluing
construction. -/
def restrictIso
    {p : ProjectiveMapProducer D}
    (c : ProjectiveMapTautologicalPullback (D := D) p)
    (U : X.left.Opens) :
    (Scheme.Modules.restrictFunctor U.ι).obj
        ((Scheme.Modules.pullback p.map).obj c.tautological.module) ≅
      (Scheme.Modules.restrictFunctor U.ι).obj (divisorModule D) :=
  (Scheme.Modules.restrictFunctor U.ι).mapIso c.pullbackIso

/-- Every open-chart restriction of the supplied pullback is again a line
bundle.  In particular this applies to the denominator and coordinate charts
used by the projective gluing construction. -/
theorem isLineBundle_restrict_pullback
    {p : ProjectiveMapProducer D}
    (c : ProjectiveMapTautologicalPullback (D := D) p)
    (U : X.left.Opens) :
    IsLineBundle ((Scheme.Modules.restrictFunctor U.ι).obj
      ((Scheme.Modules.pullback p.map).obj c.tautological.module)) := by
  exact (isLineBundle_pullback c).restrict U.ι

@[simp] theorem restrictIso_hom
    {p : ProjectiveMapProducer D}
    (c : ProjectiveMapTautologicalPullback (D := D) p)
    (U : X.left.Opens) :
    (c.restrictIso U).hom =
      ((Scheme.Modules.restrictFunctor U.ι).map c.pullbackIso.hom) :=
  rfl

@[simp] theorem restrictIso_inv
    {p : ProjectiveMapProducer D}
    (c : ProjectiveMapTautologicalPullback (D := D) p)
    (U : X.left.Opens) :
    (c.restrictIso U).inv =
      ((Scheme.Modules.restrictFunctor U.ι).map c.pullbackIso.inv) :=
  rfl

end ProjectiveMapTautologicalPullback

end
end Hartshorne
