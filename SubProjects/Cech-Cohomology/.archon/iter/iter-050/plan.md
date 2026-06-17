# Iter-050 plan — 02KG residual route-B SELECTED; BOTH lanes dispatched

## Entering state (verified)
iter-049 reduced BOTH 02KG tops to ONE residual `htilde` (+4 axiom-clean decls in
`AffineSerreVanishing.lean`): positive-degree section Čech vanishing of `~M` over a standard cover of a
**proper** `D(f)` (cover spans `√(f)`, not `R`). iter-049 Lane 2 (`cechAugmented_exact`) never launched
(slot exhaustion). Project inline-sorry = 2 (both frozen/superseded). Build GREEN.

The loop had already run the plan-phase prep subagents before I took over this phase:
blueprint-writer `iter050-02kg` (corrected the `affine_cech_vanishing_qcoh` sketch + residual sub-lemma
chain + 4 coverage-debt blocks), mathlib-analogist `iter050-residual`, blueprint-writer `iter050-routeb`
(route-A→B pivot), blueprint-clean `iter050`, progress-critic `iter050`.

## What I did this phase
1. Processed the 5 pre-run subagent reports. No unprocessed prover result files on disk (iter-049 results
   already merged into task_pending by the prep). Refreshed task_pending top note + the 02KG residual
   section to route-B / both-lanes-dispatched.
2. **Adjudicated the route fork from the analogist report → ROUTE B (change-of-RING).** Route A
   (change-of-space) was rejected: it needs a tilde-base-change sheaf iso Mathlib lacks (~350–450 LOC,
   01I8-style diamond plumbing). Route B reuses the public `AwayComparison` API + the polymorphic
   `SectionCechModule.dDiff_exact` re-instantiated over `R_f` at the MODULE level, 0 sheaf infra, 0 refactor
   (~120–200 LOC). The new public theorem is CO-LOCATED in `CechAcyclic.lean` so the `private SectionCech*`
   core stays in scope (analogist's no-refactor finding). This matches the route-B blueprint the writer
   already landed (`lem:affine_cech_vanishing_tilde_subcover` now pins
   `sectionCech_homology_exact_of_localizationAway`).
3. **Ran the mandatory blueprint-reviewer `iter050`** (the consolidated chapter was edited this iter — the
   HARD GATE needed a fresh verdict for BOTH covered lane files). **GATE CLEARS both lanes, 0 must-fix.**
   Confirmed: route-B residual block complete + correct (polymorphic `dDiff_exact` over `R_f`, the
   `M_{gσ}≅(M_f)_{gσ}` ladder, `gσ∈√(f)` witness, IsZero wrap all sound; `\uses` resolve); `cech_augmented_resolution`
   still clears (unchanged since iter-049); `unknown_uses: []` (route-A deletions left no dangling refs).
   One non-blocking "soon": `lem:cech_augmented_resolution` proof `\uses` omits `lem:qcoh_isIso_fromTildeGamma`
   (cited in prose) — future writer pass.
4. **Dispatched BOTH lanes** (progress-critic `iter050`: the original Lane-1 deferral reason — "blueprint being
   corrected + route fork unresolved" — was dissolved THIS phase; both lanes gate-cleared, independent):
   - Lane 1 (CRITICAL): `CechAcyclic.lean` — route-B residual `sectionCech_homology_exact_of_localizationAway`.
   - Lane 2 (INDEPENDENT): `CechHigherDirectImage.lean` — `cechAugmented_exact`.
5. Updated STRATEGY: 02KG row → residual route-B leaf, iters-left ~1→~2 (progress-critic throughput note);
   P5a row notes the iter-049 no-run + iter-050 re-dispatch.

## Decision made

### D1 — ROUTE B (change-of-ring), co-located in `CechAcyclic.lean`, NOT route A (change-of-space).
- **Chosen:** route B. **Why:** both routes share the same algebraic core (degreewise `M_{gσ}≅(M_f)_{gσ}`
  commuting with the alternating localisation differentials); route A piles a Mathlib-absent tilde
  base-change sheaf iso + a cross-space section identification on top. Route B applies the core directly.
- **LOC/risk:** route B ~120–200 LOC / ~5–8 lemmas / 0 refactor vs route A ~350–450 LOC + a Mathlib gap.
- **Reversal signal:** if the `dDiff_exact`-over-`R_f` re-instantiation hits a non-polymorphic wall in the
  `private` core (e.g. an instance that secretly fixed `R`), reconsider — but the analogist confirmed the
  namespace is `{R}[CommRing R]`-polymorphic and the core is in scope via co-location.

### D2 — TWO lanes, not one. Override the task_pending "Lane-1 deferred to iter-051" plan.
The deferral was written when the blueprint was mid-correction and the route fork was open. Both resolved
this phase (writers + analogist + gate-clearing reviewer all returned). progress-critic explicitly flagged
the deferral reason dissolved and recommended both lanes. Lane 1 is the critical path and throughput is
SLIPPING at the 2× boundary (one more planning-only iter → OVER_BUDGET), so dispatching it now is
load-bearing. Lane 2 is independent and starved twice. Honors the standing parallelism directive.

## Subagent skips

- strategy-critic: STRATEGY.md arc (Route A acyclic-resolution comparison) is UNCHANGED; the only edits this
  iter are calibration (02KG iters-left ~1→~2) + a within-phase tactical note (residual route B). Route B vs A
  is a tactic INSIDE the already-validated 02KG phase, adjudicated by mathlib-analogist `iter050-residual` this
  iter — not a strategy-level route swap. Last strategy-critic (iter-041) validated the arc, which has not
  changed since. No live CHALLENGE/REJECT.
- progress-critic: NOT skipped — already ran (`progress-critic-iter050`, pre-dispatched by the loop this phase);
  verdict consumed (both routes UNCLEAR, dispatch-sanity OK, both lanes dispatchable).
- blueprint-reviewer: NOT skipped — ran `iter050` this phase (chapter edited ⟹ mandatory).
