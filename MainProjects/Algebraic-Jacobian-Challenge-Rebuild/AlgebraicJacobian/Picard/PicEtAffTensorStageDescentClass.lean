/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtPushoutCarrierOverlap
import AlgebraicJacobian.Picard.PicEtTensorStageOverlap
import AlgebraicJacobian.Picard.PicEtAffDescentReflection
import AlgebraicJacobian.Picard.RelPicFaithfullyFlatInjective
import AlgebraicJacobian.Picard.RelPicTensorStageFiniteStage
import AlgebraicJacobian.Picard.PicEtTensorStageCanonicalHelpers

/-!
# Descent classes at finite tensor stages

A relative Picard class descended to a finite tensor stage inherits any equality between
two scalar-extended restriction maps.  Applied to the two faces of an etale cover, the
resulting equality can be transported through the pushout carrier and overlap comparisons
to produce an actual descent class on the lower base-changed cover.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

/-- Reflect a pair of restriction maps from a compatible ambient relative Picard class.

All rings and maps are explicit here so tensor-stage consumers can elaborate this
reflection boundary before installing their dependent scalar-extension instances. -/
theorem relPic_pair_eq_of_compatible
    {k A A' Q Q' : Type u} [Field k]
    [CommRing A] [CommRing A'] [CommRing Q] [CommRing Q']
    [Algebra k A] [Algebra k A'] [Algebra k Q] [Algebra k Q']
    (C : Over (Spec (.of k)))
    (qA : relPic C (overSpec k A)) (qA' : relPic C (overSpec k A'))
    (jA : A →ₐ[k] A') (jQ : Q →ₐ[k] Q')
    (f g : A →ₐ[k] Q) (f' g' : A' →ₐ[k] Q')
    (hjQ : Function.Injective (relPicAlgMap C jQ))
    (hq : relPicAlgMap C jA qA = qA')
    (hf : jQ.comp f = f'.comp jA) (hg : jQ.comp g = g'.comp jA)
    (hQ' : relPicAlgMap C f' qA' = relPicAlgMap C g' qA') :
    relPicAlgMap C f qA = relPicAlgMap C g qA := by
  apply relPicAlgMap_pair_eq_of_injective C jA jQ f g f' g' hjQ hf hg
  rw [hq]
  exact hQ'

set_option synthInstance.maxHeartbeats 100000 in
-- The two pushout comparisons unfold dependent tensor-product algebra structures.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- A relative Picard class satisfying the named scalar-extended face equality gives an
actual descent class on a cover base-changed around the corresponding pushout square. -/
noncomputable def descentClassOfPushoutFaceEq
    {k S R T : Type u} [Field k]
    [CommRing S] [CommRing R] [CommRing T]
    [Algebra k S] [Algebra k R] [Algebra k T]
    [Algebra S T] [Algebra R T]
    [IsScalarTower k S T] [IsScalarTower k R T]
    [Algebra.IsPushout k S R T]
    (C : Over (Spec (.of k))) (E : Algebra.EtaleCover R)
    (qS : relPic C (overSpec k (S ⊗[k] E.Carrier)))
    (hfaces :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      let q₁ := finiteStageTensorPushoutFaceLeft f f
      let q₂ := finiteStageTensorPushoutFaceRight f f
      relPicAlgMap C
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := k) (K := S) q₁).restrictScalars k) qS =
        relPicAlgMap C
          ((AlgebraicJacobian.scalarExtensionMapOfAlgHom
            (R := k) (K := S) q₂).restrictScalars k) qS) :
    descentClasses C (E.baseChange T) := by
  let f : R →ₐ[k] E.Carrier :=
    (Algebra.ofId R E.Carrier).restrictScalars k
  let Q := Pic0FiniteStageTensorPushoutRing f f
  let U := (E.baseChange T).Carrier
  let U₂ := U ⊗[T] U
  let eU : S ⊗[k] E.Carrier ≃ₐ[S] U :=
    (DatG0.etaleCoverPushoutCarrierEquiv
      (M := k) (S := S) (T := T) E).symm
  let eQ : S ⊗[k] Q ≃ₐ[S] U₂ :=
    DatG0.etaleCoverPushoutOverlapEquiv
      (M := k) (S := S) (T := T) E
  let q₁ : E.Carrier →ₐ[k] Q := finiteStageTensorPushoutFaceLeft f f
  let q₂ : E.Carrier →ₐ[k] Q := finiteStageTensorPushoutFaceRight f f
  let q₁S : S ⊗[k] E.Carrier →ₐ[k] S ⊗[k] Q :=
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := k) (K := S) q₁).restrictScalars k
  let q₂S : S ⊗[k] E.Carrier →ₐ[k] S ⊗[k] Q :=
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := k) (K := S) q₂).restrictScalars k
  let j₁ : U →ₐ[k] U₂ :=
    (DatG0.etaleCoverPushoutOverlapFaceLeft
      (M := k) (S := S) (T := T) E).restrictScalars k
  let j₂ : U →ₐ[k] U₂ :=
    (DatG0.etaleCoverPushoutOverlapFaceRight
      (M := k) (S := S) (T := T) E).restrictScalars k
  let eUk : S ⊗[k] E.Carrier →ₐ[k] U := eU.toAlgHom.restrictScalars k
  let eQk : S ⊗[k] Q →ₐ[k] U₂ := eQ.toAlgHom.restrictScalars k
  have h₁ : eQk.comp q₁S = j₁.comp eUk := by
    apply AlgHom.ext
    intro x
    exact DFunLike.congr_fun
      (DatG0.etaleCoverPushoutOverlapEquiv_faceLeft
        (M := k) (S := S) (T := T) E) x
  have h₂ : eQk.comp q₂S = j₂.comp eUk := by
    apply AlgHom.ext
    intro x
    exact DFunLike.congr_fun
      (DatG0.etaleCoverPushoutOverlapEquiv_faceRight
        (M := k) (S := S) (T := T) E) x
  refine ⟨relPicAlgMap C eUk qS, ?_⟩
  rw [mem_descentClasses_iff]
  change relPicAlgMap C j₁ (relPicAlgMap C eUk qS) =
    relPicAlgMap C j₂ (relPicAlgMap C eUk qS)
  rw [← relPicAlgMap_comp, ← relPicAlgMap_comp, ← h₁, ← h₂,
    relPicAlgMap_comp, relPicAlgMap_comp]
  exact congrArg (relPicAlgMap C eQk) hfaces

/-- The comparison data needed to reflect an ambient descent class to a finite tensor
stage.  Packaging the dependent carrier and overlap maps keeps each compatibility square
at a stable elaboration boundary. -/
structure CompatibleAmbientDescentData
    {k S R TS TK : Type u} [Field k]
    [CommRing S] [CommRing R] [CommRing TS] [CommRing TK]
    [Algebra k S] [Algebra k R] [Algebra k TS] [Algebra k TK]
    [Algebra S TS] [Algebra R TS] [Algebra R TK]
    [IsScalarTower k S TS] [IsScalarTower k R TS]
    [Algebra.IsPushout k S R TS]
    (C : Over (Spec (.of k))) (E : Algebra.EtaleCover R) where
  qStage : relPic C (overSpec k (S ⊗[k] E.Carrier))
  ξK : descentClasses C (E.baseChange TK)
  jA : S ⊗[k] E.Carrier →ₐ[k] (E.baseChange TK).Carrier
  jQ :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      S ⊗[k] Pic0FiniteStageTensorPushoutRing f f →ₐ[k]
        (E.baseChange TK).Carrier ⊗[TK] (E.baseChange TK).Carrier
  hjQ : Function.Injective
    (@relPicAlgMap k _ C
      (S ⊗[k] Pic0FiniteStageTensorPushoutRing
        ((Algebra.ofId R E.Carrier).restrictScalars k)
        ((Algebra.ofId R E.Carrier).restrictScalars k))
      ((E.baseChange TK).Carrier ⊗[TK] (E.baseChange TK).Carrier)
      inferInstance inferInstance inferInstance inferInstance jQ)
  map_eq : relPicAlgMap C jA qStage =
    (ξK : relPic C (overSpec k (E.baseChange TK).Carrier))
  faceLeft_eq :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      let q₁ := finiteStageTensorPushoutFaceLeft f f
      let q₁S : S ⊗[k] E.Carrier →ₐ[k]
          S ⊗[k] Pic0FiniteStageTensorPushoutRing f f :=
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := k) (K := S) q₁).restrictScalars k
      jQ.comp q₁S = (doubleInl (E.baseChange TK)).comp jA
  faceRight_eq :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      let q₂ := finiteStageTensorPushoutFaceRight f f
      let q₂S : S ⊗[k] E.Carrier →ₐ[k]
          S ⊗[k] Pic0FiniteStageTensorPushoutRing f f :=
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := k) (K := S) q₂).restrictScalars k
      jQ.comp q₂S = (doubleInr (E.baseChange TK)).comp jA

set_option synthInstance.maxHeartbeats 100000 in
-- The source and target overlap rings contain map-selected dependent tensor products.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- A finite-stage relative Picard class compatible with an ambient descent class gives
an actual descent class on the lower base-changed cover. -/
noncomputable def descentClassOfCompatibleAmbient
    {k S R TS TK : Type u} [Field k]
    [CommRing S] [CommRing R] [CommRing TS] [CommRing TK]
    [Algebra k S] [Algebra k R] [Algebra k TS] [Algebra k TK]
    [Algebra S TS] [Algebra R TS] [Algebra R TK]
    [IsScalarTower k S TS] [IsScalarTower k R TS]
    [Algebra.IsPushout k S R TS]
    (C : Over (Spec (.of k))) (E : Algebra.EtaleCover R)
    (d : CompatibleAmbientDescentData
      (S := S) (R := R) (TS := TS) (TK := TK) C E) :
    descentClasses C (E.baseChange TS) := by
  let f : R →ₐ[k] E.Carrier :=
    (Algebra.ofId R E.Carrier).restrictScalars k
  let Q := Pic0FiniteStageTensorPushoutRing f f
  let q₁ : E.Carrier →ₐ[k] Q := finiteStageTensorPushoutFaceLeft f f
  let q₂ : E.Carrier →ₐ[k] Q := finiteStageTensorPushoutFaceRight f f
  let q₁S : S ⊗[k] E.Carrier →ₐ[k] S ⊗[k] Q :=
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := k) (K := S) q₁).restrictScalars k
  let q₂S : S ⊗[k] E.Carrier →ₐ[k] S ⊗[k] Q :=
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := k) (K := S) q₂).restrictScalars k
  have hξK :
      relPicAlgMap C (doubleInl (E.baseChange TK))
          (d.ξK : relPic C (overSpec k (E.baseChange TK).Carrier)) =
        relPicAlgMap C (doubleInr (E.baseChange TK))
          (d.ξK : relPic C (overSpec k (E.baseChange TK).Carrier)) :=
    (mem_descentClasses_iff (C := C)).mp d.ξK.2
  have hfaces : relPicAlgMap C q₁S d.qStage = relPicAlgMap C q₂S d.qStage :=
    relPic_pair_eq_of_compatible C d.qStage d.ξK d.jA d.jQ q₁S q₂S
      (doubleInl (E.baseChange TK)) (doubleInr (E.baseChange TK))
      d.hjQ d.map_eq d.faceLeft_eq d.faceRight_eq hξK
  exact descentClassOfPushoutFaceEq C E d.qStage hfaces

end

end AlgebraicGeometry
