# Directive — progress-critic

Assess convergence of the two active routes the planner is considering for iter-052 prover dispatch.
Per-route signals (last 4–5 iters) below. Return a per-route verdict (CONVERGING / CHURNING / STUCK /
UNCLEAR) and, for any CHURNING/STUCK, the corrective TYPE.

## Route 1 — 02KG affine Serre vanishing (`CechAcyclic.lean` → `AffineSerreVanishing.lean`)
Strategy `Iters left` estimate (current): ~1. Phase entered its current ("residual leaf") form at iter-049.
- iter-047: keystone `qcoh_section_isLocalizedModule` landed (01I8 substep). sorry: 2→2.
- iter-048: 01I8 assembly `isIso_fromTildeΓ_of_quasicoherent` landed → `qcoh_iso_tilde_sections` unconditional. sorry 2→2. (+2 decls)
- iter-049: BOTH 02KG tops reduced to one residual `htilde` (+4 axiom-clean decls in `AffineSerreVanishing.lean`). sorry 2→2.
- iter-050: dispatched 0 provers (plan-validate parser bug dropped both objective lines). No prover output. sorry 2→2.
- iter-051: residual `htilde` SOLVED — `sectionCech_homology_exact_of_localizationAway` landed axiom-clean in `CechAcyclic.lean` (+3 public/private decls). status COMPLETE for that lane. sorry 2→2.
- iter-052 proposed objective: `AffineSerreVanishing.lean` — discharge the two unconditional tops (`affine_cech_vanishing_qcoh`, `affine_serre_vanishing`) by feeding the new theorem to the existing `_of_tildeVanishing` forms (mechanical, decls don't yet exist).

## Route 2 — P5a augmented Čech resolution (`CechHigherDirectImage.lean` → stalkwise-exactness criterion)
Strategy `Iters left` estimate (current): ~4–5. The `cechAugmented_exact` target was first dispatched iter-049.
- iter-049: `cechAugmented_exact` lane DISPATCHED but NEVER LAUNCHED (slot exhaustion; only 1 prover jsonl on disk). No output.
- iter-050: re-dispatched; 0 provers ran (same plan-validate parser bug). No output.
- iter-051: lane RAN. Built the augmented-complex OBJECT layer (+6 axiom-clean decls: `cechAugmentedComplex` + 5 companions). The exactness theorem `cechAugmented_exact` NOT added — blocked on a genuine Mathlib gap: no "complex of `X.Modules` exact iff stalkwise exact" reflection criterion. No sorry inserted. Status PARTIAL with a documented decomposition handoff (steps 1–2 = build the stalkwise-exactness criterion ~150–250 LOC; steps 3–4 reuse built infra).
- iter-052 proposed action: do NOT re-dispatch `cechAugmented_exact` as-is. Instead consult mathlib-analogist on the stalkwise-exactness route + write the blueprint for a new stalkwise-exactness criterion lane (prover next iter once gate-cleared). Possibly start the criterion as a new mathlib-build lane this iter if the route is crisp.

## This iter's PROGRESS.md `## Current Objectives` proposal (file count + basenames)
1 firm prover lane: `AffineSerreVanishing.lean` (discharge 02KG tops). Possibly a 2nd lane (`StalkwiseExact.lean` — new file, stalkwise-exactness criterion) IF the analogist route is crisp and the blueprint gate clears this phase.

## Questions
- Is Route 1 converging (residual landed; discharge is the last mechanical step)?
- Route 2 has 3 consecutive iters where `cechAugmented_exact` did not land (2 no-runs + 1 genuine-blocker partial). Is this CHURNING/STUCK, or is the iter-051 partial genuine forward progress (object layer built + a real Mathlib gap precisely identified)? Is "consult analogist + write blueprint for a separate stalkwise-criterion lane, defer the prover" the right corrective, or is a route pivot warranted?
