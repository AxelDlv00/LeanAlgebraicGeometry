# Session 27 (iter-027) — review summary

## Metadata
- **Sorry count**: 2 → 2 (no regression). Both intentional/frozen: superseded relative-form
  `CechAcyclic.lean:110` (`affine`, blueprint-authorized) + frozen P5b `CechHigherDirectImage.lean:679`.
  Both new files this iter are **0 sorry**.
- **Lanes planned 2, ran 2** (AbsoluteCohomology naturality; new `CechToCohomology.lean` — parallel
  mathlib-build). Both lanes landed their targets in full.
- **+17 axiom-clean declarations** (5 AbsoluteCohomology + 12 CechToCohomology); **0 new sorries**;
  **3 named blueprint targets landed** (1 Lane-1 + L1 + L2 of the 01EO chain).
- **Build**: both touched files `lake env lean … → EXIT 0`, diagnostic-clean. All probed named targets
  `lean_verify`-clean (`{propext, Classical.choice, Quot.sound}`): `absoluteCohomologyZeroAddEquiv_naturality`,
  `cechComplex_shortExact_of_basis`, `quotient_cech_vanishing_of_basis`, `shortExact_piMap`, `cechCohomology`.
- `archon dag-query`: **gaps (∞ holes) = 0**, **unmatched = 14** (all new `lean_aux` helpers from both files;
  listed in recommendations.md).

## The headline: both lanes closed; the 01EO chain is half-built first try
The iter-027 plan opened two parallel lanes; both made full axiom-clean progress with no churn,
no sorries, no blockers on what was attempted.

### Lane 1 — `absoluteCohomologyZeroAddEquiv_naturality` (AbsoluteCohomology.lean, +5)
Naturality of the landed H⁰≅Γ iso in the coefficient sheaf. Solved first attempt by decomposing the
`AddEquiv` into its two layers (`Ext.homEquiv₀` then `jShriekOU_homEquiv`) and proving naturality of
each (4 private helpers). The pivotal Lean fact: `Scheme.Modules.toPresheafOfModules X` is
**definitionally** the right-adjoint composite `SheafOfModules.forget ⋙ restrictScalars (𝟙 _)`
(verified by `rfl`), so `Adjunction.homEquiv_naturality_right` of the sheafification adjunction applies
directly. Carriers `F.obj (op U)` and `F.presheaf.obj (op U)` are defeq, so plain `rfl` folded them —
no `erw` gymnastics (the recurring obstacle class did not bite here).

Final signature (top arrow `H⁰(U,g) = e.comp (Ext.mk₀ g) (add_zero 0)`, bottom arrow
`g_U = ConcreteCategory.hom (((toPresheafOfModules X).map g).app (op U))`). Because the iso is an
`AddEquiv`, surjectivity of `g_U` ⇒ surjectivity of `H⁰(U,g)` — exactly the surjectivity-transfer input
L3 needs.

### Lane 2 — new `CechToCohomology.lean`, L1 + L2 of the 01EO chain (+12)
New file scaffolded (imports `CechBridge` + `AbsoluteCohomology`, namespace `AlgebraicGeometry`).
Built the section-Čech functoriality bricks (no Mathlib functoriality existed:
`sectionCechCosimplicialMap/Functor`, `sectionCechComplexFunctor/Map`), the `cechCohomology` accessor
(the effort-breaker's flagged naming item — now exists), and the two chain lemmas:

- **`cechComplex_shortExact_of_basis` (L1)** — `HomologicalComplex.shortExact_of_degreewise_shortExact`
  reduces to degree-`i` short-exactness; each degree is **defeq** to the `Pi.map` short complex of
  `faceShortComplex`, closed by the AB4* keystone `shortExact_piMap`.
- **`quotient_cech_vanishing_of_basis` (L2)** — abstract homological core
  `cechHomology_quotient_vanishing` (δIso dimension shift `Hᵖ(Q) ≅ Hᵖ⁺¹(F) = 0`) applied at the
  section-Čech short complex as a defeq wrapper.

**Signature divergence (important, see recommendations):** the prover used the COVER-LOCAL,
PRESHEAF-level form (`U : ι → Opens X`, `P : ShortComplex X.PresheafOfModules`, per-face `hface`
hypothesis) that the effort-breaker explicitly recommended ("no `Cov`"), strictly more general than
the cover-global `(B,Cov)`/sheaf prose currently in the blueprint. The Lean is correct and more
general; the **blueprint prose lags** (lvb cechtocohom two must-fix — both blueprint-side).

## Audits this iter
- **lean-auditor `iter027`**: both files clean. 0 critical / 0 major / 3 minor. `shortExact_piMap`
  confirmed genuine (Epi half manually proved via `AddCommGrpCat.epi_iff_surjective` + `Concrete.productEquiv`,
  not `inferInstance`; both directions of `Function.Exact` non-vacuous). `absoluteCohomologyZeroAddEquiv_naturality`
  a real commuting square (the two private rewrites do real work before `rfl`). Minors: one `erw`
  (AbsoluteCohomology:47), one aspirational forward-reference comment (AbsoluteCohomology:160), implicit
  `Mono` `inferInstance` in `shortExact_piMap`. No must-fix. Report:
  `.archon/task_results/lean-auditor-iter027.md`.
- **lean-vs-blueprint-checker `abscohom`**: CLEAN, 10 decls, 0 red flags. `absoluteCohomologyZeroAddEquiv_naturality`
  faithfully realizes `lem:absolute_cohomology_zero_natural`, no signature drift. 4 private helpers =
  minor coverage debt. Report: `.archon/task_results/lean-vs-blueprint-checker-abscohom.md`.
- **lean-vs-blueprint-checker `cechtocohom`**: 0 Lean-side red flags, but **2 must-fix (blueprint-side)** —
  L1/L2 prose describes cover-global/sheaf; Lean landed cover-local/presheaf. Plus 2 major coverage gaps
  (`shortExact_piMap`, `cechHomology_quotient_vanishing` need blueprint blocks). Report:
  `.archon/task_results/lean-vs-blueprint-checker-cechtocohom.md`.

## Blueprint markers updated (manual)
- `Cohomology_CechHigherDirectImage.tex`, `lem:cech_ses_of_basis`: added `% NOTE:` flagging the
  cover-local/presheaf landed signature vs. the cover-global/sheaf prose (lvb cechtocohom must-fix #1).
- `Cohomology_CechHigherDirectImage.tex`, `lem:quotient_vanishing_cech`: added `% NOTE:` flagging the
  cover-local signature with explicit hSES/hI/hF hypotheses vs. the "I injective" prose (lvb must-fix #2).
- No `\mathlibok` added: the new decls are project-proved (not Mathlib re-exports). No `\lean{}` rename
  needed (all pins matched). No stale `\notready` present.

## sync_leanok
`sync_leanok-state.json` iter=27, sha 83ac111, **added 10 / removed 2**. The iter-025/026 `\leanok`
mis-removal anomaly on `lem:ses_cech_h1` / `lem:injective_cech_acyclic` appears resolved this iter
(net positive add, CechBridge untouched). Not re-flagged.

## Key findings / reusable patterns (→ Knowledge Base)
1. **AB4* in Ab — product of SES is short exact (`shortExact_piMap`)**: `Epi (Pi.map φ)` is NOT
   `inferInstance` in `Ab` (only `Mono` is); prove the epi elementwise via `AddCommGrpCat.epi_iff_surjective`
   + `Concrete.productEquiv`, exactness via `ShortComplex.ab_exact_iff_function_exact`.
2. **Naturality of a composite `AddEquiv`, layer by layer**: decompose into the per-layer `Equiv`/adjunction
   naturalities. `toPresheafOfModules X = SheafOfModules.forget ⋙ restrictScalars (𝟙 _)` *definitionally*
   (`rfl`) unlocks `Adjunction.homEquiv_naturality_right` of `sheafificationAdjunction`.
3. **Cover-local/presheaf-level statement of section-Čech lemmas** (vs. cover-global/sheaf) is strictly
   more general and avoids threading `Cov`/`B`; push the geometric `ses_cech_h1` surjectivity in only as a
   per-face hypothesis `hface` at instantiation. Watch: the blueprint prose must track the landed signature.

## Recommendations for next plan iter
See `recommendations.md`. Headline: (1) add the `CechToCohomology` root import (must-fix, planner-owned);
(2) blueprint-writer rewrite of L1/L2 prose to the cover-local form + 2 new helper lemma blocks (HARD-GATE
prerequisite before L3/L4 provers); (3) the per-face SES derivation feeds L1's `hface`; (4) L3 is now
unblocked by the Lane-1 naturality landing; (5) 14 unmatched helpers to blueprint.
