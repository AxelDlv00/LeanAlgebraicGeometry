# Strategy Critic Directive — iter-136 re-verification

You are the fresh-context strategy critic. Read STRATEGY.md and the
small bundle named below; render an unbiased verdict on whether the
current strategic plan is sound.

## Files to read

1. **`.archon/STRATEGY.md`** (verbatim) — primary subject of review.
2. **`references/summary.md`** — short reference index.
3. **`references/challenge.lean`** — the original challenge by Christian
   Merten naming the protected declarations / final theorem(s).
4. **Blueprint chapter summary** — read just the **first 25 lines** of
   each chapter under `blueprint/src/chapters/` to extract a one-line
   topic per chapter (chapter titles + one-line topic). DO NOT read
   the chapter bodies; that is the blueprint-reviewer's territory.

## What you MUST NOT read

- `.archon/iter/iter-NNN/{plan,review,objectives}.md` for any NNN.
- `.archon/task_pending.md`, `.archon/task_done.md`,
  `.archon/PROGRESS.md`, `.archon/task_results/*.md`,
  `.archon/proof-journal/**`.
- Any per-iter narrative of "what we tried last time."

If the directive accidentally cites information from these, ignore it.

## Project goal

Formalize the nine protected declarations of Christian Merten's
Jacobian challenge listed in `archon-protected.yaml` (verbatim):

```
AlgebraicJacobian/Genus.lean:
  - AlgebraicGeometry.genus
AlgebraicJacobian/Jacobian.lean:
  - AlgebraicGeometry.Jacobian
  - AlgebraicGeometry.Jacobian.instGrpObj
  - AlgebraicGeometry.Jacobian.smoothOfRelativeDimension_genus
  - AlgebraicGeometry.Jacobian.instIsProper
  - AlgebraicGeometry.Jacobian.instGeometricallyIrreducible
AlgebraicJacobian/AbelJacobi.lean:
  - AlgebraicGeometry.Jacobian.ofCurve
  - AlgebraicGeometry.Jacobian.comp_ofCurve
  - AlgebraicGeometry.Jacobian.exists_unique_ofCurve_comp
```

The end-state is **zero inline `sorry` in the project**, no named
project axioms. Bodies of the protected declarations transit through
`Jacobian.lean`'s `nonempty_jacobianWitness`.

## What is asked of you this iter

The strategy was last revised iter-135 (1 minor edit: naming wart
`Ideal.IsLocalRing.CotangentSpace` → `IsLocalRing.CotangentSpace`).
The substantive strategic content is unchanged from iter-134; the
iter-135 critic returned SOUND with 1 CHALLENGE + 2 minor alternatives
(all absorbed or rebutted). The iter-135 rebuttal of Alt 2
(temporary-axiom pile-composition smoke test) was: "the no-axioms rule
binds; the iter-135 type-elaboration check already serves as a
lighter-weight integration spike."

**Please re-verify the strategy with fresh eyes**:

1. Are all the routes / decompositions still sound?
2. Are there alternative routes you would flag that the strategy has
   not considered?
3. Is the `over-k` commitment (§ "Direct over-k rigidity") still
   defensible on its current grounds (cleanliness (ii) + auto-revert
   wiring (iii) + piece (i.a) tractability (iv, scope-narrow))?
4. Is the M2.body-pile decomposition (i.a)+(i.b)+(i.c)+(ii)+(iii)
   still the right shape for closing M2.a body?
5. Does any route smell of sunk-cost reasoning?
6. Is anything new you would FLAG that prior critics have missed?

If you find no substantive issue, return SOUND and say so explicitly;
the planner will use that to ratify the strategy this iter.

## Output

Write your full report to
`.archon/task_results/strategy-critic-iter136.md`. The wrapper script
manages the path; do not include a filename in your output content.
Use the per-route CHALLENGE / SOUND / REJECT format documented in the
strategy-critic descriptor's "Output" section.
