# Iter 046 — Plan (Quot-Foundations)

## TL;DR
1 critical-path prover lane (**QUOT annihilator characterization**, conditional f.g. version) + heavy
blueprint prep that makes GF + SNAP prover-ready for iter-047. STRATEGY updated (gap2 done, GF base-case
rerouted, format de-drifted). Coverage debt (4 blocks) cleared. FBC PARKED.

## Decision made — 1 lane, not 2+; FBC stays parked; GF/SNAP = blueprint only
- **Chosen:** dispatch ONLY the QUOT annihilator prover this iter. GF base case = effort-break (blueprint);
  SNAP = author chapter (blueprint). Both prover-ready iter-047 (real prepared parallelism, not manufactured
  churn).
- **Why not a 2nd prover lane:** GF base case + SNAP chapters were (re)written THIS iter → no fresh
  complete+correct blueprint-reviewer verdict (HARD GATE); rushing a prover onto a just-rerouted/just-authored
  blueprint = the low-quality-prover-work failure the gate exists to prevent. FBC parked (kill-criterion;
  off critical path). So 1 genuinely-ready lane. progress-critic blessed (dispatch OK).
- **Frontier-validation catch (load-bearing):** `lem:modules_annihilator_ideal` looked frontier-ready
  (all listed `\uses` leanok) but its engine `annihilator_isLocalizedModule_eq_map` requires `[Module.Finite
  Γ(X,U) Γ(F,U)]` — the f.g. of sections = the not-yet-proved G1 base case. The `\uses` under-declared it.
  Rescoped the lane to the CONDITIONAL version (f.g. as explicit hypothesis) per the Mathlib-gradient
  strategy: provable NOW + strictly more general; the finite-type-F form is discharged by G1 later. Blueprint
  statement updated to match (+ cross-ref to `lem:gf_qcoh_fintype_finite_sections`).

## Critic dispositions
- **progress-critic `iter046` CONVERGING / dispatch OK.** QUOT fresh frontier lane; FBC managed-park
  endorsed; GF effort-break = correct corrective. ACCEPTED.
- **strategy-critic `iter046` CHALLENGE×2 — BOTH ACCEPTED:**
  1. GF base case rerouted: "stalkwise-epi ⟹ Γ-epi" is false in general → **affine-qcoh exactness of Γ /
     exact-functor transport across the gap1/gap2 descent** (Stacks 01PB). Reflected in STRATEGY + the
     effort-breaker directive; the effort-breaker decomposed into 3 seams along that route.
  2. SNAP infra authored (`Picard_SectionGradedRing.tex`, 3-layer decomposition). Re-estimated 4–8 iters.
  - FBC parking ruled SOUND (bounded, off critical path). Format DRIFT fixed (STRATEGY 14.7→~13.3 KB,
    iter-NNN stripped from active cells, Risks cells one-lined).
- **blueprint-reviewer `iter046`:** annihilator CLEAR; coverage-debt + base-case + SNAP proposals all
  actioned this iter.

## Subagents dispatched
- read-only: blueprint-reviewer, progress-critic, strategy-critic (all 3 mandatory).
- write: effort-breaker `gf-basecase` (GF base case + 2 coverage-debt blocks), blueprint-writer `snap`
  (new SNAP chapter, spawned reference-retriever for `stacks-modules.tex`), blueprint-clean `iter046`.
- Plan-agent wiring: content.tex `\input` SNAP; QuotScheme `\uses` → SNAP assembly nodes; 2 FBC
  coverage-debt blocks (`def:keystone_adjR`, `def:keystone_beta`) written by hand + keystone `\uses` updated.

## Coverage debt — CLEARED
keystoneAdjR, keystoneBeta (FBC, by hand); finite_localizedModule_transfer,
gf_finite_sections_of_basicOpen_finite_cover (GF, effort-breaker). unmatched should drop 4→0 next sync.
