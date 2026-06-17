# Strategy Critic Directive

## Slug
iter149

## Iter
149

## Question

Re-verify STRATEGY.md for soundness as a fresh mathematician
would, with no investment in the project's existing momentum.
**STRATEGY.md is materially unchanged from iter-148.** That
iter you challenged it on 2 specific items (DRIFT phrases + LOC
inconsistency on Route C + substep 3 gap depth ambiguity); the
planner absorbed all of them in the iter-148 plan phase. This
iter please re-verify the absorption stuck AND surface any
fresh challenges from a 4-iter-deeper view of the file
(iter-145 → iter-148 chart-algebra evidence is on the
record now).

## Inputs

### STRATEGY.md (verbatim)

(See `.archon/STRATEGY.md` — 207 LOC, well under 250-line bound.)

### references/summary.md (verbatim)

(See `references/summary.md` — 1 reference, `challenge.lean`,
the formal challenge file by Christian Merten.)

### Blueprint chapter summary

Eleven chapters under `blueprint/src/chapters/`. Topics:

- `Cohomology_SheafCompose` — sheaf composition / pushforward
  bridge, abstract.
- `Cohomology_StructureSheafAb` — structure-sheaf-as-AbGroup
  pipeline (Phase A 2–4 inventory).
- `Cohomology_StructureSheafModuleK` — structure-sheaf-as-
  ModuleCat-k pipeline.
- `Cohomology_MayerVietoris` — 2-chart Čech / Mayer–Vietoris
  abstract infrastructure (`AffineCoverMVSquare`, MV exact
  sequence).
- `Differentials` — forward smoothness criterion +
  smooth_locally_free_omega.
- `Genus` — genus definition; no H¹ vanishing computations.
- `Jacobian` — Jacobian def + Albanese witness + existence
  theorem + genus-stratified body + Route A Picard scheme
  via FGA decomposition + Route B historical-only.
- `Rigidity` — scheme-level dominant-source/separated-target
  rigidity packaging (closed).
- `RigidityKbar` — `rigidity_over_kbar` body + cotangent-
  vanishing pile decomposition + chart-algebra piece (ii)
  first-class 5-block decomposition.
- `AlgebraicJacobian_Cotangent_GrpObj` — pointer chapter into
  `GrpObj.lean` (post iter-145 chart-algebra excise).
- `AbelJacobi` — Abel–Jacobi map at a marked point + uniqueness
  of factorisation.

### Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected
declarations (signatures frozen at `archon-protected.yaml`),
headlined by `AlgebraicGeometry.Jacobian` (a smooth proper
geometrically irreducible group scheme over `k` of relative
dimension `genus C`) and `Jacobian.nonempty_jacobianWitness`
(the existence of an Albanese / Jacobian object uniformly over
the $k$-rational pointing of a smooth proper geometrically
irreducible curve `C/k`, with no $C(k) \neq \emptyset$
hypothesis on the protected signature). End-state: zero inline
`sorry` and kernel-only axioms (`propext`, `Classical.choice`,
`Quot.sound`).

## Specific re-verification asks (carry-over from iter-148
challenges)

1. **Substep 3 path commitment.** Iter-148 plan agent's
   commitment in `## Open strategic questions` was: "iter-148
   prover lane attempts path (b); fallback to (a) or (c) for
   iter-149+ if (b) fails." Iter-148 outcome: path (b) framework
   landed sorry-free; residual concentrated at the
   `IsPurelyInseparable ∧ Algebra.IsSeparable` consolidated
   claim, decomposed into 4 named sub-claims. Iter-149 plan
   commits to **continuing path (b)** with a more substantively
   scoped prover lane (~370–610 LOC across 2 sorries + 4
   sub-claim attacks). Please verify this commitment is sound,
   given the iter-148 mathlib-analogist verdict on Mathlib
   gap depth.

2. **LOC envelope reconciliation.** Iter-148 raised the
   rolling-trigger threshold to 1200 LOC cumulative. Current
   total LOC landed in `Cotangent/ChartAlgebra.lean`: 419 LOC
   (iter-148 close); iter-149 lane budgeted at ~370–610 LOC
   would bring cumulative to 789–1029 LOC. Both numbers stay
   under the 1200 LOC trigger. Please re-verify the envelope
   is honest given the genuine Mathlib gap depth surfaced
   iter-148.

3. **Phases & estimations row honesty.** Row 1
   (Chart-algebra envelope) shows "iters left 4–7". Elapsed in
   current phase: 4 (iter-145 → iter-148). Iter-148 closed
   neither sorry. Is the 4–7 range still honest, or should the
   estimate be revised upward given the iter-148 gap-depth
   finding? Please apply the throughput-honesty bucket from
   your descriptor.

4. **DRIFT-phrase excisions.** Iter-148 plan-agent absorbed 4
   DRIFT phrases per your iter-148 challenge. Please verify
   they have not re-emerged in any updated section. Specific
   phrases removed (look for new variants):
   - "iter-123 audit weighted this heavily" → dropped.
   - "pre-iter-127 path; iter-127 committed" → reworded.
   - "Iter-150 carries a scheduled symmetric audit" → reworded
     "next strategic checkpoint".
   - "closed sub-pieces omitted; see iter-147 sidecar" →
     replaced with a non-iter-specific summary.

5. **Multi-route coverage.** STRATEGY.md commits to:
   - Route C (M2 critical path) — chart-algebra piece (ii)
     in `Cotangent/ChartAlgebra.lean`. Active.
   - Route A (M3 off-critical-path) — Picard scheme via FGA.
     Scheduled to scaffold ~iter-170+.
   - Alternative — over-$\bar k$ + Galois descent — held in
     reserve under rolling trigger.

   Please re-verify the routing decisions are still sound given
   the iter-148 evidence.

## Out of scope

- Iter sidecars' full content (do not read).
- `task_pending.md`, `task_done.md`, recent prover task results
  (do not read — these would corrupt the fresh-context
  premise).
- Per-iter narrative of what was tried — only `STRATEGY.md`'s
  current frozen form matters.

## Reminders

- Report path: `.archon/task_results/strategy-critic-iter149.md`.
- Your verdict must be `SOUND` / `CHALLENGE` / `DRIFTED`
  per-route + a global verdict.
- If unchanged from iter-148, you may pass through the iter-148
  challenges as still-live with a 1-line note rather than
  re-deriving them.
