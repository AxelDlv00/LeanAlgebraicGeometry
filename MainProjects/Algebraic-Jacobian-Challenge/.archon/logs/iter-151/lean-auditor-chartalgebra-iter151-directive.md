# Lean audit directive — iter-151

Audit the following Lean file as Lean (no strategy framing, no
"what we are trying to prove" bias):

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Cotangent/ChartAlgebra.lean`

## Focus areas

1. The theorem `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
   (around L256) ends in a `sorry` (around L422) with a large comment
   block claiming the lemma is FALSE as stated. Independently assess:
   does the comment's reasoning hold up? Is retaining a `sorry` under a
   signature the author believes is false the right Lean hygiene, or
   should something else be done?
2. The `_mvPoly_*` private helper lemmas and the `_hFunct` step
   (the (C.a)–(C.c) scaffolding): are they genuinely closed (no hidden
   `sorry`, no `admit`, no vacuous/tautological bodies)? Are any of them
   dead/orphaned (defined but unused)?
3. Any other suspect definitions, outdated comments, dead-end proofs,
   or bad Lean practices in the file.

## Out of scope

- Do NOT assess whether the lemma SHOULD be true (that is a
  math-strategy question); only audit the Lean as written.

Report a per-declaration checklist plus a flagged-issues block with
severities.
