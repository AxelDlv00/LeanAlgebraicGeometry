/-
Copyright (c) 2026 The AlgebraicJacobian authors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: The AlgebraicJacobian Contributors
-/
import AlgebraicJacobian.Picard.DivisorFamilyAffTheta

/-!
# A TWISTING DATUM THAT DOES NOT CONFINE THE PIECES

`Picard/DivisorFamilyAffTheta.lean` builds the Θ-layer over a widened cover, and its own
`isEmpty_chartTyping_of_straddling` proves that every declaration in it is **vacuous on the
covers protection `I-0492` exists for**: the layer is indexed by a `ChartTyping`, whose field
`piece_le` puts each piece inside one of a FIXED PAIR of pinned `P¹` charts, and a piece
holding a point off `V₀` and a point off `V₁` admits no such assignment.

That is not a repairable detail of the Θ-layer; it is the fixed-pair typing re-entering
through an index, which `I-0492` clause 3 names as the pattern to avoid ("do not smuggle the
old typing back in by typing pieces INTO the charts").  This file removes it.

## The distinction the old index conflates

`relThetaSections` (`Picard/DivisorFamilyTheta.lean:59`) models `𝒪(Θᵃ)` as **pairs of
sections on `V₀`, `V₁` matching through the theta cocycle**.  That is a two-chart model of the
LINE BUNDLE, and it is not a constraint on any divisor: it is how this project spells the
sheaf, for every family, straddling or not.

`ChartTyping` is a different thing wearing the same clothes: it constrains **the divisor's own
pieces** to sit inside those charts.  Only the second is the refuted fixed-pair confinement
(ADDENDUM 3 §2, roadmap leaf `…joint-cover`, rejected).  The Θ-layer needs the first and was
given the second, and the second is what empties it.

## What the layer actually consumes

Four things, and none of them says where a piece lives:

* a per-piece **reading** `read j : H⁰(𝒪(Θᵃ)) → Γ(pieces j)` — a local trivialization of the
  twist over the piece, which is what `relThetaResSide` *is* when the piece happens to lie in
  a chart;
* a per-pair **comparison unit** `unit i j` on the overlap;
* the **matching law** relating the two through that unit — the only input of
  `thetaEval_mem`;
* a **germ law** tying the reading to the two chart components up to a unit of the stalk,
  which is what the kernel bridge runs on.

`ThetaTrivData` below packages exactly those.  It mentions `relPinnedChart` — the twist's own
model — and it says **nothing** about `pieces j ≤ anything`.

## What this buys, proved rather than asserted

* `ChartTyping.thetaTrivData` — the old index maps in, so nothing landed is lost and the
  chart-typed layer is the special case it always was.
* `thetaTrivData_zero` — **`ThetaTrivData D 0` is inhabited for EVERY widened cover**,
  straddling ones included, by gluing the two chart components over the piece (the sheaf
  axiom for `V₀ ⊔ V₁ = ⊤`, applied to the piece — not a confinement of the piece, which is
  covered by the two charts rather than contained in one).
* `nonempty_thetaTrivData_and_isEmpty_chartTyping` — **the separation**: on a straddling
  cover the new index is inhabited while `ChartTyping` is empty.  So this is a strictly wider
  index, on exactly the covers `I-0492` is about, and the exponent it is proved at is the one
  `DivisorAdaptation.divisorDatum` runs at (`thetaIdealUnit_zero`,
  `Picard/DivisorDatumInverse.lean:207`) — not a vacuous corner.

## What it does NOT buy, stated plainly

Inhabitation at `a > 0` needs `𝒪(Θᵃ)` to be trivial over each piece, which for an arbitrary
affine open is a condition on the bundle (a class in `Pic` of the piece), **not** free.  This
file makes that a hypothesis about the SHEAF that a producer may discharge per cover, in place
of an index that no straddling cover can inhabit at all.  The `a > 0` producer is not here and
is not claimed.
-/

set_option autoImplicit false
set_option backward.isDefEq.respectTransparency false
/- `lake env lean` drops the lakefile's `[leanOptions]` (I-0161), so the pinned synthesis
depth must be set in-file for the faithful per-file check. -/
set_option maxSynthPendingDepth 3

universe u

open CategoryTheory TopologicalSpace Opposite

namespace AlgebraicGeometry

attribute [local instance] Scheme.overModule Scheme.overSectionsAlgebra

variable {k : Type u} [Field k] {C : Over (Spec (.of k))}
variable {R : Type u} [CommRing R] [Algebra k R]
variable {π : C.left ⟶ P1 k} [IsFinite π]

/-! ## The chart-free twisting datum -/

/-- **A twisting datum for a widened cover**, carrying what the Θ-layer consumes and no
containment of any piece in any chart.

Compare `ChartTyping` (`Picard/DivisorFamilyAffCover.lean:204`), whose `piece_le` field is the
fixed-pair confinement that `AffAdaptation.isEmpty_chartTyping_of_straddling` shows no
straddling cover can satisfy.  Nothing below is a statement about where `pieces j` lies. -/
structure ThetaTrivData (D : AffCoverData C R) (a : ℕ) where
  /-- The local reading of a global theta section on the piece: a trivialization of `𝒪(Θᵃ)`
  over `pieces j`, spelled through its effect on sections. -/
  read : ∀ j : D.index, relThetaSections C R π a →ₗ[R] Γ(relCurve C R, D.pieces j)
  /-- The comparison unit of two readings on the overlap of their pieces. -/
  unit : ∀ i j : D.index, Γ(relCurve C R, D.pieces i ⊓ D.pieces j)ˣ
  /-- **The matching law**: on the overlap the two readings differ by the comparison unit.
  This is the whole input of `thetaEval_mem`. -/
  matching : ∀ (i j : D.index) (x : relThetaSections C R π a),
    (relCurve C R).resHom (inf_le_left : D.pieces i ⊓ D.pieces j ≤ D.pieces i) (read i x)
      = ((unit i j : Γ(relCurve C R, D.pieces i ⊓ D.pieces j)ˣ) :
          Γ(relCurve C R, D.pieces i ⊓ D.pieces j))
        * (relCurve C R).resHom inf_le_right (read j x)
  /-- **The germ law**: where a point of the piece also lies in a pinned chart, the germ of
  the reading agrees with the germ of that chart's component of the section up to a unit of
  the stalk.  This is what the kernel bridge runs on, and it refers to the two-chart model of
  the SHEAF rather than to the location of the piece.

  Stated in the `relThetaResSide … inf_le_right` spelling rather than as `Bool.rec x.val.1
  x.val.2 b`, because that is the form `germ_val_mem_stalkIdeal_of_forall_side`
  (`Picard/DivisorFamilyAffTheta.lean:691`) consumes — the two differ by a self-restriction. -/
  germ_read : ∀ (j : D.index) (b : Bool) (z : relCurve C R) (hzj : z ∈ D.pieces j)
      (hzb : z ∈ relPinnedChart C R π b) (x : relThetaSections C R π a),
    ∃ u : ((relCurve C R).presheaf.stalk z)ˣ,
      ((relCurve C R).presheaf.germ (D.pieces j) z hzj).hom (read j x)
        = (u : (relCurve C R).presheaf.stalk z)
          * ((relCurve C R).presheaf.germ ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b)
              z ⟨trivial, hzb⟩).hom (relThetaResSide a b inf_le_right x)

/-! ## The old index maps in: nothing landed is lost -/

namespace ChartTyping

variable {D : AffCoverData C R} (τ : ChartTyping C R π D) (a : ℕ)

/-- **A chart typing gives a twisting datum.**  The reading is `relThetaResSide` at the
assigned side, the unit is `AffAdaptation.thetaOvlUnit`, the matching law is
`relThetaResSide_matching` — i.e. exactly the three ingredients
`Picard/DivisorFamilyAffTheta.lean` uses — and the germ law holds with `u = 1` on the assigned
side, comparing the two sides through the side matching unit otherwise.

So the widened Θ-layer's hypotheses are *implied* by the old index: this file weakens an
index, it does not replace one theory by another. -/
noncomputable def thetaTrivData : ThetaTrivData (π := π) D a where
  read j := relThetaResSide a (τ.side j)
    (AffAdaptation.piece_le_relPinnedChart (π := π) τ j)
  unit i j := relThetaSideUnit a (τ.side i) (τ.side j)
    (AffAdaptation.pieces_inf_le_relPinnedChart_inf (π := π) τ i j)
  matching i j x := by
    rw [resHom_relThetaResSide a (τ.side i)
        (AffAdaptation.piece_le_relPinnedChart (π := π) τ i),
      resHom_relThetaResSide a (τ.side j)
        (AffAdaptation.piece_le_relPinnedChart (π := π) τ j)]
    exact relThetaResSide_matching a (τ.side i) (τ.side j)
      (AffAdaptation.pieces_inf_le_relPinnedChart_inf (π := π) τ i j) x
  germ_read j b z hzj hzb x := by
    -- the two readings at `z` differ by the side matching unit, restricted to a germ
    have hzW : z ∈ D.pieces j ⊓ relPinnedChart C R π b := ⟨hzj, hzb⟩
    have hle : D.pieces j ⊓ relPinnedChart C R π b
        ≤ relPinnedChart C R π (τ.side j) ⊓ relPinnedChart C R π b :=
      inf_le_inf_right _ (AffAdaptation.piece_le_relPinnedChart (π := π) τ j)
    have hmatch := relThetaResSide_matching a (τ.side j) b hle x
    -- the comparison unit already lives on the piece-chart overlap, so its germ is a unit
    refine ⟨(((relThetaSideUnit a (τ.side j) b hle).isUnit).map
      ((relCurve C R).presheaf.germ (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom).unit, ?_⟩
    have hgerm := congrArg ((relCurve C R).presheaf.germ
      (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom hmatch
    rw [map_mul] at hgerm
    -- move the reading's germ down to the overlap, where `hmatch` lives
    rw [show ((relCurve C R).presheaf.germ (D.pieces j) z hzj).hom
          (relThetaResSide a (τ.side j)
            (AffAdaptation.piece_le_relPinnedChart (π := π) τ j) x)
        = ((relCurve C R).presheaf.germ (D.pieces j ⊓ relPinnedChart C R π b) z hzW).hom
            (relThetaResSide a (τ.side j) (hle.trans inf_le_left) x) from
      (AffAdaptation.germ_relThetaResSide_eq a x (τ.side j)
        (AffAdaptation.piece_le_relPinnedChart (π := π) τ j) inf_le_left hzW).symm,
      hgerm]
    -- and the `b`-component's germ up from the overlap to `⊤ ⊓ chart b`
    exact congrArg _ (AffAdaptation.germ_relThetaResSide_eq a x b
      (inf_le_right : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b
        ≤ relPinnedChart C R π b)
      (le_inf le_top (hle.trans inf_le_right)) hzW)

end ChartTyping

/-! ## Inhabitation at exponent `0`, for EVERY widened cover

At `a = 0` the theta cocycle is trivial (`relThetaCocycle_zero`), so a global theta section is
a pair of sections of the STRUCTURE sheaf on `V₀`, `V₁` agreeing on the overlap — and the two
pinned charts cover the curve.  One gluing therefore produces a genuine global section, and the
reading on a piece is that section restricted.  Note where the covering is used: `V₀ ⊔ V₁ = ⊤`
is a statement about the CURVE, applied before any piece is mentioned.  No piece is required to
sit inside a chart, which is exactly the difference from `ChartTyping`. -/

section ZeroExponent

variable (C R π)

/-- **The two pinned charts cover the curve**, in the `⊤ ⊓ ·` spelling the theta components
live over. -/
lemma le_iSup_top_inf_relPinnedChart :
    (⊤ : (relCurve C R).Opens) ≤ ⨆ b : Bool, (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b :=
  fun z _ => by
    have hz : z ∈ (relCover C R (fiberTwoCover π)).V₀ ⊔ (relCover C R (fiberTwoCover π)).V₁ := by
      rw [relCover_sup]; trivial
    rcases Opens.mem_sup.mp hz with h | h
    · exact Opens.mem_iSup.mpr ⟨false, ⟨trivial, h⟩⟩
    · exact Opens.mem_iSup.mpr ⟨true, ⟨trivial, h⟩⟩

/-- **A global theta section at exponent `0` glues to a global section of `𝒪`.**  Its two
components agree on the chart overlap because the cocycle is `1` there, and the charts cover. -/
lemma existsUnique_glueThetaZero (x : relThetaSections C R π 0) :
    ∃! s : Γ(relCurve C R, ⊤), ∀ b : Bool,
      (relCurve C R).resHom
          (inf_le_left : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b ≤ ⊤) s
        = relThetaResSide 0 b inf_le_right x := by
  refine (relCurve C R).sheaf.existsUnique_gluing'
    (fun b : Bool => (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b) ⊤
    (fun b => homOfLE inf_le_left) (le_iSup_top_inf_relPinnedChart C R π)
    (fun b => relThetaResSide 0 b inf_le_right x) ?_
  intro i j
  -- the matching law at exponent `0`, where the side unit is `1`
  have hle : ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π i)
        ⊓ ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π j)
      ≤ relPinnedChart C R π i ⊓ relPinnedChart C R π j :=
    inf_le_inf inf_le_right inf_le_right
  have hmatch := relThetaResSide_matching 0 i j hle x
  rw [AffAdaptation.relThetaSideUnit_zero (C := C) (R := R) (π := π) i j hle, Units.val_one,
    one_mul] at hmatch
  rw [show relThetaResSide 0 i (hle.trans inf_le_left) x
      = (relCurve C R).resHom (inf_le_left :
          ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π i)
            ⊓ ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π j)
          ≤ (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π i)
        (relThetaResSide 0 i inf_le_right x) from
    (resHom_relThetaResSide 0 i inf_le_right inf_le_left x).symm,
    show relThetaResSide 0 j (hle.trans inf_le_right) x
      = (relCurve C R).resHom (inf_le_right :
          ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π i)
            ⊓ ((⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π j)
          ≤ (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π j)
        (relThetaResSide 0 j inf_le_right x) from
    (resHom_relThetaResSide 0 j inf_le_right inf_le_right x).symm] at hmatch
  exact hmatch

/-- The glued global section of a theta section at exponent `0`. -/
noncomputable def glueThetaZero (x : relThetaSections C R π 0) : Γ(relCurve C R, ⊤) :=
  (existsUnique_glueThetaZero C R π x).choose

lemma resHom_glueThetaZero (x : relThetaSections C R π 0) (b : Bool) :
    (relCurve C R).resHom
        (inf_le_left : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b ≤ ⊤)
        (glueThetaZero C R π x)
      = relThetaResSide 0 b inf_le_right x :=
  (existsUnique_glueThetaZero C R π x).choose_spec.1 b

/-- Uniqueness, in the form the linearity proofs consume. -/
lemma glueThetaZero_eq_of_forall {x : relThetaSections C R π 0} {s : Γ(relCurve C R, ⊤)}
    (h : ∀ b : Bool, (relCurve C R).resHom
        (inf_le_left : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b ≤ ⊤) s
      = relThetaResSide 0 b inf_le_right x) :
    s = glueThetaZero C R π x :=
  (existsUnique_glueThetaZero C R π x).unique h
    ((existsUnique_glueThetaZero C R π x).choose_spec.1)

/-- **The gluing is `R`-linear**, as a map out of the theta sections at exponent `0`. -/
noncomputable def glueThetaZeroHom :
    relThetaSections C R π 0 →ₗ[R] Γ(relCurve C R, ⊤) where
  toFun := glueThetaZero C R π
  map_add' x y := by
    refine (glueThetaZero_eq_of_forall C R π (fun b => ?_)).symm
    rw [map_add, resHom_glueThetaZero, resHom_glueThetaZero, map_add]
  map_smul' r x := by
    refine (glueThetaZero_eq_of_forall C R π (fun b => ?_)).symm
    -- `resHom` commutes with the `overModule` scalar action; both spellings of that lemma in
    -- the tree are `private` (`Cohomology/TwistedSheaf.lean:122`, `GluedSheaf.lean:108`), so
    -- the two-line unfolding is inlined rather than re-exported (inbox `I-0712`).
    have hsmul : (relCurve C R).resHom
        (inf_le_left : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b ≤ ⊤)
          (r • glueThetaZero C R π x)
        = r • (relCurve C R).resHom
            (inf_le_left : (⊤ : (relCurve C R).Opens) ⊓ relPinnedChart C R π b ≤ ⊤)
            (glueThetaZero C R π x) := by
      rw [Scheme.overModule_smul_def, map_mul, Scheme.overModule_smul_def]
      congr 1
      exact (relCurve C R).overAlgebraMap_apply_res R (homOfLE inf_le_left).op r
    rw [RingHom.id_apply, hsmul, resHom_glueThetaZero, map_smul]

end ZeroExponent

end AlgebraicGeometry
