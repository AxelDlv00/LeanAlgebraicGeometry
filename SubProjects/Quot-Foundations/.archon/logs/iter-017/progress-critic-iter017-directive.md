# Progress-critic directive — iter-017

Assess convergence per active prover route. Verdicts feed the planner's stuck-protocol gate.
Three routes are candidates for this iter's prover dispatch.

## Route FBC — Cohomology/FlatBaseChange.lean  [proposed this iter: prove/fine-grained]
Phase FBC-A, entered ~iter-011. STRATEGY `Iters left`: 1–3.
Signals (last 4 iters):
- sorry count: iter-013 ?→ ; iter-014 5→4 (closed Seam 1 `base_change_mate_unit_value`);
  iter-015 4→4; iter-016 4→4.
- helpers added: iter-014 0 (closed Seam 1); iter-015 +1 (Seam-2 leg-id scaffold);
  iter-016 +1 `pullbackPushforward_unit_comp` (CLOSED, axiom-clean).
- prover statuses: iter-014 COMPLETE(Seam1); iter-015 PARTIAL; iter-016 PARTIAL.
- recurring blocker phrases: "conjugate calculus", iter-016 "rw [hfst]/[hsnd] motive is not type
  correct — legs in dependent positions (codomain_read type, gammaPushforwardIso, IsPullback.of_hasPullback)".
- each PARTIAL iter landed a NEW closed axiom-clean helper; the Seam-2 sorry persists because the
  legs sit in dependent positions. Documented next step: abstract `codomain_read` with the two legs as
  subst-able variables, then `subst` + Seam 1.

## Route GF — Picard/FlatteningStratification.lean  [proposed this iter: prove]
Phase GF-alg, entered ~iter-012. STRATEGY `Iters left`: 1–3.
Signals (last 4 iters):
- sorry count: iter-013 ?; iter-014 5→4 (closed `gf_torsion_reindex` +5 helpers);
  iter-015 4→5 (+1 descent helper); iter-016 5→4 (CLOSED `free_localizationAway_of_away_tower`).
- helpers added: iter-014 +5 (all closed); iter-015 +1 (sorry'd descent helper);
  iter-016 0 new (closed the iter-015 helper).
- prover statuses: iter-014 COMPLETE; iter-015 PARTIAL (helper accreted); iter-016 COMPLETE(helper).
- recurring blocker phrases: "OreLocalization instance-presentation diamond" between the IH output
  and the helper input (L5 steps 3–4). Now the SOLE L5 blocker, with two named resolution paths
  (align `gf_torsion_reindex`'s emitted instances; or restate the helper `hfree`).

## Route QUOT — Picard/QuotScheme.lean  [proposed this iter: mathlib-build, headline]
Phase SNAP-S2, Route-2 (ambient subquotient induction) entered iter-016. STRATEGY `Iters left`: 2–3.
Signals (last 4 iters):
- sorry count: 4→4→4→4 (4 downstream stubs, static).
- decls added: iter-015 +3 axiom-clean graded-API decls (D5 + G1 split); iter-016 0 (NO prover lane —
  route PIVOTED structurally to Route 2 after the progress-critic iter-016 CHURNING verdict).
- prover statuses: iter-015 PARTIAL (G2–G4 blocked by isDefEq/whnf kernel pathology); iter-016 no lane.
- recurring blocker phrase (pre-pivot): "isDefEq/whnf 2M-heartbeat runaway on DirectSum.Decomposition
  over quotient/subtype carrier". The iter-016 CHURNING corrective (mathlib-analogist consult + Route-2
  pivot + blueprint re-skeleton) is DONE. iter-017 dispatches the first Route-2 build lane (create 5
  `GradedModule.*` ambient-subquotient decls + the (⊤,⊥) bridge); the analogist showed Route 2 makes
  the runaway structurally impossible (no derived-carrier grading).

## Planner's proposed objectives this iter (3 files, import-independent)
1. QuotScheme.lean — mathlib-build the Route-2 graded-API (headline, post-CHURNING-pivot first build).
2. FlatteningStratification.lean — prove: fix the OreLocalization diamond to close L5; then L4 fold.
3. FlatBaseChange.lean — fine-grained, CONTINGENT on a blueprint-writer fixing the 2 lvb must-fix
   gaps + a fast-path re-review clearing FBC this iter; target = abstract-variable-legs Seam-2 restructure.

Give a per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and, for any CHURNING/STUCK, the
corrective TYPE. Run dispatch-sanity on the 3-file proposal.
