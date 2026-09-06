/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.Pic0FiniteStageTensorProducer
import AlgebraicJacobian.Picard.PicEtAffFaithfullyFlatInjective

/-!
# Compatible degree-zero classes at a finite tensor stage

Faithfully flat restriction reflects equality of degree-zero Picard classes on affine
tests. Consequently a compatible family on finitely many tensor test rings descends to
one finite stage with all its map equations. The stage can retain any prescribed finite
set of coefficients, and no finiteness condition on the family of arrows is needed.
-/

set_option autoImplicit false

universe u

open CategoryTheory
open scoped TensorProduct

namespace AlgebraicGeometry

section FaithfullyFlat

variable {k A B : Type u} [Field k] [CommRing A] [CommRing B]
  [Algebra k A] [Algebra k B] (C : Over (Spec (.of k)))
  [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- Restriction on affine etale Picard classes is injective along a faithfully flat
algebra map. -/
theorem picEtMap_faithfullyFlat_injective [GeometricallyReduced C.hom]
    (phi : A →ₐ[k] B) (hphi : phi.toRingHom.FaithfullyFlat) :
    Function.Injective (picEtMap C (Over.overSpecMap phi)) := by
  letI : Algebra A B := phi.toRingHom.toAlgebra
  haveI : IsScalarTower k A B := .of_algebraMap_eq fun r => (phi.commutes r).symm
  have halg : algebraMap A B = phi.toRingHom := rfl
  haveI : Module.FaithfullyFlat A B :=
    RingHom.faithfullyFlat_algebraMap_iff.mp (halg.symm ▸ hphi)
  intro x y hxy
  apply (picEtAffineEquiv C A).injective
  apply PicEtAff.map_faithfullyFlat_injective (A := A) (B := B) C
  change PicEtAff.mapAlg C phi (picEtAffineEquiv C A x) =
    PicEtAff.mapAlg C phi (picEtAffineEquiv C A y)
  rw [← picEtAffineEquiv_naturality, ← picEtAffineEquiv_naturality, hxy]

/-- Faithfully flat affine restriction reflects equality of degree-zero classes. -/
theorem pic0Map_faithfullyFlat_injective [SmoothOfRelativeDimension 1 C.hom]
    (phi : A →ₐ[k] B) (hphi : phi.toRingHom.FaithfullyFlat) :
    Function.Injective (pic0Map C (Over.overSpecMap phi)) := by
  intro x y h
  apply Subtype.ext
  exact picEtMap_faithfullyFlat_injective C phi hphi (congrArg Subtype.val h)

end FaithfullyFlat

variable {F K : Type u} [Field F] [Field K] [Algebra F K]
  [Algebra.IsAlgebraic F K]
  (C : Over (Spec (.of F))) [SmoothOfRelativeDimension 1 C.hom]
  [IsProper C.hom] [GeometricallyIrreducible C.hom]

/-- A finite tensor stage embeds faithfully on degree-zero Picard classes. -/
theorem pic0Map_tensorStage_injective
    (S : DatG0.FiniteStageData F K) (A : Type u) [CommRing A] [Algebra F A] :
    Function.Injective (pic0Map C (Over.overSpecMap (S.tensorMap (A := A)))) := by
  apply pic0Map_faithfullyFlat_injective C
  letI : Algebra (S.stage ⊗[F] A) (K ⊗[F] A) := S.tensorAlgebra (A := A)
  haveI : Module.FaithfullyFlat (S.stage ⊗[F] A) (K ⊗[F] A) :=
    DatG0.tensorStageMap_faithfullyFlat (B := A) S.toFinSubext
  have halg : algebraMap (S.stage ⊗[F] A) (K ⊗[F] A) =
      (S.tensorMap (A := A)).toRingHom := rfl
  rw [← halg]
  exact RingHom.faithfullyFlat_algebraMap_iff.mpr inferInstance

/-- A compatible family on finitely many tensor test rings descends to one finite stage
above any prescribed stage, retaining all compatibility equations. -/
theorem exists_pic0Subgroup_tensorStage_compatible
    {ι δ : Type*} [Finite ι]
    (A : ι → Type u) [∀ i, CommRing (A i)] [∀ i, Algebra F (A i)]
    (s t : δ → ι) (r : ∀ d, A (s d) →ₐ[F] A (t d))
    (S₀ : DatG0.FiniteStageData F K)
    (x : ∀ i, pic0Subgroup C (overSpec F (K ⊗[F] A i)))
    (hx : ∀ d, pic0Map C (Over.overSpecMap
      (Algebra.TensorProduct.map (AlgHom.id F K) (r d))) (x (s d)) = x (t d)) :
    ∃ S : DatG0.FiniteStageData F K, S₀.stage ≤ S.stage ∧
      ∃ xS : ∀ i, pic0Subgroup C (overSpec F (S.stage ⊗[F] A i)),
        (∀ i, pic0Map C (Over.overSpecMap (S.tensorMap (A := A i))) (xS i) = x i) ∧
        ∀ d, pic0Map C (Over.overSpecMap
          (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r d))) (xS (s d)) =
            xS (t d) := by
  obtain ⟨S, hS, xS, hmap⟩ := exists_pic0Subgroup_tensorStage_finite C A S₀ x
  refine ⟨S, hS, xS, hmap, ?_⟩
  intro d
  apply pic0Map_tensorStage_injective C S (A (t d))
  rw [hmap]
  have hcomp : (S.tensorMap (A := A (t d))).comp
      (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r d)) =
    (Algebra.TensorProduct.map (AlgHom.id F K) (r d)).comp
      (S.tensorMap (A := A (s d))) := by
    ext z <;> rfl
  apply Subtype.ext
  change picEtMap C (Over.overSpecMap (S.tensorMap (A := A (t d))))
    (picEtMap C (Over.overSpecMap
      (Algebra.TensorProduct.map (AlgHom.id F S.stage) (r d))) (xS (s d)).val) =
        (x (t d)).val
  rw [← picEtMap_comp, ← Over.overSpecMap_comp, hcomp,
    Over.overSpecMap_comp, picEtMap_comp]
  change (pic0Map C (Over.overSpecMap
    (Algebra.TensorProduct.map (AlgHom.id F K) (r d)))
    (pic0Map C (Over.overSpecMap (S.tensorMap (A := A (s d)))) (xS (s d)))).val = _
  rw [hmap, hx]

end AlgebraicGeometry
