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

/-! ### Complex regularity and the local analytic inverse

The real flow construction already gives a real `C¹` time-one map, while the
parameter argument gives complex differentiability of the named candidate.
The normed-space scalar-restriction bridge in
`ComplexManifoldRealification` upgrades the extended-chart representative to
complex `C¹`.  Restricting the ordinary normed-space inverse-function theorem
and composing with the existing group chart then produces a genuine manifold
local diffeomorphism.  This is the local analytic input for uniformization; it
does not identify the global quotient with `G`. -/

/-- The canonical exponential written in its identity chart is complex `C¹`.

The real `C¹` statement is used only on the neighborhood where the target
chart is defined, and complex differentiability is supplied on that same
neighborhood. -/
theorem canonicalComplexExponential_chart_contDiffAt
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    ContDiffAt ℂ 1
      ((extChartAt I ((canonicalComplexExponential (G := G) I) 0)) ∘
        (canonicalComplexExponential (G := G) I)) 0 := by
  let f : E → G := canonicalComplexExponential (G := G) I
  let e := extChartAt I (f 0)
  let g : E → E := e ∘ f
  have hf_real : ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1 f := by
    change ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
      (fun v : E => canonicalRealFlow (G := G) I v 1)
    exact canonicalRealFlow_time_one_contMDiff (G := G) I
  have hf_complex : MDifferentiable 𝓘(ℂ, E) I f := by
    simpa [f] using (canonicalComplexExponential_mdifferentiable (G := G) I)
  have hg_real : ContDiffAt ℝ 1 g 0 := by
    have he_real : ContMDiffAt (complexToRealModel I) 𝓘(ℝ, E) 1
        (extChartAt (complexToRealModel I) (f 0)) (f 0) :=
      contMDiffAt_extChartAt
    have hcomp := he_real.comp 0 hf_real.contMDiffAt
    have hcomp' : ContMDiffAt 𝓘(ℝ, E) 𝓘(ℝ, E) 1
        ((extChartAt (complexToRealModel I) (f 0)) ∘ f) 0 := by
      exact hcomp
    exact contMDiffAt_iff_contDiffAt.mp hcomp'
  have hf_continuous : Continuous f := hf_real.continuous
  have hsource : f ⁻¹' (chartAt H (f 0)).source ∈ 𝓝 (0 : E) :=
    hf_continuous.continuousAt.preimage_mem_nhds
      (chart_source_mem_nhds H (f 0))
  have hg_complex : ∀ᶠ y in 𝓝 (0 : E), DifferentiableAt ℂ g y := by
    filter_upwards [hsource] with y hy
    have he_complex : MDifferentiableAt I 𝓘(ℂ, E) e (f y) :=
      mdifferentiableAt_extChartAt hy
    exact (he_complex.comp y (hf_complex y)).differentiableAt
  have hg : ContDiffAt ℂ 1 g 0 :=
    contDiffAt_one_of_real_of_complex hg_real hg_complex
  simpa [f, e, g] using hg

/-- The canonical exponential is a complex `C¹` map at the identity.

This is a chartwise regularity certificate for the existing complex Lie-group
structure, rather than a transported or newly chosen manifold structure. -/
theorem canonicalComplexExponential_contMDiffAt
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    ContMDiffAt 𝓘(ℂ, E) I 1
      (canonicalComplexExponential (G := G) I) 0 := by
  rw [contMDiffAt_iff_target]
  refine ⟨?_, ?_⟩
  · have hreal : ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
        (canonicalComplexExponential (G := G) I) := by
      change ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
        (fun v : E => canonicalRealFlow (G := G) I v 1)
      exact canonicalRealFlow_time_one_contMDiff (G := G) I
    exact hreal.continuous.continuousAt
  · exact (canonicalComplexExponential_chart_contDiffAt (G := G) I).contMDiffAt

/-- The canonical exponential is a complex local diffeomorphism at the
identity.

The proof takes the complex `C¹` extended-chart representative, applies the
normed-space inverse-function theorem, restricts to the open set on which the
original exponential lands in the chart, and packages the resulting inverse
with that chart as a `PartialDiffeomorph`. -/
theorem canonicalComplexExponential_isLocalDiffeomorphAt
    [CompleteSpace E] [T2Space G]
    [I.Boundaryless] [CompactSpace G] [PreconnectedSpace G] :
    IsLocalDiffeomorphAt 𝓘(ℂ, E) I 1
      (canonicalComplexExponential (G := G) I) 0 := by
  let f : E → G := canonicalComplexExponential (G := G) I
  let e := extChartAt I (f 0)
  let g : E → E := e ∘ f
  have hg : ContDiffAt ℂ 1 g 0 := by
    simpa [f, e, g] using
      (canonicalComplexExponential_chart_contDiffAt (G := G) I)
  have hf_complex : MDifferentiable 𝓘(ℂ, E) I f := by
    simpa [f] using (canonicalComplexExponential_mdifferentiable (G := G) I)
  have hf_md : MDifferentiableAt 𝓘(ℂ, E) I f 0 := hf_complex 0
  have he_md : MDifferentiableAt I 𝓘(ℂ, E) e (f 0) :=
    mdifferentiableAt_extChartAt (mem_chart_source H (f 0))
  have hg_mfderiv :
      mfderiv 𝓘(ℂ, E) 𝓘(ℂ, E) g 0 =
        (mfderiv I 𝓘(ℂ, E) e (f 0)).comp
          (mfderiv 𝓘(ℂ, E) I f 0) := by
    exact mfderiv_comp 0 he_md hf_md
  have hderiv_f : mfderiv 𝓘(ℂ, E) I f 0 = ContinuousLinearMap.id ℂ E := by
    exact (canonicalComplexExponential_hasMFDerivAt_zero (G := G) I).mfderiv
  have hg_invertible : (fderiv ℂ g 0).IsInvertible := by
    rw [← mfderiv_eq_fderiv, hg_mfderiv, hderiv_f]
    exact (isInvertible_mfderiv_extChartAt
      (I := I) (x := f 0) (y := f 0)
        (mem_extChartAt_source (I := I) (f 0))).comp
      ⟨ContinuousLinearEquiv.refl ℂ E, rfl⟩
  obtain ⟨g', hg'⟩ := hg_invertible
  have hg_hasFDeriv : HasFDerivAt g (g' : E →L[ℂ] E) 0 := by
    rw [hg']
    exact (hg.differentiableAt one_ne_zero).hasFDerivAt
  let φ : OpenPartialHomeomorph E E :=
    hg.toOpenPartialHomeomorph g hg_hasFDeriv one_ne_zero
  have hφ0 : (0 : E) ∈ φ.source :=
    hg.mem_toOpenPartialHomeomorph_source hg_hasFDeriv one_ne_zero
  have hφ0_target : g 0 ∈ φ.target :=
    hg.image_mem_toOpenPartialHomeomorph_target hg_hasFDeriv one_ne_zero
  have hφinv : ContDiffAt ℂ 1 (φ.symm : E → E) (g 0) := by
    have hpoint : φ.symm (g 0) = 0 := φ.left_inv hφ0
    apply φ.contDiffAt_symm (f₀' := g') hφ0_target
    · simpa [φ, hpoint] using hg_hasFDeriv
    · simpa [φ, hpoint] using hg
  let s : Set E := f ⁻¹' e.source
  have hf_real : ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1 f := by
    change ContMDiff 𝓘(ℝ, E) (complexToRealModel I) 1
      (fun v : E => canonicalRealFlow (G := G) I v 1)
    exact canonicalRealFlow_time_one_contMDiff (G := G) I
  have hs_open : IsOpen s := by
    exact (isOpen_extChartAt_source (I := I) (f 0)).preimage
      hf_real.continuous
  let φs : OpenPartialHomeomorph E E := φ.restrOpen s hs_open
  have hφs0 : (0 : E) ∈ φs.source := by
    rw [OpenPartialHomeomorph.restrOpen_source]
    exact ⟨hφ0, mem_extChartAt_source (I := I) (f 0)⟩
  have hφs0_target : g 0 ∈ φs.target := φs.map_source hφs0
  have hφs_inv : ContDiffAt ℂ 1 (φs.symm : E → E) (g 0) := by
    have hpoint : φs.symm (g 0) = 0 := φs.left_inv hφs0
    apply φs.contDiffAt_symm (f₀' := g') hφs0_target
    · simpa [φs, φ, hpoint] using hg_hasFDeriv
    · simpa [φs, φ, hpoint] using hg
  let ψ : OpenPartialHomeomorph E E := φs.restrContDiff ℂ 1 (by norm_num)
  have hψ0 : (0 : E) ∈ ψ.source := by
    rw [OpenPartialHomeomorph.restrContDiff_source]
    exact ⟨hφs0, hg, hφs_inv⟩
  have hψ_smooth : ContDiffOn ℂ 1 (ψ : E → E) ψ.source := by
    have hbase := φs.contDiffOn_restrContDiff_source (𝕜 := ℂ)
      (n := (1 : ℕ∞ω)) (by norm_num)
    apply hbase.congr
    intro y hy
    exact OpenPartialHomeomorph.restrContDiff_apply ℂ φs 1 (by norm_num) y
  have hψ_inv_smooth : ContDiffOn ℂ 1 (ψ.symm : E → E) ψ.target := by
    have hbase := φs.contDiffOn_restrContDiff_target (𝕜 := ℂ)
      (n := (1 : ℕ∞ω)) (by norm_num)
    apply hbase.congr
    intro y hy
    exact OpenPartialHomeomorph.restrContDiff_symm_apply ℂ φs 1
      (by norm_num) y
  let Pψ : PartialDiffeomorph 𝓘(ℂ, E) 𝓘(ℂ, E) E E 1 :=
    PartialDiffeomorph.mk ψ.toPartialEquiv ψ.open_source ψ.open_target
      hψ_smooth.contMDiffOn hψ_inv_smooth.contMDiffOn
  let χ : PartialDiffeomorph 𝓘(ℂ, E) I E G 1 :=
    PartialDiffeomorph.mk e.symm
      (by simpa [e] using (isOpen_extChartAt_target (I := I) (f 0)))
      (by simpa [e] using (isOpen_extChartAt_source (I := I) (f 0)))
      (by
        simpa [e] using
          (contMDiffOn_extChartAt_symm (I := I) (n := (1 : ℕ∞ω)) (f 0)))
      (by
        simpa [e] using
          (contMDiffOn_extChartAt (I := I) (n := (1 : ℕ∞ω)) (x := f 0)))
  let P : PartialDiffeomorph 𝓘(ℂ, E) I E G 1 := Pψ.trans χ
  have hP0 : (0 : E) ∈ P.source := by
    change 0 ∈ (Pψ.toPartialEquiv.trans χ.toPartialEquiv).source
    rw [PartialEquiv.trans_source]
    refine ⟨hψ0, ?_⟩
    change ψ 0 ∈ e.symm.source
    change g 0 ∈ e.target
    exact e.map_source (mem_extChartAt_source (I := I) (f 0))
  refine ⟨P, hP0, ?_⟩
  intro y hy
  change f y = e.symm (ψ y)
  have hyψ : y ∈ ψ.source := hy.1
  have hyφs : y ∈ φs.source := by
    rw [OpenPartialHomeomorph.restrContDiff_source] at hyψ
    exact hyψ.1
  have hy_s : y ∈ s := by
    rw [OpenPartialHomeomorph.restrOpen_source] at hyφs
    exact hyφs.2
  have hy_e : f y ∈ e.source := hy_s
  have hy_eq : ψ y = g y := by
    change ψ y = φ y
    rfl
  rw [hy_eq]
  exact (e.left_inv hy_e).symm

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
  let e : E ≃ₗ[ℂ] GroupLieAlgebra I G :=
    complexLieAlgebraEquiv (G := G) I
  let Φ : ℂ × GroupLieAlgebra I G → G := fun p =>
    canonicalComplexFlow (G := G) I (e.symm p.2) p.1
  let F : G →* G := (MulAut.conj x).toMonoidHom
  let Ψ : ℂ × GroupLieAlgebra I G → G := fun p => F (Φ p)
  let P : (ℂ × GroupLieAlgebra I G → G) → Prop := fun Ξ =>
    (∀ w : GroupLieAlgebra I G, Ξ (0, w) = 1) ∧
    (∀ (w : GroupLieAlgebra I G) (a b : ℂ),
      Ξ (a + b, w) = Ξ (a, w) * Ξ (b, w)) ∧
    MDifferentiable (𝓘(ℂ).prod 𝓘(ℂ, E)) I
      (fun p : ℂ × E => Ξ (p.1, e p.2)) ∧
    (∀ w : GroupLieAlgebra I G,
      HasMFDerivAt 𝓘(ℂ) I (fun a : ℂ => Ξ (a, w)) 0
        ((ContinuousLinearMap.id ℂ ℂ).smulRight w))
  have hunique : ∃! Ξ, P Ξ := by
    simpa [P, e] using
      (existsUnique_intrinsicComplexLieExponentialFamily (G := G) I)
  have hΦ : P Φ := by
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro w
      simp [Φ]
    · intro w a b
      simpa [Φ] using
        canonicalComplexFlow_add_parameter (G := G) I (e.symm w) a b
    · simpa [Φ, e] using
        (canonicalComplexFlow_mdifferentiable_joint (G := G) I)
    · intro w
      simpa [Φ, e] using
        canonicalComplexFlow_hasMFDerivAt_zero (G := G) I (e.symm w)
  have hFfun : (F : G → G) = complexLieConjugation x := by
    funext y
    simp [F, complexLieConjugation, MulAut.conj_apply]
  have hF : MDifferentiable I I F := by
    rw [hFfun]
    have hc : ContMDiff I I ω (complexLieConjugation x) :=
      (contMDiff_const.mul contMDiff_id).mul contMDiff_const.inv
    exact hc.mdifferentiable (by simp)
  have hFderiv : HasMFDerivAt I I F 1
      (ContinuousLinearMap.id ℂ E) := by
    have h := (hF 1).hasMFDerivAt
    have hd : mfderiv I I F 1 = ContinuousLinearMap.id ℂ E := by
      rw [hFfun, mfderiv_complexLieConjugation_one_eq_id (G := G) I x]
    exact h.congr_mfderiv hd
  have hΨ : P Ψ := by
    refine ⟨?_, ?_, ?_, ?_⟩
    · intro w
      simp [Ψ, hΦ.1 w]
    · intro w a b
      dsimp [Ψ]
      rw [hΦ.2.1 w a b, F.map_mul]
    · have hcomp := hF.comp hΦ.2.2.1
      simpa [Ψ, Function.comp_def] using hcomp
    · intro w
      have hFderiv' : HasMFDerivAt I I F (Φ (0, w))
          (ContinuousLinearMap.id ℂ E) := by
        rw [hΦ.1 w]
        exact hFderiv
      have hcomp := hFderiv'.comp 0 (hΦ.2.2.2 w)
      have hmap :
          (ContinuousLinearMap.id ℂ E).comp
              ((ContinuousLinearMap.id ℂ ℂ).smulRight w) =
            (ContinuousLinearMap.id ℂ ℂ).smulRight w := by
        apply ContinuousLinearMap.ext
        intro c
        change c • (w : E) = c • (w : E)
        rfl
      exact (hcomp.congr_mfderiv hmap : HasMFDerivAt 𝓘(ℂ) I
        (fun a : ℂ => Ψ (a, w)) 0
          ((ContinuousLinearMap.id ℂ ℂ).smulRight w))
  have heq : Ψ = Φ := hunique.unique hΨ hΦ
  have hpoint := congrFun heq (z, e v)
  dsimp [Ψ, Φ] at hpoint
  rw [hFfun] at hpoint
  simpa [e] using hpoint

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
    letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I ⊤
    apply subgroup_closure_eq_top_of_one_mem_interior
    have hlocal :=
      range_mem_interior_of_isLocalDiffeomorphAt
        (canonicalComplexExponential_isLocalDiffeomorphAt (G := G) I)
    simpa only [canonicalComplexExponential_zero] using hlocal
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
