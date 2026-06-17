# Directive — lean-vs-blueprint-checker (OCofP iter-197)

## Files

- Lean: `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- Blueprint chapter: `blueprint/src/chapters/RiemannRoch_OCofP.tex`

## iter-197 prover delta (for context)

Lane A substrate-build phase. Added 3 new axiom-clean substrate
helpers (the "mathlib-build" prover mode helper budget = 3):

1. `Scheme.lineBundleAtClosedPoint.localLift_of_log_ordFrac_eq_zero`
   (DVR-side `WithZero.log = 0` ⟹ unit-lift; ~25 LOC).
2. `Scheme.lineBundleAtClosedPoint.algebraMap_bijective_of_finite_isDomain_isAlgClosed`
   (Hartshorne I.3.4 algebraic kernel; ~10 LOC).
3. `Scheme.lineBundleAtClosedPoint.functionField_localUnit_of_orderZero_at_primeDivisor`
   (per-prime-divisor scheme-level wrapper of #1; ~15 LOC).

`functionField_const_of_complete_curve_of_orderZero` body advanced
to extract `stalkLift : ∀ Q, ∃ a, IsUnit a ∧ algebraMap _ K(C) a = f`
via helper #3 before the (still-typed) `sorry` on the global Hartogs
gluing.

File-level sorry count: 3 → 3 (substrate added in parallel; parent
sorry on global Hartogs + Γ=k̄ remains).

## Audit ask

1. Bidirectional check:
   - Lean → blueprint: do the three new helpers have `\lean{...}`
     pins in the chapter? The iter-196 plan-phase blueprint-writer
     `ocofp-leanrecipes` landed pins for sub-claims (a) / (b) / (c) —
     verify that the iter-197 prover's actual private-helper names
     match the pins.
   - Blueprint → Lean: any blueprint `\lean{...}` describing a Mathlib
     lemma that the prover ended up not using? Should be cleaned up.
2. The iter-196 review flagged broken `\uses` and pin labels
   (`order_conditions_of_globalSection`, `principal_ne_zero_of_nonconstant`).
   The iter-197 plan-phase ran a `blueprint-writer ocofp-pin-cleanup-iter197`
   dispatch that supposedly re-anchored these. Confirm the fix landed
   correctly (the prover task report claims "old labels grep zero matches").
3. The blueprint's two remaining Mathlib gaps (algebraic Hartogs at
   codim-1 / Γ=k̄ cohomology substrate) should now be precisely
   typed in the chapter (per the prover's "exact type statement"
   block). Verify the chapter has them with reasonable framing.

## Output

Standard lean-vs-blueprint-checker per-file bidirectional report.

## Read scope

`AlgebraicJacobian/RiemannRoch/OCofP.lean` and
`blueprint/src/chapters/RiemannRoch_OCofP.tex`.

Do NOT read STRATEGY.md / PROGRESS.md / iter sidecars / task results.
