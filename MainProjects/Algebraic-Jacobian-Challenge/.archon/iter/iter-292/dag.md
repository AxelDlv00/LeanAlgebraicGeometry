# DAG iter-292 narrative

## Headline: verified-stable, no edit — every claim re-grounded from source this iter (not
inherited). A fresh `leandag build` reconfirms the blueprint is byte-for-structure identical to
iters 287–291: **878 blueprint nodes, 54 lean-aux, 1484 edges, gaps 0, isolated-blueprint 0, 2 ∞
lean-aux nodes**; doctor `malformed_refs` 11 (all `literal-ref`, `Jacobian.tex` 9 + `AbelJacobi.tex`
2), `broken_refs` 0, `orphan_chapters` 0; STRATEGY.md SHA `aa783bb7` unchanged. Gate criteria
1–4, 6, 7 PASS; criterion 5 (1-to-1 over the 54 lean-aux) stays STRUCTURALLY DEFERRED. No chapter
edited; TO_USER.md already current. The discipline this iter was to verify the artifacts directly
rather than trust the prior narrative (the iter-291 lesson).

## What I verified directly this iter (grounded, not lifted)
1. `leandag build` + `leandag stats` — 878 blueprint / 54 lean-aux / 1484 edges; Proved 443
   (50.5%); Ready 50; Needs `\lean{}` 0; Unmatched `\lean{}` 44; Isolated 54 (**0 blueprint**); ∞
   nodes 2; effort done 678,198 / remaining-finite 275,905.
2. `leandag show gaps` → **0 nodes**. Criterion 1 (zero ∞ *blueprint* sources) holds; both ∞ nodes
   are Lean-aux-side.
3. Doctor JSON (`logs/iter-291/blueprint-doctor.json`) — `malformed_refs` 11, partitioned by
   reading each entry's `chapter` field: `Jacobian.tex` 9 + `AbelJacobi.tex` 2. `broken_refs` 0,
   `orphan_chapters` 0.
4. **`git hash-object .archon/STRATEGY.md`** = `aa783bb7881d917ad132d0e3180af15525a04c11` — unchanged.
5. **Read `.archon/prompts/dag.md` directly** (NOT the injected summary). Line 261 verbatim:
   *"Doctor findings inside protected files (literal-REF, math-delim, undefined macros, …): do NOT
   auto-repair. List them in `TO_USER.md` for the mathematician to fix — their file, their call."*
   This is the grounded basis for routing the 11 literal-refs, replacing the inherited paraphrase.
6. **Read `TO_USER.md`** — 3 concise bullets, the literal-ref notice present and accurate (per-line
   `\cref` suggestions: AbelJacobi L68 → `thm:nonempty_jacobianWitness`; Jacobian
   L631/L469-chap/L630-thm forced; L459 + four-instance ranges = mathematician's call; L612/614
   no-action comment-quote). No edit needed.

## Why the protected-exposition literal-refs are routed, not auto-repaired (re-grounded)
- `Jacobian.tex` / `AbelJacobi.tex` are the human-authored exposition of the mathematician's
  frozen-signature declarations (`AlgebraicGeometry.Jacobian` +4 instances, `genus`, the three
  `Jacobian.ofCurve`). dag.md line 261 names literal-REF inside protected files as an explicit
  do-NOT-auto-repair / route-to-user case. Even the genuinely FORCED targets are left for the
  mathematician because these are the most sensitive chapters and the standing decision (iters
  288–291) is consistent; the user has the exact suggestions in TO_USER.md and can apply them in
  seconds. This is the opposite of iters 286–287 (RiemannRoch, NOT protected, context-determinable
  — squarely the DAG hygiene mandate, repaired).

## Criterion-5 deferral — STRUCTURALLY FORCED, re-derived from the live topology
The 54 uncovered lean-aux all originate from `TensorObjSubstrate.lean` + `DualInverse.lean` and are
reported by `leandag show isolated` as **Isolated (no edges) 54 — 0 of them blueprint**. That
topology is the proof the deferral is structural, not laziness:
- **2 of the 54 are ∞-effort sorry targets** (`sheafificationCompPullback_comp_tail`,
  `sliceDualTransportInv`) — ∞ precisely because they ARE the stuck D3′ / dual-route-2 pieces
  (Lean-kernel `whnf`/`eqToHom`-transport wall, memory `ts271`/`ts265`). Pointing `\lean{}` at them
  would make them ∞ *blueprint* sources I cannot prove → trades a criterion-5 fail for a
  criterion-1 fail.
- **The other 52 are Lean-internal monoidal-coherence scaffolding** (`restrictScalars_μ_app_tmul`,
  `pushforward_μ_eq`, `dualUnitRingSwapHom`, …). They have NO edges into the blueprint goal cone
  because the public-theorem blueprint proofs (already in the consolidated
  `Picard_TensorObjSubstrate.tex`) are written at a mathematical level that elides them.
  Blueprinting them would either leave them ISOLATED *blueprint* nodes (criterion-4 fail) or force
  Lean-implementation scaffolding into mathematical proof prose that doesn't naturally cite it. The
  current state — these live Lean-aux-side, the blueprint cone stays clean — is the *correct*
  representation. The lane is FROZEN (no `.lean` commit since iter-277), so the helpers are stable,
  but stable-and-internal is still below the roadmap granularity; if the prover breaks the wall via
  a different route they get refactored away.
Criterion 5 closes cleanly only once the prover/math settles those two ∞ declarations — a
Lean-kernel transport wall, not a blueprint gap.

## Gate criteria — 6 PASS, 1 structurally deferred
1. Zero ∞ blueprint sources — ✓ (`gaps` 0 of 0; the 2 ∞ nodes are Lean-aux).
2. Zero broken `\uses{}` — ✓ (leandag + doctor: 0 broken).
3. Every blueprint decl pinned by `\lean{}` — ✓ (Needs `\lean{}` 0).
4. Connected — one cone, zero isolated blueprint — ✓ (Isolated 54, all Lean-aux; 0 blueprint).
5. 1-to-1 coverage — ✗ 54 lean-aux uncovered (TensorObjSubstrate + DualInverse).
   **Deferred — STRUCTURALLY FORCED** (see above; re-derived from live `leandag show isolated`).
6. `content.tex` inputs every chapter — ✓ (38 chapters; unchanged).
7. `leanblueprint web` renders — ✓ (EXIT 0 as of iter-287; no chapter edited since, so unchanged).

## The meta-signal (unchanged, re-affirmed)
The loop has been DAG-only across iters 278–292 while the A.1.c.sub prover lane sits on a Lean-kernel
transport wall. **The blueprint is not the bottleneck** — it is one acyclic cone, renders as a web
site, and carries zero non-protected doctor findings. Nothing further blueprint work unblocks the
wall; it is the plan/prover phase's to break (or the user's to steer via `USER_HINTS.md`, as the
TO_USER.md banner already offers).

## Subagent skips

- strategy-critic: STRATEGY.md SHA `aa783bb7` unchanged from iter-291 and prior verdict was SOUND
  with no live CHALLENGE/REJECT — its skip conditions are all met.
- blueprint-reviewer: no chapter under `blueprint/src/chapters/` edited since its prior dispatch
  (DAG byte-stable 878/54/1484 across iters 287–292; no commit touches a chapter since `f1a6833`),
  prior verdict cleared the gate, and no live must-fix finding remains.
- blueprint-writer: nothing flagged for a writer — no reviewer must-fix is live, the only doctor
  class (literal-ref) is in protected-exposition chapters routed to the user, and the criterion-5
  gap is structurally deferred (not a writer task).
- dag-walker / effort-breaker: no ∞ *blueprint* source, no isolated *blueprint* node, and no
  untranscribed dependency — `leandag show gaps` is empty and the only ∞ nodes are Lean-aux sorry
  targets with no informal proof to walk/break.
- progress-critic: dag phase has no prover objectives to gate, and the prover lane committed no new
  `.lean` output since iter-277 — no new trajectory data to assess.
