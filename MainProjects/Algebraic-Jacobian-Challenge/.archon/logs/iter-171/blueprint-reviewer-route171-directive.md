# Blueprint Reviewer Directive

## Slug
route171

## Iter
171

## Scope

Whole-blueprint audit. Per-chapter checklist of completeness + correctness. Focus areas this iter:

1. **`Jacobian.tex`** — Route A per-sub-phase decomposition (A.1–A.4) landed iter-170 (L347-L432). Is each sub-phase decomposed deeply enough for a future blueprint-writer to expand into per-sub-phase chapters? Or is each sub-phase still itself too coarse?
2. **`AbelianVarietyRigidity.tex`** — covers `AbelianVarietyRigidity.lean` + `Genus0BaseObjects.lean`. iter-170 added NOTE refreshes on `def:gaTranslationP1` + `lem:gmScaling_fixes_zero` recording option-(c) decision. Is the genus-0 chain complete + correct enough for the Lane A body-first attempt this iter?
3. **`AbelianVarietyRigidity.tex` `prop:genusZero_curve_iso_P1` block (L1448–L1501)** — iter-170 deferred this to upstream Mathlib. iter-171 reverses this: commits to an in-tree RR sub-build per `analogies/rrbridge-survey.md` option (1). Is the current 50-line `prop` block sufficient as a target for prover-ready sub-decomposition into 4 Hartshorne IV.1.3.5 ingredients (divisor of a closed point, RR formula on a genus-0 curve, linear equivalence, "rational ⟹ ≅ ℙ¹")? Or does it need expansion into a 4-section sub-chapter?
4. **Whole-blueprint orphan check** — Are all `\lean{...}` decls live (i.e., every `\lean{namespace.theorem_name}` resolves to an actual project declaration)? Are there orphan `\proves{...}` annotations or broken `\uses{...}` references?
5. **Unstarted-phase blueprint proposals** — STRATEGY.md row "Refactor — AVR split" + the 4 new Route A sub-rows (A.1/A.2/A.3/A.4) + the new RR-bridge in-tree sub-build COMMITMENT do not yet have prover-ready chapter coverage. Propose chapter outlines for each unstarted phase.

## Absolute file paths to read

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/*.tex`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/content.tex`
- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/lean_decls`

## Out of scope

- Lean-side audits (the lean-auditor and lean-vs-blueprint-checker subagents handle those).
- Strategy-level critique (strategy-critic territory).
- Sorry-count or progress assessment (progress-critic territory).

## Active prover lane this iter

ONE prover lane on `Genus0BaseObjects.lean` (re-attempt iter-170's body-first `gmScalingP1` test, lost to API-500). HARD GATE: ensure `AbelianVarietyRigidity.tex` (covers G0BO) is `complete: true` AND `correct: true` AND has no live must-fix-this-iter finding — your verdict on this chapter directly gates the prover lane.
