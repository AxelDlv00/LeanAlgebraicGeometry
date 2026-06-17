# Strategy-Critic Directive

## Slug
clean210b

## What to read (and ONLY this)
- `.archon/STRATEGY.md` (verbatim — the current strategy).
- `references/summary.md` (the index of available sources).
- The blueprint chapter list below (titles + topics).
- The project goal below.

Do NOT read iter sidecars, PROGRESS.md, task_pending/done, prover/review reports,
or any per-iter narrative. Your value is a fresh-mathematician view of the strategy.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected Lean declarations
headed by `AlgebraicGeometry.Jacobian` and `Jacobian.nonempty_jacobianWitness` —
an Albanese/Jacobian object uniform over the `k`-rational pointing of a smooth
proper geometrically irreducible curve `C/k`, with NO `C(k)≠∅` hypothesis and NO
`CharZero` (only `[Field k]`). The witness `J := Pic⁰_{C/k}` is built
unconditionally; only the universal property `isAlbaneseFor` is quantified over the
pointing. The end-state is zero inline `sorry` in the cone of each protected decl
with kernel-only axioms.

## Blueprint chapters (titles / topics)
- Picard_TensorObjSubstrate: line-bundle ⊗-group law via ⊗-invertibility (active lane)
- Picard_RelPicFunctor: relative Picard functor Pic_{C/k}
- Picard_FGAPicRepresentability: FGA representability of the Picard scheme
- Picard_QuotScheme / Picard_FlatteningStratification: Quot scheme (Nitsure) + flattening
- Picard_LineBundlePullback / Picard_RelativeSpec / Picard_IdentityComponent: Pic substrate
- Albanese_AlbaneseUP: Albanese universal property of Pic⁰ (Route 2)
- Albanese_{CodimOneExtension, Thm32RationalMapExtension, AuslanderBuchsbaum}: Route-1 cone (retained reversibly)
- RiemannRoch_* (WeilDivisor, RRFormula, OCofP, OcOfD, RationalCurveIso): RR substrate (PAUSED)
- Genus0BaseObjects_*, AbelianVarietyRigidity, AbelJacobi: genus-0 / rigidity substrate
- Cohomology_MayerVietoris: cohomology substrate

## Focus questions (this iter's two strategy changes)
1. **A.2.c Quot fork.** STRATEGY now states representability is RR-free ONLY via the full
   general Quot/Hilbert engine (~2150 LOC, all Mathlib-absent), while the cheap curve route
   (Sym^n/Abel–Jacobi, ~600–1000 LOC) needs the PAUSED Riemann–Roch. Is this fork stated
   correctly against the sources (Kleiman §4–§5, Nitsure §5)? Is committing to the RR-free
   general engine the right call given the standing ROUTE C PAUSE, or is there a third path?
2. **A.1.c.SubT associator.** STRATEGY claims the line-bundle group-law associator is now
   built objectwise on invertible objects by local trivialization, avoiding `MonoidalClosed`.
   Is this sound as a strategy-level claim, or does it hide a coherence obligation?

Also give your standard fresh challenges to any route you find unsound, over-scoped, or
resting on an unverified premise (e.g. the autoduality RR-freeness risk for Route 2).

## Output
Per-route verdict (SOUND / CHALLENGE / REJECT) with reasoning, to
`task_results/strategy-critic-clean210b.md`.
