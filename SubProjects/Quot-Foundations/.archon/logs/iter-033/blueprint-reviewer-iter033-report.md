# Blueprint Reviewer Report — Iter 033

**Scope**: Whole-blueprint audit (all 6 chapters), HARD GATE check for named lanes.  
**leandag summary**: 313 blueprint nodes, 191 proved (leanok), 60 mathlib_ok, 12 with_sorry, 82 unmatched_lean, 4 isolated (3 lean_aux + 1 blueprint lemma), 653 edges.  
**blueprint-doctor**: 2 malformed `\uses{}` (empty argument) in `Cohomology_FlatBaseChange.tex`; 1 covers_problem (`FlatBaseChangeGlobal.lean` does not yet exist — expected); no orphan chapters; no broken refs; no axiom declarations.

---

## Chapter Reports

---

### Cohomology_RegroupHelper.tex

**Covers**: `AlgebraicJacobian/Cohomology/RegroupHelper.lean`  
**Complete**: YES  
**Correct**: YES  

Single lemma `lem:base_change_regroup_linearEquiv` — `\leanok` on both statement and proof. `\lean{AlgebraicGeometry.base_change_regroup_linearEquiv}`, `\uses{lem:isPushout_cancelBaseChange_mathlib}`. Source: Stacks Project, "boils down to the equality" step; citation complete. No issues.

---

### Cohomology_FlatBaseChange.tex

**Covers**: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` AND `AlgebraicJacobian/Cohomology/FlatBaseChangeGlobal.lean`  
**Complete**: PARTIAL — FBC-A is fully formalized; FBC-B chain is blueprinted but `FlatBaseChangeGlobal.lean` does not exist yet (expected for this iter).  
**Correct**: MOSTLY — two Mathlib anchor names need prover verification (see must-fix §M1).

#### FBC-A status (complete, all leanok)

All affine-local nodes through `lem:pushforward_base_change_mate_cancelBaseChange` and `lem:affine_base_change_pushforward` are leanok. The `_legs` crux nodes (`lem:base_change_mate_fstar_reindex_legs_link_cancelEUnit`, `_cancelPullbackComp`, `_survivor`) are the with_sorry targets for the FBC-A prover this iter — these are NOT in the FBC-B scope.

#### FBC-B chain (7 new blocks, lines 3091–3363)

The chain that feeds the FBC-B prover is:

| Block | Lean target | \mathlibok | \uses{} | Proof sketch | Status |
|---|---|---|---|---|---|
| `lem:flat_preserves_equalizer_mathlib` | `LinearMap.tensorEqLocusEquiv` | YES | — | clear | UNMATCHED (see §M1) |
| `lem:sheaf_equalizer_products_mathlib` | `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts` | YES | — | clear | UNMATCHED (see §M1) |
| `lem:finite_affine_cover_qcqs` | `AlgebraicGeometry.Scheme.exists_finite_affineCover_inter_isQuasiCompact` | — | empty (malformed, see §M2) | detailed | unformalized |
| `lem:gamma_finite_equalizer` | `AlgebraicGeometry.Modules.gammaIsLimitSheafConditionFork` | — | accurate | detailed | unformalized |
| `lem:base_changed_equalizer_diagram` | `AlgebraicGeometry.baseChange_sheafConditionFork_tensorIso` | — | accurate | detailed, source-quoted | unformalized |
| `lem:flat_base_change_separated` | `AlgebraicGeometry.flatBaseChange_pushforward_isIso_of_isSeparated` | — | accurate | detailed, source-quoted | unformalized |
| `lem:flat_base_change_mayer_vietoris` | `AlgebraicGeometry.flatBaseChange_pushforward_mayerVietoris` | — | accurate | detailed, source-quoted | unformalized |
| `lem:flat_base_change_reduce_global_sections` | `AlgebraicGeometry.flatBaseChange_isIso_iff_gammaTensorComparison` | — | accurate | detailed, source-quoted | unformalized |

`thm:flat_base_change_pushforward` — `\leanok` (exists, presumably with sorry pending the chain); its proof was rewritten as a short composite over the chain.

**Proof sketch quality**: All five project-local blocks have inline proofs that are detailed and mathematically correct. They are formalizable assuming the two Mathlib anchors resolve (see §M1). Source citations (Stacks Tag 02KH) with `% SOURCE QUOTE` blocks are complete on the source-using blocks.

**blueprint-doctor issues**: Two `\uses{}` with empty argument in this chapter — one is in `lem:finite_affine_cover_qcqs` (the lemma itself carries `\uses{}`), one in its proof block. These are minor lint warnings that do not break dependency tracking.

---

### Picard_FlatteningStratification.tex

**Covers**: `AlgebraicJacobian/Picard/FlatteningStratification.lean`  
**Complete**: YES for current scope (GF-alg completed, GF-geo fully documented)  
**Correct**: YES

**GF-alg phase (completed, iter 022)**: All dévissage blocks through the Nagata normalisation machinery are leanok. Mathlib anchors (`lem:noeth_prime_filtration`, `lem:fp_free_descent`, etc.) are in the unmatched_lean list — this reflects that their Lean declarations are expected Mathlib names but the LSP hasn't resolved them, which is consistent with the \mathlibok markers and no-leanok policy for external anchors.

**GF-geo phase (ACTIVE)**:

| Block | Lean target | Proof sketch | Status |
|---|---|---|---|
| `lem:gf_qcoh_fintype_finite_sections` | `AlgebraicGeometry.gf_qcoh_fintype_finite_sections` | detailed (Tag 01PB, finite-gen gluing criterion) | unformalized |
| `lem:gf_flat_locality_assembly` | `AlgebraicGeometry.gf_flat_locality_assembly` | detailed (flatness-is-local + localization) | unformalized |
| `thm:generic_flatness` | `AlgebraicGeometry.genericFlatness` | detailed (4-step from algebraic form); NOTE: `[QuasiCompact p]` hypothesis documented; Lean signature header recorded | with_sorry |

Source: Nitsure §4, source-quoted. Both bridge lemmas have `\uses{lem:qcoh_section_localization_basicOpen}` (G1 overlaps with gap1 qcoh infra — noted in LEAN STATUS comment). All three blocks are formalizable from the proof sketches.

---

### Picard_GrassmannianCells.tex

**Covers**: `AlgebraicJacobian/Picard/GrassmannianCells.lean`  
**Complete**: YES  
**Correct**: YES, with two sync_leanok notes (see §A1, §A2)

**GR-cells phase (completed, iter 012)**: All affine chart, transition map, and cocycle blocks are leanok.

**GR-glue phase (completed, iter 031)**: The full glue datum was landed in iter 031 per the NOTE in `def:gr_glued_scheme`. `def:gr_glued_scheme` has `\leanok` (line 1597).

**New coverage blocks (this iter)**:

**`lem:gr_separated`** (line 1706):
- `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` — well-formed
- `\uses{def:gr_glued_scheme, def:gr_transition}` — accurate
- Source: Nitsure §1 "Separatedness"; `% SOURCE:`, `% SOURCE QUOTE:`, `% SOURCE QUOTE PROOF:`, `\textit{Source: ...}` all present
- Proof sketch: complete and detailed — identifies the restricted diagonal with the ring map δ_{I,J} sending X^J → (X^I_J)^{-1}X^I, proves surjectivity by showing 1/P^I_J is in the image via the second component, and states the explicit matrix relation X^J_I X^I − X^J = 0. Sufficient for formalization.
- leandag: UNMATCHED (Lean declaration does not exist — correct, not yet formalized)
- **PASSES the scaffold+prove gate.**

**`lem:gr_proper`** (line 1777):
- `\lean{AlgebraicGeometry.Grassmannian.isProper}` — well-formed
- `\uses{def:gr_glued_scheme, lem:gr_separated}` — accurate
- Source: Nitsure §1 "Properness"; full source quote from nitsure-hilbert-quot.tex L865-L891
- Proof sketch: detailed valuative criterion argument — existence by choosing J minimising ν(f(P^I_J)), constructing g via θ_{I,J}, proving ν(g(x^J_{p,q})) ≥ 0 by cofactor expansion; uniqueness by separatedness. Sufficient for formalization.
- leandag: UNMATCHED (correct)

**Third new block**: The `section:gr_out_of_scope` section (lines 1897–1920) documents deferred items (tautological bundle, functor-of-points, relative version) — this is prose only, no formalization obligation.

**Sync_leanok advisory notes**:
- **§A1**: `def:gr_the_glue_data` (line 1560) lacks `\leanok` despite `theGlueData` being formalized per iter 031 NOTE. sync_leanok miss.
- **§A2**: `lem:gr_chartTransition'_cocycle` (line 1491) lacks `\leanok` on both statement and proof despite "Proved directly in Lean" text. sync_leanok miss.
- **§A3**: `lem:gr_awayMulCommEquiv_comp_awayInclLeft` (line 1348) lacks `\leanok` on statement despite "Proved directly in Lean." Another sync_leanok miss.

These are marker sync issues only — the underlying Lean declarations exist.

---

### Picard_QuotScheme.tex

**Covers**: `AlgebraicJacobian/Picard/QuotScheme.lean` AND `AlgebraicJacobian/Picard/GradedHilbertSerre.lean`  
**Complete**: YES for formalized scope; gap1 blocks documented and ready  
**Correct**: YES

**SNAP-S2 / QUOT-defs / subquotient induction (completed)**: All rational-Hilbert toolkit blocks, subquotient constructors, induction machinery, and support/freeness predicates are leanok.

**New coverage blocks (this iter, 3 blocks)**:

**`def:over_restrict_equiv`** (line 3025):
- `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictEquiv}` — leandag: NOT unmatched (declaration exists in Lean project)
- `\uses{}`: 5 deps (overEquivalence_sheafCongr, opens_overEquivalence, pushforwardPushforwardEquivalence, two continuity lemmas) — accurate
- Proof sketch: detailed — applies pushforwardPushforwardEquivalence to the opens site equivalence, with step-2 ring-sheaf identification collapsing to `rfl` by construction
- No `\leanok` (correct: new, awaiting sync_leanok)
- Formalizable: YES

**`lem:over_restrict_functor_iso`** (line 3065):
- `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictFunctorIso}` — leandag: NOT unmatched
- `\uses{def:over_restrict_equiv, lem:modules_restrictFunctor_mathlib, lem:opens_overEquivalence_mathlib}` — accurate
- Proof sketch: both sides are pushforwards along the same opens functor (composition law + pushforwardCongr)
- No `\leanok` (correct)
- Formalizable: YES

**`lem:over_restrict_pullback_iso`** (line 3189):
- `\lean{AlgebraicGeometry.Scheme.Modules.overRestrictPullbackIso}` — leandag: NOT unmatched
- `\uses{lem:over_restrict_iso, lem:modules_restrictFunctorIsoPullback_mathlib, lem:modules_pullback_mathlib}` — accurate
- Proof sketch: compose slice-to-geometric iso with restrictFunctorIsoPullback component — minimal and sufficient
- No `\leanok` (correct)
- Formalizable: YES

**P1 node: `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent`** (line 3221):
- `\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}` — leandag: UNMATCHED (declaration does not exist — correct, this is the P1 formalization target)
- `\uses{}`: 7 deps (over_restrict_iso, over_restrict_pullback_iso, presentation_map, quasicoherentData_bind, modules_pullback, isIso_fromTildeΓ_of_presentation, isLocalization_basicOpen + exists_finite_basicOpen_cover) — accurate, complete chain
- NOTE: "the pinned Lean decl does NOT yet exist; it is the per-element transport step of gap1"
- Proof sketch: 4-step transport — quasi-coherence datum → `QuasicoherentData.bind` to D(r) → push through bridge `lem:over_restrict_iso` → `Presentation.map` across affine identification → `isIso_fromTildeΓ_of_presentation` closes. Fully detailed.
- **PASSES the P1 prover gate.**

**Supporting gap1 infrastructure (not yet formalized)**:
- `lem:section_localization_descent` — `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen_descent}` — gap1 keystone; detailed proof (source: Stacks Properties §"Sections over principal opens", Tag referenced); unformalized
- `lem:qcoh_affine_isIso_fromTildeΓ` — unmatched; uses descent + equivalence
- `lem:isIso_fromTildeΓ_of_presentation_mathlib` — unmatched (\mathlibok anchor `AlgebraicGeometry.isIso_fromTildeΓ_of_presentation`)

**Isolated blueprint node**: `lem:annihilator_meets_nonZeroDivisors` (lean target `Submodule.annihilator_top_inter_nonZeroDivisors`) is isolated in the dependency graph with 0 uses and 0 impact. Its downstream consumer may have been renamed or not yet written. Advisory: check if this should be referenced by the annihilator-ideal sheaf characterization.

---

### Picard_RelativeSpec.tex

**Covers**: `AlgebraicJacobian/Picard/RelativeSpec.lean`  
**Complete**: YES  
**Correct**: YES (with encoding caveats noted in-file)

All blocks leanok. `thm:relative_spec_univ` and `thm:relative_spec_affine_base` carry NOTEs that the Lean type is weaker than the full Yoneda bijection / canonical iso — these are correctly flagged as in-file encoding decisions, not blueprint errors.

---

## Must-Fix This Iter

### §M1 — FBC-B Mathlib anchor names need prover verification (BLOCKING for FBC-B prover)

`lem:flat_preserves_equalizer_mathlib` pins `\lean{LinearMap.tensorEqLocusEquiv}` as a `\mathlibok` anchor. This name is **UNMATCHED** in leandag: the declaration does not appear in the imported Lean project. The chapter NOTE acknowledges it is "underlain by `Module.Flat.ker_lTensor_eq` and `Module.Flat.eqLocus_lTensor_eq`." The prover must:
1. Search Mathlib for the actual equalizer-preservation lemma for flat modules (candidates: `Module.Flat.eqLocus_lTensor_eq`, `LinearMap.lTensor_ker`, or similar)
2. Either cite the correct Mathlib name or derive `LinearMap.tensorEqLocusEquiv` as a project lemma

Similarly, `lem:sheaf_equalizer_products_mathlib` pins `\lean{TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts}` — also UNMATCHED. The prover should verify this name exists in current Mathlib or find the correct form.

**Impact**: If either anchor name is wrong, `lem:flat_base_change_separated` and `lem:flat_base_change_mayer_vietoris` lose their key flatness-commutes-with-equalizer input.

### §M2 — Empty `\uses{}` in FBC-B blocks (minor lint, SHOULD-FIX)

`lem:finite_affine_cover_qcqs` has an empty `\uses{}` tag in its statement and proof blocks. blueprint-doctor flags both as malformed. The block uses only Mathlib facts (affine basis, quasi-compactness, separation), so adding `\uses{}` annotations pointing to Mathlib anchors would improve traceability. For the prover this is advisory — the proof sketch is clear without them.

---

## Advisories (Non-Blocking)

### §A1–A3 — Missing \leanok markers in GrassmannianCells (sync_leanok should fix)
- `def:gr_the_glue_data` — formalized per iter 031 NOTE, lacks `\leanok`
- `lem:gr_chartTransition'_cocycle` — "Proved directly in Lean," lacks `\leanok` on statement and proof
- `lem:gr_awayMulCommEquiv_comp_awayInclLeft` — "Proved directly in Lean," lacks `\leanok` on statement
These are sync_leanok misses; no blueprint content fix needed.

### §A4 — GF-alg Mathlib anchors unmatched
Several GF-alg Mathlib anchors (`lem:noeth_prime_filtration`, `lem:fp_free_descent`, `lem:noether_normalization_fg`, etc.) appear in the unmatched_lean list. These are \mathlibok items whose Lean names may differ from current Mathlib. They are not blocking for this iter (GF-alg is completed), but the prover should verify the exact Mathlib names when the GF-geo prover lane opens.

### §A5 — Isolated blueprint node
`lem:annihilator_meets_nonZeroDivisors` is isolated (0 deps, 0 impact). Its downstream consumer has not been blueprinted yet or its \uses reference was lost. Not blocking this iter.

---

## HARD GATE Verdicts

### FBC chapter (covering FlatBaseChange.lean + FlatBaseChangeGlobal.lean)

**FBC-A prover lane**: PASSES. The `_legs` crux chain is complete and the section-level identity chain is all leanok.

**FBC-B prover lane**: CONDITIONAL PASS.
- The chain blueprint (7 blocks, lines 3091–3363) is present, sources are cited, proof sketches are detailed and formalizable.
- The prover must create `FlatBaseChangeGlobal.lean` (does not exist).
- **Mandatory prover action §M1**: verify the two Mathlib anchor names (`LinearMap.tensorEqLocusEquiv` and `TopCat.Presheaf.isSheaf_iff_isSheafEqualizerProducts`) before writing the chain. If either doesn't exist, find the correct Mathlib name or construct a project-level bridge.
- Subject to §M1 resolution, the FBC-B blueprint is complete enough to proceed. Dispatch the prover with the §M1 caveat flagged.

### Picard_QuotScheme.tex — P1 node prover lane

**PASSES.** `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` has a complete, detailed blueprint: well-formed `\lean{}` target, accurate 7-dep `\uses{}`, and a 4-step proof sketch that chains through the `over_restrict_iso` bridge. The three supporting `over_restrict` blocks are blueprinted and their Lean declarations already exist. Dispatch the P1 prover.

### Picard_GrassmannianCells.tex — scaffold+prove lane (`lem:gr_separated`)

**PASSES.** `lem:gr_separated` has a well-formed `\lean{}` target, accurate `\uses{}`, complete source citation (Nitsure §1), and a detailed proof sketch (ring-map surjectivity argument, matrix formula X^J_I X^I − X^J = 0). Dispatch the scaffold+prove agent.
