# Blueprint Review — iter-080

**Scope**: whole-blueprint audit (`blueprint/src/chapters/*.tex`), with three focus
questions gating this iter's prover dispatch.

---

## Global leandag stats

```
unknown_uses  : 0    (no broken \uses{} cross-references)
unmatched_lean: 118  (Lean declarations with no \lean{} pin in the blueprint)
isolated      : 138  (mostly lean_aux; see §FlatteningStratification below)
```

`unknown_uses: 0` means all `\uses{label}` references resolve across chapters. The 118
`unmatched_lean` entries are the primary blueprint debt — mostly iter-079 additions to
`GrassmannianQuot.lean` that were never blueprinted (see Focus Q2).

---

## Focus Q1 — `Picard_GlueDescent.tex`

### Is `\uses{lem:gr_glueData_bridges}` at L513/522/556 a broken ref?

**NO — not broken.** `lem:gr_glueData_bridges` is defined in
`Picard_GrassmannianQuot.tex` (lines 151–187) with three `\lean{}` pins:
`glueData_bridge_src`, `glueData_bridge_mid`, `glueData_bridge_tgt`. leandag reports
`unknown_uses: 0`, confirming all cross-chapter `\uses{}` edges resolve. The ref is valid.

### Are the ~13 triple-overlap helpers blueprinted?

**NO.** Declarations named in the directive
(`glueData_triple_square`, `glueData_preimage_image_eq₃`, `glueTripleBaseChangeIso`,
`glueTripleFactor_transpose`, `glueTripleFactor_mate`, `glueLegA_component_transpose`,
`glueLegB_component_transpose`, etc.) do **not** appear as labeled `\begin{lemma}`
blocks anywhere in the blueprint. They are described only in the **prose** of the three
numbered items (lines 539–562) of the proof sketch of
`lem:gr_glueChartFamily_equalizes`.

### Is the proof sketch of item (3) / `glueChartComponent_leg_compat` detailed enough?

**Current sorry status (from Lean source)**:
```
-- GlueDescent.lean, line 2023
lemma glueChartComponent_leg_compat (i p q : D.J) : …
  …
  sorry   -- line 2081
```

The sorry is **real**. The outer `glueChartFamily_equalizes` (line 2088) calls this
helper; the statement block of `lem:gr_glueChartFamily_equalizes` carries `\leanok`
(declaration exists in Lean), but the **proof block has no `\leanok`** (sorry via the
transitive chain).

The 3-item proof sketch at lines 539–562 gives a research-level road map:
1. Triple-overlap opens identity (analogue of `glueOverlapBaseChangeIso`)
2. Triple-overlap base-change iso assembled by four-factor recipe
3. Transposed component = C2 cocycle after conjugation by `glueData_bridges`

This is **adequate structure** but **insufficient for direct prover dispatch** as written: each
item corresponds to several sub-declarations that need `\lean{}` pins and separate
`\begin{lemma}` blocks before a prover can target them individually. The prover would
need to decompose items (1)–(3) into ~5–8 labeled sub-blocks inline.

**Verdict (gate)**:
- `lem:gr_glueChartFamily_equalizes` proof: **OPEN (sorry)** — gated behind
  `glueChartComponent_leg_compat`
- Blueprint completeness for the sub-helpers: **INCOMPLETE** — prose only, no labeled blocks
- Recommended action: plan agent should extract the 5–8 sub-helpers from the prose and
  add labeled blueprint blocks with `\lean{}` hints before dispatching the GlueDescent
  prover lane

---

## Focus Q2 — `Picard_GrassmannianQuot.tex`

### Is `sec:grquot_universal` detailed enough for `represents.left_inv` / `right_inv`?

**Current sorry status (from GrassmannianQuot.lean)**:
```
-- line 4435
sorry  -- represents.left_inv (uniqueness: given two morphisms equal on the tautological quotient)
-- line 4440
sorry  -- represents.right_inv (existence: construct morphism from a RankQuotient)
```

The single `\begin{theorem}` block for `thm:grassmannian_universal_property` (statement:
`\leanok`, proof covers both directions) gives the overall structure but is gated
on two un-blueprinted dependencies:
- `universalQuotient_restrictionIso` (line 2419 of Lean file): 1 sorry, **NOT blueprinted**
- `tautologicalRankQuotient` (line 2475 of Lean file): present, **NOT blueprinted**

Without blueprinting `universalQuotient_restrictionIso` (the chart-locus pullback
identification) and `tautologicalRankQuotient`, the proof obligations for `left_inv`/
`right_inv` cannot be dispatched with the level of guidance this prover lane needs.

### 7 iter-079 additions + `tautologicalRankQuotient`, `universalQuotient_restrictionIso` — blueprinted?

**None are blueprinted.** All 9 declarations searched in the `.tex` returned no hits.
Their Lean status (from `GrassmannianQuot.lean`):

| Declaration | Lean line | Has sorry? | Blueprinted? |
|---|---|---|---|
| `chartMorphism_glue_compat` | 4194 | no | **NO** |
| `comp_chartMorphism` | 4116 | no | **NO** |
| `presentedMatrix_comp` | 3927 | no | **NO** |
| `chart_point_eq` | 4070 | no | **NO** |
| `universalMatrix_map_presentedMatrix` | 3995 | no | **NO** |
| `imageMatrix_map_ringHom` | 4038 | no | **NO** |
| `chartComposite_rqPullback` | 3201 | no | **NO** |
| `tautologicalRankQuotient` | 2475 | no | **NO** |
| `universalQuotient_restrictionIso` | 2419 | **YES** | **NO** |

These 9 declarations account for a significant share of the `unmatched_lean: 118` count.

**Must-fix gap**: `universalQuotient_restrictionIso` carries a sorry and is the critical
blocker for the `represents` instance. Plan agent must blueprint this declaration (proof
sketch: identify the restriction of `universalQuotient` to a chart locus with the
chart's rank quotient via the glue isomorphism; the factorization is the blueprint proof
target) before dispatching a `GrassmannianQuot` prover.

**Verdict (gate)**:
- `thm:grassmannian_universal_property` proof: **OPEN** — `left_inv` and `right_inv`
  both sorry'd
- Blueprint completeness: **INCOMPLETE** — 9 Lean declarations unblueprinted
- Recommended action: plan agent should add labeled blocks for at minimum
  `universalQuotient_restrictionIso` and `tautologicalRankQuotient`, then dispatch GR-quot
  prover lane on `universalQuotient_restrictionIso` + `represents`

---

## Focus Q3 — `Cohomology_FlatBaseChange.tex` (FBC-B DIRECT route)

### Is `thm:fbcb_global_direct` complete + correct enough to scaffold+prove this iter?

**YES — GREEN. Launch the FBC-B DIRECT prover lane this iter.**

**Blueprint block** (lines 4502–4584):
```latex
\label{thm:fbcb_global_direct}
\lean{AlgebraicGeometry.Modules.baseChangeGammaPullbackEquiv}
\uses{lem:finite_affine_cover_qcqs, lem:fbcb_gammaTopEquivEqLocus,
      lem:fbcb_baseChangeGammaEquiv, lem:pullback_spec_tilde_iso,
      lem:affine_base_change_pushforward, lem:flat_base_change_reduce_global_sections}
```
No `\leanok` (not yet scaffolded). Covers `FlatBaseChangeGlobal.lean` via the
`% archon:covers` header.

**Dependency readiness**:

| Dep | leanok? | In FlatBaseChangeGlobal.lean? |
|---|---|---|
| `lem:finite_affine_cover_qcqs` | ✓ | ✓ (0-sorry) |
| `lem:fbcb_gammaTopEquivEqLocus` | ✓ | ✓ (0-sorry) |
| `lem:fbcb_baseChangeGammaEquiv` | ✓ | ✓ (0-sorry, last decl at line 241) |
| `lem:pullback_spec_tilde_iso` | ✓ | (in FlatBaseChange.lean, 0-sorry) |
| `lem:affine_base_change_pushforward` | ✓ | (in FlatBaseChange.lean, 0-sorry) |
| `lem:flat_base_change_reduce_global_sections` | **NO** | **NOT YET PRESENT** |

`lem:flat_base_change_reduce_global_sections` (= `flatBaseChange_isIso_iff_gammaTensorComparison`)
is blueprinted (lines 3999–4036) with a clear proof: "being isomorphism is local on S';
reduce to the tilde equivalence + fully faithful." It must be added to
`FlatBaseChangeGlobal.lean` alongside `baseChangeGammaPullbackEquiv`.

**3-step proof of `thm:fbcb_global_direct`** (lines 4530–4583):
1. Apply `lem:fbcb_baseChangeGammaEquiv` (DONE): `B⊗_A Γ(X,F) ≅ eqLocus(id_B⊗leftRes, id_B⊗rightRes)`
2. Per-chart identify the base-changed legs with restriction legs of F' over X' (Tag 01I9 /
   `lem:pullback_spec_tilde_iso` + `lem:affine_base_change_pushforward`): both DONE
3. Recognize the RHS equalizer as `Γ(X', F')` via `lem:fbcb_gammaTopEquivEqLocus`: DONE
4. Convert to sheaf-level via `lem:flat_base_change_reduce_global_sections`: to scaffold

**Current FBC sorry map**:
- `FlatBaseChangeGlobal.lean`: **0 sorries**, ends at `baseChangeGammaEquiv`
- `FlatBaseChange.lean`:
  - `base_change_mate_fstar_reindex_legs_conj` (line 1802): sorry (ABANDONED route)
  - `base_change_mate_gstar_transpose` (line 2291): sorry (ABANDONED route)
  - `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`: transitively sorry through the abandoned mate route
- The DIRECT route bypasses both mate sorries entirely

**Prover recipe**:
1. Add `flatBaseChange_isIso_iff_gammaTensorComparison` to `FlatBaseChangeGlobal.lean`
   (proof: locality on S' + tilde fully-faithful, ~20 LOC)
2. Scaffold + prove `baseChangeGammaPullbackEquiv` in `FlatBaseChangeGlobal.lean`
   following the 3-step blueprint proof (~80–150 LOC)
3. In `FlatBaseChange.lean`, fill the body of `affineBaseChange_pushforward_iso` (derive
   from `baseChangeGammaPullbackEquiv` specialized to an affine morphism) and
   `flatBaseChange_pushforward_isIso` (derive from the full `baseChangeGammaPullbackEquiv`
   + `flatBaseChange_isIso_iff_gammaTensorComparison`), discarding the sorry-backed mate
   route that currently populates those bodies

---

## FlatteningStratification isolated `lem:mathlib_*` nodes

`leandag show isolated` reports **3 isolated `lem:mat…` nodes** in FlatteningStratification,
all with `Proved: ✗` (expected: `\mathlibok` blocks never get `\leanok`), `Deps: 0`,
`Impact: 0`.

Of the 14 `lem:mathlib_*` labeled blocks in `Picard_FlatteningStratification.tex`
(lines 1848–2389, covering `lem:mathlib_flat_of_free`, `lem:mathlib_flat_localization_preserves`,
`lem:mathlib_localization_flat`, `lem:mathlib_flat_of_localized_maximal`,
`lem:mathlib_flat_of_isLocalized_maximal`, `lem:mathlib_flat_trans`,
`lem:mathlib_flat_of_isLocalized_span`, `lem:mathlib_free_of_isLocalizedModule`,
`lem:mathlib_scheme_basicOpen_res`, `lem:mathlib_algebra_isEpi`,
`lem:mathlib_tensorProduct_lid_epi`, `lem:mathlib_commRingCat_epi_iff_epi`,
`lem:mathlib_spec_fullyFaithful`, `lem:mathlib_isOpenImmersion_mono`,
`lem:mathlib_isAffineOpen_isoSpec`, `lem:mathlib_baseChange_flat`,
`lem:mathlib_flat_of_linearEquiv`, `lem:mathlib_flat_isBaseChange`), 11 are cited by
proof blocks. Three are not cited — likely anchors added for the geometric wrapper proof
that references them inline without explicit `\uses{}` declarations.

**Status: BENIGN.** Isolated `\mathlibok` nodes do not block any prover lane and do not
affect leandag's `unknown_uses: 0` health. Low-priority cleanup: add `\uses{lem:mathlib_*}`
to the `genericFlatness` proof block that exercises these flatness anchors.

---

## Per-Chapter Completeness & Correctness Checklist

### `Cohomology_FlatBaseChange.tex` (4584 lines)
- **complete**: MOSTLY — affine infrastructure all `\leanok`; `thm:fbcb_global_direct`
  and `lem:flat_base_change_reduce_global_sections` not `\leanok` (to scaffold);
  FBC-A abandoned apparatus (`base_change_mate_fstar_reindex_legs_conj`,
  `base_change_mate_gstar_transpose`) has sorries (planned for cleanup/delete)
- **correct**: YES — DIRECT route blueprint is consistent with Lean structure;
  STRATEGY.md confirms FBC-A is off-path
- **gate**: FBC-B DIRECT prover lane — **OPEN, launch this iter** (see Focus Q3)

### `Cohomology_RegroupHelper.tex` (76 lines)
- **complete**: YES — 2 blocks, both `\leanok`, `lem:base_change_regroup_linearEquiv`
  statement and proof both closed
- **correct**: YES
- **gate**: N/A (done)

### `Picard_FlatteningStratification.tex` (2672 lines)
- **complete**: MOSTLY — main theorem `thm:generic_flatness_algebraic` and geometric
  `genericFlatness` done; 3 isolated `lem:mathlib_*` anchors unused; `lem:isL…` node
  in leandag isolated list is the `lem:isLocalization_*` helper (proved, isolated in
  the DAG sense only, not in Lean)
- **correct**: YES
- **gate**: N/A (GF-alg and GF-geo both COMPLETED per STRATEGY.md)
- **minor gap**: Add `\uses{lem:mathlib_flat_of_free}` etc. to the `genericFlatness`
  proof block to connect the 3 isolated anchors

### `Picard_GlueDescent.tex` (842 lines)
- **complete**: PARTIALLY — 28 `\leanok` markers on statement blocks; proof block of
  `lem:gr_glueChartFamily_equalizes` NOT `\leanok`; ~13 triple-overlap helpers described
  in prose only with no labeled blueprint blocks
- **correct**: YES — the proof structure is sound; `lem:gr_glueData_bridges` is a valid
  cross-chapter ref
- **gate**: **BLOCKED** — `glueChartComponent_leg_compat` sorry open; blueprint needs
  sub-helper blocks extracted from items (1)–(3) before dispatching the prover

### `Picard_GrassmannianCells.tex` (2772 lines)
- **complete**: VERY — 155 `\leanok`, 8 `\mathlibok`, 105 labels; main results include
  `gr_cocycle`, `Grassmannian.scheme`, `isSeparated`, `isProper` all `\leanok`
- **correct**: YES
- **gate**: N/A (GR-cells/glue/separated/proper all COMPLETED per STRATEGY.md)

### `Picard_GrassmannianQuot.tex` (2521 lines)
- **complete**: INCOMPLETE — 9 Lean declarations in `GrassmannianQuot.lean` have no
  blueprint coverage; `universalQuotient_restrictionIso` is sorry'd and unblueprinted;
  `represents.left_inv`/`right_inv` sorry'd; proof block of
  `thm:grassmannian_universal_property` has `\leanok` on statement only
- **correct**: The existing blueprint prose is correct; the gap is coverage, not errors
- **gate**: **BLOCKED** — must-fix: add blueprint blocks for
  `universalQuotient_restrictionIso` and `tautologicalRankQuotient` before prover dispatch
- **recommended action this iter**: plan agent writes blueprint blocks for the 2 critical
  missing declarations + dispatches GR-quot prover lane for `universalQuotient_restrictionIso`

### `Picard_QuotScheme.tex` (5666 lines)
- **complete**: PARTIALLY — 169 `\leanok`, 40 `\mathlibok`; missing `\leanok` on
  `def:sectionGradedRing` (line 157), `def:sectionGradedModule` (line 202),
  `lem:sectionGradedModule_fg` (line 239), `def:hilbert_polynomial` (line 59),
  `thm:hilbertPoly_of_sectionModule` (line 705), `lem:sectionGradedRing_gcommSemiring`
  (line 1369)
- **correct**: YES for the done portions
- **gate**: BLOCKED on SNAP (`def:sectionGradedRing` gated on tensor-power infrastructure;
  see `Picard_SectionGradedRing.tex` below)
- **note**: SNAP crux chain through `tensorPowAdd` is DONE (see SectionGradedRing);
  `lem:sectionGradedRing_gcommSemiring` (graded-ring assembly from tensor powers) is
  the current frontier in QuotScheme

### `Picard_RelativeSpec.tex` (438 lines)
- **complete**: YES — all 5 main declarations `\leanok`:
  `def:qc_sheaf_of_algebras`, `thm:relative_spec_exists`, `def:relspec_structure_morphism`,
  `thm:relative_spec_univ`, `thm:relative_spec_affine_base`
- **correct**: YES — `thm:relative_spec_univ` (needed for GR-repr) is done ✓
- **gate**: N/A (done; QUOT-repr prerequisite satisfied)

### `Picard_SectionGradedRing.tex` (1486 lines)
- **complete**: MOSTLY — 41 `\leanok`, 8 `\mathlibok`; SNAP crux is DONE:
  `ztensor_whisker_localIso` ✓, `isIso_sheafification_whiskerRight_unit` ✓,
  `tensorObjAssoc` ✓, `tensorPowAdd` ✓. Missing `\leanok`: `lem:sectionGradedRing_gcommSemiring`
  (graded semiring assembly, line 1369) and its downstream
- **correct**: YES — STRATEGY.md SNAP row "ACTIVE (crux)" status is **OUTDATED**: the
  crux and its feeder are both `\leanok` as of this iter's blueprint state
- **gate**: SNAP crux chain done; remaining = `sectionGradedRing_gcommSemiring` (graded
  ring assembly using tensor powers) → then `def:sectionGradedRing` in QuotScheme
- **recommended action**: dispatch SNAP prover lane for `sectionGradedRing_gcommSemiring`
  this iter (all inputs are ready)

---

## Unstarted-phase blueprint proposals

The following blueprint sections are absent but would be needed before the corresponding
prover lanes can be dispatched. Listed in priority order:

### 1. `GlueDescent` — triple-overlap sub-helpers for `glueChartComponent_leg_compat`

**Status**: zero blueprint blocks; triple-overlap helpers described only in proof prose
(items 1–3 of the proof sketch).

**Proposal**: add 5–8 labeled `\begin{lemma}` blocks in `Picard_GlueDescent.tex`,
extracting from the prose:
- `lem:gr_glueData_preimage_image_eq₃` — triple-overlap opens identity (item 1)
- `lem:gr_glueTripleBaseChangeIso` — triple-overlap base-change iso (item 2)
- `lem:gr_glueLegA_component_transpose` — transposed A-leg at triple (item 3 setup)
- `lem:gr_glueLegB_component_transpose` — transposed B-leg at triple (item 3 setup)
- `lem:gr_glueTripleFactor_mate` — mate calculation closing the C2 equation

Each should carry a `\lean{}` hint for the corresponding Lean sub-declaration and a
`\uses{}` list citing `lem:gr_glueData_bridges` and the pair-level analogues.

### 2. `GrassmannianQuot` — `universalQuotient_restrictionIso` + `tautologicalRankQuotient`

**Status**: both in Lean (former sorry'd); neither blueprinted.

**Proposal** (minimum to unblock the `represents` prover):

```latex
\begin{definition}
  \label{def:universalQuotient_restrictionIso}
  \lean{AlgebraicGeometry.Grassmannian.universalQuotient_restrictionIso}
  \uses{def:tautological_quotient, def:gr_glueRestrictionIso}
  The restriction of the universal quotient $\mathcal{O}^r \to \mathcal{U}$ to the
  $I$-chart $U^I$ is isomorphic to the chart's rank-$d$ quotient $\mathcal{O}^r_{U^I} \to
  \mathcal{U}^I$ via the glue-restriction isomorphism $\phi_I$.
\end{definition}
```

```latex
\begin{definition}
  \label{def:tautologicalRankQuotient}
  \lean{AlgebraicGeometry.Grassmannian.tautologicalRankQuotient}
  \uses{def:tautological_quotient, def:universalQuotient_restrictionIso}
  The tautological quotient data as a $\mathrm{RankQuotient}$ structure over the
  Grassmannian scheme.
\end{definition}
```

Also add the 7 iter-079 sorry-free declarations as `\begin{lemma}\leanok` blocks
(since they are provably done) to drain the `unmatched_lean: 118` count.

### 3. `SectionGradedRing` / `QuotScheme` — `sectionGradedRing_gcommSemiring` proof sketch

**Status**: `lem:sectionGradedRing_gcommSemiring` has a label in both SectionGradedRing
and QuotScheme; no proof block with `\leanok`.

**Proposal**: add a proof block to `lem:sectionGradedRing_gcommSemiring` describing:
- The graded multiplication is defined degree-by-degree via `sheafTensorObj`
- Associativity: `tensorObjAssoc` (DONE ✓)
- Distributivity over degree addition: `tensorPowAdd` (DONE ✓)
- The ring axioms lift from the object-wise structure

This will unblock the SNAP prover lane for this iter.

### 4. `FlatBaseChange` — cleanup lane for abandoned FBC-A apparatus

**Status**: `base_change_mate_fstar_reindex_legs_conj` and `base_change_mate_gstar_transpose`
carry sorries; 30+ supporting `base_change_mate_*` lemma blocks in the blueprint are
annotated with `% NOTE: superseded by the conjugate-side re-encoding` or similar.

**Proposal**: plan a cleanup/delete lane (not a prover lane) to:
1. Remove the sorry-bearing `base_change_mate_fstar_reindex_legs_conj` and
   `base_change_mate_gstar_transpose` Lean declarations from `FlatBaseChange.lean`
2. Delete or suppress the `% NOTE: superseded` blueprint blocks
3. Confirm `affineBaseChange_pushforward_iso` and `flatBaseChange_pushforward_isIso`
   are solely backed by the DIRECT route after step (1)

This is not a prover task but a structural cleanup that should follow the FBC-B DIRECT
prover landing.

---

## Dispatch recommendation for iter-080

| Lane | Chapter file | Key target | Blueprint gate | Verdict |
|---|---|---|---|---|
| **FBC-B DIRECT** | `FlatBaseChangeGlobal.lean` | `baseChangeGammaPullbackEquiv` | GREEN | **LAUNCH** |
| **GR-quot** | `GrassmannianQuot.lean` | `universalQuotient_restrictionIso` | BLOCKED (unblueprinted) | plan first |
| **SNAP assembly** | `SectionGradedRing.lean` | `sectionGradedRing_gcommSemiring` | NEARLY READY | launch after proof sketch added |
| **GlueDescent C2** | `GlueDescent.lean` | `glueChartComponent_leg_compat` | BLOCKED (sub-helpers unblueprinted) | plan first |
| GF-geo | `FlatteningStratification.lean` | — | DONE | skip |
| RelativeSpec | — | — | DONE | skip |
