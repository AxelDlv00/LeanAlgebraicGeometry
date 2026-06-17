# Progress-critic directive — iter-226

Assess convergence of ONE active route. Strict context: only the signals below.

## Route: A.1.c.SubT.dual — sheaf internal-hom / ⊗-group-law substrate
File: `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`
Strategy `Iters left` for this phase: **~6–12**. Phase entered at **iter-219** (elapsed **7**).

### Last 5 iters' signals
- **iter-221**: project sorry 80→80 (file 3→3). PARTIAL. Helpers added: ~6 (presheaf dual
  `PresheafOfModules.dual` + eval helpers). Blocker phrase: "Over.map pseudofunctor coherence".
- **iter-222**: project sorry 80→81 (file 3→4). PARTIAL — STUBBED a naturality `sorry` into
  `internalHomEval`. Helpers: 2. Blocker phrase: "whnf heartbeat bomb".
- **iter-223**: 81→81. PARTIAL/BLOCKED — no close; re-characterized the bomb (wrongly) as
  goal-wide. Helpers: 0 (prover reverted own edits). Blocker phrase: "whnf bomb goal-wide".
- **iter-224**: 81→80 (file 4→3). SOLVED — closed the iter-222 stub (`internalHomEval`
  naturality). NOTE: the bomb was STALE (a Mathlib bump removed it); 81→80 only closed a stub
  the build itself introduced. Helpers: 0 net. Blocker phrase: "stale diagnosis".
- **iter-225**: 80→80. PARTIAL mechanically; PRIMARY success bar met. Built `Scheme.Modules.dual`
  axiom-clean (no-sorry infra). Built the descended eval `dual_eval` then REMOVED it — it was
  sorry-transitive through `isLocallyInjective_whiskerLeft_of_W` (L641) = the d.2 stalk-⊗ gap.
  Helpers: 1 (`dual`). Blocker phrase: "sorry-transitive through d.2".

### Key structural facts (for your read, not extra context to police)
- The project sorry counter has NOT moved DOWN on genuine new content since iter-217. The
  iter-224 81→80 closed a stub the build had introduced in iter-222.
- Sub-steps 1–4 of the dual block are retired; sub-step 5 (`exists_tensorObj_inverse`, the
  80→79 mover) remains.
- iter-225 review framed the next move as a FORCED FORK: (1) pivot to building d.2, or
  (2) escalate the RR-pause/divisor fork to the user.

### Planner's proposed iter-226 objective (dispatch-sanity input)
THIS iter the planner is NOT building d.2 and NOT idling. The planner found a THIRD path the
review's fork missed: the blueprint already designs `exists_tensorObj_inverse` and the associator
via **direct gluing through the CLOSED `tensorObj_restrict_iso`** (d.2-free), and the
`exists_tensorObj_inverse` docstring confirms the local→global contraction uses the closed
restrict-iso + unit-iso, with `Linv := dual L` (now nameable). The remaining ingredients are
(a) `dual_isLocallyTrivial`, (b) a `SheafOfModules` morphism/iso-descent gluing lemma — both
believed d.2-free. Proposed iter-226 plan: dispatch a `mathlib-analogist` consult on the
descent/gluing idiom (running in parallel with you), then a `blueprint-writer` for the d.2-free
re-route section, then (fast-path) a `mathlib-build` prover on the descent ingredient. ONE Lean
file (`TensorObjSubstrate.lean`); cap respected.

## What I need
Per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) with the named corrective TYPE if
not CONVERGING. In particular: is pursuing the d.2-free re-route (consult → blueprint → descent
ingredient) a sound corrective, or is this route STUCK in a way that warrants the RR-fork pivot
instead? Dispatch-sanity check on the proposed objective.
