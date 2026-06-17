# Blueprint Review — iter-026

**Reviewer**: blueprint-reviewer subagent  
**Date**: 2026-06-07  
**Scope**: Whole-blueprint audit + HARD-GATE verdicts for three chapters under prover dispatch

---

## Quick-reference: HARD-GATE verdicts

| Chapter | Complete | Correct | Verdict |
|---------|----------|---------|---------|
| `Cohomology_FlatBaseChange.tex` | YES | YES | **PASS** — dispatch unblocked |
| `Picard_QuotScheme.tex` | PARTIAL | YES | **CONDITIONAL** — two coverage-debt lemmas dispatchable; gap1 needs sketch fix first |
| `Picard_GrassmannianCells.tex` | PARTIAL | YES | **PASS for dispatch** — must build three Lean decls this iter |

---

## Chapter-by-chapter checklist

### 1. `Cohomology_RegroupHelper.tex`

| Item | Status |
|------|--------|
| All declarations leanok | YES — `lem:base_change_regroup_linearEquiv` leanok |
| All `\uses{}` resolvable | YES — `lem:isPushout_cancelBaseChange_mathlib` (mathlibok) |
| Open sorrys | 0 |
| Broken refs | 0 (confirmed by blueprint-doctor) |

**Verdict**: complete + correct. No action needed.

---

### 2. `Cohomology_FlatBaseChange.tex` ← HARD-GATE #1

| Item | Status |
|------|--------|
| All declarations leanok | YES — every lemma through `thm:flat_base_change_pushforward` carries `\leanok` |
| Three atomic cancel lemmas (A-2a/b/c) | YES — all leanok: `lem:base_change_mate_inner_eCancel_eUnit`, `_pushforwardComp`, `_pullbackComp` |
| Assembly node `lem:base_change_mate_inner_eCancel` | YES — leanok |
| Top-level `lem:base_change_mate_inner_value_eq` | YES — leanok |
| "Order of operations" paragraph (iter-024 must-fix) | YES — present at lines 2244–2259 |
| FBC terminal theorem | YES — `thm:flat_base_change_pushforward` leanok |
| Open sorrys | 0 |

**HARD-GATE focus — "Order of operations (load-bearing)" paragraph**:

The paragraph resolves the iter-024 must-fix completely. It gives the prover two formalizable routes:

1. **Primary route**: "distribute the unit on the free composite [e^hom ∘ Spec ιA] first — before the generic-square legs (g', f') are identified with the concrete pullback projections (pr_1, pr_2). Distributing first keeps each of the four factors in the free a∘b shape against which the three atoms are stated. Hence: distribute the unit on the free composite first; cancel with the three atoms; then read through `lem:base_change_mate_codomain_read`."

2. **Fallback route**: "if the free composite is no longer accessible, target the locked factor by its position in the composite (a congruence at that occurrence) rather than by matching its head symbol."

Both routes are concrete and formalizable. The fallback explicitly solves the literal-form lock by positional congruence rather than head-symbol matching. The iter-024 must-fix is **resolved**.

**Verdict**: PASS — complete + correct. Prover dispatch unblocked.

---

### 3. `Picard_FlatteningStratification.tex`

| Item | Status |
|------|--------|
| Algebraic core (`thm:generic_flatness_algebraic`) | Lean decl exists (axiom-clean aside from L5 sorrys) |
| L1–L4 dévissage chain | leanok |
| `lem:gf_torsion_reindex` | NO leanok — OreLocalization instance mismatch (not missing math) |
| `lem:gf_polynomial_core` | NO leanok — same OreLocalization blocker |
| G1 bridge `lem:gf_qcoh_fintype_finite_sections` | NO leanok — mathlib-build target |
| G3 bridge `lem:gf_flat_locality_assembly` | NO leanok — stub-level proof sketch |
| `thm:generic_flatness` (geometric) | NO leanok — gated on G1 + G3 |

**Must-fix ongoing (carry forward)**:
- L5 sorry in `lem:gf_torsion_reindex` / `lem:gf_polynomial_core`: root cause is OreLocalization instance presentation mismatch. Blueprint NOTE correctly identifies the fix as non-local (make the conclusion emit over canonical OreLocalization instances). Action: OreLocalization alignment, then close.
- G1 (`lem:gf_qcoh_fintype_finite_sections`) and G3 (`lem:gf_flat_locality_assembly`): neither has an axiom-clean Lean decl. G1 is a mathlib-build target (proof sketch: local finite generation on affine open). G3 proof sketch is stub-level ("per-patch freeness → flatness assembly") without naming Mathlib APIs.

**Verdict**: partially complete. Algebraic core is progressed. Geometric theorem remains gated. Not under prover dispatch this iter.

---

### 4. `Picard_QuotScheme.tex` ← HARD-GATE #2

| Item | Status |
|------|--------|
| Hilbert polynomial / IsRatHilb toolkit | leanok through `lem:graded_subquotient_isRatHilb` |
| Ambient subquotient API | leanok |
| `lem:gradedHilbertSerre_rational` | leanok — axiom-clean |
| `def:modules_annihilator`, `lem:annihilator_localization_eq_map` | leanok |
| `lem:qcoh_section_localization_basicOpen` | NO leanok — Lean decl not yet built for general X |
| `lem:isLocalizedModule_tilde_restrict` | NO `\leanok` in tex; directive confirms axiom-clean Lean decl exists — sync_leanok should add marker |
| `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` | NO `\leanok` in tex; directive confirms axiom-clean Lean decl exists — sync_leanok should add marker |
| `lem:qcoh_affine_isIso_fromTildeΓ` (gap1) | NO leanok — Lean decl NOT yet built |
| `def:schematic_support`, `def:has_proper_support`, `def:quot_functor` | leanok |
| `def:is_locally_free_of_rank` | leanok — NOTE: "Mathlib does not provide this predicate" |
| `thm:grassmannian_representable` | leanok marker present — but see must-fix below |

**HARD-GATE focus — three new blocks after `lem:qcoh_section_localization_basicOpen`**:

**Block 1: `lem:isLocalizedModule_tilde_restrict`**  
Coverage-debt entry for the Spec-local core. The tex statement block (lines 2541–2556) carries `\lean{AlgebraicGeometry.isLocalizedModule_tilde_restrict}` but no `\leanok` marker. Directive confirms the Lean decl is axiom-clean. This is a sync_leanok issue — the marker should be present after next sync. Proof sketch is complete and correct (3 lines: Mathlib supplies the tilde.toOpen instance; precompose with inverse of top-section iso via `IsLocalizedModule.of_linearEquiv_right`).

**Block 2: `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`**  
Coverage-debt entry. No `\leanok` marker in tex; directive confirms axiom-clean Lean decl. Proof sketch (lines 2580–2589) is complete: naturality square of ψ intertwines restriction maps of M̃(N) and M; transport `lem:isLocalizedModule_tilde_restrict` across the two component isos. Formalizable. sync_leanok issue.

**Block 3: `lem:qcoh_affine_isIso_fromTildeΓ` (gap1)**  
*This is the keystone's missing descent ingredient.* The Lean decl `isIso_fromTildeΓ_of_isQuasicoherent` does NOT yet exist. The proof sketch (lines 2613–2625) is:
1. Apply Mathlib's `isIso_fromTildeΓ_of_presentation` (correct Mathlib hook — exists at pinned commit).
2. Quasi-coherence provides local presentations of M on a cover of Spec R by basic opens.
3. Spec R is qcqs → pass to finite subcover.
4. "Take global sections to obtain a generating family and a relation module over R, and rebuild the presentation globally as the tilde(-)-image of an R-module free presentation."
5. Apply `isIso_fromTildeΓ_of_presentation`.

**Assessment — is the globalization step specified well enough?** PARTIALLY. The sketch:
- Names the correct Mathlib hook at both ends ✓
- Correctly identifies quasi-compactness as the key property ✓
- States the mathematical plan correctly ✓
- **Hand-waves the globalization**: step 4 ("take global sections to obtain a generating family") does not name which Mathlib API translates `IsQuasicoherent` into local presentations (what type/structure does `IsQuasicoherent` yield in Lean?), nor does it specify how to extract global generators from finitely many basic-open patches. This is the "hard direction" the NOTE itself acknowledges, and it is exactly where a mathlib-build prover could get stuck without further guidance.

**Must-fix for gap1 before prover dispatch**: the sketch must be extended to name (a) which Mathlib definition or lemma is invoked to extract local presentations from `IsQuasicoherent` (e.g., whether `IsQuasicoherent` in Mathlib directly gives local free resolutions, or whether it only gives local iso with a tilde sheaf), and (b) the concrete Lean construction that assembles local sections into a global relation: is it `Finsupp.supported_eq_span_single_image`, `Submodule.span_iUnion`, or something else in the `Scheme.Modules` namespace?

**`\uses{}` accuracy for `lem:qcoh_section_localization_basicOpen`**: the three new blocks are correctly listed in its \uses{}: `lem:isLocalizedModule_tilde_restrict`, `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ`, `lem:qcoh_affine_isIso_fromTildeΓ`. The logical dependency chain is accurate.

**Additional must-fix: `thm:grassmannian_representable` leanok discrepancy**  
The blueprint carries `\leanok` (lines 2897) for `thm:grassmannian_representable`, but the NOTE (lines 2905–2916) explicitly states: "The Lean statement `AlgebraicGeometry.Scheme.Grassmannian.representable` is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding." The leanok marker was auto-set by sync_leanok (a sorry-present declaration counts), but the prose statement is substantially richer than what the Lean decl delivers. This is a prose-vs-lean alignment issue. Action: either (a) split the prose into a proved skeleton + separately marked goals for the omitted content, or (b) add a `% NOTE:` flagging the scope gap explicitly in the statement block (the NOTE currently appears only in the proof block).

**Verdict**: CONDITIONAL — coverage-debt lemmas (blocks 1+2) are dispatchable (axiom-clean decls exist, sync_leanok will add markers); gap1 (block 3) needs proof-sketch strengthening before mathlib-build prover dispatch; `thm:grassmannian_representable` leanok discrepancy must be resolved.

---

### 5. `Picard_GrassmannianCells.tex` ← HARD-GATE #3

| Item | Status |
|------|--------|
| `def:gr_affine_chart`, `def:gr_universal_matrix`, `def:gr_minor_det` | leanok |
| `def:gr_universal_minor`, `def:gr_universalMinorInv`, `def:gr_image_matrix` | leanok |
| `def:gr_transition_pre`, `def:gr_transition` | leanok |
| Matrix helpers (`lem:gr_mul_submatrix_col`, `lem:gr_map_nonsing_inv`, etc.) | leanok |
| Triple-overlap rings and localized transition maps | leanok |
| `lem:gr_cocycle` | leanok — full cocycle condition proved in Lean |
| `def:gr_glued_scheme` | NO leanok — Lean decl not yet built |
| `lem:gr_separated` | NO leanok — Lean decl not yet built |
| `lem:gr_proper` | NO leanok — Lean decl not yet built |

**HARD-GATE focus — `def:gr_glued_scheme`**:

All gluing prerequisites are formalized:
- Charts U^I via `def:gr_affine_chart` (leanok) — U^I ≅ A^{d(r-d)}
- Overlap localizations via `def:gr_minor_det` (leanok) — U^I_J = D(det X^I_J)
- Transition isomorphisms via `def:gr_transition` (leanok) — θ_{I,J}: U^I_J → U^J_I
- Cocycle condition via `lem:gr_cocycle` (leanok) — θ_{I,K} = θ_{I,J} ∘ θ_{J,K}

The blueprint statement (lines 1045–1086) specifies: glue the {U^I} (finitely many affines) along the θ_{I,J}, yielding a finite-type Z-scheme; smoothness proven via each chart being A^{d(r-d)}. The `\uses{def:gr_affine_chart, def:gr_transition, lem:gr_cocycle}` is accurate and complete.

**Minor gap**: the blueprint does not name the Lean gluing API (`AlgebraicGeometry.Scheme.GlueData` or equivalent). The prover should be directed to search Mathlib for the appropriate gluing construction. This is a minor gap — the mathematical inputs are fully specified; only the API name is missing.

**`lem:gr_separated`**: proof sketch (lines 1091–1157) gives the explicit matrix equation X^J_I X^I - X^J = 0 defining the diagonal, and establishes surjectivity of δ_{I,J} via concrete formula. Adequate for a Lean prover.

**`lem:gr_proper`**: proof sketch (lines 1162–1280) gives the DVR valuative criterion: choose J minimizing ν(f(P^I_J)); on U^J all entries have non-negative valuation; unique extension to Spec R follows. The J-minimality argument is concrete and reproducible in Lean. Adequate.

**Verdict**: PASS for prover dispatch — proof sketches are detailed enough to build the three missing decls. All three Lean decls must be built this iter.

---

### 6. `Picard_RelativeSpec.tex`

| Item | Status |
|------|--------|
| `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism` | leanok |
| `thm:relative_spec_univ`, `thm:relative_spec_affine_base` | leanok |
| Prose-vs-lean alignment | NOTE: Lean form of `thm:relative_spec_univ` is weaker than prose (IsAffineHom not full Yoneda-bijection) |

**Verdict**: complete as formalizable; correct with noted scope limitation. No action needed this iter.

---

## Must-fix-this-iter

1. **`lem:qcoh_affine_isIso_fromTildeΓ` proof sketch (gap1) — QuotScheme.tex**  
   Extend the globalization step to name: (a) the Lean API for extracting local presentations from `IsQuasicoherent` (what does `IsQuasicoherent` provide in Mathlib at the pinned commit — a local-iso-with-tilde property, or explicit free resolutions?), and (b) the assembly construction mapping local generators to a global R-module presentation. Without this, a mathlib-build prover cannot proceed past the quasi-compact cover step.

2. **`lem:isLocalizedModule_tilde_restrict` and `lem:isLocalizedModule_restrict_of_isIso_fromTildeΓ` — `\leanok` markers missing**  
   Directive confirms axiom-clean Lean decls exist. The markers should appear after the next sync_leanok run. Verify that `lake build` on the relevant module produces no errors (the markers may have been omitted due to a build issue). If sync_leanok confirms clean, no action; otherwise, diagnose the build failure.

3. **`thm:grassmannian_representable` scope mismatch — QuotScheme.tex**  
   The leanok marker is present but the Lean decl is a "weakened existence skeleton" missing smoothness, properness, relative dimension, tautological quotient, and Plücker embedding. Add a `% NOTE:` in the statement block (not just the proof block) so the prose-vs-lean gap is visible to sync_leanok and the review agent. Consider splitting into a proved skeleton `thm:grassmannian_representable_skeleton` and separately marked goals.

4. **`def:gr_glued_scheme` — name the Lean gluing API — GrassmannianCells.tex**  
   Minor: add a `% NOTE:` or prose hint identifying the Mathlib gluing construction (`AlgebraicGeometry.Scheme.GlueData` or equivalent) so the prover doesn't have to search. Low priority; the mathematical inputs are complete.

---

## Unstarted-phase blueprint proposals

The following strategy phases lack blueprint coverage or have stub-only entries:

1. **Generic flatness geometric bridges (G1 + G3) — FlatteningStratification.tex**  
   `lem:gf_qcoh_fintype_finite_sections` (G1) and `lem:gf_flat_locality_assembly` (G3) are both stub-level or mathlib-build targets with no axiom-clean Lean decls. The geometric theorem `thm:generic_flatness` is gated on both. G3 proof sketch is too thin to hand to a mathlib-build prover (names the goal but not the Mathlib API path).  
   **Proposal**: in the next plan iter, assign a mathlib-build prover to G1 with a concrete route (local finite generation on affine open → `Scheme.Modules.sections_finite_of_isQuasicoherent_of_isFiniteType` or equivalent). Expand the G3 sketch to name the flatness-assembly lemma in Mathlib.

2. **`thm:relative_spec_univ` strengthening — RelativeSpec.tex**  
   The Lean form is weaker than prose (IsAffineHom, not Functor.RepresentableBy). This blocks the `thm:grassmannian_representable` proof path (a). A RepresentableBy-free approach (path b: direct gluing of chart-wise classifying morphisms) is mentioned as an alternative but not yet sketched.  
   **Proposal**: blueprint the RepresentableBy-free approach for representability of the Grassmannian, resolving the NOTE in `thm:grassmannian_representable` without requiring a stronger `thm:relative_spec_univ`.

3. **OreLocalization instance alignment — FlatteningStratification.tex**  
   The L5 sorrys in `lem:gf_torsion_reindex` and `lem:gf_polynomial_core` are not missing math; they are a non-local Lean infrastructure fix (making torsion_reindex emit its conclusion over canonical OreLocalization instances rather than the constructed one). This is not reflected in the blueprint as a dedicated sub-task.  
   **Proposal**: add a blueprint note or task for the OreLocalization alignment refactor so the prover targeting L5 has an explicit action item rather than a vague "instance presentation mismatch."
