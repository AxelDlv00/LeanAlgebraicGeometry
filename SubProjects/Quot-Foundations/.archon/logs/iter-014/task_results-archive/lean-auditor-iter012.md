# Lean Audit Report

## Slug
iter012

## Iteration
012

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 184–247: A large STATUS/UPDATE narrative inside the module-doc for the
    `globalSectionsIso_hom_comp_specMap_appTop` section references iteration numbers
    **iter-234**, **iter-236**, **iter-240**, **iter-241**. The current project is at
    iter-012. These are orphaned iteration numbers from the prior AlgebraicJacobian
    project from which this material was extracted. The underlying code (route (b),
    `gammaPushforwardIso`, etc.) is axiom-clean and the comments accurately describe
    historical dead-ends — the issue is purely the orphaned cross-project numbering,
    not factual error.
  - Lines ~841–851 (docstring for `base_change_mate_regroupEquiv`): "STATUS (iter-011,
    route (a) executed): the def is **fully proved, no `sorry`**." iter-011 is within
    this project's history; no issue here. The claim is accurate (the def is sorry-free).
  - Lines 998–1010 (`base_change_mate_unit_value`): proof body is `sorry`. Docstring
    accurately labels this as "REMAINING". No overstating of progress.
  - Lines 1079–1091 (`base_change_mate_fstar_reindex`): proof body ends in `sorry` after
    a descriptive comment. Docstring accurately labels as "REMAINING". No overstating.
  - Lines 1121–1136 (`base_change_mate_gstar_transpose`): partial proof (`rw [Functor.map_comp]`)
    then `sorry`. The partial step is genuine (functoriality of `moduleSpecΓFunctor`). The
    sorry is properly disclosed.
  - Lines 1147–1178 (`base_change_mate_section_identity`): proof is
    `unfold pushforwardBaseChangeMap; rw [Adjunction.homEquiv_counit];
    exact base_change_mate_gstar_transpose ψ φ M`. The dependency on
    `base_change_mate_gstar_transpose` (which is sorry-bearing) is **real**. The docstring
    says the sorry is "at the per-generator node below" — slightly inaccurate phrasing
    (the sorry is inside the called lemma, not syntactically below in this body), but
    not materially misleading.
  - `base_change_mate_generator_trace` and `pushforward_base_change_mate_cancelBaseChange`
    carry no `sorry` keyword directly but are sorry-bearing transitively through
    `base_change_mate_gstar_transpose → base_change_mate_section_identity`.
  - Lines 1309, 1331: `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`
    both contain `sorry` directly. All properly described.
  - No statement was weakened to dodge a seam. The three seam lemma types are mathematically
    substantive, and `base_change_mate_section_identity` depends genuinely on Seam 3.
  - Seam 1 (`base_change_mate_unit_value`) and Seam 2 (`base_change_mate_fstar_reindex`) are
    currently **not called** in any proof body — their dependencies on Seam 3 are documented
    only in comments. They are standalone sorry stubs awaiting integration.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (heartbeat raises)
- **excuse-comments**: none
- **notes**:
  - All axiom-clean declarations in `GenericFreeness` namespace:
    `exists_free_localizationAway_of_finite`, `exists_flat_localizationAway_of_finite`,
    `exists_free_localizationAway_of_moduleFinite`, `exists_free_localizationAway_of_torsion`,
    `exact_localizedModule_powers_of_shortExact`, `free_localizationAway_of_free_of_eq_mul`,
    `free_of_shortExact_of_free_free`, `exists_free_localizationAway_of_shortExact`,
    `gf_clear_one_denominator`, the full Nagata normalization block
    (`finSuccEquiv_map_comm`, private helpers, `gf_nagata_monic_lastVar`),
    `finSuccEquiv_rename_succ`, `mvPolynomial_quotient_finite_of_monic_lastVar`,
    and **`gf_generic_rank_ses`** — all verified axiom-clean with substantive proofs.
  - Lines 907–910: `set_option synthInstance.maxHeartbeats 1000000` and
    `set_option maxHeartbeats 1000000` on `gf_torsion_reindex`. Both are at theorem
    scope. The accompanying comments accurately describe the cause (stacked localization
    module instances on doubly-indexed polynomial rings). These are honest and not
    masking a broken statement.
  - Line 516 (`exists_localizationAway_finite_mvPolynomial`): `sorry` after Noether
    normalisation Step 1. Comment accurately identifies the surviving Mathlib-absent
    residue (descending module-finiteness from K[b̄] to A_g[b]). Honest.
  - Lines 945–1016 (`gf_torsion_reindex`): proof body ends in `sorry` after substantial
    and genuine partial work — the ASSEMBLY block installs all module instances, proves
    `hfinPg`, `hFgann`, `htorsion`, `hfinQf`, and the in-body comment chain (a)–(e)
    accurately describes the four remaining bookkeeping steps. The existential packaging
    of module instances in the statement (`∃ (_ : Module …) …`) is unconventional but
    not a weakening: the mathematical content (dimension drop under localization) is
    equivalent to the standard statement.
  - Lines 1084–1101 (`exists_free_localizationAway_polynomial`): `sorry` after the
    generic-rank SES is obtained; comment accurately says it is blocked on
    `gf_torsion_reindex`. Honest.
  - Lines 1145–1168 (`genericFlatnessAlgebraic`): `sorry` for the finite-type residue.
    Accurately described.
  - Line 1235 (`genericFlatness`): `sorry`. Accurately described.

---

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All 12 new declarations are **sorry-free and axiom-clean**: `affineChart`,
    `universalMatrix`, `minorDet`, `universalMinor`, `isUnit_det_universalMinor`,
    `universalMinorInv`, `universalMinorInv_mul_cancel`, `imageMatrix`,
    `transitionPreMap`, `universalMatrix_submatrix_self`, `universalMatrix_map_transitionPreMap`,
    `isUnit_transitionPreMap_minorDet`, `transitionMap`, `transitionMap_self`, plus all
    triple-overlap machinery and helpers.
  - **`cocycleCondition` is not circular.** Dependency chain traced:
    `cocycleCondition` → `cocycle_imageMatrix_eq` → `imageMatrix_map_eq` →
    `map_nonsing_inv`, `isUnit_det_universalMinor` → `IsLocalization.Away.algebraMap_isUnit`.
    No back-edge to `cocycleCondition`. The proof reduces both sides to `(Y_K)⁻¹ Y`
    via `imageMatrix_map_eq` applied in two ways, then `inv_mul_inv_mul_cancel` cancels
    `(Y_J)⁻¹ Y_J` in the RHS. This is a genuine and complete proof.
  - Private helpers (`mul_submatrix_col`, `map_nonsing_inv`, `isUnit_incl_transitionPreMap_cross`,
    `isUnit_algebraMap_away_left/right`, `map_map_eq_of_comp`, `imageMatrix_map_eq`,
    `inv_mul_inv_mul_cancel`, `cocycle_imageMatrix_eq`) all state what they claim and
    their proofs are complete.
  - `transitionMap_self` correctly proves `θ_{I,I} = id` via `IsLocalization.ringHom_ext`
    and establishing that `hpre : transitionPreMap … = algebraMap`.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: 4 flagged (sorry bodies on scaffold defs)
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 119, 157, 195, 219: docstrings for the four blueprint-pinned sorry-body
    declarations contain "iter-177+:" labels. The current project is at iter-012;
    iter-177+ is from the prior AlgebraicJacobian project. These labels indicate when
    the bodies were planned to be filled in the prior project and are now stale/confusing
    in the current project numbering. The underlying code state (all four are `:= sorry`
    or `:= by sorry`) is correctly described as "iter-176 file-skeleton" — the sorry
    bodies are accurate, but the "iter-177+" labels are orphaned.
  - `hilbertPolynomial` (line 125): `noncomputable def … := sorry`. A `def` body of
    `sorry` produces a definitionally-opaque term of type `Polynomial ℚ` that axiom-checks
    as `sorry`. The docstring accurately labels this a "typed `sorry`" file-skeleton placeholder.
  - `QuotFunctor` (line 165): `noncomputable def … := sorry`. Same pattern.
  - `Grassmannian` (line 201): `noncomputable def … := sorry`. Same pattern.
  - `Grassmannian.representable` (line 227): `theorem … := by sorry`. Same pattern.
  - **8 private power-series helpers are all sorry-free**: `coeff_invOneSubPow_one_mul`,
    `rationalHilbert_antidiff`, `IsRatHilb` (def), `IsRatHilb.ofEventuallyZero`,
    `IsRatHilb.bump`, `IsRatHilb.sub`, `IsRatHilb.shiftRight`, `IsRatHilb.antidiff`,
    `IsRatHilb.ofDiffEq`. All proved, no sorry.
  - **`annihilator_isLocalizedModule_eq_map`** (lines 362–422): Axiom-clean theorem.
    Proof is non-trivial: splits into `Ann Rₚ Mₚ ⊆ (Ann R M).map` and reverse, using
    `IsLocalization.mk'_surjective`, finite generating set, common-denominator clearing,
    and `IsLocalizedModule.mk'_smul_mk'`. The argument is mathematically correct and complete.
  - `IsLocallyFreeOfRank`, `annihilator`, `annihilator_ideal_le`, `schematicSupport`,
    `schematicSupportι`, `HasProperSupport`: All axiom-clean definitions/lemmas.

---

## Must-fix-this-iter

*All of these are `:= sorry` (or direct `sorry` in proof) on load-bearing declarations.
None are hiding progress — all surrounding comments are accurate. The must-fix flag is
the auditor's mechanical rule: open sorries block downstream work.*

- `FlatBaseChange.lean:1010` — `base_change_mate_unit_value` body is `sorry`. Why must-fix: load-bearing Seam 1 for the full affine base-change chain; not callable by any downstream proof until closed.
- `FlatBaseChange.lean:1091` — `base_change_mate_fstar_reindex` body ends in `sorry` (partial). Why must-fix: load-bearing Seam 2.
- `FlatBaseChange.lean:1136` — `base_change_mate_gstar_transpose` body ends in `sorry` (partial after `rw [Functor.map_comp]`). Why must-fix: the ONLY sorry in the dependency chain of `base_change_mate_section_identity`; all downstream theorems in the affine base-change proof are transitively sorry-bearing through this.
- `FlatBaseChange.lean:1309` — `affineBaseChange_pushforward_iso` proof body ends in direct `sorry` (the affine restriction step). Why must-fix: main theorem of the file.
- `FlatBaseChange.lean:1331` — `flatBaseChange_pushforward_isIso` body is `sorry`. Why must-fix: primary goal of the file.
- `FlatteningStratification.lean:516` — `exists_localizationAway_finite_mvPolynomial` (L4) body is `sorry`. Why must-fix: required by `genericFlatnessAlgebraic` in the non-finite-over-A case.
- `FlatteningStratification.lean:1016` — `gf_torsion_reindex` (L5b) body ends in `sorry`. Why must-fix: required by `exists_free_localizationAway_polynomial` and therefore by the full generic flatness chain.
- `FlatteningStratification.lean:1101` — `exists_free_localizationAway_polynomial` (L5) body ends in `sorry`. Why must-fix: required by `genericFlatnessAlgebraic`.
- `FlatteningStratification.lean:1168` — `genericFlatnessAlgebraic` body ends in `sorry`. Why must-fix: required by `genericFlatness`.
- `FlatteningStratification.lean:1235` — `genericFlatness` body is `sorry`. Why must-fix: primary geometric goal of the file.
- `QuotScheme.lean:125` — `hilbertPolynomial` def body is `sorry`. Why must-fix: load-bearing `def` with sorry body; the type `S → Polynomial ℚ` is non-trivial.
- `QuotScheme.lean:165` — `QuotFunctor` def body is `sorry`. Why must-fix: primary functor of the file.
- `QuotScheme.lean:201` — `Grassmannian` def body is `sorry`. Why must-fix: primary functor.
- `QuotScheme.lean:227` — `Grassmannian.representable` proof is `sorry`. Why must-fix: primary theorem.

---

## Major

- `FlatBaseChange.lean:184–247` — STATUS/UPDATE narrative in module-doc references iterations
  **iter-234, iter-236, iter-240, iter-241** from the prior AlgebraicJacobian project. Current
  project is at iter-012. These are orphaned cross-project iteration labels in a large
  explanatory block. The underlying described code is axiom-clean and the historical
  reasoning is accurate; the issue is purely the confusing numbering that makes the
  development history appear to span far more iterations than this project has run.
  Recommendation: strip or relabel these status blocks to remove the prior-project numbering.
- `QuotScheme.lean:119,157,195,219` — "iter-177+:" labels in docstrings of the four
  sorry-body scaffold declarations. Same prior-project numbering issue. The "iter-177+"
  references describe future implementation milestones using numbering from a different
  project. Recommendation: update to reference current project iteration numbers or remove.

---

## Minor

- `FlatBaseChange.lean:~1155` — Docstring for `base_change_mate_section_identity` states
  the sorry is "at the per-generator node below". Syntactically the sorry is inside the
  called lemma `base_change_mate_gstar_transpose`, not "below" in the current proof body.
  The comment accurately conveys the mathematical location (the generator-level
  mate-unwinding), but the "below" phrasing is imprecise for code navigation.
- `FlatteningStratification.lean:907–910` — Dual `set_option` heartbeat raises
  (`synthInstance.maxHeartbeats 1000000` and `maxHeartbeats 1000000`) on `gf_torsion_reindex`.
  These are honest and the comments explain the cause. Flagged only because both are at the
  theorem level; consider whether the instance-search raise alone suffices.
- `FlatBaseChange.lean` — `base_change_mate_unit_value` (Seam 1) and
  `base_change_mate_fstar_reindex` (Seam 2) are currently not called by any proof body —
  they are standalone sorry stubs. They will be needed once `base_change_mate_gstar_transpose`
  is developed beyond the current partial proof. This is the expected proof-development
  pattern (lay down the seams, then wire them up), but worth noting that the conceptual
  dependency (Seam 3 uses Seams 1 and 2) is documented only in comments, not in code.

---

## Excuse-comments (always called out separately)

None found. All sorry-body declarations are explicitly labeled as placeholders or "REMAINING"
obligations; no comment claims wrong code is correct or defers a known error.

---

## Severity summary

- **must-fix-this-iter**: 14 — all are open `sorry` bodies on load-bearing declarations; no deception or weakened statements detected
- **major**: 3 — orphaned cross-project iteration numbers in status comments (FlatBaseChange lines 184–247; QuotScheme lines 119, 157, 195, 219)
- **minor**: 3 — imprecise docstring phrasing, dual heartbeat raises, unconnected seam stubs
- **excuse-comments**: 0

Overall verdict: The four files are in clean sorry-bookkeeping state — all open sorries are
honestly disclosed, no statements were weakened to dodge proofs, GrassmannianCells.lean is
fully axiom-clean including the cocycle condition, and the only quality issues are orphaned
iteration labels from a prior project (major) and minor phrasing imprecisions.
