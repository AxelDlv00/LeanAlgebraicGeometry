# Iter-160 plan-agent run

## Headline outcome

Iter-160 is the **HARD-GATE-clear + bridge-2 prover-launch iter**. The iter-159 prover lane
returned exactly as predicted: `[IsAlgClosed kbar]` sig change + `hfib` (axiom-clean) + docstrings
landed, and bridge 2 (the agreement equation) was **extracted into a new named top-level helper**
`rigidity_eqOn_saturated_open_to_affine` (sorry body, route-B docstring). The Rigidity-Lemma chain
now has exactly **one** residual `sorry` — the bottom helper — with everything above it
`sorry`-free in its own body.

The iter-159 review flagged ONE must-fix blocking the prover lane: the new helper had no `\lean{}`
block / `\uses` edge, so the `\leanok`-tagged chain proofs rendered fully-proven in the dependency
graph despite the transitive `sorryAx` (marker-graph laundering). This iter closed that via the
**sanctioned same-iter fast path**, which took TWO writer rounds because the first introduced a
backward-edge 2-cycle:

1. `blueprint-writer avr-helper` — added the `lem:rigidity_eqOn_saturated_open_to_affine` block
   (`\label`+`\lean{}`+route-B two-step proof prose, reusing the existing Mumford verbatim quote)
   + a `\uses` edge + refreshed the stale "two residual sorries" decomposition remark.
2. `blueprint-reviewer avr-recheck` (scoped) → **`correct: PARTIAL`**: the new `\uses` edges pointed
   BACKWARD (`dense_open ⟷ saturated_open` 2-cycle) and `thm:rigidity_lemma` had no `\uses` edge at
   all, so the headline STILL laundered. Clean catch — the writer's first pass was mechanically
   present but graph-incorrect.
3. `blueprint-writer avr-uses-fix` — rebuilt the edges forward (`rigidity_lemma`(proof)→`dense_open`,
   `dense_open`(proof)→`saturated_open`, `saturated_open` a leaf), removing the cycle and
   propagating the leaf `sorry`'s not-proven status up to both upstream nodes.
4. `blueprint-reviewer avr-recheck2` (scoped) → **HARD GATE CLEARS**: `complete:true`+`correct:true`,
   forward-acyclic chain, headline de-laundered, signature/route-B prose/citations all intact, no
   new must-fix.

Then the prover lane fires at `rigidity_eqOn_saturated_open_to_affine` via cohomology-free route B.

## Subagent verdicts (absorbed)

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| progress-critic | avr-trajectory | **CONVERGING** | "add helper → close it or isolate next honest residual" is genuine convergence (2/3 helpers closed axiom-clean; the 3rd IS the named residual, not new debt). Firing the prover at the helper via route B is correct; no escalation. **Forward-watch (not must-fix):** cube + Riemann–Roch entirely unstarted = dominant downstream cost; re-estimate the `~10–18` full-arm figure for OVER_BUDGET drift once the chain closes. |
| blueprint-writer | avr-helper | COMPLETE | New helper block + `\uses` + remark refresh; reused existing Mumford quote (no new fabrication). |
| blueprint-reviewer | avr-recheck | **PARTIAL (must-fix)** | Backward `\uses` 2-cycle + headline still laundering. Prescribed the exact forward-edge fix. |
| blueprint-writer | avr-uses-fix | COMPLETE | Forward acyclic edge set; headline de-laundered; cycle removed. |
| blueprint-reviewer | avr-recheck2 | **PASS — HARD GATE CLEARS** | Chapter complete+correct, no must-fix; prover lane cleared this iter. |

## Decision made

**Fire the prover at `rigidity_eqOn_saturated_open_to_affine` via route B; do NOT pivot, do NOT
open a cube/RR lane, do NOT spend a lane on cosmetic GrpObj docstrings.**

- **Why route B / no pivot.** The route-(c) commitment is unchanged and progress-critic CONVERGING.
  The helper is TRUE-as-stated (every hypothesis load-bearing; blueprint-reviewer confirmed
  signature-faithful + non-vacuous), so no disproof pass is warranted — spend the budget. Route B
  (per-closed-slice constancy + dense-closed-points globalisation) is the analogist-vetted,
  cohomology-free assembly; the relative Stein / `f_*O=O` framing is a confirmed Mathlib gap and is
  explicitly off-limits.
- **Single deep lane (no throttling).** The only file with productive sorry work is AVR (the helper);
  the other open sorries are gated/deferred (cube+RR scaffolds; `Jacobian`/`RigidityKbar` downstream).
  So one focused deep lane is correct, not artificial throttling.
- **GrpObj docstring cleanup deferred.** The iter-159 lean-auditor flagged 2 stale docstrings in
  `Cotangent/GrpObj.lean` (0 live sorries, cosmetic). It unblocks nothing downstream; per "avoid
  shallow objectives unless they unblock something" it is NOT worth a parallel prover lane + a
  lean-vs-blueprint re-review this iter. Folded into a future mechanical lane.
- **LOC/risk.** Route B is the analogist's ~1–2 iter estimate; PARTIAL is a legitimate deep-lane
  outcome. The directive permits landing new named sub-lemmas (Step 1 per-slice constancy; Step 2
  dense-closed-points hom-ext) as clean top-level `sorry`-bearing decls if they don't close.
- **Cheapest reversal signal.** If the prover reports that Step 2's "dense-closed-points ⟹ hom-ext"
  connective itself needs a Mathlib gap (not just a bespoke build), OR Step 1's slice-integrality
  cannot be derived from the `(X⊗Y)` instances, escalate to a mathlib-analogist consult before the
  next prover round (mirrors the iter-158 binding fallback).

## Soundness check (done, not deferred)

Before committing the deep-lane budget I confirmed `rigidity_eqOn_saturated_open_to_affine` is not a
false target: the iter-159 review + this iter's blueprint-reviewer both verified the signature is
faithful and every hypothesis (`[IsAlgClosed]`, `IsProper X.hom`, `GeometricallyIrreducible (X⊗Y)`,
`IsReduced (X⊗Y).left`, `IsSeparated Z.hom`, saturation `_hUV`, affine `U₀`, containment `_hfU`) is
load-bearing and applied non-vacuously. The math is exactly Mumford's "for each `y∈V`, the complete
variety `X×{y}` maps into the affine `U₀`, hence to a single point" — sound. No counterexample pass
needed.

## Subagent skips

- strategy-critic: STRATEGY.md unchanged since iter-157 (route (c) committed + reaffirmed sound;
  no pivot, no estimation change >30% this iter); the iter-157 CHALLENGE was addressed and is not
  live; iters 158/159 likewise skipped on the same stable-strategy ground. The progress-critic's
  cube/RR OVER_BUDGET caution is a forward-watch (revisit once the chain closes), not a current
  strategy change.

## Notes / FYI for the user (surfaced via review → TO_USER.md)

- The genus-0 Rigidity-Lemma chain is now one `sorry` from done (`rigidity_eqOn_saturated_open_to_affine`).
  Closing it makes `rigidity_lemma` fully proven + axiom-clean — a shared asset that also feeds
  Route A's Albanese UP. The dominant remaining route-(c) cost (theorem of the cube + Riemann–Roch)
  is still entirely unstarted; the `~10–18` iters-left estimate is honest but untested against that
  heaviest segment. Override by adding a hint to USER_HINTS.md if you want the cube blueprinted in
  parallel now rather than after the chain closes.
