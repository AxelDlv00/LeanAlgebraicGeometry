/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Algebra.EtaleCover
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorPushoutComparison

/-!
# Etale-cover carriers over a pushout square

An algebraic pushout square identifies the carrier of a base-changed etale cover
with scalar extension of the original carrier. This file extends that comparison
to the cover's self-overlap and records compatibility with both Cech faces.
-/

set_option autoImplicit false

universe u

open CategoryTheory Limits
open scoped TensorProduct

namespace AlgebraicGeometry.DatG0

noncomputable section

set_option synthInstance.maxHeartbeats 100000 in
-- Pushout cancellation builds a dependent algebra structure on the cover carrier.
set_option maxSynthPendingDepth 16 in
/-- The carrier of a cover base-changed around a pushout square is scalar extension
of the original carrier from the initial ring. -/
noncomputable def etaleCoverPushoutCarrierEquiv
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    (E.baseChange T).Carrier ≃ₐ[S] S ⊗[M] E.Carrier :=
  ((E.baseChangeEquiv T).restrictScalars S).trans
    (Algebra.IsPushout.cancelBaseChangeAlg M S R T E.Carrier)

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the dependent carrier comparison needs a deeper and longer search.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- The pushout carrier comparison sends a canonical cover generator to the
corresponding scalar-extension generator. -/
@[simp]
theorem etaleCoverPushoutCarrierEquiv_baseChange_tmul
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) (x : E.Carrier) :
    etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E
        ((E.baseChangeEquiv T).symm ((1 : T) ⊗ₜ[R] x)) =
      (1 : S) ⊗ₜ[M] x := by
  rw [etaleCoverPushoutCarrierEquiv]
  change Algebra.IsPushout.cancelBaseChangeAlg M S R T E.Carrier
      ((E.baseChangeEquiv T)
        ((E.baseChangeEquiv T).symm ((1 : T) ⊗ₜ[R] x))) =
    (1 : S) ⊗ₜ[M] x
  rw [(E.baseChangeEquiv T).apply_symm_apply]
  exact Algebra.IsPushout.cancelBaseChangeAlg_tmul M S R T E.Carrier x

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the dependent carrier comparison needs a deeper and longer search.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- Inverse generator formula for the pushout carrier comparison. -/
@[simp]
theorem etaleCoverPushoutCarrierEquiv_symm_tmul
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) (x : E.Carrier) :
    (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
        ((1 : S) ⊗ₜ[M] x) =
      (E.baseChangeEquiv T).symm ((1 : T) ⊗ₜ[R] x) := by
  apply (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).injective
  rw [(etaleCoverPushoutCarrierEquiv
    (M := M) (S := S) (T := T) E).apply_symm_apply]
  exact (etaleCoverPushoutCarrierEquiv_baseChange_tmul
    (M := M) (S := S) (T := T) E x).symm

set_option synthInstance.maxHeartbeats 100000 in
-- Extensionality unfolds the dependent tensor algebra hierarchy in the pushout square.
set_option maxHeartbeats 800000 in
set_option maxSynthPendingDepth 16 in
/-- The inverse carrier comparison intertwines scalar extension of the cover
structure map with the base-ring pushout equivalence. -/
theorem etaleCoverPushoutCarrierEquiv_symm_naturality
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    let f : R →ₐ[M] E.Carrier :=
      (Algebra.ofId R E.Carrier).restrictScalars M
    let eR : (S ⊗[M] R) ≃ₐ[S] T :=
      Algebra.IsPushout.equiv M S R T
    let eE : (S ⊗[M] E.Carrier) ≃ₐ[S] (E.baseChange T).Carrier :=
      (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
    let g : T →ₐ[S] (E.baseChange T).Carrier :=
      (Algebra.ofId T (E.baseChange T).Carrier).restrictScalars S
    eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M) (K := S) f) =
      g.comp eR.toAlgHom := by
  dsimp only
  apply Algebra.TensorProduct.ext_ring
  ext r
  simp only [AlgHom.coe_comp, AlgHom.coe_restrictScalars', AlgEquiv.coe_algHom,
    Function.comp_apply, Algebra.TensorProduct.includeRight_apply,
    AlgebraicJacobian.scalarExtensionMapOfAlgHom_tmul, Algebra.ofId_apply,
    etaleCoverPushoutCarrierEquiv_symm_tmul,
    Algebra.IsPushout.equiv_tmul, map_one, one_mul]
  apply (E.baseChangeEquiv T).injective
  rw [(E.baseChangeEquiv T).apply_symm_apply]
  rw [(E.baseChangeEquiv T).commutes]
  rw [show algebraMap R E.Carrier r = r • (1 : E.Carrier) by
    simp [Algebra.smul_def]]
  rw [TensorProduct.tmul_smul]
  simp [Algebra.smul_def]

/-- The left face of the self-overlap of a cover after base change around a
pushout square. -/
noncomputable def etaleCoverPushoutOverlapFaceLeft
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    let U := (E.baseChange T).Carrier
    U →ₐ[S] U ⊗[T] U := by
  dsimp only
  exact (Algebra.TensorProduct.includeLeft :
    (E.baseChange T).Carrier →ₐ[T]
      (E.baseChange T).Carrier ⊗[T] (E.baseChange T).Carrier).restrictScalars S

/-- The right face of the self-overlap of a cover after base change around a
pushout square. -/
noncomputable def etaleCoverPushoutOverlapFaceRight
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    let U := (E.baseChange T).Carrier
    U →ₐ[S] U ⊗[T] U := by
  dsimp only
  exact (Algebra.TensorProduct.includeRight :
    (E.baseChange T).Carrier →ₐ[T]
      (E.baseChange T).Carrier ⊗[T] (E.baseChange T).Carrier).restrictScalars S

set_option synthInstance.maxHeartbeats 100000 in
-- The categorical pushout comparison elaborates through several dependent tensors.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- Scalar extension of the original cover's self-overlap is canonically the
self-overlap after base change around the pushout square. -/
noncomputable def etaleCoverPushoutOverlapEquiv
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    let f : R →ₐ[M] E.Carrier :=
      (Algebra.ofId R E.Carrier).restrictScalars M
    S ⊗[M] Pic0FiniteStageTensorPushoutRing f f ≃ₐ[S]
      (E.baseChange T).Carrier ⊗[T] (E.baseChange T).Carrier := by
  dsimp only
  let U := (E.baseChange T).Carrier
  let f : R →ₐ[M] E.Carrier :=
    (Algebra.ofId R E.Carrier).restrictScalars M
  let eR : (S ⊗[M] R) ≃ₐ[S] T :=
    Algebra.IsPushout.equiv M S R T
  let eE : (S ⊗[M] E.Carrier) ≃ₐ[S] U :=
    (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
  let g : T →ₐ[S] U :=
    (Algebra.ofId T U).restrictScalars S
  let Q := U ⊗[T] U
  let j₁ : U →ₐ[S] Q :=
    etaleCoverPushoutOverlapFaceLeft (M := M) (S := S) (T := T) E
  let j₂ : U →ₐ[S] Q :=
    etaleCoverPushoutOverlapFaceRight (M := M) (S := S) (T := T) E
  have hnat : eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M) (K := S) f) =
      g.comp eR.toAlgHom :=
    etaleCoverPushoutCarrierEquiv_symm_naturality
      (M := M) (S := S) (T := T) E
  have hPush : IsPushout
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom j₁.toRingHom)
      (CommRingCat.ofHom j₂.toRingHom) := by
    change IsPushout
      (CommRingCat.ofHom (algebraMap T U))
      (CommRingCat.ofHom (algebraMap T U))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := T) (A := U) (B := U)))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := T) (A := U) (B := U)).toRingHom)
    exact CommRingCat.isPushout_tensorProduct T U U
  exact finiteStageTensorPushoutComparison
    f f eR eE eE g g j₁ j₂ hnat hnat hPush

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the comparison requires the same dependent tensor hierarchy as its definition.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The overlap comparison carries the scalar-extended left face to the actual
left face after base change. -/
theorem etaleCoverPushoutOverlapEquiv_faceLeft
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    let f : R →ₐ[M] E.Carrier :=
      (Algebra.ofId R E.Carrier).restrictScalars M
    let eE : (S ⊗[M] E.Carrier) ≃ₐ[S] (E.baseChange T).Carrier :=
      (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
    (etaleCoverPushoutOverlapEquiv
      (M := M) (S := S) (T := T) E).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M) (K := S) (finiteStageTensorPushoutFaceLeft f f)) =
      (etaleCoverPushoutOverlapFaceLeft
        (M := M) (S := S) (T := T) E).comp eE.toAlgHom := by
  dsimp only
  let U := (E.baseChange T).Carrier
  let f : R →ₐ[M] E.Carrier :=
    (Algebra.ofId R E.Carrier).restrictScalars M
  let eR : (S ⊗[M] R) ≃ₐ[S] T :=
    Algebra.IsPushout.equiv M S R T
  let eE : (S ⊗[M] E.Carrier) ≃ₐ[S] U :=
    (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
  let g : T →ₐ[S] U :=
    (Algebra.ofId T U).restrictScalars S
  let Q := U ⊗[T] U
  let j₁ : U →ₐ[S] Q :=
    etaleCoverPushoutOverlapFaceLeft (M := M) (S := S) (T := T) E
  let j₂ : U →ₐ[S] Q :=
    etaleCoverPushoutOverlapFaceRight (M := M) (S := S) (T := T) E
  have hnat : eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M) (K := S) f) =
      g.comp eR.toAlgHom :=
    etaleCoverPushoutCarrierEquiv_symm_naturality
      (M := M) (S := S) (T := T) E
  have hPush : IsPushout
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom j₁.toRingHom)
      (CommRingCat.ofHom j₂.toRingHom) := by
    change IsPushout
      (CommRingCat.ofHom (algebraMap T U))
      (CommRingCat.ofHom (algebraMap T U))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := T) (A := U) (B := U)))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := T) (A := U) (B := U)).toRingHom)
    exact CommRingCat.isPushout_tensorProduct T U U
  change
    (finiteStageTensorPushoutComparison
        f f eR eE eE g g j₁ j₂ hnat hnat hPush).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M) (K := S) (finiteStageTensorPushoutFaceLeft f f)) =
      j₁.comp eE.toAlgHom
  exact finiteStageTensorPushoutComparison_faceLeft
    f f eR eE eE g g j₁ j₂ hnat hnat hPush

set_option synthInstance.maxHeartbeats 100000 in
-- Unfolding the comparison requires the same dependent tensor hierarchy as its definition.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- The overlap comparison carries the scalar-extended right face to the actual
right face after base change. -/
theorem etaleCoverPushoutOverlapEquiv_faceRight
    {M S R T : Type u}
    [CommRing M] [CommRing S] [CommRing R] [CommRing T]
    [Algebra M S] [Algebra M R] [Algebra M T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower M S T] [IsScalarTower M R T]
    [Algebra.IsPushout M S R T]
    (E : Algebra.EtaleCover R) :
    let f : R →ₐ[M] E.Carrier :=
      (Algebra.ofId R E.Carrier).restrictScalars M
    let eE : (S ⊗[M] E.Carrier) ≃ₐ[S] (E.baseChange T).Carrier :=
      (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
    (etaleCoverPushoutOverlapEquiv
      (M := M) (S := S) (T := T) E).toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M) (K := S) (finiteStageTensorPushoutFaceRight f f)) =
      (etaleCoverPushoutOverlapFaceRight
        (M := M) (S := S) (T := T) E).comp eE.toAlgHom := by
  dsimp only
  let U := (E.baseChange T).Carrier
  let f : R →ₐ[M] E.Carrier :=
    (Algebra.ofId R E.Carrier).restrictScalars M
  let eR : (S ⊗[M] R) ≃ₐ[S] T :=
    Algebra.IsPushout.equiv M S R T
  let eE : (S ⊗[M] E.Carrier) ≃ₐ[S] U :=
    (etaleCoverPushoutCarrierEquiv (M := M) (S := S) (T := T) E).symm
  let g : T →ₐ[S] U :=
    (Algebra.ofId T U).restrictScalars S
  let Q := U ⊗[T] U
  let j₁ : U →ₐ[S] Q :=
    etaleCoverPushoutOverlapFaceLeft (M := M) (S := S) (T := T) E
  let j₂ : U →ₐ[S] Q :=
    etaleCoverPushoutOverlapFaceRight (M := M) (S := S) (T := T) E
  have hnat : eE.toAlgHom.comp
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := M) (K := S) f) =
      g.comp eR.toAlgHom :=
    etaleCoverPushoutCarrierEquiv_symm_naturality
      (M := M) (S := S) (T := T) E
  have hPush : IsPushout
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom g.toRingHom)
      (CommRingCat.ofHom j₁.toRingHom)
      (CommRingCat.ofHom j₂.toRingHom) := by
    change IsPushout
      (CommRingCat.ofHom (algebraMap T U))
      (CommRingCat.ofHom (algebraMap T U))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeLeftRingHom
          (R := T) (A := U) (B := U)))
      (CommRingCat.ofHom
        (Algebra.TensorProduct.includeRight
          (R := T) (A := U) (B := U)).toRingHom)
    exact CommRingCat.isPushout_tensorProduct T U U
  change
    (finiteStageTensorPushoutComparison
        f f eR eE eE g g j₁ j₂ hnat hnat hPush).toAlgHom.comp
      (AlgebraicJacobian.scalarExtensionMapOfAlgHom
        (R := M) (K := S) (finiteStageTensorPushoutFaceRight f f)) =
      j₂.comp eE.toAlgHom
  exact finiteStageTensorPushoutComparison_faceRight
    f f eR eE eE g g j₁ j₂ hnat hnat hPush

end

end AlgebraicGeometry.DatG0
