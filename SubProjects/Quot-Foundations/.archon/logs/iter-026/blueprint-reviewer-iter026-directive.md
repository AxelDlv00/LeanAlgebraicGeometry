# blueprint-reviewer directive — iter-026 (Quot-Foundations)

Whole-blueprint audit (read every chapter under `blueprint/src/chapters/`). Per-chapter completeness +
correctness checklist + HARD-GATE verdict. This iter THREE files are candidates for prover dispatch — pay
particular attention to their chapters, but review the whole blueprint as usual.

## Files under prover dispatch this iter (gate these chapters)
1. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` → `Cohomology_FlatBaseChange.tex`.
   Focus: `lem:base_change_mate_inner_value_eq` and its assembly node `lem:base_change_mate_inner_eCancel`
   — does the newly added "Order of operations (load-bearing)" paragraph give a prover a CONCRETE,
   formalizable route past the literal-form lock (distribute the unit on the free composite before the
   legs lock to the concrete projections)? This was the iter-024 must-fix; confirm it is now resolved or
   name precisely what remains under-specified.
2. `AlgebraicJacobian/Picard/QuotScheme.lean` → `Picard_QuotScheme.tex`.
   Focus: the three blocks added after `lem:qcoh_section_localization_basicOpen` —
   `lem:isLocalizedModule_tilde_restrict`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`
   (coverage-debt entries for the two iter-024 affine engines, which DO have axiom-clean Lean decls), and
   `lem:qcoh_affine_isIso_fromTildeΓ` (gap1: `IsQuasicoherent M → IsIso M.fromTildeΓ` on Spec R — the
   keystone's missing descent ingredient, Lean decl NOT yet built). Is gap1's proof sketch (local
   presentations ⟹ global presentation on the affine, then `isIso_fromTildeΓ_of_presentation`)
   detailed enough to hand to a mathlib-build prover, or does it hand-wave the globalization? Is the
   keystone `\uses{}` now accurate?
3. `AlgebraicJacobian/Picard/GrassmannianCells.lean` → `Picard_GrassmannianCells.tex`.
   Focus: `def:gr_glued_scheme` (`Grassmannian.scheme`) — is the gluing construction specified well enough
   to build (charts, overlaps `U^I_J`, transition isos `θ`, cocycle), given the cocycle is already proved
   in Lean? Are `lem:gr_separated` / `lem:gr_proper` complete enough to follow next iter?

Report your standard per-chapter checklist, the HARD-GATE verdict (complete + correct) for each of the
three chapters above, any must-fix-this-iter findings, and your `## Unstarted-phase blueprint proposals`
section if any strategy phase still lacks coverage.
