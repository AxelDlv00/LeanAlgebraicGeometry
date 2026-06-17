# Lean Audit Report

## Slug
iter152

## Iteration
152

## Scope
- files audited: 15 (14 under `AlgebraicJacobian/` + the root `AlgebraicJacobian.lean`)
- files skipped (per directive): 0

Diagnostics cross-checked with the LSP:
- `ChartAlgebra.lean`: only two `sorry` warnings (L256, L468); **no errors**. `df_zero_factors_through_constant_on_chart` (L411) emits **no** sorry warning yet `lean_verify` reports its axiom set as `{propext, sorryAx, Classical.choice, Quot.sound}` — i.e. it transitively depends on `sorry`.
- `RigidityKbar.lean`: one `sorry` warning (L75); no errors.
- Declaration-level inline-`sorry` count matches the directive's known-issues tally (9 total).

## Per-file checklist

### AlgebraicJacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Pure import aggregator. Fine.

### AlgebraicJacobian/AbelJacobi.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `ofCurve`/`comp_ofCurve`/`exists_unique_ofCurve_comp` are honest projections from `jacobianWitness`. Transitively depend on the Jacobian `sorry`-chain (known/expected). Status block (iter-073) is accurate.

### AlgebraicJacobian/Cohomology/MayerVietorisCore.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Mature MV-LES core; no sorries. `set_option backward.isDefEq.respectTransparency false` usages are documented Mathlib-mirror requirements.

### AlgebraicJacobian/Cohomology/MayerVietorisCover.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 2-affine cover MV + carrier classes; no sorries. Comments accurate.

### AlgebraicJacobian/Cohomology/SheafCompose.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (whole-library `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - L6 `import Mathlib` (whole library) rather than targeted imports — minor build-cost smell.

### AlgebraicJacobian/Cohomology/StructureSheafAb.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Three honestly-closed instances. Fine.

### AlgebraicJacobian/Cohomology/StructureSheafModuleK.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Large, mature, no sorries. The abandoned `IsAffineHModuleHomFinite` is correctly documented as removed (L46-48) rather than left as dead code — good hygiene.

### AlgebraicJacobian/Cotangent/ChartAlgebra.lean  *(focus)*
- **outdated comments**: 3 flagged
- **suspect definitions**: none (signatures well-formed; sorries honest/expected)
- **dead-end proofs**: 0 (the two `sorry` bodies are documented open obligations)
- **bad practices**: 1 (naming drift on `ext_of_diff_zero`); 1 (sorryAx laundering)
- **excuse-comments**: none in the red-flag sense
- **notes**:
  - L39-61 file-level "Status (iter-146 prover lane)" block is stale: references `: True := sorry` skeletons that no longer exist, and describes the "base-change-to-`\bar k`-and-properness chain" closure for `constants_integral_over_base_field` that the iter-152 body explicitly abandons.
  - L227-255 (`mem_range_algebraMap_of_D_eq_zero` docstring header) frames the typeclass story as "Iter-149 signature inflation (`[CharZero k]` + std-smooth)" and does **not** mention the iter-152 `[IsAlgClosed k]`+`[IsDomain B]` additions (the very change made this iter). The body comment L361-382 *does* cover them — header lags the signature.
  - L387-410 + L422-428 (`df_zero_factors_through_constant_on_chart`) docstring/body comment mention only iter-147/iter-149 refinements; do not explain the iter-152 `[IsAlgClosed k]`+`[IsDomain B]` now in its own signature.
  - L433-467 (`constants_integral_over_base_field` docstring) documents a 3-substep recipe (substep 3 base-change to `\bar k`; `IsPurelyInseparable`/`IsSeparable` split) that the iter-152 body comment (L475-485) directly contradicts ("none of the four (S3.*) lemmas … are consumed"). Actively misleading about the intended proof route.
  - L411 `df_zero_factors_through_constant_on_chart`: clean delegation body, **no inline sorry**, but axiom-set contains `sorryAx` (verified). Honest in source (docstring says it delegates to the KDM helper), but a syntactic sorry-counter would mis-mark it sorry-free → blueprint `\leanok` laundering risk. Known prior issue; persists by design.
  - L516 `Scheme.Over.ext_of_diff_zero`: name promises a "differentials vanish" hypothesis but the signature takes scheme-level `eqOnOpen` (and is a verbatim re-statement delegating to `ext_of_eqOnOpen`). Honestly documented as a thin rename, but the name overpromises.
  - **Positive**: the iter-152 fix to `mem_range_algebraMap_of_D_eq_zero` (adding `[IsAlgClosed k]`+`[IsDomain B]`, documented counterexamples CE1/CE2 at L366-375) correctly repairs the previously-false bare statement; the signature is now mathematically plausible. The remaining `sorry` is a genuine to-prove obligation, not a stand-in for a false claim.

### AlgebraicJacobian/Cotangent/ChartAlgebraS3.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: 0 (4 off-path scaffold sorries, per directive)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L59-63 file header claims the four (S3.*) lemmas "are consumed by Lane 2 … the consolidated `sorry` at L367 of `ChartAlgebra.lean` is rewritten to feed (S3.sep.1 → S3.sep.2) …". Stale after the iter-152 alg-closed re-route: the consumer is now a bare `sorry` (at L468, not L367) consuming none of them. Several per-lemma docstrings repeat the stale coupling/line numbers (L148-179 ref `ChartAlgebra.lean:L431`; L306-323 ref `L457`).
  - L208 / L51 describe `Gamma_baseChange_iso_tensor_of_proper` as "The load-bearing Mathlib gap of path (b)" while L220-242 mark it "HYBRID-DEFERRED … NOT on the project's M2.a critical path" — internally contradictory framing (load-bearing only for the descoped path (b)). Per directive these off-path scaffolds are otherwise fine; flagged only for the contradictory "load-bearing" wording.

### AlgebraicJacobian/Cotangent/GrpObj.lean
- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none (file is sorry-free)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - L433-443 "Status" block states "Step 2 PARTIAL iter-137 (body remains `sorry`) … Compose main lemma body `sorry` pending Step 2 closure (iter-138+ target)". Both referenced declarations (`relativeDifferentialsPresheaf_basechange_along_proj_two`, `mulRight_globalises_cotangent`) were **excised iter-145** (excise notes at L552-560, L624-629). The status is stale.
  - L465-525 section comment "Piece (i.b) Step 2 … (iter-138 PARTIAL skeleton)" enumerates three sub-goals (`d_app`, `d_map`, `IsIso`) of the now-excised `basechange_along_proj_two_inv`. Orphaned ~60-line comment block describing deleted declarations; only `isIso_of_app_iso_module` survives from that lane.
  - Live declarations (`cotangentSpaceAtIdentity`, `cotangentSpaceAtIdentity_finrank_eq`, `shearMulRight`, `section_snd_eq_identity_struct`, `relativeDifferentialsPresheaf_restrict_along_identity_section`, `isIso_of_app_iso_module`) are sound and sorry-free.

### AlgebraicJacobian/Differentials.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `smooth_locally_free_omega` honestly discloses that the *converse* is mathematically false (with counterexample). Forward direction proven, no sorry. Good hygiene.

### AlgebraicJacobian/Genus.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 (whole-library `import Mathlib`)
- **excuse-comments**: none
- **notes**:
  - L6 `import Mathlib`. Body is the honest `dim_k H¹(C,O_C)` one-liner; accurate.

### AlgebraicJacobian/Jacobian.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 0 (2 expected `sorry` scaffolds: `genusZeroWitness` L197, `positiveGenusWitness` L223)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `nonempty_jacobianWitness` (L249) has no inline sorry but transitively depends on the two witness sorries (same laundering pattern as `df_zero`; honestly documented). The "Forbidden shortcut" sanity-check comment (L44-53) is a genuinely useful guard, not an excuse-comment.

### AlgebraicJacobian/Rigidity.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `Scheme.Over.ext_of_eqOnOpen` closed, no sorry. "Hypothesis history" block is accurate and well-justified (the char-p Frobenius rationale for strengthening to scheme-level equality is correct).

### AlgebraicJacobian/RigidityKbar.lean  *(focus)*
- **outdated comments**: 1 flagged
- **suspect definitions**: none (signature well-formed)
- **dead-end proofs**: 0 (1 expected `sorry`: `rigidity_over_kbar` L75)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Signature addition `[IsAlgClosed kbar]`+`[CharZero kbar]` is well-formed. The "Status (iter-126 scaffold)" block (L20-29) and the declaration docstring (L70-74) don't mention the iter-152 typeclass additions — mild staleness.
  - The iter-126 "Encoding choice" note (Option A literal `ℙ¹` is mathematically wrong) is a correct, valuable disclosure, not an excuse-comment.

## Must-fix-this-iter

None. Every `sorry` in scope is a documented, signature-sound open obligation (matching the directive's known-issues tally); no excuse-comments, no weakened-wrong definitions, no parallel-API copies, no unauthorized axioms, no `:= True`/`:= rfl`-on-nontrivial bodies. The iter-152 signature changes are well-formed Lean and (for the KDM lemma) mathematically repair a previously-false statement.

## Major

- `Cotangent/ChartAlgebra.lean:433-485` — `constants_integral_over_base_field` docstring (3-substep recipe, base-change to `\bar k`, `IsPurelyInseparable`/`IsSeparable` split) is contradicted by the iter-152 body comment, which states the alg-closed route consumes none of the (S3.*) lemmas. Actively misleads about the intended closure.
- `Cotangent/ChartAlgebra.lean:39-61` — file-level "Status (iter-146 prover lane)" block stale: cites `: True := sorry` skeletons that no longer exist and a closure chain the body has abandoned.
- `Cotangent/ChartAlgebra.lean:227-255, 387-428` — docstrings of the two declarations re-signed this iter (`mem_range_algebraMap_of_D_eq_zero`, `df_zero_factors_through_constant_on_chart`) were not updated to explain the new `[IsAlgClosed k]`+`[IsDomain B]` hypotheses.
- `Cotangent/ChartAlgebra.lean:411` — `df_zero_factors_through_constant_on_chart` is sorry-free in its own body but carries `sorryAx` transitively (verified). Risk of false `\leanok` if the marker sync counts only inline sorries. (Known prior issue, persists.)
- `Cotangent/ChartAlgebra.lean:516` — `Scheme.Over.ext_of_diff_zero` name implies a `df = dg` hypothesis the signature does not contain (it takes `eqOnOpen`); currently a verbatim rename of `ext_of_eqOnOpen`.
- `Cotangent/ChartAlgebraS3.lean:59-63, 148-179, 306-323` — stale consumer cross-references: claim `constants_integral_over_base_field` consumes the (S3.*) lemmas at `ChartAlgebra.lean:L367/L431/L457`; the iter-152 consumer (now at L468) consumes none of them, and the line numbers are wrong.
- `Cotangent/GrpObj.lean:433-443, 465-525` — stale comment blocks describing Step 2 / Compose-main lemmas as `sorry`-pending; both were excised iter-145. The ~60-line sub-goal enumeration is orphaned.

## Minor

- `RigidityKbar.lean:20-29, 70-74` — status/docstring don't mention the iter-152 `[IsAlgClosed kbar]`+`[CharZero kbar]` additions.
- `Cotangent/ChartAlgebraS3.lean:51, 208 vs 220-242` — `Gamma_baseChange_iso_tensor_of_proper` simultaneously called "the load-bearing Mathlib gap of path (b)" and "NOT on the project's M2.a critical path"; contradictory framing (load-bearing only for a descoped path).
- `Genus.lean:6`, `Cohomology/SheafCompose.lean:6` — whole-library `import Mathlib` instead of targeted imports.
- `Cotangent/ChartAlgebra.lean:262-383` — large dead scaffolding (`_hRev`, `_basis`, `_hCoordVanish`, `bTilde`, `_hFunct`, the SubmersivePresentation `obtain`, …) preceding the `sorry`, underscore-prefixed to suppress lints. Documented "structured sorry"; acceptable but heavy.

## Excuse-comments (always called out separately)

None. The project's many "structured `sorry` pending iter-N+" comments are documented open-obligation markers on signature-sound declarations, not admissions of wrong code; they do not meet the excuse-comment bar.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 7
- **minor**: 4
- **excuse-comments**: 0

Overall verdict: The iter-152 signature changes are well-formed Lean and the KDM re-signing is a genuine mathematical repair, but a cluster of stale comments (abandoned proof recipes, excised-declaration status blocks, wrong consumer cross-references) and one persistent `sorryAx`-laundering site warrant comment cleanup — no wrong code blocks downstream work this iter.
