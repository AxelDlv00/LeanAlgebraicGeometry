# DAG iter-294 narrative

## Headline: verified-stable + ONE new grounding — I tested the criterion-5 deferral against
live `sorry` counts instead of re-inheriting it. A fresh `leandag build` reconfirms the blueprint
is byte-for-structure identical to iters 287–293: **878 blueprint nodes (443 proved, 1 mathlib),
54 lean-aux, 1484 edges, with-sorry 91, effort done 678,198 / remaining-finite 275,905, 2 ∞
lean-aux nodes**; `leandag show gaps` → 0; `leandag show isolated | grep -ic blueprint` → 0;
doctor `malformed_refs` 11 (all `literal-ref`, `Jacobian.tex` 9 + `AbelJacobi.tex` 2),
`broken_refs` 0, `orphan_chapters` 0; STRATEGY.md SHA `aa783bb7` unchanged; TO_USER.md current.
Gate criteria 1–4, 6, 7 PASS; criterion 5 (1-to-1 over the 54 lean-aux) stays deferred. No
chapter, STRATEGY, PROGRESS, or TO_USER edit.

## The discipline this iter: I tried to BREAK the deferral, not just re-confirm it
The loop has been DAG-only-stable for 7 iters with criterion 5 the sole open gate item. Rather
than write an 8th identical "stable, no-op", I set out to test whether closing criterion 5 (cover
the 54 lean-aux → declare COMPLETE → stop the loop) is achievable this iter. The path would be a
`dag-walker`/`blueprint-writer` at the (non-protected) consolidated `Picard_TensorObjSubstrate.tex`
adding entries for all 54: "proved directly in Lean" stubs for the sorry-free ones, informal
sketches for the rest. I checked feasibility against the live `.lean` before dispatching anything.

## Why the attempt is premature — NEW artifact grounding (not inherited)
`grep -c sorry` on the two files that emit all 54 lean-aux:
- `AlgebraicJacobian/Picard/TensorObjSubstrate.lean` — **18 sorry**
- `AlgebraicJacobian/Picard/TensorObjSubstrate/DualInverse.lean` — **13 sorry**
- **31 live sorries total**, matching the byte-frozen prover lane (iter-277, 31 sorries).

This is the decisive fact prior iters asserted from memory but did not re-derive: the two files
are *actively mid-construction*, not a finished API awaiting transcription. Consequences for the
cover-it-now path:
1. The "proved directly in Lean" stub is valid ONLY for sorry-free decls. With 31 sorries spread
   across these helpers, many of the 54 are NOT sorry-free, so they would need a *written informal
   proof*, not a one-line note.
2. The 2 ∞ lean-aux (`sheafificationCompPullback_comp_tail`, `sliceDualTransportInv`) have neither
   sorry-free Lean nor a settled informal proof — that absence is *why* they are stuck (Lean-kernel
   `whnf`/`eqToHom`-transport wall, memory `ts271`/`ts265`). Pinning `\lean{}` at them makes them ∞
   *blueprint* sources I cannot prove → trades a criterion-5 fail for a criterion-1 fail.
3. The prover extracts/renames/merges these helpers every time the lane advances (memory iters
   261–283); 54 fresh `\lean{}` pins would go stale on the next prover edit.

So the deferral is structurally forced, now re-grounded from the live 31-sorry count rather than
lifted from the prior sidecar. Criterion 5 closes cleanly only once the prover/math settles the
TensorObjSubstrate + DualInverse construction — a prover-lane event, not a blueprint gap.

## What I verified directly this iter (grounded, not lifted)
1. `leandag build` — 878 blueprint / 54 lean-aux / 1484 edges; with-sorry 91; ∞ nodes 2.
2. `leandag show gaps` → 0 nodes. Criterion 1 (zero ∞ *blueprint* sources) holds.
3. `leandag show isolated | grep -ic blueprint` → 0. Criterion 4 (one cone, 0 isolated blueprint).
4. Doctor JSON (`logs/iter-293/blueprint-doctor.json`) partitioned by `chapter`: `malformed_refs`
   11 = `Jacobian.tex` 9 + `AbelJacobi.tex` 2, all `literal-ref`; `broken_refs` 0; `orphan` 0.
5. `git hash-object .archon/STRATEGY.md` = `aa783bb7881d917ad132d0e3180af15525a04c11` — unchanged.
6. Read `TO_USER.md` — literal-ref notice present and accurate (per-line `\cref` suggestions).
7. `grep -c sorry` on the two TensorObjSubstrate files — 18 + 13 = 31 (NEW this iter).

## Why the protected-exposition literal-refs are routed, not auto-repaired (unchanged)
`Jacobian.tex` / `AbelJacobi.tex` are the human-authored exposition of the mathematician's
frozen-signature declarations (`AlgebraicGeometry.Jacobian` +4 instances, `genus`, the three
`Jacobian.ofCurve`). My DAG prompt (line 261, read verbatim) names literal-REF inside protected
files as an explicit do-NOT-auto-repair / route-to-user case. TO_USER.md carries the exact
per-line `\cref` targets; the user applies them (their file, their call). This is the opposite of
iters 286–287 (RiemannRoch, NOT protected, context-determinable — repaired by the DAG agent).

## Gate criteria — 6 PASS, 1 structurally deferred
1. Zero ∞ blueprint sources — ✓ (`gaps` 0; the 2 ∞ nodes are lean-aux).
2. Zero broken `\uses{}` — ✓ (0).
3. Every blueprint decl pinned by `\lean{}` — ✓ (Needs `\lean{}` 0).
4. Connected — one cone, 0 isolated blueprint — ✓ (54 isolated, all lean-aux).
5. 1-to-1 coverage — ✗ 54 lean-aux uncovered (TensorObjSubstrate + DualInverse, 31 live sorries).
   **Deferred — STRUCTURALLY FORCED**, re-grounded this iter from the live sorry count.
6. `content.tex` inputs every chapter — ✓ 38/38.
7. `leanblueprint web` renders — ✓ (EXIT 0 as of iter-287; no chapter edited since).

## The meta-signal (unchanged, re-grounded)
The loop has been DAG-only across iters 278–294 while the A.1.c.sub prover lane has not advanced
(31 sorries, byte-frozen since iter-277). The blueprint is not the bottleneck — it is one acyclic
cone, renders as a web site, and carries zero non-protected doctor findings. The stuck-ness is a
Lean-kernel transport wall on D3′ / dual-route-2 for the plan/prover phase to break; nothing
further blueprint work unblocks. Criterion 5 closes when that lane settles.

## Subagent skips
- strategy-critic: STRATEGY.md SHA unchanged (`aa783bb7`) from iter-293 and prior verdict was SOUND
  with no live CHALLENGE.
- blueprint-reviewer: no chapter under `blueprint/src/chapters/` edited since its prior dispatch
  (web/DAG byte-identical since iter-287); prior verdict cleared the hard gate; the only live
  doctor finding is the routed protected literal-refs (not a blueprint-reviewer must-fix).
- blueprint-writer: no chapter flagged for writing/extension; the sole open item (54 lean-aux) is a
  deferred prover-lane coverage gap, not a prose gap.
- dag-walker: 0 ∞ *blueprint* sources and 0 isolated *blueprint* nodes — no blueprint cone to walk;
  the 2 ∞ nodes are lean-aux deferred for the reason above.
- effort-breaker: no ∞ *blueprint* node to decompose.
- progress-critic: prior iter ran no prover phase (DAG-only), so there is no new trajectory data.
