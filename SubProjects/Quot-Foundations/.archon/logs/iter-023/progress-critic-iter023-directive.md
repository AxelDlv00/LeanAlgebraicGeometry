# Progress-critic directive — iter-023

Assess convergence per active route from the signals below. You do NOT see STRATEGY.md or the blueprint by design.

## Route: FBC — base_change_mate_gstar_transpose (FlatBaseChange.lean)

The single live crux of the FBC lane. Signals (last 4 iters):

- Live sorry count (the gstar crux specifically): iter-019: 1, iter-020: 1, iter-021: 1, iter-022: 1.
  (File total FBC sorries = 4 throughout: 1 live gstar @1613 + 1 dead-code orphan @1421 + 2 deferred-downstream @1786/@1808 that are gated on gstar.)
- Prover dispatched on gstar: iter-019 (route established), iter-020 NO prover (route-swap plan iter), iter-021 PARTIAL, iter-022 PARTIAL.
- New top-level decls/helpers added per iter to close it: iter-021: 0 (2-rw reframing pin only), iter-022: 0 (conjugate-counit `set`/`have` scaffold landed inside the proof, compiles, no new decl).
- Recurring blocker phrase: "step 2–3 telescoping, ~150 LOC, inline derivation of `Γ_R(θ_in) = ρ`" — present iter-021 and iter-022.
- iter-022 prover landed: recipe step 1 (counit split + conjugate transport) fully formalized and compiles (`huce` master counit-transport identity). Remaining: step 2 (inline `Γ_R(θ_in)=ρ`) + step 3 (generator close).
- A lean-vs-blueprint-checker this iter flagged the gstar blueprint proof sketch as UNDER-SPECIFIED at step 2 (must-fix blueprint-adequacy gap) — the ~150-LOC inline telescoping is not described in the chapter.
- STRATEGY `Iters left` for FBC-A: 2–3 (post-swap baseline). Entered the gstar-crux sub-phase ~iter-020.

Planner's proposed corrective this iter: an effort-breaker decomposition of gstar step-2 into named sub-lemmas (the inline `Γ_R(θ_in)=ρ` sub-lemma + generator close) with their own blueprint blocks + `\uses`, then a fine-grained prover on the pieces. Assess whether this is the right corrective or whether the route should pivot.

## Route: GF — FlatteningStratification.lean

- GF-alg phase COMPLETED iter-022: `genericFlatnessAlgebraic` closed axiom-clean. File live sorry 2→1.
- The single remaining GF sorry is the geometric `genericFlatness` @2208 — a NEW sub-phase (GF-geo) with no prover attempt yet; its blueprint proof sketch (4-step finite-affine-cover) already exists.
- STRATEGY `Iters left` GF-geo: 1–2; the phase has not started.

## Planner's proposed objectives this iter (file count + basenames)

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — fine-grained prover on the gstar sub-lemmas (after effort-breaker + blueprint re-review).
- Possibly `AlgebraicJacobian/Picard/FlatteningStratification.lean` — either GF-geo prover OR a de-private/stale-comment refactor (mutually exclusive same-file).

Give per-route verdicts (CONVERGING / CHURNING / STUCK / UNCLEAR) + named correctives, and a dispatch-sanity check on the proposed objectives.
