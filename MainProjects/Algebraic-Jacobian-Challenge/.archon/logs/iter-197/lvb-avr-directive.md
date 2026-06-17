# Directive — lean-vs-blueprint-checker (AbelianVarietyRigidity iter-197)

## Files

- Lean: `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- Blueprint chapter: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## iter-197 prover delta (for context)

Lane E (post-blueprint-writer `avr-barescheme-mustfix-iter197` chapter
expansion) landed THREE new axiom-clean Proj-side helpers:

1. `Proj.basicOpenIsoSpec_inv_app_top`
2. `Proj.awayι_app_basicOpen`
3. `Proj.awayι_appIso_top_inv` — **renamed by the prover** from the
   blueprint's pinned `lem:awayi_appIso_top_inv_apply_isLocElem`
   (point-value form). The prover built the morphism-level form
   instead (cleaner, produces the same point-value evaluation via
   `congr`).

Consumer #1 `kbarChart1Ring_specMap_fac` advanced via these helpers
(Proj.appIso iter-188—194 STUCK signal RESOLVED) but the residual now
sits at `onePt.left.app(D₊(X_1))` evaluation — still a typed sorry.

File-level sorry count: 3 → 3 (no closure; structural advance only).

## Audit ask

1. Bidirectional check:
   - Lean → blueprint: do the three new helpers have matching
     `\lean{...}` pins in the chapter? Are signatures right?
   - Blueprint → Lean: the blueprint's
     `lem:awayi_appIso_top_inv_apply_isLocElem` (point-value form) is
     a candidate for **rename to the morphism-level form** the prover
     built. Confirm or flag.
2. Are the iter-196 / iter-197 "Status" notes in the chapter that
   describe pending blockers (Proj.appIso evaluation) now stale and
   ready to be rewritten to point to the new residual
   `onePt.left.app(D₊(X_1))` evaluation?
3. Lane E push-beyond consumer #2 `iotaGm_chart1_appIso_eval` was
   UNTOUCHED iter-197 — does its blueprint entry need a note that
   helper-substitution is now possible but not yet applied?
4. Any newly created `\uses{}` chain that's broken by the helper
   rename?

## Output

Standard lean-vs-blueprint-checker per-file bidirectional report.

## Read scope

`AlgebraicJacobian/AbelianVarietyRigidity.lean` and
`blueprint/src/chapters/AbelianVarietyRigidity.tex`.

Do NOT read STRATEGY.md / PROGRESS.md / iter sidecars / task results.
