# Iter 020 — Plan (Quot-Foundations)

## TL;DR

**Resumed after a mid-plan context reset** (like iters 009/012/015/017). The prior partial run had
already processed the iter-019 prover results, run lean-auditor + 3 lean-vs-blueprint-checkers,
dispatched progress-critic `iter020` (FBC STUCK, GF CHURNING, QUOT STUCK-metric-artifact),
mathlib-analogist `fbc-mate` (cross-domain), blueprint-writer `quot-iter020` (base-case route-(b)
block + 16 coverage blocks), and **two FBC refactors** (`fbc-decouple-legs`, `fbc-legfree`) that were
**interrupted by the reset** (no dispatch_end, no reports).

On resume the decisive work was **establishing FBC ground truth**: an incremental `lake build` cache
was reporting a STALE sorry landscape. A forced rebuild (`touch` + build) revealed the real state and
a **genuine FBC route swap** the `decouple-legs` refactor had landed: it built
`base_change_mate_domain_read` **axiom-clean** and re-routed `base_change_mate_section_identity` to
derive from `domain_read` + `codomain_read` + Seam-3 `gstar_transpose`, making the **6-iter-stuck
Seam-2 `fstar_reindex` mate-unwinding crux dead code**. (`legfree`'s intended binder-drop never landed
— harmless; the route swap from `decouple-legs` already obviated it.)

I then finished the blueprint pipeline (FBC reroute writer + QUOT clean → blueprint-reviewer, which
cleared the QUOT HARD GATE and confirmed the FBC route swap) and dispatched the **2 ready lanes**:
GF (close L4 finiteness AND begin `genericFlatnessAlgebraic` — the CHURNING corrective) and QUOT
(close the single `iSupIndep` keystone leaf via ROUTE (b) only — the STUCK corrective). FBC gets **no
prover** this iter (route just swapped; dead-code cleanup + the `gstar_transpose` prover are iter-021).

## State at entry (iter-019 prover outcomes, verified this resume)

- **FBC** — build GREEN, 4 sorries: `base_change_mate_fstar_reindex_legs` @1333 (now-DEAD crux),
  `gstar_transpose` @1490 (Seam 3, now the LIVE crux), affine @1667, FBC-B @1707.
  `base_change_mate_domain_read` verified **axiom-clean** (`propext, Classical.choice, Quot.sound`);
  `section_identity` carries `sorryAx` only via `gstar_transpose`. The public `fstar_reindex` (1435)
  is referenced only in comments — confirmed orphaned.
- **GF** — build GREEN, 3 sorries: L4 finiteness leaf @754, `genericFlatnessAlgebraic` @1797, GF-geo
  @1864. L4 injectivity crux closed iter-019 (axiom-clean); helper `isLocalization_lift_injective`
  added + already blueprinted (`lem:gf_isLocalization_lift_injective` @chapter 541).
- **QUOT** — build GREEN, 5 sorries: 4 protected stubs (126/165/201/228) + the `iSupIndep` base-case
  leaf @1494. The SNAP-S2 keystone `gradedModule_hilbertSeries_rational` is assembled end-to-end;
  `subquotient_finite_transfer` (3-iter blocker) closed axiom-clean.

## Subagents dispatched this iter (8; all returned)

Prior-run (pre-reset), consumed on resume:
- **progress-critic `iter020`** — FBC STUCK (refactor), GF CHURNING (pace; same-session L4+dévissage),
  QUOT STUCK (metric artifact, 1 terminal leaf; route-(b)-only restriction). Dispatch sanity OK.
- **mathlib-analogist `fbc-mate`** (cross-domain) — root cause = proof-parametrised codomain legs;
  recommended legs-free / conjugate-side telescoping. `analogies/fbc-mate-legreindex.md`.
- **blueprint-writer `quot-iter020`** — base-case `lem:graded_subquotient_base_eventuallyZero`
  (route-(b) discipline) + 16 coverage-debt blocks + 6 `\mathlibok` anchors; leandag clean.
- **refactor `fbc-decouple-legs`** (interrupted) — landed the domain-read route swap (the substantive
  FBC win this iter). **refactor `fbc-legfree`** (interrupted) — intended binder-drop did NOT land
  (no harm).

This-run (post-reset):
- **blueprint-writer `fbc-reroute`** — deleted the 3 phantom blocks (`_eCancel`/`_affineUnit`/
  `_innerMatch`, pinning non-existent decls), marked the `fstar_reindex` apparatus superseded, made the
  domain-read route authoritative for `section_identity`; leandag `unknown_uses:[]`, no broken pins.
- **blueprint-clean `quot`** — 7 edits stripping Lean leakage from the new QUOT blocks; route (a)/(b)
  kept as concise math remarks; citations verbatim-verified.
- **blueprint-reviewer `iter020`** — **QUOT `complete:true correct:true`, 0 must-fix → GATE OPEN**; FBC
  route-swap coherent, `gstar_transpose` the live crux; DAG structurally clean.

## Decision made

### 1. FBC — accept the refactor's route swap; no prover this iter; cleanup+prove iter-021
- **Why:** the interrupted `decouple-legs` refactor genuinely solved the 6-iter STUCK Seam-2 wall — not
  by closing the crux, but by **rendering it unnecessary**: `base_change_mate_domain_read` (axiom-clean)
  + the existing `codomain_read` give `section_identity` directly modulo Seam-3 `gstar_transpose`. This
  IS the progress-critic's STUCK corrective (a structural refactor), executed. Re-attempting the
  `fstar_reindex` crux is now forbidden (dead code).
- **Why no FBC prover this iter:** the file is mid-transition (dead code present; chapter just
  reconciled). The clean next step is (a) a dead-code-removal refactor, then (b) a prover on
  `gstar_transpose` — both iter-021. Dispatching a prover onto a file with a just-swapped route and
  lingering dead code risks confusion. The route swap is itself this iter's FBC deliverable.
- **Trade-off:** 1-iter latency to the `gstar_transpose` prover vs. a clean handoff. Cheap signal to
  reverse: if iter-021 finds `gstar_transpose` is itself a multi-iter wall, revisit whether the
  domain-read route truly reduces the difficulty (vs. having relocated it).

### 2. GF — enforce same-session L4-finiteness + dévissage start (CHURNING corrective)
- The critic's CHURNING is pace-based (0.25 sorries/iter), not approach-based; the recipe is concrete.
  The corrective is to stop the "close a crux then scope out" flatline: the objective now requires
  closing L4 finiteness AND proving ≥1 `genericFlatnessAlgebraic` dévissage step in the same session.

### 3. QUOT — route-(b)-only restriction (STUCK metric-artifact corrective)
- The STUCK verdict is a file-level-sorry-count artifact (50 sorry-free helpers + the deliberate
  keystone-assembly leaf). The practical state is 1 terminal leaf with a confirmed-viable route. The
  corrective is a hard prohibition on route (a) (`liftQ` scalar-ring dead end) and a concrete route-(b)
  sketch (dfinsupp destructuring + degree-n component, no outgoing map). Dispatched accordingly.

## Disproof / soundness checks
- **FBC route-swap soundness:** verified `base_change_mate_domain_read` axiom-clean (no `sorryAx`);
  verified `section_identity`'s only `sorryAx` path is `gstar_transpose`; verified the public
  `fstar_reindex` is consumed by nothing live (grep → comments only). The refactor did not weaken any
  protected/public signature (build green, no importer breakage).
- **No new axioms** (blueprint-doctor + reviewer `axiom_decls:[]`).

## Subagent skips
- **strategy-critic:** skipped. STRATEGY.md edits this iter are estimate/route-prose refreshes for the
  FBC route swap (which a fresh refactor + the analogist + the progress-critic already validated as the
  correct structural corrective) plus GF/SNAP estimate updates — no new route, no decomposition change,
  no new fork. Last verdict (iter-016) SOUND, no live challenge. Re-running it on an unchanged strategic
  skeleton (same Goal, same phases, same routes) would be a hollow dispatch.
- **strategy-auditor:** not dispatched — no major new phase/route started (the FBC route swap is within
  the existing FBC-A phase; GF/QUOT continue existing routes).

## Tool substitutions
- None. (`archon-informal-agent.py` remains unavailable — no API key in env — but was not needed; the
  recipes are blueprint/analogist-sourced.)
