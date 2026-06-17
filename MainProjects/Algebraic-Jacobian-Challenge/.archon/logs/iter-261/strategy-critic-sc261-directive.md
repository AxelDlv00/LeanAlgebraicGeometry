# strategy-critic directive (iter-261)

Provide a fresh-mathematician critique of the project's global strategy. Read ONLY these, verbatim:

- `.archon/STRATEGY.md` (the current strategy — just updated this iter).
- `references/summary.md` (the reference index).
- The blueprint chapter titles (one-line topic per chapter) in `blueprint/src/chapters/*.tex`
  — read the `\chapter{...}` line of each; do NOT read chapter bodies.

Do NOT read: `PROGRESS.md`, `task_pending.md`/`task_done.md`, `task_results/`, any
`iter/iter-NNN/*` sidecar, proof-journal, or review reports. Your value is seeing the strategy as a
fresh mathematician, free of the project's momentum.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge: nine protected declarations headed by
`AlgebraicGeometry.Jacobian` / `Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object
uniform over the `k`-rational pointing of a smooth proper geometrically irreducible curve `C/k`
(`[Field k]` only). `J := Pic⁰_{C/k}`. End-state: zero inline `sorry` in the dependency cone of each
protected decl, 0 project axioms.

## What changed in STRATEGY.md this iter (the specific thing to sanity-check)
The shared root `SheafOfModules.overEquivalence` closed (engine `IsFinitePresentation` axiom-clean),
but it was found **structurally insufficient** for the dual-inverse `sliceDualTransport` (it carries
no internal-hom/dual content). The dual now takes **route-2**: build `sliceDualTransport` sectionwise
= leg-A slice-site Hom base-change (Beck–Chevalley across `f.opensFunctor`) ∘ leg-B
`restrictScalarsRingIsoDualEquiv`. Question to pressure-test: is route-2 the right way to obtain the
RPF group inverse `exists_tensorObj_inverse`, or is there a structurally cheaper path to a
tensor-inverse of a locally-trivial line bundle (e.g. via the already-axiom-clean `picCommGroup` on
the `IsInvertible` carrier, or a different inverse witness)? Also assess the overall RR-free Route-A
arc (A.1.c.sub → A.1.c.fun → A.2.c) for soundness and whether the A.2.c engine pole is correctly
scoped.

Give SOUND / CHALLENGE / REJECT verdicts with reasoning.
