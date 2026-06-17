# Mathlib Analogist Report

## Slug
p1-hedge-iter138

## Iteration
138

## Question

For the `C(k) ≠ ∅` branch of M2.b genus-0 witness specifically, is there a
viable ℙ¹-specific rigidity argument — cheaper than the general over-k shared
cotangent-vanishing pile (pieces (i)+(ii)+(iii)) — that uses a **weak ℙ¹
identification** of `C` with `ℙ¹_k` via elementary projective-embedding +
low-order-pole-existence (NOT full Serre duality), and that collapses the
dependence on scheme-level absolute Frobenius (piece (iii), ~800–1500 LOC) to
ring-side `k[t]` / `k[1/t]` instances?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1: Weak ℙ¹ identification exists in Mathlib b80f227 | NEEDS_MATHLIB_GAP_FILL | critical |
| 2: Ring-side `k[t]` Frobenius replaces piece (iii) cheaply | PROCEED conditional on Decision 1 (rules it out) | informational |
| 3: Hedge eliminates pieces (i.b) and (i.c) | PROCEED with (i.b)+(i.c) regardless of hedge | critical |
| 4: Hedge LOC envelope vs bundled pile | NOT-VIABLE on LOC grounds | critical |

**Overall verdict: NOT-VIABLE — DO NOT PURSUE THE HEDGE.**

## Direct answers to directive questions

### Q1. Weak ℙ¹ identification in Mathlib `b80f227`?

**No chain exists.** The required path (`smooth proper geom-irr genus-0
k-curve with k-point ⇒ C ≅ ℙ¹_k`) needs Riemann–Roch on a genus-0 curve plus
a degree-1 divisor — a chain whose every ingredient is structurally absent
from Mathlib:
- No `ProjectiveSpace n S : Scheme.CanonicallyOver S` (only the abstract
  `AlgebraicGeometry.Proj 𝒜` of a graded ring in
  `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Scheme`; iter-126 already
  encountered this hole, cf. `AlgebraicJacobian/RigidityKbar.lean:38-46`).
- No Cartier/Weil divisors on smooth proper curves; no global sections of
  line bundles; no linear systems; no `RiemannRoch` (verified by the iter-110
  pre-existing analogist file `analogies/serre-duality.md`).
- No Brauer-Severi triviality.

**In-tree build cost for the weak identification: ~1500–3000 LOC.** This is
the genus-0 specialisation of the iter-110 deferred Serre-duality build
(~3000–8000 LOC for full Serre duality on smooth proper curves). Comparable
in scope to the Hilbert/Quot scheme gap driving Phase C3 deferral.

### Q2. Cotangent-trivial input on `ℙ¹_k` charts?

**Mixed.** If the identification existed, the ring-level Frobenius savings
would be real:
- `Mathlib.Algebra.CharP.Frobenius` ships `frobenius` and `iterateFrobenius`
  ready for use on `k[t]` and `k[1/t]`.
- **But `Differential.ContainConstants k (Polynomial k)` is NOT a Mathlib
  instance.** Only the trivial `instContainConstants A A`
  (`Mathlib/RingTheory/Derivation/DifferentialRing.lean:75-76`).
- In characteristic `p > 0`, `ContainConstants k k[t]` with the standard
  derivation is **false** (every `f(t)^p` has derivative 0 but isn't constant).
  The hedge must replicate piece (iii)'s Frobenius descent ladder at the
  ring level on `k[t]` and `k[1/t]` — saving ~400–1100 LOC vs the scheme-
  level version, not the full ~800–1500 LOC the hedge claims to save.

The ring-side Frobenius hedge does NOT come for free; it just relocates piece
(iii)'s cost to the ring level on the affine charts.

### Q3. LOC envelope comparison

**Bundled pile (current strategy): ~1860–3540 LOC**
- (i.b) `mulRight_globalises_cotangent` + helpers: ~210–440 LOC.
- (i.c) `omega_free` + `omega_rank_eq_dim`: ~600–1100 LOC.
- (ii) scheme-level `ext_of_diff_zero`: ~250–500 LOC.
- (iii) scheme-level Frobenius iteration: ~800–1500 LOC.

**Hedge: ~2610–5240 LOC**
- Weak ℙ¹ identification (Riemann–Roch + linear systems +
  Brauer-Severi triviality, all gap-fill): ~1500–3000 LOC.
- (i.b)+(i.c) STILL required (target-side `A` cotangent, unaffected by
  source-side identification): ~810–1540 LOC.
- Affine-chart-glued (ii) on Spec k[t] ∪ Spec k[1/t]: ~150–300 LOC.
- Ring-side Frobenius iteration on k[t]/k[1/t]: ~150–400 LOC.

**The hedge is strictly more expensive than the pile in expectation
(~500–1700 LOC penalty).** And the hedge's risk profile is much worse: the
identification's prerequisite stack is wholly novel infrastructure with no
upstream precedent, while the pile's pieces all have at least partial Mathlib
precedents (`KaehlerDifferential.tensorKaehlerEquiv`, `frobenius`,
`Differential.ContainConstants` as a typeclass interface).

### Q4. Verdict

**NOT-VIABLE.** Three independent failures:

1. **Prerequisite gap.** Mathlib `b80f227` has no infrastructure for the
   weak identification (Decision 1). In-tree build cost equals or exceeds
   the bundled pile cost.
2. **Target-side residual.** The hedge addresses the source `C ≅ ℙ¹_k` side;
   pieces (i.b)+(i.c) trivialise the **target** `A`'s cotangent and remain
   irreducible (Decision 3).
3. **Ring-side `ContainConstants` is itself a non-trivial gap.** Mathlib's
   only registered instance is the trivial diagonal one. In char `p`, a
   ring-level `ContainConstants k k[t]` is **false** without a Frobenius
   descent — i.e., the hedge must replicate piece (iii) at the ring level
   anyway (Decision 2).

### Q5. Sequencing recommendation

**N/A — the hedge is not on a viable path. Continue with the bundled pile.**

The iter-137 PARTIAL prover lane on piece (i.b) Step 2 (per
`analogies/kaehler-tensorequiv-presheafpullback.md`) is the active build front
and remains the correct next step. Pieces (i.c), (ii), (iii) follow in their
already-scheduled order.

If the bundled pile stalls on (iii) at iter-140+, the cheaper escape hatch
is to **keep `rigidity_over_kbar` as a named-gap sorry** in the same family as
`serre_duality_genus` (cf. `analogies/serre-duality.md` named-gap deferral
recommendation). Going via the hedge would be strictly more expensive than
either closing the pile or accepting a named gap.

## Must-fix-this-iter

None. The hedge is a strategic proposal under evaluation; no shipped code
is divergent. The iter-138 strategic-decision artefact (`STRATEGY.md`)
should record the NOT-VIABLE verdict to retire the hedge from future
strategy iterations.

## Major

None (no ALIGN_WITH_MATHLIB verdicts; the only ALIGN-class finding is that
the iter-126 refactor agent's deliberate avoidance of an explicit
`ProjectiveSpace n S` encoding — in favour of the abstract `genus = 0 +
smooth + proper + geom-irr` characterisation — was the **correct call** and
remains so. The hedge would have reversed that decision at much higher cost.)

## Informational

- **Decision 1 (NEEDS_MATHLIB_GAP_FILL):** The weak ℙ¹ identification is a
  multi-thousand-LOC structural gap upstream; not project-actionable cheaply.
- **Decision 2 (PROCEED conditional, irrelevant under Decision 1):** ring-
  level Frobenius hedge would save ~400–1100 LOC vs scheme-level piece (iii)
  if the identification were free, but the identification is not free.
- **Decision 3 (PROCEED with (i.b)+(i.c) regardless):** target-side cotangent
  triviality is a fixed cost; the hedge does not retire it.
- **Decision 4 (NOT-VIABLE):** hedge costs strictly more than the pile in
  expectation with a much wider build-risk tail.

## Persistent file

`analogies/p1-hedge-genus-zero-witness.md` — full design-rationale, decision-
by-decision Mathlib search citations, and LOC comparison captured for future
iters. Recommend this analogy be cited by any future strategy iteration that
revisits the genus-0 M2.b body closure plan.

Overall verdict: the ℙ¹-specific hedge is **NOT-VIABLE** in Mathlib `b80f227`
because the weak identification's prerequisite stack is wholly absent
upstream, the hedge does not retire the target-side cotangent pieces, and the
ring-side Frobenius "savings" require their own Mathlib gap-fill. Continue
with the bundled pile (i.b)+(i.c)+(ii)+(iii); keep the named-gap deferral
option as the iter-140+ contingency.
