# Lean ↔ blueprint check — `RiemannRoch/WeilDivisor.lean` vs
# `RiemannRoch_WeilDivisor.tex`

## Files

- Lean: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Iter-200 edits (substrate-only, axiom-clean)

8 new declarations added (Lane WD-A4a Sub-build 1):

1. `Scheme.PrimeDivisor.ext`
2. `Scheme.PrimeDivisor.restrictToOpen`
3. `Scheme.PrimeDivisor.ofOpen`
4. `Scheme.PrimeDivisor.restrictToOpen_point` (`@[simp]`)
5. `Scheme.PrimeDivisor.ofOpen_point` (`@[simp]`)
6. `Scheme.PrimeDivisor.equivOpen`
7. `Scheme.PrimeDivisor.stalkIso`
8. `Scheme.IsRegularInCodimensionOne.instOpen`

Sorries unchanged (3 → 3 at L535, L843, L1413). HARD BAR met
(open-immersion stalk-bridge for prime divisors, Stacks 02IZ).

## What I need from you

Bidirectional check, per your descriptor:

1. **Lean → blueprint**: are the 8 new substrate declarations
   reflected in the blueprint chapter? If not, report whether the
   chapter SHOULD host a new section (e.g. `\section{Open-immersion
   descent for prime divisors}` citing Stacks 02IZ). The prover's
   handoff note explicitly recommended this.
2. **Blueprint → Lean**: confirm the chapter's existing `\lean{...}`
   pins still resolve to existing declarations after the file's
   structural growth (1318 → 1438 LOC); flag any broken pins.
3. **Chapter completeness for prover-gate**: WD is an active Route A
   lane (iter-201+ will dispatch Sub-build 2 = `Ring.ordFrac`
   transport). Does the chapter contain enough material to guide the
   iter-201+ prover, or does it need plan-agent expansion?

## Severity rating

- `must-fix-this-iter` blocks downstream prover work next iter.
- `soon` should be addressed within 1-2 iters.
- `major` / `minor` are advisory.

## Output

Write to `.archon/task_results/lean-vs-blueprint-checker-wd-iter200.md`.
