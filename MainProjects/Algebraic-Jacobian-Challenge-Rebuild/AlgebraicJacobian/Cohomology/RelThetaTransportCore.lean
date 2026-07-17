/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.RelThetaTransport

/-!
# DD-4 base-field-transport sub-brick — the section collapse at test ring `k`

The linear-algebra core of the M–L seam of I-0175.  At test ring `R = k` the section base
change `relSectionsBaseChange C k` degenerates to a `k`-linear equivalence
`sectionsCollapse : Γ(C.left, V) ≃ₗ[k] Γ(relCurve C k, V_k)`, computed as the section
pullback `relPullbackSection C k` (an isomorphism because the first projection
`relCurve C k ⟶ C.left` is an iso).  It is a ring isomorphism commuting with restriction,
the arrow through which the twisted section modules of `thetaTwistSheaf π n` (on `C.left`)
and `relThetaTwistSheaf C k π n` (on `relCurve C k`) are identified.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false

universe u

open CategoryTheory Limits MonoidalCategory CartesianMonoidalCategory TopologicalSpace
open Opposite
open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Over.sectionsAlgebra

section SectionsCollapse

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))

/-- **The section collapse at test ring `k`**: the `k`-linear equivalence
`Γ(C.left, V) ≃ₗ[k] Γ(relCurve C k, V_k)`, the section base change `relSectionsBaseChange
C k` precomposed with the tensor-unit cancellation `M ≃ k ⊗[k] M`.  Concretely it is the
section pullback `relPullbackSection C k` (`sectionsCollapse_apply`). -/
noncomputable def sectionsCollapse (V : C.left.Opens)
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left)) :
    Γ(C.left, V) ≃ₗ[k] Γ(relCurve C k, (fst C (overSpec k k)).left ⁻¹ᵁ V) :=
  (TensorProduct.lid k Γ(C.left, V)).symm.trans (relSectionsBaseChange C k hV hV')

/-- The section collapse is the section pullback along the first projection. -/
lemma sectionsCollapse_apply (V : C.left.Opens)
    (hV : IsCompact (V : Set C.left)) (hV' : IsQuasiSeparated (V : Set C.left))
    (s : Γ(C.left, V)) :
    sectionsCollapse C V hV hV' s = relPullbackSection C k V s := by
  rw [sectionsCollapse, LinearEquiv.trans_apply, TensorProduct.lid_symm_apply,
    relSectionsBaseChange_tmul]
  rw [map_one, one_mul]

/-- **Pullback of sections to the relative curve commutes with restriction** (the
`RelativeSectionsLinear`-level fact, re-derived here to avoid the `Challenge` import of
`H1BaseFieldInvariance`): restricting on the curve then pulling back agrees with pulling
back then restricting on the relative curve. -/
lemma relPullbackSection_resHom' {W V : C.left.Opens} (hWV : W ≤ V) (s : Γ(C.left, V)) :
    relPullbackSection C k W (C.left.resHom hWV s) =
      (relCurve C k).resHom
        (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)
        (relPullbackSection C k V s) := by
  have h1 : C.left.presheaf.map (homOfLE hWV).op ≫
      (fst C (overSpec k k)).left.appLE W ((fst C (overSpec k k)).left ⁻¹ᵁ W) le_rfl =
      (fst C (overSpec k k)).left.appLE V ((fst C (overSpec k k)).left ⁻¹ᵁ W)
        (le_rfl.trans (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)) :=
    Scheme.Hom.map_appLE _ le_rfl (homOfLE hWV).op
  have h2 : (fst C (overSpec k k)).left.appLE V ((fst C (overSpec k k)).left ⁻¹ᵁ V)
        le_rfl ≫
      (relCurve C k).presheaf.map
        (homOfLE (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)).op =
      (fst C (overSpec k k)).left.appLE V ((fst C (overSpec k k)).left ⁻¹ᵁ W)
        (le_rfl.trans (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)) :=
    Scheme.Hom.appLE_map _ le_rfl
      (homOfLE (Scheme.Hom.preimage_mono (fst C (overSpec k k)).left hWV)).op
  exact (congr($(h1).hom s)).trans (congr($(h2).hom s)).symm

/-- Restriction along an equality of opens, as a `k`-linear equivalence (the two
restrictions along `U ≤ U'` and `U' ≤ U` are mutually inverse). -/
noncomputable def presheafCongr {X : Scheme.{u}} [X.Over (Spec (.of k))]
    {U U' : X.Opens} (h : U = U') :
    Γ(X, U) ≃ₗ[k] Γ(X, U') :=
  LinearEquiv.ofLinear
    (secRes (X.moduleKSheaf k) (le_of_eq h.symm))
    (secRes (X.moduleKSheaf k) (le_of_eq h))
    (LinearMap.ext fun s => by
      change (secRes (X.moduleKSheaf k) (le_of_eq h.symm))
          ((secRes (X.moduleKSheaf k) (le_of_eq h)) s) = s
      rw [secRes_secRes, secRes_self])
    (LinearMap.ext fun s => by
      change (secRes (X.moduleKSheaf k) (le_of_eq h))
          ((secRes (X.moduleKSheaf k) (le_of_eq h.symm)) s) = s
      rw [secRes_secRes, secRes_self])

end SectionsCollapse

/-! ## The twisted section modules collapse across the pinned charts -/

section TwistCollapse

variable {k : Type u} [Field k] (C : Over (Spec (.of k)))
variable (π : C.left ⟶ P1 k) [IsFinite π] (n : ℕ)

noncomputable local instance (priority := 50) instOverCleftCore :
    C.left.Over (Spec (.of k)) := ⟨C.hom⟩

/-- **Chart-0 collapse of twisted sections**: the field twisted sections of `𝒪(Θⁿ)` over
`V₀` are identified with the relative twisted sections over `V₀ᵏ`, through the two chart
trivializations and the section collapse. -/
noncomputable def twistCollapse₀ :
    ↥(twistSubmodule k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n)
        (fiberChart₀ π)) ≃ₗ[k]
      ↥(twistSubmodule k (relCover C k (fiberTwoCover π)).V₀
        (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n)
        (relCover C k (fiberTwoCover π)).V₀) :=
  (twistTriv₀ k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) (le_refl _)).trans
    ((sectionsCollapse C (fiberChart₀ π)
        (isAffineOpen_preimage_chartOpen π 0).isCompact
        (isAffineOpen_preimage_chartOpen π 0).isQuasiSeparated).trans
      (twistTriv₀ k (relCover C k (fiberTwoCover π)).V₀
        (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n) (le_refl _)).symm)

/-- **Chart-1 collapse of twisted sections**. -/
noncomputable def twistCollapse₁ :
    ↥(twistSubmodule k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n)
        (fiberChart₁ π)) ≃ₗ[k]
      ↥(twistSubmodule k (relCover C k (fiberTwoCover π)).V₀
        (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n)
        (relCover C k (fiberTwoCover π)).V₁) :=
  (twistTriv₁ k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) (le_refl _)).trans
    ((sectionsCollapse C (fiberChart₁ π)
        (isAffineOpen_preimage_chartOpen π 1).isCompact
        (isAffineOpen_preimage_chartOpen π 1).isQuasiSeparated).trans
      (twistTriv₁ k (relCover C k (fiberTwoCover π)).V₀
        (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n) (le_refl _)).symm)

/-- **Overlap collapse of twisted sections**: the overlap-term identification, whose
cokernel is the twisted `H¹`. -/
noncomputable def twistCollapseN :
    ↥(twistSubmodule k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n)
        (fiberChart₀ π ⊓ fiberChart₁ π)) ≃ₗ[k]
      ↥(twistSubmodule k (relCover C k (fiberTwoCover π)).V₀
        (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n)
        ((relCover C k (fiberTwoCover π)).V₀ ⊓ (relCover C k (fiberTwoCover π)).V₁)) :=
  (twistTriv₀ k (fiberChart₀ π) (fiberChart₁ π) (thetaUnit π ^ n) inf_le_left).trans
    ((sectionsCollapse C (fiberChart₀ π ⊓ fiberChart₁ π)
        (fiberTwoCover π).isAffineOpen_inf.isCompact
        (fiberTwoCover π).isAffineOpen_inf.isQuasiSeparated).trans
      ((@presheafCongr k _ (relCurve C k) (relCurve.instOver C k) _ _
          (relCover_inf C k (fiberTwoCover π)).symm).trans
        (twistTriv₀ k (relCover C k (fiberTwoCover π)).V₀
          (relCover C k (fiberTwoCover π)).V₁ (relThetaCocycle C k π n) inf_le_left).symm))

end TwistCollapse

end AlgebraicGeometry
