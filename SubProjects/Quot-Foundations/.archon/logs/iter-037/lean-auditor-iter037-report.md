# Lean Audit Report

## Slug
iter037

## Iteration
037

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/GrassmannianCells.lean`

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none flagged (escalated heartbeat limits are all accompanied by explanatory comments)
- **excuse-comments**: none
- **notes**:
  - File is 1837 lines; zero `sorry` / `admit` / `native_decide` present.
  - Three new declarations verified — see "New declarations" section below.
  - `set_option maxHeartbeats` escalations at lines 876, 1098, 1347 are each accompanied by accurate inline comments identifying the `MvPolynomial` / away-localisation instance-diamond source; standard practice for this project.
  - `set_option backward.isDefEq.respectTransparency false` at line 1350 is correctly scoped to the single heavy `isSeparatedToSpecZ` proof.
  - `erw` at lines 912–913, 1387–1400: each use is local and the surrounding comment explains why syntactic `rw` is blocked (instance-diamond on heavy localization objects). No pattern suggesting degenerate tactic usage.
  - `congrArg (_ ≫ ·) hXY` at line 916: legitimate workaround for a Scheme-category `Category.assoc` defeq issue; the comment documents this.
  - Private helpers `det_one_updateCol`, `mul_submatrix_col`, `map_nonsing_inv`, `isUnit_incl_transitionPreMap_cross`, `isUnit_algebraMap_away_left`, `isUnit_algebraMap_away_right`, `imageMatrix_map_eq`, `inv_mul_inv_mul_cancel`, `cocycle_imageMatrix_eq`, `rotMid`, `transitionInvImageMatrix`, `transitionInvPair`, `isIso_sheaf_of_isIso_app_basicOpen`, `bijective_comp_of_localizations`, `iSup_basicOpen_subtype_eq_top`, `res_comp`, `descent_smul_eq_zero`, `descent_overlap_agree`, `descent_surj`: all private, all have honest proof bodies.

---

### `AlgebraicJacobian/Picard/QuotScheme.lean`

- **outdated comments**: none
- **suspect definitions**: 4 known scaffold stubs (see below)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: 4 (on the 4 known scaffold stubs — pre-existing, directive-acknowledged; see below)
- **notes**:
  - File is 1811 lines; exactly 4 `sorry` bodies present (lines 126, 165, 201, 228), matching the 4 pre-existing scaffold declarations listed in the directive. No new `sorry` introduced.
  - Two new declarations verified — see "New declarations" section below.
  - **Known scaffold stubs** (pre-existing, directive-acknowledged as protected):
    - `hilbertPolynomial` (line 123): `sorry` body; see note on `iter-177+` comment below.
    - `QuotFunctor` (line 161): `sorry` body; same.
    - `Grassmannian` (line 198): `sorry` body; same.
    - `Grassmannian.representable` (line 225): `sorry` body; same.
  - **`iter-177+:` comments on scaffolds** (lines 119–122, 155–160, 194–197, 219–224): Each scaffold's docstring contains a block of the form "iter-177+: … For the iter-176 file-skeleton the body is a typed `sorry`." The phrase "the body is a typed `sorry`" is an explicit admission of incompleteness and matches the excuse-comment pattern. Per the directive these are known protected stubs; flagged as **major** (not must-fix) because they are pre-existing and the directive explicitly acknowledges them.
  - **`task_results/.../QuotScheme.md`** (line ~272): doc comment uses `...` as a fuzzy path fragment. Minor imprecision; **minor** severity.
  - `set_option maxHeartbeats 2000000 / synthInstance.maxHeartbeats 800000 / backward.isDefEq.respectTransparency false` at lines 1100–1102, 1163–1165, 1233–1235, 1252–1254, 1281–1283: all documented with accurate comments attributing the cost to `SheafOfModules`/`Presentation.map` instance synthesis. Standard project practice.
  - `convert step2 using 1` at line 540: correct; the subsequent `LinearMap.ext` / `congr` steps close the structural side condition properly.
  - `Subsingleton.elim` at line 837: appropriate use inside `overEquivalence_inverse_isCocontinuous` where the `Over.homMk` proof obligation has `Subsingleton` type.
  - The "TODO" matches at lines 758, 763, 785, 814, 871 all refer to a **Mathlib-side** TODO in `Topology/Sheaves/Over.lean` that the project is filling — these are descriptions of the project's contribution, not internal excuse-comments.

---

## New declarations verification

### GrassmannianCells.lean

#### `det_one_updateCol` (private, line 1645)

**Signature:** `((1 : Matrix (Fin d) (Fin d) R).updateCol p v).det = v p`

**Verdict:** Honest. Proof: rewrite by `Matrix.cramer_apply` (which equates `(A.updateCol i v).det` with `(A.cramer v) i`), then apply `Matrix.mulVec_cramer 1 v` (giving `1.cramer v = v` since `1.det = 1` and `1.mulVec = id`). Three-line proof, axiom-clean.

Note: Mathlib has no direct `det_one_updateCol` lemma (there is `Matrix.cramer_apply` and `Matrix.mulVec_cramer` but not this combination stated directly); the private helper is warranted.

#### `exists_minorDet_eq_free_entry` (line 1661)

**Signature:** Given `q ∉ J` and row `p`, there exists `K' : Finset (Fin r)` with `K'.card = d` such that `minorDet d r J K' hJ hK' = MvPolynomial.X (p, ⟨q, hq⟩)` or `= - MvPolynomial.X (p, ⟨q, hq⟩)`.

**Verdict:** Honest. Proof strategy:
1. Sets `K' := insert q (J.erase jp)` where `jp := J.orderIsoOfFin hJ p`, proves `K'.card = d` by `card_insert_of_notMem` + `card_erase_of_mem`.
2. Constructs column map `colMap k = if k = p then q else J.orderIsoOfFin hJ k`, proves it is injective and has image in `K'`.
3. Constructs permutation `σ` via `Equiv.ofBijective` from the order-iso reindexing, proves `oiK' ∘ σ = colMap`.
4. Key identity `hBupd`: `(universalMatrix J).submatrix id colMap = (1).updateCol p v` where `v k' = universalMatrix d r J hJ k' q`. Proved by `Matrix.ext` case analysis on `k = p` (uses `universalMatrix`'s `dif_neg hq` branch) and `k ≠ p` (uses `dif_pos`, `Matrix.one_apply`).
5. Applies `det_one_updateCol` to get `det(...) = MvPolynomial.X (p, ⟨q, hq⟩)`.
6. Relates via `Matrix.det_permute'` and the permutation sign; case-splits on `Equiv.Perm.sign σ = 1` or `= -1` via `Int.units_eq_one_or`.

No `sorry`. The proof is long (~100 lines) but structurally correct, with each step explicitly justified.

#### `existence_factor_through_valuationRing` (line 1775)

**Signature:** Under a minimal-valuation chart index `J` (maximizing `v(f(P^I_J))`), the composite `g = f' ∘ θ̃_{I,J}` maps every `MvPolynomial.X` generator into `(algebraMap R K).range`.

**Verdict:** Honest. Proof:
1. `hminorR`: for every `K'` with `K'.card = d`, `g(minorDet J K')` lies in `R`. Follows from the minor-ratio identity `existence_lift_transitionPreMap_minorDet_mul` (which gives `g(P^J_{K'}) = f(P^I_{K'}) / f(P^I_J)`) combined with `hJmax` (giving `v(f(P^I_{K'})) ≤ v(f(P^I_J))`) and `Valuation.mem_integer_iff`.
2. `hgen`: each free generator `x^J_{p,q} = ± minorDet J K'` by `exists_minorDet_eq_free_entry`; the two sign cases apply `hminorR` directly or via `neg_mem`.
3. MvPolynomial induction: constants use `RingHom.ext_int` + `map_intCast`; `add` and `mul_X` use `add_mem` / `mul_mem` with `hgen`.

All steps are axiom-clean.

---

### QuotScheme.lean

#### `isLocalizedModule_of_ringEquiv_semilinear` (line 1670)

**Full name:** `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_of_ringEquiv_semilinear`

**Verdict:** Honest. Transports `IsLocalizedModule S g` (over ring `R`) to `IsLocalizedModule (S.map σ) h` (over ring `R'`) through a ring iso `σ : R ≃+* R'` and `σ`-semilinear additive equivalences `e₁ : M₁ ≃+ N₁`, `e₂ : M₂ ≃+ N₂`.

- **`map_units`**: For `x ∈ S.map σ`, extracts `⟨s, hs, hsx⟩` with `σ s = ↑x`. Proves `(algebraMap R' (End R') N₂) (↑x) = e₂ ∘ (algebraMap R (End R) M₂)(s) ∘ e₂.symm` by `Module.algebraMap_end_apply` + `he₂` + `hsx`. Bijectivity follows from `hsrc` (bijectivity from the source `IsLocalizedModule`) conjugated by `e₂.bijective`.
- **`surj`**: Applies source `IsLocalizedModule.surj` at `e₂.symm y`; constructs witness `(e₁ x, σ s)`; the equation `(σ s) • y = h (e₁ x)` follows by applying `e₂` to `(↑s) • e₂.symm y = g x` and using `he₂` + `hh` + `e₂.apply_symm_apply`.
- **`exists_of_eq`**: Uses `e₂.injective` to descend `h (e₁.symm y₁) = h (e₁.symm y₂)` to `g`, applies source `exists_of_eq`, converts via `he₁` and `e₁.apply_symm_apply`.

All three fields correct. No sorry.

#### `isLocalizedModule_restrictScalars_powers_algebraMap` (line 1720)

**Full name:** `AlgebraicGeometry.Scheme.Modules.isLocalizedModule_restrictScalars_powers_algebraMap`

**Verdict:** Honest. Given `[IsLocalizedModule (powers (algebraMap R Rr f)) g]` with `g : M₁ →ₗ[Rr] M₂`, proves `IsLocalizedModule (powers f) (g.restrictScalars R)`.

- **`map_units`**: For `x ∈ powers f`, extracts `n` with `f^n = ↑x`. Proves `(algebraMap R (End R) M₂)(↑x) = (algebraMap Rr (End Rr) M₂)((algebraMap R Rr f)^n)` via `Module.algebraMap_end_apply` + `map_pow` + `algebraMap_smul`. Bijectivity from source `map_units`.
- **`surj`**: Gets `⟨⟨x, s⟩, hx⟩` from source `surj`; extracts `n` from `s.2`; witness is `⟨x, ⟨f^n, n, rfl⟩⟩`; converts `(f^n : R) • y = (↑s : Rr) • y` by `← map_pow` + `algebraMap_smul`.
- **`exists_of_eq`**: Source `exists_of_eq` gives `c ∈ powers (algebraMap R Rr f)` with `c • x₁ = c • x₂`; extracts `n`; converts via `← map_pow` + `algebraMap_smul` to get `(f^n : R) • x₁ = (f^n : R) • x₂`.

All three fields correct. No sorry.

---

## Must-fix-this-iter

None.

---

## Major

- `AlgebraicJacobian/Picard/QuotScheme.lean:119–122`: The `hilbertPolynomial` docstring body contains "For the iter-176 file-skeleton the body is a typed `sorry`." — explicit admission of incompleteness. Matches excuse-comment pattern (major minimum per audit standard). Pre-existing, directive-acknowledged scaffold stub; not new dead code.
- `AlgebraicJacobian/Picard/QuotScheme.lean:155–160`: Same pattern on `QuotFunctor`. Pre-existing.
- `AlgebraicJacobian/Picard/QuotScheme.lean:194–197`: Same pattern on `Grassmannian`. Pre-existing.
- `AlgebraicJacobian/Picard/QuotScheme.lean:219–224`: Same pattern on `Grassmannian.representable`. Pre-existing.

---

## Minor

- `AlgebraicJacobian/Picard/QuotScheme.lean:272` (approximately): `task_results/.../QuotScheme.md` — the `...` glob fragment in a doc-comment cross-reference is an imprecise path. Not misleading but unprofessionally vague for a reference that should be findable.

---

## Excuse-comments (called out separately)

- `QuotScheme.lean:122`: "For the iter-176 file-skeleton the body is a typed `sorry`." (attached to `hilbertPolynomial`). Severity: major (pre-existing scaffold; directive-acknowledged).
- `QuotScheme.lean:160`: "For the iter-176 file-skeleton the body is a typed `sorry`." (attached to `QuotFunctor`). Severity: major (pre-existing scaffold; directive-acknowledged).
- `QuotScheme.lean:197`: "For the iter-176 file-skeleton the body is a typed `sorry`." (attached to `Grassmannian`). Severity: major (pre-existing scaffold; directive-acknowledged).
- `QuotScheme.lean:224`: "For the iter-176 file-skeleton the body is a typed `sorry`." (attached to `Grassmannian.representable`). Severity: major (pre-existing scaffold; directive-acknowledged).

All four are pre-existing, unambiguously documented as scaffold stubs in the directive, and have appeared in prior iters. They are called out here for audit completeness, not as new findings.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 4 (all pre-existing excuse-comments on directive-acknowledged scaffold stubs)
- **minor**: 1 (imprecise doc cross-reference path)
- **excuse-comments**: 4 (same as major findings above; pre-existing and directive-acknowledged)

Overall verdict: Both files are clean this iteration — all 5 new declarations (`det_one_updateCol`, `exists_minorDet_eq_free_entry`, `existence_factor_through_valuationRing`, `isLocalizedModule_of_ringEquiv_semilinear`, `isLocalizedModule_restrictScalars_powers_algebraMap`) are axiom-clean and honestly proved; no new `sorry` was introduced anywhere; the only flagged issues are 4 pre-existing excuse-comments on long-standing scaffold stubs that the directive explicitly acknowledges.
