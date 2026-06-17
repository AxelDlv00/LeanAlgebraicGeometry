# Session 21 (iter-021) — Review Summary

## Metadata
- **Session / iter:** session_21 = iter-021. Model: claude-opus-4-8 (provers).
- **Lanes dispatched:** 2 prover lanes (GF prove, FBC prove) + 1 enabling refactor (`quot-split`, plan-phase).
- **Active `sorry` (tactic-body) before → after, per file:**
  - `FlatteningStratification.lean` (GF): **3 → 2** (−1). Closed L4 finiteness leaf @754.
    Remaining: B/𝔭 cascade @2021, GF-geo @2109.
  - `FlatBaseChange.lean` (FBC): **4 → 4** (net 0). `gstar_transpose` @1551 partial (route + 2-`rw`
    reframing landed, sorry remains); dead `fstar_reindex_legs` @1421; affine @1724; FBC-B @1746.
  - `QuotScheme.lean` (QUOT): **4 → 4** (file-split refactor only; 4 protected stubs @126/165/201/228).
  - `GradedHilbertSerre.lean` (QUOT, NEW): **0** sorries (keystone axiom-clean, created by file-split).
- **Net:** −1 active sorry; +1 axiom-clean theorem closed (GF L4); 0 new top-level decls from provers.
- **Build:** both prover-edited modules `lake build` EXIT 0 (8317/8318 jobs); FBC + GF axiom-clean
  (`lean_verify` → `{propext, Classical.choice, Quot.sound}`).
- **Coverage debt:** `archon dag-query unmatched` = **0**; `gaps` = **0**. Clean.
- **blueprint-doctor:** no structural findings (0 orphans, 0 broken refs, 0 axioms).

## Headline
The **GF L4 finiteness leaf** (`exists_localizationAway_finite_mvPolynomial`,
`lem:gf_noether_clear_denominators`) — deferred 3 iters (018/019/020) and the progress-critic's
must-fix this iter — is **CLOSED axiom-clean** on the first genuine attempt. This was the planner's
rebuttal target against the GF-STUCK→pivot reading, and it landed.

## Target 1 — `exists_localizationAway_finite_mvPolynomial` (GF L4) — SOLVED ✅

**File:** `FlatteningStratification.lean`, decl @505, leaf was @754.
**Result:** RESOLVED, axiom-clean (verified `lean_verify` →
`AlgebraicGeometry.GenericFreeness.exists_localizationAway_finite_mvPolynomial`:
`{propext, Classical.choice, Quot.sound}`).

**Structure of the close** (all local `have`/`letI`/`set`; no new top-level decls):

1. **`g1` construction (denominator clearing).** `MvPolynomial.algebraMvPolynomial`
   (`Algebra (MvPoly A) (MvPoly K)`, NOT a global instance — `letI`) + `MvPolynomial.isLocalization`
   (`IsLocalization (Submonoid.map C A⁰) (MvPoly K)`). Scalar tower `MvPoly A → MvPoly K → B_K`; each
   generator `algebraMap B B_K x` integral over `MvPoly K` (`hint.isIntegral`); the **collapsing lemma**
   `IsIntegral.exists_multiple_integral_of_isLocalization` yields `a ∈ A⁰` with `C a • (...)` integral
   over `MvPoly A`. Set `g1 := ∏_{x∈σ} a`, `g := g0·g1`.
2. **Scaffolding transfer `g0 → g`.** `ν/ψ/b/φ/hsquare/hφ_inj` transferred verbatim; only `hgB_unit`
   changed (via `g0 ∣ g`: `isUnit_of_dvd_unit (map_dvd …)`); `hcomp` (`ν∘φ = gK∘map ψ`) hoisted out of
   `hφ_inj` so the finiteness block reuses it.
3. **Finiteness `hfin`:** (I) per-generator integrality over `MvPoly A_g` via `algAgBK := (gK∘map ψ).toAlgebra`,
   `isIntegral_algHom_iff νA hν_inj`, `IsIntegral.tower_top`, divide out the unit `C(aGen x)`;
   (II) `adjoin (MvPoly A_g) (image σ) = ⊤` via `Algebra.adjoin_induction` over `A_g` (algebraMap case
   through the `IsLocalization.Away.map` square) bumped to `MvPoly A_g` via `restrictScalars`+`adjoin_le`;
   (III) `Algebra.finite_adjoin_of_finite_of_isIntegral` + `rw [hadj]` + `Module.Finite.equiv (Subalgebra.topEquiv.toLinearEquiv)`.

**Errors encountered and fixed (from `attempts_raw.jsonl`):**
- `failed to synthesize Algebra (MvPolynomial (Fin s) A) (MvPolynomial (Fin s) (FractionRing A))` →
  `letI ... := MvPolynomial.algebraMvPolynomial`.
- `IsIntegral ... expected Scheme` (the `AlgebraicGeometry` namespace shadows the root `IsIntegral`) →
  `_root_.IsIntegral`.
- `typeclass instance problem is stuck IsLocalization (Submonoid.powers g) ?m` → annotate
  `set ψ : Localization.Away g →+* FractionRing A := IsLocalization.lift ...` (RingHom codomain pin).
- `Tactic rfl failed: ... C (aGen x) not defeq` for `hwC` → use `change ... ; simp only [MvPolynomial.map_C]`
  (NOT `rfl`; `algebraMap (MvPoly A) (MvPoly A_g) = MvPolynomial.map (algebraMap A A_g)` holds by `rfl`
  but the `C`-pushforward needs `map_C`).
- `rw [map_mul]` under `set Bg/set Ag` → `motive is not type correct` (OreLocalization abstraction); use
  `simp only`. `rw [← h.unit_spec]` where `h` depends on the rewritten term → same; restructure to
  `IsUnit.val_inv_mul` / `Units.inv_eq_of_mul_eq_one_right`.

**Key API confirmed (re-verify on Mathlib bump):** `IsIntegral.exists_multiple_integral_of_isLocalization`,
`MvPolynomial.isLocalization`, `MvPolynomial.algebraMvPolynomial`, `isIntegral_algHom_iff`,
`IsIntegral.tower_top`, `Algebra.finite_adjoin_of_finite_of_isIntegral`, `IsLocalization.lift_comp`,
`IsLocalization.surj`, `IsLocalization.Away.map`.

## Target 2 — `genericFlatnessAlgebraic` (B/𝔭 cascade) — PARTIAL ⚠

**File:** `FlatteningStratification.lean`, node @2021. Now that L4 + L5 are both axiom-clean, the
planner asked to discharge the `N ≅ B/𝔭` dévissage node. The prover replaced the stale placeholder
comment (which still claimed L4/L5 "under construction") with a precise **4-step assembly route**:
(1) `C := B ⧸ p.asIdeal` (instances `IsDomain C`, `Algebra A C`, `FiniteType A C`), transport freeness
along the `A`-linear equiv `a`; (2) torsion split on `C ⊗_A K`; (3) L4 → `C_g` finite over
`MvPoly A_g[X_n]`; (4) feed `C_g` to L5, descend via `free_localizationAway_of_away_tower`.

**Genuine new residual:** the **ring-localisation ↔ module-localisation bridge** in step (4) —
`Localization.Away (algebraMap A C g)` vs `LocalizedModule (powers g) C`. Left an honest documented
`sorry` per PROGRESS §Objective-1. Next iter: bridge via an `IsLocalizedModule`-uniqueness iso
`LocalizedModule (powers g) C ≃ Localization.Away (algebraMap A C g)`, then pure assembly.

## Target 3 — `base_change_mate_gstar_transpose` (FBC Seam-3) — PARTIAL ⚠

**File:** `FlatBaseChange.lean`, decl @1490, sorry @~1551. First prover attempt on the new live crux
(promoted by the iter-020 route swap). Two `rw`s landed + the route was pinned; the sorry remains.

- `rw [Functor.map_comp]` (pre-existing) splits `Γ(g^*(θ_in) ≫ ε_g)`; **NEW**
  `rw [Iso.inv_comp_eq, ← Iso.eq_comp_inv]` moves `Θ_src/regroupEquiv/Θ_tgt` to the RHS, isolating the
  two geometric Γ-factors. Goal now `Γ_{R'}(g^*(θ_in)) ≫ Γ_{R'}(ε_g) = (Θ_src.hom ≫ regroupEquiv.inv) ≫ Θ_tgt.inv`.
- **Route identified:** gstar is the COUNIT companion of the proven Seam-1 `base_change_mate_unit_value`.
  Use `CategoryTheory.conjugateEquiv_counit_symm` (Mathlib `Mates.lean:287`) instantiated at
  `adjL/adjR/α` mirroring `pullback_spec_tilde_iso ψ`.
- **Why harder than Seam-1 — it bundles two pieces:** (a) inner reindex of `θ_in` over `Spec R` must be
  reproven **inline** (citing the sorry-backed `fstar_reindex` is BANNED — forfeits axiom-cleanliness),
  reusing the PROVED `…_legs_unitExpand`/`_gammaDistribute` + `gammaMap_pushforwardComp_*` + Seam-1's
  value; (b) generator close against `base_change_mate_regroupEquiv`.
- **Confirmed dead ends (do NOT repeat):** per-generator brute force (`ext x` then `rfl`/`simp`) — the
  geometric counit/pullback/Γ have no element-level normal form; routing through `fstar_reindex` (Seam-2,
  sorry-backed dead code).

## Refactor (plan-phase) — `quot-split`
`QuotScheme.lean` 1696→423 lines; new `GradedHilbertSerre.lean` (1287 lines, graded Hilbert–Serre layer,
0 sorries, keystone axiom-clean); 11 IsRatHilb-toolkit decls de-privatized (clears recurring M1); stale
iter-020 comment removed (clears the iter-020 major); root `AlgebraicJacobian.lean` imports the new
module. No signature/label/name changes; no protected-decl moves. Coverage debt for the 2 new GradedModule
helpers was blueprinted (leandag clean).

## Key findings / patterns discovered
- **The collapsing lemma `IsIntegral.exists_multiple_integral_of_isLocalization` is the L4 unlock** —
  one call replaces a manual per-coefficient denominator-clearing fold. The `g := g0·g1` two-factor
  witness is mathematically mandatory (the `g0`-only finiteness is generically false-typed).
- **`algebraMap (MvPoly A) (MvPoly S) = MvPolynomial.map (algebraMap A S)` by `rfl`** (the
  `algebraMvPolynomial` algebraMap) — load-bearing simplification throughout L4.
- **Namespace shadow:** inside `namespace AlgebraicGeometry`, bare `IsIntegral` resolves to a
  scheme-typed clash; use `_root_.IsIntegral`. (Recurs from the iter-011 `open Polynomial` shadow note.)
- **FBC gstar is a two-piece bundle** — the route swap that obviated `fstar_reindex` concentrated both
  the inner-reindex content and the generator close into this one crux.

## Blueprint markers updated (manual)
- None this iter. Both task results report "Needs blueprint entry: None" (all prover work was local
  `have`/`letI`/`set`; no new top-level decls, no renames, no Mathlib-backed re-exports). No `\mathlibok`,
  `\lean{}` correction, `% NOTE`, or stale `\notready` change was warranted.

## ⚠ sync_leanok anomaly (flagged for the planner — NOT a marker I can fix)
`sync_leanok-state.json` shows iter-021 ran (sha 9834fa4), but `chapters_touched` is **only**
`Picard_QuotScheme.tex`. The **entire GF chapter `Picard_FlatteningStratification.tex` has 0 `\leanok`
markers** — including L4 (just closed), L5 (`exists_free_localizationAway_polynomial`, closed iter-017),
and `isLocalization_lift_injective` (closed iter-019), all sorry-free + axiom-clean **public** theorems.
This is a systemic sync resolution failure for the GF chapter (the dashboard materially under-reports GF
progress). `\leanok` is owned by `sync_leanok`, not the review agent — surfaced in `recommendations.md`.

## Subagent reports
- See `recommendations.md` for landed findings from `lean-auditor` (iter021) and the two
  `lean-vs-blueprint-checker`s (FBC, GF). Reports under `.archon/task_results/` and archived to
  `logs/iter-021/`.
