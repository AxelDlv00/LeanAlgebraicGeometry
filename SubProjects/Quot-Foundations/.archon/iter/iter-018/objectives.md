# Iter 018 — Objectives (per-lane detail)

## Lane 1 — FBC `Cohomology/FlatBaseChange.lean` [prove]

**Target:** `base_change_mate_fstar_reindex_legs` step-iii crux, `sorry` line 1324. Then cascade Seam 3
`base_change_mate_gstar_transpose` (1428).

**Recipe (from iter-017 prover report + blueprint `lem:base_change_mate_fstar_reindex_legs` step-iii):**
after the `subst hfst; subst hsnd` + the step-(ii) Γ-collapses already in the proof, the goal is the
affine-model identity with surviving unit factor
`(moduleSpecΓFunctor).map ((pushforward (Spec φ)).map (unit_{e≫Spec ιA}))` and
`key := pullbackPushforward_unit_comp e.hom (Spec.map inclA) (tilde M)` staged. Steps:
(a) rewrite the unit factor by `key`;
(b) discharge the `e`-unit as an iso via `pullback_isEquivalence_of_iso` and absorb it into
`base_change_mate_codomain_read_legs`;
(c) read the surviving `Spec ιA`-unit's Γ-value through Seam 1 `base_change_mate_unit_value`;
(d) compose with the codomain read + `restrictScalars ψ` to land `base_change_mate_inner_value`.
Note: `gammaMap_pushforwardComp_hom_eq_id` collapses naturally once the unit factor is rewritten by
`key` (it misses the discrimination tree at the step-(ii) `simp` position — expected).

**Mathlib pins:** `pullback_isEquivalence_of_iso` [verified iter-017], `Adjunction.homEquiv_counit`
[expected] for Seam 3.

**Partial bar:** step-iii crux (fully closes Seam 2). **OOS:** affine (1601), FBC-B (1623).
**Do NOT** add a new opaque helper — the residual is one isolated mate-unwinding goal.

## Lane 2 — GF `Picard/FlatteningStratification.lean` [prove]

**Target:** L4 `exists_localizationAway_finite_mvPolynomial`, `sorry` line 516. Then
`genericFlatnessAlgebraic` (1558) as budget allows.

**Recipe (iter-017 prover decomposition + blueprint `lem:gf_noether_clear_denominators` Steps 1–2):**
in-code already obtained `gK : MvPolynomial (Fin s) K → B_K` injective + module-finite (field Noether
normalisation). Descend to `A_g`:
(1) **injectivity** — `b_j := gK(X_j)` alg-independent over `K`; restrict along `A_g ↪ K` (the
`IsLocalization.map … hle` embedding used in `gf_clear_one_denominator`) → independent over `A_g` →
φ injective. Atoms: `AlgebraicIndependent.restrictScalars` [expected], `MvPolynomial.aeval_injective`
[expected].
(2) **module-finiteness** — Finset-fold of the CLOSED `gf_clear_one_denominator` (409) over the
integral-dependence coefficient polynomials of a finite `MvPolynomial (Fin s) K`-generating set of
`B_K`; common `g` makes relations hold over `A_g[b_1..b_s]`; generating-set push →
`Module.Finite (MvPolynomial (Fin s) A_g) B_g`.

**Partial bar:** L4 close. **OOS:** `genericFlatness` (1625, GF-geo). Recipe file:
`analogies/gf-generic-rank-ses.md`.

## Lane 3 — QUOT `Picard/QuotScheme.lean` [prover-mode: mathlib-build]

**Targets (bottom-up, axiom-clean, no sorry):**
1. `Module.Finite (MvPolynomial (Fin r) κ) M` from `r` commuting degree-1 endos:
   `A := Algebra.adjoin κ {x₀..x_{r-1}} ⊆ End_κ M`; `Algebra.isMulCommutative_adjoin κ hcomm`
   ([verified]) → `IsMulCommutative ↥A` → `CommRing`/`CommMonoid A` by `inferInstance`; `aeval` into `A`
   + `Module.compHom` for the `κ[t]`-module with `Xᵢ • m = xᵢ m`. **NOT** the deprecated
   `Algebra.adjoinCommRingOfComm`.
2. subquotient-datum `structure` (bundle `N'≤N` homogeneous + `r` commuting `RaisesDegree` endos
   preserving `N,N'` + poly-module + scalar-tower + `Module.Finite`).
3. `subquotient_finite_transfer` — one-generator descent via the FREE-poly surjection
   `κ[t₀..t_{r-1}] ↠ κ[t₀..t_{r-2}]` (`X_{r-1}↦0`) + `Submodule.FG.restrictScalars_of_surjective`
   ([verified carried]); uses `x_{r-1}` annihilates K,C from `subquotient_ker_coker`.
4. `subquotient_hilbertSeries_rational` — `P(r)` induction: base `r=0` via `IsRatHilb.ofEventuallyZero`;
   step feeds D6 + IH(K) + IH(C) into `IsRatHilb.ofDiffEq` + `.bump`.
5. `(⊤,⊥)` bridge into `gradedModule_hilbertSeries_rational`.

**HARD ENTRY CONSTRAINT:** no `DirectSum.Decomposition`/`IsInternal` on quotient/subtype carriers —
ambient `Naux ⊓ ℳn` only. Smaller ring = free `κ[t₀..t_{r-2}]`, NOT `adjoin {x₀..x_{r-2}}`. isDefEq/whnf
recurrence ⇒ STOP + report, no heartbeat raises. Hand off a precise decomposition at the first genuine
block. Protected stubs (123/161/198/225) untouched.
