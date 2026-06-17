# Lean ↔ Blueprint Checker — WeilDivisor iter199

## Files in scope

- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## Iter-199 changes

Lean: 2 new axiom-clean substrate helpers added
(`Scheme.RationalMap.order_neg` ~L290, `Scheme.RationalMap.order_pow_of_ne_zero`
~L308). The HARD BAR target
`rationalMap_order_finite_support_of_isNoetherian` was NOT added — the
recipe requires open-immersion stalk-bridge infrastructure not yet in
the file or Mathlib. File-level sorry count: 3 → 3 (unchanged).

Blueprint: plan-phase added a standalone `\lean{AlgebraicGeometry.Scheme.rationalMap_order_finite_support}`
block at L529 with `% SOURCE QUOTE` + 4-step proof sketch +
`[IsLocallyNoetherian X]` vs `[IsNoetherian X]` hypothesis gap analysis.

## What to check (bidirectional)

1. Are the 2 new Lean helpers (`order_neg`, `order_pow_of_ne_zero`)
   represented anywhere in the blueprint? If not, is a standalone
   `\lean{...}` pin appropriate (project-bespoke §2 substrate), or
   should they remain anonymous?
2. Does the chapter's narrative still match the file's current state
   regarding the HARD BAR helper's absence?
3. Any stale `\lean{...}` pins to declarations that don't exist or
   have moved?
4. Any blueprint claims that depend on the un-built helper?
