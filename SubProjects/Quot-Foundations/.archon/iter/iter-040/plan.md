# Iter 040 — Plan (Quot-Foundations)

## TL;DR

iter-039 fired the FBC kill-criterion (conj-2b/2d landed, the one-shot `_legs_conj` reframing didn't close)
and landed the last QUOT gap1 feeders (all consumers now built). This iter is **decision + preparation +
1 deep prover lane**:
1. **FBC** — honored the kill-criterion (NO conjugate prover round); the api-alignment analogist consult
   resolved the fork decisively to **Fallback B** (layer-by-layer conjugate transport). Updated STRATEGY +
   the FBC blueprint `_legs_conj` sketch to that route. iter-041 dispatches the FINAL in-loop FBC round.
2. **QUOT** — blueprint-writer decomposed the geometric section-transport producer into a `\uses`-linked
   chain (a–d + TOP); HARD GATE re-cleared (blueprint-reviewer); dispatched **1 mathlib-build prover** on
   the producer (bottom-up from sub-gap (a)). The only gate-clear ready frontier this iter.
3. **Coverage debt CLEARED** — 13 QUOT/Scheme.Modules + 6 GR blueprint blocks (two blueprint-writers);
   leandag unmatched → 0 in the touched neighbourhoods.

## Decision made — FBC: adopt Fallback B, defer the prover round to iter-041 (the final in-loop attempt)

- **Option chosen:** NO FBC conjugate prover round this iter (honoring the pre-armed kill-criterion). The
  corrective for the STUCK route was the api-alignment analogist consult — which I dispatched and which
  returned IN-ITER with a decisive verdict: **ALIGN → Fallback B** (the `leftAdjointCompIso`/
  `conjugateEquiv.injective` discharge), executed by peeling ONE adjunction-layer at a time via
  `conjugateEquiv_symm_comp` + whiskering (mirroring Mathlib's `leftAdjointCompNatTrans₀₂₃_eq_conjugateEquiv_symm`),
  NOT the one-shot recognise that failed 3 iters. Element-`ext` (Fallback A) is DROPPED — it is the iter-035
  dead end and Mathlib reserves `ext` for atomic dictionary leaves only. Recipe persisted to
  `analogies/fbc-legs-conj-injective-route.md`.
- **Why defer the prover to iter-041 rather than run it now:** (1) the kill-criterion I armed last iter
  literally named iter-040 as "no conjugate round" — overriding my own pre-commitment the same iter the
  consult lands is the rush/sunk-cost pattern the discipline guards against; (2) both critics schedule the
  FBC prover for iter-041 and the progress-critic set a HARD constraint that it is the FINAL in-loop attempt
  before user escalation — that round must be maximally prepared (blueprint sketch + analogies recipe
  encoded), which I did this iter; (3) the one ready prover slot is better spent on the QUOT producer (the
  bottleneck unblocking GF). So FBC = prepared now, dispatched iter-041.
- **LOC/risk:** iter-041 FBC round ~80–150 LOC, fine-grained. Risk: Fallback B is still a conjugate-class
  discharge; if the layer-by-layer peeling also resists, the route is genuinely exhausted in-loop.
- **Cheapest reversal signal (next fallback):** if the iter-041 Fallback-B round closes nothing, escalate to
  the user and open the affine **tilde-transport** route that bypasses `gstar_transpose` at the
  affine-local level (the strategy-critic's flagged structurally-different route) — NOT another conjugate
  round, NOT another analogist consult.

## Critic dispositions (no silent overrides)

- **progress-critic `iter040` — FBC STUCK / QUOT CONVERGING.** ACCEPTED. FBC: the critic confirmed the
  kill-criterion fired correctly and the analogist consult is the right corrective TYPE; it added the
  constraint that the iter-041 FBC round is the LAST in-loop attempt (no further analogist rounds) before
  user escalation — encoded in STRATEGY + PROGRESS + TO_USER. QUOT: CONVERGING (each iter peeled a genuine
  layer; residual now decomposed) but throughput **OVER_BUDGET** (~14 iters vs the 3–7 estimate) → revised
  the QUOT estimate in STRATEGY (3–6 left) and added an explicit "elapsed ~14 iters, this is the last" note.
- **strategy-critic `iter040` — FBC CHALLENGE (sequencing only) / QUOT,GF,GR SOUND.** ADDRESSED, not
  rebutted. The challenge was narrow: (i) fallbacks A and B are both conjugate-class, while the
  tilde-transport route (the only `gstar_transpose`-bypass) was escalation-gated — answered by keeping
  tilde-transport as the explicit next-fallback reversal signal (above) AND by the analogist's first-
  principles reason that B is the Mathlib-aligned direct route (so tilde is a heavier detour, correctly
  deferred); (ii) surface A2 (the untouched Mathlib-absent affine reduction) as a PARALLEL lane — done:
  split FBC-A into A1 (`_legs_conj`) and A2 (affine reduction) rows in STRATEGY, A2 marked parallelisable
  and needing its own api-alignment consult + blueprint. Format DRIFT (backward narrative) — trimmed the
  edited cells; a fuller prose-trim pass remains owed (non-blocking, logged in task_pending hygiene).
- **blueprint-reviewer `iter040` — HARD GATE PASSES** for Picard_QuotScheme (complete+correct, no must-fix)
  ⟹ the QUOT producer lane is dispatched THIS iter (same-iter fast path: writer → green → re-review). GR
  coverage blocks all matched; one soon-not-must-fix `\uses` wiring on `lem:gr_det_one_updateCol` logged.
- **mathlib-analogist `fbc-fork` — ALIGN → Fallback B.** Acted on: STRATEGY route + Q2 + the FBC blueprint
  `_legs_conj` NOTE/sketch updated to the layer-by-layer route; recipe in `analogies/`.

## QUOT producer lane — why this shape (not another "assemble Hfr" round)

The progress-critic's CONVERGING-but-watch read and the iter-039 prover handoff agree: the gap1 keystone is
NOT a trivial assembly — its sole remaining input is a genuine ~200–400 LOC geometry build (the basic-open
`Hfr` producer). Re-dispatching "assemble Hfr" would churn. Instead the blueprint-writer decomposed it into
a `\uses`-linked chain — (a) 3-fold `pullbackComp` iso + P1 transport, (b) range/`σf'=algebraMap`
computations, (c) ⊤-vs-`D(f')` σ-naturality, (d) f-locus scalar-tower, then the TOP assembly — so the
mathlib-build prover attacks small pieces bottom-up. This is the blueprint-expansion corrective, matching a
genuine remaining build rather than a helper-churn.

## Soundness check
No disproof pass owed: the QUOT keystone is Stacks `lemma-invert-f-sections` (well-established); the FBC
`_legs_conj` coherence is a true mate identity (math certified sound by the iter-039 strategy-critic).

## Subagent skips
(none — all five HIGHLY RECOMMENDED + the analogist were dispatched this phase: blueprint-reviewer,
progress-critic, strategy-critic, two blueprint-writers, mathlib-analogist.)
