/-
Copyright (c) 2026 The Mumford Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The Mumford Contributors
-/

import MumfordLib.CanonicalComplexQuotient
import MumfordLib.ComplexExponentialAtlas
import MumfordLib.IntrinsicComplexUniformization
import MumfordLib.LatticeQuotientDiffeomorph
import MumfordLib.TranslationTopology
import Mathlib.Geometry.Manifold.Diffeomorph
import Mathlib.Geometry.Manifold.LocalDiffeomorph

/-!
# Diffeomorphic quotient bridge for the canonical candidate

The quotient projection and the canonical exponential are local complex
diffeomorphisms. Smooth descent along these maps makes the induced quotient
equivalence a complex `C¹` diffeomorphism, respecting the group operations.
The quotient uses its explicit lattice branch atlas and the target uses its
original Lie-group charts. The tangent model has a supplied complex coordinate;
the source-level identification with the intrinsic exponential remains separate.
-/

set_option autoImplicit false

open scoped Manifold ContDiff

namespace Mumford
namespace Analytic

noncomputable section

/- A multiplicative analogue of the additive translation diffeomorphism already
   exposed by `MumfordLib.TranslationTopology`. -/
noncomputable def mulTranslationDiffeomorph
    {𝕜 H E G : Type*} [NontriviallyNormedField 𝕜]
    [TopologicalSpace H] [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    (I : ModelWithCorners 𝕜 E H) (n : ℕ∞ω)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I n G] (a : G) : Diffeomorph I I G G n := by
  letI : IsTopologicalGroup G := topologicalGroup_of_lieGroup I n
  exact {
    toEquiv := (Homeomorph.mulLeft a).toEquiv
    contMDiff_toFun := contMDiff_mul_left
    contMDiff_invFun := by
      change ContMDiff I I n (fun x : G => a⁻¹ * x)
      exact contMDiff_mul_left }

@[simp]
theorem mulTranslationDiffeomorph_apply
    {𝕜 H E G : Type*} [NontriviallyNormedField 𝕜]
    [TopologicalSpace H] [NormedAddCommGroup E] [NormedSpace 𝕜 E]
    (I : ModelWithCorners 𝕜 E H) (n : ℕ∞ω)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I n G] (a x : G) :
    mulTranslationDiffeomorph I n a x = a * x :=
  rfl

/- The identity local diffeomorphism of the canonical exponential transports to
   every tangent point by additive source translation and multiplicative target
   translation. -/
theorem canonicalComplexExponential_isLocalDiffeomorphAt_of_additive
    {E H G : Type*}
    [NormedAddCommGroup E] [NormedSpace ℂ E]
    [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I ω G]
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] (x : E) :
    IsLocalDiffeomorphAt 𝓘(ℂ, E) I 1
      (canonicalComplexExponential (G := G) I) x := by
  let src : Diffeomorph (𝓘(ℂ, E)) (𝓘(ℂ, E)) E E 1 :=
    Uniformization.addTranslationDiffeomorph (𝓘(ℂ, E)) 1 (-x)
  let tgt : Diffeomorph I I G G 1 :=
    mulTranslationDiffeomorph I 1
      (canonicalComplexExponential (G := G) I x)
  have hsrc : IsLocalDiffeomorphAt (𝓘(ℂ, E)) (𝓘(ℂ, E)) 1
      (src : E → E) x := by
    exact src.isLocalDiffeomorph x
  have hzero : IsLocalDiffeomorphAt 𝓘(ℂ, E) I 1
      (canonicalComplexExponential (G := G) I) 0 :=
    canonicalComplexExponential_isLocalDiffeomorphAt (G := G) I
  have hmid : IsLocalDiffeomorphAt 𝓘(ℂ, E) I 1
      ((canonicalComplexExponential (G := G) I) ∘ (src : E → E)) x := by
    have hzero' : (src : E → E) x = (0 : E) := by
      change -x + x = 0
      abel
    have hzero_at : IsLocalDiffeomorphAt 𝓘(ℂ, E) I 1
        (canonicalComplexExponential (G := G) I) (src x) := by
      simpa [hzero'] using hzero
    exact hsrc.comp I G hzero_at
  have htgt : IsLocalDiffeomorphAt I I 1
      (tgt : G → G)
      ((canonicalComplexExponential (G := G) I) (src x)) := by
    apply tgt.isLocalDiffeomorph
  have hcomp := hmid.comp I G htgt
  have hsrc_apply (y : E) : src y = -x + y := by
    rfl
  have heq : (tgt : G → G) ∘
      ((canonicalComplexExponential (G := G) I) ∘ (src : E → E)) =
      (canonicalComplexExponential (G := G) I) := by
    funext y
    change canonicalComplexExponential (G := G) I x *
      canonicalComplexExponential (G := G) I (src y) =
      canonicalComplexExponential (G := G) I y
    rw [hsrc_apply, ← canonicalComplexExponential_add (G := G) I x (-x + y)]
    congr 1
    abel
  rw [heq] at hcomp
  exact hcomp

/- The translated pointwise certificates assemble into the global local
   diffeomorphism predicate used by range and quotient consumers. -/
theorem canonicalComplexExponential_isLocalDiffeomorph
    {E H G : Type*}
    [NormedAddCommGroup E] [NormedSpace ℂ E]
    [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
    [TopologicalSpace G] [ChartedSpace H G] [Group G]
    [LieGroup I ω G]
    [CompleteSpace E] [T2Space G] [I.Boundaryless]
    [CompactSpace G] [PreconnectedSpace G] :
    IsLocalDiffeomorph 𝓘(ℂ, E) I 1
      (canonicalComplexExponential (G := G) I) := by
  intro x
  exact canonicalComplexExponential_isLocalDiffeomorphAt_of_additive I x

section Quotient

open Uniformization ComplexVectorLatticeExponentialData

variable {E H G : Type*}
  [NormedAddCommGroup E] [NormedSpace ℂ E]
  [TopologicalSpace H] (I : ModelWithCorners ℂ E H)
  [TopologicalSpace G] [ChartedSpace H G] [CommGroup G]
  [LieGroup I ω G]
  [CompleteSpace E] [T2Space G] [I.Boundaryless]
  [CompactSpace G] [PreconnectedSpace G]

/-- The canonical exponential identifies its period quotient, equipped with
the lattice branch atlas, with the original complex Lie group by a complex
`C¹` diffeomorphism. The supplied coordinate only selects the lattice atlas. -/
noncomputable def canonicalComplexExponentialQuotientDiffeomorph
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) :
    let d := canonicalComplexVectorLatticeExponentialData (G := G) I coordinate
    letI : ChartedSpace E (E ⧸ d.ambientPeriodLattice) :=
      analyticQuotientChartedSpace d
    Diffeomorph (𝓘(ℂ, E)) I (E ⧸ d.ambientPeriodLattice) G 1 := by
  let d := canonicalComplexVectorLatticeExponentialData (G := G) I coordinate
  letI : ChartedSpace E (E ⧸ d.ambientPeriodLattice) :=
    analyticQuotientChartedSpace d
  exact d.quotientDiffeomorph I
    (canonicalComplexExponential_isLocalDiffeomorph (G := G) I)

/-- The quotient diffeomorphism is the first-isomorphism equivalence on points. -/
@[simp]
theorem canonicalComplexExponentialQuotientDiffeomorph_apply
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g)
    (q : E ⧸ (canonicalComplexVectorLatticeExponentialData
      (G := G) I coordinate).ambientPeriodLattice) :
    canonicalComplexExponentialQuotientDiffeomorph (G := G) I coordinate q =
      Additive.toMul ((canonicalComplexVectorLatticeExponentialData
        (G := G) I coordinate).quotientAddEquiv q) := rfl

/-- The quotient diffeomorphism sends a tangent representative to its exponential. -/
@[simp]
theorem canonicalComplexExponentialQuotientDiffeomorph_mk
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) (v : E) :
    canonicalComplexExponentialQuotientDiffeomorph (G := G) I coordinate
        (QuotientAddGroup.mk' (canonicalComplexVectorLatticeExponentialData
          (G := G) I coordinate).ambientPeriodLattice v) =
      canonicalComplexExponential (G := G) I v := by
  rw [canonicalComplexExponentialQuotientDiffeomorph_apply,
    quotientAddEquiv_mk]
  rfl

/-- The inverse recovers the period class of any exponential preimage. -/
@[simp]
theorem canonicalComplexExponentialQuotientDiffeomorph_symm_exp
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g) (v : E) :
    letI : ChartedSpace E (E ⧸ (canonicalComplexVectorLatticeExponentialData
        (G := G) I coordinate).ambientPeriodLattice) :=
      analyticQuotientChartedSpace
        (canonicalComplexVectorLatticeExponentialData (G := G) I coordinate)
    (canonicalComplexExponentialQuotientDiffeomorph (G := G) I coordinate).symm
        (canonicalComplexExponential (G := G) I v) =
      QuotientAddGroup.mk' (canonicalComplexVectorLatticeExponentialData
        (G := G) I coordinate).ambientPeriodLattice v := by
  letI : ChartedSpace E (E ⧸ (canonicalComplexVectorLatticeExponentialData
      (G := G) I coordinate).ambientPeriodLattice) :=
    analyticQuotientChartedSpace
      (canonicalComplexVectorLatticeExponentialData (G := G) I coordinate)
  rw [← canonicalComplexExponentialQuotientDiffeomorph_mk I coordinate v]
  exact (canonicalComplexExponentialQuotientDiffeomorph
    (G := G) I coordinate).symm_apply_apply _

/-- The complex diffeomorphism carries quotient addition to the original group law. -/
theorem canonicalComplexExponentialQuotientDiffeomorph_add
    {g : ℕ} (coordinate : E ≃L[ℂ] GenusComplexVector g)
    (q r : E ⧸ (canonicalComplexVectorLatticeExponentialData
      (G := G) I coordinate).ambientPeriodLattice) :
    canonicalComplexExponentialQuotientDiffeomorph (G := G) I coordinate (q + r) =
      canonicalComplexExponentialQuotientDiffeomorph (G := G) I coordinate q *
        canonicalComplexExponentialQuotientDiffeomorph (G := G) I coordinate r := by
  simp only [canonicalComplexExponentialQuotientDiffeomorph_apply, map_add]
  rfl

end Quotient

end
end Analytic
end Mumford
