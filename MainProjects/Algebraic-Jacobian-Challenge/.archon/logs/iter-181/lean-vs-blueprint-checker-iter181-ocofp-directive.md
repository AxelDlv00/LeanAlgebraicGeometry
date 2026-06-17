# Lean vs blueprint check — OCofP iter-181

## File

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/RiemannRoch/OCofP.lean`

## Chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/RiemannRoch_OCofP.tex`

## What happened this iter

This file received a **plan-phase refactor** plus a **prover lane**:

- **Refactor `refactor-ocofp-globalsections-sig`** (iter-181 plan-phase)
  added a new `noncomputable def lineBundleAtClosedPoint.toFunctionField`
  (typed `sorry`) and replaced the iff RHS of
  `Scheme.lineBundleAtClosedPoint.globalSections_iff`
  from `Nonempty { s // s ≠ 0 }` (vacuous-in-`f`) to
  `∃ s, lineBundleAtClosedPoint.toFunctionField P hP s = f`
  (binding `s` to `f`). This was the iter-180 CRITICAL must-fix.

- **Lane A prover (iter-181)** added two private directional helpers
  `globalSections_iff_mp` and `globalSections_iff_mpr`, each carrying
  one typed sorry, with the iff itself implemented as
  `⟨globalSections_iff_mp _ _ _ _ _, globalSections_iff_mpr _ _ _ _ _⟩`.

The blueprint chapter prose was already updated by the planner (plan-phase
edit binding `s` to `f` in the lemma block).

## Audit questions

1. Does the new Lean signature of `globalSections_iff` match the
   blueprint chapter's lemma block (label
   `lem:lineBundleAtClosedPoint_globalSections_iff`)?
2. Does the new `lineBundleAtClosedPoint.toFunctionField` declaration
   have a corresponding `\lean{...}` pin in the blueprint? If not, is
   one needed? Should the blueprint add a `\lean{...}` pin or document
   that this is an internal-to-Lean helper?
3. Does the chapter's proof block (the `\begin{proof}` ... `\end{proof}`
   under `lem:lineBundleAtClosedPoint_globalSections_iff`) cite the
   correct Hartshorne reference for the binding `s ↔ f`? Does the
   proof block discuss the `toFunctionField` map or treat it implicitly?
4. The two new directional helpers `globalSections_iff_mp` and
   `globalSections_iff_mpr` — should the blueprint add `\lean{...}`
   pins for them, or are they internal-to-Lean structure?

## Output

Standard lean-vs-blueprint-checker report:
- Lean → blueprint findings.
- Blueprint → Lean findings.
- Recommended chapter-side actions (\lean{...} pins, prose tightening,
  etc.).
- Recommended Lean-side actions (renames, signature refinement, etc.).
- Conclusion: `complete: true | partial | false` and `correct: true | false`
  per the HARD GATE format.

## Read scope

- The Lean file in full.
- The blueprint chapter in full.
- No other context.
