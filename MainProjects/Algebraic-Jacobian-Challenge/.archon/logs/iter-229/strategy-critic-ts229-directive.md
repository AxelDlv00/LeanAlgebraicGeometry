# strategy-critic directive — ts229

You are a fresh-context critic of the global strategy. Read ONLY the inputs named below.
Do NOT read iter sidecars, task results, PROGRESS.md, or any per-iter narrative.

## Inputs (read these files)

1. **The current strategy (verbatim):** `.archon/STRATEGY.md` — read in full.
2. **References index:** `references/summary.md`.
3. **Blueprint summary:** the chapter files under `blueprint/src/chapters/*.tex` — read only the
   `\chapter{...}`/section titles and the first sentence of each, to form a one-line-per-chapter
   topic map. Do NOT deep-read proofs.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only). `J := Pic⁰_{C/k}` built unconditionally; end-state = zero inline `sorry` in
each protected decl's dependency cone, 0 project axioms, kernel-only axioms.

## What changed in the strategy this iter (so you can focus your review)

The sole ungated lane (A.1.c.SubT, the ⊗-group-law substrate for `Pic X`) has been STUCK for 10
iters. This iter, two independent Mathlib-idiom consults converged on a **reframe**: the two
remaining bridges (the dual's local-triviality, and the morphism-descent gluing engine) are
blocked on the SAME Mathlib-absent root — the open-immersion↔slice **sheaf-site equivalence**, a
named documented Mathlib TODO. The strategy now dispatches the prover at that single shared bridge
(rather than rotating between the two faces of it).

## Questions for you

1. Is the decomposition sound — is "build the one shared slice-site sheaf equivalence, which
   unblocks both bridges" a structurally correct reading, or is there a hidden reason the two
   bridges are NOT actually the same gap?
2. The whole RR-free substrate exists to avoid a USER-paused Riemann–Roch route. Given the
   substrate keeps growing (now ~400–700 LOC for the ⊗-inverse alone, on a ~4300–7500 LOC total
   Route-A arc), is the cost asymmetry the strategy claims (RR-free engine vs. divisor `Pic⁰` +
   paused RR) still credible? Note: lifting the RR pause is a USER-only action (a standing
   directive); the planner CANNOT swap routes itself — so frame any route-level challenge as a
   recommendation for the USER escalation, not an action the planner can take.
3. Any structural error, hallucinated dependency, or unnecessary phase in the `## Phases &
   estimations` table or the critical path (A.1.c.SubT → A.1.c → A.2.c)?

## Output
SOUND / CHALLENGE / REJECT per the usual format, with specific findings. If you CHALLENGE a route,
name the concrete strategy edit you'd want — but respect that route-swapping is USER-gated here.
