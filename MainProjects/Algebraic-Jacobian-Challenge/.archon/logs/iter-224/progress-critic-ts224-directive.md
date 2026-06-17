# Progress-critic directive — iter-224

You are auditing ONE active route for convergence. Fresh-context only: do not read
PROGRESS.md / STRATEGY.md / blueprint chapters. Below is everything you need.

## Route: A.1.c.SubT.dual — sheaf internal-hom / dual of 𝒪_X-modules
File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
Strategy estimate (verbatim from the phase row): **Iters left ~6–12**; route entered its current
phase (the funded dual build) at **iter-219**. Elapsed in-phase: **5** (iters 219–223).
Convergence is tracked by **sub-step retirement** (5 sub-steps: 1 value module, 2 presheaf
internalHom, 3 dual+eval morphism, 4 sheaf condition, 5 inverse object). Sub-steps 1–2 RETIRED
axiom-clean. Sub-step 3 has spanned iters 221→223 and is the focus below.

### Last 5 iters — extracted signals (project sorry count / status / what changed / blocker)
- **iter-219**: project sorry 80→80. PARTIAL. Built the value module (sub-step 1, 11 axiom-clean
  decls). Blocker: none (forward).
- **iter-220**: 80→80. PARTIAL. Assembled the presheaf `internalHom` (sub-step 2, 12 axiom-clean
  decls). Blocker: `Over.map` pseudofunctor coherence (solved in-step via `hom_app_heq`).
- **iter-221**: 80→80. PARTIAL. Built `dual` (axiom-clean, leanok'd) + `internalHomEvalApp` +
  5 eval helpers. Blocker: full `internalHomEval` morphism slipped — `Over.map` coherence in
  the `Hom.mk` naturality field.
- **iter-222**: 80→**81**. PARTIAL. SOLVED the `Over.map` coherence (`restr_map_homMk`,
  `dual_map_app_terminal`, `internalHomEvalApp_tmul` — axiom-clean) and ASSEMBLED `internalHomEval`
  — but its naturality field is a typed `sorry` (first upward sorry move of the build). Blocker:
  `whnf` heartbeat bomb, diagnosed as localized to `restr_map_homMk (𝟙_) f`.
- **iter-223**: **81→81**. PARTIAL / BLOCKED. NO new live decls (the prover reverted its own
  over-optimistic edits). Decisive negative finding: the iter-222 "localized bomb + 3 whnf-free
  routes" diagnosis is WRONG — the bomb is **goal-wide** `𝟙_`-`whnf` toxicity that fires on the
  FIRST rewrite of ALL three routes; `local irreducible` cannot shield it (toxicity is in
  Mathlib's `𝟙_` machinery). Confirmed the exact lemma a next route needs (`tensorUnit_map`),
  preserved the six-step reduction in-source. ~12 authoritative `lake env lean` bisection compiles.

### Recurring blocker phrases
- "whnf heartbeat bomb / `(deterministic) timeout at whnf, 200000 heartbeats`" (iters 222–223)
- "`Over.map` pseudofunctor coherence" (iters 220–221, SOLVED iter-222)
- Net project sorry has NOT moved DOWN since iter-217 (81→80); pinned at 81 across iters 222–223.

### This iter's (224) PROPOSED action — NOT a prover dispatch
The iter-223 plan **pre-committed** an escalation tripwire: "if iter-223 does not close the
naturality sorry, iter-224 MUST run a mathlib-analogist consult BEFORE any further dispatch — NOT
another helper round." iter-223 did not close it. So iter-224's proposal is:
- **No prover dispatch this iter.** Dispatch a **mathlib-analogist (api-alignment)** consult on the
  evaluation-morphism shape / whnf-free naturality discharge (`ts224dual`).
- Hold ready, pending the analogist verdict, the fallback recorded by the iter-223 review: **revert
  `internalHomEval` to ABSENT** (project sorry 81→80) so the build does not carry a stubbed morphism.

## What I need from you
1. Your convergence verdict for this route: CONVERGING / CHURNING / STUCK / UNCLEAR — with the
   distinction between "stuck on *closing* the naturality" vs "advancing on *understanding* it."
2. Whether the proposed action (analogist consult, no prover, hold the revert fallback) is the
   correct corrective TYPE for your verdict — or whether you'd push a different corrective
   (route pivot, blueprint expansion, structural refactor, or pulling the revert NOW).
3. A concrete tripwire for iter-225: under what observable outcome should the planner stop
   re-investing in closing this naturality and instead execute the revert-to-absent fallback
   (sorry 81→80) and move the lane's frontier elsewhere?
4. Dispatch-sanity: confirm the iter-224 proposal (0 prover files, 1 consult) is within norms.
