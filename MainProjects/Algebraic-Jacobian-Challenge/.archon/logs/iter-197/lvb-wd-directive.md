# Directive — lean-vs-blueprint-checker (WeilDivisor iter-197)

## Files

- Lean: `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`
- Blueprint chapter: `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`

## iter-197 prover delta (for context)

Lane I closed 1 sorry: `hy_ne_bot` in
`isRegularInCodimOneProjectiveLineBar` (L916). The whole
`isRegularInCodimOneProjectiveLineBar` theorem is now fully
axiom-clean (`{propext, Classical.choice, Quot.sound}` only).

Closure path: generic-point-contradiction route (~30 LOC) rather than
the documented Stacks 02IZ topological-coheight bridge. Key insight:
`y.asIdeal = ⊥` ⟹ `y` is generic ⟹ `Y.point = genericPoint` ⟹
`Order.coheight Y.point = 0`, contradicting `Y.coheight = 1`.

File-level sorry count: 4 → 3.

Other lane I sorries (`rationalMap_order_finite_support`,
`principal_degree_zero`, `degree_positivePart_principal_eq_finrank`)
remain open — substrate-gated on Hartshorne I.6.12 (Mathlib gap,
analogist verdict `NEEDS_MATHLIB_GAP_FILL`).

## Audit ask

1. Bidirectional check:
   - Lean → blueprint: does `isRegularInCodimOneProjectiveLineBar`'s
     blueprint entry (`lem:isRegularInCodimOneProjectiveLineBar`)
     describe the iter-196 8-step PID-transfer route correctly?
     Should the now-closed `hy_ne_bot` step be updated from "pending"
     to the generic-point-contradiction proof sketch the prover used?
   - Blueprint → Lean: are the three remaining open sorries described
     with the right `NEEDS_MATHLIB_GAP_FILL` framing?
2. Is the blueprint's signaled proof route for `hy_ne_bot`
   (Stacks 02IZ topological-coheight bridge) stale — should the
   chapter now describe the generic-point-contradiction shortcut
   that landed?
3. Any chapter cross-reference to `isRegularInCodimOneProjectiveLineBar`
   that needs `\leanok` (handled deterministically by `sync_leanok` —
   just confirm the surface name matches)?

## Output

Standard lean-vs-blueprint-checker per-file bidirectional report.

## Read scope

`AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` and
`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex`.

Do NOT read STRATEGY.md / PROGRESS.md / iter sidecars / task results.
