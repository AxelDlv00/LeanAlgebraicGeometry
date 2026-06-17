# Blueprint Reviewer Directive (iter-117)

## Slug

iter117

## Iteration

117

## Standing fact pattern (the user just gave a substantive new directive)

The user wrote (verbatim from `USER_HINTS.md`):

> [...] you should remove all wrong mathematical statements and plan how to
> fill the gap it leaves. No wrong definition/proofs/signatures are accepted
> it should always be correct and never be temporarily wrong. Moreover the
> blueprints should be detailed enough to ensure that the provers have
> enough material. [...]

So your audit this iter has an extra emphasis: **flag any chapter where the
proof sketches are NOT detailed enough for a prover to formalize**. Vague
sketches that gloss over key steps are must-fix. The planner needs a
prioritized list of chapters to send blueprint-writer dispatches against
next iter.

## Scope

Whole blueprint. Read every chapter under
`blueprint/src/chapters/*.tex`. The 13-chapter index:

- Rigidity.tex
- Genus.tex
- Jacobian.tex
- AbelJacobi.tex
- Differentials.tex
- Modules_Monoidal.tex
- Picard_LineBundle.tex
- Picard_Functor.tex
- Picard_FunctorAb.tex
- Cohomology_SheafCompose.tex
- Cohomology_StructureSheafAb.tex
- Cohomology_StructureSheafModuleK.tex
- Cohomology_MayerVietorisCore.tex / Cohomology_MayerVietorisCover.tex

## Project goal (for chapter-vs-Lean alignment)

The project formalizes Christian Merten's Jacobian challenge
(`references/challenge.lean`). The 9 protected declarations
(`archon-protected.yaml`) are: `genus`, `Jacobian`, four `Jacobian`
instances, `Jacobian.ofCurve`, `Jacobian.comp_ofCurve`,
`Jacobian.exists_unique_ofCurve_comp`. Other chapters describe project
content beyond the protected chain: Differentials cotangent API, Picard
arc, Mayer-Vietoris foundations, Čech machinery.

## Standing planner concerns going into iter-117

The planner is rewriting STRATEGY.md to comply with "nothing deferred".
That means several chapters that currently document "named Mathlib
gap" sorries with no concrete close-plan will need to either:

- be rewritten with a concrete decomposition into subclaims the prover
  can attack, OR
- be trimmed because the corresponding Lean declaration will be
  removed from project scope.

You should flag, per chapter:

- Whether the proof sketches are detailed enough (a paragraph or more
  per non-trivial step, with named Mathlib lemmas tagged
  `[verified]`/`[expected]`/`[gap]`).
- Whether the chapter contains "this is a named Mathlib gap; deferred"
  prose that the user's new directive overrides.
- Whether the chapter's `\lean{...}` declarations match the current
  Lean file's declaration names (Mathlib bumps and project renames
  drift these).
- Whether the chapter's `\uses{...}` graph has any broken edges.

## Constraints

- You are read-only on the blueprint. Your output is your report.
- Pass per-chapter checklist with `complete: yes/partial/no` and
  `correct: yes/partial/no`.
- Per-chapter must-fix items get listed at the top.
- Pass back a HARD GATE recommendation: for each chapter, is its
  current state acceptable for the prover to consume, or must a
  blueprint-writer fire this iter before that chapter's Lean file
  gets prover work?

## Constraints on must-fix severity

Apply your standard severity rules. The user directive is supplementary,
not overriding — i.e. a "blueprint name drift" finding is still must-fix
even if it's not strictly about depth.

## Length

Whatever the audit warrants. Don't truncate.
