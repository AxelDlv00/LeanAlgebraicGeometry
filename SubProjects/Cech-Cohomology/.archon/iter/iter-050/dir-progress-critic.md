# Progress-critic directive — iter-050 convergence read

Two active routes feeding this iter's prover assignment. Assess CONVERGING / CHURNING / STUCK / UNCLEAR
per route and flag dispatch-sanity issues on the proposed objectives.

## Route 1 — 02KG affine Serre vanishing — `AffineSerreVanishing.lean`
Top targets `affine_serre_vanishing` + `affine_cech_vanishing_qcoh`. Were GATED on the 01I8 keystone chain
(closed iter-048); the tops first became dispatchable iter-049.

Signals (last 5 iters; mathlib-build mode ⟹ "no-sorry, helpers" is the unit of progress, not sorry count):
- iter-045: 02KG GATED (01I8 in progress). No 02KG prover.
- iter-046: 02KG GATED. No 02KG prover.
- iter-047: 02KG GATED. No 02KG prover.
- iter-048: 01I8 CLOSED (`qcoh_iso_tilde_sections` unconditional) — 02KG ungated. No 02KG prover yet.
- iter-049: FIRST 02KG-top prover. Status PARTIAL. +4 axiom-clean decls
  (`affine_cover_span_localizationAway`, `cechCohomology_isZero_of_iso`, two `_of_tildeVanishing` reduction
  forms). 0 sorries introduced. Reduced BOTH tops to a SINGLE explicit residual `htilde`. Blocker phrase:
  "residual = section Čech vanishing of `~M` over a cover of a PROPER `D(f)`; route = change-of-base to
  `R_f`; the iter-049 prover called it 'genuinely multi-session infrastructure, comparable to the keystone
  chain'."

Concern to weigh: the keystone chain (01I8) was estimated ~2 iters but took ~14 (040→048, the largest
overrun in the project). The 02KG residual is now self-described as "comparable to the keystone chain." Is
02KG at risk of the same multi-iter overrun, and does the 1-iter-of-data trajectory (reduce-to-residual,
then decompose) look like genuine convergence or the start of another long helper-chain?

STRATEGY `Iters left` for this route: **~1** (02KG row). Route entered current phase (tops dispatchable):
**iter-049**.

## Route 2 — P5a augmented Čech resolution — `CechHigherDirectImage.lean` (`cechAugmented_exact`)
INDEPENDENT of 02KG (only needs the now-unconditional `qcoh_iso_tilde_sections`). Blueprint sketch rewritten
iter-049 to a stalk-at-prime / "one `f_i` is a unit" contracting-homotopy argument; gate-cleared.

Signals:
- iter-049: DISPATCHED but the prover **NEVER LAUNCHED** — only one prover jsonl on disk (the loop appears to
  have run a single prover and Lane 1 consumed the slot). 0 prover output, 0 helpers, 0 sorries. No
  trajectory data yet.

STRATEGY `Iters left` for this route: **~3–4** (P5a row). Route entered current phase: **iter-049**
(dispatched, no run).

## This iter's PROGRESS.md `## Current Objectives` proposal (for dispatch-sanity)
- **1 prover lane:** `CechHigherDirectImage.lean` — build `cechAugmented_exact` (mathlib-build, NEW decl,
  gate-cleared). [Route 2]
- The Route-1 residual prover is DEFERRED to iter-051 (blueprint sketch is being corrected this iter by a
  writer; a route fork — change-of-space vs change-of-ring — is being adjudicated by a mathlib-analogist
  this iter). Only blueprint + analogist work on Route 1 this iter, no Route-1 prover.

Assess: is deferring the Route-1 prover (and giving the slot to the twice-starved Route-2 lane) sound, or is
there a dispatch-sanity problem (e.g. Route 2 is not actually ready, or Route 1 should not be deferred)?
