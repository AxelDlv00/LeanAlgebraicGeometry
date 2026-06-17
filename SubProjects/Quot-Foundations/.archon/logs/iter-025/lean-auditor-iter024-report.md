# Lean Auditor Report — iter024

**Date:** 2026-06-07  
**Scope:** All 8 project `.lean` source files  
**Focus:** (A) `FlatBaseChange.lean` new `eCancel` atoms, `gstar_generator_close`, staleness of comments in `inner_value_eq`/`gstar_transpose`; (B) `QuotScheme.lean` new section docstring and new theorem bodies  
**Role:** Read-only audit; no edits made

---

## Per-File Checklist

### `AlgebraicJacobian.lean` (7 lines)

- [x] File is imports-only; no proof content. No issues.

---

### `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (100 lines)

- [x] Single declaration `base_change_regroup_linearEquiv`: proved, axiom-clean.
- [x] No `sorry` present.
- [x] Section docstring accurate.

---

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (2008 lines) — PRIMARY FOCUS

#### New atoms (this iteration)

| Declaration | Line | Verdict |
|---|---|---|
| `base_change_mate_inner_eCancel_eUnit` | ~1498 | **CORRECT** — `haveI := pullback_isEquivalence_of_iso e; infer_instance` |
| `base_change_mate_inner_eCancel_pushforwardComp` | ~1510 | **CORRECT** — `h : … = 𝟙 _` + `(moduleSpecΓFunctor (R := R)).congr_map` |
| `base_change_mate_inner_eCancel_pullbackComp` | ~1527 | **CORRECT** — `exact (Scheme.Modules.pullbackComp _ _).hom_inv_id_app (tilde M)` |
| `base_change_mate_gstar_generator_close` | ~1545 | **CORRECT** — `erw [ModuleCat.ExtendRestrictScalarsAdj.Counit.map_apply_one_tmul]; rfl` |

All four new atoms have sound bodies; no gaps, no weakened types.

#### Comment staleness check — `base_change_mate_inner_value_eq` (~lines 1612–1626)

The comment reads (paraphrase): "New atoms proved; wiring blocked by literal-form-lock after `subst` of pullback legs." This accurately describes the current state (the sorry at ~line 1627 is blocked by the known `fbc-subst-legs-literal-form-lock` pathology). **ACCURATE — not stale.**

#### Comment staleness check — `base_change_mate_gstar_transpose` (~lines 1797–1809) — **MUST-FIX**

The comment lists a "REMAINING CRUX" with item (b):

> "the generator close `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv`"

This is precisely what `base_change_mate_gstar_generator_close` proves, and that theorem was **closed this iteration** (line ~1545, body `erw [...]; rfl`). The comment still marks it as remaining. **STALE — must update.**

The sorry at line ~1810 in `base_change_mate_gstar_transpose` remains legitimate (wiring from the closed generator close into the full adjoint mate computation is still blocked), but the comment describing the blockers is now inaccurate.

#### Full sorry inventory for FlatBaseChange.lean

| Declaration | Line | Classification |
|---|---|---|
| `base_change_mate_fstar_reindex_legs` | ~1421 | EXPECTED — dead/orphaned per directive |
| `base_change_mate_inner_value_eq` | ~1627 | EXPECTED — literal-form-lock (known pathology) |
| `base_change_mate_gstar_transpose` | ~1810 | EXPECTED — crux sorry, wiring incomplete |
| `base_change_mate_section_identity` | delegates | EXPECTED — sorry-backed via `gstar_transpose` |
| `base_change_mate_generator_trace` | delegates | EXPECTED — via `section_identity` |
| `pushforward_base_change_mate_cancelBaseChange` | delegates | EXPECTED — via chain |
| `affineBaseChange_pushforward_iso` | ~1983 | EXPECTED — out of scope this iter |
| `flatBaseChange_pushforward_isIso` | ~2005 | EXPECTED — out of scope this iter |

No unexpected sorry found.

---

### `AlgebraicJacobian/Picard/QuotScheme.lean` (549 lines) — PRIMARY FOCUS

#### New section docstring (~line 425)

```
/-! ## Project-local Mathlib supplement — quasi-coherent sections localize on a basic open -/
```

Describes the two new theorems that follow: `isLocalizedModule_tilde_restrict` and `isLocalizedModule_restrict_of_isIso_fromTildeΓ`. **ACCURATE.**

#### New theorem `isLocalizedModule_tilde_restrict` (~line 467)

Body uses `tilde.isoTop N` for `e : N ≃ₗ[R] _`, applies the triangle identity, and invokes `IsLocalizedModule.of_linearEquiv_right`. Proved. Type matches description. **CORRECT.**

#### New theorem `isLocalizedModule_restrict_of_isIso_fromTildeΓ` (~line 510)

Transports localization across the isomorphism induced by `M.fromTildeΓ` being iso, using `convert step2 using 1` and `LinearMap.ext`. Proved. **CORRECT.**

#### Protected stubs (4 expected)

| Declaration | Status |
|---|---|
| `hilbertPolynomial` | EXPECTED sorry stub |
| `QuotFunctor` | EXPECTED sorry stub |
| `Grassmannian` | EXPECTED sorry stub |
| `Grassmannian.representable` | EXPECTED sorry stub |

No unexpected sorry found.

---

### `AlgebraicJacobian/Picard/RelativeSpec.lean` (294 lines)

- [x] `QcohAlgebra` structure: 3-field structure (`sheaf`, `unit`, `coequifibered`). No sorry.
- [x] `RelativeSpec`: body `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued`. Proved, correct.
- [x] `RelativeSpec.structureMorphism`: body `.toBase`. Proved, correct.
- [x] `RelativeSpec.UniversalProperty`: proved via `isAffineHom_of_forall_exists_isAffineOpen` + `Cover.RelativeGluingData.toBase_preimage_eq_opensRange_ι`. Axiom-clean.
- [x] `RelativeSpec.affine_base_iff`: proved via `UniversalProperty` + `isAffine_of_isAffineHom`. Axiom-clean.
- [x] No `sorry` anywhere in file.

---

### `AlgebraicJacobian/Picard/GradedHilbertSerre.lean` (1288 lines)

All sections fully read. No `sorry` found.

Key declarations verified:
- `IsRatHilb` toolkit (`ofEventuallyZero`, `bump`, `sub`, `shiftRight`, `antidiff`, `ofDiffEq`): all proved.
- `GradedModule` namespace: `RaisesDegree`, `subquotientHilb`, `polyModule`, `polySubmodule`, `lastVarAlgHom`, `subquotient_finite_transfer`, `polyQuot_finite_of_le_denominator`, `polyQuot_finite_of_le_numerator`: all proved.
- `SubquotientDatum` structure with fields `N`, `N'`, `hle`, `hN`, `hN'`, `t`, `hcomm`, `hraise`, `hpresN`, `hpresN'`, `hfin`: correct.
- `SubquotientDatum.ker`, `SubquotientDatum.coker` constructors: proved.
- `subquotient_base_eventuallyZero` (base case): proved via `iSupIndep_map_of_mem_ker_sup` + Noetherian finiteness.
- `subquotient_hilbertSeries_rational` (induction): proved via `IsRatHilb.ofDiffEq`.
- `gradedModule_hilbertSeries_rational` (top-level Hilbert–Serre): proved.

No issues.

---

### `AlgebraicJacobian/Picard/GrassmannianCells.lean` (636 lines)

All 636 lines read. No `sorry` found.

Key declarations verified (all proved, axiom-clean):
- `affineChart`: `Spec (CommRingCat.of (MvPolynomial (Fin d × {q // q ∉ I}) ℤ))`. Correct.
- `universalMatrix`, `minorDet`, `universalMinor`, `universalMinorInv`: definitions, no sorry.
- `isUnit_det_universalMinor`, `universalMinorInv_mul_cancel`: proved.
- `imageMatrix`, `transitionPreMap`: definitions.
- `universalMatrix_submatrix_self`: proved via `Finset.orderIsoOfFin` + `EmbeddingLike.apply_eq_iff_eq`.
- `imageMatrix_submatrix_self` (`M_J = 1`): proved.
- `imageMatrix_submatrix_I` (`M_I = Cramer inverse`): proved.
- `universalMatrix_map_transitionPreMap` (matrix formula): proved.
- `isUnit_transitionPreMap_minorDet`: proved.
- `transitionMap`: definition (away-localisation lift).
- `transitionMap_self` (`θ_{I,I} = id`): proved via `IsLocalization.ringHom_ext`.
- `awayInclLeft`, `awayInclRight`, `awayInclLeft_comp_algebraMap`, `awayInclRight_comp_algebraMap`: proved.
- `transitionPreMap_minorDet` (general minor formula): proved.
- `cocycleΘIJ`, `cocycleΘJK`, `cocycleΘIK` (triple-overlap transition maps): definitions.
- `cocycle_imageMatrix_eq` (matrix identity behind cocycle): proved via `inv_mul_inv_mul_cancel`.
- `cocycleCondition` (`Θ_{I,K} = Θ_{I,J} ∘ Θ_{J,K}`): proved via `IsLocalization.ringHom_ext` + `MvPolynomial.ringHom_ext`.

No issues.

---

### `AlgebraicJacobian/Picard/FlatteningStratification.lean` (2267 lines)

All 2267 lines read. One `sorry` found.

#### Sorry inventory

| Declaration | Line | Classification |
|---|---|---|
| `genericFlatness` | 2264 | EXPECTED — missing Mathlib bridges GAP G1 + GAP G3 (documented in-file comment) |

The sorry in `genericFlatness` is preceded by a 66-line comment block (lines 2198–2263) that (a) documents a prior signature-correctness fix (`[QuasiCompact p]` added), (b) gives a precise route-to-close (4 steps), and (c) identifies the two missing bridges:

- **GAP G1** — quasicoherent + finite-type ⟹ `Module.Finite Γ(X,W) Γ(F,W)` (affine-local identification `F|_W ≅ (Γ(F,W))~` with finiteness not yet in Mathlib).
- **GAP G3** — flat-locality assembly from a finite source cover.

The algebraic core `genericFlatnessAlgebraic` (line 1981) is **fully proved and axiom-clean** — the sorry lives only in the geometric wrapper. The comment correctly describes the state. **EXPECTED, well-documented.**

Key proved declarations (no sorry, all fully read):
- `GenericFreeness.exists_free_localizationAway_of_finite` (L1 finite leaf): proved.
- `GenericFreeness.exists_free_localizationAway_of_torsion` (L1 torsion leaf): proved.
- `GenericFreeness.exists_free_localizationAway_of_shortExact` (L3 splice): proved.
- `GenericFreeness.exists_localizationAway_finite_mvPolynomial` (L4 Noether normalisation): proved.
- `GenericFreeness.gf_generic_rank_ses` (L5a SES): proved.
- `GenericFreeness.gf_torsion_annihilator` (L5b.1): proved.
- `GenericFreeness.gf_nagata_monic_lastVar` (L5b.2): proved.
- `GenericFreeness.mvPolynomial_quotient_finite_of_monic_lastVar` (L5b.3): proved.
- `GenericFreeness.gf_torsion_reindex` (L5b): proved (with `set_option maxHeartbeats 4000000`).
- `GenericFreeness.free_localizationAway_of_away_tower`: proved.
- `GenericFreeness.exists_free_localizationAway_polynomial` (L5): proved via strong induction.
- `genericFlatnessAlgebraic`: proved (no sorry).

---

## Must-Fix Issues

### MF-1 — Stale comment in `base_change_mate_gstar_transpose` (FlatBaseChange.lean ~lines 1797–1809)

**Severity:** MAJOR (misleading; will confuse the next prover about what remains)

The "REMAINING CRUX" comment inside `base_change_mate_gstar_transpose` lists:

> (b) the generator close `extendScalars ψ (ρ) ≫ ε^alg = regroupEquiv.inv`

as still outstanding. But `base_change_mate_gstar_generator_close` was proved in this same iteration (line ~1545) with body `erw [ModuleCat.ExtendRestrictScalarsAdj.Counit.map_apply_one_tmul]; rfl`. Item (b) is no longer remaining; the crux comment should be updated to reflect that generator close is done and only the wiring into the full adjoint-mate computation remains blocked.

**Action:** The comment block should remove item (b) from the "remaining" list and note that `gstar_generator_close` is closed; the sorry itself is still correct and expected.

---

## Minor Observations

### MN-1 — `base_change_mate_gstar_transpose` sorry remains expected despite generator close

The sorry at line ~1810 is still necessary: closing `gstar_generator_close` does not automatically close `gstar_transpose` because the wiring into the main adjoint-mate calculation is blocked by the literal-form-lock pathology (after `subst` of pullback legs, the goal cannot be re-folded to `e`/`inclA`). No change to the sorry is needed; only the comment (MF-1 above).

### MN-2 — `genericFlatness` has two well-documented Mathlib gaps

GAP G1 and GAP G3 are genuine Mathlib absences, not project-specific; the comment correctly identifies them. Both are candidates for upstream Mathlib contributions and/or local workarounds in a future iteration.

### MN-3 — `set_option maxHeartbeats` flags in FlatteningStratification.lean

Three elevated heartbeat limits are present:
- `set_option synthInstance.maxHeartbeats 1000000` (3×, covering `gf_torsion_reindex`, `free_localizationAway_of_away_tower`, `exists_free_localizationAway_polynomial`).
- `set_option maxHeartbeats 4000000` (covering `gf_torsion_reindex`).
- `set_option maxHeartbeats 1600000` + `set_option synthInstance.maxHeartbeats 400000` (covering `genericFlatnessAlgebraic`).

All are commented with explicit justification. No action required; flagged for awareness.

---

## Severity Summary

| ID | Severity | Location | Description |
|---|---|---|---|
| MF-1 | **MAJOR** | FlatBaseChange.lean ~1797–1809 | Stale comment: `gstar_generator_close` listed as remaining CRUX item (b) but was proved this iteration |
| MN-1 | minor | FlatBaseChange.lean ~1810 | `gstar_transpose` sorry still correct despite generator close; comment fix sufficient |
| MN-2 | minor | FlatteningStratification.lean 2264 | `genericFlatness` sorry behind GAP G1/G3; well-documented |
| MN-3 | info | FlatteningStratification.lean | Elevated heartbeat options; all justified |

---

## Overall Verdict

**PASS with 1 must-fix.**

All 4 new atoms in `FlatBaseChange.lean` are correct. Both new `QuotScheme.lean` theorems are correct and the section docstring is accurate. The sorry inventory matches the directive's known-issues list exactly. No unexpected sorry was introduced anywhere across all 8 files.

The single must-fix (MF-1) is a stale comment — it does not affect proof correctness, only documentation accuracy — and can be resolved with a targeted comment edit in `base_change_mate_gstar_transpose`.
