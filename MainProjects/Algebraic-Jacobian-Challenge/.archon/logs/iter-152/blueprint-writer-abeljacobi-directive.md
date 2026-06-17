# Blueprint Writer Directive

## Slug
abeljacobi-descent

## Target chapter
blueprint/src/chapters/AbelJacobi.tex

## Strategy context (the slice that matters)
The project pivoted: `rigidity_over_kbar` now carries `[IsAlgClosed kbar]`
(rigidity proved over an algebraically closed base, descended to general k
downstream). The prior "over-k commitment" framing (rigidity k-agnostic, no
algebraic-closure hypothesis, sub-step C.2.f DROPPED) is now STALE.

## Required edits to this chapter
- At the passages (around the lines describing `thm:rigidity_over_kbar`'s use)
  that assert "signature is k-agnostic", "no algebraic-closure … hypothesis",
  "sub-step C.2.f DROPPED": rewrite to reflect that rigidity is proved over the
  algebraic closure k̄ and descended to k via faithfully-flat descent of
  morphism equality (`AlgebraicGeometry.Flat.epi_of_flat_of_surjective`). Keep
  the edits minimal — this chapter's three Albanese-projection declarations are
  already closed and consume the corrected statement only through its name.
- Do not introduce new declarations; this is a consistency/prose reconciliation.

## Out of scope
- Do NOT edit other chapters; flag cross-chapter issues in Notes for Plan Agent.
- Do NOT add `\leanok`/`\mathlibok`. Do NOT write Lean tactics.
- Do NOT change protected signatures (`Jacobian.ofCurve`, `comp_ofCurve`,
  `exists_unique_ofCurve_comp`) or their `\lean{}` hints.
