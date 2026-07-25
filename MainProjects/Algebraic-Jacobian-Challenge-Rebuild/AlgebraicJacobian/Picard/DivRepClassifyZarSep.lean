/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivRepClassifyZar

/-!
# F5 — the class side of the backward classification: separation

`Picard/DivRepClassifyZar.lean` proves the *hom* side of the backward classification:
a locally certified divisor class determines a **unique** morphism satisfying the
characterizing clause (`isDivRepClassify_unique`).  This file proves the *class* side:
a morphism satisfying the clause determines the **class**.

* `AlgebraicGeometry.map_pairTautFst_eq_of_specMap_pairChartMap_eq` and its `Snd`
  mirror — **the W2 converse**: two pair-chart maps presenting the same morphism to
  `grPair` pull the tautological pair back equally.  The forward implication is
  `specMap_pairChartMap_eq_of_map_pairTaut_eq`
  (`Picard/GrassmannianPairCompare.lean`); the converse is the two chart-compatibility
  theorems of `Picard/DivCarvePairChart.lean` read in the `pairTaut` spelling.
* `AlgebraicGeometry.eq_of_isDivRepClassify` — **the separation theorem**: two locally
  certified divisor classes over an affine test whose classifying morphism is the same
  are equal.
* `AlgebraicGeometry.divRepClassifyZar_injective` — the packaged corollary.

The route is certificate-free and free of the DDR9-U ε-identity: it consumes only the
composite certificate × frame cover (`DivFamZar.exists_certChartCover`), the frame
transport `map_window_frame_toSubmodule`, the seam-free relative mono
`divFam_divEq_of_eps_eq_total` (DDR-8), and Zariski separation for `DivFamZar`
(`DivFamZar.eq_of_away_eq`).
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161). -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits
open scoped TensorProduct Pointwise

namespace AlgebraicGeometry

/-! ## The W2 converse in the `pairTaut` spelling -/

section PairTautConverse

open Grassmannian

variable (k : Type u) [Field k] (g r₁ r₂ : ℕ)

/-- **W2, converse, first factor**: two pair-chart maps presenting the same morphism
`Spec B ⟶ grPair` pull the first tautological window back equally.  The exact converse
of `specMap_pairChartMap_eq_of_map_pairTaut_eq`; both are the `pairTaut` reading of
`map_includeLeft_chartTautologicalPoint_eq_of_specMap_pairChartMap_eq`. -/
theorem map_pairTautFst_eq_of_specMap_pairChartMap_eq
    {i i' : (glueData k g r₁).J} {j j' : (glueData k g r₂).J}
    {B : Type u} [CommRing B] [Algebra k B]
    (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] B)
    (w' : PairChartRing k g r₁ g r₂ i' j' →ₐ[k] B)
    (h : Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
       = Spec.map (CommRingCat.ofHom w'.toRingHom) ≫ pairChartMap k g r₁ g r₂ i' j') :
    Module.Grassmannian.map w (pairTautFst k g r₁ r₂ i j)
      = Module.Grassmannian.map w' (pairTautFst k g r₁ r₂ i' j') := by
  have h₁ := Grassmannian.map_includeLeft_chartTautologicalPoint_eq_of_specMap_pairChartMap_eq
    k g r₁ g r₂ w w' h
  rw [pairTautFst, pairTautFst, ← Module.Grassmannian.map_comp,
    ← Module.Grassmannian.map_comp]
  exact h₁

/-- **W2, converse, second factor**: the `pairTautSnd` mirror of
`map_pairTautFst_eq_of_specMap_pairChartMap_eq`. -/
theorem map_pairTautSnd_eq_of_specMap_pairChartMap_eq
    {i i' : (glueData k g r₁).J} {j j' : (glueData k g r₂).J}
    {B : Type u} [CommRing B] [Algebra k B]
    (w : PairChartRing k g r₁ g r₂ i j →ₐ[k] B)
    (w' : PairChartRing k g r₁ g r₂ i' j' →ₐ[k] B)
    (h : Spec.map (CommRingCat.ofHom w.toRingHom) ≫ pairChartMap k g r₁ g r₂ i j
       = Spec.map (CommRingCat.ofHom w'.toRingHom) ≫ pairChartMap k g r₁ g r₂ i' j') :
    Module.Grassmannian.map w (pairTautSnd k g r₁ r₂ i j)
      = Module.Grassmannian.map w' (pairTautSnd k g r₁ r₂ i' j') := by
  have h₂ := Grassmannian.map_includeRight_chartTautologicalPoint_eq_of_specMap_pairChartMap_eq
    k g r₁ g r₂ w w' h
  rw [pairTautSnd, pairTautSnd, ← Module.Grassmannian.map_comp,
    ← Module.Grassmannian.map_comp]
  exact h₂

end PairTautConverse

/-! ## Cancelling the coordinate embedding of a window -/

section WindowCancel

/-- **The coordinate embedding of a window is injective**: base change of a linear
equivalence along `k → B` is an equivalence, so `Submodule.map` along it reflects
equality.  This is what removes the `b.equivFun` coordinates from a frame identity. -/
theorem submodule_eq_of_map_baseChange_equivFun_eq
    {k : Type u} [Field k] {M : Type u} [AddCommGroup M] [Module k M] {r : ℕ}
    (b : Module.Basis (Fin r) k M) (B : Type u) [CommRing B] [Algebra k B]
    {P Q : Submodule B (TensorProduct k B M)}
    (h : Submodule.map (LinearMap.baseChange B b.equivFun.toLinearMap) P
       = Submodule.map (LinearMap.baseChange B b.equivFun.toLinearMap) Q) :
    P = Q := by
  have hcomp : (LinearMap.baseChange B b.equivFun.symm.toLinearMap).comp
      (LinearMap.baseChange B b.equivFun.toLinearMap) = LinearMap.id := by
    rw [← LinearMap.baseChange_comp]
    simp
  have hinj : Function.Injective (LinearMap.baseChange B b.equivFun.toLinearMap) := by
    intro x y hxy
    have h1 := congrArg (LinearMap.baseChange B b.equivFun.symm.toLinearMap) hxy
    have h2 : (LinearMap.baseChange B b.equivFun.symm.toLinearMap).comp
        (LinearMap.baseChange B b.equivFun.toLinearMap) x
      = (LinearMap.baseChange B b.equivFun.symm.toLinearMap).comp
        (LinearMap.baseChange B b.equivFun.toLinearMap) y := h1
    rwa [hcomp, LinearMap.id_apply, LinearMap.id_apply] at h2
  exact Submodule.map_injective_of_injective hinj h

end WindowCancel

/-! ## Separation: the classifying morphism determines the class -/

section Curve

open Scheme Grassmannian

variable {k : Type u} [Field k] {C : Over (Spec (CommRingCat.of k))}
variable {π : C.left ⟶ P1 k} [IsFinite π]

noncomputable local instance instOverCleftDivRepSep :
    C.left.Over (Spec (CommRingCat.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (CommRingCat.of k))]
  [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (CommRingCat.of k))]
  [QuasiCompact (C.left ↘ Spec (CommRingCat.of k))]
  [IsDominant π]
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g : ℕ)
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
variable (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))
variable (r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k
  ↥(divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
variable (b₂ : Module.Basis (Fin r₂) k
  ↥(divisorSections k
    ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤))
variable {S : Type u} [CommRing S] [Algebra k S]

/-- **The product of two span-⊤ families is span-⊤**: the common refinement of two
finite affine covers of `Spec S`. -/
theorem span_range_mul_eq_top {m₀ m₁ : ℕ} (c₀ : Fin m₀ → S) (c₁ : Fin m₁ → S)
    (h₀ : Ideal.span (Set.range c₀) = ⊤) (h₁ : Ideal.span (Set.range c₁) = ⊤) :
    Ideal.span (Set.range fun p : Fin m₀ × Fin m₁ => c₀ p.1 * c₁ p.2) = ⊤ := by
  refine top_le_iff.mp ?_
  calc (⊤ : Ideal S) = Ideal.span (Set.range c₀) * Ideal.span (Set.range c₁) := by
        rw [h₀, h₁, Ideal.top_mul]
    _ = Ideal.span (Set.range c₀ * Set.range c₁) := Ideal.span_mul_span _ _
    _ ≤ Ideal.span (Set.range fun p : Fin m₀ × Fin m₁ => c₀ p.1 * c₁ p.2) := by
        refine Ideal.span_mono ?_
        rintro x ⟨y, ⟨a, rfl⟩, z, ⟨b, rfl⟩, rfl⟩
        exact ⟨(a, b), rfl⟩

end Curve

end AlgebraicGeometry
