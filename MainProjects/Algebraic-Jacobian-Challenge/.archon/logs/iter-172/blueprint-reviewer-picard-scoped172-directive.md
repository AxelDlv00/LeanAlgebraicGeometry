# Blueprint reviewer directive (iter-172, slug `picard-scoped172`) — SAME-ITER FAST PATH

## Mode

Scoped same-iter fast-path re-review per the blueprint-reviewer workflow ("On a pivot iter where you rewrite chapter C and `lake build` then goes green, you may re-dispatch me scoped to C alone").

## Scope (NARROW)

Target chapter: `blueprint/src/chapters/Picard_RelativeSpec.tex` (NEW — 449 LOC; landed iter-172 via `blueprint-writer route-a1-retry2` after two iter-171 failed attempts).

Out-of-scope: the rest of the blueprint (the whole-blueprint dispatch `route172` returned earlier this iter; that report stands for everything else).

## Asks

1. Is Picard_RelativeSpec.tex complete (all 6 expected declarations present: `QcohAlgebra`, `RelativeSpec`, `RelativeSpec.UniversalProperty`, `RelativeSpec.affine_base_iff`, `RelativeSpec.base_change`, `RelativeSpec.functor`)? Each with a `\lean{...}` pin, `% SOURCE:` + `% SOURCE QUOTE:` + visible `\textit{Source: ...}` line?
2. Is Picard_RelativeSpec.tex correct in mathematical content (Stacks 01LL/01LO/01LQ/01LR/01LS faithfully reproduced; verbatim quotes match the local source file `references/stacks-constructions.tex`)?
3. Citation discipline: per project rules every reference must be local + verbatim. The writer report flagged `% SOURCE QUOTE PROOF: TODO` placeholder on one multi-page lemma. Is that acceptable per project rules, or must the writer return to fill the quote before Lane B can fire?
4. Does the chapter declare `% archon:covers AlgebraicJacobian/Picard/RelativeSpec.lean`? Is the `content.tex` `\input` order issue addressed (the planner will update `content.tex` post-review)?

## Out of scope

- NO whole-blueprint audit (already done this iter via `route172`).
- NO findings on other chapters.
- NO unstarted-phase proposals (already covered in the whole-blueprint dispatch).

## Decision the planner needs

**Does the chapter pass HARD GATE (complete + correct + no must-fix-this-iter)** so that the planner can include `AlgebraicJacobian/Picard/RelativeSpec.lean` (Lane B file-skeleton scaffold) in iter-172 `## Current Objectives`?

Possible outcomes:
- **PASS**: planner adds Lane B for iter-172.
- **PARTIAL with must-fix**: planner defers Lane B to iter-173; iter-173 mandatory blueprint-reviewer re-evaluates after a writer round addresses the must-fix.
- **FAIL on structure**: writer is recalled iter-173 with a tighter directive.

## Format

Per descriptor, return ONE verdict block per chapter examined (just the one chapter). Keep the report under ~50 lines. Lead with `HARD GATE: <PASS | PARTIAL | FAIL>`.
