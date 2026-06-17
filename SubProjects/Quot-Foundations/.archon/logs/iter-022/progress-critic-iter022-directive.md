# Progress-critic directive — iter-022

Assess convergence per active route. Two live prover lanes proposed for iter-022.

## Route GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean`

Target: close `genericFlatnessAlgebraic` (the algebraic core of generic flatness).
Strategy `## Phases` row "GF-alg": Status ACTIVE, Iters left 1–2. Phase entered ~iter-014.

Signals (last 4 iters):
- iter-018: L4 (`exists_localizationAway_finite_mvPolynomial`) PARTIAL — F1–F6 foundation landed, 1 honest sorry (finiteness leaf). Sorries in file: 3. Helpers added: ~6.
- iter-019: L4 injectivity crux FULLY PROVEN (ν/ψ/φ/compatibility-square/Function.Injective φ, axiom-clean); +1 helper `isLocalization_lift_injective`. Sorries: 3 (finiteness leaf @754 remained). Status PARTIAL (real progress).
- iter-020: dévissage 2/3 obligations of `genericFlatnessAlgebraic` closed; L4 finiteness leaf @754 UNCHANGED (explicit budget deferral, collapsing lemma pre-scouted). Sorries: 3. Status PARTIAL.
- iter-021: L4 finiteness leaf @754 CLOSED axiom-clean (`g:=g0·g1` witness + `IsIntegral.exists_multiple_integral_of_isLocalization`). `genericFlatnessAlgebraic` B/𝔭 cascade @2021 PARTIAL — documented sorry, 4-step assembly route left in code, the single new residual is the ring↔module localisation bridge (`LocalizedModule (powers g) C ≃ Localization.Away (algebraMap A C g)`). Sorries: 3→2. Status COMPLETE(L4)+PARTIAL(cascade).
- Recurring blocker phrase: "@754 deferred/unchanged" (iters 018–020) — RESOLVED iter-021.

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Target: close `base_change_mate_gstar_transpose` (Seam-3 counit coherence; the live crux after the iter-020 route swap).
Strategy `## Phases` row "FBC-A": Status ACTIVE, Iters left 2–3. Current crux (gstar) entered iter-020.

Signals (last 4 iters):
- iter-018: Seam-2 `fstar_reindex_legs` step-(iii) unmoved (5th consecutive iter); only a comment + 1 scaffolding line added. Sorries: 4. Status PARTIAL (no movement).
- iter-019: 2/5 atomic sub-lemmas closed (`_unitExpand`, `_gammaDistribute`); the assembly sorry UNMOVED (6th iter on that goal). Sorries: 4. Status PARTIAL.
- iter-020: ROUTE SWAP — refactor built `base_change_mate_domain_read` axiom-clean, re-routed `section_identity` via domain_read+codomain_read+gstar_transpose; the 6-iter-stuck `fstar_reindex` became dead code. No prover this iter (planner decision). Sorries: 4.
- iter-021: `gstar_transpose` PARTIAL — 2-rw reframing (`Iso.inv_comp_eq, ← Iso.eq_comp_inv`) isolated the two Γ-factors; route pinned to `CategoryTheory.conjugateEquiv_counit_symm` (dual of proven Seam-1); concrete 3-step next-iter recipe left. NOT closed. Sorries: 4. Status PARTIAL (first attempt on new crux; structure + route landed).
- Recurring blocker phrase: pre-swap "fstar_reindex literal-form lock" (6 iters) — RESOLVED by the iter-020 route swap. The new crux (gstar) has had exactly 1 prover attempt.

## Planner's proposed iter-022 objectives (2 lanes, 2 files)
1. `FlatteningStratification.lean` — close `genericFlatnessAlgebraic` B/𝔭 cascade @2021 (assembly; bridge the ring↔module localisation iso) + remove the stale L4 comment @531.
2. `FlatBaseChange.lean` — close `base_change_mate_gstar_transpose` @1551 via the pinned `conjugateEquiv_counit_symm` route + inline reindex + generator close.

Give per-route verdict (CONVERGING / CHURNING / STUCK / UNCLEAR) and any must-fix corrective.
