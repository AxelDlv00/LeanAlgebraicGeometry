/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieFlowAddition

/-!
# Parameter identities for canonical real flows

The canonical choice of a central real flow is a function of the tangent
vector.  This file records the pointwise regularity and scalar/additive
identities supplied by the integral-curve specification.  These are
fixed-time identities; joint regularity in the time and tangent parameters is
handled below only as a finite-dimensional real continuity statement; joint
complex or holomorphic regularity is not asserted here.
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

/-- The canonical real flow is continuous in its time parameter. -/
theorem canonicalRealFlow_continuous
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    Continuous (canonicalRealFlow I v) :=
  (canonicalRealFlow_spec I v).2.1.continuous

/-- In finite-dimensional real tangent spaces, the canonical flow is jointly
continuous in time and tangent parameters.  This is a real continuity
statement only; it does not assert complex holomorphicity. -/
theorem canonicalRealFlow_continuous_joint
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    [FiniteDimensional ℂ E] :
    Continuous (fun p : ℝ × GroupLieAlgebra (complexToRealModel I) G =>
      canonicalRealFlow I p.2 p.1) := by
  classical
  letI : FiniteDimensional ℝ E := FiniteDimensional.complexToReal E
  letI : FiniteDimensional ℝ (GroupLieAlgebra (complexToRealModel I) G) := by
    change FiniteDimensional ℝ E
    infer_instance
  letI : T2Space (GroupLieAlgebra (complexToRealModel I) G) := by
    change T2Space E
    infer_instance
  letI : ContinuousMul G :=
    ⟨(contMDiff_mul I ω (G := G)).continuous⟩
  let V := GroupLieAlgebra (complexToRealModel I) G
  let b : Module.Basis (Fin (Module.finrank ℝ V)) ℝ V :=
    Module.finBasisOfFinrankEq ℝ V rfl
  let l : List (Fin (Module.finrank ℝ V)) :=
    List.ofFn (fun i => i)
  have hlist (u : V) (t : ℝ) :
      canonicalRealFlow I ((l.map (fun i => (b.repr u) i • b i)).sum) t =
        (l.map (fun i => canonicalRealFlow I ((b.repr u) i • b i) t)).prod := by
    induction l with
    | nil => simp [canonicalRealFlow_zero]
    | cons i l ih =>
      simp only [List.map_cons, List.sum_cons, List.prod_cons]
      rw [canonicalRealFlow_add, ih]
  have hrepr (u : V) :
      (l.map (fun i => (b.repr u) i • b i)).sum = u := by
    dsimp [l]
    rw [List.map_ofFn, List.sum_ofFn]
    exact b.sum_repr u
  have heq :
      (fun p : ℝ × V => canonicalRealFlow I p.2 p.1) =
        (fun p : ℝ × V =>
          (l.map (fun i => canonicalRealFlow I ((b.repr p.2) i • b i) p.1)).prod) := by
    funext p
    calc
      canonicalRealFlow I p.2 p.1 =
          canonicalRealFlow I ((l.map (fun i => (b.repr p.2) i • b i)).sum) p.1 := by
            rw [hrepr p.2]
      _ = (l.map (fun i => canonicalRealFlow I ((b.repr p.2) i • b i) p.1)).prod :=
        hlist p.2 p.1
  rw [heq]
  apply continuous_list_prod l
  intro i hi
  have hcoord : Continuous (fun v : V => (b.repr v) i) :=
    (continuous_apply i).comp (Module.Basis.continuous_coe_repr b)
  have harg : Continuous (fun p : ℝ × V => p.1 * (b.repr p.2) i) :=
    continuous_fst.mul (hcoord.comp continuous_snd)
  have hfactor : Continuous (fun p : ℝ × V =>
      canonicalRealFlow I (b i) (p.1 * (b.repr p.2) i)) :=
    (canonicalRealFlow_spec I (b i)).2.1.continuous.comp harg
  have hscalar :
      (fun p : ℝ × V => canonicalRealFlow I ((b.repr p.2) i • b i) p.1) =
        (fun p : ℝ × V => canonicalRealFlow I (b i) (p.1 * (b.repr p.2) i)) := by
    funext p
    exact canonicalRealFlow_smul I (b i) (b.repr p.2 i) p.1
  rw [hscalar]
  exact hfactor

/-- At each time, the canonical flow has the derivative prescribed by its
left-invariant vector field. -/
theorem canonicalRealFlow_hasMFDerivAt
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) (t : ℝ) :
    HasMFDerivAt 𝓘(ℝ, ℝ) (complexToRealModel I)
      (canonicalRealFlow I v) t
      ((1 : ℝ →L[ℝ] ℝ).smulRight
        (mulInvariantVectorField (I := complexToRealModel I) v
          (canonicalRealFlow I v t))) :=
  (canonicalRealFlow_spec I v).2.1 t

/-- The derivative of the canonical flow at time zero is its tangent vector. -/
theorem canonicalRealFlow_hasMFDerivAt_zero
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) :
    HasMFDerivAt 𝓘(ℝ, ℝ) (complexToRealModel I)
      (canonicalRealFlow I v) 0
      ((1 : ℝ →L[ℝ] ℝ).smulRight v) := by
  have h' := (canonicalRealFlow_spec I v).2.1 0
  rw [(canonicalRealFlow_spec I v).1] at h'
  have hvone :
      mulInvariantVectorField (I := complexToRealModel I) v (1 : G) = v := by
    rw [mulInvariantVectorField]
    have hone : (fun x : G => (1 : G) * x) = id := by
      funext x
      simp
    rw [hone, mfderiv_id]
    rfl
  convert h' using 1
  · apply NormedSpace.ext
    rfl
  · apply ContinuousLinearMap.ext
    intro c
    rw [hvone]
    change c • v = c • v
    rfl

/-- Evaluating a scalar-multiple flow at time one recovers the original flow
at that scalar time. -/
theorem canonicalRealFlow_eq_time_one_smul
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v : GroupLieAlgebra (complexToRealModel I) G) (t : ℝ) :
    canonicalRealFlow I v t =
      canonicalRealFlow I (t • v) 1 := by
  simpa only [one_mul] using
    (canonicalRealFlow_smul I v t 1).symm

/-- At a fixed time, the flow of a two-term linear combination is the product
of the separately scaled flows. -/
theorem canonicalRealFlow_linear_combination
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (v w : GroupLieAlgebra (complexToRealModel I) G) (a b t : ℝ) :
    canonicalRealFlow I (a • v + b • w) t =
      canonicalRealFlow I v (t * a) * canonicalRealFlow I w (t * b) := by
  rw [canonicalRealFlow_add, canonicalRealFlow_smul, canonicalRealFlow_smul]

end Analytic
end Mumford
