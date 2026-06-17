# Blueprint-reviewer report

**Slug**: iter058
**Iteration**: 058
**Date**: 2026-06-09

---

## Executive summary

All three chapters audit clean. The two prover-lane hard gates clear with no must-fix findings.
The OpenImmersionPushforward decomposition is complete and correct for next-iter dispatch, with one
soon-fix annotation. Coverage debt is fully retired.

---

## Per-chapter verdicts

### Chapter: `Cohomology_HigherDirectImage.tex`

**Covers**: `AlgebraicJacobian/Cohomology/HigherDirectImage.lean`

**complete: true | correct: true**

Single definition block `def:higher_direct_image` → `\lean{AlgebraicGeometry.higherDirectImage}`,
`\leanok` present. No proof obligations. Self-contained. Nothing to flag.

---

### Chapter: `Cohomology_AcyclicResolution.tex`

**Covers**: `AlgebraicJacobian/Cohomology/AcyclicResolution.lean`

**complete: true | correct: true**

All Mathlib anchors correctly marked `\mathlibok`:
- `lem:right_derived_injective_resolution`, `lem:right_derived_vanishes_injective`,
  `lem:right_derived_zero_iso_self`, `lem:homology_long_exact_sequence`
- `lem:horseshoe_biprod_injective`, `lem:horseshoe_degree_split`

All project-local lemmas (`lem:horseshoe_stage_mono`, `lem:horseshoe_twist`,
`lem:horseshoe_dComp`, `lem:horseshoe_chainMap`, `lem:quasiIso_tau2`,
`lem:horseshoe_resolvesMiddle`, `lem:injective_resolution_of_ses`,
`lem:acyclic_dimension_shift`, `lem:acyclic_one_iso_coker`, `lem:cosyzygy_ses`,
`lem:applied_cosyzygy_cycles`, `lem:cohomology_of_applied_resolution`,
`lem:acyclic_resolution_computes_derived`, `def:right_acyclic`) carry `\leanok` on
both statement and proof. Nothing to flag.

---

### Chapter: `Cohomology_CechHigherDirectImage.tex`

**Covers**: 14 Lean files (via `% archon:covers` declarations), including
`AffineSerreVanishing.lean`, `CechSectionIdentification.lean`,
`OpenImmersionPushforward.lean`, `CechAcyclic.lean`, and 10 others.

**complete: true | correct: true**

Details by sub-area follow.

---

#### Lane 1 — AffineSerreVanishing.lean

**Gate: CLEARS**

**`lem:affine_cech_vanishing_general_seed`**
- `\lean{AlgebraicGeometry.sectionCech_homology_exact_of_affineOpen}`
- `\leanok` on statement and proof.
- Verified in `CechAcyclic.lean` line 2162: proved without sorry.
- `\uses{}` edges: `lem:affine_cech_vanishing_qcoh_cover`,
  `lem:standard_cover_cofinal_affine`, `lem:basicOpen_algMap_section`.
- Status: **correct, already built** (seed confirmed from iter-057).

**`lem:affine_serre_vanishing_general_open`**
- `\lean{AlgebraicGeometry.affine_serre_vanishing_general_open}`
- `\leanok` on statement only (proof body contains sorry — correct: sync_leanok
  will remove proof `\leanok` once the sorry is closed; no marker error here).
- Proof sketch present: complete informal argument (3 phases: cover reduction via
  `affineCoverSystemGeneral` + `affine_surj_of_vanishing_affine`, seed invocation,
  Čech-to-cohomology bridge).
- `\uses{}` entries (9): `lem:affine_cover_system_general`,
  `lem:affine_surj_of_vanishing_affine`, `lem:affine_cech_vanishing_general_seed`,
  `lem:cech_to_cohomology_comparison`, `lem:higher_direct_image_openImmersion_acyclic`,
  `lem:acyclic_resolution_computes_derived`, `lem:right_derived_vanishes_injective`,
  `lem:right_derived_injective_resolution`, `lem:right_derived_zero_iso_self`.
- Build target confirmed absent from `AffineSerreVanishing.lean` (not yet built —
  that is expected; this is the prover's objective for this iter).
- No must-fix. Ready to formalize.

---

#### Lane 2 — CechSectionIdentification.lean

**Gate: CLEARS**

**Stubs 5/6 — augmented form agreement**

`lem:cechSection_complex_iso` (Stub 5):
- Blueprint text (checked lines 7981-8055): explicitly names target as
  "augmented form `D'_aug`", written as
  `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε`.
- Lean file (`CechSectionIdentification.lean` line 386-401): signature
  `D ≅ (sectionCechComplexV 𝒰 F V).augment ε hε` — **exact match**.
- `\leanok` on statement, sorry at proof. Correct.

`lem:cechSection_contractible` (Stub 6):
- Blueprint (lines 8082-8163): targets homotopy on the augmented complex `D'_aug`.
- Lean file (line 453-460): sorry present, statement anchored to augmented form.
- **Blueprint and Lean agree on augmented form.** No must-fix.

**Stub-1 decomposition chain** (split from `lem:coproduct_distrib_fibrePower`)

Four new sub-lemma blocks confirmed present and well-formed:

| Label | `\lean{}` hint | `\uses{}` edges | Mathlib anchor |
|-------|---------------|-----------------|----------------|
| `lem:widePullback_overX_eq_prod` | present | `lem:widePullbackCone_isLimitOfFan_mathlib`, `lem:over_mkIdTerminal_mathlib` | both confirmed in blueprint |
| `lem:coproduct_distrib_fibrePower_zero` | present | `lem:widePullback_overX_eq_prod`, `lem:isIso_sigmaDesc_map_mathlib` | confirmed |
| `lem:prod_coproduct_distrib` | present | `lem:finitaryExtensive_scheme_mathlib` | confirmed |
| `lem:coproduct_fibrePower_reindex` | present | `lem:sigmaSigmaIso_mathlib`, `lem:prod_coproduct_distrib` | confirmed |

Mathlib anchors (`lem:finitaryExtensive_scheme_mathlib` line 8228,
`lem:isIso_sigmaDesc_map_mathlib` line 8239, `lem:widePullbackCone_isLimitOfFan_mathlib`
line 8265, `lem:over_mkIdTerminal_mathlib` line 8277, `lem:sigmaSigmaIso_mathlib`
line 8289) all present and marked `\mathlibok`.

Assembly lemma `lem:coproduct_distrib_fibrePower` (the original target) retains its
`\uses{}` pointing at all four sub-lemmas — chain is complete.

Proof sketches for all four sub-lemmas are present and contain sufficient informal
argument for a prover to proceed. No must-fix on Stub 1.

---

#### OpenImmersionPushforward decomposition — NOT a prover lane this iter

**Ready for next-iter prover dispatch**

Five sub-lemma build targets confirmed present in blueprint:

1. **`lem:pushforward_commutes_free`** — `\uses{}` present, proof sketch: free-module
   commutation via colimit-preservation. Adequate.
2. **`lem:pushforward_commutes_sheafify`** — `\uses{}` present, proof sketch:
   sheafification adjunction + naturality. Adequate.
3. **`lem:yoneda_transport_along_homeo`** — `\uses{}` present, proof sketch: Yoneda
   naturality under homeomorphism. Adequate.
4. **`lem:jshriek_transport_along_iso`** — `\uses{}` present, proof sketch: j!-pushforward
   transport via scheme iso + jShriekOU naturality. Adequate.
5. **`lem:pushforward_iso_preserves_qcoh`** — proof sketch present. **SOON**: no `\uses{}`
   declared; should cite `lem:higher_direct_image_openImmersion_acyclic` or the relevant
   Mathlib qcoh-preservation lemma once identified. Not must-fix (sketch is clear), but add
   before dispatching the prover.

Mathlib anchor `lem:comp_iso_of_iso_mathlib` (or equivalent) present and `\mathlibok`.

Assembly lemma `lem:modules_isoSpec_ext_transport` retains `\uses{}` listing all five
sub-lemmas. Chain is complete.

**Overall assessment**: decomposition is complete + correct. One soon-fix (`\uses{}` on
`lem:pushforward_iso_preserves_qcoh`) before prover dispatch next iter.

---

#### Coverage debt — 13 helpers

All 13 prover-created helpers confirmed to have blueprint entries with accurate `\uses{}`:

**CechAcyclic change-of-ring chain** (7 helpers):
- `lem:isLocalizedModule_baseChange_away` — entry present, `\leanok`, confirmed built
  (`CechAcyclic.lean` line 977).
- `lem:section_cech_module_exact_of_affineCover` — entry present, `\leanok`.
- `lem:sectionCech_homology_exact_of_affineCover` — entry present, `\leanok`.
- `lem:affine_cech_vanishing_general_seed` — entry present, `\leanok` (confirmed above).
- `lem:standard_cover_cofinal_affine` — entry present, `\leanok`.
- `lem:affine_surj_of_vanishing_affine` — entry present, `\leanok`.
- `lem:affine_cover_system_general` — entry present, `\leanok`.

**CoverArrowOver* coproduct leaf** (3 helpers):
- `lem:coverArrowOverSigmaIso` — entry present, `\leanok`.
- `lem:coverArrowOverCofan` — entry present, `\leanok`.
- `lem:coverArrowOverIsColimit` — entry present, `\leanok`.

**OpenImmersionPushforward internals** (3 helpers):
- `lem:pushforwardEquivOfIso` — entry present, `\leanok`.
- `lem:pushforwardExtAddEquiv` — entry present, `\leanok`.
- `lem:pushforwardEquivOfIso_functor_additive` — entry present, `\leanok`.

`leandag build --json` reports `unknown_uses: []` — no broken dependency edges.
No isolated blueprint nodes (isolated leandag nodes are `lean_aux` internal helpers,
not blueprint obligations).

---

## Dependency and isolation findings

- `leandag build --json`: `unknown_uses: []`, `unmatched_lean: []` for all substantive
  declarations. Clean.
- `leandag show isolated`: all isolated nodes are `lean_aux` private helpers (not blueprint
  items). Expected; no action required.
- blueprint-doctor: no undefined macros, no broken `\ref`/`\uses`/`\proves`, no orphan
  chapters, no new `axiom` declarations introduced this iter.

---

## Severity summary

| Finding | Severity | Action |
|---------|----------|--------|
| `lem:pushforward_iso_preserves_qcoh` missing `\uses{}` | **SOON** | Add before next-iter OpenImmersionPushforward prover dispatch |

No MUST-FIX findings.

---

## Hard gate decisions

| Prover lane | Chapter gate | Verdict |
|-------------|-------------|---------|
| `AffineSerreVanishing.lean` | `Cohomology_CechHigherDirectImage.tex` | **CLEARS** — `lem:affine_serre_vanishing_general_open` complete + correct; seed `\leanok` confirmed |
| `CechSectionIdentification.lean` | `Cohomology_CechHigherDirectImage.tex` | **CLEARS** — Stub-1 decomposition complete + correct; Stubs 5/6 augmented-form agreement confirmed |

**Overall chapter verdicts**:
- `Cohomology_HigherDirectImage.tex`: complete + correct
- `Cohomology_AcyclicResolution.tex`: complete + correct
- `Cohomology_CechHigherDirectImage.tex`: complete + correct
