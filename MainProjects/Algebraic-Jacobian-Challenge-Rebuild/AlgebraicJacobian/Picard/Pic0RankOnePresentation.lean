/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.ModulesBaseSheaf
import AlgebraicJacobian.Cohomology.ModulesPushforwardBaseChange
import AlgebraicJacobian.Cohomology.GluedSheafH0BaseChange
import AlgebraicJacobian.Picard.Pic0EndgameContract
import AlgebraicJacobian.Picard.Pic0RingDatumEngine

/-!
# The local-presentation contract for the rank-one Picard locus

An element of `picDegLayerFunctor` is an etale-plus class, not a chosen line bundle.  The
rank-one route therefore needs an explicit local presentation before it can use the evaluation
map of a line bundle.  `PicRankOneLocalPresentation` records that presentation on an affine
test and ties every piece of data to the input class:

* a descent-class representative whose plus class is the affine collapse of the input;
* a cocycle datum presenting that same relative Picard class;
* a locally free rank-one `Scheme.Modules` object whose base-ring sheaf is the datum's sheaf;
* invertibility of the canonical native pushforward base-change mate on every cartesian square;
* the cohomological rank-one outputs used by the evaluation construction.

No existence, openness, or representability assertion is made here.  The first canonical
consumer is `PicRankOneLocalPresentation.evaluation`, the pullback-pushforward counit.
The method `PicRankOneLocalPresentation.h0BaseChange` derives arbitrary affine base change
from the same presentation's `H^1`-vanishing field.  The section bridge at the end identifies
datum `H^0` with native global sections and proves, by the adjunction triangle identity, that
the evaluation counit sends the canonical unit-lift back to that same section.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory CartesianMonoidalCategory

open scoped TensorProduct

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra
attribute [local instance 10000] relCurve.instOver

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable {A : Type u} [CommRing A] [Algebra k A]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

/-- A rank-one presentation of a genus-degree plus class on an affine test.

The two equality fields prevent an unrelated cocycle datum or line bundle from serving as a
witness: `representative` presents the input plus class, `datum_class` presents that same
relative Picard class, and `module_iso` identifies the resulting cocycle sheaf with the
underlying base-ring sheaf of `module`. -/
structure PicRankOneLocalPresentation
    (lam : picDegLayer C (genus C : ℤ) (overSpec k A)) : Type (u + 1) where
  cover : Algebra.EtaleCover A
  representative : descentClasses C cover
  represents :
    PicEtAff.mk C cover representative = picEtAffineEquiv C A lam.1
  datum : BasicOpenCocycleDatum C cover.Carrier pi
  datum_class :
    (representative : relPic C (overSpec k cover.Carrier)) =
      relPicMk C (overSpec k cover.Carrier) datum.cechPicClass
  module : (relCurve C cover.Carrier).Modules
  module_iso :
    Scheme.toModuleKSheafOfModules
      (Over.mk (relCurve C cover.Carrier ↘ Spec (.of cover.Carrier))) module ≅ datum.sheaf
  line_bundle : Scheme.Modules.IsLineBundle module
  native_pushforward_base_change :
    ∀ {T' X' : Scheme.{u}}
      (g : T' ⟶ Spec (.of cover.Carrier)) (f' : X' ⟶ T')
      (g' : X' ⟶ relCurve C cover.Carrier)
      (sq : IsPullback g' f'
        (relCurve C cover.Carrier ↘ Spec (.of cover.Carrier)) g),
      IsIso ((canonicalBaseChangeMap sq).app module)
  h1_vanishing : Subsingleton (Sheaf.HModule datum.sheaf 1)
  h0_finite : Module.Finite cover.Carrier (Sheaf.HModule datum.sheaf 0)
  h0_projective : Module.Projective cover.Carrier (Sheaf.HModule datum.sheaf 0)
  h0_rank_one :
    ∀ p : PrimeSpectrum cover.Carrier,
      Module.rankAtStalk (Sheaf.HModule datum.sheaf 0) p = 1

namespace PicRankOneLocalPresentation

variable {pi} {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}

noncomputable local instance presentationModuleSections
    (P : PicRankOneLocalPresentation pi lam) (U : (relCurve C P.cover.Carrier).Opens) :
    Module P.cover.Carrier Γ(P.module, U) :=
  Scheme.moduleKSections
    (Over.mk (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))) P.module U

/-- The canonical `H^0` base-change equivalence attached to a rank-one presentation.

This is derived from `P.h1_vanishing`; it is not an independently chosen witness. -/
noncomputable def h0BaseChange (P : PicRankOneLocalPresentation pi lam)
    (B : Type u) [CommRing B] [Algebra k B] [Algebra P.cover.Carrier B]
    [IsScalarTower k P.cover.Carrier B] :
    B ⊗[P.cover.Carrier] (Sheaf.HModule P.datum.sheaf 0) ≃ₗ[B]
      Sheaf.HModule (P.datum.baseChange B).sheaf 0 :=
  P.datum.datumH0BaseChange B
    ((subsingleton_datumPair_h1_iff P.datum).mpr P.h1_vanishing)

/-- The canonical evaluation map attached to a tied local rank-one presentation. -/
noncomputable def evaluation (P : PicRankOneLocalPresentation pi lam) :
    (Scheme.Modules.pullback
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) ⟶
      P.module :=
  (Scheme.Modules.pullbackPushforwardAdjunction
    (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).counit.app P.module

/-! ## Native pushforward base change and evaluation coherence -/

/-- The canonical native pushforward base-change isomorphism supplied by the presentation.

The isomorphism is not chosen independently: its hom is definitionally
`(canonicalBaseChangeMap sq).app P.module`. -/
noncomputable def nativeBaseChangeIso (P : PicRankOneLocalPresentation pi lam)
    {T' X' : Scheme.{u}}
    (g : T' ⟶ Spec (.of P.cover.Carrier)) (f' : X' ⟶ T')
    (g' : X' ⟶ relCurve C P.cover.Carrier)
    (sq : IsPullback g' f'
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) g) :
    (Scheme.Modules.pullback g).obj
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) ≅
      (Scheme.Modules.pushforward f').obj ((Scheme.Modules.pullback g').obj P.module) := by
  exact @asIso _ _ _ _ ((canonicalBaseChangeMap sq).app P.module)
    (P.native_pushforward_base_change g f' g' sq)

/-- The native pushforward base-change isomorphism for an affine coefficient extension. -/
noncomputable def nativeBaseChangeIsoAffine (P : PicRankOneLocalPresentation pi lam)
    (B : Type u) [CommRing B] [Algebra k B] [Algebra P.cover.Carrier B]
    [IsScalarTower k P.cover.Carrier B] :
    (Scheme.Modules.pullback
      (Spec.map (CommRingCat.ofHom (algebraMap P.cover.Carrier B)))).obj
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) ≅
      (Scheme.Modules.pushforward
        (relCurve C B ↘ Spec (.of B))).obj
          ((Scheme.Modules.pullback (relCurveMap C P.cover.Carrier B)).obj P.module) :=
  P.nativeBaseChangeIso
    (overSpecMap (k := k) P.cover.Carrier B).left
    (snd C (overSpec k B)).left
    (relCurveMap C P.cover.Carrier B)
    (Over.isPullback_whiskerLeft C (overSpecMap (k := k) P.cover.Carrier B))

/-- The source of evaluation identifies canonically with the source of evaluation after any
cartesian base change. -/
noncomputable def evaluationSourceBaseChangeIso (P : PicRankOneLocalPresentation pi lam)
    {T' X' : Scheme.{u}}
    (g : T' ⟶ Spec (.of P.cover.Carrier)) (f' : X' ⟶ T')
    (g' : X' ⟶ relCurve C P.cover.Carrier)
    (sq : IsPullback g' f'
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) g) :
    (Scheme.Modules.pullback
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⋙
      Scheme.Modules.pullback g').obj
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) ≅
      (Scheme.Modules.pushforward f' ⋙ Scheme.Modules.pullback f').obj
        ((Scheme.Modules.pullback g').obj P.module) :=
  ((((Scheme.Modules.pullbackComp f' g) ≪≫
    Scheme.Modules.pullbackCongr sq.w.symm ≪≫
    (Scheme.Modules.pullbackComp g'
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).symm).app
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module)).symm) ≪≫
    (Scheme.Modules.pullback f').mapIso (P.nativeBaseChangeIso g f' g' sq)

/-- Under the source identification, evaluation after base change is the pullback of the
presentation's original evaluation counit. -/
theorem evaluationSourceBaseChangeIso_hom_evaluation
    (P : PicRankOneLocalPresentation pi lam)
    {T' X' : Scheme.{u}}
    (g : T' ⟶ Spec (.of P.cover.Carrier)) (f' : X' ⟶ T')
    (g' : X' ⟶ relCurve C P.cover.Carrier)
    (sq : IsPullback g' f'
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) g) :
    (P.evaluationSourceBaseChangeIso g f' g' sq).hom ≫
        (Scheme.Modules.pullbackPushforwardAdjunction f').counit.app
          ((Scheme.Modules.pullback g').obj P.module) =
      (Scheme.Modules.pullback g').map P.evaluation := by
  change ((((Scheme.Modules.pullbackComp f' g) ≪≫
      Scheme.Modules.pullbackCongr sq.w.symm ≪≫
      (Scheme.Modules.pullbackComp g'
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).symm).inv).app
          ((Scheme.Modules.pushforward
            (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module)) ≫
    ((Scheme.Modules.pullback f').map ((canonicalBaseChangeMap sq).app P.module) ≫
      (Scheme.Modules.pullbackPushforwardAdjunction f').counit.app
        ((Scheme.Modules.pullback g').obj P.module)) =
    (Scheme.Modules.pullback g').map
      ((Scheme.Modules.pullbackPushforwardAdjunction
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).counit.app P.module)
  exact canonicalBaseChangeMap_counit_cancel sq P.module

/-! ## The datum/native-section/evaluation bridge -/

/-- The global datum section represented by a degree-zero cohomology class. -/
noncomputable def datumSection (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    P.datum.sheaf.obj.obj (op (⊤ : (relCurve C P.cover.Carrier).Opens)) :=
  Sheaf.HModule.linearEquiv₀
    (Opens.grothendieckTopology ((relCurve C P.cover.Carrier : Scheme.{u}) : TopCat))
    isTerminalTop P.datum.sheaf y

/-- The presentation identifies datum `H^0` with native global sections of its line bundle. -/
noncomputable def moduleSectionsEquiv (P : PicRankOneLocalPresentation pi lam) :
    Sheaf.HModule P.datum.sheaf 0 ≃ₗ[P.cover.Carrier] Γ(P.module, ⊤) :=
  (Sheaf.HModule.mapEquiv P.module_iso.symm 0).trans
    (Sheaf.HModule.linearEquiv₀
      (Opens.grothendieckTopology ((relCurve C P.cover.Carrier : Scheme.{u}) : TopCat))
      isTerminalTop
      (Scheme.toModuleKSheafOfModules
        (Over.mk (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))) P.module))

/-- The native section is exactly the datum section transported through `module_iso`. -/
theorem module_iso_inv_datumSection (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    (P.module_iso.inv.hom.app (op (⊤ : (relCurve C P.cover.Carrier).Opens))).hom
      (P.datumSection y) = P.moduleSectionsEquiv y := by
  exact Sheaf.HModule.linearEquiv₀_naturality
    (hT := isTerminalTop) (f := P.module_iso.inv) y

/-- A datum `H^0` class, read as a global section of the native pushforward. -/
noncomputable def pushforwardSectionOfH0 (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    Γ((Scheme.Modules.pushforward
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module, ⊤) := by
  change Γ(P.module,
    (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⁻¹ᵁ
      (⊤ : (Spec (.of P.cover.Carrier)).Opens))
  simpa using P.moduleSectionsEquiv y

/-- The canonical unit-lift of a datum `H^0` class to the source of evaluation. -/
noncomputable def evaluationLiftOfH0 (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    Γ((Scheme.Modules.pullback
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module),
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⁻¹ᵁ
        (⊤ : (Spec (.of P.cover.Carrier)).Opens)) :=
  ((Scheme.Modules.pullbackPushforwardAdjunction
    (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).unit.app
      ((Scheme.Modules.pushforward
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module)).app
          (⊤ : (Spec (.of P.cover.Carrier)).Opens) (P.pushforwardSectionOfH0 y)

/-- Evaluation of the canonical unit-lift returns the original native global section.

This is the right triangle identity of pullback-pushforward.  It is the counit compatibility
needed before the section can be used to define a divisor; no zero-locus claim is made here. -/
theorem evaluation_evaluationLiftOfH0 (P : PicRankOneLocalPresentation pi lam)
    (y : Sheaf.HModule P.datum.sheaf 0) :
    (Scheme.Modules.Hom.app P.evaluation
      ((relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier)) ⁻¹ᵁ
        (⊤ : (Spec (.of P.cover.Carrier)).Opens))).hom
      (P.evaluationLiftOfH0 y) = P.pushforwardSectionOfH0 y := by
  have h := congrArg
    (fun (f : (Scheme.Modules.pushforward
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module ⟶
      (Scheme.Modules.pushforward
        (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) =>
      (Scheme.Modules.Hom.app f (⊤ : (Spec (.of P.cover.Carrier)).Opens)).hom
        (P.pushforwardSectionOfH0 y))
    ((Scheme.Modules.pullbackPushforwardAdjunction
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).right_triangle_components
        P.module)
  exact h

end PicRankOneLocalPresentation

end AlgebraicGeometry
