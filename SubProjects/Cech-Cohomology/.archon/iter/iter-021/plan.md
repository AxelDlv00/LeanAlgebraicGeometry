# Iter-021 plan — execute the CHURNING corrective (free-complex differential match); close P3 step c+d

## Entering state (verified)
iter-020 ran all 3 lanes: +18 axiom-clean decls, 0 new sorries, build GREEN, 3 named sub-targets landed
(`cechFreeEval_X`, `cechFreeEval_quasiIso_of_isEmpty`, `qcohSectionsAwayLocalized`) + the `FreeCechEngine.*`
combinatorial engine + the CechBridge contravariant-transport infra (file now 0 sorries). Project sorry = 2
(superseded relative-form `CechAcyclic.affine` line 109; frozen P5b `CechHigherDirectImage.lean:679`).
STRATEGY.md SHA-unchanged from iter-020.

## What I did this iter (plan phase)
1. Processed iter-020 results (task_done/task_pending updated; 3 prover result files cleared; lean-auditor
   + 3 lvb reports consumed). lean-auditor: 0 must-fix on Lean; 2 majors (stale FreePresheafComplex
   docstring — prover already fixed it; FreeCechEngine/CombinatorialCech duplication — see D3). lvb:
   FreePresheafComplex 2 must-fix (private-name refs + unblueprinted FreeCechEngine), CechAcyclic 3 major,
   CechBridge 4 major — ALL blueprint-side.
2. **progress-critic `iter021`**: Route 1 (CechAcyclic) CONVERGING (SLIPPING — close c+d this iter);
   **Route 2 (FreePresheafComplex) CHURNING** (`cechFreeComplex_quasiIso` not landed in 3 iters). The
   must-fix corrective it named — blueprint-expand the differential-match sub-lemma + dispatch the prover
   on that specific step — is exactly D1. A 3rd setup-only return → escalate to mathlib-analogist on
   `HomologicalComplex.Homotopy` packaging idioms.
3. **blueprint-writer `iter021`** (consolidated chapter): cleared coverage debt 24→0; added the CHURNING
   corrective node `lem:cech_free_eval_engine_iso` (differential match) + `lem:free_cech_engine` (the 9
   FreeCechEngine decls); purged every private-`CombinatorialCech.*` ref from the free-eval proofs;
   corrected `lem:section_cech_homology_exact` to `ab_exact_iff` + a 3-sub-lemma chain
   (`sectionCechProductEquiv`/`sectionCechCofaceMatch`/`sectionCechAbExact`); added the 3 CechBridge
   coverage blocks + the `injective_cech_acyclic` assembly path. No strategy-modifying findings.
4. **blueprint-clean `iter021`**: purity pass (2 Lean-syntax leak fixes, 4 process-verbosity strips);
   both new `% SOURCE QUOTE` blocks verified verbatim against `references/stacks-cohomology.tex` L1236–1268.
5. **blueprint-reviewer `iter021`** (whole blueprint, HARD GATE, fast path): all 3 chapters
   `complete:true correct:true`; all 5 directive items confirmed resolved; **HARD GATE CLEARS both
   FreePresheafComplex.lean and CechAcyclic.lean**. (One note: PROGRESS.md must say `ab_exact_iff` not
   `moduleCat_exact_iff` for step (c) — incorporated.)
6. Wrote PROGRESS.md (2 lanes), task ledgers, this sidecar.

## Decision made

### D1 — Execute the CHURNING corrective on Route 2 (not a re-dispatch of the same lane).
Route 2 is CHURNING (named target absent 3 iters). The sanctioned response is a concrete corrective, not
another reworded recipe. The corrective: the genuine bottleneck is the **differential match** (evaluated
alternating-face differential ↔ `FreeCechEngine.combDifferential` on coproduct injections), which until now
was buried inside `lem:cech_free_eval_prepend_homotopy`'s prose. I promoted it to its own blueprint node
`lem:cech_free_eval_engine_iso` with a real proof sketch (`Sigma.hom_ext` + `PreservesCoproduct.iso`
naturality + `cechFreeSimplicial` reindexing) and dispatch the prover at THAT specific small node first
(then nonempty case → glue, all mechanical given the engine). This is the progress-critic's named
corrective verbatim. Cheapest reversal signal: a 3rd setup-only return ⇒ escalate to mathlib-analogist on
`HomologicalComplex.Homotopy` packaging (already queued in PROGRESS.md next-iter plan).

### D2 — Drop CechBridge as a prover lane this iter.
CechBridge is 0 sorries; its only open target `injective_cech_acyclic` is gated on Route 2's not-yet-existing
`cechFreeComplex_quasiIso`, so a lane would be an immediate noop (and the bridge infra is already complete).
Excluded from objectives. It re-enters the moment the quasi-iso lands (one-step op-transport assembly, path
now blueprinted). Only 2 lanes this iter — both have genuine, gate-cleared work; no artificial throttling.

### D3 — Keep the FreeCechEngine/CombinatorialCech duplication (do NOT de-privatize).
lean-auditor flagged the 9-lemma duplication as MAJOR, recommending de-privatizing `CombinatorialCech.*`
in CechAcyclic.lean so FreePresheafComplex can import them. REJECTED for this iter: de-privatizing means a
refactor touching BOTH active lane files mid-convergence (CechAcyclic drops `private` on 9 decls;
FreePresheafComplex deletes 9 working axiom-clean decls + re-imports) — real risk to the working engine
that the differential-match build depends on THIS iter, for a pure code-cleanliness gain that does not
block the cone. The duplication is now honestly blueprinted (`lem:free_cech_engine` with a `% NOTE:`
recording the tradeoff). Revisit as a polish-phase refactor once P3b closes. The sole project goal is
closing the protected cone; duplication doesn't obstruct it.

## Subagent skips
- strategy-critic: STRATEGY.md SHA-unchanged from iter-020, prior verdict SOUND with no live CHALLENGE
  (iter-019's P5a-oversell CHALLENGE was accepted+addressed; the P5a deferred-bridge is an OPEN question,
  not a live challenge, and is off this iter's P3/P3b critical path). All routes are pure execution +
  blueprint repair this iter — no strategic route/decomposition change.
- strategy-auditor: no major new phase/route started; same two execution lanes.

## Risks / watch
- Route 2 differential-match is genuinely hard (chain/coproduct dual of the section-side cochain id). If
  the prover lands the engine-iso node but not the full quasi-iso, that is still convergence (residual
  shrinks to the mechanical nonempty packaging). A 3rd round with NO engine-iso progress = escalate (D1).
- Route 1 SLIPPING: aim to close c1–c3 + step (d). If only c1–c2 land, revise P3 iters-left upward.
