# Lean Audit Report

## Slug
iter011

## Iteration
011

## Scope
- files audited: 4
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Picard/GrassmannianCells.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 31–44: A `/-` block labelled "Planner note:" is embedded inside the production source namespace. It contains natural-language construction guidance aimed at a prover agent, not a reader of the formalized code. This is scaffolding that belongs in the blueprint or task_results; in production source it will become stale as the proofs evolve.
  - `universalMatrix_submatrix_self` (line 150): Genuine proof — identifies the I-columns of `universalMatrix` as the identity block. Checked: uses `dif_pos`, a by-cases on `p = p'`, and an order-iso injectivity step. Not trivial.
  - `isUnit_transitionPreMap_minorDet` (line 229): Non-vacuous. Proof uses `RingHom.map_det` + `universalMatrix_map_transitionPreMap` + `imageMatrix_submatrix_I` + `IsUnit.of_mul_eq_one`; the det-inverse identity is real content (requires `universalMinorInv_mul_cancel`).
  - `transitionMap_self` (line 255): Genuine proof. Four sub-steps (`hmin1 → hinv1 → himg → hpre`) followed by `IsLocalization.ringHom_ext`. Not a degenerate placeholder.
  - `mul_submatrix_col` private lemma (line 165): Comment "avoids a matrix-multiplication instance-keying issue that blocks the generic rw of Mathlib's submatrix-mul lemmas" — this is an honest technical explanation, not an excuse-comment.
  - All 16 new declarations: no `sorry`, no `axiom`; bodies are genuine. The directive's claim of axiom-clean and sorry-free is confirmed.

---

### AlgebraicJacobian/Cohomology/FlatBaseChange.lean

- **outdated comments**: 2 flagged
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Lines 184–246 (section header `/-! ## Project-local Mathlib supplement — global-sections / pushforward ring map -/`): Contains a large multi-paragraph STATUS block referencing iteration numbers **iter-234**, **iter-236**, **iter-240**, **iter-241**. This project (Quot-Foundations) is at iter-011 with only one git commit ("Initial commit: extracted from Algebraic-Jacobian-Challenge"). Those iteration numbers are from the source project. These comments are stale legacy development logs imported verbatim and do not correspond to any iteration of this project's history. They will cause confusion about the project's development narrative.
  - Line ~1059 (docstring of `pushforward_base_change_mate_cancelBaseChange`): Says "is the genuine crux and is the outstanding obligation (typed `sorry` below)." The sorry this function **depends on** is in `base_change_mate_section_identity` at line 1011, which is **above** `pushforward_base_change_mate_cancelBaseChange` in the file, not below. The declaration's own proof body contains no `sorry`, but it chains through `base_change_mate_generator_trace → base_change_mate_section_identity` (which is sorry-blocked). A reader sees "sorry below" and may incorrectly conclude this declaration is sorry-free; its axiom set includes `sorryAx`.
  - Lines 839–851 (docstring of `base_change_mate_regroupEquiv`): "STATUS (iter-011, route (a) executed): the def is **fully proved, no `sorry`**." — This is accurate and current-iteration. The function body has no `sorry`.
  - `base_change_mate_section_identity` (line 984): The sorry at line 1011 is inside a proof reduced to the per-generator identity after `ext x`. The docstring honestly names this as the "residual mate-unwinding coherence… Mathlib-absent." Correctly scoped.
  - `affineBaseChange_pushforward_iso` (line 1111): sorry at line 1142 for the affine-reduction step. Docstring and inline comment both name this as "obligation 1" (the restriction-compatibility of `pushforwardBaseChangeMap`). Honestly scoped.
  - `flatBaseChange_pushforward_isIso` (line 1151): sorry at line 1164. Docstring honestly describes the Čech-complex / affine-cover infrastructure as missing. Correctly scoped.
  - Inline iteration references in proof bodies (e.g., "iter-240 PIVOT" at line ~566, "iter-241" at line ~632): legacy annotation noise from source project.

---

### AlgebraicJacobian/Picard/FlatteningStratification.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **Domain adaptation (NagataNormalization, lines 660–822)**: The private lemmas (`T`, `T1`, `degreeOf_zero_t`, `T_leadingcoeff_eq`, etc.) transcribe Mathlib's field-only Noether-normalisation machinery to a noetherian domain. The adaptation is sound: the section variable is `[CommRing k] [IsDomain k]`, and `T_leadingcoeff_eq` (line 760) returns the leading coefficient as `MvPolynomial.C (coeff v f)` (non-zero in a domain) rather than asserting it is a unit (which requires a field). `gf_nagata_monic_lastVar` (line 795) then localizes at that coefficient to make it a unit (`IsLocalization.Away.algebraMap_isUnit`). The field is **not** silently assumed.
  - `gf_torsion_annihilator` (line 636): Genuine, sorry-free. Uses `Submodule.annihilator_top_inter_nonZeroDivisors`. The domain hypothesis `IsDomain A` is used via `nonZeroDivisors.ne_zero`. Non-trivial.
  - `gf_nagata_monic_lastVar` (line 795): Genuine, sorry-free. Uses the private `T_leadingcoeff_eq` + localization + `leadingCoeff_map_of_leadingCoeff_ne_zero`. Non-trivial.
  - `mvPolynomial_quotient_finite_of_monic_lastVar` (line 852): Genuine, sorry-free. Rescales to a monic polynomial, invokes `Polynomial.Monic.finite_quotient`, transports along `AlgEquiv`. Non-trivial.
  - `gf_torsion_reindex` (line 912): sorry at line 949, labelled "REMAINING ASSEMBLY (localization-module transport plumbing, not a math blocker)." The three mathematical building blocks (`gf_torsion_annihilator`, `gf_nagata_monic_lastVar`, `mvPolynomial_quotient_finite_of_monic_lastVar`) are all in place and called; the sorry is the assembly glue. Honestly scoped per the directive.
  - `exists_free_localizationAway_polynomial` (line 964): sorry at line 1034. The strong-induction skeleton with `generalizing N` is genuine; the inductive step's sorry is blocked only on `gf_torsion_reindex`. Comment is detailed and honest.
  - `genericFlatnessAlgebraic` (line 1071), `genericFlatness` (line 1133): sorries are honest; primary route (finite-module leaf) is axiom-clean, residue is the genuine Mathlib-absent dévissage.
  - `exists_free_localizationAway_of_torsion` (line 168): Detailed proof using `LocalizedModule.subsingleton_iff`, span induction, product of annihilators. Sound; the `smul_comm` usage on line 202 is valid (commutative ring action).
  - `finSuccEquiv_map_comm` (private, line 668): Correct by `MvPolynomial.induction_on` with `Fin.cases` on the variable index.

---

### AlgebraicJacobian/Picard/QuotScheme.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - `hilbertPolynomial` (line 123): `:= sorry`. Docstring explicitly says "for the iter-176 file-skeleton the body is a typed `sorry`." Not an excuse-comment — the type is substantive (`Polynomial ℚ`) and the skeleton status is honestly declared.
  - `QuotFunctor` (line 161): `:= sorry`. Same rationale; type is `(Over S)ᵒᵖ ⥤ Type u`.
  - `Grassmannian` (line 198): `:= sorry`. Same.
  - `Grassmannian.representable` (line 225): `:= sorry`. Same; packages `∃ Y, Nonempty (... .RepresentableBy Y)` which is substantive.
  - **All four skeleton sorries are honestly scoped** (docstrings say "iter-177+: the body…" and flag the skeleton status explicitly). No overclaiming.
  - `annihilator` (line 298): `IdealSheafData.ofIdeals (fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1))`. Genuine — mirrors the `Scheme.Hom.ker` pattern. The section comment (lines 268–279) honestly explains that the full bidirectional characterization (`annihilator_ideal`) is blocked on the QCoh→localization bridge.
  - `annihilator_ideal_le` (line 305): Uses `IdealSheafData.ideal_ofIdeals_le`. Non-vacuous: states only the `≤` direction (the always-available `ofIdeals` direction). Reverse inclusion is correctly deferred.
  - `schematicSupport`, `schematicSupportι` (lines 312, 320): Non-trivial derived definitions, no sorry.
  - `HasProperSupport` (line 328): `IsProper (schematicSupportι F ≫ f)`. Non-vacuous predicate.
  - `IsLocallyFreeOfRank` (line 253): Uses `⨆ i, U i = ⊤` + pullback-iso to free sheaf. Non-vacuous.
  - `annihilator_isLocalizedModule_eq_map` (line 362): Substantial proof (lines 369–421). The ≥ direction uses `IsLocalization.mk'_surjective`, a finite common-denominator argument (product of annihilator witnesses over generators), and `IsLocalization.mk'_eq_mul_mk'_one`. The ≤ direction uses `Ideal.map_le_iff_le_comap` + `IsLocalizedModule.mk'_surjective`. The `smul_comm`-style steps are valid over a commutative ring. Proof is sound.

---

## Must-fix-this-iter

*None.* No excuse-comments, no weakened-wrong definitions, no vacuous statements, no unauthorized axioms, no fake proof bodies.

---

## Major

- `FlatBaseChange.lean:184–246` — STATUS block in section header references iteration numbers **iter-234, iter-236, iter-240, iter-241** from the source project (Algebraic-Jacobian-Challenge). These do not correspond to any iteration of this project (Quot-Foundations, currently iter-011). A developer reading this file will be confused about what was done when. These are stale legacy development logs imported verbatim and should be pruned or relocated to a history/attribution note.

- `FlatBaseChange.lean:~1059` (docstring of `pushforward_base_change_mate_cancelBaseChange`) — The phrase "typed `sorry` below" mislocates the sorry dependency. The sorry this declaration depends on is in `base_change_mate_section_identity` at line 1011, which is **above** this declaration in the file. The body of `pushforward_base_change_mate_cancelBaseChange` contains no `sorry` directly, but it is transitively sorry-dependent via `base_change_mate_generator_trace → base_change_mate_section_identity`. A reader seeing "sorry below" may incorrectly conclude this function is sorry-free.

---

## Minor

- `GrassmannianCells.lean:32–44` — "Planner note:" block embedded in production source namespace. Development guidance for a prover agent; should live in blueprint or task_results, not in the formalized source.

- `FlatBaseChange.lean:566–569, 632–641` (proof body of `pushforward_spec_tilde_iso`) — Inline comments "iter-240 PIVOT (`algebraize`)" and "KEY INSIGHT (iter-241):" are legacy annotation from the source project. They reference iterations that do not exist in Quot-Foundations' history.

- `FlatteningStratification.lean:648–659` (NagataNormalization section header) — Comment "replays that construction over a noetherian *domain* (the field is used in Mathlib only to conclude the top coefficient is a unit…)" is accurate and helpful, but does not cite the specific Mathlib location (`Mathlib.RingTheory.NoetherNormalization`) so future maintenance cannot easily compare against upstream.

---

## Excuse-comments (always called out separately)

*None found.* No declaration carries a comment of the form "temporary wrong definition," "will fix later," "placeholder," or similar.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: All four files are mathematically honest — no weakened definitions, no vacuous statements, no fake proofs; the two major findings are documentation issues (stale legacy iteration numbers from source project, and a mislocated "sorry below" pointer) that should be cleaned up before the file's development narrative becomes fully entrenched.
