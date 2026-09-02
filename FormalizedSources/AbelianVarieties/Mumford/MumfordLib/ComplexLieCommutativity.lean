/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.ComplexLieAdjoint
import Mathlib.Algebra.Group.Commute.Basic
import Mathlib.Algebra.Group.Subgroup.Lattice
import Mathlib.Geometry.Manifold.LocalDiffeomorph
import Mathlib.Topology.Algebra.OpenSubgroup
import Mathlib.Topology.Connected.Clopen

/-!
# The integration interface for compact complex Lie groups

The compact-holomorphic argument in `ComplexLieAdjoint` makes the derivative
of every conjugation map equal to the identity.  This file proves the
local-to-global generation step in Mumford's argument and records the missing
Lie exponential input explicitly.  The resulting Lie-group theorems are
conditional interfaces: they do not assert the existence of an exponential
for an arbitrary Lie group.  The coordinate space `E` is intentionally kept
general here; specializing it to the source's finite-dimensional complex
tangent model is a separate source-fidelity obligation.
-/

set_option autoImplicit false

noncomputable section

open scoped Manifold ContDiff

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

end Analytic
end Mumford
