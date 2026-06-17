# DAG iter-293 narrative

## Headline: verified-stable, no edit — every claim re-grounded from live artifacts this iter
(not inherited from the prior sidecar). A fresh `leandag build` reconfirms the blueprint is
byte-for-structure identical to iters 287–292: **878 blueprint nodes, 54 lean-aux, 1484 edges,
gaps 0, isolated-blueprint 0, 2 ∞ lean-aux nodes**; doctor `malformed_refs` 11 (all `literal-ref`,
`Jacobian.tex` 9 + `AbelJacobi.tex` 2), `broken_refs` 0, `orphan_chapters` 0; STRATEGY.md SHA
`aa783bb7` unchanged. Gate criteria 1–4, 6, 7 PASS; criterion 5 (1-to-1 over the 54 lean-aux)
stays STRUCTURALLY DEFERRED. No chapter edited; TO_USER.md already current.

## What I verified directly this iter (grounded, not lifted)
1. `leandag build` — 878 blueprint (443 proved, 1 mathlib) / 54 lean-aux / 1484 edges; with-sorry
   91; effort done 678,198 / remaining-finite 275,905; **∞ nodes 2**.
2. `leandag show gaps` → **0 nodes**. Criterion 1 (zero ∞ *blueprint* sources) holds; both ∞ nodes
   are Lean-aux-side.
3. `leandag show isolated | grep -ic blueprint` → **0**. Criterion 4 (one cone, 0 isolated
   blueprint) holds; the 54 isolated nodes are all lean-aux.
4. Doctor JSON (`logs/iter-292/blueprint-doctor.json`) — partitioned by reading each entry's
   `chapter` field: `malformed_refs` 11 = `Jacobian.tex` 9 + `AbelJacobi.tex` 2, every one
   `literal-ref`. `broken_refs` 0, `orphan_chapters` 0.
5. `git hash-object .archon/STRATEGY.md` = `aa783bb7881d917ad132d0e3180af15525a04c11` — unchanged.
6. Read `TO_USER.md` directly — the literal-ref notice is present and accurate (per-line `\cref`
   suggestions: AbelJacobi L68 → `thm:nonempty_jacobianWitness`; Jacobian L631/L469-chap/L630-thm
   forced; L459 + the four-instance ranges = mathematician's call; L612/614 no-action
   comment-quote). No edit needed.

## Why the protected-exposition literal-refs are routed, not auto-repaired (re-grounded, unchanged)
- `Jacobian.tex` / `AbelJacobi.tex` are the human-authored exposition of the mathematician's
  frozen-signature declarations (`AlgebraicGeometry.Jacobian` +4 instances, `genus`, the three
  `Jacobian.ofCurve`). My DAG prompt names literal-REF inside protected files as an explicit
  do-NOT-auto-repair / route-to-user case.
- I re-examined whether to break the standing decision and apply just the FORCED targets (AbelJacobi
  L68, Jacobian L631/L469-chap/L630-thm). I declined: (a) these are the two most sensitive central
  chapters and editing the mathematician's prose on my reading of context is exactly the risk the
  routing rule guards against; (b) the chapters are a *mix* of forced and genuinely-ambiguous refs
  (L459, the two four-instance `Theorems~REF--REF` ranges), so a partial fix leaves the chapter
  still flagged — no hygiene win, just a thrash; (c) it unblocks nothing — the web already renders
  EXIT 0 and the loop's bottleneck is the prover's Lean-kernel wall, not blueprint display. This is
  the opposite of iters 286–287 (RiemannRoch, NOT protected, fully context-determinable — repaired).

## Criterion-5 deferral — STRUCTURALLY FORCED (re-derived from the live topology)
The 54 uncovered lean-aux all originate from `TensorObjSubstrate.lean` + `DualInverse.lean` and are
reported by `leandag show isolated` as isolated with **0 of them blueprint**.
- **2 of the 54 are ∞-effort sorry targets** (`sheafificationCompPullback_comp_tail`,
  `sliceDualTransportInv`) — ∞ precisely because they ARE the stuck D3′ / dual-route-2 pieces
  (Lean-kernel `whnf`/`eqToHom`-transport wall, memory `ts271`/`ts265`). Pointing `\lean{}` at them
  would make them ∞ *blueprint* sources I cannot prove → trades a criterion-5 fail for a
  criterion-1 fail.
- **The other 52 are Lean-internal monoidal-coherence scaffolding** (`restrictScalars_μ_app_tmul`,
  `pushforward_μ_eq`, `dualUnitRingSwapHom`, …) below the granularity of the consolidated
  `Picard_TensorObjSubstrate.tex`, which already blueprints the file's public theorems. The prover
  constantly extracts/renames/merges them (memory iters 261–283), so blueprinting them now goes
  stale on the next prover edit. The lane is frozen because STUCK, not done.
Criterion 5 closes cleanly only once the prover/math settles those two declarations.

## Gate criteria — 6 PASS, 1 structurally deferred
1. Zero ∞ blueprint sources — ✓ (`gaps` 0 of 0; the 2 ∞ nodes are Lean-aux).
2. Zero broken `\uses{}` — ✓ (leandag + doctor: 0 broken).
3. Every blueprint decl pinned by `\lean{}` — ✓ (Needs `\lean{}` 0).
4. Connected — one cone, zero isolated blueprint — ✓ (Isolated 54, all Lean-aux; 0 blueprint).
5. 1-to-1 coverage — ✗ 54 lean-aux uncovered (TensorObjSubstrate + DualInverse). Deferred —
   STRUCTURALLY FORCED (see above). Untouched this iter.
6. `content.tex` inputs every chapter — ✓ 38/38.
7. `leanblueprint web` renders — ✓ (EXIT 0 since iter-287; no chapter edited since).

## The meta-signal (unchanged)
DAG-only across iters 278–293 while the A.1.c.sub prover lane has not advanced. The blueprint is
not the bottleneck — one acyclic cone, renders as a web site, zero non-protected doctor findings.
The stuck-ness is a Lean-kernel transport wall on D3′ / dual-route-2 for the plan/prover phase to
break; nothing further blueprint work unblocks.

## Subagent skips

- strategy-critic: STRATEGY.md SHA `aa783bb7` unchanged from iter-292 and prior verdict was SOUND
  with no live CHALLENGE/REJECT.
- blueprint-reviewer: no chapter under `blueprint/src/chapters/` edited since prior dispatch; prior
  verdict cleared the HARD GATE for all chapters under active prover work; no live must-fix finding.
- blueprint-writer: no chapter flagged incomplete by the prior review; nothing to write.
- blueprint-clean: no blueprint-writer round this iter, so nothing to clean.
- dag-walker: 0 ∞ *blueprint* sources (`leandag show gaps` empty); no incomplete cone to walk.
- effort-breaker: no ∞ blueprint node to decompose and no prover lane to feed a frontier break.
- progress-critic: the prover phase ran no new prover work (DAG-only, lane byte-frozen since
  iter-277); no new trajectory data to assess.
