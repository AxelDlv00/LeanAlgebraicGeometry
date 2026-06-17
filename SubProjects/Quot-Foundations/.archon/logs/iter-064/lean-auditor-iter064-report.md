# Lean Audit Report

## Slug
iter064

## Iteration
064

## Scope
- files audited: 1 (directive: single-file audit)
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianQuot.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Exactly 2 `sorry` occurrences, at L1973 and L2156. Both are documented honestly (see details below). No laundering detected.
  - Two `set_option maxHeartbeats 1600000` additions at L1721 and L1886. Both carry specific rationale comments citing the `X.Modules` diamond overhead. Justified.
  - Namespace structure is clean: 5 opens (`AlgebraicGeometry.Grassmannian` × 3, `AlgebraicGeometry.Scheme.Modules` × 2) all balanced by matching `end` at L309, L597, L1083, L1439, L2062, L2158. The double-open of `AlgebraicGeometry.Grassmannian` at L2064 is a deliberate second namespace block, not an error.
  - No `axiom`, `opaque`, or `native_decide` in any of the audited new declarations.
  - **L1973 (`tautologicalQuotient` sorry)**: The sorry is the `hk` argument of `Scheme.Modules.glueLift` — the equalizing condition asserting that the per-chart adjoint transposes agree over overlaps. The docstring explicitly says "the remaining `sorry` is the equalizing condition" and the inline comment names the mathematical content (chart compatibility `g_{IJ} ∘ f_{IJ}^* u^I = (t_{IJ} ≫ f_{JI})^* u^J`, matrix core `universalMatrix_map_transitionPreMap`). Honest. The sorry is NOT in the bundle transition machinery — `bundleTransitionData` and `bundleTransition_cocycle` are both fully proved and correctly supplied to `glueLift` before the sorry.
  - **L2156 (`represents` sorry)**: Full `noncomputable def … := sorry` for the universal property theorem. The docstring's NOTE section is honest about the upstream dependency on `tautologicalQuotient`. **However**, the NOTE contains a stale parenthetical — see the Major section below.
  - **New decls — `tripleOverlapSections` (L1522)**: Genuine content; wraps `(Scheme.ΓSpecIso _).inv ≫ Scheme.Hom.appTop (awayPullbackIso …).hom`.
  - **New decls — `baseChange_bridge_gammaSpec` / `_left` / `_right` / `_transition` / `baseChange_bridge` (L1511–L1719)**: All have substantive proofs. `baseChange_bridge` closes with a `calc` chain applying `bundleTransition_cocycle_matrix`. No vacuous bodies.
  - **New decl — `bundleTransition_cocycle_transport` (L1734)**: Heavy term-mode proof; the `set_option maxHeartbeats 1600000` is justified. No sorry. Closes the hom-level C2.
  - **New decl — `pullbackFreeIso_inv_congr_hom` / `pullbackCongr_hom_app_free` / `pullbackFreeIso_inv_congr` (L1405–L1437)**: All proved by `subst h; simp [Scheme.Modules.pullbackCongr]`. Marked `@[reassoc]`; the generated `_assoc` variants are actively used at L1840–L1844 inside `bundleTransition_cocycle_transport`. Not dead.
  - **New decl — `Scheme.Modules.glueLift` (L469)**: Genuine content — `equalizer.lift (Pi.lift k)` with a `Pi.hom_ext` equalizer argument. `_hC1`/`_hC2` are intentionally unused in the morphism construction (consistent with `glue`; documented). Not a vacuous statement.
  - **New decl — `tautologicalQuotientComponent` (L1940)**: Genuine content — the adjunction `homEquiv` applied to `pullbackFreeIso (ι_I) ≫ chartQuotientMap`. No sorry.
  - **Relocated comparison cluster (L1347–L1439)**: The three `pullbackFreeIso_inv_congr_*` lemmas and the `pullbackFreeIso_comp` proof body occupy this range in the `AlgebraicGeometry.Scheme.Modules` namespace block (L1085–L1439). No duplicate declarations; all are live (used downstream). No dead stubs left behind.
  - **Private ports (L729–L932)**: Six `private lemma …'` ports of `GrassmannianCells.lean` private lemmas (`mul_submatrix_col'`, `map_nonsing_inv'`, etc.). The `'` suffix distinguishes them from the originals; the porting rationale ("private there, cannot import") is documented. Not a sign of laundering — this is standard practice for unavailable private lemmas.
  - **Comment at L965 / L975 — phantom lemma name**: The comments inside `unitToPushforward_scalarEnd_comm` reference `PresheafOfModules.pushforward_map_app_apply'` as if it is a named lemma ("is `rfl`"), but `grep` confirms this identifier exists nowhere in the project's Lean source — it is only in these two comment strings. The proof does not call it; the defeq reduction actually proceeds by `scalarEnd_val_app_one` and `rfl`. A future reader looking for this lemma will not find it. Minor.

---

## Must-fix-this-iter

None.

- Both sorries are genuine open gaps with honest documentation.
- No excuse-comments on any declaration.
- No weakened or wrong definitions.
- No axioms on substantive claims beyond the two intentional sorry bodies.

---

## Major

- `GrassmannianQuot.lean:2148` — **stale progress note in `represents` docstring**. The NOTE reads: "this rides on `tautologicalQuotient` (hence on the bundle cocycle, the only remaining upstream gap)." After iter-064, `bundleTransition_cocycle` (the bundle cocycle) is **proved** — it is no longer a gap. The actual remaining upstream gap for `represents` is `tautologicalQuotient`'s L1973 sorry (the chart-quotient overlap / equalizing condition), not the bundle cocycle. The note should be updated to identify the correct blocking item. This is not a code defect, but it misidentifies what is blocking `represents`, which can mislead downstream planning.

---

## Minor

- `GrassmannianQuot.lean:965` and `GrassmannianQuot.lean:975` — **phantom lemma reference in comments**. `PresheafOfModules.pushforward_map_app_apply'` is mentioned by name as justification for a defeq step, but this identifier does not exist anywhere in the project (confirmed by `grep`). The proof is correct (the step goes by `rfl`); the comment is misleading for a reader trying to trace the derivation.

---

## Excuse-comments (always called out separately)

None. No excuse-comments were found. All sorry occurrences have substantive forward-progress documentation.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 1 (phantom lemma name in comments)
- **excuse-comments**: 0

Overall verdict: File is in good health — 2 honest sorries at L1973 and L2156, both with clear documentation; the two `set_option maxHeartbeats 1600000` additions are justified; no duplicate or dead declarations in the relocated cluster; all new decls have genuine content. One major stale comment in the `represents` docstring (incorrectly names the bundle cocycle as the remaining upstream gap; it was closed this iter) and one minor phantom lemma reference in an explanatory comment.
