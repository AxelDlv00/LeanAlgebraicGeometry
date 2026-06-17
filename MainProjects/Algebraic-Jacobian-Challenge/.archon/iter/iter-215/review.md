# Iter-215 (Archon canonical) — review

## Outcome at a glance

- **The "sixth consecutive prover dispatch on the iter-209/210 ⊗-invertibility
  pivot (Lane TS, sole USER-permitted lane), in which the iter-215 pre-committed
  FINAL gate — close `isLocallyInjective_whiskerLeft_of_W`, count must DECREASE,
  else escalate iter-216 — was NOT met, but the prover closed the documented H2
  'REAL bottom gap' of the linchpin `tensorObj_restrict_iso` axiom-clean
  (`restrictScalarsRingIsoTensorEquiv`) and independently re-confirmed that every
  route to the gate sorry bottoms out multi-iter, so the gate's escalation branch
  is the honest outcome" iter.** The plan agent dispatched on the strategy-critic's
  locally-trivial-first close; the prover found that route is **not statable** at
  the lemma's general-site presheaf signature (`LineBundle.IsLocallyTrivial` cannot
  be stated for a general-site `F`) without a large re-signing that *still* needs
  the open `tensorObj_restrict_iso` — and turned its effort to the most
  self-contained reusable piece of the linchpin instead.

- **Build GREEN; 0 `axiom` declarations** (blueprint-doctor clean: no orphan
  chapters, all `\ref`/`\uses` resolve, no new `axiom`s). The new helper verifies
  `axioms = [propext, Quot.sound]` (no `sorryAx`) — independently re-run by the
  review agent. The L1040 `opaque` warning is the known comment-scan false positive
  ("opaque" appears in a docstring).

- **Sorry trajectory:** iter-214 **81** → iter-215 **81** (net **0**). TS-file
  code sorries **4 → 4** (no new sorries; the new decl is a sorry-free def).
  `sync_leanok` ran (iter 215, sha `c3361168`), **+0 / −0**, no chapters touched.

- **HARD BAR landing:** the assigned gate (decrease the count by closing
  `isLocallyInjective_whiskerLeft_of_W`) is **NOT met**. The linchpin's residual
  **shrank** — from "two Mathlib-absent ingredients (H1+H2)" to **H1 alone**
  (presheaf-level `pushforwardPushforwardAdj`, ≈100–150 LOC) + a ≈20-LOC packaging
  step. The PRIMARY GOAL (A.2.c via the group law) is not reached.

## The defining tension — the gate is unmet a 2nd time, and the escalation branch is now live

For the sixth window-iter the global counter is flat at 81. iters 211–214 each
landed true axiom-clean lemmas while the residual stayed a `sorry`; iter-215
continues the exact pattern (one more axiom-clean brick, residual unchanged). The
distinction this iter is process-shaped, not progress-shaped:

- **iter-214** ended with the progress-critic's explicit one-iter gate: close the
  residual this iter or escalate. **iter-215 did not close it.** The prover's own
  task result reaches the escalation branch ("the substrate is ready for USER
  escalation in iter-216 as planned"), and its reasoning is sound: the dispatched
  locally-trivial PRIMARY route is *not statable* at the lemma's signature, and the
  stalkwise FALLBACK needs the Mathlib-absent d.2 — neither can decrease the count
  without first closing an upstream multi-iter ingredient.
- So the honest read for the iter-216 planner is sharper than "stall #6": the
  pre-committed escalation trigger has fired. Two unmet gates on a ~6-iter-flat
  substrate is exactly the condition the gate was written to force a decision on.
  **The planner must explicitly choose escalate-to-USER vs. one bounded H1
  mathlib-build, and record the `## Decision made`.** A third helper round with no
  decision is the avoidance pattern.

Counterweight (why this is not pure churn): the residual is now *bounded and named*
for the first time in the window. H2 — the strong-monoidal `restrictScalars`-along-
a-ring-iso fact that prior iters listed as Mathlib-absent — is closed in-file,
axiom-clean, with a reusable proof recipe. The linchpin no longer rests on "two
absent ingredients"; it rests on one (H1) plus 20 LOC of packaging. That is genuine
forward knowledge, and it makes option (B) (fund the bounded H1 build) a defensible
alternative to escalation rather than a sunk-cost continuation.

## Process correctness

- **Prover route divergence was legitimate.** The dispatch named the
  locally-trivial close; the prover discovered that route is not statable at the
  general-site signature and pivoted to the linchpin's H2 piece. It did not silently
  abandon the gate — it reached and justified the gate's escalation branch, and
  documented the dead end (S-linear `lift` inverse → `SMulCommClass`/`CompatibleSMul`
  failure) so the next agent does not repeat it.
- **The new helper is genuine, not laundering.** lean-auditor ts215 traced every
  step (forward lift, additive inverse, both round-trips) and confirmed no hidden
  `sorry`/`admit`; the review agent re-ran `lean_verify` (`[propext, Quot.sound]`).
  The four pre-existing sorries are genuine typed sorries, unchanged.
- **Both highly-recommended review subagents dispatched** (lean-auditor ts215,
  lean-vs-blueprint-checker ts215); both **0 must-fix**.
- **Marker discipline honored.** sync_leanok owns `\leanok` (ran +0/−0); the review
  agent added only two `% NOTE:` semantic flags (H2-closure on `lem:tensorobj_restrict_iso`
  Step 3; assoc proof-route divergence on `lem:tensorobj_assoc_iso`). No `\mathlibok`
  (the helper is a project construction, not a Mathlib re-export); no `\lean{...}`
  rename; no stale `\notready`.

## Findings carried to recommendations

- **HIGH** — the iter-216 planner must make the escalate-vs-bounded-H1-build
  decision (gate unmet 2nd time).
- **HIGH** — do NOT re-dispatch `isLocallyInjective_whiskerLeft_of_W` on the same
  PRIMARY/FALLBACK routes without a structural change; the lever is upstream
  (`tensorObj_restrict_iso` via H1).
- **MEDIUM** — blueprint-writer dispatch needed (per lean-vs-blueprint-checker
  ts215): pin `restrictScalarsRingIsoTensorEquiv`, rewrite `lem:tensorobj_restrict_iso`
  Step 3 (H2 done / H1-only), align `lem:tensorobj_assoc_iso` proof sketch to the
  realized ROUTE (d). HARD-GATE prerequisite if a prover is sent at this chapter's
  files next iter.
- **LOW** — 5 stale docstrings in `TensorObjSubstrate.lean` (lean-auditor ts215)
  calling now-real defs "sorry/scaffold"; refresh in passing. Confirm
  `@[implicit_reducible]` (L1160) is a registered attribute.
- **LOW (ambiguity, not laundering)** — several chapters lack `\leanok` despite
  complete Lean bodies (lean-vs-blueprint-checker minor §4–7); sync_leanok's domain;
  sync ran +0/−0 for this tree, so flagged as a sync ambiguity for the planner, not
  a marker action for review.

## Subagent skips

(none — both highly-recommended review subagents were dispatched.)
