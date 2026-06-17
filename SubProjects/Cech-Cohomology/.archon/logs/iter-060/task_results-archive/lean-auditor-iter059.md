# Lean Audit Report

## Slug
iter059

## Iteration
059

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (code duplication — see notes)
- **excuse-comments**: none
- **notes**:
  - **Lines 42–50 — `isZero_of_faithful_preservesZeroMorphisms` is an explicit copy** from
    `CechAugmentedResolution.lean`.  The docstring says so honestly: "A copy of the same lemma
    … reproduced here because that sibling file is not in this file's import chain."  The copy
    is currently necessary given the import DAG, but if the import structure ever permits a
    shared utility file, this should be extracted.  No correctness concern; real maintenance
    burden. **(Major.)**
  - **Lines 71–101 — `isZero_presheafToSheaf_of_sections_locally_zero`**: proof strategy
    (local injectivity via `x − y`, trivial local surjectivity, then `isLocallyBijective`) is
    mathematically correct and cleaner than the objectwise-zero variant in
    `CechAugmentedResolution.lean`.
  - **Lines 160–173 — `sectionsFunctorCorepIso`**: naturality check via
    `jShriekOU_homEquiv_nat` is correct; the `AddEquiv.symm_apply_eq` step is the right lever.
  - **Lines 274–292 — `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`**: the bridge from
    Ext-vanishing to right-derived vanishing is sound.  Uses `isoRightDerivedObj`, reduces
    to exactness at degree `p+1`, extracts a preimage `g` from `extMk_eq_zero_iff`, and closes
    via `preadditiveCoyoneda_mapHomologicalComplex_d_apply`.  No smuggled assumptions.
  - **Lines 299–304 — `enoughInjectives_of_hasInjectiveResolutions`**: standard connector;
    the degree-0 term of an injective resolution is a valid injective presentation.
    `InjectiveResolution.instMonoFNatι` provides the required mono.  Sound.
  - **Lines 310–321 — `subsingleton_ext_of_iso_fst`**: correct contravariant
    Ext-functoriality; the chain `z = φ.hom ∘ (φ.inv ∘ z) = φ.hom ∘ 0 = 0` closes properly
    via `Abelian.Ext.mk₀_comp_mk₀_assoc` and `φ.hom_inv_id`.  No Subsingleton-laundering —
    the Subsingleton is a genuine consequence of `affine_serre_vanishing_general_open`.
  - **Lines 332–348 — `ext_jShriekOU_eq_zero_of_specIso`**: mathematically sound assembly.
    The bijectivity of `pushforwardExtAddEquiv` is used correctly: `htr e = htr 0` (by
    subsingleton `hsub1`) implies `e = 0` by injectivity.  `hsub1` is transferred from
    `hsub0` via `subsingleton_ext_of_iso_fst hjt`.  No fake assumptions.
  - **Lines 418–510 — `higherDirectImage_openImmersion_acyclic`** (the `_acyclic` theorem):
    The proof chain is faithful to the blueprint route:
    `higherDirectImage_iso_sheafify_presheafHomology` → reflect through faithful functor →
    `sheafificationCompToSheaf` → `GW.mapHomologyIso'` → `isoRightDerivedObj` →
    `rightDerivedNatIso sectionsFunctorCorepIso` → `isZero_coyoneda_rightDerived_of_forall_ext_eq_zero`
    → `ext_jShriekOU_eq_zero_of_specIso` (with `hV'` closed inline, `hjt`/`hqc` sorry'd).
    The factoring of the leaf into `hjt` and `hqc` is exact and faithful: these are
    precisely the two remaining geometric transport sub-lemmas.
  - **Lines 483 — `hV'` case**: `(hW.preimage j).preimage_of_isIso U.isoSpec.inv` is correct
    (affine open → affine under affine morphism `j` → affine under iso `U.isoSpec.inv`).
  - **Line 484 — `hjt` (sorry)**: honest geometric hole — the transport iso
    `Φ(jShriekOU (j⁻¹W)) ≅ jShriekOU V'` requires `pushforward_commutes_free`/`_sheafify`
    + `yoneda_transport_along_homeo`.
  - **Line 485 — `hqc` (sorry)**: honest geometric hole — quasi-coherence preservation under
    `pushforwardEquivOfIso φ`.
  - **Line 551 — `higherDirectImage_openImmersion_comp` (entirely sorry)**: acknowledged
    open handoff.  The type signature is correct; the inline comment accurately describes
    the acyclic-resolution strategy.
  - **Lines 350–362 — planner strategy comment block**: embedded planning material in
    source code.  Not an excuse-comment (does not admit the current code is wrong).
    **(Minor — cosmetic.)**
  - **Style linter**: 5 long-line warnings (lines 256, 258, 465, 466, 474); all cosmetic.
    No `linter.flexible` or `linter.style.show` fires in this file.
  - **LSP diagnostics**: zero errors; 2 sorry warnings (both expected); 5 long-line warnings.

---

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 3 flagged (unqualified `simp`, misused `show`, maxHeartbeat options without comments — see notes)
- **excuse-comments**: none
- **notes**:
  - **Lines 54–85 — `widePullback_overX_isLimit`, `widePullback_overX_eq_prod`**: correct.
    The limit fan construction checks all three `mkFanLimit` obligations (`lift`, `fac`,
    `uniq`) via `WidePullback.{lift_π,lift_base,hom_ext}`.
  - **Lines 88–125 — `overSigmaDescCofan`, `overSigmaDescIsColimit`, `overSigmaDescIso`**:
    correct.  All three colimit obligations are checked; `Sigma.hom_ext` + `Sigma.ι_desc` close
    every branch.
  - **Lines 134–156 — `prodFinSuccIso`**: correct `Fin.cases` recursion step.  The proof
    handles both the head projection (`prod.lift_fst`) and the tail projections
    (`prod.lift_snd` + `Pi.lift_π`), plus the `prod.hom_ext`/`Pi.hom_ext` uniqueness check.
  - **Lines 164–179 — `prod_coproduct_distrib`**: mathematically sound.  Uses
    `FinitaryPreExtensive.isIso_sigmaDesc_fst` correctly; `hπ : IsIso (Sigma.desc (Sigma.ι Y))`
    is established by showing it equals `𝟙` via `Sigma.hom_ext`.  The component isos `e i`
    via `pullbackLeftPullbackSndIso` are correct paste-law instances.
  - **Lines 233–271 — `pcd_hom_fst`, `pcd_hom_snd`**: both lemmas compile with no errors.
    Two bare `simp` calls at lines 246 and 268 trigger `linter.flexible` warnings.
    These should be replaced with `simp only [...]` for robustness; the proofs are otherwise
    correct. **(Minor.)**
  - **Lines 285–298 — `overSigma_hom_eq`**: line 296 uses `show` to change the goal via
    definitional equality; Lean's linter flags this as `linter.style.show` (should use
    `change`).  **(Minor.)**
  - **Lines 300–352 — `overProd_coproduct_distrib`**: mathematically sound slice-level
    distributivity `(∐ A) ⊗ B ≅ ∐ (A i ⊗ B)`.  The structure-map condition is verified via
    `hR`, `e3eq`, `e4eq`; the `cf_hom_fst` + `pcd_hom_snd` compatibility lemmas supply the
    required projections.  Dense proof but no shortcuts.
  - **Lines 355–386 — `overProd_coproduct_distrib_right`, `widePullback_coproduct_iso`**:
    both sound.  The inductive step of `widePullback_coproduct_iso` correctly pipelines:
    `widePullback_overX_eq_prod` → `prodFinSuccIso` → `prod.mapIso` (induction hypothesis
    + `overSigmaDescIso`) → `overProd_coproduct_distrib` (left) → `overProd_coproduct_distrib_right`
    (right per summand) → `prodFinSuccIso.symm` (re-pack the finite product) →
    `coproduct_fibrePower_reindex` (collapse the double coproduct).  Each transition is
    justified by the preceding infrastructure.
  - **Line 363 — `set_option maxHeartbeats 1600000`**: the Mathlib linter requires an
    explanatory comment.  The comment is missing. **(Minor.)**
  - **Lines 432–459 — `widePullback_openImm_inter`**: sound.  The `hom` is built via
    `IsOpenImmersion.lift`; the `hom_inv_id` uses `WidePullback.hom_ext g` + `lift_π`/
    `lift_base`; the `inv_hom_id` uses `cancel_mono ι` + `lift_base`.  Correct.
  - **Line 541 — `cechBackbone_left_sigma` (sorry)**: honest Stub 1 hole.  The type
    signature is the correct categorical statement (iso in `Over X` of the Čech nerve
    backbone with `∐ Over.mk j_σ`).  Non-vacuous.
  - **Lines 585–591 — `pushPull_sigma_iso` (sorry)**: honest Stub 2 hole (the new-infra
    leaf).  Correct type.  The `set_option synthInstance.maxHeartbeats 800000` at line 585
    applies to a declaration whose body is currently `sorry` — the option has no effect
    now and is premature.  **(Minor.)**
  - **Lines 624–644 — `pushPull_leg_sections`**: the only non-sorry declaration in the Stub
    chain; has an explicit proof.  The chain `restrictFunctorIsoPullback.symm` followed by
    `eqToIso (image_preimage_eq_opensRange_inf + opensRange_ι)` typechecks clean (no LSP
    errors).  Correct.
  - **Lines 673–682 — `pushPull_eval_prod_iso` (sorry)**: honest Stub 4 hole.  Correct type.
  - **Lines 689–691 — `sectionCechComplexV`**: clean `abbrev`.  No concern.
  - **Lines 737–752 — `cechSection_complex_iso` (sorry)**: honest Stub 5 hole.  The
    statement `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` is the corrected form (uses
    the augmented complex); it is mathematically non-vacuous.  The "AMBIGUITY FLAG" note at
    line 699 is a prover-facing note about the adapter type for `Kp`, not an admission of
    incorrectness.  Not an excuse-comment.
  - **Lines 804–811 — `cechSection_contractible` (sorry)**: honest Stub 6 hole.  The
    statement — contracting homotopy on the augmented complex under `V ≤ coverOpen 𝒰 i_fix`
    — is mathematically correct: the hypothesis provides a left inverse for the augmentation
    map `ε` (the `i_fix`-component projection), and the standard combinatorial extra-degeneracy
    argument supplies the rest.  Non-vacuous.
  - **Style linter**: 17 long-line warnings (lines 198, 199, 202, 223, 233, 239, 241, 254,
    260, 262, 275, 285, 304, 305, 509, 546, 574, 684, 701); all cosmetic.  Two
    `linter.flexible` warnings (bare `simp` at lines 246, 268).  One `linter.style.show`
    (line 296).  Two maxHeartbeat-option-without-comment warnings (lines 363, 585).
  - **LSP diagnostics**: zero errors; 5 sorry warnings (all expected); style warnings only.

---

## Must-fix-this-iter

None.

No declaration has an excuse-comment, a weakened-wrong definition, a parallel Mathlib API,
a suspect non-sorry body on a substantive claim, or an unauthorized axiom.

---

## Major

- `OpenImmersionPushforward.lean:42` — `isZero_of_faithful_preservesZeroMorphisms` is an
  explicit copy-paste of the same declaration from `CechAugmentedResolution.lean` (import
  cycle prevents sharing).  The docstring is honest about this, which prevents it reaching
  must-fix, but the duplication creates a maintenance hazard: if either copy diverges (e.g.
  the proof breaks on a Mathlib bump), the error only appears in the file that imports the
  changed dependency.  When the import structure permits, extract to a shared utility module.

---

## Minor

- `OpenImmersionPushforward.lean:256,258,465,466,474` — 5 lines exceed the 100-character
  limit (`linter.style.longLine`).  Cosmetic.
- `OpenImmersionPushforward.lean:350–362` — embedded `/- Planner strategy: -/` comment block.
  Planning material in source; harmless but adds noise.
- `CechSectionIdentification.lean:246,268` — bare `simp` calls trigger `linter.flexible`.
  Should be `simp only [...]` for robustness against future Mathlib `@[simp]` additions.
- `CechSectionIdentification.lean:296` — `show` used to change a goal (should be `change`).
  `linter.style.show` fires.
- `CechSectionIdentification.lean:363` — `set_option maxHeartbeats 1600000` lacks the
  required explanatory comment.  `linter.style.maxHeartbeats` fires.
- `CechSectionIdentification.lean:585` — `set_option synthInstance.maxHeartbeats 800000`
  is applied to a `sorry`-body declaration; the option is inert until the proof is filled in,
  and lacks the required explanatory comment.  `linter.style.maxHeartbeats` fires.
- `CechSectionIdentification.lean` (various) — 17 long-line warnings.  Cosmetic.

---

## Excuse-comments (always called out separately)

None found in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1
- **minor**: 9 (counting each distinct issue location, not each individual long-line warning)
- **excuse-comments**: 0

Overall verdict: Both files are auditor-clean. Every sorry is an honest open problem with a
correctly-typed, non-vacuous goal. All proved declarations are mathematically sound, with no
smuggled assumptions or fake signatures. The single major finding (lemma duplication) is
correctly documented in-source and carries no correctness risk.
