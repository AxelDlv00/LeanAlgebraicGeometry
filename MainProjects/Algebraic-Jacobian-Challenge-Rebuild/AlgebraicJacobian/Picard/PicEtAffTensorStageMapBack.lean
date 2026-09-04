/-
Copyright (c) 2026 The AlgebraicJacobian Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.PicEtAffTensorStageDescentClass

/-!
# Mapping finite tensor-stage descent classes back to the ambient test

This module exposes the two algebra maps used by the finite-stage route and a flat
comparison boundary for descending a relative Picard class.  Keeping the comparison
hypotheses explicit avoids putting the dependent carrier and overlap instances into a
single canonical wrapper.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

noncomputable section

namespace DatG0

set_option maxSynthPendingDepth 16 in
/-- The nested tensor-stage map as an algebra map over the intermediate field. -/
noncomputable def tensorStageNestedAmbientMapOverIntermediate
    {F K B : Type u} [Field F] [Field K] [Algebra F K]
    [CommRing B] [Algebra F B]
    (M : FinSubext F K) (S : FiniteStageData M.1 K) :
    S.stage ⊗[M.1] (M.1 ⊗[F] B) →ₐ[M.1] K ⊗[F] B :=
  ((Algebra.TensorProduct.cancelBaseChange F M.1 K K B).toAlgHom.restrictScalars M.1).comp
    (S.tensorMap (A := M.1 ⊗[F] B))

end DatG0

set_option synthInstance.maxHeartbeats 100000 in
-- The explicit comparison boundary contains the two pushout face maps; this budget keeps
-- their dependent tensor-product instances predictable during elaboration.
set_option maxHeartbeats 1600000 in
set_option maxSynthPendingDepth 16 in
/-- Descend a normalized finite-stage relative Picard class from explicit comparison data.

The map `jA` identifies the normalized carrier with the ambient etale-cover carrier, while
`jQ` identifies their self-overlaps.  The injectivity of the induced relative-Picard map and
the two face squares reduce the ambient Cech equality to the normalized one. -/
noncomputable def descentClassOfExplicitComparisons
    {k S R TS TK : Type u} [Field k]
    [CommRing S] [CommRing R] [CommRing TS] [CommRing TK]
    [Algebra k S] [Algebra k R] [Algebra k TS] [Algebra k TK]
    [Algebra S TS] [Algebra R TS] [Algebra R TK]
    [IsScalarTower k S TS] [IsScalarTower k R TS]
    [Algebra.IsPushout k S R TS]
    (C : Over (Spec (.of k))) (E : Algebra.EtaleCover R)
    (qStage : relPic C (overSpec k (S ⊗[k] E.Carrier)))
    (ξK : descentClasses C (E.baseChange TK))
    (jA : S ⊗[k] E.Carrier →ₐ[k] (E.baseChange TK).Carrier)
    (jQ :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      S ⊗[k] Pic0FiniteStageTensorPushoutRing f f →ₐ[k]
        (E.baseChange TK).Carrier ⊗[TK] (E.baseChange TK).Carrier)
    (hjQ : Function.Injective (relPicAlgMap C jQ))
    (hmap : relPicAlgMap C jA qStage =
      (ξK : relPic C (overSpec k (E.baseChange TK).Carrier)))
    (hleft :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      let q₁ := finiteStageTensorPushoutFaceLeft f f
      let q₁S : S ⊗[k] E.Carrier →ₐ[k]
          S ⊗[k] Pic0FiniteStageTensorPushoutRing f f :=
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := k) (K := S) q₁).restrictScalars k
      jQ.comp q₁S = (doubleInl (E.baseChange TK)).comp jA)
    (hright :
      let f : R →ₐ[k] E.Carrier :=
        (Algebra.ofId R E.Carrier).restrictScalars k
      let q₂ := finiteStageTensorPushoutFaceRight f f
      let q₂S : S ⊗[k] E.Carrier →ₐ[k]
          S ⊗[k] Pic0FiniteStageTensorPushoutRing f f :=
        (AlgebraicJacobian.scalarExtensionMapOfAlgHom
          (R := k) (K := S) q₂).restrictScalars k
      jQ.comp q₂S = (doubleInr (E.baseChange TK)).comp jA) :
    descentClasses C (E.baseChange TS) := by
  let f : R →ₐ[k] E.Carrier :=
    (Algebra.ofId R E.Carrier).restrictScalars k
  let Q := Pic0FiniteStageTensorPushoutRing f f
  let q₁S : S ⊗[k] E.Carrier →ₐ[k] S ⊗[k] Q :=
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := k) (K := S) (finiteStageTensorPushoutFaceLeft f f)).restrictScalars k
  let q₂S : S ⊗[k] E.Carrier →ₐ[k] S ⊗[k] Q :=
    (AlgebraicJacobian.scalarExtensionMapOfAlgHom
      (R := k) (K := S) (finiteStageTensorPushoutFaceRight f f)).restrictScalars k
  have hξK :
      relPicAlgMap C (doubleInl (E.baseChange TK))
          (ξK : relPic C (overSpec k (E.baseChange TK).Carrier)) =
        relPicAlgMap C (doubleInr (E.baseChange TK))
          (ξK : relPic C (overSpec k (E.baseChange TK).Carrier)) :=
    (mem_descentClasses_iff (C := C)).mp ξK.2
  have hfaces : relPicAlgMap C q₁S qStage = relPicAlgMap C q₂S qStage :=
    relPic_pair_eq_of_compatible C qStage ξK jA jQ q₁S q₂S
      (doubleInl (E.baseChange TK)) (doubleInr (E.baseChange TK))
      hjQ hmap hleft hright hξK
  exact descentClassOfPushoutFaceEq C E qStage hfaces

end

end AlgebraicGeometry
