# Lean ↔ Blueprint Checker Directive

## Slug
iter185-auslander

## Lean file
AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean

## Blueprint chapter
blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex

## Known issues
- iter-185 Lane G PIVOT (per iter-184 task_result + iter-184 lean-vs-blueprint-checker `iter184-auslander`): the lane DROPPED `auslander_buchsbaum_formula` (L835, kept as typed-sorry) in favour of `exists_isRegular_of_regularLocal` (L944). The rationale is that A.4.a's downstream consumer `CohenMacaulay.of_regular` does NOT need AB formula directly.
- New helper `exists_isSMulRegular_quotient_isRegularLocal_succ` (L965) — typed sorry consolidating Stacks 00NQ + 00NU substrate.
- `regularLocal_inductive_step` (L998) body rewritten from a bare sorry to a structured 6-step scaffold consuming the new helper + IH, ending in a single technical bridge sorry at L1008 (the R⧸(x)-linear equiv between `R ⧸ Ideal.span {x}` and `QuotSMulTop x R`).
- Net sorries 2 → 3 (within PARTIAL allowance per directive).
- The iter-184 lean-vs-blueprint-checker SOUND verdict cleared the chapter; verify that the PIVOT is faithful to the chapter's `cor:regular_cohen_macaulay` Application section.
- Confirm chapter prose covers `exists_isRegular_of_regularLocal` adequately (it should — A.4.a derivation chapter, Stacks 00NQ + 00NU).
- The 2 chapter NOTE-comments from iter-184 (`cor:regular_cohen_macaulay`, AB Lean encoding) — verify they are still consistent with the iter-185 PIVOT outcome.
