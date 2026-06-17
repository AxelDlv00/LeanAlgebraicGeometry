# Blueprint-reviewer directive — iter-164 fast-path re-review of AbelianVarietyRigidity.tex

You read the whole blueprint as always, but the VERDICT THAT MATTERS this dispatch is a
focused fast-path re-check of ONE chapter: `AbelianVarietyRigidity.tex`. It was rewritten
twice this iter (two blueprint-writer passes) to fix the must-fix you raised earlier
(`blueprint-reviewer-iter164`): the two genus-0 frontier blocks were NOT prover-ready.

## What changed since your prior dispatch
The genus-0 base case was re-routed. The OLD route (extend the additive-defect map ψ over
ℙ¹×ℙ¹ via Milne Thm 3.2, then 𝔾_a/𝔾_m incompatibility) is ABANDONED. The NEW primary route
is the **𝔾_m-scaling shortcut**, installed as the proof of `prop:morphism_P1_to_AV_constant`
(`\lean{morphism_P1_to_grpScheme_const}`):
- `σ_× : ℙ¹ × 𝔾_m → ℙ¹`, `(x,λ)↦λx` (total scheme morphism, fixes `0`) — `def:gaTranslationP1`,
  `\lean{gmScalingP1}`.
- `h := σ_× ≫ f`; apply the PROVEN Cor 1.5 (`lem:hom_additivity_over_product`, first-factor-
  only-proper) with `V=ℙ¹` proper, `W=𝔾_m`, base points `0,1`; the W-axis collapses (0 is a
  scaling fixed point) ⟹ `f(λx)=f(x)`; at `x=1`, `f|_{𝔾_m}` constant; density + separated
  (`thm:GrpObj_eq_of_eqOnOpen`, proven) ⟹ `f` constant.
- The deep `Hom(𝔾_a,A)=0` and the 𝔾_a-additive `lem:hom_from_Ga_trivial` are DEMOTED off the
  critical path; `lem:rational_map_to_av_extends` (Thm 3.2) demoted to Route-A-only.

## Decide (the fast-path gate)
1. Is `prop:morphism_P1_to_AV_constant`'s NEW scaling-shortcut proof prover-ready — i.e.
   detailed enough to formalize, math sound (the Cor 1.5 base-point conditions, the fixed-point
   collapse, the density step), and consuming only proven/well-defined inputs
   (`lem:hom_additivity_over_product`, `def:gaTranslationP1`/`gmScalingP1`, `thm:GrpObj_eq_of_eqOnOpen`)?
2. Are `def:genus0_base_objects` (concrete ℙ¹/𝔾_a/𝔾_m over Spec k̄) and `def:gaTranslationP1`
   (the σ_× action) specified at a level a prover can scaffold (the `\lean` hints are
   [expected] to-build infra — that is acceptable for a definition block, as with prior
   scaffolds, provided the construction sketch is concrete: the chartwise total-morphism
   computation must be present)?
3. Is the `\uses` graph forward-acyclic, the demoted blocks cleanly off the critical path,
   no laundering (no `\leanok` proof resting on a `sorry` — note the known `sync_leanok`
   keyword-prefix infra bug still leaves false proof-`\leanok` on the 3 scaffold props;
   that is NOT yours to fix and should NOT block your gate decision)?

## Output
Per-chapter checklist. **State explicitly whether `AbelianVarietyRigidity.tex` is now
`complete: true` + `correct: true` with no must-fix** (the fast-path gate for putting
`AbelianVarietyRigidity.lean` into this iter's prover objectives). If still partial, name
exactly what is missing. Other chapters: brief status only (no change expected).
