# Directive — lean-vs-blueprint-checker (H1Vanishing iter-197)

## Files

- Lean: `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`
- Blueprint chapter: `blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`

## iter-197 prover delta (for context)

Lane H Route H-2 HARD-BAR-MET: closed 1 sorry (the `hinner_iso`
sorry at L851/855 of iter-196) via 4 new axiom-clean declarations:

1. `alphaConstToSkyPUnit` — `(Functor.const).obj A → skyscraperPresheaf PUnit.unit A`.
2. `betaSkyToConstPUnit` — opposite direction via `toSheafify`.
3. `alphaConstToSkyPUnit_comp_betaSkyToConstPUnit_eq_toSheafify` —
   composition lemma.
4. `Scheme.skyscraperSheaf_iso_constantSheaf_punit` — the inner iso.

`Scheme.skyscraperSheaf_eq_pushforward_const` is now fully
axiom-clean (verified by `lean_verify`).

Lane H Route H-1 (`IsFlasque.constant_of_irreducible` non-empty
branch, L138) NOT addressed iter-197. The prover noted a
fresh-approach pivot recommendation: stalk-based iso bridge via
`isIso_iff_stalkFunctor_map_iso` rather than the blueprint-described
"Full+Faithful constantSheaf" Mathlib gap.

`IsFlasque.injective_flasque` (L613, j_! gap) standing deferral.

File-level sorry count: 3 → 2.

## Audit ask

1. Bidirectional check:
   - Lean → blueprint: do the 4 new helpers + the now-closed
     `skyscraperSheaf_eq_pushforward_const` have correct `\lean{...}`
     pins?
   - Blueprint → Lean: is `lem:skyscraperSheaf_iso_constantSheaf_punit`
     (which the iter-196 blueprint-writer `h1v-mustfix-iter197` added)
     described correctly vs. what landed?
2. The blueprint sketches Route A (Full+Faithful constantSheaf for
   `IsFlasque.constant_of_irreducible`) — should this be amended with
   the prover's recommended stalk-based alternative
   (`isIso_iff_stalkFunctor_map_iso`)? This is a strategy-shaping
   pivot recommendation.
3. Any stale "iter-196 plan" notes in the chapter that now describe a
   step that landed?

## Output

Standard lean-vs-blueprint-checker per-file bidirectional report.
If the route-pivot recommendation in the prover task seems
significant, flag as "strategy-modifying findings" so the iter-198
plan agent picks it up.

## Read scope

`AlgebraicJacobian/RiemannRoch/H1Vanishing.lean` and
`blueprint/src/chapters/RiemannRoch_H1Vanishing.tex`.

Do NOT read STRATEGY.md / PROGRESS.md / iter sidecars / task results.
