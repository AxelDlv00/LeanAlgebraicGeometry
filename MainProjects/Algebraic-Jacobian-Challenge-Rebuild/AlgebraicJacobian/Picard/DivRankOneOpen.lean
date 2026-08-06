/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.Pic0RankOneLocus
import Mathlib.AlgebraicGeometry.Restrict

/-!
# The universal divisor rank-one open contract

The genus divisor representer is unconditional, while the rank-one restriction still needs a
family-level open-locus producer.  This file separates those two facts.  The predicate below is
the inverse image of `PicRankOneOpen` along the represented universal Abel map.  A
`DivRankOneOpenData` witness identifies that predicate with the range of one actual open of the
representer; only after that witness is supplied do we define the open subscheme.

This shape prevents a logical `Subfunctor` from being silently reinterpreted as a scheme.  It also
gives the canonical inverse lane a stable contract: it consumes the witness equality and can use
the resulting open inclusion and all of its pullbacks without choosing a generator.
-/

set_option autoImplicit false
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory Limits Opposite

namespace AlgebraicGeometry

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable [SmoothOfRelativeDimension 1 C.hom] [IsProper C.hom]
  [GeometricallyIrreducible C.hom]
variable (pi : C.left ⟶ P1 k) [IsFinite pi]

noncomputable section

/-- The universal genus-divisor predicate whose Abel class lies in `PicRankOneOpen`. -/
def divRankOneUniversalPredicate :
    Subfunctor (yoneda.obj (divRepAffGenusScheme C)) :=
  divRankOnePresentationPreimageRepresenter pi

/-- The Yoneda map induced by the inclusion of an open of an object in the slice.  Naming this
map is useful to consumers which need the actual factorisation through the open, rather than only
the proposition that a point lies in its range. -/
def openSubfunctorMap (D : Over (Spec (.of k))) (U : D.left.Opens) :
    yoneda.obj (Over.mk (U.ι ≫ D.hom)) ⟶ yoneda.obj D :=
  yoneda.map (Over.homMk (U := Over.mk (U.ι ≫ D.hom)) U.ι)

/-- The subfunctor represented by an open `U` of an object `D` in the slice over `Spec k`.

Its values are precisely morphisms which factor through the open immersion `U.ι`; using the
Yoneda range keeps this definition independent of any chosen affine presentation of `U`. -/
def openSubfunctor (D : Over (Spec (.of k))) (U : D.left.Opens) :
    Subfunctor (yoneda.obj D) :=
  Subfunctor.range (openSubfunctorMap D U)

/-- Unpack range membership into the actual source point and its equality in the ambient Yoneda
functor.  This is the pointwise factorisation API used by inverse constructions. -/
theorem openSubfunctor_mem_iff
    (D : Over (Spec (.of k))) (U : D.left.Opens)
    {T : (Over (Spec (.of k)))ᵒᵖ}
    (x : (yoneda.obj D).obj T) :
    x ∈ (openSubfunctor D U).obj T ↔
      ∃ y : (yoneda.obj (Over.mk (U.ι ≫ D.hom))).obj T,
        (openSubfunctorMap D U).app T y = x := by
  rfl

/-- An explicit geometric certificate for the universal rank-one predicate.

The equality is the missing family-level producer/gluing statement: it identifies the logical
preimage with an actual open of the canonical genus representer.  No default or top-open witness
is manufactured here. -/
structure DivRankOneOpenData (pi : C.left ⟶ P1 k) [IsFinite pi] where
  carrier : (divRepAffGenusScheme C).left.Opens
  carrier_eq :
    openSubfunctor (divRepAffGenusScheme C) carrier =
      divRankOneUniversalPredicate pi

/-- The open subscheme supplied by a `DivRankOneOpenData` witness. -/
def DivRankOneOpen (h : DivRankOneOpenData (C := C) pi) : Scheme :=
  h.carrier.toScheme

/-- The canonical open immersion into the genus divisor representer. -/
def divRankOneOpenMap (h : DivRankOneOpenData (C := C) pi) :
    DivRankOneOpen pi h ⟶ (divRepAffGenusScheme C).left :=
  h.carrier.ι

theorem divRankOneOpen_isOpenImmersion
    (h : DivRankOneOpenData (C := C) pi) :
    IsOpenImmersion (divRankOneOpenMap pi h) := by
  change IsOpenImmersion h.carrier.ι
  infer_instance

/-- The open represented object, retained in the slice over `Spec k` for consumers of the affine
divisor functor. -/
def divRankOneOpenOver (h : DivRankOneOpenData (C := C) pi) :
    Over (Spec (.of k)) :=
  Over.mk (divRankOneOpenMap pi h ≫ (divRepAffGenusScheme C).hom)

/-- The inclusion of the certified open, as a morphism in the slice over `Spec k`.

This is the map whose Yoneda action is consumed by the canonical rank-one Abel inverse.  Naming
it separately keeps consumers independent of the implementation spelling of `divRankOneOpenOver`.
-/
def divRankOneOpenOverMap (h : DivRankOneOpenData (C := C) pi) :
    divRankOneOpenOver pi h ⟶ divRepAffGenusScheme C :=
  Over.homMk (divRankOneOpenMap pi h)

/-- Pull back the certified rank-one open along an arbitrary slice morphism. -/
def divRankOneOpenPullback
    (h : DivRankOneOpenData (C := C) pi)
    {T : Over (Spec (.of k))} (q : T ⟶ divRepAffGenusScheme C) : T.left.Opens :=
  q.left ⁻¹ᵁ h.carrier

theorem divRankOneOpenPullback_isOpenImmersion
    (h : DivRankOneOpenData (C := C) pi)
    {T : Over (Spec (.of k))} (q : T ⟶ divRepAffGenusScheme C) :
    IsOpenImmersion (divRankOneOpenPullback pi h q).ι := by
  infer_instance

/-- Pointwise form of arbitrary base-change compatibility for the certified open. -/
theorem mem_divRankOneOpenPullback_iff
    (h : DivRankOneOpenData (C := C) pi)
    {T : Over (Spec (.of k))} (q : T ⟶ divRepAffGenusScheme C)
    (x : T.left) :
    x ∈ divRankOneOpenPullback pi h q ↔ q.left.base x ∈ h.carrier := by
  rfl

/-- The universal predicate is exactly the represented preimage used by the Abel restriction. -/
theorem divRankOneUniversalPredicate_eq_preimage :
    divRankOneUniversalPredicate pi = divRankOnePresentationPreimageRepresenter pi :=
  rfl

/-- The certified open carrier has the universal rank-one predicate as its Yoneda range. -/
theorem divRankOneOpen_carrier_eq
    (h : DivRankOneOpenData (C := C) pi) :
    openSubfunctor (divRepAffGenusScheme C) h.carrier =
      divRankOneUniversalPredicate pi :=
  h.carrier_eq

/-- Pointwise form of the witness equality, exposing the exact contract consumed by an inverse.

The right-hand side is the range of the open immersion, so a consumer can use this theorem to
replace a rank-one predicate proof by a factorisation through `DivRankOneOpen pi h`. -/
theorem divRankOneOpen_mem_iff
    (h : DivRankOneOpenData (C := C) pi)
    {T : (Over (Spec (.of k)))ᵒᵖ}
    (x : (yoneda.obj (divRepAffGenusScheme C)).obj T) :
    x ∈ (divRankOneUniversalPredicate pi).obj T ↔
      x ∈ (openSubfunctor (divRepAffGenusScheme C) h.carrier).obj T := by
  rw [h.carrier_eq]

/-- A point of the universal rank-one predicate factors through the certified open immersion.

Unlike a bare range-membership proof, the conclusion exposes the source point and the equality
of its image with the given divisor point, which is the exact data needed by a canonical inverse. -/
theorem divRankOneOpen_mem_iff_factorization
    (h : DivRankOneOpenData (C := C) pi)
    {T : (Over (Spec (.of k)))ᵒᵖ}
    (x : (yoneda.obj (divRepAffGenusScheme C)).obj T) :
    x ∈ (divRankOneUniversalPredicate pi).obj T ↔
      ∃ y : (yoneda.obj (Over.mk
          (h.carrier.ι ≫ (divRepAffGenusScheme C).hom))).obj T,
        (openSubfunctorMap (divRepAffGenusScheme C) h.carrier).app T y = x := by
  rw [divRankOneOpen_mem_iff pi h x, openSubfunctor_mem_iff]

/-- The same factorisation contract with the named open object and slice inclusion.

The source in the preceding theorem is definitionally the slice object
`divRankOneOpenOver pi h`; this corollary gives the stable public names expected by inverse
consumers. -/
theorem divRankOneOpen_mem_iff_factorization_over
    (h : DivRankOneOpenData (C := C) pi)
    {T : (Over (Spec (.of k)))ᵒᵖ}
    (x : (yoneda.obj (divRepAffGenusScheme C)).obj T) :
    x ∈ (divRankOneUniversalPredicate pi).obj T ↔
      ∃ y : (yoneda.obj (divRankOneOpenOver pi h)).obj T,
        (yoneda.map (divRankOneOpenOverMap pi h)).app T y = x := by
  rw [divRankOneOpen_mem_iff_factorization pi h x]
  rfl

/-- A point in the certified open carrier is a point of the universal rank-one predicate. -/
theorem divRankOneOpen_mem_of_carrier
    (h : DivRankOneOpenData (C := C) pi)
    {T : (Over (Spec (.of k)))ᵒᵖ}
    {x : (yoneda.obj (divRepAffGenusScheme C)).obj T}
    (hx : x ∈ (openSubfunctor (divRepAffGenusScheme C) h.carrier).obj T) :
    x ∈ (divRankOneUniversalPredicate pi).obj T := by
  exact (divRankOneOpen_mem_iff pi h x).mpr hx

/- The logical rank-one predicate remains stable under arbitrary pullback, independently of the
   geometric witness used to represent it by an open. -/
theorem divRankOneOpen_baseChange_mem
    {T T' : (Over (Spec (.of k)))ᵒᵖ}
    (f : T ⟶ T')
    {x : (yoneda.obj (divRepAffGenusScheme C)).obj T}
    (hx : x ∈ (divRankOneUniversalPredicate pi).obj T) :
    (yoneda.obj (divRepAffGenusScheme C)).map f x ∈
      (divRankOneUniversalPredicate pi).obj T' :=
  (divRankOneUniversalPredicate pi).map f hx

end

end AlgebraicGeometry
