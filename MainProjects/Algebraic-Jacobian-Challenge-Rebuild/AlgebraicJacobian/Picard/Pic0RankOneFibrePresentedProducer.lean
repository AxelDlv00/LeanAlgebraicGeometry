/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.DivRankOneOpen
import AlgebraicJacobian.Picard.Pic0RankOneEvaluationZeroLocus

/-!
# The family-level producer for the rank-one fibre presentation

This file is deliberately an assembly layer.  Its input is the actual arbitrary-scheme
rank-one family: native presentations on every affine pullback, together with the canonical
evaluation divisor and its factorisation theorem.  The output is the stronger
`PicRankOneOpen.FibrePresented` datum, not an assumption of that datum.  The final theorem feeds
the constructed family immediately to `picRankOneOpen_isOpen_of_fibrePresented`.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory
  CartesianMonoidalCategory

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable section

abbrev rankOneAmbient : Schemeᵒᵖ ⥤ Type u :=
  Over.sigmaExtension (Spec (.of k))
    (picDegLayerFunctor C (genus C : ℤ))

abbrev rankOneLocus : Schemeᵒᵖ ⥤ Type u :=
  Over.sigmaExtension (Spec (.of k)) (PicRankOneOpen pi).toFunctor

abbrev genusDivisorYoneda : Schemeᵒᵖ ⥤ Type u :=
  yoneda.obj (divRepAffGenusScheme C).left

/-! ## The actual family-level input -/

/--
The data needed to assemble one arbitrary-scheme rank-one fibre.

`familyValue` is the restriction of the displayed ambient family to `W`, and
`nativePresentation` quantifies over every affine pullback of that value.  The map
`canonicalEvaluationDivisor` is the evaluation-divisor classifier on the rank-one locus, with
its Abel compatibility kept explicit.  The last field is the geometric factorisation statement
for that divisor, rather than a field of `FibrePresented` itself.  Divisor uniqueness is not an
extra hypothesis: it is recovered from Abel compatibility and the subtype inclusion.

In particular, no field-fibre dimension witness, unrelated line bundle, or pre-existing
`PicRankOneOpen.FibrePresented` is accepted by this contract.
-/
structure PicRankOneCanonicalEvaluationFamily
    {X : Scheme.{u}}
    (g : yoneda.obj X ⟶ rankOneAmbient (C := C)) where
  W : X.Opens
  familyValue : rankOneAmbient (C := C).obj (op (W : Scheme.{u}))
  familyValue_eq :
    familyValue =
      (yoneda.map W.ι ≫ g).app (op (W : Scheme.{u})) (𝟙 (W : Scheme.{u}))
  /-- The tied native presentation on every affine pullback of the actual family value. -/
  nativePresentation :
    ∀ (A : Type u) [CommRing A] [Algebra k A]
      (t : overSpec k A ⟶ Over.mk familyValue.1),
      Nonempty (PicRankOneNativePresentation pi
        ((picDegLayerFunctor C (genus C : ℤ)).map t.op familyValue.2))
  /-- The canonical evaluation divisor classifier on the public rank-one locus. -/
  canonicalEvaluationDivisor :
    rankOneLocus (C := C) (pi := pi) ⟶ genusDivisorYoneda (C := C)
  canonicalEvaluationDivisor_abel :
    canonicalEvaluationDivisor ≫ abelDivAffGenusSigma C =
      picRankOneOpenSigmaIncl pi
  /-- The canonical divisor factors through `W` whenever its Abel class is the displayed family. -/
  canonicalEvaluationDivisor_factor :
    ∀ (S : Scheme.{u})
      (v : rankOneLocus.obj (op S)) (w : S ⟶ X),
      (abelDivAffGenusSigma C).app (op S)
          (canonicalEvaluationDivisor.app (op S) v) =
        g.app (op S) w →
      ∃ u : S ⟶ (W : Scheme.{u}),
        u ≫ canonicalEvaluationDivisor.app
              (op (W : Scheme.{u}))
              (⟨familyValue.1, ⟨familyValue.2,
                mem_picRankOneOpen_of_nativePresentations pi
                  (fun A _ _ t => nativePresentation A t)⟩⟩) =
          canonicalEvaluationDivisor.app (op S) v ∧
        u ≫ W.ι = w

namespace PicRankOneCanonicalEvaluationFamily

variable {X : Scheme.{u}}
variable {g : yoneda.obj X ⟶ rankOneAmbient (C := C)}

/-- The Sigma-extended public-locus inclusion is injective on every test scheme. -/
lemma picRankOneOpenSigmaIncl_app_injective (S : Scheme.{u}) :
    Function.Injective ((picRankOneOpenSigmaIncl pi).app (op S)) := by
  rintro ⟨a, x⟩ ⟨b, y⟩ h
  dsimp [picRankOneOpenSigmaIncl,
    CategoryTheory.Over.sigmaExtensionNat] at h
  have hab : a = b := congrArg Sigma.fst h
  subst b
  congr 1
  apply Subtype.ext
  exact eq_of_heq (Sigma.mk.inj h).2

/-- The public-locus element carried by the actual family over its producer open. -/
noncomputable def locusValue (F : PicRankOneCanonicalEvaluationFamily pi g) :
    rankOneLocus.obj (op (F.W : Scheme.{u})) :=
  ⟨F.familyValue.1, ⟨F.familyValue.2,
    mem_picRankOneOpen_of_nativePresentations pi
      (fun A _ _ t => F.nativePresentation A t)⟩⟩

/-- The map into the public locus is obtained from its universal element by Yoneda. -/
noncomputable def fst (F : PicRankOneCanonicalEvaluationFamily pi g) :
    yoneda.obj (F.W : Scheme.{u}) ⟶ rankOneLocus (C := C) (pi := pi) :=
  yonedaEquiv.symm F.locusValue

/-- The canonical evaluation divisor of the actual family over the producer open. -/
noncomputable def evaluationDivisor
    (F : PicRankOneCanonicalEvaluationFamily pi g) :
    (F.W : Scheme.{u}) ⟶ (divRepAffGenusScheme C).left :=
  F.canonicalEvaluationDivisor.app (op (F.W : Scheme.{u})) F.locusValue

lemma fst_comp_incl (F : PicRankOneCanonicalEvaluationFamily pi g) :
    F.fst ≫ picRankOneOpenSigmaIncl pi = yoneda.map F.W.ι ≫ g := by
  apply yonedaEquiv.injective
  change (picRankOneOpenSigmaIncl pi).app (op (F.W : Scheme.{u})) F.locusValue =
    (yoneda.map F.W.ι ≫ g).app (op (F.W : Scheme.{u})) (𝟙 (F.W : Scheme.{u}))
  dsimp [locusValue, picRankOneOpenSigmaIncl,
    CategoryTheory.Over.sigmaExtensionNat]
  rw [← F.familyValue_eq]

lemma canonicalEvaluationDivisor_abel_app
    (F : PicRankOneCanonicalEvaluationFamily pi g)
    (S : Scheme.{u}) (v : rankOneLocus.obj (op S)) :
    (abelDivAffGenusSigma C).app (op S)
        (F.canonicalEvaluationDivisor.app (op S) v) =
      (picRankOneOpenSigmaIncl pi).app (op S) v := by
  have h := congrArg
    (fun q => q.app (op S) v) F.canonicalEvaluationDivisor_abel
  exact h

/-- The family evaluation divisor has the displayed family as its Abel class. -/
lemma evaluationDivisor_abel
    (F : PicRankOneCanonicalEvaluationFamily pi g) :
    yoneda.map F.evaluationDivisor ≫ abelDivAffGenusSigma C =
      yoneda.map F.W.ι ≫ g := by
  have heval :
      yoneda.map F.evaluationDivisor =
        F.fst ≫ F.canonicalEvaluationDivisor := by
    apply yonedaEquiv.injective
    rw [yonedaEquiv_yoneda_map, yonedaEquiv_comp]
    rfl
  rw [heval, Category.assoc, F.canonicalEvaluationDivisor_abel]
  exact F.fst_comp_incl

/-! ## Assembly of the stronger fibre datum -/

/--
Assemble the public fibre presentation from the native family and the canonical evaluation divisor.

The divisor factorisation is used before the `FibrePresented` structure is built.  Its divisor
equality, together with naturality of the evaluation classifier and injectivity of the public
locus inclusion, gives the required equality in the public rank-one locus.  The resulting square
is therefore a genuine pullback square, not a packaged hypothesis.
-/
noncomputable def toFibrePresented
    (F : PicRankOneCanonicalEvaluationFamily pi g) :
    PicRankOneOpen.FibrePresented pi g where
  W := F.W
  fst := F.fst
  sq := F.fst_comp_incl
  exists_factor := by
    intro S v w hvw
    have habel :
        (abelDivAffGenusSigma C).app (op S)
            (F.canonicalEvaluationDivisor.app (op S) v) =
          g.app (op S) w := by
      calc
        (abelDivAffGenusSigma C).app (op S)
            (F.canonicalEvaluationDivisor.app (op S) v) =
            (F.canonicalEvaluationDivisor ≫ abelDivAffGenusSigma C).app
              (op S) v := rfl
        _ = (picRankOneOpenSigmaIncl pi).app (op S) v := by
          rw [F.canonicalEvaluationDivisor_abel]
        _ = g.app (op S) w := hvw
    obtain ⟨u, hud, huw⟩ := F.canonicalEvaluationDivisor_factor S v w habel
    change u ≫ F.evaluationDivisor =
      F.canonicalEvaluationDivisor.app (op S) v at hud
    refine ⟨u, ?_, huw⟩
    have hnat := ConcreteCategory.congr_hom
      (F.canonicalEvaluationDivisor.naturality u.op) F.locusValue
    have htransport :
        F.canonicalEvaluationDivisor.app (op S)
            (F.fst.app (op S) u) =
          u ≫ F.canonicalEvaluationDivisor.app
            (op (F.W : Scheme.{u})) F.locusValue := by
      simpa [fst, yonedaEquiv_symm_app_apply] using hnat
    have hdiv :
        F.canonicalEvaluationDivisor.app (op S)
            (F.fst.app (op S) u) =
          F.canonicalEvaluationDivisor.app (op S) v := by
      calc
        F.canonicalEvaluationDivisor.app (op S)
          (F.fst.app (op S) u) =
          u ≫ F.canonicalEvaluationDivisor.app
            (op (F.W : Scheme.{u})) F.locusValue := htransport
        _ = F.canonicalEvaluationDivisor.app (op S) v := hud
    apply picRankOneOpenSigmaIncl_app_injective pi S
    calc
      (picRankOneOpenSigmaIncl pi).app (op S) (F.fst.app (op S) u) =
          (abelDivAffGenusSigma C).app (op S)
            (F.canonicalEvaluationDivisor.app (op S)
              (F.fst.app (op S) u)) :=
        (F.canonicalEvaluationDivisor_abel_app S (F.fst.app (op S) u)).symm
      _ = (abelDivAffGenusSigma C).app (op S)
          (F.canonicalEvaluationDivisor.app (op S) v) := congrArg _ hdiv
      _ = (picRankOneOpenSigmaIncl pi).app (op S) v :=
        F.canonicalEvaluationDivisor_abel_app S v

@[simp]
lemma toFibrePresented_W
    (F : PicRankOneCanonicalEvaluationFamily pi g) :
    F.toFibrePresented.W = F.W :=
  rfl

lemma toFibrePresented_isPullback
    (F : PicRankOneCanonicalEvaluationFamily pi g) :
    IsPullback F.fst (yoneda.map F.W.ι) (picRankOneOpenSigmaIncl pi) g :=
  F.toFibrePresented.isPullback

/-! ## Immediate openness consumer -/

theorem picRankOneOpen_isOpen_of_canonicalEvaluationFamilies
    (D : ∀ (X : Scheme.{u})
      (g : yoneda.obj X ⟶ rankOneAmbient (C := C)),
      PicRankOneCanonicalEvaluationFamily pi g) :
    PicRankOneOpen.IsOpen pi := by
  apply picRankOneOpen_isOpen_of_fibrePresented pi
  intro X g
  exact (D X g).toFibrePresented

end PicRankOneCanonicalEvaluationFamily

end
end AlgebraicGeometry
