/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieFlowParameter

/-!
# Complex parameters for the canonical real flow

The canonical flow is constructed by real integral curves.  This file records
the honest complex-parameter reindexing obtained by first multiplying a model
vector by a complex scalar and then evaluating the real flow at time one.  The
identities below are algebraic and real-regularity statements; no
holomorphicity claim is made.
-/

set_option autoImplicit false

noncomputable section

open Function Set
open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ω G]

/-- The identity map from the complex model space to the tangent space of the
realified Lie group, regarded as a real-linear map. -/
def complexToRealLieAlgebraMap :
    E →ₗ[ℝ] GroupLieAlgebra (complexToRealModel I) G :=
  { toFun := fun v => v
    map_add' := by
      intro v w
      rfl
    map_smul' := by
      intro c v
      rfl }

/-- The complex-parameterized flow obtained from the real flow at time one. -/
def canonicalComplexFlow
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : E) (z : ℂ) : G :=
  canonicalRealFlow I (complexToRealLieAlgebraMap I (z • v)) 1

/-! The time-one map underlying `canonicalComplexFlow`.  This is the
    formalization's exponential candidate; source-level uniqueness and
    uniformization are separate statements. -/
def canonicalComplexExponential
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : E) : G :=
  canonicalRealFlow I (complexToRealLieAlgebraMap I v) 1

@[simp]
theorem canonicalComplexFlow_eq_exponential_smul
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) (z : ℂ) :
    canonicalComplexFlow (G := G) I v z =
      canonicalComplexExponential (G := G) I (z • v) := rfl

@[simp]
theorem canonicalComplexFlow_zero_vector
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (z : ℂ) :
    canonicalComplexFlow (G := G) I (0 : E) z = (1 : G) := by
  change canonicalRealFlow (G := G) I
      (complexToRealLieAlgebraMap I (z • (0 : E))) 1 = (1 : G)
  rw [smul_zero, map_zero]
  exact congrFun (canonicalRealFlow_zero (G := G) I) 1

@[simp]
theorem canonicalComplexFlow_zero_parameter
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) :
    canonicalComplexFlow (G := G) I v 0 = (1 : G) := by
  change canonicalRealFlow (G := G) I
      (complexToRealLieAlgebraMap I ((0 : ℂ) • v)) 1 = (1 : G)
  rw [zero_smul, map_zero]
  exact congrFun (canonicalRealFlow_zero (G := G) I) 1

/-- The complex flow is additive in its complex parameter. -/
theorem canonicalComplexFlow_add_parameter
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) (z w : ℂ) :
    canonicalComplexFlow (G := G) I v (z + w) =
      canonicalComplexFlow (G := G) I v z * canonicalComplexFlow (G := G) I v w := by
  change canonicalRealFlow (G := G) I
      (complexToRealLieAlgebraMap I ((z + w) • v)) 1 =
    canonicalRealFlow (G := G) I (complexToRealLieAlgebraMap I (z • v)) 1 *
      canonicalRealFlow (G := G) I (complexToRealLieAlgebraMap I (w • v)) 1
  rw [add_smul, map_add]
  exact canonicalRealFlow_add (G := G) I
    (complexToRealLieAlgebraMap I (z • v))
    (complexToRealLieAlgebraMap I (w • v)) 1

/-- On real parameters, the complex flow agrees with the original real flow. -/
theorem canonicalComplexFlow_ofReal
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (v : E) (r : ℝ) :
    canonicalComplexFlow (G := G) I v (r : ℂ) =
      canonicalRealFlow (G := G) I (complexToRealLieAlgebraMap I v) r := by
  unfold canonicalComplexFlow
  have h := canonicalRealFlow_eq_time_one_smul (G := G) I
    (complexToRealLieAlgebraMap I v) r
  rw [h]
  simp [complexToRealLieAlgebraMap]

/-- The complex-parameterized flow is jointly continuous in its parameter and
vector.  This is a real/topological statement and does not assert
holomorphicity. -/
theorem canonicalComplexFlow_continuous_joint
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    Continuous (fun p : ℂ × E =>
      canonicalComplexFlow (G := G) I p.2 p.1) := by
  let e : E →ₗ[ℝ] GroupLieAlgebra (complexToRealModel I) G :=
    complexToRealLieAlgebraMap I
  have htime : Continuous (fun u : E =>
      canonicalRealFlow (G := G) I (e u) 1) := by
    exact (canonicalRealFlow_time_one_contMDiff (G := G) I).continuous
  have hsmul : Continuous (fun p : ℂ × E => p.1 • p.2) :=
    continuous_smul (M := ℂ) (X := E)
  have hcomp := htime.comp hsmul
  change Continuous (fun p : ℂ × E =>
      canonicalRealFlow (G := G) I (e (p.1 • p.2)) 1) at hcomp
  change Continuous (fun p : ℂ × E =>
    canonicalRealFlow (G := G) I
      (complexToRealLieAlgebraMap I (p.1 • p.2)) 1)
  simpa [e] using hcomp

/-- The real time, complex scalar, and model vector may vary jointly in the
canonical real flow.  This remains a real/topological statement; in particular,
it does not assert holomorphic dependence on the complex scalar. -/
theorem canonicalRealFlow_continuous_joint_complex_smul
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    Continuous (fun p : ℝ × (ℂ × E) =>
      canonicalRealFlow (G := G) I
        (complexToRealLieAlgebraMap I (p.2.1 • p.2.2)) p.1) := by
  have hsmul : Continuous (fun p : ℂ × E => p.1 • p.2) :=
    continuous_smul (M := ℂ) (X := E)
  have harg : Continuous (fun p : ℝ × (ℂ × E) =>
      ((p.1, p.2.1 • p.2.2) :
        ℝ × GroupLieAlgebra (complexToRealModel I) G)) := by
    exact continuous_fst.prodMk (hsmul.comp continuous_snd)
  exact (canonicalRealFlow_continuous_joint (G := G) I).comp harg

end Analytic
end Mumford
