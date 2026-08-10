/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import AlgebraicJacobian.Picard.DivRankOneOpen
import AlgebraicJacobian.Picard.Pic0RankOneNativePresentation

/-!
# Conditional assembly of the rank-one fibre presentation

This file isolates the final presheaf assembly.  It does not construct the still-missing
arbitrary-scheme rank-one family or canonical evaluation divisor.  Instead, its input records
native presentations on every affine pullback of one restricted family value, a natural
evaluation-divisor classifier, and the classifier's geometric factorisation theorem.  From
those inputs it constructs the stronger `PicRankOneOpen.FibrePresented` datum, proves the
resulting square is a pullback, and feeds it immediately to
`picRankOneOpen_isOpen_of_fibrePresented`.

Thus the declarations below are a conditional adapter, not the family-level producer required
by the Phase-4 acceptance contract.  In particular, the divisor factorisation remains an
explicit upstream obligation and receives no producer credit here.
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

/-! ## The explicit geometric input -/

/--
The explicit data needed to assemble one arbitrary-scheme rank-one fibre.

`restrictedValue` is the restriction of the displayed ambient family to `W`, and
`nativePresentation` quantifies over every affine pullback of that value.  The map
`canonicalEvaluationDivisor` is the evaluation-divisor classifier on the rank-one locus, with
its Abel compatibility kept explicit.  The last field is the unresolved geometric
factorisation statement for that divisor, rather than a field of `FibrePresented` itself.
Divisor uniqueness is not an extra hypothesis: it is recovered from Abel compatibility and the
subtype inclusion.

In particular, no field-fibre dimension witness, unrelated line bundle, or pre-existing
`PicRankOneOpen.FibrePresented` is accepted by this contract.  Conversely, this structure is not
itself a producer: an inhabitant must still supply the arbitrary-affine native presentations and
the canonical divisor factorisation.
-/
structure PicRankOneFibrePresentationInput
    {X : Scheme.{u}}
    (g : yoneda.obj X ⟶ rankOneAmbient (C := C)) where
  W : X.Opens
  restrictedValue : rankOneAmbient (C := C).obj (op (W : Scheme.{u}))
  restrictedValue_eq :
    restrictedValue =
      (yoneda.map W.ι ≫ g).app (op (W : Scheme.{u})) (𝟙 (W : Scheme.{u}))
  /-- The tied native presentation on every affine pullback of the restricted family value. -/
  nativePresentation :
    ∀ (A : Type u) [CommRing A] [Algebra k A]
      (t : overSpec k A ⟶ Over.mk restrictedValue.1),
      Nonempty (PicRankOneNativePresentation pi
        ((picDegLayerFunctor C (genus C : ℤ)).map t.op restrictedValue.2))
  /-- The canonical evaluation divisor classifier on the public rank-one locus. -/
  canonicalEvaluationDivisor :
    rankOneLocus (C := C) (pi := pi) ⟶ genusDivisorYoneda (C := C)
  canonicalEvaluationDivisor_abel :
    canonicalEvaluationDivisor ≫ abelDivAffGenusSigma C =
      picRankOneOpenSigmaIncl pi

namespace PicRankOneFibrePresentationInput

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

/-- The public-locus element carried by the restricted family value over `W`. -/
noncomputable def locusValue (F : PicRankOneFibrePresentationInput pi g) :
    rankOneLocus.obj (op (F.W : Scheme.{u})) :=
  ⟨F.restrictedValue.1, ⟨F.restrictedValue.2,
    mem_picRankOneOpen_of_nativePresentations pi
      (fun A _ _ t => F.nativePresentation A t)⟩⟩

/-- The map into the public locus is obtained from its universal element by Yoneda. -/
noncomputable def fst (F : PicRankOneFibrePresentationInput pi g) :
    yoneda.obj (F.W : Scheme.{u}) ⟶ rankOneLocus (C := C) (pi := pi) :=
  yonedaEquiv.symm F.locusValue

/-- The canonical evaluation divisor of the restricted family value over `W`. -/
noncomputable def evaluationDivisor
    (F : PicRankOneFibrePresentationInput pi g) :
    (F.W : Scheme.{u}) ⟶ (divRepAffGenusScheme C).left :=
  F.canonicalEvaluationDivisor.app (op (F.W : Scheme.{u})) F.locusValue

/-- The unresolved geometric factorisation of the canonical evaluation divisor through `W`.

This predicate is deliberately separate from `PicRankOneFibrePresentationInput`: none of the
native-presentation fields proves it. -/
def CanonicalEvaluationDivisorFactors
    (F : PicRankOneFibrePresentationInput pi g) : Prop :=
  ∀ (S : Scheme.{u}) (v : rankOneLocus.obj (op S)) (w : S ⟶ X),
    (abelDivAffGenusSigma C).app (op S)
        (F.canonicalEvaluationDivisor.app (op S) v) =
      g.app (op S) w →
    ∃ u : S ⟶ (F.W : Scheme.{u}),
      u ≫ F.evaluationDivisor =
          F.canonicalEvaluationDivisor.app (op S) v ∧
        u ≫ F.W.ι = w

/-- The factorisation clause required by `PicRankOneOpen.FibrePresented`, exposed without
packaging it into that structure. -/
def FibreFactorizationClause
    (F : PicRankOneFibrePresentationInput pi g) : Prop :=
  ∀ (S : Scheme.{u}) (v : rankOneLocus.obj (op S)) (w : S ⟶ X),
    (picRankOneOpenSigmaIncl pi).app (op S) v =
      g.app (op S) w →
    ∃ u : S ⟶ (F.W : Scheme.{u}),
      F.fst.app (op S) u = v ∧ u ≫ F.W.ι = w

lemma fst_comp_incl (F : PicRankOneFibrePresentationInput pi g) :
    F.fst ≫ picRankOneOpenSigmaIncl pi = yoneda.map F.W.ι ≫ g := by
  apply yonedaEquiv.injective
  change (picRankOneOpenSigmaIncl pi).app (op (F.W : Scheme.{u})) F.locusValue =
    (yoneda.map F.W.ι ≫ g).app (op (F.W : Scheme.{u})) (𝟙 (F.W : Scheme.{u}))
  dsimp [locusValue, picRankOneOpenSigmaIncl,
    CategoryTheory.Over.sigmaExtensionNat]
  rw [← F.restrictedValue_eq]

lemma canonicalEvaluationDivisor_abel_app
    (F : PicRankOneFibrePresentationInput pi g)
    (S : Scheme.{u}) (v : rankOneLocus.obj (op S)) :
    (abelDivAffGenusSigma C).app (op S)
        (F.canonicalEvaluationDivisor.app (op S) v) =
      (picRankOneOpenSigmaIncl pi).app (op S) v := by
  have h := congrArg
    (fun q => q.app (op S) v) F.canonicalEvaluationDivisor_abel
  exact h

/-- The family evaluation divisor has the displayed family as its Abel class. -/
lemma evaluationDivisor_abel
    (F : PicRankOneFibrePresentationInput pi g) :
    yoneda.map F.evaluationDivisor ≫ abelDivAffGenusSigma C =
      yoneda.map F.W.ι ≫ g := by
  have heval :
      yoneda.map F.evaluationDivisor =
        F.fst ≫ F.canonicalEvaluationDivisor := by
    apply yonedaEquiv.injective
    rw [yonedaEquiv_yoneda_map]
    rw [yonedaEquiv_comp]
    have hx := yonedaEquiv_comp
      (yonedaEquiv.symm F.locusValue) F.canonicalEvaluationDivisor
    rw [hx]
    simp [fst]
  rw [heval, Category.assoc, F.canonicalEvaluationDivisor_abel]
  exact F.fst_comp_incl

/-- Once the divisor classifier and its Abel law are fixed, divisor factorisation is exactly the
`FibrePresented.exists_factor` clause.  This equivalence records rather than conceals the hard
geometric obligation. -/
theorem canonicalEvaluationDivisorFactors_iff_fibreFactorizationClause
    (F : PicRankOneFibrePresentationInput pi g) :
    F.CanonicalEvaluationDivisorFactors ↔ F.FibreFactorizationClause := by
  constructor
  · intro hfactor S v w hvw
    have habel :
        (abelDivAffGenusSigma C).app (op S)
            (F.canonicalEvaluationDivisor.app (op S) v) =
          g.app (op S) w := by
      calc
        (abelDivAffGenusSigma C).app (op S)
            (F.canonicalEvaluationDivisor.app (op S) v) =
            (picRankOneOpenSigmaIncl pi).app (op S) v :=
          F.canonicalEvaluationDivisor_abel_app S v
        _ = g.app (op S) w := hvw
    obtain ⟨u, hud, huw⟩ := hfactor S v w habel
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
  · intro hfactor S v w habel
    have hvw :
        (picRankOneOpenSigmaIncl pi).app (op S) v =
          g.app (op S) w := by
      calc
        (picRankOneOpenSigmaIncl pi).app (op S) v =
            (abelDivAffGenusSigma C).app (op S)
              (F.canonicalEvaluationDivisor.app (op S) v) :=
          (F.canonicalEvaluationDivisor_abel_app S v).symm
        _ = g.app (op S) w := habel
    obtain ⟨u, hu, huw⟩ := hfactor S v w hvw
    refine ⟨u, ?_, huw⟩
    have hnat := ConcreteCategory.congr_hom
      (F.canonicalEvaluationDivisor.naturality u.op) F.locusValue
    have htransport :
        F.canonicalEvaluationDivisor.app (op S)
            (F.fst.app (op S) u) =
          u ≫ F.canonicalEvaluationDivisor.app
            (op (F.W : Scheme.{u})) F.locusValue := by
      simpa [fst, yonedaEquiv_symm_app_apply] using hnat
    calc
      u ≫ F.evaluationDivisor =
          F.canonicalEvaluationDivisor.app (op S)
            (F.fst.app (op S) u) := htransport.symm
      _ = F.canonicalEvaluationDivisor.app (op S) v := congrArg _ hu

/-! ## Assembly of the stronger fibre datum -/

/--
Assemble the public fibre presentation from the native family and the canonical evaluation divisor.

The divisor factorisation is a visible argument, and the preceding equivalence converts it to
the exact public-locus clause.  The resulting pullback statement is therefore conditional on
that unresolved geometric input.
-/
noncomputable def toFibrePresented
    (F : PicRankOneFibrePresentationInput pi g)
    (hfactor : F.CanonicalEvaluationDivisorFactors) :
    PicRankOneOpen.FibrePresented pi g where
  W := F.W
  fst := F.fst
  sq := F.fst_comp_incl
  exists_factor := by
    simpa only [FibreFactorizationClause] using
      (F.canonicalEvaluationDivisorFactors_iff_fibreFactorizationClause.mp hfactor)

@[simp]
lemma toFibrePresented_W
    (F : PicRankOneFibrePresentationInput pi g)
    (hfactor : F.CanonicalEvaluationDivisorFactors) :
    (F.toFibrePresented hfactor).W = F.W :=
  rfl

lemma toFibrePresented_isPullback
    (F : PicRankOneFibrePresentationInput pi g)
    (hfactor : F.CanonicalEvaluationDivisorFactors) :
    IsPullback F.fst (yoneda.map F.W.ι) (picRankOneOpenSigmaIncl pi) g :=
  (F.toFibrePresented hfactor).isPullback

/-! ## Immediate openness consumer -/

theorem picRankOneOpen_isOpen_of_nativePresentations_and_divisorFactorization
    (D : ∀ (X : Scheme.{u})
      (g : yoneda.obj X ⟶ rankOneAmbient (C := C)),
      PicRankOneFibrePresentationInput pi g)
    (hfactor : ∀ (X : Scheme.{u})
      (g : yoneda.obj X ⟶ rankOneAmbient (C := C)),
      (D X g).CanonicalEvaluationDivisorFactors) :
    PicRankOneOpen.IsOpen pi := by
  apply picRankOneOpen_isOpen_of_fibrePresented pi
  intro X g
  exact (D X g).toFibrePresented (hfactor X g)

end PicRankOneFibrePresentationInput

end
end AlgebraicGeometry
