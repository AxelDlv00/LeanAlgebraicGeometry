---
author: sync
content_type: structure
created: '2026-07-29T15:31:44'
decl: AlgebraicGeometry.ThetaTrivData
docstring: '**A twisting datum for a widened cover**, carrying what the Θ-layer consumes
  and no

  containment of any piece in any chart.


  Compare `ChartTyping` (`Picard/DivisorFamilyAffCover.lean:204`), whose `piece_le`
  field is the

  fixed-pair confinement that `AffAdaptation.isEmpty_chartTyping_of_straddling` shows
  no

  straddling cover can satisfy.  Nothing below is a statement about where `pieces
  j` lies.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffThetaTyping.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaTrivData
type: lean
updated: '2026-07-29T15:31:44'
---
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
<!-- REVIEWER FINDING (review-ajcr, run 0082 s0008, 2026-07-29) -->
## Reviewer audit: the vacuity MOVED rather than closed, and the `a = 0` citation is on the wrong carrier

Written into the file directly because `horizon graph add comment` echoes the body and
persists nothing (I-0932, still live at this run — I re-confirmed it on this node).

**The repair is real and the statement is NON-VACUOUS.** All four fields quantify over the
relative curve and its overlaps; a matching-law or germ-law failure on an overlap falsifies
it. `ThetaTrivData` exists because `AffAdaptation.isEmpty_chartTyping_of_straddling`
(`Picard/DivisorFamilyAffTheta.lean:658`) proved `ChartTyping` *empty* on exactly the
straddling covers R2 exists to handle, and this carrier drops `piece_le`.

**But nothing imports it.** `grep -rl '^import .*DivisorFamilyAffThetaTyping'` over
`AlgebraicJacobian/` returns **zero** importers; the module is umbrella-rooted (so it
builds) and has no consumer. An inhabited index with no consumers delivers the same
throughput as an empty one, and only the empty kind is caught by a vacuity sweep. Durable
lesson filed as I-1110.

**Citation defect, verified at the source.** The defence of the sole unconditional
producer's exponent `a = 0` cites `thetaIdealUnit_zero`
(`Picard/DivisorDatumInverse.lean:207`). That declaration exists — but its binder is
`variable {d : (relCurve C R).LocalEquations} (A : DivisorAdaptation C R π d)`, i.e. it is
stated on `DivisorAdaptation`, the **chart-typed** carrier, which takes `π`. The widened
carrier is `AffAdaptation`, and `grep 'AffAdaptation.*divisorDatum'` returns zero. The
citation is TRUE and on the WRONG CARRIER — the shape that is hardest to catch, because
checking the *name* succeeds.

**For a lane extending this layer:** give it a consumer on the widened side or say plainly
that it is a parked repair, and re-derive the `a = 0` justification against `AffAdaptation`
rather than inheriting it.
