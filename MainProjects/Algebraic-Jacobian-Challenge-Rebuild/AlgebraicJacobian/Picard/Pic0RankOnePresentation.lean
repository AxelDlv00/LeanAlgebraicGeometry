/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Cohomology.ModulesBaseSheaf
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
* the cohomological rank-one outputs used by the evaluation construction.

No existence, openness, or representability assertion is made here.  The first canonical
consumer is `PicRankOneLocalPresentation.evaluation`, the pullback-pushforward counit.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits TopologicalSpace Opposite MonoidalCategory CartesianMonoidalCategory

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
  h1_vanishing : Subsingleton (Sheaf.HModule datum.sheaf 1)
  h0_finite : Module.Finite cover.Carrier (Sheaf.HModule datum.sheaf 0)
  h0_projective : Module.Projective cover.Carrier (Sheaf.HModule datum.sheaf 0)
  h0_rank_one :
    ∀ p : PrimeSpectrum cover.Carrier,
      Module.rankAtStalk (Sheaf.HModule datum.sheaf 0) p = 1

namespace PicRankOneLocalPresentation

variable {pi} {lam : picDegLayer C (genus C : ℤ) (overSpec k A)}

/-- The canonical evaluation map attached to a tied local rank-one presentation. -/
noncomputable def evaluation (P : PicRankOneLocalPresentation pi lam) :
    (Scheme.Modules.pullback
      (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj
        ((Scheme.Modules.pushforward
          (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).obj P.module) ⟶
      P.module :=
  (Scheme.Modules.pullbackPushforwardAdjunction
    (relCurve C P.cover.Carrier ↘ Spec (.of P.cover.Carrier))).counit.app P.module

end PicRankOneLocalPresentation

end AlgebraicGeometry
