## File to check

- Lean file: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint chapter: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## iter-184 change

Lane E closed `iotaGm_onePt_chart1_factor` (L105) Tier-1 axiom-clean (axioms: `{propext, Classical.choice, Quot.sound}`). Helper budget 0 honoured. Proof uses `IsOpenImmersion.lift_fac` + `Scheme.Hom.coe_opensRange` + `Proj.opensRange_awayι` + `Proj.fromOfGlobalSections_preimage_basicOpen` + `Scheme.basicOpen_of_isUnit`.

The chapter contains a `\cref{thm:rigidity_genus0_curve_to_AV}` (per blueprint-doctor iter-184) that has no matching `\label`. Confirm or refute this finding from the Lean side: is `thm:rigidity_genus0_curve_to_AV` a label that should exist in this chapter, or is the `\cref` pointing at a label in another chapter that was renamed/removed?

## What I expect

- Lean → blueprint: is every Lean declaration accurately reflected in the blueprint chapter (correct `\lean{...}` pin, correct signature, correct hypotheses)?
- Blueprint → Lean: is the prose detailed enough that the Lean code clearly was written from it (no signature drift, no missing assumption that the Lean needs)?
- Specifically check the iter-184 Lane E closure: does the chapter prose for `iotaGm_onePt_chart1_factor` match the closure path that landed (range-containment via the 5-lemma chain above)?

## Out of scope

- Other files / chapters.
- Strategy or roadmap-level commentary.

## Report length

Under ~150 lines.
