# strategy-critic sc257 — fresh strategic review (iter-257)

Read ONLY these, as a fresh mathematician with no investment in the project's momentum:
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md` (verbatim — the strategy under review).
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/references/summary.md` (the reference index).
- Blueprint chapter titles + one-line topics: list from
  `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/*.tex`
  (read the first `\chapter{}`/`\section{}` and the first theorem label of each; do NOT read them in full).

Do NOT read: iter sidecars (`.archon/iter/**`), `PROGRESS.md`, `task_pending.md`, `task_done.md`,
`task_results/**`, review reports, proof-journal. Your value is the sunk-cost-free view.

## Project goal (one paragraph)

Formalize Christian Merten's Jacobian challenge: the protected `AlgebraicGeometry.Jacobian` /
`Jacobian.nonempty_jacobianWitness` declarations — an Albanese/Jacobian object uniform over the
k-rational pointing of a smooth proper geometrically irreducible curve C/k, with `J := Pic⁰_{C/k}`
built unconditionally. End-state: zero inline sorry in each protected decl's dependency cone, 0 project
axioms. Critical path (RR-free, Route C paused by user): A.1.c.sub (line-bundle comparison-iso substrate)
→ A.1.c.fun (relative Picard functor) → A.2.c (representability).

## Specific question to pressure-test this iter

The substrate work currently spends iters on the **dual-inverse chain** (`dual_restrict_iso` →
`exists_tensorObj_inverse`) in `DualInverse.lean`. STRATEGY records a carrier pivot: `Pic X` is carried
on tensor-invertibility `IsInvertible M := ∃N, M⊗N≅𝒪`, with `picCommGroup` already done, so the GROUP
inverse is a free membership witness. Yet `exists_tensorObj_inverse` (loc-triv ⟹ invertible) is still
being built via the dual. Is this consistent — i.e. is `exists_tensorObj_inverse` genuinely the
loc-triv-carrier⟶invertible-carrier BRIDGE that RPF needs (so the dual work is on-path), or is the
project re-deriving a group inverse the carrier pivot already made free (so the dual arc should be
dropped)? Challenge or confirm. Also: is opening the A.2.c engine pole in parallel NOW (LineBundleCoherence
loc-triv coherence entry) the right call, or premature given A.1.c.sub is not yet closed?

Give a verdict (SOUND / CHALLENGE / REJECT) per route with explicit reasoning.
