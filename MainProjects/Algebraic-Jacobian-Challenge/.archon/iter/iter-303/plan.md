# iter-303 plan — RESUME prover after the iter-272–302 DAG/blueprint hiatus

## Situation
- Last real prover round: **iter-271**. Iters 272–302 ran no prover phase — they were a
  blueprint-completion + DAG-connectivity arc culminating in iter-302's USER-directed
  "connect everything": lean-aux 54→0, ∞-nodes 2→0, components 20→1 (932-node single
  cone), 0 broken `\uses`. blueprint-reviewer iter302 = HARD GATE CLEARS, 0 must-fix.
- `lake build` this phase = **exit 0** (green). `last_lake_build.log` was empty (stale);
  I re-ran to confirm. Files were left compilable at iter-271 and only `.tex` changed since.
- Git history is squashed to 2 commits, so no per-iter sorry deltas from git; I read sorry
  state directly from the files.

## Key state findings
- `DualInverse.lean`: `sliceDualTransportInv` already extracted top-level (L273, typechecks
  per ts271); `invFun` wired holes 4→3. ~11 real sorries in the dual cluster.
- `TensorObjSubstrate.lean`: `sheafificationCompPullback_comp_tail` exists (L2536). ~14 real
  sorries incl. the ready tensor-iso cluster (jw_ismonoidal, pullback0_tensor_iso, etc.).
- `CechHigherDirectImage.lean`: 4 sorries; `pushPullMap_comp` blocked DEFINITIONALLY (kernel
  whnf on eqToHom over-triangle transports), per ts265.
- `FlatteningStratification.lean`: 7 typed sorries (generic flatness + flat-locus chain),
  frontier-ready, blueprinted, RR-free (Stacks 052B).
- `LineBundleCoherence.lean` + `SheafOverEquivalence.lean`: **locally sorry-free** — the grep
  "sorry" hits were comment text only; the engine coherence root `chartOverIso` closed
  iter-258/259. No lane needed (corrects an earlier read where raw `grep -c sorry` looked nonzero).

## Decision made
**4 prover lanes**, all on the A.2.c/A.1.c critical path, no A.3+, no Route C:
1. `DualInverse.lean` [fine-grained] — close `sliceDualTransport` invFun + round-trips.
2. `TensorObjSubstrate.lean` [fine-grained] — `sheafificationCompPullback_comp_tail` (analogist
   `conjugateEquiv_whiskerLeft` route) + ready tensor-iso nodes.
3. `CechHigherDirectImage.lean` [mathlib-build] — generalized eqToHom-cancellation → `pushPullMap_comp`.
4. `FlatteningStratification.lean` [mathlib-build] — `genericFlatness` (Stacks 052B) bottom-up.

**Why these four:** lanes 1–2 are the deepest open sub-roots (A.1.c.sub) the bottom-up USER
directive mandates first; they are surgically scoped with recipes (`analogies/d3-mate271.md`,
the corrected dual prose) and now full reviewer-certified blueprint proofs for the formerly-∞
nodes. Lanes 3–4 weight the A.2.c engine (the strategy's dominant rate-limiter), are
import-independent of the Picard substrate (true parallelism per the USER directive), and are
RR-free.

**Why NOT more lanes (PARALLELISM directive weighed):**
- `QuotScheme.smooth_proper_curve_projective` — classically RR-dependent (embed via a
  high-degree divisor), would risk pulling the permanently-paused Route C. Deferred until a
  theorem-level RR-disjointness check at A.2.c entry. `quot_reduction_to_pi_star_W` alone is
  not clearly RR-free either; whole file held this iter.
- `RelPicFunctor.lean` — `rel_pic_etale_sheaf_unit_canonical` is frontier-ready but the
  functor's group/functorial bodies are gated cross-file on the dual chain (lanes 1–2). Premature.
- Quality over quantity: two deep mathlib-build engine lanes (3, 4) already saturate the
  "blind-ish skeleton" budget; adding a third deep skeleton lane risks an iter of typed-sorry churn.

**Reversal signal:** if lanes 1–2 close this iter, next iter opens RelPicFunctor (group inverse
now unblocked) and the Quot engine (after the RR-disjointness check). If lane 3's option-b hits
the kernel wall again, escalate to the refactor subagent (option a, transport-light `pushPullMap`).

## Handling the live iter-271 CHURNING/STUCK verdicts
pc271 reported DUAL=CHURNING, D3′=STUCK. Per the stuck-protocol these are must-fix and forbid
"another helper round." My response is NOT a re-dispatch of the same lane with a reworded recipe:
- The iter-271 correctives (the `sliceDualTransportInv` top-level extraction; the analogist
  `conjugateEquiv_whiskerLeft` route) were **devised but never executed** — the prover round that
  would run them never happened (the loop diverted to 31 DAG iters). This iter is their **first
  execution**.
- Additionally, both targets now carry **full, reviewer-certified informal proofs** in the
  blueprint (written iter-302) that did not exist at iter-271 — a genuine new input, not cosmetic.
So this is the concrete corrective the protocol demands (recipe + blueprint-expansion), executed,
not deferred. If after THIS iter (the first real attempt at the correctives) the lanes still don't
move, the next planner escalates: refactor subagent for the D3′ left-adjoint wrapping / a
mathlib-analogist cross-domain consult for the dual ε-transport.

## Subagent skips
- blueprint-reviewer: iter302 whole-blueprint review (today) HARD-GATE-CLEARS all 4 target
  chapters (`correct: true`, 0 must-fix); no chapter edited since that review. Dispatcher skip
  condition met.
- progress-critic: prior 31 iters ran no prover phase ⇒ no new trajectory data (dispatcher skip
  condition "prior iter ran no prover phase"). The live iter-271 CHURNING/STUCK verdicts are
  handled above by first-time corrective execution + new blueprint proofs, not by ignoring them.
- strategy-critic: STRATEGY.md SHA-unchanged since iter-272; prior verdict SOUND with no live
  CHALLENGE/REJECT (the lone caveat — re-run the Pic≅Cl disjointness check at the THEOREM level
  when the A.4 Route-1 cone acquires that edge — is a future-deferred note, not a live challenge,
  and A.4 is not dispatched this iter).

## STRATEGY.md
Left unchanged (SHA stable since iter-272). Routes/decomposition/estimates are unaffected by a
resumption iter; the blueprint-complete milestone is recorded in the iter-302 dag sidecar and
PROGRESS, not a strategy change. Will refresh the A.1.c.sub iters-left/velocity cells once this
iter's prover trajectory provides real data.
