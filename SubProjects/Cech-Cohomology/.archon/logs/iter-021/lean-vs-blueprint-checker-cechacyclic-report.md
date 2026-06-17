# Lean ↔ Blueprint Check Report

## Slug
cechacyclic

## Iteration
021

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/CechAcyclic.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks: `lem:section_cech_product_equiv`, `lem:section_cech_coface_match`,
  `lem:section_cech_ab_exact`, `lem:section_cech_homology_exact`,
  `lem:cech_acyclic_affine`, `def:qcoh_sections_localized`)

---

## Per-declaration (iter-021 additions)

### `sectionCechProductEquiv` (blueprint: `lem:section_cech_product_equiv`)
- **Lean target exists**: yes (line 1221)
- **Signature matches**: yes — `ToType (sectionCechCosimplicial U F).obj (SimplexCategory.mk p) ≃ (∀ σ : Fin (p+1) → ι, ToType (F.presheaf.obj (Opposite.op (⨅ k, U (σ k)))))`, exactly matching the blueprint's `ToType(∏ᶜ F_σ) ≃ ∏_σ ToType(F_σ)`
- **Proof follows sketch**: yes — body is `Concrete.productEquiv ...`, as blueprint prescribes; blueprint marks both statement and proof `\leanok`. ✓
- **notes**: Faithful realization; no issues.

### `sectionCechProductEquiv_apply` (blueprint: not separately listed)
- **Lean target exists**: yes (line 1232) — this is a coordinate-projection lemma for `sectionCechProductEquiv`
- **Signature matches**: N/A (not a blueprint target)
- **Proof follows sketch**: N/A
- **notes**: Reasonable helper; the blueprint's `\lean{...}` list for `lem:section_cech_product_equiv` omits this. Not a red flag, but worth adding to `\lean{...}` for completeness (see Blueprint adequacy section).

### `sectionCechFaceRestr` (blueprint: not listed)
- **Lean target exists**: yes (line 1284) — named def for the presheaf restriction `F.presheaf.obj(op(⨅ l U(σ∘δᵢl))) ⟶ F.presheaf.obj(op(⨅ k U(σk)))` at face `i`
- **Signature matches**: N/A (not a blueprint target)
- **Proof follows sketch**: N/A
- **notes**: Helper extracted to prevent re-elaboration of `homOfLE (le_iInf …)` in `sectionCech_objD_apply`. Not a red flag; arguably worth a `\lean{...}` mention in `lem:section_cech_coface_match` for cross-reference.

### `sectionCech_objD_apply` (blueprint: `lem:section_cech_coface_match` — ABSTRACT HALF ONLY)
- **Lean target exists**: yes (line 1296) — the declaration exists under a different name than the blueprint expects
- **Signature matches**: PARTIAL — proves the abstract unfold of `objD q` through the product equivalence into an alternating sum of `sectionCechFaceRestr` applications; does NOT show that `sectionCechFaceRestr` equals `dCoface` (the tilde-F comparison via `qcohRestriction_eq_comparison` is absent)
- **Proof follows sketch**: no — the blueprint's `lem:section_cech_coface_match` specifies a complete coface identification including `basicOpen_sprod` and `qcohRestriction_eq_comparison` (see blueprint lines 832–849); `sectionCech_objD_apply` explicitly notes "no sheaf identification yet" and stops at the abstract cosimplicial unfold
- **notes**: The declaration is correctly described in its own docstring as the "abstract" part; it does NOT over-claim. The issue is on the blueprint side: `\lean{AlgebraicGeometry.sectionCechCofaceMatch}` is the stated target, but `sectionCechCofaceMatch` does NOT appear anywhere in the Lean file. The abstract result has been split off under a new name without the blueprint tracking the split.

### `sectionCech_isZero_homology_of_objD_exact` (blueprint: `lem:section_cech_ab_exact`)
- **Lean target exists**: yes (line 1247) — under a different name than the blueprint expects
- **Signature matches**: PARTIAL — proves `IsZero ((sectionCechComplex U F).homology (q + 1))` given the hypothesis `Function.Exact (ConcreteCategory.hom (objD q)) (ConcreteCategory.hom (objD (q+1)))`; the full `sectionCechAbExact` would discharge that hypothesis using the product equivalence and coface match
- **Proof follows sketch**: no — the blueprint's `lem:section_cech_ab_exact` states the homology vanishing unconditionally (for `1 ≤ p`), not under a hypothesis; the existing declaration factors out only the homological-algebra step
- **notes**: The declaration is genuinely useful and correct. The issue is the same as above: `\lean{AlgebraicGeometry.sectionCechAbExact}` is the blueprint's stated target, but `sectionCechAbExact` is absent from the Lean file. The partial result is a step toward it, not a substitution.

---

## `\lean{...}` blocks not in the five new additions

### `def:qcoh_sections_localized` → `qcohSectionsAwayLocalized`, `basicOpen_sprod`, `iInf_fin_succ`, `qcohRestriction_eq_comparison`
- All four exist in the Lean file (lines 1129, 1141, 1165, 1183) with correct signatures.
- `iInf_fin_succ`: private helper, not in the `\lean{...}` list — blueprint already anticipates this.
- `qcohRestriction_eq_comparison`: exists (line 1183) and matches the blueprint's description (the unique `R`-linear map from `comparison_unique` that equals the presheaf restriction).
- ✓ all present; no issues.

### `def:section_cech_module_complex` → `SectionCechModule.*` family
- All listed declarations (`dCoeff`, `dCoface`, `dDiff`, `dDiff_apply`, `dToCech`, `dToCech_isLocalizedModule`, `cechCoface_dToCech`, `dToCech_comm`, `cechCofaceLin`, `cechCoface_apply`, `locDiff`, `locDiff_apply`, `locDiff_eq_depDiff`, `locDiff_exact`, `fLoc`, `fLoc_apply`, `fLoc_isLocalizedModule`, `locDiff_fLoc`, `map_dDiff_eq_locDiff`, `spanIdx`, `spanIdx_spec`) exist in the Lean file. All implementations are non-sorry.
- `AwayComparison.comparison_isLocalizedModule` and `AwayComparison.Inverts.smul_pow_cancel` also exist.
- ✓ fully covered.

### `lem:section_cech_module_exact` → `SectionCechModule.dDiff_exact`
- Exists (line 1082); blueprint marks statement and proof `\leanok`. Implementation is non-sorry and routes through `exact_of_isLocalized_span`. ✓

### `lem:section_cech_product_equiv` (already covered above) ✓

### `lem:section_cech_coface_match` → `\lean{AlgebraicGeometry.sectionCechCofaceMatch}`
- **Lean target exists**: NO — `sectionCechCofaceMatch` does not appear in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blueprint's `\lean{...}` names a declaration that does not exist. The file has `sectionCech_objD_apply` (the abstract half) but not the tilde-wired assembly. The blueprint block has no `\leanok`, so this is an aspirational target; missing target is **major**. However, it blocks `sectionCechAbExact` and `sectionCech_homology_exact`, which makes it functionally blocking.

### `lem:section_cech_ab_exact` → `\lean{AlgebraicGeometry.sectionCechAbExact}`
- **Lean target exists**: NO — `sectionCechAbExact` does not appear in the file
- Blueprint has no `\leanok`; this is an aspirational target. Missing is **major**.

### `lem:section_cech_homology_exact` → many `\lean{...}` targets
- The listed names in the `\lean{...}` block include:
  - `sectionCech_homology_exact` — **MISSING** from file
  - All `AwayComparison.*`, `CechLocalized.*`, and `SectionCechModule.*` names — ✓ present
- Blueprint has no `\leanok`; aspirational. Missing `sectionCech_homology_exact` is **major**.

### `lem:cech_acyclic_affine` → `CechAcyclic.affine`, `sectionCech_affine_vanishing`, `CombinatorialCech.*`
- `CechAcyclic.affine`: exists (line 75), body is `:= by sorry`; no `\leanok` on blueprint; documented open hole. Not a red flag.
- `sectionCech_affine_vanishing`: **MISSING**; the blueprint has a `% NOTE:` comment flagging it as a planned re-sign target. Major.
- All `CombinatorialCech.*` private declarations: exist and are implemented (no sorry). These are helpers private to the file; listed in `\lean{...}` primarily for coverage tracking. ✓

---

## Red flags

### Placeholder / suspect bodies
None found. The only `:= by sorry` is `CechAcyclic.affine`, which is the acknowledged top-level open hole. Its blueprint counterpart has no `\leanok`, and its docstring and inline comments accurately describe the remaining work (the L1 categorical→module bridge). This is not a red flag.

### Excuse-comments
None. The inline comments in `CechAcyclic.affine` (lines 83–109) are technical exposition of the proof strategy, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims
None. The `Classical.choice` usage (via `classical` tactic in `dDiff_exact` at line 1084) is for a `classical` tactic block for decidability, which is standard and not a substantive claim. No `axiom` declarations.

---

## Unreferenced declarations (informational)

The following declarations appear in the file but have no `\lean{...}` reference in the chapter:
- `sectionCechProductEquiv_apply` (line 1232) — helper for the product equivalence; should be in `lem:section_cech_product_equiv`'s `\lean{...}` list
- `sectionCechFaceRestr` (line 1284) — helper definition for the presheaf restriction at a face; should be in `lem:section_cech_coface_match`'s `\lean{...}` list
- `sectionCech_objD_apply` (line 1296) — abstract coface match; **should be separately listed** (see must-fix below)
- `sectionCech_isZero_homology_of_objD_exact` (line 1247) — homological-algebra step toward `sectionCechAbExact`; **should be separately listed**
- `ab_hom_finsetSum_apply` (line 1272) — private Ab-morphism helper; acceptable as private

All `CombinatorialCech.*`, `AwayComparison.*`, `CechLocalized.*`, `SectionCechModule.*` declarations are `\lean{...}`-referenced in the blueprint. ✓

---

## Blueprint adequacy for this file

- **Coverage**: Of the `\lean{...}` blocks covering CechAcyclic.lean,
  - Blocks with `\leanok` (= blueprint claims formalized): `lem:section_cech_product_equiv` (1 target, exists ✓) and `lem:section_cech_module_exact` (1 target, exists ✓).
  - Blocks without `\leanok` (aspirational): `lem:section_cech_coface_match` (target `sectionCechCofaceMatch` absent), `lem:section_cech_ab_exact` (target `sectionCechAbExact` absent), `lem:section_cech_homology_exact` (target `sectionCech_homology_exact` absent), `lem:cech_acyclic_affine` (`sectionCech_affine_vanishing` absent, `CechAcyclic.affine` present with sorry).
  - 4 substantive declarations in the file (`sectionCechProductEquiv_apply`, `sectionCechFaceRestr`, `sectionCech_objD_apply`, `sectionCech_isZero_homology_of_objD_exact`) are not `\lean{...}`-referenced.

- **Proof-sketch depth**: **under-specified** in two areas:
  1. `lem:section_cech_coface_match` (lines 799–849) presents `sectionCechCofaceMatch` as a monolithic single lemma. The actual formalization has naturally split into (a) the abstract cosimplicial unfold (`sectionCech_objD_apply`, now done) and (b) the tilde-F identification via `qcohRestriction_eq_comparison` (still open). The blueprint proof sketch does not guide this split; a prover following it has no roadmap for which sub-results to prove first. This is the direct cause of the "tilde-bridge still open" situation the directive flags.
  2. `lem:section_cech_homology_exact` (lines 604–746): the proof sketch correctly identifies the three-step chain (`exactAt_iff_isZero_homology` → `ShortComplex.ab_exact_iff` → `dDiff_exact`), but relies on `sectionCechCofaceMatch` as an input. Since `sectionCechCofaceMatch` is the blocker and its proof strategy is not decomposed in the chapter, the sketch for `sectionCech_homology_exact` cannot yet guide a prover.

- **Hint precision**: **loose** for `lem:section_cech_coface_match`. The prose correctly describes the goal but does not distinguish the abstract-unfold step (which requires only `AlternatingCofaceMapComplex.objD`, `Pi.lift_π`, and `CosimplicialObject.δ`) from the sheaf-identification step (which requires `qcohRestriction_eq_comparison` and the `basicOpen_sprod` rewrite). A prover confronting this lemma has to discover the split independently.

- **Generality**: **matches need** for the currently-formalized declarations. The `sectionCech_objD_apply` and `sectionCech_isZero_homology_of_objD_exact` are correctly stated for a general `F : X.PresheafOfModules`, matching what the downstream affine vanishing needs.

- **Blueprint adequacy for step (d) (`sectionCech_affine_vanishing`)**: **too thin**. The proof sketch for `lem:cech_acyclic_affine` (lines 1110–1172) correctly invokes `lem:section_cech_homology_exact` + `lem:section_cech_module_exact`, but both `sectionCech_homology_exact` and `sectionCechCofaceMatch` are absent. The immediate blocker is `sectionCechCofaceMatch`; once that exists, the rest of the chain is guided by the existing prose. The blueprint correctly notes (lines 573–582) that a general QCoh `F` requires `F ≅ tilde(ΓF)` (Stacks 01I8), but does not say whether `sectionCechCofaceMatch` should be proved only for tilde M (using `qcohRestriction_eq_comparison` directly) or for all QCoh F (needing the affine equivalence). This ambiguity leaves the prover without a decision point.

- **Recommended chapter-side actions (for blueprint-writing agent)**:
  1. Add `sectionCech_objD_apply` and `sectionCechFaceRestr` to the `\lean{...}` list of `lem:section_cech_coface_match`, and explicitly decompose its proof sketch into two sub-steps: (a) abstract cosimplicial unfold (`sectionCech_objD_apply`) and (b) sheaf-identification bridge (`qcohRestriction_eq_comparison`).
  2. Add `sectionCechProductEquiv_apply` to the `\lean{...}` list of `lem:section_cech_product_equiv`.
  3. Add `sectionCech_isZero_homology_of_objD_exact` to the `\lean{...}` list of `lem:section_cech_ab_exact` as an intermediate step, and update the proof sketch to show that `sectionCechAbExact` = `sectionCech_isZero_homology_of_objD_exact` applied to the conclusion of `sectionCechCofaceMatch`.
  4. Clarify in `lem:section_cech_coface_match` or `def:qcoh_sections_localized` whether `sectionCechCofaceMatch` should be proved only for the tilde case (using `qcohRestriction_eq_comparison`) with a general-QCoh corollary via `fromTildeΓ`, or directly for all QCoh F.

---

## Severity summary

- **must-fix-this-iter**: NONE — no false/over-claiming declarations, no sorry on a `\leanok`-marked statement, no axioms on substantive claims. The new declarations faithfully represent what they prove.

- **major**:
  1. `AlgebraicGeometry.sectionCechCofaceMatch` listed in `\lean{...}` of `lem:section_cech_coface_match` does not exist in the Lean file; `sectionCech_objD_apply` covers only the abstract half.
  2. `AlgebraicGeometry.sectionCechAbExact` listed in `\lean{...}` of `lem:section_cech_ab_exact` does not exist; `sectionCech_isZero_homology_of_objD_exact` is the incomplete precursor.
  3. `AlgebraicGeometry.sectionCech_homology_exact` listed as primary target of `lem:section_cech_homology_exact` does not exist.
  4. `AlgebraicGeometry.sectionCech_affine_vanishing` listed in `\lean{...}` of `lem:cech_acyclic_affine` does not exist (blueprint has a `% NOTE:` flagging this as planned).
  5. Blueprint adequacy: `lem:section_cech_coface_match` does not decompose the proof into the abstract-unfold step and the tilde-bridge step; the `\lean{...}` list should add `sectionCech_objD_apply` and `sectionCechFaceRestr`.
  6. `sectionCechProductEquiv_apply`, `sectionCechFaceRestr`, `sectionCech_objD_apply`, and `sectionCech_isZero_homology_of_objD_exact` are substantive declarations in the file that the blueprint does not reference.

- **minor**:
  1. The blueprint's tilde-vs-general-QCoh strategy for `sectionCechCofaceMatch` is ambiguous; clarifying whether to prove the tilde case first would resolve the prover's decision point.

**Overall verdict**: The five iter-021 additions are mathematically faithful and do not over-claim; the tilde-bridge step (`sectionCechCofaceMatch`) is correctly left open, not papered over. The chapter has four major missing `\lean{...}` targets and one structural adequacy failure (the abstract/tilde split in `lem:section_cech_coface_match` is not documented), but no must-fix-this-iter findings.
