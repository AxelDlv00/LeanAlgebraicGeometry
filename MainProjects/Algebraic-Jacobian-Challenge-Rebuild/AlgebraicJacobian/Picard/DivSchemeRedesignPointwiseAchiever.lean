/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivSchemeRedesignAchiever
import AlgebraicJacobian.Picard.DivSchemeFibrePoint
import AlgebraicJacobian.Picard.DivSchemeSeedUnivGen
import AlgebraicJacobian.Picard.DivSchemeRedesignCarvePin

/-!
# The pointwise universal achiever over the total seed curve

The seed-prime achiever is stated on a fibre curve over `κ(p)`.  The seed, however, is
chosen pointwise on the total curve over the carve ring.  This file supplies the small
reindexing bridge between the two statements: for a total point `z`, set
`p := relCurveBasePoint C RZ z` and `z_fib := relCurveResiduePoint C RZ z`, then apply the
seed-prime theorem at `(p, z_fib)`.

There is one important topological qualification.  A total point can be the generic point
of a vertical fibre, so `z_fib ≠ genericPoint (relCurve C κ(p))` is not true for every total
point.  Accordingly the main theorem takes that hypothesis explicitly, while the companion
dichotomy is unconditional and exposes the generic-fibre branch to downstream code.
The old seed is left untouched.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

open Scheme Grassmannian

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
  Scheme.functionFieldOverModule
attribute [local instance 10000] relCurve.instOver

namespace PointwiseAchiever

section SeedContext

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
  [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom] [GeometricallyIrreducible C.hom]
variable {π : C.left ⟶ P1 k} [IsFinite π] [IsDominant π]

noncomputable local instance instOverCleftPointwise : C.left.Over (Spec (.of k)) :=
  ⟨C.hom⟩

variable [SmoothOfRelativeDimension 1 (C.left ↘ Spec (.of k))] [IsIntegral C.left]
  [LocallyOfFiniteType (C.left ↘ Spec (.of k))] [QuasiCompact (C.left ↘ Spec (.of k))]
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
variable (hO : Sheaf.h0 (C.left.moduleKSheaf k) = 1)
  (hχ : Sheaf.chi (C.left.moduleKSheaf k) = 1 - (g : ℤ))

-- The fibre-curve instances used by the seed-prime theorem are reconstructed locally here
-- because its original declarations are section-local.
noncomputable local instance instIsIntegralRelCurvePointwise (L : Type u) [Field L]
    [Algebra k L] : IsIntegral (relCurve C L) := instIsIntegralBaseChange C L

noncomputable local instance instSmoothRelCurvePointwise (L : Type u) [Field L]
    [Algebra k L] :
    SmoothOfRelativeDimension 1 (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  instSmoothOfRelativeDimensionBaseChange C L

noncomputable local instance instQCRelCurvePointwise (L : Type u) [Field L]
    [Algebra k L] : QuasiCompact (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  instQuasiCompactBaseChange C L

noncomputable local instance instLFTRelCurvePointwise (L : Type u) [Field L]
    [Algebra k L] : LocallyOfFiniteType (relCurve C L ↘ Spec (CommRingCat.of L)) :=
  haveI : Smooth (relCurve C L ↘ Spec (CommRingCat.of L)) :=
    SmoothOfRelativeDimension.smooth 1 _
  inferInstance

noncomputable local instance instFinH0RelCurvePointwise (L : Type u) [Field L]
    [Algebra k L] : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 0) :=
  instModuleFiniteHModuleZeroBaseChange C L

noncomputable local instance instFinH1RelCurvePointwise (L : Type u) [Field L]
    [Algebra k L] : Module.Finite L (Sheaf.HModule ((relCurve C L).moduleKSheaf L) 1) :=
  instModuleFiniteHModuleOneBaseChange C L

local notation "RZ" => seedChartRing C hπ g r₁ r₂ b₁ b₂ i j

/-! ## Payload and the total-point bridge -/

/-- The full fibre-achiever payload at a seed-base prime.

This is an abbreviation (rather than a second copy of the long existential) so downstream
proofs can `obtain ⟨x, hx, hmem, hcmp, hr, hach⟩` directly while the exact payload remains
definitionally identical to `exists_relThetaWindowEquiv_mem_divUniversalSeedK_achieves_seedPrime`.
-/
abbrev pointwiseAchieverPayload
    (p : PrimeSpectrum RZ)
    (hne : divUniversalFibreKM C hπ g r₁ r₂ b₁ i j p.asIdeal.ResidueField ≠ ⊥)
    {w : relCurve C p.asIdeal.ResidueField}
    (hw : w ≠ genericPoint (relCurve C p.asIdeal.ResidueField)) : Prop :=
  exists_relThetaWindowEquiv_mem_divUniversalSeedK_achieves_seedPrime
    C hπ g r₁ r₂ b₁ b₂ i j hO hχ p hne hw

-- Reconstructing the native tower `k → RZ → κ(p)` while elaborating the achiever payload
-- exceeds the default instance and recursion budgets.
set_option maxHeartbeats 2400000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in
/-- At a total point whose canonical residue-field lift is non-generic in its fibre, the
universal vector and all relative-achiever data are obtained by applying the landed
seed-prime achiever at `p := relCurveBasePoint C RZ z` and
`z_fib := relCurveResiduePoint C RZ z`.

The nonzero-fibre-window hypothesis is discharged from the existing Riemann--Roch
nonvanishing theorem `exists_mem_ne_zero_divUniversalFibreKM_seedPrime`.
-/
theorem exists_pointwise_achiever_at_totalPoint
    (z : relCurve C RZ)
    (hzfib : relCurveResiduePoint C RZ z ≠
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField)) :
    ∃ hne : divUniversalFibreKM C hπ g r₁ r₂ b₁ i j
        (relCurveBasePoint C RZ z).asIdeal.ResidueField ≠ ⊥,
      pointwiseAchieverPayload C hπ g r₁ r₂ b₁ b₂ i j hO hχ
        (relCurveBasePoint C RZ z) hne hzfib := by
  obtain ⟨f, hf, hf0⟩ :=
    exists_mem_ne_zero_divUniversalFibreKM_seedPrime C hπ g r₁ r₂ b₁ b₂ i j hO hχ
      (relCurveBasePoint C RZ z)
  let hne : divUniversalFibreKM C hπ g r₁ r₂ b₁ i j
      (relCurveBasePoint C RZ z).asIdeal.ResidueField ≠ ⊥ := by
    intro hbot
    apply hf0
    rw [hbot, Submodule.mem_bot] at hf
    exact hf
  exact ⟨hne, exists_relThetaWindowEquiv_mem_divUniversalSeedK_achieves_seedPrime
    C hπ g r₁ r₂ b₁ b₂ i j hO hχ (relCurveBasePoint C RZ z) hne hzfib⟩

-- The dichotomy retains the full dependent achiever payload in its non-generic branch, so
-- elaboration rebuilds the same residue-field tower as the main theorem.
set_option maxHeartbeats 2400000 in
set_option synthInstance.maxHeartbeats 800000 in
set_option maxRecDepth 8000 in
/-- Every total point admits the sound two-way case split needed by a pointwise seed
construction: either its canonical fibre point is non-generic and carries the full achiever
payload, or it is the generic point of that fibre.  The second branch is genuine (vertical
fibre generic points occur), so it is exposed rather than hidden behind an unprovable
closedness claim.
-/
theorem exists_pointwise_achiever_or_fibre_generic
    (z : relCurve C RZ) :
    (∃ hzfib : relCurveResiduePoint C RZ z ≠
        genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField),
      ∃ hne : divUniversalFibreKM C hπ g r₁ r₂ b₁ i j
          (relCurveBasePoint C RZ z).asIdeal.ResidueField ≠ ⊥,
        pointwiseAchieverPayload C hπ g r₁ r₂ b₁ b₂ i j hO hχ
          (relCurveBasePoint C RZ z) hne hzfib) ∨
      relCurveResiduePoint C RZ z =
        genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField) := by
  by_cases hzf : relCurveResiduePoint C RZ z ≠
      genericPoint (relCurve C (relCurveBasePoint C RZ z).asIdeal.ResidueField)
  · left
    obtain ⟨hne, hdata⟩ :=
      exists_pointwise_achiever_at_totalPoint C hπ g r₁ r₂ b₁ b₂ i j hO hχ z hzf
    exact ⟨hzf, hne, hdata⟩
  · right
    exact Classical.not_not.mp hzf

end SeedContext

end PointwiseAchiever

end AlgebraicGeometry
