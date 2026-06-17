# blueprint-reviewer · iter186

You are auditing the WHOLE blueprint (29 chapters; see
`blueprint/src/content.tex` for the canonical list). Your verdict
drives the iter-186 HARD GATE: which chapters are complete + correct
enough to back live prover work this iter.

Particular foci for iter-186:

1. **`Albanese_CodimOneExtension.tex`** — iter-185
   `blueprint-writer codimone-stacks-00tt` landed
   `lem:smooth_to_regular_local_ring` (Stacks 00TT) + new
   `lem:mem_domain_partial_map_reshuffle` blocks at L189-231.
   iter-186 plan-phase further reworded a `% NOTE` comment near L209
   to defeat a blueprint-doctor regex false-positive (literal
   `\uses{}` in a comment matched the doctor's empty-arg pattern).
   Verify: are these blocks complete + correct enough for iter-186
   Lane M↓ to re-open for the `IsRegularLocalRing` half? Specifically:
   - `lem:smooth_to_regular_local_ring` (around L189-231) — does it
     contain enough information that a Lean prover with Mathlib +
     `Algebra.Smooth` + `IsRegularLocalRing` can derive the conclusion?
   - `lem:mem_domain_partial_map_reshuffle` — is it self-contained?
   - Is `Albanese_CodimOneExtension.tex` chapter overall now
     COMPLETE + CORRECT for the `IsRegularLocalRing` half body work?

2. **`Picard_IdentityComponent.tex`** — iter-186 plan-phase
   dispatched `blueprint-writer identitycomponent-split-blocks` (Path B)
   to address the 2 MUST-FIX-THIS-ITER findings from
   `lean-vs-blueprint-checker iter185-identitycomponent`. The writer
   splits `thm:identity_component_open_subgroup` (4 sub-blocks) and
   `thm:pic_zero_is_abelian_variety` (3 sub-blocks).
   - **NOTE: the writer dispatch is concurrent with your audit; the
     chapter you read may or may not include the new blocks**, depending
     on dispatch ordering. If you find the chapter still has the
     OVER-LOADED 2 blocks (`thm:identity_component_open_subgroup`
     covering 4 conclusions; `thm:pic_zero_is_abelian_variety`
     covering 3), flag this as a CHAPTER-IN-FLIGHT condition and
     mark the chapter `partial` pending split landing — do NOT issue
     a new must-fix-this-iter for what is already being addressed.
   - If you find the split DID land, verify: does each new
     per-conclusion block have its own `\lean{...}` pin to a Lean
     name that exists in `AlgebraicJacobian/Picard/IdentityComponent.lean`
     (some new names like `IdentityComponent.isSubgroupHomomorphism`
     and `Pic0Scheme.finrank_eq_genus` are EXPECTED to NOT exist yet
     — that is intentional, those decls are scheduled for iter-187+
     scaffold; their absence is NOT a chapter-side defect)?

3. **`AbelianVarietyRigidity.tex`** — iter-186 plan-phase dispatched
   `blueprint-writer gmscaling-chart-agreement-expansion` to address
   the iter-185 MUST-FIX-THIS-ITER finding on
   `lem:gmscaling_chart_agreement` proof-sketch inadequacy. The
   writer adds tactic-level detail + 3 pickup paths + 6 `\lean{...}`
   pin additions. Same CHAPTER-IN-FLIGHT caveat as #2 above.

4. **`Picard_QuotScheme.tex`** — iter-186 plan-phase added a new
   `\subsection{Project-side base-change substrate}` after
   `\section{Cohomology and base change}` pinning 4 previously-unpinned
   Lean decls (`canonicalBaseChangeMap`, `_app_app_isIso`, `_isIso`,
   `Scheme.Modules.pullback_app_isoTensor`) as new blueprint-blocks
   each with their own `\lean{...}` pin. Verify the additions are
   well-formed (no overlong blocks, sources cited from the existing
   chapter material, no broken `\uses{...}` references to undefined
   labels).

## HARD GATE candidate lanes (10) for iter-186

Per-file mapping to chapter:

1. `AlgebraicJacobian/AbelianVarietyRigidity.lean` ←→
   `AbelianVarietyRigidity.tex` (consolidated `% archon:covers …`)
2. `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean` ←→
   `Albanese_AuslanderBuchsbaum.tex`
3. `AlgebraicJacobian/Albanese/CodimOneExtension.lean` ←→
   `Albanese_CodimOneExtension.tex`
4. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` ←→
   `AbelianVarietyRigidity.tex` (consolidated `% archon:covers …`)
5. `AlgebraicJacobian/Picard/IdentityComponent.lean` ←→
   `Picard_IdentityComponent.tex`
6. `AlgebraicJacobian/Picard/LineBundlePullback.lean` ←→
   `Picard_LineBundlePullback.tex`
7. `AlgebraicJacobian/Picard/QuotScheme.lean` ←→
   `Picard_QuotScheme.tex`
8. `AlgebraicJacobian/RiemannRoch/OCofP.lean` ←→
   `RiemannRoch_OCofP.tex`
9. `AlgebraicJacobian/RiemannRoch/RRFormula.lean` ←→
   `RiemannRoch_RRFormula.tex`
10. `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean` ←→
    `RiemannRoch_RationalCurveIso.tex`

Per the HARD GATE, each file F may be added to `## Current Objectives`
iff its corresponding chapter C is `complete: true` AND `correct: true`
AND no new must-fix-this-iter finding touches C.

## Unstarted-phase audit

Re-run the unstarted-phase blueprint coverage audit against
`STRATEGY.md` (29-chapter blueprint vs ~24 phases). The iter-185
audit identified 2 unstarted-phase candidates
(`Albanese_SmoothToRegular.tex` for Stacks 00TT formalisation,
iter-200+; `Picard_CastelnuovoMumford.tex` for Flattening
sub-helper) — re-confirm these are still applicable, and surface any
new gaps if `STRATEGY.md` row state has changed.

## Output

Standard per-chapter checklist (complete | partial | false on
{prose, sources, proofs, encoding}) + per-route HARD GATE verdict
(PASS / CONDITIONAL / FAIL) + must-fix-this-iter findings + unstarted-
phase proposals.

Report at `.archon/task_results/blueprint-reviewer-iter186.md`.
