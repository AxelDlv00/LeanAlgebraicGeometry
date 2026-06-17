# Lean Audit Report

## Slug
iter035

## Iteration
035

## Scope
- files audited: 3
- files skipped (per directive): all other `.lean` files — directive listed exactly these three files as scope

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 3 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **L184–247**: Historical narrative block documenting a resolved routing debate across iter-234/236, including `UPDATE (iter-236): route (a) is empirically the carrier wall and is now confirmed DEAD` and `UPDATE (resolved): ... fully proved, no sorry`. The block ends with a correct status (issue resolved, no open obligation). Not actively misleading, but the iter-number references will become stale noise as the project matures. Minor.
  - **L1699 (`base_change_mate_fstar_reindex_legs_conj` proof comment)**: "This is the last authorized conjugate round (PROGRESS.md tripwire)". References an external project-management file by name inside a `.lean` proof body. Bad practice: `.lean` comments should be self-contained and not require reading external state files to decode. The mathematical content is fine; the project-management language is not auditable from the code. Major.
  - **L2046–2047 (inside `base_change_mate_gstar_transpose`)**: Comment says `base_change_mate_fstar_reindex` is "currently sorry-backed (its `…_legs` apparatus carries a dead `sorry`)". The sorry at L1700 in `base_change_mate_fstar_reindex_legs_conj` is the **active planned sorry** for the conjugate-side discharge with a detailed implementation roadmap at lines 1682–1699. Calling it "dead" contradicts the docstring of `base_change_mate_section_identity` (L2145–2148), which correctly labels it "the single residual obligation of the whole Seam-3 chain". "Dead sorry" implies abandoned/unreachable; this sorry has a live plan and is the key outstanding obligation. Misleading. Major.
  - **L2060**: `-- SCAFFOLD (iter-022)` — iter-022 timestamp is 13 iterations stale. The scaffolded conjugate-counit code is still present and the proof is unfinished, so the label is conceptually accurate — but the age tag is dated noise. Minor.
  - **L2099**: `-- LANDED SCAFFOLD (iter-022, recipe step 1 COMPLETE — verified compiling)` — same 13-iteration stale timestamp. Minor.
  - **L1700 (`base_change_mate_fstar_reindex_legs_conj`)**: `sorry` at end of proof. Proof reduces via `subst hfst; subst hsnd`, then carries a detailed conjugate-side plan (lines 1682–1699). Honest — genuine incomplete proof, not a stub.
  - **L2122 (`base_change_mate_gstar_transpose`)**: `sorry` at end of proof. After the `huce` scaffold lands (iter-022 work), two cruxes remain: (a) inner reindex reproved inline, (b) generator close + dictionary cancellation. Honest, not an excuse-comment.
  - **L2303 (`affineBaseChange_pushforward_iso`)**: `sorry` inside `intro U` branch. Comment accurately describes the missing affine-restriction-compatibility step. Honest.
  - **L2325 (`flatBaseChange_pushforward_isIso`)**: `sorry`. Comment documents the intended Čech-complex strategy. Honest.
  - **Sorry count: 4 total** (L1700, L2122, L2303, L2325). Matches the 4 pre-existing sorries from the directive. No new sorry introduced. ✓
  - **`_legs` wrapper** (`base_change_mate_fstar_reindex_legs`, L1713–1750): Body is `exact base_change_mate_codomain_read_legs_conj_eq … ▸ base_change_mate_fstar_reindex_legs_conj …`. **No inline sorry**. Transitively sorry-backed through `_legs_conj` at L1700. ✓
  - **`_legs_conj`** (`base_change_mate_fstar_reindex_legs_conj`, L1647–1700): Carries the **only sorry in the conj sub-chain** at L1700. (Three additional independent sorries exist at L2122/2303/2325 in separate seams.) ✓
  - **conj-1a** (`base_change_mate_codomain_read_legs_conj`, L1563): Faithful statement. Uses `conjPullbackFactor` (= `leftAdjointCompIso`) as the factor; proved equal to `pullbackComp` by the sorry-free `conjPullbackFactor_eq_pullbackComp` (L1520). Statement NOT weakened. ✓
  - **conj-1b** (`base_change_mate_codomain_read_legs_conj_eq`, L1594): States `_conj = _legs`. Proved sorry-free via `base_change_mate_codomain_read_legs_eq_param` (proved by `rfl`) + `conjPullbackFactor_eq_pullbackComp`. Statement NOT weakened. ✓
  - **conj-2c** (`base_change_mate_reindex_conj_pushforwardCollapse`, L1626): Three Γ-collapse conjuncts: `pushforwardComp.inv → 𝟙`, `pushforwardComp.hom → 𝟙`, `pushforwardCongr hfg → eqToHom`. Proved sorry-free by three atomic sorry-free lemmas (`gammaMap_pushforwardComp_inv_eq_id`, `gammaMap_pushforwardComp_hom_eq_id`, `gammaMap_pushforwardCongr_hom`, all at L1218–1244). Statement NOT weakened. ✓
  - **`conjPullbackFactor`** (L1489): Proved sorry-free by `Adjunction.leftAdjointCompIso`. ✓
  - **`conjPullbackFactor_eq_pullbackComp`** (L1520): Proved sorry-free via `pullbackComp_eq_leftAdjointCompIso` (L1198, itself proved via `pullbackComp_inv_eq_leftAdjointCompIso_inv`, L1181). ✓
  - **`base_change_mate_codomain_read_legs_eq_param`** (L1536): Proved by `rfl`. ✓
  - No statement in the conj chain was shaped to avoid the real obstruction. ✓
  - No new axiom observed. ✓

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: none (the 4 `:= sorry` stubs are pre-existing protected declarations)
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **L126/165/201/228**: `:= sorry` stubs for `hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`. All pre-existing protected stubs explicitly documented as "iter-176 file-skeleton". No new sorry introduced. ✓
  - **`Hfr` hypothesis analysis** (`isLocalizedModule_basicOpen_descent_of_cover`, L1626–1646):
    - `Hfr` states: `∀ U, (∃ r ∈ t, U ≤ D(r)) → IsLocalizedModule (powers f) (ρ[D(f)∩U, U])`.
    - Conclusion: `IsLocalizedModule (powers f) (ρ[D(f), ⊤])` — the restriction on global sections.
    - These are **genuinely different** maps: `U = ⊤` is not covered by `Hfr` (which only applies when `U ≤ D(r)` for some cover element). `Hfr` is NOT a disguised assumption of the conclusion. Honest. ✓
  - **`iSup_basicOpen_subtype_eq_top`** (L1330): Proved via `PrimeSpectrum.iSup_basicOpen_eq_top_iff'`. ✓
  - **`res_comp`** (L1340): Proved by `← Functor.map_comp; ← op_comp; rfl`. ✓
  - **`descent_smul_eq_zero`** (L1356): Proved via `TopCat.Sheaf.eq_of_locally_eq'`. `Hfr` specialized to `U = D(r)` via `⟨r, hr, le_refl _⟩`. ✓
  - **`descent_overlap_agree`** (L1418): Proved by term-mode chain of `res_comp` equalities and `LinearMap.map_smul`. ✓
  - **`descent_surj`** (L1461): Proved via `TopCat.Sheaf.existsUnique_gluing'`. Uses `Hfr` for overlaps `D(r)∩D(r')` (covered by `⟨i, i.2, inf_le_left⟩`). ✓
  - **`isLocalizedModule_basicOpen_descent_of_cover`** (L1626): Proved sorry-free. `map_units` from `map_units_restrict_basicOpen` (L705, proved axiom-clean). `surj` and `exists_of_eq` from the two private helpers. ✓
  - **L1102, 1165, 1235, 1254, 1283**: `set_option backward.isDefEq.respectTransparency false` used 5 times, always paired with `set_option maxHeartbeats 2000000` and `set_option synthInstance.maxHeartbeats 800000`. This non-standard option bypasses transparency constraints during defeq matching. Intentional workaround for the `Scheme.Modules` instance-diamond problem in the `presentationPullback` series. Files compile clean, no correctness failure — but it is a non-standard technique not from the Lean/Mathlib mainstream and makes these proofs harder to maintain. Minor.
  - No new sorry, no axiom leak. ✓

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`compactSpace_scheme`** (L1443): Instance, proved via `theGlueData.openCover.compactSpace` using finitely many compact affine charts. ✓
  - **`quasiCompact_toSpecZ`** (L1454): Proved by `HasAffineProperty.iff_of_isAffine.mpr (compactSpace_scheme d r)`. ✓
  - **`locallyOfFiniteType_toSpecZ`** (L1462): Proved via `IsZariskiLocalAtSource.of_openCover` + `ι_toSpecZ` + `HasRingHomProperty.Spec_iff`. ✓
  - **`quasiSeparated_toSpecZ`** (L1474): Proved by `infer_instance` from `IsSeparated (toSpecZ d r)`. ✓
  - **`valuativeUniqueness_toSpecZ`** (L1482): Proved by `IsSeparated.valuativeCriterion`. ✓
  - **`transitionPreMap_minorDet_mul`** (L1495): Proved by honest algebraic computation — `transitionPreMap_minorDet`, `mul_submatrix_col`, `Matrix.det_mul`, `RingHom.map_det`, `universalMinorInv_mul_cancel`. No sorry, no shortcut. ✓
  - **`isProper_of_valuativeExistence`** (L1531): Proof:
    ```lean
    haveI : QuasiCompact := quasiCompact_toSpecZ d r
    haveI : QuasiSeparated := quasiSeparated_toSpecZ d r
    haveI : LocallyOfFiniteType := locallyOfFiniteType_toSpecZ d r
    apply IsProper.of_valuativeCriterion
    exact ValuativeCriterion.iff.mpr ⟨hE, valuativeUniqueness_toSpecZ d r⟩
    ```
    `hE : ValuativeCriterion.Existence (toSpecZ d r)` is the explicit hypothesis; it is passed directly to `ValuativeCriterion.iff.mpr`. It is NOT discharged inside the proof. The three "cheap" ingredients are all independently proved above. No smuggling of the existence obligation. ✓
  - **Sorry count: 0**. No new sorry, no axiom. ✓

---

## Must-fix-this-iter

None. No finding meets the strict must-fix criteria (excuse-comments on load-bearing declarations, weakened definitions, unauthorized `:= sorry` stubs on substantive claims, axiom leaks, parallel Mathlib APIs). All four sorries in FlatBaseChange.lean carry genuine incomplete proofs with documented plans.

**Directive-specific verification summary:**

| Check | Result |
|-------|--------|
| `_legs` body sorry-free | ✓ Yes — `exact … ▸ …_conj …`, no inline sorry |
| `_legs_conj` carries the only residual sorry (conj sub-chain) | ✓ Yes — L1700 is the only sorry in the `conjPullbackFactor`/`_legs`/`_legs_conj` chain |
| conj-1a faithful (not weakened) | ✓ Yes — same conclusion type as `_legs`, factor equal by proved lemma |
| conj-1b faithful (proved sorry-free) | ✓ Yes — `rw` + `rfl`, no sorry |
| conj-2c faithful (proved sorry-free) | ✓ Yes — three atomic lemmas, all proved |
| `Hfr` is honest, not a disguised conclusion | ✓ Yes — `U ≤ D(r)` condition is strictly weaker than `U = ⊤` |
| `isProper_of_valuativeExistence` does not smuggle existence | ✓ Yes — `hE` is the theorem's hypothesis, not discharged internally |
| No new sorry in any file | ✓ FlatBaseChange: 4 (pre-existing); QuotScheme: 4 (pre-existing stubs); GrassmannianCells: 0 |
| No axiom leak | ✓ None observed |

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:1699` — Proof comment says "This is the last authorized conjugate round (PROGRESS.md tripwire)". References an external project-management file inside a `.lean` proof body. The comment is not auditable from the code alone and will become opaque noise as project management evolves. The mathematical content is fine; the external reference should be removed or replaced with a self-contained explanation.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2047` — Comment in `base_change_mate_gstar_transpose` proof calls the sorry in `_legs_conj` a "dead `sorry`". The sorry at L1700 has a detailed 18-line implementation plan (L1682–1699) and is explicitly called "the single residual obligation of the whole Seam-3 chain" in the docstring of `base_change_mate_section_identity` (L2145). "Dead sorry" implies abandoned/unreachable; this sorry is the primary active workitem of the conjugate chain. The mislabeling contradicts the docstring and could mislead project tracking.

---

## Minor

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:184–247` — Historical narrative block references iter-234/236 resolution. Ends correctly ("fully proved, no sorry"), so not actively misleading — but the iter-count references will decay as the project matures.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:2060,2099` — `SCAFFOLD (iter-022)` and `LANDED SCAFFOLD (iter-022)` iter-tags are 13 iterations stale.
- `AlgebraicJacobian/Picard/QuotScheme.lean:1102,1165,1235,1254,1283` — `set_option backward.isDefEq.respectTransparency false` used 5 times. Intentional but non-standard; maintainability concern for future editors.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` — `set_option maxHeartbeats 4000000` on three theorems (40× default). Legitimate for current machinery; flag for performance review once sorries are closed.

---

## Excuse-comments (always called out separately)

None. No declaration in any of the three files carries a comment of the form "TODO replace with real def", "placeholder", "temporary", "wrong but works", or "will fix later". The sorry-backed proof comments document the intended route and outstanding obstacles — correct practice for incomplete proofs.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (FlatBaseChange.lean:1699 PROGRESS.md reference; FlatBaseChange.lean:2047 "dead sorry" mislabeling)
- **minor**: 4 (historical iter-tags at L184–247; stale SCAFFOLD at L2060/2099; `backward.isDefEq.respectTransparency` in QuotScheme; maxHeartbeats scale in FlatBaseChange)
- **excuse-comments**: 0

Overall verdict: All three files are mathematically sound for iter-035. The conjugate chain, descent keystone, and properness scaffold are honest; no sorry counts have changed from the pre-existing baseline; no statement was weakened to avoid its real obstruction. The two major findings are documentation issues (an external file reference and a misleading "dead sorry" label) rather than proof-correctness problems.
