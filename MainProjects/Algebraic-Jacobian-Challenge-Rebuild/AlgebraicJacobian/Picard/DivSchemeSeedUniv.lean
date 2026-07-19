/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeFamilyUniv
import AlgebraicJacobian.Picard.DivSchemeFrameKit
import AlgebraicJacobian.Picard.DivisorFamilyWindow

/-!
# G-4 — the universal seed windows `K_univ`/`K'_univ` (`informal/w4-g4-worksheet.md` §1.2)

The submodule layer of the universal theta generator seed: over each `Z(♦)`-chart ring
`R_Z = DivCarveChartRing k A B g r₁ r₂ b₁ b₂ i j` at the campaign windows
`A = s·F`, `B = M·F` (`s = windowS_choice`, `M = windowM_choice`), the tautological
carve pair of `Picard/DivSchemeFamilyUniv` is transported into the pinned window
ambients `H_M`, `H_{M+s}` and pushed through the window identification
`relThetaWindowEquiv` — producing exactly the submodule parameter `K` that the DDR-5
ε-projection identity (`ThetaGeneratorSeed.divFamEps_certifiedFamily`,
`Picard/DivSchemeEps.lean`) consumes for a seed at the universal point.

The worksheet's `grPointCongr` helper is the LANDED `Grassmannian.congrAmbient`
(`Picard/DivSchemeFrameKit.lean`, K1), with naturality `map_congrAmbient` (K4); this
file only instantiates it.

* `AlgebraicGeometry.Grassmannian.projective_submodule_of_projective_quotient` — a
  submodule with projective quotient of a projective module is projective (the
  `quotRetract` splitting; the projectivity companion of the landed
  `finite_submodule_of_projective_quotient`).
* `AlgebraicGeometry.Grassmannian.finrank_ker_baseChangeMkQ_add_of_field` — **the fibre
  corank law**: at any field point `L` of the base ring, the fibre of a Grassmannian
  point (the kernel of `baseChangeMkQ L`) has `finrank + g = dim_k H` — the `hKMrank`
  shape of the P-fib-N pack at every residue field.
* `AlgebraicGeometry.divUniversalFstWindow` / `divUniversalSndWindow` — the universal
  pair transported to the window ambients through the DD-4 boundary bases
  (`congrAmbient` along `b₁.equivFun.symm`, resp. `b₂.equivFun.symm` composed with the
  `add_nsmul` window regluing `seedWindowShiftEquiv` — the same spelling as
  `windowShiftMul`, `RiemannRoch/CarveDegree.lean`).
* `AlgebraicGeometry.divUniversalSeedK` / `divUniversalSeedK'` — **`K_univ`/`K'_univ`**:
  the images of the transported points under the window identification — the seed
  submodule parameters at the universal point, in the exact spelling of
  `ThetaGeneratorSeed.divFamEps_certifiedFamily` (`K = map relThetaWindowEquiv
  x₁.toSubmodule`); `divUniversalSeedK_eq_map`/`divUniversalSeedK'_eq_map` unfold them
  to the worksheet §1.2 composites.
* `AlgebraicGeometry.finite_divUniversalSeedK`(`'`) /
  `projective_divUniversalSeedK`(`'`) — **`K_univ` is finite projective over `R_Z`,
  certificate-free**: the ambient quotient of the Grassmannian point is projective, so
  the point's submodule is a retract of the free ambient, and `K_univ` is its image
  under a linear equivalence.  This is what makes the achiever lift of the seed
  construction (worksheet §1.5) anti-circular.

The fibre instantiation (the P-fib-N firing at every prime of the chart ring) is
`AlgebraicJacobian.Picard.DivSchemeSeedUnivFibre`.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme

namespace Grassmannian

/-! ## Generic module algebra: projectivity of the point submodule, fibre corank -/

section Generic

variable {R : Type u} [CommRing R] {M : Type u} [AddCommGroup M] [Module R M]

/-- **A submodule with projective quotient of a projective module is projective**: the
`quotRetract` splitting exhibits it as a retract of the ambient module — the
projectivity companion of `finite_submodule_of_projective_quotient`. -/
theorem projective_submodule_of_projective_quotient (N : Submodule R M)
    [Module.Projective R M] [Module.Projective R (M ⧸ N)] :
    Module.Projective R ↥N :=
  Module.Projective.of_split N.subtype (quotRetract N)
    (LinearMap.ext fun x =>
      (quotRetract_apply_of_mem N x.2).trans (Subtype.ext rfl))

variable {k : Type u} [Field k]

/-- **The fibre corank law of a Grassmannian point** (the `hKMrank` shape of the
P-fib-N pack): at a field `L` over the base ring `T`, the fibre of a point of
`grFunctorAff k H g T` — the kernel of `baseChangeMkQ L` — satisfies
`finrank + g = dim_k H`.  The quotient of the fibre ambient is the base change of the
point's rank-`g` projective quotient, so its `L`-dimension is `g`
(`rankAtStalk_baseChange`), and rank–nullity closes. -/
theorem finrank_ker_baseChangeMkQ_add_of_field {T : Type u} [CommRing T] [Algebra k T]
    {H : Type u} [AddCommGroup H] [Module k H] [Module.Finite k H] {g : ℕ}
    (x : grFunctorAff k H g T) (L : Type u) [Field L] [Algebra k L] [Algebra T L]
    [IsScalarTower k T L] :
    Module.finrank L
        ↥(LinearMap.ker (Module.Grassmannian.baseChangeMkQ L x.toSubmodule)) + g
      = Module.finrank k H := by
  haveI := x.finite_quotient
  haveI := x.projective_quotient
  -- the quotient of the fibre ambient is the base-changed quotient
  have e := Module.Grassmannian.baseChangeMkQEquiv (B := L) x.toSubmodule
  -- its dimension is the rank of the point's quotient, i.e. `g`
  have hgQ : Module.finrank L
      (L ⊗[T] (TensorProduct k T H ⧸ x.toSubmodule)) = g := by
    have hfree : Module.rankAtStalk (R := L)
        (L ⊗[T] (TensorProduct k T H ⧸ x.toSubmodule))
        = Module.finrank L (L ⊗[T] (TensorProduct k T H ⧸ x.toSubmodule)) :=
      Module.rankAtStalk_eq_finrank_of_free
    have hp : Module.rankAtStalk (R := L)
        (L ⊗[T] (TensorProduct k T H ⧸ x.toSubmodule)) ⟨⊥, Ideal.isPrime_bot⟩ = g := by
      rw [Module.rankAtStalk_baseChange]
      exact x.rankAtStalk_eq _
    exact (congrFun hfree ⟨⊥, Ideal.isPrime_bot⟩).symm.trans hp
  have hq : Module.finrank L
      (TensorProduct k L H ⧸
        LinearMap.ker (Module.Grassmannian.baseChangeMkQ L x.toSubmodule)) = g := by
    rw [LinearEquiv.finrank_eq e]
    exact hgQ
  -- rank–nullity in the fibre ambient
  have hrn := Submodule.finrank_quotient_add_finrank
    (LinearMap.ker (Module.Grassmannian.baseChangeMkQ L x.toSubmodule))
  rw [hq] at hrn
  -- the fibre ambient has the `k`-dimension of `H`
  have hamb : Module.finrank L (TensorProduct k L H) = Module.finrank k H :=
    Module.finrank_baseChange
  omega

end Generic

end Grassmannian

/-! ## The campaign section: the universal pair in the window ambients -/

section SeedUniv

open Grassmannian

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (π : C.left ⟶ P1 k) [IsFinite π]

noncomputable local instance instOverCleftSeedUniv : C.left.Over (Spec (.of k)) := ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
  [IsDominant π]
variable [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 0)]
  [Module.Finite k (Sheaf.HModule (C.left.moduleKSheaf k) 1)]
variable (hπ : π ≫ P1.structureMap k = C.left ↘ Spec (CommRingCat.of k))
variable (g r₁ r₂ : ℕ)
variable (b₁ : Module.Basis (Fin r₁) k
  ↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤))
variable (b₂ : Module.Basis (Fin r₂) k
  ↥(Scheme.divisorSections k ((windowS_choice π hπ g • fiberWeilDivisor π)
    + (windowM_choice π hπ g • fiberWeilDivisor π)) ⊤))
variable (i : (glueData k g r₁).J) (j : (glueData k g r₂).J)

/-- **The window regluing** `H⁰(𝒪(s·F + M·F)) = H⁰(𝒪((M+s)·F))` — the `add_nsmul`
ambient identification, in the same spelling as `windowShiftMul`
(`RiemannRoch/CarveDegree.lean`). -/
noncomputable def seedWindowShiftEquiv :
    ↥(Scheme.divisorSections k ((windowS_choice π hπ g • fiberWeilDivisor π)
        + (windowM_choice π hπ g • fiberWeilDivisor π)) ⊤) ≃ₗ[k]
      ↥(Scheme.divisorSections k
        ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤) :=
  LinearEquiv.ofEq _ _ (congrArg (fun D => Scheme.divisorSections k D ⊤)
    (by rw [add_nsmul]; exact add_comm _ _))

/-- **The universal first window point** `x₁` over a `Z(♦)`-chart ring: the universal
tautological point `divUniversalFst`, transported into the embedding window ambient
`H_M` through the DD-4 boundary basis (`congrAmbient` along `b₁.equivFun.symm` — the
worksheet's `grPointCongr`). -/
noncomputable def divUniversalFstWindow :
    grFunctorAff k
      (↥(Scheme.divisorSections k (windowM_choice π hπ g • fiberWeilDivisor π) ⊤)) g
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) :=
  congrAmbient b₁.equivFun.symm
    (divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)

/-- **The universal second window point** `x₂`: `divUniversalSnd` transported into the
shifted window ambient `H_{M+s}` through `b₂.equivFun.symm` and the window regluing. -/
noncomputable def divUniversalSndWindow :
    grFunctorAff k
      (↥(Scheme.divisorSections k
        ((windowM_choice π hπ g + windowS_choice π hπ g) • fiberWeilDivisor π) ⊤)) g
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j) :=
  congrAmbient (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g))
    (divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)

/-- **`K_univ`** (worksheet §1.2): the universal seed submodule at the embedding window
`M` — the image of the universal first window point under the window identification.
This is verbatim the submodule parameter of
`ThetaGeneratorSeed.divFamEps_certifiedFamily` at `x₁ = divUniversalFstWindow`. -/
noncomputable def divUniversalSeedK :
    Submodule
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      (relThetaSections C
        (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
          (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
        π (windowM_choice π hπ g)) :=
  Submodule.map
    (relThetaWindowEquiv C
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      π (windowM_choice π hπ g) (relThetaPairH1_windowM C π hπ g)).toLinearMap
    (divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule

/-- **`K'_univ`** (worksheet §1.2): the universal seed submodule at the shifted window
`M + s` — the image of the universal second window point under the window
identification. -/
noncomputable def divUniversalSeedK' :
    Submodule
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      (relThetaSections C
        (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
          (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
        π (windowM_choice π hπ g + windowS_choice π hπ g)) :=
  Submodule.map
    (relThetaWindowEquiv C
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      π (windowM_choice π hπ g + windowS_choice π hπ g)
      (relThetaPairH1_windowMS C π hπ g)).toLinearMap
    (divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule

/-- The worksheet §1.2 composite spelling of `K_univ`: the image of the universal
tautological submodule under the window identification composed with the base-changed
boundary basis. -/
theorem divUniversalSeedK_eq_map :
    divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j
      = Submodule.map
          ((relThetaWindowEquiv C
              (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
                (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
              π (windowM_choice π hπ g)
              (relThetaPairH1_windowM C π hπ g)).toLinearMap
            ∘ₗ LinearMap.baseChange
              (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
                (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
              b₁.equivFun.symm.toLinearMap)
          (divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule := by
  rw [Submodule.map_comp]
  rfl

/-- The worksheet §1.2 composite spelling of `K'_univ`. -/
theorem divUniversalSeedK'_eq_map :
    divUniversalSeedK' C π hπ g r₁ r₂ b₁ b₂ i j
      = Submodule.map
          ((relThetaWindowEquiv C
              (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
                (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
              π (windowM_choice π hπ g + windowS_choice π hπ g)
              (relThetaPairH1_windowMS C π hπ g)).toLinearMap
            ∘ₗ LinearMap.baseChange
              (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
                (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
              (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g)).toLinearMap)
          (divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
            (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule := by
  rw [Submodule.map_comp]
  rfl

/-! ## `K_univ` is finite projective over `R_Z`, certificate-free -/

/-- `K_univ` is `R_Z`-linearly the universal first window point's submodule. -/
noncomputable def divUniversalSeedKEquiv :
    ↥(divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule ≃ₗ[
      DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j]
      ↥(divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j) :=
  LinearEquiv.ofSubmodules
    (relThetaWindowEquiv C
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      π (windowM_choice π hπ g) (relThetaPairH1_windowM C π hπ g)) _ _ rfl

/-- `K'_univ` is `R_Z`-linearly the universal second window point's submodule. -/
noncomputable def divUniversalSeedK'Equiv :
    ↥(divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule ≃ₗ[
      DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j]
      ↥(divUniversalSeedK' C π hπ g r₁ r₂ b₁ b₂ i j) :=
  LinearEquiv.ofSubmodules
    (relThetaWindowEquiv C
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      π (windowM_choice π hπ g + windowS_choice π hπ g)
      (relThetaPairH1_windowMS C π hπ g)) _ _ rfl

/-- The window point's submodule is `R_Z`-linearly the universal tautological
submodule (the base-changed boundary basis is an ambient equivalence). -/
noncomputable def divUniversalFstWindowEquiv :
    ↥(divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule ≃ₗ[
      DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j]
      ↥(divUniversalFstWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule :=
  LinearEquiv.ofSubmodules
    (LinearEquiv.baseChange k
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      _ _ b₁.equivFun.symm) _ _ rfl

/-- Mirror of `divUniversalFstWindowEquiv` for the second window point. -/
noncomputable def divUniversalSndWindowEquiv :
    ↥(divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule ≃ₗ[
      DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j]
      ↥(divUniversalSndWindow C π hπ g r₁ r₂ b₁ b₂ i j).toSubmodule :=
  LinearEquiv.ofSubmodules
    (LinearEquiv.baseChange k
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      _ _ (b₂.equivFun.symm.trans (seedWindowShiftEquiv C π hπ g))) _ _ rfl

/-- **`K_univ` is a finite `R_Z`-module, certificate-free**: it is linearly the
universal tautological submodule, a projective-quotient submodule of the finite free
ambient (`finite_submodule_of_projective_quotient`). -/
theorem finite_divUniversalSeedK :
    Module.Finite
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      ↥(divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j) := by
  haveI := finite_submodule_of_projective_quotient
    (divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule
  exact Module.Finite.equiv
    ((divUniversalFstWindowEquiv C π hπ g r₁ r₂ b₁ b₂ i j).trans
      (divUniversalSeedKEquiv C π hπ g r₁ r₂ b₁ b₂ i j))

/-- **`K'_univ` is a finite `R_Z`-module, certificate-free.** -/
theorem finite_divUniversalSeedK' :
    Module.Finite
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      ↥(divUniversalSeedK' C π hπ g r₁ r₂ b₁ b₂ i j) := by
  haveI := finite_submodule_of_projective_quotient
    (divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule
  exact Module.Finite.equiv
    ((divUniversalSndWindowEquiv C π hπ g r₁ r₂ b₁ b₂ i j).trans
      (divUniversalSeedK'Equiv C π hπ g r₁ r₂ b₁ b₂ i j))

/-- **`K_univ` is a projective `R_Z`-module, certificate-free**: the universal
tautological submodule is a retract of the free ambient
(`projective_submodule_of_projective_quotient`), and `K_univ` is its image under a
linear equivalence.  This is the anti-circularity licence of the seed's achiever lift
(worksheet §1.5). -/
theorem projective_divUniversalSeedK :
    Module.Projective
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      ↥(divUniversalSeedK C π hπ g r₁ r₂ b₁ b₂ i j) := by
  haveI := projective_submodule_of_projective_quotient
    (divUniversalFst k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule
  exact Module.Projective.of_equiv
    ((divUniversalFstWindowEquiv C π hπ g r₁ r₂ b₁ b₂ i j).trans
      (divUniversalSeedKEquiv C π hπ g r₁ r₂ b₁ b₂ i j))

/-- **`K'_univ` is a projective `R_Z`-module, certificate-free.** -/
theorem projective_divUniversalSeedK' :
    Module.Projective
      (DivCarveChartRing k (windowS_choice π hπ g • fiberWeilDivisor π)
        (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j)
      ↥(divUniversalSeedK' C π hπ g r₁ r₂ b₁ b₂ i j) := by
  haveI := projective_submodule_of_projective_quotient
    (divUniversalSnd k (windowS_choice π hπ g • fiberWeilDivisor π)
      (windowM_choice π hπ g • fiberWeilDivisor π) g r₁ r₂ b₁ b₂ i j).toSubmodule
  exact Module.Projective.of_equiv
    ((divUniversalSndWindowEquiv C π hπ g r₁ r₂ b₁ b₂ i j).trans
      (divUniversalSeedK'Equiv C π hπ g r₁ r₂ b₁ b₂ i j))

end SeedUniv

end AlgebraicGeometry
