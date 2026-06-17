# Convergence audit — iter-050

Assess per-route convergence for the 3 routes the planner is weighing for iter-050 prover dispatch.

## Route: GF-geo (`FlatteningStratification.lean`)
- Strategy: phase entered iter-039; current est `4–6` iters left.
- Signals (last 5 iters), active sorry = 1 throughout (`genericFlatness`, gated on G1):
  - iter-045: +2 decls (G1 locality reduction + base-case gap). Status PARTIAL.
  - iter-046: annihilator side-work (QuotScheme), GF untouched.
  - iter-047: +3 axiom-clean (seam-2 counit, seam-3, free-epi base case). seam-1 BLOCKED. PARTIAL.
  - iter-048: WASTED (plan-validate failed_all_noop; 0 provers ran).
  - iter-049: +2 axiom-clean (seam-1b, seam-1c). seam-1a BLOCKED. PARTIAL.
- Recurring blocker: seam-1a `gf_localGenerators_restrict` (restriction-of-generation = epi-preservation).
  iter-049 RESOLVED the blocker characterization: concrete route now exists = transport `σ.π` along the
  EXISTING project infra `overRestrictPullbackIso` through the epi-preserving geometric `pullback U.ι`.
- iter-050 proposed objective: build seam-1a via that route, then assembly → G1 → G3 → close genericFlatness.

## Route: SNAP-S0 (`SectionGradedRing.lean`)
- Strategy: phase entered iter-047; current est `3–6` iters left. Active sorry = 0 throughout.
- Signals:
  - iter-047: +10 axiom-clean decls (layer-1: tensorObj/Pow, unitors, braiding, counit). PARTIAL.
  - iter-048: WASTED (0 provers).
  - iter-049: +1 axiom-clean (`sectionsMul`, lax-Γ). `tensorPowAdd` BLOCKED. PARTIAL.
- Recurring blocker: the sheaf-level associator = strong-monoidality of `PresheafOfModules.sheafification`.
  Both known routes hit ABSENT Mathlib: LocalizedMonoidal needs `MonoidalClosed (PresheafOfModules)`;
  stalkwise needs stalk infra for module sheaves. The prior analogue (snap-assoc Analogue 4, "avoid the
  associator via local-freeness") was found INSUFFICIENT this iter — the associator is unavoidable.
- iter-050 proposed action: NO prover; analogist consult to decide cheapest route, defer prover to iter-051.

## Route: GR-quot (`GrassmannianQuot.lean`, NEW — not yet created)
- Fresh route. Chapter `Picard_GrassmannianQuot.tex` complete iter-049. Analogist (iter-049) found
  `universalQuotient`/`tautologicalQuotient`/`functor` rest on Mathlib-ABSENT module-gluing primitive +
  `IsLocallyFreeOfRank` predicate; `chartQuotientMap`/`represents` PROCEED-now. Deferred scaffold iter-048+049.
- iter-050 proposed objective: scaffold the file + build PROCEED-now decls + start infra (loc-free predicate).

## What to assess
For each route: CONVERGING / CHURNING / STUCK / UNCLEAR, and the corrective TYPE if not converging.
Focus: is GF genuinely converging now that seam-1a has a concrete route, or is "concrete route exists"
the same optimism as prior iters? Is SNAP churning (helpers each iter, residual unmoved)? Is deferring the
SNAP prover the right call vs forcing it? Is GR-quot a sound fresh start or a premature scaffold.
