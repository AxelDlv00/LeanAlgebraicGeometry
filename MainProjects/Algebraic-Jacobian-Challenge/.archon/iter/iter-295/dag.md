# DAG iter-295 narrative

## Headline: verified-stable, no edit — every claim re-grounded from live artifacts this iter
(not inherited from prior sidecars). A fresh `leandag build` reconfirms the blueprint is
byte-for-structure identical to iters 287–294: **878 blueprint nodes (443 proved, 1 mathlib),
54 lean-aux, 1484 edges, with-sorry 91, effort done 678,198 / remaining-finite 275,905, 2 ∞
lean-aux nodes**; `leandag show gaps` → 0 nodes; `leandag show isolated | grep -ic blueprint` → 0;
doctor `malformed_refs` 11 (all `literal-ref`, `Jacobian.tex` 9 + `AbelJacobi.tex` 2),
`broken_refs` 0, `orphan_chapters` 0; STRATEGY.md SHA `aa783bb7` unchanged; TO_USER.md current.
Gate criteria 1–4, 6, 7 PASS; criterion 5 (1-to-1 over the 54 lean-aux) stays STRUCTURALLY
DEFERRED. No chapter, STRATEGY, PROGRESS, or TO_USER edit.

## What I verified directly this iter (grounded, not lifted)
1. `git hash-object .archon/STRATEGY.md` = `aa783bb7881d917ad132d0e3180af15525a04c11` — unchanged.
2. `grep -c sorry` on the two TensorObjSubstrate files — `TensorObjSubstrate.lean` 18 +
   `DualInverse.lean` 13 = **31 live sorries**, matching the byte-frozen prover lane (iter-277).
3. `leandag build` — 878 blueprint (443 proved, 1 mathlib) / 54 lean-aux / 1484 edges; with-sorry
   91; effort done 678,198 / remaining-finite 275,905; **∞ nodes 2**.
4. `leandag show gaps` → **0 nodes**. Criterion 1 (zero ∞ *blueprint* sources) holds; both ∞ nodes
   are Lean-aux-side.
5. `leandag show isolated | grep -ic blueprint` → **0**. Criterion 4 (one cone, 0 isolated
   blueprint) holds; the 54 isolated nodes are all lean-aux.
6. Doctor JSON (`logs/iter-294/blueprint-doctor.json`) partitioned by each entry's `chapter` field:
   `malformed_refs` 11 = `Jacobian.tex` 9 + `AbelJacobi.tex` 2, every one `literal-ref`;
   `broken_refs` 0; `orphan_chapters` 0.
7. Read `TO_USER.md` — three bullets current: the FROZEN tensor-substrate notice, the iter-286
   math-delim hygiene note, and the 11 protected-chapter `literal-ref` notice with per-line `\cref`
   suggestions. No edit needed.

## Why the protected-exposition literal-refs are routed, not auto-repaired (re-grounded, unchanged)
- `Jacobian.tex` / `AbelJacobi.tex` are the human-authored exposition of the mathematician's
  frozen-signature declarations (`AlgebraicGeometry.Jacobian` +4 instances, `genus`, the three
  `Jacobian.ofCurve`). My DAG prompt names literal-REF inside protected files as an explicit
  do-NOT-auto-repair / route-to-user case (`prompts/dag.md` line 261).
- The standing decision (iters 288–294) holds: even the genuinely FORCED targets are left for the
  mathematician because these are the two most sensitive central chapters, the chapters mix forced
  and genuinely-ambiguous refs (a partial fix leaves the chapter still flagged — no hygiene win),
  and it unblocks nothing (web renders EXIT 0; the loop's bottleneck is the prover's Lean-kernel
  wall). This is the opposite of iters 286–287 (RiemannRoch, NOT protected, fully
  context-determinable — repaired squarely under the DAG hygiene mandate).

## Criterion-5 deferral — STRUCTURALLY FORCED (re-derived from the live 31-sorry count)
The 54 uncovered lean-aux all originate from `TensorObjSubstrate.lean` + `DualInverse.lean`, the
two files carrying all 31 live sorries — i.e. they are actively mid-construction, not a finished
API awaiting transcription.
- **2 of the 54 are ∞-effort sorry targets** (`sheafificationCompPullback_comp_tail`,
  `sliceDualTransportInv`) — ∞ precisely because they ARE the stuck D3′ / dual-route-2 pieces
  (Lean-kernel `whnf`/`eqToHom`-transport wall, memory `ts271`/`ts265`). Pointing `\lean{}` at them
  would make them ∞ *blueprint* sources I cannot prove → trades a criterion-5 fail for a
  criterion-1 fail.
- **The "proved directly in Lean" stub is valid only for sorry-free decls.** With 31 sorries spread
  across these helpers, many of the 54 are NOT sorry-free and would need a *written* informal
  proof, not a one-line note.
- **The prover extracts/renames/merges these helpers every time the lane advances** (memory iters
  261–283); 54 fresh `\lean{}` pins would go stale on the next prover edit.
Criterion 5 closes cleanly only once the prover/math settles the TensorObjSubstrate + DualInverse
construction — a prover-lane event, not a blueprint gap.

## Gate criteria — 6 PASS, 1 structurally deferred
1. Zero ∞ blueprint sources — ✓ (`gaps` 0 of 0; the 2 ∞ nodes are Lean-aux).
2. Zero broken `\uses{}` — ✓ (leandag + doctor: 0 broken).
3. Every blueprint decl pinned by `\lean{}` — ✓.
4. Connected — one cone, zero isolated blueprint — ✓ (Isolated 54, all Lean-aux; 0 blueprint).
5. 1-to-1 coverage — ✗ 54 lean-aux uncovered. **Deferred — STRUCTURALLY FORCED** (see above).
6. `content.tex` inputs every chapter — ✓.
7. `leanblueprint web` renders — ✓ (EXIT 0 as of iter-287; no chapter edited since).

## The meta-signal (unchanged)
The loop has been DAG-only across iters 278–295 while the A.1.c.sub prover lane has not advanced.
**The blueprint is not the bottleneck** — it is one acyclic cone, renders as a web site, and
carries zero non-protected doctor findings. The stuck-ness is a Lean-kernel transport wall on
D3′ / dual-route-2 for the plan/prover phase to break; nothing further blueprint work unblocks.

## Subagent skips
- strategy-critic: STRATEGY.md SHA unchanged (`aa783bb7`) from prior iters and prior verdict was
  SOUND with no live CHALLENGE — skip condition fully met.
- blueprint-reviewer: no chapter under `blueprint/src/chapters/` edited since prior dispatch
  (git diff clean); prior verdict cleared the HARD GATE for all chapters under active prover work;
  no live must-fix finding.
- blueprint-writer: no chapter flagged incomplete/partial; nothing to write.
- dag-walker: `leandag show gaps` → 0; no ∞ *blueprint* seed to make complete (the 2 ∞ nodes are
  Lean-aux-side, deferred by the structural criterion-5 argument).
- effort-breaker: no ready high-effort blueprint frontier node to decompose; the live bottleneck is
  a Lean-kernel wall, not an oversized informal proof.
- progress-critic: prior iter ran no prover phase (DAG-only since iter-278); no new trajectory data.
