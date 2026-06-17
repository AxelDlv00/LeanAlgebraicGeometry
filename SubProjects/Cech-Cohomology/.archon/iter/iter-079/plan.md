# iter-079 plan — CAPSTONE CLOSED via refactor signature-thread; project math content complete

## Situation (reconciled ground truth)
- Project-wide real inline sorries = **ONE**: frozen user-owned `cech_computes_higherDirectImage`
  (CHDI:780), FALSE as signed, unprovable as a lane.
- The capstone `cech_computes_higherDirectImage_of_affineCover` (`CechToHigherDirectImage.lean`) was a
  fully-written **0-sorry** assembly that did NOT type-check: producer-call at L207 lacked `[S.IsSeparated]`
  + `hres`. Confirmed first-hand vs producer sig `CechTermAcyclic.lean:699–705`.
- plan-validate's 0-sorry noop-trap had DROPPED this `prove` objective in iters 077/078/079
  (AUTO_NOTES this iter) → no prover ever ran on it. The block was OPERATIONAL, not mathematical.
- 3 leandag "ready-to-prove" frontier nodes have NO open sorries (done-pending-`\leanok`-sync) — not
  prover work. Coverage debt = 0 (injected graph).

## Decision made
- **Tool choice: refactor subagent, not a prover.** A 0-sorry-but-ill-typed file is a structural
  signature change, exactly the refactor subagent's domain (write-domain `**`, dispatched directly,
  bypasses plan-validate's noop-trap). A `prove` lane keeps getting dropped (0 sorries) and would quit
  even if it ran. Cheapest reversal: if the thread didn't compile, re-dispatch refactor with the
  diagnostic. Outcome: COMPLETE in one dispatch, LSP 0 errors / 0 sorries.
- **Carry `[X.IsSeparated]` explicitly (Option B), do NOT drop+derive it.** The producer
  `cechTerm_pushforward_acyclic` itself carries `[X.IsSeparated]`; carrying it in the consumer too is
  guaranteed to type-check (no fragile `haveI` derivation). This is the iter-078 strategy-critic's
  SANCTIONED fallback — the redundancy (X-sep ⟸ f-sep + S-sep) is recorded in STRATEGY prose, so the
  minimality challenge stays addressed. Blueprint prose edited to carry `[X.IsSeparated]` explicitly,
  keeping Lean↔blueprint consistent. Risk weighed: forgoing minimal-hypothesis aesthetics for a
  one-shot compile of the project's final deliverable — correct trade at the finish line.
- **No prover dispatch this iter** (mechanical hard gate: only the frozen unprovable sorry remains). The
  substantive work happened in the plan phase (refactor). review-build gate confirms the capstone next.

## Actions
- refactor `thread-affinecover`: added `[S.IsSeparated]` + `hres` param, forwarded `(hres n)` (L210),
  docstring updated → LSP 0 errors/0 sorries. Verified the landed edit (L198–210).
- Blueprint: aligned `lem:cech_computes_cohomology_affineCover` prose to carry `[X.IsSeparated]`.
- STRATEGY: moved P5b assembly → Completed; active table now just a light Polish row + "math complete".
- TO_USER bullet 1: capstone PROVED; named full frozen-decl relaxation (`h𝒰`,`[X.IsSeparated]`,
  `[S.IsSeparated]`,`hres`). PROGRESS/task_pending/task_done updated.

## Subagent skips
- strategy-critic: STRATEGY route unchanged (Route A; consumer-thread already decided iter-078). Prior
  verdict `capstone-iter078` was a CHALLENGE, ADDRESSED — and Option B (carry `[X.IsSeparated]`) is that
  challenge's own sanctioned fallback, so no live challenge. Re-blessing the identical route is hollow.
- progress-critic: the consumer lane had NO prover trajectory to assess (plan-validate dropped it every
  iter; producer completed iter-078). The "stall" was operational, not convergence — and I took the
  corrective (refactor, not another prover re-dispatch). No new prover output exists to extrapolate from.
- blueprint-reviewer: only edit was a tiny conservative prose change (carry `[X.IsSeparated]` explicitly)
  to a chapter whose HARD GATE already PASSED (`gate078`, complete+correct, 0 must-fix); the edit ADDS a
  hypothesis (strictly safer for the reader) and matches the Lean. No prover dispatched this iter, so the
  prover HARD GATE does not apply. No must-fix finding is live.
