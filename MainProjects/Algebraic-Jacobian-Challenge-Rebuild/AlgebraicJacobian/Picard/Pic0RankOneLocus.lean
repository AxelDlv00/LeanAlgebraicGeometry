/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOnePresentation
import Mathlib.CategoryTheory.Subfunctor.Image

/-!
# The presentation locus for the rank-one Abel map

`PicRankOneOpen` is the functorial locus in the degree-`genus C` Picard layer whose pullback to
every affine test admits a tied `PicRankOneLocalPresentation`.  Quantifying after every affine
pullback makes the condition intrinsic on arbitrary test schemes; stability under further
pullback is exactly `picEtMap_comp`.

The remaining declarations form the corresponding preimages in the widened divisor functor and
in its canonical representing Yoneda functor, together with the restricted Abel transformations.
These are logical subfunctors only.  In particular, this file does not prove that
`PicRankOneOpen` is represented by an open subscheme, and it reserves `DivRankOneOpen` for the
future actual open subscheme of the divisor representer.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite MonoidalCategory CartesianMonoidalCategory

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable section

/-- The rank-one presentation locus in the degree-`genus C` Picard layer.

Membership means that every affine pullback of the input plus class admits a local presentation
tied to that pullback.  This is the correct logical subfunctor underlying the future open Picard
locus; no openness or representability assertion is part of this definition. -/
def PicRankOneOpen :
    Subfunctor (picDegLayerFunctor C (genus C : ℤ)) where
  obj T := {lam | ∀ (A : Type u) [CommRing A] [Algebra k A]
      (t : overSpec k A ⟶ T.unop),
    Nonempty (PicRankOneLocalPresentation pi
      ((picDegLayerFunctor C (genus C : ℤ)).map t.op lam))}
  map {T T'} f lam hlam A _ _ t := by
    let F := picDegLayerFunctor C (genus C : ℤ)
    have e : F.map t.op (F.map f lam) = F.map (t ≫ f.unop).op lam := by
      apply Subtype.ext
      exact (picEtMap_comp C f.unop t lam.1).symm
      rw [e]
      exact hlam A (t ≫ f.unop)

/-! ## The public membership contract -/

/-- Unfolded membership in `PicRankOneOpen`, with the presentation tied to the pulled-back
Picard class.  Keeping this predicate named is important for producers in later lanes: a
field-level divisor or chart witness is not a substitute for this arbitrary-affine-pullback
contract. -/
theorem mem_picRankOneOpen_iff {T : (Over (Spec (.of k)))ᵒᵖ}
    (lam : (picDegLayerFunctor C (genus C : ℤ)).obj T) :
    lam ∈ (PicRankOneOpen pi).obj T ↔
      ∀ (A : Type u) [CommRing A] [Algebra k A]
        (t : overSpec k A ⟶ T.unop),
        Nonempty (PicRankOneLocalPresentation pi
          ((picDegLayerFunctor C (genus C : ℤ)).map t.op lam)) := by
  rfl

/-- Constructor for the exact lambda-tied arbitrary-affine-pullback presentation contract. -/
theorem mem_picRankOneOpen_of_localPresentations
    {T : (Over (Spec (.of k)))ᵒᵖ}
    {lam : (picDegLayerFunctor C (genus C : ℤ)).obj T}
    (h : ∀ (A : Type u) [CommRing A] [Algebra k A]
        (t : overSpec k A ⟶ T.unop),
        Nonempty (PicRankOneLocalPresentation pi
          ((picDegLayerFunctor C (genus C : ℤ)).map t.op lam))) :
    lam ∈ (PicRankOneOpen pi).obj T :=
  (mem_picRankOneOpen_iff pi lam).mpr h

/-- Pullback stability of the public rank-one locus, exposed independently of its definition. -/
theorem picRankOneOpen_map_mem {T T' : (Over (Spec (.of k)))ᵒᵖ}
    (f : T ⟶ T') {lam : (picDegLayerFunctor C (genus C : ℤ)).obj T}
    (h : lam ∈ (PicRankOneOpen pi).obj T) :
    (picDegLayerFunctor C (genus C : ℤ)).map f lam ∈ (PicRankOneOpen pi).obj T' :=
  (PicRankOneOpen pi).map f h

/-- The inverse image of `PicRankOneOpen` under the affine widened Abel transformation.

This name deliberately records only a presentation-theoretic preimage.  It is not the future
open subscheme `DivRankOneOpen`. -/
def divRankOnePresentationPreimageAff :
    Subfunctor (divFunctorAff C (genus C)) :=
  (PicRankOneOpen pi).preimage (abelDivAffTrans C (genus C))

/-- The same presentation preimage on the Yoneda functor of the canonical genus divisor
representer. -/
def divRankOnePresentationPreimageRepresenter :
    Subfunctor (yoneda.obj (divRepAffGenusScheme C)) :=
  (divRankOnePresentationPreimageAff pi).preimage
    (divFunctorAff_genus_representableBy C).toIso.hom

/-- The affine Abel transformation restricted to the rank-one presentation preimage. -/
def rankOneAbelAff :
    (divRankOnePresentationPreimageAff pi).toFunctor ⟶
      (PicRankOneOpen pi).toFunctor :=
  (PicRankOneOpen pi).fromPreimage (abelDivAffTrans C (genus C))

/-- Restrict the canonical representation isomorphism to the rank-one presentation preimage. -/
def rankOneRepresenterRestriction :
    (divRankOnePresentationPreimageRepresenter pi).toFunctor ⟶
      (divRankOnePresentationPreimageAff pi).toFunctor :=
  (divRankOnePresentationPreimageAff pi).fromPreimage
    (divFunctorAff_genus_representableBy C).toIso.hom

/-- The represented genus Abel map restricted to the rank-one presentation preimage. -/
def rankOneAbelRepresented :
    (divRankOnePresentationPreimageRepresenter pi).toFunctor ⟶
      (PicRankOneOpen pi).toFunctor :=
  rankOneRepresenterRestriction pi ≫ rankOneAbelAff pi

/-- Immediate consumer theorem: the restricted represented Abel map lands in the public locus.
The stronger canonical inverse still needs the family-level divisor/evaluation producer; this
theorem records the exact target API that consumer lanes can use today. -/
theorem rankOneAbelRepresented_mem {T : (Over (Spec (.of k)))ᵒᵖ}
    (x : (divRankOnePresentationPreimageRepresenter pi).obj T) :
    ((rankOneAbelRepresented pi).app T x :
      (picDegLayerFunctor C (genus C : ℤ)).obj T) ∈ (PicRankOneOpen pi).obj T :=
  ((rankOneAbelRepresented pi).app T x).property

end

end AlgebraicGeometry
