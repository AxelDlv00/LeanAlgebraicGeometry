/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.RealLieFlowAddition
import MumfordLib.RealLieIntegralCurveRegularity

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
    [CompactSpace G] [PreconnectedSpace G] :
    Continuous (fun p : ℝ × GroupLieAlgebra (complexToRealModel I) G =>
      canonicalRealFlow I p.2 p.1) := by
  classical
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
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

/-- The time-one canonical flow is globally `C¹` in its real tangent
parameter.  A finite real basis reduces the map to a product of fixed-vector
flows, whose `C¹` regularity follows from their integral-curve equations. -/
theorem canonicalRealFlow_time_one_contMDiff
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
      (fun v : E => canonicalRealFlow (G := G) I v 1) := by
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : FiniteDimensional ℝ E := FiniteDimensional.complexToReal E
  let V := GroupLieAlgebra (complexToRealModel I) G
  letI : NormedAddCommGroup V := by
    change NormedAddCommGroup E
    infer_instance
  letI : NormedSpace ℝ V := by
    change NormedSpace ℝ E
    infer_instance
  letI : FiniteDimensional ℝ V := by
    change FiniteDimensional ℝ E
    infer_instance
  letI : T2Space V := by
    change T2Space E
    infer_instance
  letI : ContinuousSMul ℝ V := by
    change ContinuousSMul ℝ E
    infer_instance
  let b : Module.Basis (Fin (Module.finrank ℝ V)) ℝ V :=
    Module.finBasisOfFinrankEq ℝ V rfl
  let e : E →ₗ[ℝ] V :=
    (complexToRealLieAlgebraEquiv I).toLinearMap
  let l : List (Fin (Module.finrank ℝ V)) :=
    List.ofFn (fun i => i)
  have hfactor (i : Fin (Module.finrank ℝ V)) :
      ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
        (fun u : E => canonicalRealFlow (G := G) I
          ((b.repr (e u)) i • b i) 1) := by
    let coord : E →L[ℝ] ℝ :=
      LinearMap.toContinuousLinearMap ((b.coord i).comp e)
    have hcoord : ContMDiff 𝓘(ℝ, E) 𝓘(ℝ, ℝ) 1 coord :=
      coord.contMDiff
    have hflow : ContMDiff 𝓘(ℝ, ℝ) (complexToRealModel I) 1
        (canonicalRealFlow (G := G) I (b i)) :=
      canonicalRealFlow_contMDiff_one I (b i)
    have hcomp := hflow.comp hcoord
    have heq :
        (fun u : E => canonicalRealFlow (G := G) I
          ((b.repr (e u)) i • b i) 1) =
          (canonicalRealFlow (G := G) I (b i)) ∘ coord := by
      funext u
      change canonicalRealFlow (G := G) I ((b.repr (e u)) i • b i) 1 =
        canonicalRealFlow (G := G) I (b i) (coord u)
      rw [canonicalRealFlow_smul]
      simp [coord, e]
    rw [heq]
    simpa only [Function.comp_apply] using hcomp
  have hprod :
      ∀ (xs : List (Fin (Module.finrank ℝ V))),
        ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
          (fun u : E => (xs.map (fun i =>
            canonicalRealFlow (G := G) I
              ((b.repr (e u)) i • b i) 1)).prod) := by
    intro xs
    induction xs with
    | nil =>
        simpa using (contMDiff_const (I := 𝓘(ℝ, E))
          (I' := complexToRealModel I) (n := (1 : ℕ∞ω)) (c := (1 : G)))
    | cons i xs ih =>
        change ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
          ((fun u : E => canonicalRealFlow (G := G) I
            ((b.repr (e u)) i • b i) 1) *
          (fun u : E => (xs.map (fun j =>
            canonicalRealFlow (G := G) I
              ((b.repr (e u)) j • b j) 1)).prod))
        exact (hfactor i).mul ih
  have hlist (u : E) (xs : List (Fin (Module.finrank ℝ V))) :
      canonicalRealFlow (G := G) I
          ((xs.map (fun i => (b.repr (e u)) i • b i)).sum) 1 =
        (xs.map (fun i => canonicalRealFlow (G := G) I
          ((b.repr (e u)) i • b i) 1)).prod := by
    induction xs with
    | nil =>
        simp [canonicalRealFlow_zero]
    | cons i xs ih =>
        simp only [List.map_cons, List.sum_cons, List.prod_cons]
        rw [canonicalRealFlow_add, ih]
  have hrepr (u : E) :
      (l.map (fun i => (b.repr (e u)) i • b i)).sum = e u := by
    dsimp [l]
    rw [List.map_ofFn, List.sum_ofFn]
    exact b.sum_repr (e u)
  have heq :
      (fun u : E => canonicalRealFlow (G := G) I (e u) 1) =
        (fun u : E => (l.map (fun i =>
          canonicalRealFlow (G := G) I
            ((b.repr (e u)) i • b i) 1)).prod) := by
    funext u
    calc
      canonicalRealFlow (G := G) I (e u) 1 =
          canonicalRealFlow (G := G) I
            ((l.map (fun i => (b.repr (e u)) i • b i)).sum) 1 := by
              rw [hrepr u]
      _ = _ := hlist u l
  have hmain := hprod l
  rw [← heq] at hmain
  with_reducible_and_instances
    simpa [e, complexToRealLieAlgebraEquiv,
      complexToRealLieAlgebraMap] using hmain

/-- If the time-one flow map is genuinely real differentiable at the origin,
then its derivative there is the identity.  This isolates the derivative
calculation from the remaining joint-regularity problem: the scalar flow law
identifies every line through the origin with an already differentiated
one-parameter subgroup. -/
theorem mfderiv_canonicalRealFlow_time_one_eq_id
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G]
    (hdiff : MDifferentiableAt 𝓘(ℝ, E) (complexToRealModel I)
      (fun v : E => canonicalRealFlow (G := G) I v 1) 0) :
    mfderiv 𝓘(ℝ, E) (complexToRealModel I)
      (fun v : E => canonicalRealFlow (G := G) I v 1) 0 =
      ContinuousLinearMap.id ℝ E := by
  let exp : E → G := fun v => canonicalRealFlow (G := G) I v 1
  have hexp : HasMFDerivAt 𝓘(ℝ, E) (complexToRealModel I) exp 0
      (mfderiv 𝓘(ℝ, E) (complexToRealModel I) exp 0) :=
    hdiff.hasMFDerivAt
  change (mfderiv 𝓘(ℝ, E) (complexToRealModel I) exp 0 : E →L[ℝ] E) =
    ContinuousLinearMap.id ℝ E
  apply ContinuousLinearMap.ext
  intro v
  let line : ℝ →L[ℝ] E := (1 : ℝ →L[ℝ] ℝ).smulRight v
  have hline : HasMFDerivAt 𝓘(ℝ, ℝ) 𝓘(ℝ, E) line 0 line := by
    with_reducible_and_instances
      exact line.hasFDerivAt.hasMFDerivAt
  have hexp' : HasMFDerivAt 𝓘(ℝ, E) (complexToRealModel I) exp (line 0)
      (mfderiv 𝓘(ℝ, E) (complexToRealModel I) exp 0) := by
    convert hexp using 1; simp [line]
  have hcomp := hexp'.comp 0 hline
  have heq : exp ∘ line = canonicalRealFlow I v := by
    funext t
    change canonicalRealFlow I (t • v) 1 = canonicalRealFlow I v t
    exact (canonicalRealFlow_eq_time_one_smul (G := G) I v t).symm
  rw [heq] at hcomp
  have hflow := canonicalRealFlow_hasMFDerivAt_zero (G := G) I v
  have hmaps := hcomp.mfderiv.symm.trans hflow.mfderiv
  let oneT : TangentSpace 𝓘(ℝ, ℝ) (0 : ℝ) := by
    change ℝ
    exact 1
  have h := congrArg (fun f => f oneT) hmaps
  change (mfderiv 𝓘(ℝ, E) (complexToRealModel I) exp 0) v = v
  change
    (mfderiv 𝓘(ℝ, E) (complexToRealModel I) exp 0)
        (((1 : ℝ →L[ℝ] ℝ).smulRight v) (1 : ℝ)) =
      ((1 : ℝ →L[ℝ] ℝ).smulRight v) (1 : ℝ) at h
  simpa using h

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
