# Directive — lean-auditor iter197

## Scope

Full whole-project audit of all `.lean` files under
`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/`.

Pay extra attention to the 5 files modified by the iter-197 prover phase:

- `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean`
- `AlgebraicJacobian/AbelianVarietyRigidity.lean`
- `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- `AlgebraicJacobian/RiemannRoch/OCofP.lean`
- `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`

Specifically check for:

1. **silent `sorryAx` propagation through typeclass synthesis** —
   especially in the carrier-soundness probe area
   (`Picard/FGAPicRepresentability.lean` + consumers). The iter-196
   plan committed to a smoke check at iter-197+ on any
   `HasPicScheme` / `HasPicSharp` instance carrier. Audit whether
   `lean_verify` on a consumer protected declaration shows
   `sorryAx` arriving via an unexpected route.

2. **Excuse-comments and dead-end TODO/sorry annotations** —
   does any iter-197 newly-added comment claim a closure that the
   `sorry` doesn't actually deliver?

3. **Outdated comments referencing iter-N decisions that no longer
   apply** (the iter-N references should match the actual file
   state).

4. **Suspect definitions / bad Lean practices** — `def := sorry`
   carriers, unsealed `private`-class instances, etc.

5. **Build-fragile patterns** introduced this iter — `change`-tactic
   workarounds, `simp only []` blank cases that mask bugs, etc.

## Output

Standard lean-auditor per-file checklist + flagged-issues block.
Tag must-fix-this-iter items clearly.

## Read scope

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/**/*.lean`

Do NOT read `STRATEGY.md`, `PROGRESS.md`, iter sidecars, or task
results — audit the Lean as Lean.
