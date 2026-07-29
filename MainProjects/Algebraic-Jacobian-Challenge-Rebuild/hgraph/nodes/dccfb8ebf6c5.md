---
author: sync
content_type: theorem
created: '2026-07-29T09:42:53'
decl: AlgebraicGeometry.AffAdaptation.isEmpty_chartTyping_of_straddling
docstring: '**NO `ChartTyping` EXISTS ON A COVER WITH A STRADDLING PIECE.**  If one
  piece contains a

  point outside `V₀` *and* a point outside `V₁`, then `ChartTyping C R π D` is empty:
  the piece is

  assigned some side, `piece_le` puts the *whole* piece inside that pinned chart,
  and each witness

  contradicts one of the two options.


  **This is the honest limit of the whole module, and it cuts against the headline.**  The
  claim

  this file was built on is that the widened carrier lacked a Θ-layer and that supplying
  it lets

  cert-r2''s producer reach U2.  The first half stands (see the module docstring''s
  measurements,

  independently confirmed as `I-0780`).  The second half does **not**: cert-r2''s
  producer runs

  through a cover in which the support sits inside **one** piece `W`

  (`exists_affCoverData_swallowedBy`), while the straddling hypotheses of

  `forall_not_isCertified_of_straddling` (`Picard/DivisorFamilyAffStrict.lean:127`)
  say precisely

  that the support has a point outside `V₀` and a point outside `V₁` — and both then
  lie in `W`.

  So on exactly the divisors protection `I-0492`''s widening exists to handle, this
  file''s index

  type is uninhabited and every theorem in it is vacuous.


  **Compounding it** (`I-0782`): the tree''s only producer of a `ChartTyping` is

  `FinCoverData.toChartTyping` (`Picard/DivisorFamilyAffCover.lean:255`), the migration
  *from* the

  old chart-typed carrier. So every instantiation available today factors through
  `FinCoverData`,

  i.e. this layer currently computes on the covers the chart-typed layer already handled,

  re-indexed.


  **What the module docstring got wrong, and it is a real methodological error.**
  `I-0492` clause 3

  keeps `ChartTyping` separate from the certificate clauses so that a certificate
  never *requires*

  a chart typing. That is a statement about what is **permitted**, and I read it as
  evidence about

  what is **inhabited**. Those are different questions, and only the second one decides
  whether a

  layer indexed by that datum is usable. The recorded shape is `isolating-a-residue-as-a-class`:

  check inhabitation of an index before pricing anything stated over it.'
file: AlgebraicJacobian/Picard/DivisorFamilyAffTheta.lean
generated: lean
lean_status: lean_ok
stale: true
title: AlgebraicGeometry.AffAdaptation.isEmpty_chartTyping_of_straddling
type: lean
updated: '2026-07-29T15:26:35'
---
theorem isEmpty_chartTyping_of_straddling (D : AffCoverData C R) (j : D.index)
    {x y : relCurve C R} (hxj : x ∈ D.pieces j) (hyj : y ∈ D.pieces j)
    (hx₀ : x ∉ ((relCover C R (fiberTwoCover π)).V₀ : Set (relCurve C R)))
    (hy₁ : y ∉ ((relCover C R (fiberTwoCover π)).V₁ : Set (relCurve C R))) :
    IsEmpty (ChartTyping C R π D) := by
  refine ⟨fun τ => ?_⟩
  have h := piece_le_relPinnedChart (π := π) τ j
  cases hb : τ.side j with
  | false => rw [hb] at h; exact hx₀ (h hxj)
  | true => rw [hb] at h; exact hy₁ (h hyj)

end Emptiness

/-! ## The kernel bridge — left exactness, and the seam with the chart-typed layer -/