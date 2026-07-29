---
author: sync
content_type: lemma
created: '2026-07-17T21:01:12'
decl: AlgebraicGeometry.ThetaGeneratorSeed.basicOpen_eq_basicOpen_mul
docstring: '**Denominator clearing on a piece**: every basic sub-open `D(f)` of the
  piece at `z`

  is the basic open of a chart-level section `h z · u`.'
file: AlgebraicJacobian/Picard/DivSchemeSeed.lean
generated: lean
lean_status: lean_ok
title: AlgebraicGeometry.ThetaGeneratorSeed.basicOpen_eq_basicOpen_mul
type: lean
updated: '2026-07-29T15:31:42'
---
lemma basicOpen_eq_basicOpen_mul (z : relCurve C R)
    (f : Γ(relCurve C R, D.piece z)) :
    ∃ u : Γ(relCurve C R, relPinnedChart C R π (D.side z)),
      (relCurve C R).basicOpen f = (relCurve C R).basicOpen (D.h z * u) := by
  obtain ⟨u, n, hun⟩ := IsAffineOpen.exists_pow_mul_eq_resHom
    (isAffineOpen_relPinnedChart C R π (D.side z)) (D.h z) rfl (D.piece_le z) f
  refine ⟨u, ?_⟩
  have hunit : IsUnit ((relCurve C R).resHom (D.piece_le z) (D.h z)) :=
    (relCurve C R).isUnit_resHom_of_eq_basicOpen (D.h z) rfl (D.piece_le z)
  have hON : (relCurve C R).basicOpen
      ((relCurve C R).resHom (D.piece_le z) (D.h z) ^ n) = D.piece z :=
    (relCurve C R).toLocallyRingedSpace.toRingedSpace.basicOpen_of_isUnit (hunit.pow n)
  have h1 : (relCurve C R).basicOpen f = D.piece z ⊓ (relCurve C R).basicOpen f :=
    (inf_eq_right.mpr ((relCurve C R).basicOpen_le f)).symm
  have h2 : D.piece z ⊓ (relCurve C R).basicOpen f
      = (relCurve C R).basicOpen ((relCurve C R).resHom (D.piece_le z) (D.h z) ^ n)
        ⊓ (relCurve C R).basicOpen f :=
    congrArg (fun O => O ⊓ (relCurve C R).basicOpen f) hON.symm
  have h3 : (relCurve C R).basicOpen ((relCurve C R).resHom (D.piece_le z) (D.h z) ^ n)
        ⊓ (relCurve C R).basicOpen f
      = (relCurve C R).basicOpen
          ((relCurve C R).resHom (D.piece_le z) (D.h z) ^ n * f) :=
    ((relCurve C R).basicOpen_mul _ _).symm
  have h4 : (relCurve C R).basicOpen
        ((relCurve C R).resHom (D.piece_le z) (D.h z) ^ n * f)
      = (relCurve C R).basicOpen ((relCurve C R).resHom (D.piece_le z) u) :=
    congrArg (fun s => (relCurve C R).basicOpen s) hun
  have h5 : (relCurve C R).basicOpen ((relCurve C R).resHom (D.piece_le z) u)
      = D.piece z ⊓ (relCurve C R).basicOpen u :=
    Scheme.basicOpen_resHom (D.piece_le z) u
  have h7 : (relCurve C R).basicOpen (D.h z) ⊓ (relCurve C R).basicOpen u
      = (relCurve C R).basicOpen (D.h z * u) :=
    ((relCurve C R).basicOpen_mul _ _).symm
  exact h1.trans (h2.trans (h3.trans (h4.trans (h5.trans h7))))

/-! ## The keystone: `IsGenerator` from `dvd` + fibrewise nonvanishing -/

set_option maxHeartbeats 800000 in
-- the mixed relCurve/product defeq checks at the residue fields are heavy
set_option synthInstance.maxHeartbeats 800000 in
set_option maxSynthPendingDepth 8 in
-- the `κ(p)` residue-field towers over an abstract test ring exceed the lakefile
-- pending-depth default, and the pinned-chart tensor algebras drive long searches
-- (recorded escape hatch, I-0198 hazard 3)