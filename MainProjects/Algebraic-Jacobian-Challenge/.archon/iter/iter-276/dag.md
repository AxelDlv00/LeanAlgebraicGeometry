# DAG iter-276 narrative

## Headline: the "123 lean-aux" debt was a stale cache — live count is 54, all in the two prover-lane files edited today. Net structural gain: isolated blueprint 3 → 2.

The injected DAG_STATUS (iter-275) and the start-of-iter `.leandag` cache both
reported **123 uncovered `lean-aux`**, framed as "stable remainder covered, only
the churning TensorObj lane left." A fresh `leandag build` this iter contradicts
that: the true live count is **54**, and all 54 are in the two files the prover
lane edited **today** (`TensorObjSubstrate.lean` 40 + `DualInverse.lean` 14). The
69 internal-hom / stalk-tensor / vestigial helper blocks the prior status listed
as the "stable remainder to cover" are **already on disk and matched** — they were
added in uncommitted prior-iter work whose leandag rebuild never landed (the
iter-274 sidecar admits its post-writer rebuild "never ran"), so the 123 figure
was carried forward stale across iters 274→275. Trusting `leandag` over the
narrative (as the prompt directs) was the whole game this iter.

## What I did

1. **Mapped the 123 to source files** off the live `.leandag/dag.json`: a clean
   split into 69 stable (PresheafInternalHom 32 / StalkTensor 24 / Vestigial 13,
   all 0-sorry, untouched since 2026-06-01) + 54 churning (TensorObjSubstrate.lean
   40 / DualInverse.lean 14, both edited 2026-06-04, carrying the live sorries).
   The mtime split is the exact discriminator the standing deferral criterion
   asks for ("cover once the lane stabilises").
2. **Dispatched `blueprint-writer` (tensorobj-stable276)** to cover the 69 stable
   decls in the consolidated `Picard_TensorObjSubstrate.tex`, with an explicit
   scope boundary excluding the two churning files. It returned COMPLETE with
   **no edits**: all 69 already have exactly one `\lean{}` pin, 0 isolated, 0
   unmatched — and its own `leandag build` reported lean-aux 54, conflicts [],
   unknown_uses 0. (The dispatch premise was stale, but the verification it
   produced is exactly what was needed: the stable coverage is genuinely done.)
3. **Dispatched `blueprint-reviewer` (certify276, whole-blueprint)** to certify the
   current live state, since the 69 blocks apparently never got a final reviewer
   pass on the present numbers and they back the chapter feeding the active
   DUAL/ENGINE lanes. Verdict: **HARD GATE CLEARS all active prover lanes;
   must-fix-this-iter none**; the three `*_helpers` subsections certified
   mathematically faithful, no dup pins, no Lean-syntax leak; 0 unstarted-phase
   proposals.
4. **Corrected the reviewer's single mistaken disposition and wired the last
   non-exempt isolated node.** certify276 proposed *removing*
   `lem:isiso_sheafification_map_of_W` as "orphaned scaffolding" — but it was
   misled by a stale in-file "pending deletion" comment. I checked Lean: the
   lemma is **load-bearing**, invoked by `tensorObj_assoc_iso` (line 346),
   `pullbackUnitIso` (1058), and `isIso_sheafifyDelta_unitPair_of_isIso_sheafifyEta`
   (1407). Removing its only blueprint block would have orphaned a proved Lean
   decl and *raised* uncovered lean-aux 54→55 — the wrong fix. Instead I **wired**
   it (a proved leaf with no `\uses{}` is a wiring bug, not a done node): added
   `\uses{lem:isiso_sheafification_map_of_W}` to its verified consumer
   `lem:tensorobj_assoc_iso`, and rewrote the stale comment to record it as
   load-bearing. `rdep_count` 0→1; **isolated blueprint 3 → 2**; lean-aux
   unchanged; 0 broken refs.

## leandag: before → after

```
                          iter-start (stale)   iter-end (live)
blueprint nodes                 811                811
lean-aux (uncovered)            123 → live 54       54
edges                          1387               1388  (+1 assoc→isiso)
isolated blueprint                3                  2   (−1; 2 remaining exempt)
∞ blueprint sources               0                  0
broken \uses{}                    0                  0
content.tex                    38/38              38/38
```

## Status decision

`in_progress`. Criterion 5 fails on the 54 churning-lane lean-aux (deferred);
criterion 4 has 2 reviewer-exempt off-path leaves. Criteria 1–3, 6 pass. The
roadmap is otherwise a complete, dependency-correct cone; criterion 5 closes when
`TensorObjSubstrate.lean` / `DualInverse.lean` stop churning (their sorry counts
stop moving), at which point one writer covers the 54 without immediate re-churn.
Name-drift maintenance afterward is the loop plan/review agents' repinning job
(cf. iter-271 `repin271`), not a dedicated DAG pass.

## Note on the stale-cache root cause (for the loop)

The 123→54 discrepancy traces to uncommitted blueprint work not being reflected in
committed leandag state plus a skipped post-writer rebuild back in iter-274. Each
DAG iter already rebuilds `leandag` first (per the prompt cadence), so the live
numbers are always authoritative — but the carried-forward narrative drifted for
two iters. No action needed beyond trusting the live rebuild (done); flagged here
so a future reader doesn't re-derive the phantom 123.

## Subagent skips

- strategy-critic: STRATEGY.md unchanged this iter (pure coverage-reconciliation +
  one `\uses{}` wire-up; no route/phase/estimate change); prior verdict SOUND with
  no live CHALLENGE. Skip condition met.
- progress-critic: this is a DAG phase with no prover-objective decision to gate
  and no new prover output to assess (prover trajectory is the loop plan agent's
  domain). Skip condition met.
- dag-walker: 0 ∞ blueprint sources (`dag-query gaps` = 0 of 0); the only
  remaining isolated blueprint nodes are the 2 reviewer-certified exempt off-path
  S3 leaves. The 54 isolated lean-aux are criterion-5 coverage debt (the active
  prover lane), not untranscribed blueprint dependencies — nothing for a
  cone-walker to wire. The one wire-able isolated node
  (`lem:isiso_sheafification_map_of_W`) I wired directly (single verified edge).
- blueprint-clean: no chapter received new prose/blocks this iter (the writer made
  no edits; my only edits were one `\uses{}` label addition and one comment
  correction — no Lean leakage possible), and no provers are dispatched by the DAG
  phase. Nothing to strip/validate.
