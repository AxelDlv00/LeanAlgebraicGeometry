# Blueprint Reviewer Report — iter034b (HARD GATE, whole-blueprint audit)

**Date:** 2026-06-08  
**Reviewer:** blueprint-reviewer subagent  
**Scope:** All six chapters under `blueprint/src/chapters/*.tex`  
**Method:** Full sequential read of all chapter files; manual audit of `\lean{}` pins,
`\uses{}` dependency edges, mathematical coherence, and proof-prose fidelity.

---

## Gate Verdicts (executive summary)

| Lane | Chapter | Gate verdict |
|------|---------|-------------|
| FBC-A (conjugate re-encoding) | `Cohomology_FlatBaseChange.tex` | **CLEAR** |
| FBC-B (H⁰-as-equalizer chain) | `Cohomology_FlatBaseChange.tex` | **CLEAR** |
| QUOT P1 (3 new blocks + keystone) | `Picard_QuotScheme.tex` | **CLEAR** |
| GR-glue separated | `Picard_GrassmannianCells.tex` | **CLEAR** |

All four prover lanes are approved to run. No chapter requires a blocking fix before
dispatch.

---

## Chapter Audits

### 1. `Cohomology_FlatBaseChange.tex`

**Covers:** `FlatBaseChange.lean` + `FlatBaseChangeGlobal.lean`  
**complete:** true  
**correct:** true

#### FBC-A lane: conjugate-side re-encoding

Key blocks audited:

| Block | `\lean{}` pin | Status |
|-------|--------------|--------|
| `lem:base_change_mate_section_identity` | `AlgebraicGeometry.baseChange_mate_id` | `\leanok` |
| `lem:base_change_mate_generator_trace` | `AlgebraicGeometry.baseChange_mate_generator_trace` | `\leanok` |
| `lem:pushforward_base_change_mate_cancelBaseChange` | (project decl) | `\leanok` |
| `lem:affine_base_change_pushforward` | (project decl) | `\leanok` |
| `thm:flat_base_change_pushforward` | (project decl) | `\leanok` |

The conjugate-side re-encoding for `lem:base_change_mate_codomain_read_legs` and
`lem:base_change_mate_fstar_reindex_legs` is mathematically coherent. The `_legs`
coherence is expressed as a `conjugateEquiv`-component identity via
`leftAdjointCompIso + conjugateEquiv.injective`, with no positional-rewrite dependence.
The approach avoids naturality-square arithmetic and is directly formalizable.

`\uses{}` chains are well-formed throughout; no broken or circular edges found.

**FBC-A gate: CLEAR.**

#### FBC-B lane: H⁰-as-equalizer chain

| Block | `\lean{}` pin | Status |
|-------|--------------|--------|
| `lem:flat_preserves_equalizer_mathlib` | `LinearMap.tensorEqLocusEquiv` | `\mathlibok` |
| `lem:gamma_finite_equalizer` | (project decl) | `\leanok` |
| `lem:gamma_finite_equalizer_cover` | (project decl) | `\leanok` |
| `lem:gamma_amodule_restriction` | `AlgebraicGeometry.Modules.gammaCoverRestrictScalars` | build-ahead (no `\leanok`) |
| `lem:gamma_alinear_res_maps` | `AlgebraicGeometry.Modules.gammaCoverResMapsALinear` | build-ahead |
| `lem:gamma_eqLocus_iso` | `AlgebraicGeometry.Modules.gammaEqLocusIso` | build-ahead |
| `lem:base_changed_equalizer_diagram` | `AlgebraicGeometry.baseChange_sheafConditionFork_tensorIso` | build-ahead |
| `lem:flat_base_change_separated` | `AlgebraicGeometry.flatBaseChange_pushforward_isIso_of_isSeparated` | build-ahead |
| `lem:flat_base_change_mayer_vietoris` | `AlgebraicGeometry.flatBaseChange_pushforward_mayerVietoris` | build-ahead |
| `lem:flat_base_change_reduce_global_sections` | `AlgebraicGeometry.flatBaseChange_isIso_iff_gammaTensorComparison` | build-ahead |

The `\lean{LinearMap.tensorEqLocusEquiv}` pin on `lem:flat_preserves_equalizer_mathlib`
names a real Mathlib declaration in `Mathlib.RingTheory.Flat.Equalizer` (confirmed via
loogle in prior session). The `\mathlibok` marker is correctly applied.

The build-ahead blocks (no `\leanok`) are correctly scaffolded as future targets, not
defects. The FBC-B equalizer chain from `lem:gamma_finite_equalizer_cover` through to
`lem:flat_base_change_reduce_global_sections` is mathematically coherent.

`\uses{}` chains are well-formed throughout.

**FBC-B gate: CLEAR.**

---

### 2. `Picard_QuotScheme.tex`

**Covers:** `QuotScheme.lean` + `GradedHilbertSerre.lean`  
**complete:** true  
**correct:** true

#### Graded Hilbert–Serre layer (lines 1–2899, reviewed in full)

The Hilbert polynomial, ambient subquotient induction, and all Graded Hilbert–Serre
sub-lemmas are heavily `\leanok`. The Mathlib anchors (`lem:opens_overEquivalence_mathlib`,
`lem:equivalence_sheafCongr_mathlib`, `lem:pushforwardPushforwardEquivalence_mathlib`)
are correctly pinned with `\mathlibok`. The support/freeness predicates section and the
over-site bridge infrastructure (C, steps 1–4') are all `\leanok`.

#### Three new P1 coverage blocks (lines 3229–3317)

| Block | `\lean{}` pin | `\uses{}` | Status |
|-------|--------------|----------|--------|
| `def:over_restrict_unit_iso` | `AlgebraicGeometry.Scheme.Modules.overRestrictUnitIso` | `def:over_restrict_equiv` | present, no `\leanok` (build target) |
| `def:over_restrict_presentation` | `AlgebraicGeometry.Scheme.Modules.overRestrictPresentation` | `def:over_restrict_unit_iso`, `lem:over_restrict_pullback_iso`, `lem:presentation_map_mathlib` | present, no `\leanok` |
| `def:presentation_pullback_iota_of_quasicoherentData` | `AlgebraicGeometry.Scheme.Modules.presentationPullbackιOfQuasicoherentData` | `def:over_restrict_presentation`, `lem:quasicoherentData_bind_mathlib` | present, no `\leanok` |

**Mathematical correctness:**

- `def:over_restrict_unit_iso`: The step-3 slice equivalence functor preserves the unit
  module. Proof routes through `isIso_unitToPushforwardObjUnit_of_isIso'` with the
  identity ring comparison `ψ₀ = homMk(1)`. Correct and formalizable (the `IsIso ψ`-driven
  form is the canonical approach for this slice construction, consistent with prior gap1
  bridge work).

- `def:over_restrict_presentation`: Applies `Presentation.map` along the step-3
  equivalence functor (using `def:over_restrict_unit_iso` to identify the unit image),
  then `Presentation.ofIsIso` across the pullback packaging isomorphism
  `lem:over_restrict_pullback_iso`. Chain is correct and tight.

- `def:presentation_pullback_iota_of_quasicoherentData`: Extracts the per-member slice
  presentation from quasi-coherence data and feeds it to `def:over_restrict_presentation`.
  Straightforward wrapper; correct.

#### P1 keystone `lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (lines 3321–3364)

```
\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_restrict_basicOpen}
```

The `\lean{}` pin names a decl that does NOT yet exist in Lean — this is expected and
correctly noted in the `% NOTE:` comment. It is this iter's build target.

**Mathematical correctness:** The proof chain is:
1. Quasi-coherence datum → slice presentation on cover member q.Xᵢ
2. `QuasicoherentData.bind` + `Presentation.map` → presentation of M.over(D(r))
3. Slice-to-geometric bridge `lem:over_restrict_iso` → geometric restriction presentation
4. Affine identification D(r) ≅ Spec R_r (`lem:isLocalization_basicOpen_mathlib`) +
   `Presentation.map` along pullback functor → global presentation of M|_{D(r)} on Spec R_r
5. `lem:isIso_fromTildeΓ_of_presentation_mathlib` → `IsIso((M|_{D(r)}).fromTildeΓ)`

All five steps are logically correct. The `\uses{}` edges in the proof block correctly
list `def:over_restrict_presentation` and `def:presentation_pullback_iota_of_quasicoherentData`.

**Minor issue (non-blocking):** `lem:exists_finite_basicOpen_cover_le_quasicoherentData`
appears in the statement `\uses{}` (correct, since D(r) ≤ q.Xᵢ is part of the hypothesis)
but is not listed in the proof `\uses{}` even though the proof text references it
explicitly. This creates a small DAG asymmetry. Not blocking; no broken edge, just a
missing backward pointer in the proof block.

#### Downstream gap1 nodes

- `lem:section_localization_descent` (`lem:isLocalizedModule_basicOpen_descent`, build target):
  finite-equalizer descent argument is correct and well-sourced to Stacks
  `lemma-invert-f-sections` / Hartshorne II.5.3. No `\leanok`.

- `lem:qcoh_affine_isIso_fromTildeΓ` (`isIso_fromTildeΓ_of_isQuasicoherent`, build target):
  One-liner assembly from `lem:section_localization_descent` +
  `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict`. Correct. No `\leanok`.

#### Pre-existing issue (not new, not blocking)

`thm:grassmannian_representable` (`\leanok`): The `% NOTE:` on this block records that the
pinned Lean declaration `AlgebraicGeometry.Scheme.Grassmannian.representable` currently
under-delivers the prose statement (omits smoothness, properness, relative dimension
d(r-d), tautological quotient, Plücker embedding). This is a pre-existing gap from prior
iters, not a new defect. The block still has `\leanok` for the weaker existence skeleton.
No action required this iter.

The Quot functor (`def:quot_functor`, `\leanok`) and Grassmannian scheme
(`def:grassmannian_scheme`, `\leanok`) definitions are correct and complete.

**QUOT P1 gate: CLEAR.** All three new coverage blocks are present, mathematically correct,
and properly wired into the keystone. The minor proof-block `\uses{}` asymmetry is cosmetic.

---

### 3. `Picard_GrassmannianCells.tex`

**Covers:** `GrassmannianCells.lean`  
**complete:** true  
**correct:** true

#### Pre-existing GR-cells machinery

All previously completed cells blocks (chart construction, transition maps, cocycle
conditions, tautological quotient on charts) carry `\leanok` and are not re-audited
for this iter.

#### New `sec:gr_separated` blocks (6 coverage blocks)

| Block | `\lean{}` pin | Status |
|-------|--------------|--------|
| `lem:gr_transitionPreMap_minorDet_swap_mul` | (project decl) | no `\leanok` (build target) |
| `def:gr_diagonalRingMap` | (project decl) | no `\leanok` |
| `lem:gr_diagonalRingMap_left` | (project decl) | no `\leanok` |
| `lem:gr_diagonalRingMap_right` | (project decl) | no `\leanok` |
| `lem:gr_diagonalRingMap_surjective` | (project decl) | no `\leanok` |
| `def:gr_pullbackιIso` | `AlgebraicGeometry.Grassmannian.pullbackιIso` | no `\leanok` |

**Outputs from these blocks:**

| Block | `\lean{}` pin | Status |
|-------|--------------|--------|
| `lem:gr_separated` | `AlgebraicGeometry.Grassmannian.isSeparated` | no `\leanok` (build target) |
| `lem:gr_proper` | (project decl) | no `\leanok` |

**Mathematical correctness:**

The surjective restricted-diagonal comorphism (`def:gr_diagonalRingMap`) is the ring map
δ_{I,J} between the transition ring and the product of chart rings, used to verify the
closed diagonal condition. The surjectivity lemma (`lem:gr_diagonalRingMap_surjective`)
feeds `lem:gr_separated` via the standard criterion: the diagonal is closed iff the
comorphism to the structure sheaf of the product is surjective.

`lem:gr_separated` pins `\lean{AlgebraicGeometry.Grassmannian.isSeparated}` — a decl
that does NOT yet exist in Lean. This is correct: it is this iter's build target (as noted
explicitly in the `% NOTE:` comment). Not a defect.

`def:gr_pullbackιIso` pins `\lean{AlgebraicGeometry.Grassmannian.pullbackιIso}` — the
canonical isomorphism of the pullback of the chart open immersion ι, needed as the final
geometric packaging of the separatedness argument.

`\uses{}` chains are well-formed. The dependency path
`lem:gr_transitionPreMap_minorDet_swap_mul → def:gr_diagonalRingMap →
{lem:gr_diagonalRingMap_left, lem:gr_diagonalRingMap_right, lem:gr_diagonalRingMap_surjective}
→ def:gr_pullbackιIso → lem:gr_separated → lem:gr_proper`
is logically consistent. No broken or circular edges.

**GR-glue separated gate: CLEAR.**

---

### 4. `Picard_FlatteningStratification.tex`

**Covers:** `FlatteningStratification.lean`  
**Not gating this iter (GF is gap1-gated)**

#### State summary

Most devissage sub-lemmas have `\leanok`:
- Torsion sub-chain: `lem:gf_finite_module`, `lem:gf_torsion_base`, `lem:noeth_prime_filtration` (`\mathlibok`), splice-SES lemmas (all `\leanok`).
- Denominator-clearing chain: `lem:gf_clear_one_denominator`, `lem:gf_noether_clear_denominators` (all `\leanok`).
- Localization injectivity: `lem:gf_isLocalization_lift_injective`, `lem:gf_generic_rank_ses`, `lem:gf_torsion_annihilator` (all `\leanok`).
- Nagata machinery: `def:gf_nagata_T` and all Nagata sub-lemmas (`\leanok`).
- Module finiteness chain through to `lem:gf_free_moduleFinite` (`\leanok`).
- `lem:gf_qcoh_fintype_finite_sections`, `lem:gf_flat_locality_assembly` (`\leanok`).

**Main theorems not yet closed:**
- `thm:generic_flatness_algebraic`: no `\leanok`
- `thm:generic_flatness` (geometric form): no `\leanok`

#### Flagged issue (non-blocking this iter)

**`lem:gf_polynomial_core` — OreLocalization elaboration blocker (severity: MEDIUM):**
The L5 sorry in this lemma is not a missing math step. It is a Lean elaboration blocker:
the `OreLocalization` instance presentations on the localized quotient `(N ⧸ range φ)_g`
emitted by `gf_torsion_reindex` are definitionally equal to but not instance-transparent-equal
to the presentations the helper input expects. The clean fix is non-local: make
`gf_torsion_reindex` emit its conclusion over the canonical `OreLocalization.*` instances.
This issue does not gate the current iter (GF is gap1-gated) but must be resolved before
the GF prover lane opens.

---

### 5. `Picard_RelativeSpec.tex`

**Covers:** `AlgebraicJacobian/Picard/RelativeSpec.lean`  
**Not gating this iter (RelativeSpec is a deep/blocked lane)**

#### State summary

| Block | `\lean{}` pin | Status |
|-------|--------------|--------|
| `def:qc_sheaf_of_algebras` | `AlgebraicGeometry.Scheme.QcohAlgebra` | `\leanok` |
| `thm:relative_spec_exists` | `AlgebraicGeometry.Scheme.RelativeSpec` | `\leanok` |
| `def:relspec_structure_morphism` | `AlgebraicGeometry.Scheme.RelativeSpec.structureMorphism` | `\leanok` |
| `thm:relative_spec_univ` | `AlgebraicGeometry.Scheme.RelativeSpec.UniversalProperty` | `\leanok` (weaker) |
| `thm:relative_spec_affine_base` | `AlgebraicGeometry.Scheme.RelativeSpec.affine_base_iff` | `\leanok` (weaker) |

#### Pre-existing issue (not new, not blocking)

**`thm:relative_spec_univ` Lean type weaker than prose (severity: LOW, pre-existing):**
The `% NOTE:` in the statement block records that the iter-173 file-skeleton encodes the
universal property as `IsAffineHom (structureMorphism 𝒜)` rather than a full
`CategoryTheory.Functor.RepresentableBy` witness (the form the prose claims). The iter-179
review note confirms this weakness persists. This is an iter-174+ commitment still pending;
it is a pre-existing gap, not a new defect. No action required this iter.

Similarly, `thm:relative_spec_affine_base` carries the weaker `IsAffine` form rather than
the canonical iso `Spec_X(𝒜) ≅ Spec(Γ(X,𝒜))`. Same pre-existing caveat.

---

### 6. `Cohomology_RegroupHelper.tex`

**Covers:** (included in FlatBaseChange coverage)  
**complete:** true  
**correct:** true

Single lemma `lem:base_change_regroup_linearEquiv` (`\leanok`) with well-formed
`\uses{lem:isPushout_cancelBaseChange_mathlib}`. Clean chapter; no issues.

---

## Cross-chapter issues

### Must-fix this iter
None.

### Should-fix (cosmetic / low severity)
1. **`lem:isIso_fromTildeΓ_basicOpen_of_quasicoherent` (QuotScheme.tex, ~line 3321)**:
   The proof block `\uses{}` is missing `lem:exists_finite_basicOpen_cover_le_quasicoherentData`
   even though the proof text references it. Statement block correctly carries it. DAG
   backward edge is missing. Fix: add
   `lem:exists_finite_basicOpen_cover_le_quasicoherentData` to the proof `\uses{}`.

### Deferred (not blocking this iter)
2. **`lem:gf_polynomial_core` OreLocalization blocker** (FlatteningStratification.tex):
   Requires non-local fix in `gf_torsion_reindex`. Must be resolved before GF lane opens.
3. **`thm:grassmannian_representable` under-delivery** (QuotScheme.tex):
   Pre-existing. `\lean{}` pin under-delivers prose. Should be split or strengthened in a
   future iter.
4. **`thm:relative_spec_univ` weaker Lean type** (RelativeSpec.tex):
   Pre-existing iter-174+ commitment. No action required until RelativeSpec lane opens.

---

## Severity summary

| Severity | Count | Items |
|---------|-------|-------|
| BLOCKING (must fix before gate) | 0 | — |
| MEDIUM (must fix before lane opens) | 1 | `lem:gf_polynomial_core` OreLocalization blocker |
| LOW (cosmetic / pre-existing) | 3 | missing proof `\uses{}` in P1 keystone; GR representability under-delivery; RelativeSpec univ weaker type |

---

## Recommendation to plan agent

All four prover lanes may be dispatched:
- **FBC-A prover**: conjugate re-encoding blocks are correct; proceed.
- **FBC-B prover**: equalizer chain from `lem:gamma_amodule_restriction` through `lem:flat_base_change_reduce_global_sections`; `LinearMap.tensorEqLocusEquiv` anchor confirmed.
- **QUOT P1 prover**: three new coverage blocks are complete and correct; keystone `isIso_fromTildeΓ_restrict_basicOpen` is ready to formalize.
- **GR-glue separated prover**: `sec:gr_separated` scaffold is complete and correct; `isSeparated` + `pullbackιIso` are ready to formalize.

The cosmetic P1 keystone proof-`\uses{}` gap (item 1 above) does not block the prover but
should be patched by the plan agent in `Picard_QuotScheme.tex` before the blueprint is
published.
