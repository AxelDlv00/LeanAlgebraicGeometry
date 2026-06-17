# AlgebraicJacobian/RiemannRoch/RRFormula.lean

## Iter-192 summary

**Result: HARD BAR MET (file: 2 → 1 sorry).**

- Added `import AlgebraicJacobian.RiemannRoch.H1Vanishing`.
- Removed the local `private theorem Scheme.H1_skyscraperSheaf_finrank_eq_zero`
  (it was a typed-sorry shadow of the public declaration in `H1Vanishing.lean`).
  Replaced with a docstring-only comment block explaining the new sourcing.
- The downstream consumer `Scheme.eulerCharacteristic_skyscraperSheaf`
  references `Scheme.H1_skyscraperSheaf_finrank_eq_zero C P`; after the
  deletion the name resolves to the imported public version (iter-191
  Lane H), which closes via composition of `HModule_flasque_eq_zero`
  (still typed-sorry in H1Vanishing, Hartshorne III.2.5) and the
  axiom-clean `skyscraperSheaf_isFlasque`. So the H1 chain consumption
  is complete — `eulerCharacteristic_skyscraperSheaf` now traces all
  the way to the H1Vanishing carrier instead of stopping at a local sorry.

Build verifies cleanly:
- `lake build AlgebraicJacobian.RiemannRoch.RRFormula` → success.
- 1 remaining sorry warning: line 335 (`eulerCharacteristic_shortExact_add`).
- Axiom probe on key declarations: `propext, Classical.choice, Quot.sound,
  sorryAx`. The transitive `sorryAx` is inherited from
  `HModule_flasque_eq_zero` (H1Vanishing.lean) and the remaining local
  `eulerCharacteristic_shortExact_add` — both are off-critical-path
  documented blockers.

## H1_skyscraperSheaf_finrank_eq_zero (former line 468)

### Attempt 1 (iter-192)
- **Approach:** Add `import AlgebraicJacobian.RiemannRoch.H1Vanishing` and
  replace the body of the local `private` shadow theorem with a
  delegation `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero C P`.
- **Result:** FAILED on first build — error
  ``a non-private declaration `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero`
   has already been declared``. The `private` modifier in Lean 4 still
  registers the full namespaced name in the environment; importing the
  public version collides regardless of file-local visibility.

### Attempt 2 (iter-192)
- **Approach:** Delete the local `private theorem` entirely and replace
  with a docstring-only `/-! ... -/` block explaining the sourcing
  change. The downstream consumer call inside
  `eulerCharacteristic_skyscraperSheaf` resolves to the public version
  automatically.
- **Result:** RESOLVED. `lake build` succeeds with the H1 sorry
  removed; only the `eulerCharacteristic_shortExact_add` sorry remains.
- **Key insight:** `private` in Lean 4 controls *visibility* (callability
  from outside the file), not *namespace registration*. The fully
  qualified name still goes into the environment, so a `private`
  declaration cannot share a name with an `import`ed declaration even
  though it cannot be referenced from outside.

## eulerCharacteristic_shortExact_add (line 323; body at line 335)

### Attempt 1 (iter-192) — push-beyond evaluation
- **Approach:** Assess feasibility of closing within iter-192 budget.
- **Result:** DEFERRED. The PUSH-BEYOND condition in the directive was
  "if [the other sorry] is a downstream consumer of the same chain".
  `eulerCharacteristic_shortExact_add` is **not** a consumer of the H1
  skyscraper chain — it is a general χ-additivity-on-SES claim that
  needs different infrastructure:
  1. The project-side `ModuleCat kbar`-flavoured LES carrier specialised
     to `Scheme.HModule kbar` (Mathlib provides
     `Abelian.Ext.covariantSequence_exact` but the specialisation has
     not been done in the project).
  2. Grothendieck vanishing `HModule kbar F i = 0` for `i ≥ 2` on a
     1-dimensional scheme — at the project `Abelian.Ext (constSheaf
     kbar, -)` level (Mathlib has no schemes/curve-cohomology
     dimension lemma at this level).
  3. The 6-term alternating rank identity on `kbar`-finite-dimensional
     vector spaces (provable from `LinearMap.finrank_range_add_finrank_ker`
     plus iteration; ~30-60 LOC).
- **Dead end:** Closing the body requires (1)+(2) which together are
  the ~150-300 LOC sub-build flagged as off-critical-path in the
  blueprint's `% NOTE: gated on project-side LES carrier + finiteness
  machinery.` annotation (chapters/RiemannRoch_RRFormula.tex L264-275).
  The piece (3) alone does not close the sorry.
- **Next step (iter-193+):** Either factor piece (3) into a standalone
  helper for partial progress, or escalate via `mathlib-build` mode for
  the project-side LES carrier + Grothendieck vanishing pieces.

## Blueprint markers

- `lem:H1_skyscraperSheaf_finrank_eq_zero` (RRFormula.tex L342) was
  formerly `\leanok` on the type signature only because the local copy
  carried a sorry. After this iter, the public version in
  H1Vanishing.lean is the authoritative carrier; sync_leanok should
  recompute `\leanok` based on the H1Vanishing decl's axiom status
  (`sorryAx` still inherited from `HModule_flasque_eq_zero` body).
- All other declarations in RRFormula.lean retain their existing
  `\leanok` status (no signature changes).

## Lemmas discovered

- `CategoryTheory.Abelian.Ext.covariantSequence_exact` (Mathlib) —
  exact 6-term LES carrier for an SES in any HasExt abelian category.
- `Mathlib.ModuleCat.free_shortExact_finrank_add` — additivity of
  finrank on a 3-term SES of finite free modules.
- `LinearMap.finrank_range_add_finrank_ker` — the basic rank-nullity
  needed to iterate into a 6-term alternating-rank identity.

These are the building blocks any iter-193+ closure attempt should
consume.

## Push-beyond verdict

Genuinely blocked. Both sorries that remain in the file at iter-191
exit are gated on different substrate pieces:
- H1 sorry: chain on H1Vanishing.lean's `HModule_flasque_eq_zero`
  (Hartshorne III.2.5, iter-192+ Lane H critical-path target).
- shortExact_add sorry: project-side LES specialisation + Grothendieck
  H²-vanishing at the Ext-cohomology level.

This iter cleared the H1 sorry by importing the iter-191 substrate;
the shortExact_add sorry requires a different lane.
