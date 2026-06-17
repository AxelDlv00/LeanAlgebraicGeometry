# Blueprint Writer Report

## Slug
gr-cocycle

## Status
COMPLETE

## Target chapter
blueprint/src/chapters/Picard_GrassmannianCells.tex

## Changes Made
- **Added `% LEAN SIGNATURE` block** to `lem:gr_cocycle`
  (`\lean{AlgebraicGeometry.Grassmannian.cocycleCondition}`) — pins the intended
  scaffold target, the composition direction, and the doubly-localised triple-overlap
  rings. (must-fix F-4a)
- **Removed** `lem:mathlib_isUnit_iff_isUnit_det`
  (`\lean{Matrix.isUnit_iff_isUnit_det}`, `\mathlibok`) — orphaned isolated anchor;
  neither Lean proof uses it (see below). (must-fix F-4b)

## F-4a — the `% LEAN SIGNATURE` I pinned for `cocycleCondition`

**Composition direction.** RING-HOM direction `θ_{I,K} = θ_{I,J} ∘ θ_{J,K}`
(the scheme-morphism reading `θ_{J,K} ∘ θ_{I,J}` is its Spec-dual). This is the
direction consistent with the landed `transitionMap` orientation
(read from `AlgebraicJacobian/Picard/GrassmannianCells.lean:245`):

```
transitionMap d r I J hI hJ :
  Localization.Away (minorDet d r J I hJ hI) →+* Localization.Away (minorDet d r I J hI hJ)
```

i.e. domain `R^J[1/P^J_I]`, codomain `R^I[1/P^I_J]`.

**The genuine typing subtlety (the iter-011 prover's flag), now resolved in the
signature.** The naive
`transitionMap I K = (transitionMap I J).comp (transitionMap J K)` does **not**
typecheck:
- `transitionMap J K` codomain `Localization.Away (minorDet d r J K hJ hK)` (`R^J[1/P^J_K]`)
  ≠ `transitionMap I J` domain `Localization.Away (minorDet d r J I hJ hI)` (`R^J[1/P^J_I]`);
- `transitionMap I K` domain `Localization.Away (minorDet d r K I hK hI)` (`R^K[1/P^K_I]`)
  ≠ the composite's start `Localization.Away (minorDet d r K J hK hJ)` (`R^K[1/P^K_J]`).

The two `IsLocalization.Away.lift` codomains/domains differ, so I pinned the
conclusion over the **triple-overlap rings** obtained by inverting BOTH relevant
minors (named explicitly in the signature so the prover knows the formalization shape):

```
S_K := Localization.Away (minorDet d r K I hK hI * minorDet d r K J hK hJ)  -- R^K[1/(P^K_I P^K_J)]
S_J := Localization.Away (minorDet d r J I hJ hI * minorDet d r J K hJ hK)  -- R^J[1/(P^J_I P^J_K)]
S_I := Localization.Away (minorDet d r I J hI hJ * minorDet d r I K hI hK)  -- R^I[1/(P^I_J P^I_K)]
```

with the canonical `algebraMap`s from each single away-localisation into the matching
double one, giving localised transition maps
`Θ_{J,K} : S_K →+* S_J`, `Θ_{I,J} : S_J →+* S_I`, `Θ_{I,K} : S_K →+* S_I` (each the
`IsLocalization.Away.lift`/`IsLocalization.lift` of the relevant `transitionPreMap`
composed with the structure map into the double localisation). The pinned conclusion:

```
cocycleCondition d r I J K (hI : I.card = d) (hJ : J.card = d) (hK : K.card = d) :
  Θ_{I,K} = Θ_{I,J}.comp Θ_{J,K}      -- propositional equality of ring homs  S_K →+* S_I
```

The three cardinality hypotheses `hI hJ hK : _.card = d` are spelled out. The note
that pinning over the chart ring `S_I` on the triple-overlap open is acceptable (it
matches the prose proof, which computes over `ℤ[X^I, 1/P^I_J, 1/P^I_K] = S_I`) is
included in the comment.

The existing proof sketch is consistent with this signature (it checks agreement of
the two ring homs on the K-generators `x^K_{p,q}`, both giving `(X^I_K)^{-1} X^I` over
`S_I`); per the directive I did **not** rewrite the sketch.

## F-4b — `lem:mathlib_isUnit_iff_isUnit_det`: REMOVED

I read both Lean proofs:
- `isUnit_det_universalMinor` (`lem:gr_minorDet_unit`,
  `AlgebraicJacobian/Picard/GrassmannianCells.lean:104-110`) — uses
  `RingHom.map_det` + `IsLocalization.Away.algebraMap_isUnit`. Does NOT use
  `Matrix.isUnit_iff_isUnit_det`.
- `universalMinorInv_mul_cancel` (`lem:gr_universalMinorInv_identities`, lines 123-128)
  — uses `Matrix.nonsing_inv_mul` + `Matrix.mul_nonsing_inv` (via
  `isUnit_det_universalMinor`). Does NOT use `Matrix.isUnit_iff_isUnit_det`.

A repo-wide grep (`grep -rn isUnit_iff_isUnit_det AlgebraicJacobian/`) returned no hits.
Since neither proof (nor any other Lean decl) uses it, per the directive I removed the
orphaned `\mathlibok` anchor block entirely.

## Verification
- `leandag build --json`: `unknown_uses: []` (no broken `\uses` introduced by the removal).
- `leandag query --isolated --chapter Picard_GrassmannianCells`: 0 results (no isolated
  nodes remain in the chapter; the previously-isolated `lem:mathlib_isUnit_iff_isUnit_det`
  is gone, and `lem:gr_cocycle` is wired in both directions —
  `\uses{def:gr_transition, …, lem:gr_transition_self}` upstream and
  `def:gr_glued_scheme \uses{lem:gr_cocycle}` downstream).
- The `\mathlibok` Cramer-inverse anchors `lem:mathlib_nonsing_inv_mul` and
  `lem:mathlib_mul_nonsing_inv` remain (used by `lem:gr_universalMinorInv_identities`),
  so only the unused determinant-criterion anchor was dropped.

## References consulted
None (no new citation block authored). The `% SOURCE`/`% SOURCE QUOTE` material on the
cocycle block was already present from prior work (Nitsure §1); I added only the
`% LEAN SIGNATURE` engineering comment and removed one Mathlib anchor — neither requires
a source quote.

## Macros needed (if any)
None.

## Reference-retriever dispatches (if any)
None.

## Notes for Plan Agent
- **Formalization-shape note for the cocycle prover (not strategy-modifying).** The
  cocycle cannot be stated as a single-localisation `RingHom.comp` equality — the
  prover must first build the three doubly-localised rings `S_K, S_J, S_I` and the
  localised maps `Θ_{*,*}` (lifting `transitionPreMap`/`transitionMap` along the extra
  inverted minor). I named these in the signature comment. This is a real piece of
  scaffolding (≈ 3 aux defs + the lift lemmas) that does NOT yet exist in
  `GrassmannianCells.lean`; a `lean-scaffolder` pass to land the `S_*`/`Θ_*` skeleton
  before the prover attempts `cocycleCondition` would de-risk the leaf. The blueprint
  blocks for these aux objects are GR helper `lean_aux` nodes, which the directive
  deferred — flagging here so the scaffolding is planned, not silently assumed.
- The generated `blueprint/web/*.html` artifacts still contain stale references to the
  removed `lem:mathlib_isUnit_iff_isUnit_det` node; they regenerate on the next typeset
  and are not source.

## Strategy-modifying findings
None. The composition direction is consistent with the landed orientation of
`def:gr_transition` (`transitionMap`): domain `R^J[1/P^J_I]`, codomain `R^I[1/P^I_J]`,
so `θ_{I,K} = θ_{I,J} ∘ θ_{J,K}` as ring homs is the correct reading and reveals no
problem with `def:gr_transition`. The doubly-localised intermediate ring is a
formalization-shape detail (recorded under Notes for Plan Agent), not a strategy change.
