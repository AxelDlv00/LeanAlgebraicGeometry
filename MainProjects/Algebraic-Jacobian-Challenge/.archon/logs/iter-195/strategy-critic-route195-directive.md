# Directive — strategy-critic `route195`

## Context

The iter-195 plan-phase edited STRATEGY.md in two ways:

1. The "Carrier-soundness refactor — DEFERRED" entry under
   `## Open strategic questions` was rewritten to **commit the
   refactor to a concrete iter-200 slot** (no more "iter-195+"
   sliding). The mathlib-analogist sweep already scheduled iter-200
   is now co-scheduled with the carrier-soundness refactor.
2. The "Iter-194 progress-critic findings (recorded)" section was
   replaced with an "Iter-195 routing pivot (recorded)" section
   documenting iter-195's close-focused dispatch on the 3
   highest-leverage targets per session-194 review recommendations
   (Lane H SAb.Exact, BareScheme.lean NEW LANE, Lane E chart-1 idiom).

The strategy itself (Phases & estimations, Routes, Mathlib gaps)
is unchanged.

## Your job

Given the current `STRATEGY.md` (read it fresh; do NOT rely on
recollection), verify:

1. **Soundness of the iter-200 carrier-soundness commitment.** Is
   landing this refactor in iter-200 alongside the mathlib-analogist
   sweep a sound calendar choice, OR should it be earlier/later? The
   session-194 reviewer's R1 recommendation was to either land it
   iter-195 OR commit to a concrete iter-200+ slot. The plan agent
   chose iter-200 because (a) blast radius is large + (b) design
   options need the mathlib-analogist consult (existential `Nonempty
   (Σ' S, ...)` vs opaque-axiom vs structure-of-data) + (c) pulling
   it forward displaces the 3 iter-195 closure-focused lanes. Is
   this reasoning correct?
2. **Soundness of the iter-195 close-focused dispatch.** Lane H +
   BareScheme + Lane E are flagged as highest-leverage. Lanes M↓ +
   A.3.i body + RCI helper (d) + G n=k+1 are explicitly deferred to
   iter-200. Is the priority ordering sound, or are there
   higher-leverage targets the plan agent missed?
3. **Bottom-up execution priority.** STRATEGY.md `## Bottom-up
   execution priority` lists A.3.i + Lane M↓ + A.4.b + A.3.0 + A.2.a
   + A.2.b as roots. iter-195 dispatch DOES include Lane I substrate
   (#4), AB n=k+1 OFF-CRITICAL-PATH, but defers A.3.i body, Lane M↓,
   A.3.0, A.2.a, A.2.b. Is the bottom-up priority still being honored?
4. **Risks / blind spots.** What risks does the iter-195 plan miss?
   What strategic alternatives does the plan agent not consider?

## Output format

Per the strategy-critic descriptor: SOUND / CHALLENGE / REJECT
verdict + per-decision rationale + must-fix-this-iter findings if
any. Findings must be specific (e.g. "the iter-200 carrier-soundness
slot should be iter-198 because X" rather than "consider an earlier
slot").

## Materials provided

This directive includes:

- `STRATEGY.md` (verbatim, current state):

```
{{STRATEGY.md verbatim — read directly from /home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md}}
```

- `references/summary.md` (read directly from the project).

- Blueprint chapter index — one line per chapter (you may read
  `blueprint/src/chapters/*.tex` directly for one-line topic
  summaries).

- Project goal (paraphrased from `references/challenge.lean.ref`):
  formalize Christian Merten's Jacobian challenge — nine protected
  declarations headlined by `AlgebraicGeometry.Jacobian` and
  `Jacobian.nonempty_jacobianWitness`, establishing existence of an
  Albanese / Jacobian object uniform over the `k`-rational pointing
  of a smooth proper geometrically irreducible curve `C / k`, with
  NO `C(k) ≠ ∅` hypothesis. End-state: zero inline `sorry`,
  kernel-only axioms (`propext`, `Classical.choice`, `Quot.sound`).

## Do NOT include

- Iter sidecars under `iter/iter-NNN/`.
- `task_pending.md`, `task_done.md`, recent prover task results.
- Recent review reports or session journals.
- Per-iter narrative beyond what STRATEGY.md itself documents.
