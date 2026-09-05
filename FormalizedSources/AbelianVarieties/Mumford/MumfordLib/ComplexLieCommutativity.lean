/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieAdjoint
import MumfordLib.ComplexLieExponentialUniqueness
import MumfordLib.RealLieFlowParameter
import MumfordLib.ComplexLieFlowParameter
import Mathlib.Analysis.Calculus.InverseFunctionTheorem.ContDiff
import Mathlib.Algebra.Group.Commute.Basic
import Mathlib.Algebra.Group.Subgroup.Lattice
import Mathlib.Geometry.Manifold.LocalDiffeomorph
import Mathlib.Topology.Algebra.OpenSubgroup
import Mathlib.Topology.Connected.Clopen

/-!
# The integration interface for compact complex Lie groups

The compact-holomorphic argument in `ComplexLieAdjoint` makes the derivative
of every conjugation map equal to the identity.  This file proves the
local-to-global generation step in Mumford's argument, records useful
conditional exponential interfaces, and closes commutativity through the
canonical holomorphic exponential and its naturality.  Real invariant flows
construct that exponential and prove its global range; complex regularity and
one-parameter uniqueness supply the functoriality used here.
-/

set_option autoImplicit false

noncomputable section

open scoped Manifold ContDiff Topology

namespace Mumford
namespace Analytic

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [Group G]
  [LieGroup I ⊤ G]

/-!
### Explicit exponential boundary

`exponential_generates` is the source-level local-generation conclusion used
in Mumford's commutativity argument.  The `conjugation_exp` field is the
functoriality of the exponential under conjugation; its right-hand side uses
the independently proved adjoint map.
-/

/-- The part of a Lie exponential argument needed to integrate adjoint
triviality.  This is an explicit conditional interface, not an existence
claim for Lie exponentials. -/
structure ComplexLieExponentialData where
  /-- The candidate exponential in fixed tangent coordinates. -/
  exponential : E → G
  /-- The exponential takes the zero tangent vector to the identity. -/
  exponential_zero : exponential 0 = 1
  /-- The exponential image generates the whole group. -/
  exponential_generates :
    Subgroup.closure (Set.range exponential) = (⊤ : Subgroup G)
  /-- Conjugation transports exponential points by the adjoint derivative. -/
  conjugation_exp : ∀ (x : G) (v : E),
    complexLieConjugation x (exponential v) =
      exponential ((complexLieAdjoint (G := G) I x) v)

namespace ComplexLieExponentialData

@[simp]
theorem exponential_zero_apply
    (d : ComplexLieExponentialData (E := E) (H := H) (G := G) I) :
    d.exponential 0 = 1 :=
  d.exponential_zero

end ComplexLieExponentialData

/-!
### The algebraic generation step
-/

/-- A central generating subset forces a group to be commutative.

The proof uses subgroup closure induction, so the generation hypothesis is
strictly weaker than surjectivity of the chosen parametrization.
-/
theorem isMulCommutative_of_central_generators
    {G : Type*} [Group G] {s : Set G}
    (hcentral : ∀ z ∈ s, ∀ x : G, Commute x z)
    (hgen : Subgroup.closure s = (⊤ : Subgroup G)) :
    IsMulCommutative G := by
  apply isMulCommutative_iff.mpr
  intro x y
  have hc : ∀ z ∈ Subgroup.closure s, Commute x z := by
    intro z hz
    induction hz using Subgroup.closure_induction with
    | mem z hz => exact hcentral z hz x
    | one => exact Commute.one_right x
    | mul a b ha hb h₁ h₂ => exact h₁.mul_right h₂
    | inv a ha h₁ => exact h₁.inv_right
  have hy : y ∈ Subgroup.closure s := by
    rw [hgen]
    exact Set.mem_univ y
  exact hc y hy

/-- In a preconnected group with separately continuous multiplication, a subset
containing an identity neighborhood algebraically generates the whole group;
the neighborhood makes its subgroup closure open. -/
theorem subgroup_closure_eq_top_of_one_mem_interior
    {G : Type*} [Group G] [TopologicalSpace G] [SeparatelyContinuousMul G]
    [PreconnectedSpace G] {s : Set G}
    (h1 : (1 : G) ∈ interior s) :
    Subgroup.closure s = (⊤ : Subgroup G) := by
  have h1c : (1 : G) ∈ interior (Subgroup.closure s : Set G) :=
    (interior_mono Subgroup.subset_closure) h1
  have hopen : IsOpen (Subgroup.closure s : Set G) :=
    Subgroup.isOpen_of_one_mem_interior _ h1c
  have hclosed : IsClosed (Subgroup.closure s : Set G) :=
    Subgroup.isClosed_of_isOpen _ hopen
  have hclopen : IsClopen (Subgroup.closure s : Set G) :=
    ⟨hclosed, hopen⟩
  have huniv : (Subgroup.closure s : Set G) = Set.univ :=
    hclopen.eq_univ ⟨1, Subgroup.one_mem _⟩
  apply top_unique
  intro x _
  have hx : x ∈ (Subgroup.closure s : Set G) := by
    rw [huniv]
    exact Set.mem_univ x
  exact hx

/-- An identity neighborhood of central elements forces a preconnected group
with separately continuous multiplication to be commutative. -/
theorem isMulCommutative_of_central_nhds
    {G : Type*} [Group G] [TopologicalSpace G] [SeparatelyContinuousMul G]
    [PreconnectedSpace G] {s : Set G}
    (hcentral : ∀ z ∈ s, ∀ x : G, Commute x z)
    (h1 : (1 : G) ∈ interior s) :
    IsMulCommutative G :=
  isMulCommutative_of_central_generators hcentral
    (subgroup_closure_eq_top_of_one_mem_interior h1)

/-!
### Local generation from a local inverse
-/

/-- A map that is a local diffeomorphism at a point has range containing a
neighborhood of its value at that point. -/
theorem range_mem_interior_of_isLocalDiffeomorphAt
    {𝕜 E' F H₁ H₂ M N : Type*} [NontriviallyNormedField 𝕜]
    [NormedAddCommGroup E'] [NormedSpace 𝕜 E']
    [NormedAddCommGroup F] [NormedSpace 𝕜 F]
    [TopologicalSpace H₁] [TopologicalSpace H₂]
    [TopologicalSpace M] [ChartedSpace H₁ M]
    [TopologicalSpace N] [ChartedSpace H₂ N]
    {I' : ModelWithCorners 𝕜 E' H₁} {J : ModelWithCorners 𝕜 F H₂}
    {n : WithTop ℕ∞} {f : M → N} {x : M}
    (hf : IsLocalDiffeomorphAt I' J n f x) :
    f x ∈ interior (Set.range f) := by
  apply mem_interior.mpr
  refine ⟨hf.localInverse.source, ?_, hf.localInverse.open_source,
    hf.localInverse_mem_source⟩
  intro y hy
  exact ⟨hf.localInverse y, hf.localInverse_right_inv hy⟩

/-- An `RCLike` C¹ map from a Banach space to a boundaryless manifold has
range containing a neighborhood of its value wherever its manifold derivative
is invertible.

This is the inverse-function consequence used for the Lie exponential. It is
proved in an extended chart because the manifold inverse-function theorem is
not currently packaged in this direction. -/
theorem range_mem_interior_of_contMDiffAt_of_mfderiv_isInvertible
    {𝕜 E' H' M : Type*}
    [RCLike 𝕜]
    [NormedAddCommGroup E'] [NormedSpace 𝕜 E'] [CompleteSpace E']
    [TopologicalSpace H'] (I' : ModelWithCorners 𝕜 E' H')
    [TopologicalSpace M] [ChartedSpace H' M] [IsManifold I' 1 M]
    [I'.Boundaryless]
    {f : E' → M} {x : E'}
    (hf : ContMDiffAt 𝓘(𝕜, E') I' 1 f x)
    (hderiv : (mfderiv 𝓘(𝕜, E') I' f x).IsInvertible) :
    f x ∈ interior (Set.range f) := by
  let e := extChartAt I' (f x)
  let g : E' → E' := fun y => e (f y)
  have hg_contDiff : ContDiffAt 𝕜 1 g x := by
    have h := (contMDiffAt_iff_target.mp hf).2
    exact h.contDiffAt
  have hf_md : MDifferentiableAt 𝓘(𝕜, E') I' f x :=
    hf.mdifferentiableAt one_ne_zero
  have he_md : MDifferentiableAt I' 𝓘(𝕜, E') e (f x) :=
    mdifferentiableAt_extChartAt (mem_chart_source H' (f x))
  have hg_mfderiv :
      mfderiv 𝓘(𝕜, E') 𝓘(𝕜, E') g x =
        (mfderiv I' 𝓘(𝕜, E') e (f x)).comp
          (mfderiv 𝓘(𝕜, E') I' f x) := by
    exact mfderiv_comp x he_md hf_md
  have hg_invertible : (fderiv 𝕜 g x).IsInvertible := by
    rw [← mfderiv_eq_fderiv, hg_mfderiv]
    exact (isInvertible_mfderiv_extChartAt
      (I := I') (x := f x) (y := f x)
        (mem_extChartAt_source (I := I') (f x))).comp hderiv
  obtain ⟨g', hg'⟩ := hg_invertible
  have hg_hasFDeriv : HasFDerivAt g (g' : E' →L[𝕜] E') x := by
    rw [hg']
    exact (hg_contDiff.differentiableAt one_ne_zero).hasFDerivAt
  have hmap : Filter.map g (nhds x) = nhds (g x) :=
    (hg_contDiff.hasStrictFDerivAt' (f' := (g' : E' →L[𝕜] E')) hg_hasFDeriv
      one_ne_zero).map_nhds_eq_of_equiv
  have hsource : f ⁻¹' e.source ∈ nhds x :=
    hf.continuousAt.preimage_mem_nhds
      (extChartAt_source_mem_nhds (I := I') (f x))
  let t : Set E' := g '' (f ⁻¹' e.source)
  have ht : t ∈ nhds (g x) := by
    rw [← hmap]
    change g ⁻¹' t ∈ nhds x
    exact Filter.mem_of_superset hsource (Set.subset_preimage_image g _)
  have hpre : e ⁻¹' t ∈ nhds (f x) := by
    have ht' : t ∈ Filter.map e (nhds (f x)) := by
      rw [map_extChartAt_nhds_of_boundaryless (I := I')]
      exact ht
    exact ht'
  rw [mem_interior_iff_mem_nhds]
  apply Filter.mem_of_superset
    (Filter.inter_mem hpre (extChartAt_source_mem_nhds (I := I') (f x)))
  rintro y ⟨hy, hy_source⟩
  obtain ⟨z, hz_source, hz⟩ := hy
  refine ⟨z, ?_⟩
  exact e.injOn hz_source hy_source hz

/-- An invertible manifold derivative also gives a neighborhood on which the
    original map is injective.  The proof uses the same extended-chart
    construction as the range-interior lemma above. -/
theorem eventually_injective_of_contMDiffAt_of_mfderiv_isInvertible
    {𝕜 E' H' M : Type*}
    [RCLike 𝕜]
    [NormedAddCommGroup E'] [NormedSpace 𝕜 E'] [CompleteSpace E']
    [TopologicalSpace H'] (I' : ModelWithCorners 𝕜 E' H')
    [TopologicalSpace M] [ChartedSpace H' M] [IsManifold I' 1 M]
    [I'.Boundaryless]
    {f : E' → M} {x : E'}
    (hf : ContMDiffAt 𝓘(𝕜, E') I' 1 f x)
    (hderiv : (mfderiv 𝓘(𝕜, E') I' f x).IsInvertible) :
    ∃ U ∈ 𝓝 x, Set.InjOn f U := by
  let e := extChartAt I' (f x)
  let g : E' → E' := fun y => e (f y)
  have hg_contDiff : ContDiffAt 𝕜 1 g x := by
    have h := (contMDiffAt_iff_target.mp hf).2
    exact h.contDiffAt
  have hf_md : MDifferentiableAt 𝓘(𝕜, E') I' f x :=
    hf.mdifferentiableAt one_ne_zero
  have he_md : MDifferentiableAt I' 𝓘(𝕜, E') e (f x) :=
    mdifferentiableAt_extChartAt (mem_chart_source H' (f x))
  have hg_mfderiv :
      mfderiv 𝓘(𝕜, E') 𝓘(𝕜, E') g x =
        (mfderiv I' 𝓘(𝕜, E') e (f x)).comp
          (mfderiv 𝓘(𝕜, E') I' f x) := by
    exact mfderiv_comp x he_md hf_md
  have hg_invertible : (fderiv 𝕜 g x).IsInvertible := by
    rw [← mfderiv_eq_fderiv, hg_mfderiv]
    exact (isInvertible_mfderiv_extChartAt
      (I := I') (x := f x) (y := f x)
        (mem_extChartAt_source (I := I') (f x))).comp hderiv
  obtain ⟨e', he'⟩ := hg_invertible
  have hg_hasFDeriv : HasFDerivAt g (e' : E' →L[𝕜] E') x := by
    rw [he']
    exact (hg_contDiff.differentiableAt one_ne_zero).hasFDerivAt
  let φ := hg_contDiff.toOpenPartialHomeomorph g hg_hasFDeriv one_ne_zero
  have hφg : (φ : E' → E') = g := by
    dsimp [φ]
  let U : Set E' := φ.source
  refine ⟨U, ?_, ?_⟩
  · have hφx : x ∈ φ.source := by
      dsimp [φ]
      exact ContDiffAt.mem_toOpenPartialHomeomorph_source
        hg_contDiff hg_hasFDeriv one_ne_zero
    exact φ.open_source.mem_nhds hφx
  · intro y hy z hz hyz
    have hy' : y ∈ φ.source := by simpa [U] using hy
    have hz' : z ∈ φ.source := by simpa [U] using hz
    apply φ.injOn hy' hz'
    rw [hφg]
    dsimp [g, e]
    rw [hyz]

/-!
### Consuming the adjoint producer
-/

/-- Conjugation functoriality for a candidate exponential, together with the
compact adjoint calculation, makes every exponential point central. -/
theorem commute_exponential_of_conjugation_exp
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (exponential : E → G)
    (hconjugation_exp : ∀ (x : G) (v : E),
      complexLieConjugation x (exponential v) =
        exponential ((complexLieAdjoint (G := G) I x) v))
    (a : G) (v : E) :
    Commute a (exponential v) := by
  apply (commute_iff_eq a (exponential v)).2
  calc
    a * exponential v = (a * exponential v * a⁻¹) * a := by
      simp [mul_assoc]
    _ = exponential ((complexLieAdjoint (G := G) I a) v) * a := by
      have hconj := hconjugation_exp a v
      change a * exponential v * a⁻¹ =
        exponential ((complexLieAdjoint (G := G) I a) v) at hconj
      rw [hconj]
    _ = exponential v * a := by
      rw [complexLieAdjoint_eq_id (G := G) I a]
      rfl

/-- Every point is fixed by conjugation once the explicit exponential boundary
is supplied and the compact adjoint map is trivial. -/
theorem complexLieConjugation_eq_self_of_exponential
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (d : ComplexLieExponentialData (E := E) (H := H) (G := G) I) (x y : G) :
    complexLieConjugation x y = y := by
  have hcentral : ∀ z ∈ Set.range d.exponential, ∀ a : G, Commute a z := by
    intro z hz
    obtain ⟨v, rfl⟩ := hz
    intro a
    exact commute_exponential_of_conjugation_exp
      (G := G) I d.exponential d.conjugation_exp a v
  have hgen : Subgroup.closure (Set.range d.exponential) = (⊤ : Subgroup G) :=
    d.exponential_generates
  have hcomm : Commute x y := by
    have hmul : IsMulCommutative G :=
      isMulCommutative_of_central_generators hcentral hgen
    exact (isMulCommutative_iff.mp hmul) x y
  change x * y * x⁻¹ = y
  exact hcomm.mul_inv_cancel

/-- A local-diffeomorphism candidate for the exponential suffices for
commutativity once conjugation functoriality is supplied.  This discharges the
inverse-neighborhood and connected-generation steps, but it does not construct
the Lie exponential or prove its functoriality. -/
theorem complexLieGroup_isMulCommutative_of_local_exponential
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (exponential : E → G)
    (hexponential_zero : exponential 0 = 1)
    (hexponential_local :
      IsLocalDiffeomorphAt 𝓘(ℂ, E) I ⊤ exponential 0)
    (hconjugation_exp : ∀ (x : G) (v : E),
      complexLieConjugation x (exponential v) =
        exponential ((complexLieAdjoint (G := G) I x) v)) :
    IsMulCommutative G := by
  letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I ⊤
  apply isMulCommutative_of_central_nhds (s := Set.range exponential)
  · intro z hz a
    obtain ⟨v, rfl⟩ := hz
    exact commute_exponential_of_conjugation_exp
      (G := G) I exponential hconjugation_exp a v
  · have hlocal :=
      range_mem_interior_of_isLocalDiffeomorphAt hexponential_local
    simpa only [hexponential_zero] using hlocal

/-- A `C¹` candidate exponential with identity derivative at zero suffices for
commutativity once conjugation functoriality is supplied. The inverse-function
and connected-generation steps are consequences rather than hypotheses here;
the theorem still does not construct the exponential or its functoriality. -/
theorem complexLieGroup_isMulCommutative_of_exponential_mfderiv
    [CompleteSpace E]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (exponential : E → G)
    (hexponential_zero : exponential 0 = 1)
    (hexponential_contMDiffAt :
      ContMDiffAt 𝓘(ℂ, E) I 1 exponential 0)
    (hexponential_mfderiv :
      mfderiv 𝓘(ℂ, E) I exponential 0 = ContinuousLinearMap.id ℂ E)
    (hconjugation_exp : ∀ (x : G) (v : E),
      complexLieConjugation x (exponential v) =
        exponential ((complexLieAdjoint (G := G) I x) v)) :
    IsMulCommutative G := by
  letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I ⊤
  apply isMulCommutative_of_central_nhds (s := Set.range exponential)
  · intro z hz a
    obtain ⟨v, rfl⟩ := hz
    exact commute_exponential_of_conjugation_exp
      (G := G) I exponential hconjugation_exp a v
  · have hderiv :
        (mfderiv 𝓘(ℂ, E) I exponential 0).IsInvertible := by
      rw [hexponential_mfderiv]
      exact ⟨ContinuousLinearEquiv.refl ℂ E, rfl⟩
    have hlocal :=
      range_mem_interior_of_contMDiffAt_of_mfderiv_isInvertible
        I hexponential_contMDiffAt hderiv
    simpa only [hexponential_zero] using hlocal

/-- The compact connected complex Lie group is commutative under the explicit
exponential boundary. -/
theorem complexLieGroup_isMulCommutative_of_exponential
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (d : ComplexLieExponentialData (E := E) (H := H) (G := G) I) :
    IsMulCommutative G := by
  apply isMulCommutative_iff.mpr
  intro x y
  have h := complexLieConjugation_eq_self_of_exponential
    (G := G) I d x y
  change x * y * x⁻¹ = y at h
  calc
    x * y = (x * y * x⁻¹) * x := by simp [mul_assoc]
    _ = y * x := by rw [h]

/-!
### Commutativity from canonical real flows
-/

/-- The time-one values of the canonical real flows contain an identity
neighborhood.  The inverse-function theorem is applied in the real model
coordinates `E`; an explicit linear equivalence then identifies that range
with the range parametrized by the underlying real Lie algebra. -/
theorem canonicalRealFlow_time_one_mem_interior
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    (1 : G) ∈ interior (Set.range
      (fun v : GroupLieAlgebra (complexToRealModel I) G =>
        canonicalRealFlow (G := G) I v 1)) := by
  let e : E ≃ₗ[ℝ] GroupLieAlgebra (complexToRealModel I) G :=
    complexToRealLieAlgebraEquiv I
  let f : E → G := fun v => canonicalRealFlow (G := G) I v 1
  let exp : GroupLieAlgebra (complexToRealModel I) G → G :=
    fun v => canonicalRealFlow (G := G) I v 1
  have hf : ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1 f := by
    simpa [f] using (canonicalRealFlow_time_one_contMDiff (G := G) I)
  have hdiff : MDifferentiableAt 𝓘(ℝ, E) (complexToRealModel I) f 0 :=
    hf.mdifferentiableAt one_ne_zero
  have hderiv :
      mfderiv 𝓘(ℝ, E) (complexToRealModel I) f 0 =
        ContinuousLinearMap.id ℝ E := by
    dsimp [f]
    exact mfderiv_canonicalRealFlow_time_one_eq_id (G := G) I hdiff
  have hinvertible :
      (mfderiv 𝓘(ℝ, E) (complexToRealModel I) f 0).IsInvertible := by
    rw [hderiv]
    exact ⟨ContinuousLinearEquiv.refl ℝ E, rfl⟩
  have hlocal :=
    range_mem_interior_of_contMDiffAt_of_mfderiv_isInvertible
      (𝕜 := ℝ) (I' := complexToRealModel I) hf.contMDiffAt hinvertible
  have hzero : f 0 = (1 : G) := by
    dsimp [f]
    change canonicalRealFlow (G := G) I
      (0 : GroupLieAlgebra (complexToRealModel I) G) 1 = 1
    exact congrFun (canonicalRealFlow_zero (G := G) I) (1 : ℝ)
  have hlocal_one : (1 : G) ∈ interior (Set.range f) := by
    rw [← hzero]
    exact hlocal
  have hrange : Set.range f = Set.range exp := by
    apply Set.Subset.antisymm
    · rintro z ⟨v, rfl⟩
      refine ⟨e v, ?_⟩
      simp [exp, f, e, complexToRealLieAlgebraEquiv,
        complexToRealLieAlgebraMap]
    · rintro z ⟨v, rfl⟩
      obtain ⟨u, rfl⟩ := e.surjective v
      refine ⟨u, ?_⟩
      simp [exp, f, e, complexToRealLieAlgebraEquiv,
        complexToRealLieAlgebraMap]
  rw [← hrange]
  exact hlocal_one

/-! The realified inverse-function argument also supplies local injectivity for
    the named complex exponential candidate.  This is a topological statement
    about the underlying tangent space; it does not assert complex `C¹`
    regularity. -/
theorem canonicalComplexExponential_exists_nhds_injOn
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    ∃ U ∈ 𝓝 (0 : E),
      Set.InjOn (canonicalComplexExponential (G := G) I) U := by
  let f : E → G := fun v => canonicalRealFlow (G := G) I v 1
  have hf : ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1 f := by
    simpa [f] using (canonicalRealFlow_time_one_contMDiff (G := G) I)
  have hdiff : MDifferentiableAt 𝓘(ℝ, E) (complexToRealModel I) f 0 :=
    hf.mdifferentiableAt one_ne_zero
  have hderiv :
      mfderiv 𝓘(ℝ, E) (complexToRealModel I) f 0 =
        ContinuousLinearMap.id ℝ E := by
    dsimp [f]
    exact mfderiv_canonicalRealFlow_time_one_eq_id (G := G) I hdiff
  have hinvertible :
      (mfderiv 𝓘(ℝ, E) (complexToRealModel I) f 0).IsInvertible := by
    rw [hderiv]
    exact ⟨ContinuousLinearEquiv.refl ℝ E, rfl⟩
  obtain ⟨U, hU, hUinj⟩ :=
    eventually_injective_of_contMDiffAt_of_mfderiv_isInvertible
      (𝕜 := ℝ) (I' := complexToRealModel I) hf.contMDiffAt hinvertible
  refine ⟨U, hU, ?_⟩
  intro y hy z hz hyz
  apply hUinj hy hz
  change canonicalRealFlow (G := G) I y 1 =
    canonicalRealFlow (G := G) I z 1
  exact hyz

/-! Translation of the zero-neighborhood gives local injectivity at every
    tangent point.  This is the form used by later covering-space arguments. -/
theorem canonicalComplexExponential_exists_nhds_injOn_at
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (x : E) :
    ∃ U ∈ 𝓝 x,
      Set.InjOn (canonicalComplexExponential (G := G) I) U := by
  obtain ⟨U₀, hU₀, hU₀inj⟩ :=
    canonicalComplexExponential_exists_nhds_injOn (G := G) I
  let U : Set E := (fun y : E => y - x) ⁻¹' U₀
  have hU : U ∈ 𝓝 x := by
    change (fun y : E => y - x) ⁻¹' U₀ ∈ 𝓝 x
    have hcont : ContinuousAt (fun y : E => y - x) x :=
      (continuous_id.sub (continuous_const : Continuous (fun _ : E => x))).continuousAt
    exact hcont.preimage_mem_nhds (by simpa using hU₀)
  refine ⟨U, hU, ?_⟩
  intro y hy z hz hyz
  have hy' : y - x ∈ U₀ := hy
  have hz' : z - x ∈ U₀ := hz
  have htranslate (v : E) :
      canonicalComplexExponential (G := G) I (v - x) =
        canonicalComplexExponential (G := G) I v *
          (canonicalComplexExponential (G := G) I x)⁻¹ := by
    have hv :
        canonicalComplexExponential (G := G) I v =
          canonicalComplexExponential (G := G) I (v - x) *
            canonicalComplexExponential (G := G) I x := by
      simpa [sub_add_cancel] using
        (canonicalComplexExponential_add (G := G) I (v - x) x)
    calc
      canonicalComplexExponential (G := G) I (v - x) =
          (canonicalComplexExponential (G := G) I (v - x) *
            canonicalComplexExponential (G := G) I x) *
              (canonicalComplexExponential (G := G) I x)⁻¹ := by
            simp
      _ = canonicalComplexExponential (G := G) I v *
            (canonicalComplexExponential (G := G) I x)⁻¹ := by rw [hv]
  apply sub_left_injective
  apply hU₀inj hy' hz'
  calc
    canonicalComplexExponential (G := G) I (y - x) =
        canonicalComplexExponential (G := G) I y *
          (canonicalComplexExponential (G := G) I x)⁻¹ :=
      htranslate y
    _ = canonicalComplexExponential (G := G) I z *
          (canonicalComplexExponential (G := G) I x)⁻¹ := by rw [hyz]
    _ = canonicalComplexExponential (G := G) I (z - x) :=
      (htranslate z).symm

/-! Local injectivity at the identity propagates to every point of the kernel
    by additive translation.  This is the topological consequence needed before
    one can ask for a full period-lattice certificate. -/
theorem isDiscrete_ker_of_exists_nhds_injOn
    {E Y : Type*} [AddCommGroup E] [TopologicalSpace E]
    [IsTopologicalAddGroup E] [AddZeroClass Y]
    (f : E →+ Y)
    (hlocal : ∃ U ∈ 𝓝 (0 : E), Set.InjOn f U) :
    IsDiscrete (f.ker : Set E) := by
  obtain ⟨U, hUnhds, hfinj⟩ := hlocal
  obtain ⟨O, hOU, hOopen, hOzero⟩ := mem_nhds_iff.mp hUnhds
  apply isDiscrete_iff_forall_exists_isOpen.mpr
  intro x hx
  let V : Set E := (fun y : E => y - x) ⁻¹' O
  have hVopen : IsOpen V := by
    change IsOpen ((fun y : E => y - x) ⁻¹' O)
    exact IsOpen.preimage (continuous_id.sub continuous_const) hOopen
  refine ⟨V, hVopen, ?_⟩
  ext y
  constructor
  · rintro ⟨hyV, hyK⟩
    change y - x ∈ O at hyV
    have hdiffK : y - x ∈ f.ker := sub_mem hyK hx
    have hdiffU : y - x ∈ U := hOU hyV
    have hzeroU : (0 : E) ∈ U := mem_of_mem_nhds hUnhds
    have hfdiff : f (y - x) = f 0 := by
      rw [f.mem_ker.mp hdiffK, f.map_zero]
    have hdiffzero : y - x = 0 := hfinj hdiffU hzeroU hfdiff
    exact sub_eq_zero.mp hdiffzero
  · intro hy
    have hyx : y = x := by simpa using hy
    subst y
    constructor
    · change x - x ∈ O
      simpa using hOzero
    · exact hx

/-! The local inverse theorem therefore isolates zero in the kernel of the
    additive presentation of the canonical exponential.  The result is a
    genuine discreteness statement, while the stronger full-lattice assertion
    remains an explicit external boundary. -/
theorem canonicalComplexExponential_kernel_isDiscrete
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    IsDiscrete
      ((canonicalComplexExponentialAddHom (G := G) I).ker : Set E) := by
  apply isDiscrete_ker_of_exists_nhds_injOn
    (canonicalComplexExponentialAddHom (G := G) I)
  obtain ⟨U, hU, hUinj⟩ :=
    canonicalComplexExponential_exists_nhds_injOn (G := G) I
  refine ⟨U, hU, ?_⟩
  intro y hy z hz hyz
  apply hUinj hy hz
  exact Additive.ofMul.injective hyz

/-- The time-one canonical real flow is surjective.  Its image is a subgroup
that contains an identity neighborhood, hence is both open and closed in the
preconnected group.  This is a real surjectivity statement; it does not yet
provide the complex-linear lattice data required by uniformization. -/
theorem canonicalRealFlow_time_one_surjective
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    Function.Surjective (fun v : GroupLieAlgebra (complexToRealModel I) G =>
      canonicalRealFlow (G := G) I v 1) := by
  letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I ⊤
  let exp : GroupLieAlgebra (complexToRealModel I) G → G :=
    fun v => canonicalRealFlow (G := G) I v 1
  have hzero : exp 0 = (1 : G) := by
    dsimp [exp]
    exact congrFun (canonicalRealFlow_zero (G := G) I) (1 : ℝ)
  have hadd (v w : GroupLieAlgebra (complexToRealModel I) G) :
      exp (v + w) = exp v * exp w := by
    exact canonicalRealFlow_add (G := G) I v w 1
  have hinv (v : GroupLieAlgebra (complexToRealModel I) G) :
      exp (-v) = (exp v)⁻¹ := by
    exact canonicalRealFlow_neg (G := G) I v 1
  let Hexp : Subgroup G :=
    { carrier := Set.range exp
      one_mem' := ⟨0, hzero⟩
      mul_mem' := by
        intro a b ha hb
        obtain ⟨v, rfl⟩ := ha
        obtain ⟨w, rfl⟩ := hb
        exact ⟨v + w, hadd v w⟩
      inv_mem' := by
        intro a ha
        obtain ⟨v, rfl⟩ := ha
        exact ⟨-v, hinv v⟩ }
  have h1 : (1 : G) ∈ interior (Hexp : Set G) := by
    simpa [Hexp, exp] using
      (canonicalRealFlow_time_one_mem_interior (G := G) I)
  have hopen : IsOpen (Hexp : Set G) :=
    Hexp.isOpen_of_one_mem_interior h1
  have hclosed : IsClosed (Hexp : Set G) :=
    Hexp.isClosed_of_isOpen hopen
  have hclopen : IsClopen (Hexp : Set G) := ⟨hclosed, hopen⟩
  have huniv : (Hexp : Set G) = Set.univ :=
    hclopen.eq_univ ⟨1, Hexp.one_mem⟩
  intro x
  have hx : x ∈ (Hexp : Set G) := by
    rw [huniv]
    exact Set.mem_univ x
  exact hx

/-!
### Consuming the named complex exponential candidate

The real flow supplies the global range statement.  Complex one-parameter
uniqueness supplies naturality, and the resulting exponential data feeds the
central-generator commutativity argument. -/

/-- The named complex exponential candidate is surjective because its
underlying real time-one flow is surjective. -/
theorem canonicalComplexExponential_surjective
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    Function.Surjective (canonicalComplexExponential (G := G) I) := by
  intro x
  obtain ⟨v, hv⟩ := canonicalRealFlow_time_one_surjective (G := G) I x
  refine ⟨v, ?_⟩
  change canonicalRealFlow (G := G) I
    (complexToRealLieAlgebraMap I v) 1 = x
  exact hv

/-- Surjectivity of the bundled multiplicative exponential homomorphism. -/
theorem canonicalComplexExponentialMonoidHom_surjective
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    Function.Surjective (canonicalComplexExponentialMonoidHom (G := G) I) := by
  intro x
  obtain ⟨v, hv⟩ := canonicalComplexExponential_surjective (G := G) I x
  refine ⟨Multiplicative.ofAdd v, ?_⟩
  simpa using hv

/-! The canonical candidate can be supplied to the explicit exponential
    interface.  Its construction comes from real invariant flows, while its
    complex regularity, uniqueness, and naturality are proved separately. -/

set_option backward.isDefEq.respectTransparency false in
/-- Conjugation naturality for every complex parameter of the canonical flow.
The statement is in the chosen model coordinates.  It follows from uniqueness
of holomorphic one-parameter subgroups and the compact adjoint calculation. -/
theorem canonicalComplexFlow_conjugation
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (x : G) (v : E) (z : ℂ) :
    complexLieConjugation x (canonicalComplexFlow (G := G) I v z) =
      canonicalComplexFlow (G := G) I
        ((complexLieAdjoint (G := G) I x) v) z := by
  rw [complexLieAdjoint_eq_id (G := G) I x]
  let F : G →* G := (MulAut.conj x).toMonoidHom
  have hFfun : (F : G → G) = complexLieConjugation x := by
    funext y
    simp [F, complexLieConjugation, MulAut.conj_apply]
  have hF : MDifferentiable I I F := by
    rw [hFfun]
    have hc : ContMDiff I I ω (complexLieConjugation x) :=
      (contMDiff_const.mul contMDiff_id).mul contMDiff_const.inv
    exact hc.mdifferentiable (by simp)
  have hderiv_v : mfderiv I I F 1 v = v := by
    rw [hFfun, mfderiv_complexLieConjugation_one_eq_id (G := G) I x]
    rfl
  have hnat := complexLieExponential_naturality I I F hF v z
  rw [hderiv_v, hFfun] at hnat
  exact hnat

/-- Conjugation naturality for the canonical time-one exponential candidate,
obtained by specializing `canonicalComplexFlow_conjugation`. -/
theorem canonicalComplexExponential_conjugation
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G]
    (x : G) (v : E) :
    complexLieConjugation x (canonicalComplexExponential (G := G) I v) =
      canonicalComplexExponential (G := G) I
        ((complexLieAdjoint (G := G) I x) v) := by
  have h := canonicalComplexFlow_conjugation (G := G) I x v (1 : ℂ)
  simpa only [canonicalComplexExponential,
    canonicalComplexFlow_eq_exponential_smul, one_smul] using h

/-- The canonical holomorphic exponential packaged as the explicit interface
used by the commutativity argument. -/
noncomputable def canonicalComplexLieExponentialData
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    ComplexLieExponentialData (G := G) I where
  exponential := canonicalComplexExponential (G := G) I
  exponential_zero := canonicalComplexExponential_zero (G := G) I
  exponential_generates := by
    rw [Set.range_eq_univ.mpr
      (canonicalComplexExponential_surjective (G := G) I)]
    exact Subgroup.closure_univ
  conjugation_exp := canonicalComplexExponential_conjugation (G := G) I

/-- The canonical complex exponential gives a direct central-generator proof
of commutativity. -/
theorem complexLieGroup_isMulCommutative_of_canonicalComplexExponential
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    IsMulCommutative G := by
  exact complexLieGroup_isMulCommutative_of_exponential (G := G) I
    (canonicalComplexLieExponentialData (G := G) I)

/-- Every compact connected complex Lie group is commutative.  Holomorphic
exponential naturality makes its generating image central. -/
theorem complexLieGroup_isMulCommutative
    [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    IsMulCommutative G := by
  letI : FiniteDimensional ℂ E :=
    FiniteDimensional.of_locallyCompact_manifold G I
  letI : CompleteSpace E := FiniteDimensional.complete ℂ E
  exact complexLieGroup_isMulCommutative_of_canonicalComplexExponential
    (G := G) I

end Analytic
end Mumford
