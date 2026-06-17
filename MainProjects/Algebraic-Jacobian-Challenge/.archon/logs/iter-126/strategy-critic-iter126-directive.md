# Strategy Critic Directive

## Slug
iter126

## Project goal

Formalize the nine protected declarations of Christian Merten's Jacobian
challenge (`references/challenge.lean`):

| File | Declaration |
|---|---|
| `Genus.lean` | `AlgebraicGeometry.genus` |
| `Jacobian.lean` | `AlgebraicGeometry.Jacobian`, `Jacobian.instGrpObj`, `Jacobian.smoothOfRelativeDimension_genus`, `Jacobian.instIsProper`, `Jacobian.instGeometricallyIrreducible` |
| `AbelJacobi.lean` | `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`, `Jacobian.exists_unique_ofCurve_comp` |

All nine signatures are frozen by the mathematician; agents are read-only
on them. The end-state (per the iter-121 user directive + iter-126 user
hint reaffirmation) is **zero inline `sorry` in the project**, no named
axioms, with every Mathlib gap built out in-tree as a Mathlib contributor.

## Strategy under review

```
[Paste current STRATEGY.md verbatim — see below for the full text.]
```

The current `STRATEGY.md` (verbatim):

---
ATTACHED VERBATIM BELOW
---

Read the live file: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/.archon/STRATEGY.md`.

(Critic note: read it from disk using the Read tool; the directive does
not paste it inline to keep this file small.)

## References index

```
# References

| File | Description |
| ---- | ----------- |
| `challenge.lean` | Original AI challenge file by Christian Merten — the formal statement of the missing definitions and theorems for the Jacobian of an algebraic curve. The Lean skeleton in `AlgebraicJacobian/` is a decomposition of this file; signatures here are authoritative. |
```

## Blueprint summary

Chapter titles + one-line topic per chapter (from `blueprint/src/chapters/*.tex`):

- `AbelJacobi.tex` — The Abel–Jacobi map and the protected `AbelJacobi.Jacobian.ofCurve` interface; transits through `nonempty_jacobianWitness`.
- `Cohomology_MayerVietoris.tex` — Mayer–Vietoris long exact sequence + Čech-acyclicity infrastructure (consumer of HModule).
- `Cohomology_SheafCompose.tex` — Sheaf-composition `HasSheafCompose` instance on Opens(X) for the CommRing→AddCommGrp forget.
- `Cohomology_StructureSheafAb.tex` — Structure sheaf as AddCommGrp-valued sheaf with Sheafify/Ext instances.
- `Cohomology_StructureSheafModuleK.tex` — Structure sheaf as a Module k-valued sheaf; HModule = Abelian.Ext on it; vanishing infrastructure for Cech-acyclic covers.
- `Differentials.tex` — Relative cotangent presheaf + the forward-direction smoothness criterion + the parked bridge M1.
- `Genus.tex` — `genus C := Module.finrank k (HModule … 1)` definition.
- `Jacobian.tex` — Jacobian definition + `JacobianWitness` bundle + multi-route proof sketch of `nonempty_jacobianWitness` (Routes A/B + genus-0 sub-case C.2 with the C.2.d cotangent-vanishing keystone).
- `Modules_Monoidal.tex` — Orphan chapter (Lean file deleted; not in `content.tex`).
- `Picard_Functor.tex` — Orphan chapter (Lean file deleted; not in `content.tex`).
- `Picard_FunctorAb.tex` — Orphan chapter (Lean file deleted; not in `content.tex`).
- `Picard_LineBundle.tex` — Orphan chapter (Lean file deleted; not in `content.tex`).
- `Rigidity.tex` — Closed scheme-level rigidity lemma `Scheme.Over.ext_of_eqOnOpen` (post-iter-125 refactor).
- `RigidityKbar.tex` — NEW iter-126: scaffold chapter for `rigidity_over_kbar`, the M2.a named declaration. Cross-refs Jacobian.tex § C.2 for the proof decomposition + names the shared cotangent-vanishing Mathlib pile with four-piece (i)–(iv) decomposition.

## Prior critique status

You were dispatched as `strategy-critic-iter125` last iter and returned
CHALLENGE on 4 routes + 2 major alternatives:

1. **End-state vs M1 parked (CHALLENGE)** — soft un-park triggers were
   sunk-cost-adjacent indefinite deferral. **Iter-125 plan-agent response**:
   added a hard iter-128 un-park / disposal trigger with 3 exits.
   **Iter-126 plan-agent response (this iter)**: REMOVED exit (c)
   "named-axiom escalation" per iter-126 user hint reaffirming "no
   axioms". Remaining iter-128 exits are (a) close M1.b, (b) excise
   the bridge. Both are no-axiom paths.

2. **Iter-126 M2.a deliverable over-sold (CHALLENGE)** — "C.2.b + C.2.c
   in body" misframed; C.2.c only dichotomises. **Iter-125 plan response**:
   corrected to "scaffold named declaration with C.2.d residual sorry".
   **Iter-126 response (this iter)**: scaffold framing preserved
   verbatim; the new chapter `RigidityKbar.tex` documents the proof
   decomposition explicitly with the C.2.d keystone called out.

3. **C.2.d / M2.d-alt double-counting (CHALLENGE)** — collapse into
   single "shared cotangent-vanishing pile". **Iter-125 response**:
   STRATEGY.md § M2.d-alt now references the shared pile. **Iter-126
   response (this iter)**: pulled forward the iter-130 mathlib-analogist
   consult on this pile into iter-126 to scope the build directive
   earlier (per the user-hint "do the work" directive). Sequencing
   table iter-range tightened 10–20 → 8–12.

4. **Sequencing table iter-range layout (CHALLENGE)** — single-iter
   rows for multi-iter items mislead. **Iter-125 response**: each row's
   iter-range now matches its own LOC/iter estimate. **Iter-126 response**:
   per-row iter-ranges updated to absorb the iter-130→iter-126 analogist
   pull-forward; honest M2 closure estimate revised iter-162+ → iter-151+.

Two major alternatives you raised:

A. **Direct over-k rigidity (drop M2.c)** — STRATEGY § "Alternative"
   block added iter-125. The iter-126 plan-agent has NOT acted on this
   yet (requires mathematician confirmation that the over-k cotangent-
   vanishing argument carries the same characteristic-`p` handling as
   the over-`k̄` version). Flagged for surface to user via review-agent
   TO_USER.md.

B. **Excise the M1 bridge entirely** — iter-128 exit (b) per the hard
   trigger. Verified zero in-tree consumers iter-125. The iter-126
   plan-agent considered pulling this to iter-126 but deferred to
   iter-128 (the "shortest path" reading of the user hint is qualified
   by "your role is to fill mathlib gaps" — excise is shortest path to
   clean tree, but M1 close is shortest path to filled Mathlib PR;
   plan-agent reading: defer to iter-128 with user opportunity to weigh
   in via USER_HINTS.md if desired before then).

C. **Convert M1.b bijectivity sorry to named axiom** — REMOVED entirely
   per iter-126 user hint. Not on the table any longer.

The new iter-126 strategic content this iter:

1. **User-hint absorbed** — the iter-126 USER_HINTS.md carried "do the
   work, no axioms, ~6500–9000 LOC may not be that much for an AI, find
   the shortest path". Plan-agent reading:
   - NO AXIOMS reaffirmed (M1 exit (c) + M3 named-axiom option both
     removed from STRATEGY.md).
   - 6500–9000 LOC endorsed (Route A 6500 LOC / Route B 9000 LOC both
     on the table; the iter-123 route-pick audit's Route A preference
     stands).
   - "Shortest path" qualified by "fill mathlib gaps" — the plan-agent
     reads this as shortest path among legitimate work options, NOT
     shortest path via axioms or excision-as-shortcut.
   - "Do the work" → pulled the iter-130 cotangent-vanishing analogist
     consult forward to iter-126 (4-iter earlier scoping).

2. **Pulled-forward analogist consult** — iter-126 dispatches a
   mathlib-analogist on the shared cotangent-vanishing pile to scope
   the four pieces (i abelian-variety cotangent triviality, ii df=0
   factorisation, iii char-p handling, iv Serre duality). Output:
   `analogies/cotangent-vanishing-pile.md` + build directive.

3. **iter-126 M2.a scaffold refactor** — creates new file
   `AlgebraicJacobian/RigidityKbar.lean` with named declaration
   `rigidity_over_kbar` and single `sorry` body. Net sorry change
   2 → 3. New chapter `RigidityKbar.tex` documents it.

4. **Sequencing table revision** — iter-range tightening per the
   pulled-forward analogist; honest M2 closure estimate revised
   iter-162+ → iter-151+.

## Specific questions to address

Beyond your routine route-by-route audit:

1. **Is the iter-126 plan-agent's "shortest path" reading of the user
   hint correct?** The plan-agent reads "shortest path" as qualified by
   "your role is to fill mathlib gaps" — so it defers the M1 close vs
   excise choice to iter-128 rather than pulling the excise forward.
   Is this defensible, or should the iter-126 plan be sharper (e.g.
   pull M1 excise forward to iter-126 as well; it's a 5-LOC delete with
   zero consumers)?

2. **Is the iter-130 → iter-126 pull-forward of the cotangent-vanishing
   analogist sound?** Pro: earlier scoping = earlier build; user hint
   endorses "do the work". Con: iter-126 already has 5 subagents; the
   analogist scope is genuinely large (4 sub-pieces).

3. **Is the iter-126 plan-phase-only iter pattern (3 critics + 1
   refactor + 1 analogist, NO prover dispatch) sustainable?** Iter-125
   was also plan-phase-only. Two consecutive plan-phase-only iters
   could read as no-prover-work pattern. The plan-agent's defense: the
   refactor IS the deliverable, refactor is the right tool for
   scaffold creation; pure prover work resumes iter-127+ on scaffolded
   targets.

4. **Re-verify the iter-125 critic's prior CHALLENGES are addressed.**

Render verdicts on the strategy as-is (after the iter-126 revisions),
plus answers to the 4 specific questions above.
