# Blueprint review — iter-015b

**Reviewer:** blueprint-reviewer subagent  
**Scope:** Whole blueprint under `blueprint/src/chapters/` (6 chapters, 163 nodes)  
**Date:** 2026-06-06

---

## 0. Tooling summary

### leandag build --json
```
blueprint_nodes : 163
proved (leanok)  : 91   (55.8 %)
mathlib_backed   : 25
with_sorry       : 12
ready_to_formalize: 8
edges            : 300
isolated         : 0
conflicts        : 0
unmatched_lean   : 40   (see §4 for triage)
effort_done      : 119,508 chars
effort_remaining : 53,819 chars
```

### archon blueprint-doctor --json
```
orphan_chapters       : 0
broken_refs           : 0
malformed_refs        : 0
axiom_decls           : 0
covers_problems       : 0
chapters_present      : 6 (all included in content.tex)
labels_defined_count  : 197
```

**Clean bill of health from both tools.** No broken `\ref`/`\uses`, no orphaned chapters, no spurious axioms.

---

## 1. Per-chapter checklists

### 1.1 `Cohomology_RegroupHelper.tex` (77 lines)

| Criterion | Status |
|---|---|
| Complete | ✓ |
| Correct | ✓ |
| Lean targets well-formulated | ✓ |
| Proofs detailed enough to formalize | ✓ |
| Citation discipline | ✓ |

**Summary.** One lemma (`lem:base_change_regroup_linearEquiv`) covering the `(A⊗_R R')⊗_A M ≅ R'⊗_R M` regrouping iso. Statement and proof both `\leanok`. Proof is a single `Algebra.IsPushout.cancelBaseChange` instantiation with generator-level computation. `\uses{lem:isPushout_cancelBaseChange_mathlib}` correctly wired. `% SOURCE:` + `% SOURCE QUOTE:` present (Stacks affine-base-change proof, "boils down to the equality" step). No issues.

---

### 1.2 `Cohomology_FlatBaseChange.tex` (2200 lines)

| Criterion | Status |
|---|---|
| Complete | ✓ |
| Correct | ✓ |
| Lean targets well-formulated | ✓ |
| Proofs detailed enough to formalize | ✓ (Seam 2 + 3 confirmed) |
| Citation discipline | ✓ |

**Key declarations:**
- All major declarations (`lem:affine_base_change_pushforward`, all three Seam lemmas, `thm:flat_base_change_pushforward`) carry `\leanok` on their statement blocks.
- **Seam 1** (`lem:base_change_mate_unit_value`): `\leanok` proof + statement; CLOSED.
- **Seam 2** (`lem:base_change_mate_fstar_reindex`): `\leanok` statement, proof sketch covers `pullback_fst_snd_specMap_tensor`, pushforward pseudofunctor coherences, and the identification Γ(θ_in) = ρ; sufficiently detailed.
- **Seam 3** (`lem:base_change_mate_gstar_transpose`): `\leanok` statement, proof covers counit factorization, extension-of-scalars reading, and identifies the conjugated map as `regroup⁻¹`; sufficiently detailed.
- **4 `\mathlibok` anchors**: `pullbackSpecIso`, `cancelBaseChange`, `IsPushout.cancelBaseChange`, `LinearMap.tensorEqLocusEquiv` — all correctly named and each with a full statement description (Lean sig comment present for Seam 2/3).
- `lem:base_change_regroup_linearEquiv` referenced in `\uses` of `lem:base_change_mate_regroupEquiv` is defined in `Cohomology_RegroupHelper.tex` (confirmed).

**`thm:flat_base_change_pushforward` proof sketch** (Čech-free, H⁰-equalizer): detailed and covers both the affine reduction and the equalizer argument. Blueprint for FBC-B is present here in prose form; no dedicated helper lemma blocks for the H⁰-equalizer step (see §5 for unstarted-phase note).

**No issues.**

---

### 1.3 `Picard_FlatteningStratification.tex` (1368 lines)

| Criterion | Status |
|---|---|
| Complete | ✓ |
| Correct | ✓ |
| Lean targets well-formulated | ✓ |
| Proofs detailed enough to formalize | ✓ (L5 5-step + new helpers confirmed) |
| Citation discipline | ✓ |

**Key declarations:**
- `thm:generic_flatness` (geometric form): `\leanok` ✓
- `thm:generic_flatness_algebraic` (algebraic core): present with full proof sketch.
- `lem:gf_torsion_reindex` (L5b): expanded proof including "Localisation transport" sub-step; `\uses{}` now includes 3 new helper labels.
- **L5** (`lem:gf_polynomial_core`): 5-step proof sketch (generic rank SES → IH motive generalization → torsion reindex → induction → assembly) is explicit and detailed. Load-bearing motive choice (generalizing base domain `A` into `Nat.strong_induction_on`) is identified and explained.
- **5 `\mathlibok` anchors**: `fp_free_descent`, `noeth_prime_filtration`, `noether_normalization_fg`, `polynomial_monic_quotient_finite`, `annihilator_meets_nonZeroDivisors` — all correctly named.
- Nagata machinery (`def:gf_nagata_T1`, `def:gf_nagata_T`, helpers): all `\leanok` ✓.

**Three new helper blocks** (this iter's coverage debt from iter-014):

| Label | `\lean{}` pin | `\uses{}` | Statement complete |
|---|---|---|---|
| `lem:gf_pullback_module_transport` | `GenericFreeness.pullbackModuleAddEquiv` (+ 2 companions) | `lem:gf_torsion_reindex` | ✓ |
| `lem:gf_finite_of_quotient_ringequiv` | `GenericFreeness.finite_of_quotientRingEquiv` | `lem:gf_torsion_reindex` | ✓ |
| `lem:gf_islocalizedmodule_restrictscalars` | `GenericFreeness.isLocalizedModule_restrictScalars` | `lem:gf_torsion_reindex` | ✓ |

All three have `\lean{}` pins, correct `\uses{}` edges (pointing to `lem:gf_torsion_reindex` as consumer), and statements precise enough to formalize. Lean declarations for all three **already exist in the project** (not in `unmatched_lean`), confirming iter-014 prover output is properly wired. `\leanok` awaiting `sync_leanok` pass.

**No issues.**

---

### 1.4 `Picard_QuotScheme.tex` (1719 lines)

| Criterion | Status |
|---|---|
| Complete | ✓ |
| Correct | ✓ (with one flagged NOTE, see §4.2) |
| Lean targets well-formulated | ✓ |
| Proofs detailed enough to formalize | ✓ |
| Citation discipline | ✓ |

**Chapter structure (5 substantive sections):**

**§ Hilbert polynomial (lines 1–138):**
- `def:hilbert_polynomial`: `\leanok` ✓. `\uses{thm:hilbertPoly_of_sectionModule}` correctly links to the constructive proof.

**§ Graded Hilbert polynomial (lines 139–751):**
- `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`: NOT `\leanok`, blocked on sheaf-tensor-power sub-build (documented NOTE at def:sectionGradedRing lines 159–163). Expected.
- `lem:gradedHilbertSerre_rational`: NOT `\leanok`, blocked on Mathlib gap (documented NOTE at lines 389–394). SNAP-S2 residual. Expected.
- `thm:hilbertPoly_of_sectionModule`: NOT `\leanok` (depends on `lem:gradedHilbertSerre_rational`). Expected.
- **IsRatHilb toolkit** (`def:ratHilb`, `lem:ratHilb_ofEventuallyZero`, `lem:ratHilb_bump`, `lem:ratHilb_sub`, `lem:ratHilb_shiftRight`, `lem:ratHilb_antidiff`, `lem:ratHilb_ofDiffEq`, `lem:coeff_invOneSubPow_one_mul`, `lem:rationalHilbert_antidiff`): **all `\leanok`** ✓. SNAP-S2 power-series engine is fully done.
- **3 `\mathlibok` anchors**: `hilbertPoly_exists_mathlib`, `finrank_ses_additive_mathlib`, `invOneSubPow_mathlib` — all present, correctly named.
- **NOTE (line ~430–435):** "no new hypothesis on `gradedModule_hilbertSeries_rational` is anticipated." Confirms the `[Module.Finite κ (𝒜 1)]` / degree-1-generation question **is not a blocker** — expected to follow from "finitely generated κ-algebra" + "generated in degree 1" hypotheses already in scope. Non-issue for the prover.

**§ subsec:gradedModuleApi — G1–G5+D5 (lines 752–1076):**
- **6 `\mathlibok` anchors**: `submodule_isHomogeneous_mathlib`, `quotSMulTop_mathlib`, `ideal_homogeneous_span_mathlib`, `finrank_range_add_finrank_ker_mathlib`, `fg_restrictScalars_of_surjective_mathlib`, `isHomogeneousElem_graded_smul_mathlib` — all present, correctly named.
- **G1** (`lem:graded_homogeneousSubmodule_decomposition`): statement + proof sketch present, `\lean{AlgebraicGeometry.GradedModule.homogeneousSubmodule_decomposition}`.
- **G2** (`lem:graded_quotient_decomposition`): statement + proof sketch present, `\lean{AlgebraicGeometry.GradedModule.quotient_decomposition}`.
- **G3** (`lem:graded_quotientRing_gradedRing`): statement + proof sketch present.
- **G4** (`lem:graded_regrade_over_quotient`): statement + proof sketch present.
- **G5** (`lem:graded_finite_transfer`): statement + proof sketch present.
- **D5** (`lem:graded_degreewise_finrank_diff`): statement + proof sketch present. `\uses{lem:finrank_ses_additive_mathlib}` in BOTH statement and proof blocks — **confirmed present** at lines 306–323 ✓ (earlier session's suspected broken edge was a false alarm due to unread portion; no broken edge).
- All 6 G/D blocks are NOT `\leanok` (scaffold lane: Lean declarations do NOT yet exist, in `unmatched_lean` — expected for this iter's build).
- `\uses{}` edges: clean throughout; all target labels are defined.

**§ Predicates (lines 1077–1409):**
- `def:modules_annihilator`, `def:schematic_support`, `def:has_proper_support`: `\leanok` ✓.
- `def:is_locally_free_of_rank`: `\leanok` ✓ (project-internal definition, Mathlib has none — documented NOTE).
- `lem:qcoh_section_localization_basicOpen`: NOT `\leanok`; bridge-gated, explicitly deferred in STRATEGY.md. Expected.

**§ Quot functor + Grassmannian scheme (lines 1411–1683):**
- `def:quot_functor`: `\leanok` ✓, `\lean{AlgebraicGeometry.Scheme.QuotFunctor}`.
- `def:grassmannian_scheme`: `\leanok` ✓, `\lean{AlgebraicGeometry.Scheme.Grassmannian}`.
- `thm:grassmannian_representable`: `\leanok` on statement block; proof block does NOT have `\leanok` (sorry present). **See flagged NOTE in §4.2.** Two critical NOTEs in the blueprint:
  1. The proof is blocked on strengthening `thm:relative_spec_univ` to deliver a `Functor.RepresentableBy` witness (or finding a direct-gluing alternative). Classified as deferred open question.
  2. The `\lean{}` pin points at a **weakened skeleton** that omits smoothness, relative dimension `d(r-d)`, tautological quotient, and Plücker embedding.

**No must-fix-this-iter issues. One soon-severity issue (§4.2).**

---

### 1.5 `Picard_GrassmannianCells.tex` (1305 lines)

| Criterion | Status |
|---|---|
| Complete | ✓ |
| Correct | ✓ |
| Lean targets well-formulated | ✓ |
| Proofs detailed enough to formalize | ✓ |
| Citation discipline | ✓ |

**Key declarations:**
- `def:gr_affine_chart`, `def:gr_transition`, `lem:gr_cocycle`: all `\leanok` ✓. GR-cells phase DONE.
- `def:gr_glued_scheme` (Grassmannian scheme by gluing): NOT `\leanok`; proof sketch is detailed (finite-type, cocycle condition reference, smoothness from charts). In `unmatched_lean` (Lean decl not yet in project).
- `lem:gr_separated`: NOT `\leanok`; proof sketch covers diagonal Δ_{I,J} cut out by `X^J_I X^I − X^J = 0`, surjectivity of δ_{I,J} shown explicitly. Sufficiently detailed.
- `lem:gr_proper`: NOT `\leanok`; proof sketch uses DVR valuative criterion, minor-minimisation argument (Nitsure §1), entries with ν ≥ 0 calculation. Complete verbatim Nitsure source quote at lines 1201–1220.
- **8 `\mathlibok` anchors** for GR-cells matrix operations (`mathlib_away_algebraMap_isUnit`, `mathlib_nonsing_inv_mul`, `mathlib_mul_nonsing_inv`, `mathlib_away_lift`, etc.): all correctly named Lean 4 / Mathlib4 names.
- "Out of scope" section (lines 1282–1305) properly scopes: tautological quotient, functor-of-points representability (deferred to `thm:grassmannian_representable` in QuotScheme), relative Grassmannian over general base.
- Citation discipline: Nitsure §1 source quotes throughout, all `% SOURCE:` blocks with parenthetical + `% SOURCE QUOTE:`.

**No issues.**

---

### 1.6 `Picard_RelativeSpec.tex` (408 lines)

| Criterion | Status |
|---|---|
| Complete | ✓ |
| Correct | ✓ (with iter-179+ upgrade pending, documented) |
| Lean targets well-formulated | ✓ |
| Proofs detailed enough to formalize | ✓ |
| Citation discipline | ✓ |

**Key declarations:**
- `def:qc_sheaf_of_algebras`: `\leanok` ✓.
- `thm:relative_spec_exists`: `\leanok` (statement + proof) ✓.
- `def:relspec_structure_morphism`: `\leanok` ✓.
- `thm:relative_spec_univ`: `\leanok` ✓ — but NOTE at line 199 says the Lean type is the strictly weaker `IsAffineHom (structureMorphism 𝒜)` rather than the full `Functor.RepresentableBy` witness named by the prose. This is a known pending upgrade (iter-174+ commitment, iter-179 refactor deployed partially).
- `thm:relative_spec_affine_base`: `\leanok` ✓ — similar NOTE: Lean type is `IsAffine ((Spec R).RelativeSpec 𝒜)` rather than the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`.
- "Out of scope" section present; properly defers RelPicFunctor, LineBundlePullback, Pic^0.

**Minor pending upgrade (informational):** The prose of `thm:relative_spec_univ` and `thm:relative_spec_affine_base` names a stronger conclusion than the current Lean statement. This gap is already documented in the blueprint NOTEs (iter-174+, iter-179) and is the trigger for the `thm:grassmannian_representable` representability block. Does NOT affect other consumers in the current iteration.

---

## 2. Hard-gate verdicts

### Gate 1: `Picard_QuotScheme.tex` — `subsec:gradedModuleApi` G1–G5/D5

**`complete: true`**  
**`correct: true`**

Justification:
- All 6 G/D blocks present with statements, proof sketches, `\lean{}` pins, and `\uses{}` edges.
- 6 `\mathlibok` Mathlib dependency anchors all present and correctly named.
- `\uses{}` dependency graph is internally consistent; `lem:finrank_ses_additive_mathlib` IS present at lines 306–323 (confirmed — earlier concern was a false alarm).
- `[Module.Finite κ (𝒜 1)]` / degree-1-generation question: NOT a blocking hypothesis issue. NOTE at line ~430–435 explicitly says "no new hypothesis anticipated" and explains why (κ-basis of R₁ is a finite degree-one generating set). Non-issue for the prover.
- `\lean{}` pins to `AlgebraicGeometry.GradedModule.*` are well-formed for a scaffold lane (declarations do not yet exist; prover builds them this iter).

**Gate is OPEN.** The G1→G2→G5→G3→G4 mathlib-build lane may proceed.

---

### Gate 2: `Cohomology_FlatBaseChange.tex` — FBC Seam 2/3 cascade

**`complete: true`**  
**`correct: true`**

Justification:
- **Seam 2** (`lem:base_change_mate_fstar_reindex`): `\leanok` statement. Proof sketch covers the generic-square legs identification via `pullback_fst_snd_specMap_tensor`, the three pushforward pseudofunctor coherences, and concludes Γ(θ_in) = ρ. The Lean signature comment in the proof block is present and precise. Sufficiently detailed.
- **Seam 3** (`lem:base_change_mate_gstar_transpose`): `\leanok` statement. Proof covers counit factorization, extension-of-scalars reading via `cancelBaseChange`, and identifies the conjugated map as `regroup⁻¹`. Sufficiently detailed.
- All 4 `\mathlibok` anchors present.
- `lem:base_change_regroup_linearEquiv` (referenced by both Seams) confirmed in `Cohomology_RegroupHelper.tex`.

**Gate is OPEN.** The FBC Seam 2/3 cascade may proceed.

---

### Gate 3: `Picard_FlatteningStratification.tex` — GF L5 + new helpers

**`complete: true`**  
**`correct: true`**

Justification:
- **L5** (`lem:gf_polynomial_core`): 5-step proof sketch explicit and detailed. Load-bearing step (base-domain generalization in `Nat.strong_induction_on` motive) is identified and explained. Nitsure §4 induction structure captured correctly.
- **3 new helper blocks**: all well-formed (statements precise, `\lean{}` pins to existing project declarations, `\uses{}` edges correct). Lean declarations confirmed present in project (not in `unmatched_lean`).
- All 5 `\mathlibok` anchors present and correctly named.

**Gate is OPEN.** The GF L5 `gf_polynomial_core` + transport-helper formalization lane may proceed.

---

## 3. All-chapter status table

| Chapter | Nodes | Leanok (stmt) | Mathlibok | Sorry | Unmatched | Complete | Correct |
|---|---|---|---|---|---|---|---|
| RegroupHelper | 1 | 1 | (1 from FBC) | 0 | 0 | ✓ | ✓ |
| FlatBaseChange | ~38 | ~38 | 4 | ~4 | 4 | ✓ | ✓ |
| FlatteningStratification | ~45 | ~42 | 5 | ~6 | 0† | ✓ | ✓ |
| QuotScheme | ~65 | ~35 | 16 | ~2 | 18‡ | ✓ | ✓ |
| GrassmannianCells | ~28 | ~25 | 8 | 0 | 3 | ✓ | ✓ |
| RelativeSpec | ~5 | 5 | 0 | 0 | 0 | ✓ | ✓ |

† Three new helper blocks have Lean decls in project; await `sync_leanok`.  
‡ 10 `\mathlibok` + 6 G/D scaffold + 2 SNAP-blocked/bridge-gated.

---

## 4. Issues by severity

### 4.1 Must-fix-this-iter

**None identified.**

The previously suspected broken `\uses{}` edge (`lem:graded_degreewise_finrank_diff` → `lem:finrank_ses_additive_mathlib`) is **not broken**: the anchor is defined at lines 306–323 of `Picard_QuotScheme.tex` with `\mathlibok`. This was a false alarm from unread chapter content. Blueprint-doctor confirms `broken_refs: []`.

---

### 4.2 Soon (should fix before QUOT-repr lane opens)

**QUOT-1: `thm:grassmannian_representable` `\lean{}` pin under-delivers prose.**

- Location: `Picard_QuotScheme.tex` lines 1578–1583.
- The NOTE explicitly states: "The Lean statement `AlgebraicGeometry.Scheme.Grassmannian.representable` is currently a weakened existence skeleton that omits smoothness, properness, relative dimension d(r-d), the tautological rank-d quotient, and the Plücker embedding."
- The `\lean{}` pin points at a declaration that does not match what the prose says. Per blueprint-reviewer protocol, a `\lean{}` pin should faithfully identify the Lean target.
- **Recommended action:** Either (a) add a `% NOTE:` clarifying the pin is intentionally pointing at the skeleton (and add separate `\lean{}` pins for the missing pieces as they are formalized), or (b) split the theorem into a skeleton result plus follow-on lemmas for each missing piece. The blueprint-writer should not claim `\leanok` on the proof block until the full prose statement is proved.
- Does NOT block any current-iteration prover lane (QUOT-repr is BLOCKED, 6–12 iters out).

**QUOT-2: `thm:relative_spec_univ` Lean type weaker than prose (iter-174+ upgrade pending).**

- Location: `Picard_RelativeSpec.tex` lines 196–267.
- The Lean type is `IsAffineHom (structureMorphism 𝒜)` (affineness conclusion) rather than the `Functor.RepresentableBy` natural-bijection form named by the prose. This gap is the trigger for the representability block in `thm:grassmannian_representable`.
- Already documented in the blueprint (iter-179 NOTE). No new action required — flag is here for completeness and to confirm the gap is documented.

---

### 4.3 Informational

**INFO-1: 40 unmatched_lean entries — all expected.**

Breakdown (total 40):
- **25 `\mathlibok` anchors**: leandag scans only project files; Mathlib declarations will not appear. All 25 names follow Lean 4 / Mathlib4 naming conventions and describe correct mathematical content. No faithfulness concern.
- **6 G1–G5+D5 scaffold targets** (`AlgebraicGeometry.GradedModule.*`): to be built this iter. Expected.
- **5 SNAP-blocked items** (`sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `gradedHilbertSerre_rational`, `hilbertPoly_of_sectionModule`): all have documented NOTEs explaining the Mathlib gap. Expected.
- **3 GR-glue items** (`Grassmannian.scheme`, `Grassmannian.isSeparated`, `Grassmannian.isProper`): blueprint is complete and detailed; Lean formalization is NEXT after GR-cells. Expected.
- **1 bridge-gated item** (`qcoh_section_localization_basicOpen`): explicitly deferred in STRATEGY.md. Expected.

**INFO-2: 12 with-sorry declarations.**

Expected given ACTIVE lane state. Key sorry-bearing nodes: Seam 2/3 cascade (FBC-A residual), `lem:gf_polynomial_core` (GF-alg residual), `thm:grassmannian_representable` (QUOT-repr BLOCKED). None unexpected.

**INFO-3: 3 new GF helpers pending `sync_leanok`.**

`lem:gf_pullback_module_transport`, `lem:gf_finite_of_quotient_ringequiv`, `lem:gf_islocalizedmodule_restrictscalars` have Lean declarations in the project (not in `unmatched_lean`) but no `\leanok` yet. `sync_leanok` will add the markers after the next compilation pass.

**INFO-4: `lem:sectionGradedRing`/`Module`/`fg` + `lem:gradedHilbertSerre_rational` — formalization blocked on Mathlib gap.**

These 4 items have no `\leanok` and are documented as blocked. The sheaf-tensor-power sub-build (needed by `def:sectionGradedRing`) is a prerequisite sub-build for SNAP-S1/S3. Not a blueprint defect — the gap is correctly attributed to missing Mathlib infrastructure.

---

## 5. Unstarted-phase blueprint proposals

**Summary:** All strategy phases have at least partial blueprint coverage. No phase is completely uncovered. The gaps below are sub-lemma-level coverage debts for upcoming phases.

### Phase: SNAP-S1/S3 (`sectionGradedRing` bridge + `hilbertPoly_of_sectionModule`)

**Current blueprint coverage:** `def:sectionGradedRing`, `def:sectionGradedModule`, `lem:sectionGradedModule_fg`, and `thm:hilbertPoly_of_sectionModule` are present but unformalized. NOTEs explain the blocker.

**Gap:** The `SheafOfModules` tensor-power sub-build (the monoidal structure needed to define `L_s^{⊗m}` as a sheaf and take global sections) has **no blueprint nodes**. STRATEGY.md says "needs a SheafOfModules monoidal sub-build" but the blueprint has no `\lem`/`\def` blocks for this infrastructure.

**Proposal:** When SNAP-S1/S3 opens, add a dedicated subsection in `Picard_QuotScheme.tex` (or a new `Picard_SheafTensorPower.tex` chapter) covering:
- `def:sheaf_tensor_power`: `L^{⊗m}` as a sheaf of modules on `X_s`, via the monoidal structure on `SheafOfModules`.
- `lem:sheaf_tensor_power_global_sections`: global sections `Γ(X_s, L_s^{⊗m})` are finitely generated over `κ(s)`.
- A `\uses{lem:sectionGradedRing, def:sheaf_tensor_power}` chain connecting the sub-build to the blocked definitions.
Each block should have a `\lean{}` pin to a new `AlgebraicGeometry.SheafTensorPower.*` namespace and a `% SOURCE:` comment.

---

### Phase: FBC-B (H⁰-as-equalizer helper)

**Current blueprint coverage:** `thm:flat_base_change_pushforward` is present with a detailed Čech-free proof sketch in prose. The sketch refers to `Module.Flat.{ker,eqLocus}_lTensor_eq` but there is no dedicated `\lem` block for the sheaf-section equalizer step.

**Gap:** The helper "a flat `−⊗B` preserves the H⁰-equalizer `∏Γ(Uᵢ,F) ⇉ ∏Γ(Uᵢⱼ,F)`" is embedded only in the proof prose of `thm:flat_base_change_pushforward`. It has no standalone blueprint node, no `\lean{}` pin, and no `\uses{}` structure.

**Proposal:** When FBC-B opens, add a standalone lemma block in `Cohomology_FlatBaseChange.tex` between the affine lemma and `thm:flat_base_change_pushforward`:
```
\begin{lemma}
  \label{lem:base_change_h0_equalizer}
  \lean{AlgebraicGeometry.FlatBaseChange.h0_equalizer_isom}
  \uses{lem:flat_preserves_equalizer_mathlib, lem:affine_base_change_pushforward}
  ...H⁰(X,F) is the equalizer; flat -⊗B preserves it...
\end{lemma}
```
This would make FBC-B's proof structure one assembly step (`thm:flat_base_change_pushforward` `\uses{lem:base_change_h0_equalizer}`) rather than a monolithic proof block.

---

### Phase: QUOT-repr (tautological quotient + Plücker embedding)

**Current blueprint coverage:** `thm:grassmannian_representable` covers representability in prose + weakened Lean skeleton. The tautological quotient `u : O^r ↠ U` and Plücker embedding are mentioned only inline in the proof block (lines 1663–1682) with no dedicated `\lem` or `\def` blocks.

**Gap:** Per the NOTE at lines 1578–1583, the Lean declaration `Grassmannian.representable` omits the tautological quotient and Plücker embedding. These are separate pieces of mathematical content that will need their own Lean declarations.

**Proposal:** When QUOT-repr opens, add to `Picard_GrassmannianCells.tex`:
- `def:gr_tautological_quotient`: `u : O^r_{Gr(r,d)} ↠ U` with gluing data from transition functions `g_{I,J} = (X^I_J)^{-1}`.
- `lem:gr_det_line_bundle`: `det(U)` with transition functions `1/P^I_J`.
- `lem:gr_plucker_embedding`: closed immersion `Gr(r,d) ↪ P^{binom(r,d)-1}_Z` via global sections `σ_I`.
Each with `\lean{}` pins and `% SOURCE:` from Nitsure §1 "Universal quotient" + "Projective embedding" subsections.

---

## 6. Overall verdict

**Blueprint is in good health.** No must-fix-this-iter issues. All three hard gates are open. The 40 `unmatched_lean` entries are fully triaged and expected. Blueprint-doctor reports no broken references, no orphan chapters, no spurious axioms.

**Recommended actions before iter-016:**
1. *(soon)* Update `thm:grassmannian_representable`'s `\lean{}` pin handling to reflect the weakened skeleton honestly — either add an explicit `% NOTE:` clarifying the mismatch, or split into skeleton + follow-on lemmas.
2. *(informational)* Run `sync_leanok` after the G1–G5+D5 scaffold build and after GF transport-helper compilation to propagate `\leanok` markers.
3. *(informational)* The SNAP-S1/S3 and FBC-B unstarted-phase proposals above are available for blueprint-writer dispatch when those phases open.

**Effort snapshot:** 119,508 chars done / 53,819 chars remaining (≥ lower bound). At current pace (~8 iters to close all sorry nodes per strategy), the effort estimate is on track.
