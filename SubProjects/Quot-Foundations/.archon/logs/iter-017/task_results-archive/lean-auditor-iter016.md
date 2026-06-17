# Lean Audit Report

## Slug
iter016

## Iteration
016

## Scope
- files audited: 7
- files skipped (per directive): 0 — all source files under project tree audited
  (`.lake/packages/` external dependencies and `.archon/logs/` historical snapshots excluded as non-project-source)

Project source files enumerated:
1. `AlgebraicJacobian.lean`
2. `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
3. `AlgebraicJacobian/Cohomology/RegroupHelper.lean`
4. `AlgebraicJacobian/Picard/FlatteningStratification.lean`
5. `AlgebraicJacobian/Picard/GrassmannianCells.lean`
6. `AlgebraicJacobian/Picard/QuotScheme.lean`
7. `AlgebraicJacobian/Picard/RelativeSpec.lean`

---

## Per-file checklist

### `AlgebraicJacobian.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 5-line import hub. Clean. No findings.

---

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- **outdated comments**: 5 flagged (all stale cross-project iter markers from predecessor project)
- **suspect definitions**: none
- **dead-end proofs**: 4 flagged (honest scaffolding sorries with detailed explanations)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Line 184–247 (`STATUS (iter-234)` / `UPDATE (iter-236)` block)**: This large comment block carries iteration markers `iter-234` and `iter-236`. The current project (Quot-Foundations) is at iter-016; these numbers originate from the predecessor project "Algebraic-Jacobian-Challenge" (per git history: "Initial commit: extracted from Algebraic-Jacobian-Challenge"). The block is stale cross-project narrative.
  - **Lines 234–247 — ACTIVELY MISLEADING**: This sub-block states that `pushforward_spec_tilde_iso` has "the sole remaining obligation" — a specific QC-fact — still open. However, `pushforward_spec_tilde_iso` at line 538 is CLOSED (no sorry). The comment describes a state that no longer exists. Anyone reading this block will incorrectly believe a proof debt exists on that declaration.
  - **Line 547 (`-- iter-240 PIVOT (algebraize)`)**: Stale predecessor-project marker.
  - **Lines 635–639 (`-- KEY INSIGHT (iter-241)`)**: Stale predecessor-project marker.
  - **Lines 1199–1211 (`PARTIAL (iter-015)`)**: Current-project marker. Fine.
  - **Lines 1225–1248 (`LEG-REINDEX ENGINE (iter-016, LSP-validated)` / `RESIDUAL WALL (iter-016)`)**: Current-project markers. Fine.
  - **`pullbackPushforward_unit_comp` (lines 1140–1157)** [PROVER-FOCUS]: VERIFIED REAL PROOF. No sorry anywhere in the body. Statement is a non-vacuous pseudofunctoriality identity for adjunction units across a composite `a ≫ b`. Proof uses `unit_conjugateEquiv`, `conjugateEquiv_pullbackComp_inv`, `Adjunction.comp_unit_app`, `Category.assoc` — all structurally appropriate for the goal. Not over-specialized.
  - **`base_change_mate_fstar_reindex` (line 1248)**: Honest sorry. Detailed comment documents dependent-position rewrite wall (coercion blocks `conv`/`rw`). Not fake; not a must-fix excuse.
  - **`base_change_mate_gstar_transpose` (line 1293)**: Honest sorry. Structurally paired obligation.
  - **`affineBaseChange_pushforward_iso` (line 1466)**: Honest sorry awaiting affine reduction.
  - **`flatBaseChange_pushforward_isIso` (line 1488)**: Honest sorry awaiting Čech cohomology infrastructure.
  - All sorry-bearing declarations carry the correct types; none have `:= True`, `:= rfl`, or fake bodies.

---

### `AlgebraicJacobian/Cohomology/RegroupHelper.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 99-line file. Single declaration `base_change_regroup_linearEquiv`. REAL PROOF, no sorry.
  - `map_smul'` discharged by `TensorProduct.induction_on` with `zero`, `add`, `tmul` cases — correct pattern for this obligation.
  - Uses `comm ≫ cancelBaseChange ≫ comm` route; structurally sound.
  - File is axiom-clean.

---

### `AlgebraicJacobian/Picard/FlatteningStratification.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged (honest sorries, OreLocalization instance-diamond blocked)
- **bad practices**: none (see note on `synthInstance.maxHeartbeats`)
- **excuse-comments**: none
- **notes**:
  - **`free_localizationAway_of_away_tower` (lines 1270–1373)** [PROVER-FOCUS]: VERIFIED REAL PROOF. No sorry. Witness is `f := g * a` (single product of `g ∈ A` and numerator `a ∈ A`), obtained via `mul_ne_zero hg ha` at line 1297. Uses `IsLocalization.Away.mul_of_associated` for the localization identification. The plan's worry about `f²` (`hf0 hf0` squaring) is UNFOUNDED for this declaration. Clean.
  - **Three `set_option synthInstance.maxHeartbeats 1000000`** (directive mentioned two; there are actually three):
    - **Line 1015** (before `gf_torsion_reindex`): Honest. `MvPolynomial` over `Localization.Away` has deep instance chains. Proof is real (lines 1026–1252).
    - **Line 1254** (before `free_localizationAway_of_away_tower`): Honest. Doubly-localized carrier has `OreLocalization` / `LocalizedModule` path explosion. Proof is real.
    - **Line 1375** (before `exists_free_localizationAway_polynomial`): Honest. Stacked `OreLocalization` / `MvPolynomial` structures. Proof is partial (sorry at line 1517 for IH-application step, blocked by OreLocalization instance diamond). The high heartbeat limit is genuinely required even for the elaborated portions.
    - None of the three `synthInstance.maxHeartbeats` overrides mask looping or ill-posed elaboration.
  - **`exists_localizationAway_finite_mvPolynomial` (line 516)**: Honest sorry. Mathlib-absent content (Noether-normalization denominator clearing). Detailed comment. Not an excuse.
  - **`exists_free_localizationAway_polynomial` (lines 1485–1517)**: `sorry` at line 1517 for the IH-application step. The rest of the proof structure is real. Comment explains the OreLocalization instance diamond (two distinct paths from `CommRing.toCommSemiring` at default transparency). Not fake; not vacuous. The author's documented awareness of the precise blocker is credible.
  - **`genericFlatnessAlgebraic` (line 1597)**: Honest sorry for finite-type residue dévissage.
  - **`genericFlatness` (line 1664)**: Honest sorry for the geometric assembly.

---

### `AlgebraicJacobian/Picard/GrassmannianCells.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none (ZERO sorries in this file)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - 635 lines, entirely sorry-free.
  - `cocycleCondition`: Full proof using `IsLocalization.ringHom_ext` + `cocycle_imageMatrix_eq`. Real.
  - `transitionMap_self`, `isUnit_transitionPreMap_minorDet`, `universalMatrix_map_transitionPreMap`: all real proofs.
  - Mathematical structure is elementary matrix algebra over localized polynomial rings. No structural anomalies.
  - File is in the healthiest state of any in the project.

---

### `AlgebraicJacobian/Picard/QuotScheme.lean`
- **outdated comments**: 2 flagged (stale predecessor-project iter markers in docstrings)
- **suspect definitions**: none
- **dead-end proofs**: 4 flagged (honest scaffolding sorries)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Docstrings for `QuotFunctor` and related declarations reference `iter-177+` and `iter-176 file-skeleton`. These are predecessor-project ("Algebraic-Jacobian-Challenge") iter numbers. Minor stale context noise.
  - **`hilbertPolynomial`, `QuotFunctor`, `Grassmannian`, `Grassmannian.representable`**: All `:= sorry`. Bodies are honest; types are substantive and non-vacuous. No excuse-comments attached.
  - **`annihilator_isLocalizedModule_eq_map`**: ~60-line proof. Real and structurally sound.
  - **`rationalHilbert_antidiff`, `IsRatHilb.*`, `GradedModule.*`, `degreewise_finrank_diff`**: All real proofs.
  - The `annihilator` def uses `IdealSheafData.ofIdeals` pattern correctly.

---

### `AlgebraicJacobian/Picard/RelativeSpec.lean`
- **outdated comments**: 6+ flagged (stale predecessor-project iter markers throughout docstrings and section headers)
- **suspect definitions**: none
- **dead-end proofs**: none (ZERO sorries; all four declarations have real bodies)
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - All iter markers (`iter-173`, `iter-174`, `iter-175`, `iter-176`, `iter-177`, `iter-178`, `iter-179`) throughout docstrings and comment blocks are from the predecessor project "Algebraic-Jacobian-Challenge." The current project is iter-016.
  - **`QcohAlgebra`**: Proper structure with three substantive fields (`sheaf`, `unit`, `coequifibered`). Not a weakened definition.
  - **`RelativeSpec`**: `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).glued` — real Mathlib construction.
  - **`RelativeSpec.structureMorphism`**: `(AffineZariskiSite.relativeGluingData 𝒜.coequifibered).toBase` — real.
  - **`UniversalProperty`**: Real proof. Uses `isAffineHom_of_forall_exists_isAffineOpen`; picks an affine open `U ∋ x`, identifies preimage via `Cover.RelativeGluingData.toBase_preimage_eq_opensRange_ι`, closes with `isAffineOpen_opensRange`. Structurally sound.
  - **`affine_base_iff`**: Real proof. Uses `isAffine_of_isAffineHom` via `UniversalProperty`. One-liner once `UniversalProperty` is in hand. Correct.
  - Lines 229, 277: "iter-174+: refine to a `RepresentableBy` witness…" — forward-looking TODO notes from predecessor project. Not admissions of wrongness; the current types are non-tautological and correct. Minor noise.

---

## Must-fix-this-iter

None.

All sorries in the project are honest scaffolding obligations with substantive types and (in most cases) detailed explanations of the specific blocker. No declaration has a `:= True`, `:= rfl`, or `Classical.choice _` body on a non-trivial claim. No weakened-wrong definitions. No parallel APIs duplicating Mathlib. No unauthorized `axiom` declarations. No excuse-comments ("will fix later", "placeholder", "wrong but works").

---

## Major

- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:234–247` — Stale block claims that `pushforward_spec_tilde_iso` has "the sole remaining obligation" (a QC fact) still open. The declaration at line 538 is CLOSED (no sorry). This comment actively misleads about current proof status. Any reader or subagent reading this block will incorrectly believe a proof debt exists.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:184–247` — Large `STATUS (iter-234)` / `UPDATE (iter-236)` block from predecessor project "Algebraic-Jacobian-Challenge." Iter-234 and iter-236 have no meaning in the current project (iter-016). Block should be pruned or replaced with a current-project status note.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:547` — `-- iter-240 PIVOT (algebraize):` inline marker from predecessor project. Stale.
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean:635–639` — `-- KEY INSIGHT (iter-241):` inline marker from predecessor project. Stale.
- `AlgebraicJacobian/Picard/RelativeSpec.lean` (multiple lines: ~54, 96, 168, 205, 213, 229, 277) — Pervasive iter-173 through iter-179 markers throughout docstrings and section headers. All from predecessor project. The file as a whole reads as though it belongs to a different, much more advanced project. This is not harmful to proof correctness but is misleading provenance noise.

---

## Minor

- `AlgebraicJacobian/Picard/QuotScheme.lean` (docstrings for `QuotFunctor` and related) — `iter-177+` and `iter-176 file-skeleton` references are predecessor-project iter markers. Lower density than FlatBaseChange.lean or RelativeSpec.lean; minor cleanup.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — The directive noted two `set_option synthInstance.maxHeartbeats 1000000` instances; there are in fact three (lines 1015, 1254, 1375). No correctness issue — all three are legitimate — but the discrepancy suggests the directive's search was incomplete. Log for awareness.
- `AlgebraicJacobian/Picard/RelativeSpec.lean:229, 277` — "iter-174+: refine to `RepresentableBy`…" forward-looking TODOs. The current type is non-tautological and correct; these are enhancement notes, not admissions of weakness. Very minor.

---

## Excuse-comments (always called out separately)

None found. No declaration in the audited files carries a comment admitting that the current body is wrong, a placeholder, or a temporary stand-in.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 5
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: The proof code is clean — no fake sorries, no weakened-wrong definitions, no excuse-comments, and both prover-focus declarations (`pullbackPushforward_unit_comp` and `free_localizationAway_of_away_tower`) have real, honest proofs — but `FlatBaseChange.lean` carries a stale block (lines 234–247) that actively misrepresents the proof status of `pushforward_spec_tilde_iso`, and pervasive predecessor-project iter markers in `FlatBaseChange.lean` and `RelativeSpec.lean` create provenance confusion that should be cleaned up.
