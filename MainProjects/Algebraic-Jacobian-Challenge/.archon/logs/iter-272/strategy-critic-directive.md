# Strategy Critic Directive

## Slug
iter272

## Your task
Render a fresh-context verdict on whether the project strategy is sound and
matches its canonical skeleton. Read these (and ONLY these) as your inputs:

1. `.archon/STRATEGY.md` (verbatim — the full current strategy).
2. `references/summary.md` (the reference index).
3. The blueprint chapter set: `ls blueprint/src/chapters/*.tex` (titles/topics —
   you may skim a chapter's first ~30 lines for its topic if needed, but do not
   audit chapter math; that is the blueprint-reviewer's job).

Do NOT read iter sidecars, PROGRESS.md, task results, or prover narratives —
your value is a sunk-cost-free view.

## Project goal (one paragraph)
Formalize Christian Merten's Jacobian challenge (`references/challenge.lean.ref`):
the nine protected declarations headed by `AlgebraicGeometry.Jacobian` and
`Jacobian.nonempty_jacobianWitness` — an Albanese/Jacobian object uniform over
the `k`-rational pointing of a smooth proper geometrically irreducible curve
`C/k` (`[Field k]` only; no `C(k)≠∅`, no `CharZero`). `J := Pic⁰_{C/k}` is built
unconditionally; only `isAlbaneseFor` is quantified over the pointing. End-state:
zero inline `sorry` in each protected decl's dependency cone, kernel-only axioms.

## Focus this iteration
The strategy's "Open strategic questions" section now records a RESOLVED
disjointness check (search "A.4 Route-1 RR-freeness — disjointness check —
RESOLVED"). Assess in particular whether that resolution is sound: it claims the
Route-A active cone may use the sorry-free DEFINITIONS `order-at-a-point` and
`codim-1 cycles` (physically in a Route-C / Riemann–Roch file) without violating
the "Route 1 is RR-free" property, on the grounds that "RR-free" means
independent of the paused RR *theorems* (Riemann–Roch formula, H¹-vanishing,
degree/dimension results), not of basic divisor *vocabulary definitions*. Is
that distinction sound, or does the divisor-sum well-definedness genuinely pull
an RR theorem transitively? Challenge it if the reasoning is motivated rather
than correct. Otherwise give the broader strategy your standard fresh-context
audit (route soundness, phase ordering, canonical-skeleton conformance).
