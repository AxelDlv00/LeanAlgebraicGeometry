# Iter 016 — Objectives (per-lane detail)

## Lane FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` [prove]

Close **Seam 2** `base_change_mate_fstar_reindex` (sorry ~1197), then cascade.

Recipe (chapter `% RECIPE (iter-015, LSP-validated)` + iter-015 prover report):
1. Identify generic-square legs `g'=pullback.fst`, `f'=pullback.snd` with `Spec(ιA)`, `Spec(ιR')`
   via `pullback_fst_snd_specMap_tensor` (scaffold already landed).
2. Transport the `(g')`-unit to the affine `Spec(ιA)`-unit through the conjugate calculus:
   `conjugateEquiv_pullbackComp_inv` (with `e = pullbackSpecIso`) + `unit_conjugateEquiv` /
   `unit_conjugateEquiv_symm` (the idiom that closed Seam 1). Do NOT `rw` on the bare legs (dependent
   `pushforwardCongr` term → "motive is not type correct"); go through the abstract calculus.
3. Collapse the transparent Γ-factors: `pushforwardComp_hom_app_app`/`_inv_app_app = 𝟙`,
   `pushforwardCongr_hom_app_app = presheaf.map (eqToHom).op` — restrictScalars-identity/eqToHom on Γ.
4. Feed Seam 1 `base_change_mate_unit_value` for the `Spec(ιA)`-unit Γ-value; reconcile RHS via
   `base_change_mate_codomain_read`, land on `base_change_mate_inner_value` (`ρ`).
Then Seam 3 `base_change_mate_gstar_transpose` (~1242): counit split (`Adjunction.homEquiv_counit`),
conjugate by `domain_read`/`codomain_read` (domain bakes in `pullback_spec_tilde_iso ψ`), identify
`extendScalars ψ ∘ ρ` with `regroupEquiv.inv` on generators. Seam 3 → `section_identity` /
`generator_trace` / `cancelBaseChange` → `affineBaseChange_pushforward_iso` (~1415, affine reduction).

**Partial-success bar:** Seam 2 alone (drops to ~2–3 sorries). OUT OF SCOPE: `flatBaseChange_pushforward_isIso` (FBC-B, ~1437).

## Lane GF — `AlgebraicJacobian/Picard/FlatteningStratification.lean` [prove]

**CLOSE** the helper `free_localizationAway_of_away_tower` (~1266) — CHURNING corrective, no further
decomposition. Plan (chapter `lem:gf_away_tower_descent` + iter-015 in-body plan):
- Ring side: `IsLocalization.surj (powers g) h` clears the denominator (`h·algebraMap s = algebraMap a`,
  `a ≠ 0`); `f := g·a ≠ 0` (SINGLE power — not `f²`); `Associated (algebraMap a) h`; install
  `Algebra A (Away h)` + tower; `IsLocalization.Away.mul_of_associated` gives `Away (g·a) (Away h)`.
- Module side (the real work): show `ψ := mkLinearMap(powers h) ∘ mkLinearMap(powers g) : T → D`
  satisfies `IsLocalizedModule (powers (g·a)) ψ` (localisation-of-localisation, via the 3
  `IsLocalizedModule` axioms — no packaged Mathlib lemma); transport `hfree` via `Module.Free.of_ringEquiv`
  along `IsLocalization.algEquiv (powers (g·a)) (Away (g·a)) A_h` + `extendScalarsOfIsLocalization`.
Then wire L5 `exists_free_localizationAway_polynomial` (~1321) steps 3–4 through the closed helper
(also reconcile the `htower` OreLocalization smul so the IH at `A_g` typechecks — see iter-015 report).
Then L4 `exists_localizationAway_finite_mvPolynomial` (~486, Finset-fold over `gf_clear_one_denominator`)
→ `genericFlatnessAlgebraic` (~1467) as budget allows.

**Partial-success bar:** helper closed + L5 steps 3–4 wired. OUT OF SCOPE: `genericFlatness` (~1529, GF-geo).

## Lane QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean` — NO PROVER THIS ITER (structural pivot)

Route 2 blueprint re-skeleton landed this iter (writer `quot-route2` + clean). iter-017 dispatches a
`mathlib-build` lane to CREATE the 5 ambient `AlgebraicGeometry.GradedModule.*` decls in the ordered
build list of `analogies/quot-hilbert-function-route.md` (data → ker/coker closure → D6 → ambient FG
transfer → `P(r)` induction → `(⊤,⊥)` bridge), reusing landed G1 + D5 + `IsRatHilb`. Hard constraint:
no `DirectSum.Decomposition` on a quotient/subtype carrier — every object stays ambient `Naux ⊓ ℳn`.
