# Blueprint-reviewer report — iter-028

Audit scope: whole blueprint (all 6 chapters). Three focus chapters gate live prover
dispatch this iter. Tool runs: `archon blueprint-doctor --json` and `.leandag/dag.json`
reviewed; prior `blueprint-clean-iter028.md` incorporated.

---

## Gate verdicts (summary)

| Chapter | complete | correct | Gate-ready? |
|---------|----------|---------|-------------|
| `Cohomology_FlatBaseChange.tex` | **yes** | **yes** | ✓ FBC-A prover may dispatch |
| `Cohomology_RegroupHelper.tex` | **yes** | **yes** | ✓ |
| `Picard_QuotScheme.tex` | **yes** | **yes** | ✓ QUOT-defs prover may dispatch |
| `Picard_GrassmannianCells.tex` | **yes** | **yes** | ✓ GR-glue prover may dispatch |
| `Picard_RelativeSpec.tex` | **yes** | **yes** | ✓ (mature chapter) |
| `Picard_FlatteningStratification.tex` | **yes** | **yes** | ✓ (standalone) |

**All three focus chapters are gate-ready.** No chapter is blocked. No must-fix-this-iter
finding exists.

---

## Focus-chapter audit

### 1. `Cohomology_FlatBaseChange.tex` — Seam-A routing reconciliation

**complete: yes / correct: yes**

#### Routing narrative consistency

The live chain from Seam A through to the global theorem is fully present and internally
consistent. No superseded or contradictory claim exists. The chain:

```
inner_value_eq (leanok)
  → base_change_mate_fstar_reindex (leanok)          [literal-leg instantiation]
    → base_change_mate_fstar_reindex_legs             [leg-parametrised engine; NO leanok]
        → inner_unitReduce (LEAN INTERNAL, narrative)
        → inner_eCancel_assemble (live target; NO leanok)
            ← [3 atoms, all leanok]:
               inner_eCancel_eUnit
               inner_eCancel_pushforwardComp
               inner_eCancel_pullbackComp
        → base_change_mate_unit_value (leanok, Seam 1)
  → gstar_generator_close (leanok, Seam B)
  → gstar_counit_transport (leanok, Seam C)
  → gstar_transpose (leanok)
  → section_identity (leanok)
  → generator_trace (leanok)
  → cancelBaseChange (leanok)
  → affine_base_change_pushforward (leanok)
  → thm:flat_base_change_pushforward (leanok)
```

Both `lem:base_change_mate_inner_unitReduce` and `lem:base_change_mate_inner_eCancel`
are explicitly annotated `% LEAN INTERNAL: assembly-narrative node with no dedicated Lean
declaration` and have their `\lean` pins pointing to `base_change_mate_fstar_reindex_legs`
(the subsuming theorem). This convention is correctly documented and consistent.

#### `inner_eCancel_assemble` precision assessment

**Finding: the statement is precise enough to formalize.**

`lem:base_change_mate_inner_eCancel_assemble` (lines ~2152–2217) contains:
- Context: leg-parametrised reindex after unit expansion and four-factor Γ-distribution
- Three numbered cancellations, each citing the exact atom and the exact piece of the
  leg-parametrised codomain read it cancels
- Explicit statement of why atoms fire in the `_legs` form but not inline ("legs are carried
  as free parameters and identified with `e ∘ Spec ιA` definitionally")
- Lone survivor named: affine `(Spec ιA)`-unit evaluated by Seam 1 (`base_change_mate_unit_value`)
- `\uses{}` is comprehensive (6 entries covering all three atoms, the codomain-read variant,
  the pushforwardComp identity, and the unit value)

The proof sketch names the exact matching condition ("each atom matches the corresponding
factor on the nose") vs the inline obstruction ("same matching is blocked by a
dependent-motive obstruction"). A prover can implement this directly.

#### `\leanok` status check

- `inner_eCancel_assemble`: NO `\leanok` — **correct, this is the single live Seam-A target**
- `inner_eCancel` (narrative node): NO `\leanok` — correct
- `inner_unitReduce` (narrative node): NO `\leanok` — correct
- Three atom lemmas (`_eUnit`, `_pushforwardComp`, `_pullbackComp`): all `\leanok` — correct
- All remaining Seam B, C, and downstream lemmas: all `\leanok`

#### Must-fix-this-iter findings: NONE

The blueprint-clean subagent cleared all leakage. No superseded-code language remains.
One minor observation (not blocking): `lem:pushforward_base_change_mate_cancelBaseChange`
carries a NOTE that its Lean decl formalizes the `IsIso (Γ(α))` corollary, not the literal
equality; this honest limitation is documented inline and the prover already has `\leanok`.

---

### 2. `Picard_QuotScheme.tex` — Route-F G1-core + G1-assemble

**complete: yes / correct: yes**

#### Route-F proof completeness

`lem:qcoh_affine_section_localization` (G1-core) carries a full three-field
`IsLocalizedModule` proof sketch (lines ~2683–2751):

- **Step 1 (manual core)**: "From the quasi-coherence datum extract a finite basic-open
  tilde cover" — explicitly noted as "the only manual ingredient also present in the
  equalizer route." Uses `isIso_fromTildeΓ_of_presentation_mathlib` + `isLocalizedModule_tilde_restrict`.
- **map_units**: via `isUnit_res_basicOpen_mathlib` — one-line argument, correct.
- **surj**: compact-open induction (`compact_open_induction_mathlib`); base case = affine
  tilde localization (step 1); inductive step = sheaf MV pullback + unique gluing.
- **exists_of_eq**: same compact-open induction; base = affine tilde localization;
  inductive step = uniqueness half of `eq_of_locally_eq'`.

The structure mirrors `isLocalization_basicOpen_of_qcqs` exactly as documented. No equalizer
object, no flatness. The proof is **complete and logically correct**.

Step 1 is **correctly identified as the manual core**: it is the only place that unpacks
the quasi-coherence datum beyond what Mathlib provides directly.

#### gap1 (`lem:qcoh_affine_isIso_fromTildeΓ`) non-re-pointing

`\lean{AlgebraicGeometry.Scheme.Modules.isIso_fromTildeΓ_of_isQuasicoherent}` — this is
a new declaration that does NOT yet exist. The NOTE confirms: "the Lean decl does NOT yet
exist." The `\lean` pin has NOT been re-pointed to any existing declaration. ✓

`\uses{lem:qcoh_affine_section_localization, lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict}` — gap1
correctly feeds G1-core into the new G1-assemble reduction node.

The gap1 proof sketch (3 lines): G1-core provides `IsLocalizedModule(powers f)` for every f;
feeding this into G1-assemble (`lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict`) gives
`IsIso M.fromTildeΓ`. Correct and minimal.

#### G1-assemble subsection (4 bridge nodes)

All 4 new bridge nodes present (lines ~2785–2928):

| Node | `\lean{}` | `\uses{}` | Proof sketch | Assessment |
|------|-----------|-----------|--------------|------------|
| `lem:bijective_comp_of_localizations` | `bijective_comp_of_localizations` | linearEquiv + linearMap_ext | h agrees with canonical localization iso by uniqueness | correct |
| `lem:isIso_sheaf_of_isIso_app_basicOpen` | `isIso_sheaf_of_isIso_app_basicOpen` | isBasis + stalkFunctor_injective + isIso_of_stalk | per-basic-open bijection → stalk isomorphism → sheaf iso | correct (minor: surjectivity on stalks stated as "lifting germs", sound but could be more explicit) |
| `lem:isIso_fromTildeΓ_of_isLocalizedModule_restrict` | `isIso_fromTildeΓ_of_isLocalizedModule_restrict` | 3 Mathlib anchors | each D(f) component is bijective via bijective_comp; upgrade to sheaf iso; fully-faithful reflection | correct |
| `lem:isIso_fromTildeΓ_iff_isLocalizedModule_restrict` | same biconditional name | the two directions | forward = restrict_of_isIso; reverse = of_isLocalizedModule_restrict | correct |

None of the 4 bridge nodes has `\leanok` — **correct, they are new obligations**.

#### Route-F Mathlib anchors

8 new `\mathlibok` anchors added for Route F (lines ~2594–2682):
`isLocalization_basicOpen_of_qcqs_mathlib`, `isLocalizedModule_constructor_mathlib`,
`isUnit_res_basicOpen_mathlib`, `isIso_fromTildeΓ_of_presentation_mathlib`,
`compact_open_induction_mathlib`, `isLimitPullbackCone_mathlib`,
`existsUnique_gluing_mathlib`; and 5 G1-assemble anchors:
`isBasis_basic_opens_mathlib`, `stalkFunctor_map_injective_of_isBasis_mathlib`,
`isIso_of_stalkFunctor_map_iso_mathlib`, `isLocalizedModule_linearEquiv_mathlib`,
`isLocalizedModule_linearMap_ext_mathlib`.

All carry `\mathlibok` and `\lean{}` pins to real Mathlib names. ✓

#### Pre-existing noted gaps (not this iter's concern)

- `def:sectionGradedRing`: NOTE "blocked on absence of tensor products for sheaves of
  modules in Mathlib at the pinned commit." Pre-existing blocker; unchanged.
- `lem:qcoh_section_localization_basicOpen` (general-scheme keystone): NOTE says decl
  does not exist; reduces via gap1 + gap2 transport. Correctly documented as downstream of gap1.
- `thm:grassmannian_representable`: NOTE "proof blocked on strengthening
  `thm:relative_spec_univ` to deliver a RepresentableBy witness." Pre-existing deferred question.

#### Must-fix-this-iter findings: NONE

---

### 3. `Picard_GrassmannianCells.tex` — Scheme-level glue-data layer

**complete: yes / correct: yes**

#### `def:gr_glued_scheme` prover-readiness

The construction paragraph (lines ~1297–1391) names:
- **Glue vehicle**: `Scheme.GlueData` (Mathlib)
- **Objects**: charts `U^I` = `def:gr_affine_chart` (one per size-d subset I)
- **Overlaps**: `U^I_J` = `def:gr_chart_overlap`
- **Inclusions f**: `def:gr_chart_incl`; self-inclusion identity via `lem:gr_chartIncl_self_isIso`
- **Transitions t**: `def:gr_chart_transition`; self-transition identity via `lem:gr_chartTransition_self`
- **t' (triple-overlap cocycle)**: constructed via `def:gr_away_pullback_iso` + `Spec Θ_{I,J}`
  + `def:gr_away_mul_comm_equiv` + inverse pullback iso
- **t_fac** (compatibility with projections) and cocycle condition: named

`\uses{}` references all 11 bridge blocks. `\lean{AlgebraicGeometry.Grassmannian.scheme}`.
**Assessment: prover-ready.**

#### New section "Scheme-level glue-data layer"

11 bridge blocks: all have `\lean{}` pins and proof sketches. 4 Mathlib anchors with
`\mathlibok`. Verifications:
- `lem:mathlib_specMap_localizationAway_isOpenImmersion` → `AlgebraicGeometry.Scheme.isOpenImmersion_SpecMap_localizationAway` ✓
- `lem:mathlib_pullbackSpecIso` → `AlgebraicGeometry.pullbackSpecIso` ✓
- `lem:mathlib_isLocalization_away_mul` → `IsLocalization.Away.mul'` (prime suffix; should be verified against Mathlib at build time)
- `lem:mathlib_isLocalization_algEquiv` → `IsLocalization.algEquiv` ✓

#### Minor rendering anomaly (not blocking)

`lem:gr_minorDet_self` uses `\begin{theorem}` environment instead of `\begin{lemma}`.
Blueprint-doctor reports no broken refs (the label works regardless of environment type),
but this is a cosmetic inconsistency for the rendered web view. Recommend: change to
`\begin{lemma}` in a future cleanup pass (not this iter's prover concern).

#### Must-fix-this-iter findings: NONE

---

## Remaining chapters

### `Cohomology_RegroupHelper.tex`

**complete: yes / correct: yes**

Single lemma `lem:base_change_regroup_linearEquiv` + proof, both `\leanok`. Feeds
`lem:base_change_mate_regroupEquiv` in FlatBaseChange. Clean, minimal, stable.

### `Picard_RelativeSpec.tex`

**complete: yes / correct: yes**

Mature chapter. Key declarations (`thm:relative_spec_exists`, `def:relspec_structure_morphism`,
`thm:relative_spec_univ`) all carry `\leanok`. NOTE on `thm:relative_spec_univ`: iter-283
removed a `thm:relative_spec_base_change` dependency cycle. `thm:grassmannian_representable`
in QuotScheme consumes this chapter; the "RepresentableBy witness" open question is noted.

### `Picard_FlatteningStratification.tex`

**complete: yes / correct: yes**

`thm:generic_flatness_algebraic` NOTE says "CLOSED, axiom-clean" as of iter-022. The
`\leanok` marker should be present on the statement but its appearance depends on
`sync_leanok` — not an agent concern. The overall chapter structure is sound; the algebraic
and geometric forms of generic flatness are present.

---

## Dependency graph integrity (`leandag`)

Tool: `.leandag/dag.json` (272 nodes, 526 edges).

| Metric | Count | Assessment |
|--------|-------|------------|
| Isolated nodes | **0** | ✓ no orphans |
| Unknown uses | **0** | ✓ all `\uses{}` resolve |
| Broken refs | **0** (blueprint-doctor) | ✓ |
| Malformed refs | **0** (blueprint-doctor) | ✓ |
| Unmatched lean | 62 | expected — see below |
| Axiom decls | **0** | ✓ no new axioms |

The 62 unmatched lean entries decompose as:
- ~45 are `\mathlibok` Mathlib anchor nodes; they legitimately reference Mathlib names
  not present in the project's Lean files (the leandag matcher runs against the project,
  not Mathlib).
- ~7 are project nodes that are live obligations this or recent iters:
  `lem:qcoh_affine_section_localization`, `lem:qcoh_affine_isIso_fromTildeΓ`,
  `lem:qcoh_section_localization_basicOpen`, `def:gr_glued_scheme`, `lem:gr_separated`,
  `lem:gr_proper`, `lem:gf_flat_locality_assembly`.
- ~10 are blocked/deferred project nodes: `def:sectionGradedRing`,
  `thm:hilbertPoly_of_sectionModule`, `def:sectionGradedModule`, etc.

No action required this iter.

---

## Rendering integrity (`archon blueprint-doctor`)

Output:
- `orphan_chapters`: [] ✓
- `broken_refs`: [] ✓
- `malformed_refs`: [] ✓
- `axiom_decls`: [] ✓
- `covers_problems`: [] ✓
- `labels_defined_count`: 308

**Clean.**

---

## Cross-chapter issues

1. **`lem:gr_minorDet_self` environment** (GrassmannianCells): `\begin{theorem}` instead
   of `\begin{lemma}`. Low priority; no prover impact.

2. **`lem:mathlib_isLocalization_away_mul` Lean name has a prime**: `IsLocalization.Away.mul'`.
   Blueprint-doctor showed no broken ref (label syntax is fine). Should be verified against
   Mathlib at actual build time. Low priority.

3. **`thm:grassmannian_representable` mismatch**: the `\lean` pin points to a weakened
   existence skeleton that "omits smoothness, properness, relative dimension d(r-d), the
   tautological rank-d quotient, and the Plücker embedding" (per NOTE in QuotScheme). The
   prose statement is full. This mismatch is pre-existing and documented; the NOTE says the
   decl "should be strengthened or split." Not this iter's blocking concern.

4. **`def:sectionGradedRing` (QuotScheme): blocked** on absence of sheaf tensor products in
   Mathlib. Pre-existing; no blueprint fix available until Mathlib is extended.

---

## Unstarted-phase blueprint proposals

Two STRATEGY phases have zero blueprint coverage. Per the blueprint-reviewer charter, these
are concrete writer directive seeds (not informational).

### Proposal A: FBC-B chapter — H⁰-as-equalizer packaging

**Phase**: FBC-B (NEXT, 2–5 iters after FBC-A completes)
**Current status**: No chapter; no LaTeX.
**Content**:
- `thm:flat_base_change_pushforward` (present in FlatBaseChange) establishes the i=0 case
  using a finite equalizer argument (the proof sketch is already written in FlatBaseChange).
- The FBC-B phase packages the i>0 higher cohomology case: Čech-to-cohomology spectral
  sequence, Leray, and the higher-degree base-change isomorphism.
- Blocking on FBC-A closing (`inner_eCancel_assemble`); but the chapter can be written now.
**Proposed chapter slug**: `Cohomology_FlatBaseChange_Higher.tex` (or extend the existing
FlatBaseChange chapter with a new section "Higher cohomology base change").
**Core nodes needed**: `thm:flat_base_change_higher`, `lem:cech_cohomology_qcqs`,
`lem:cech_to_cohomology_spectral_sequence`, `lem:affine_acyclic`.

### Proposal B: SNAP-S1/S3 chapter — Snapper's Lemma and polynomial Euler characteristic

**Phase**: SNAP-S1/S3 (NEXT, 3–6 iters, currently GATED on QUOT-defs keystone)
**Current status**: `def:hilbert_polynomial` in QuotScheme carries a NOTE: "Snapper's Lemma
-- cited via Nitsure §1 and Hartshorne III.5.2; Lean formalization is a prerequisite sub-task."
There is no chapter for this material.
**Content**:
- Snapper's Lemma: the Euler characteristic χ(X, F⊗L^n) is eventually a polynomial in n
  (for L ample, F coherent on a projective variety over a field).
- Polynomial Euler characteristic for projective space.
- Hilbert polynomial as the eventual polynomial.
**Proposed chapter slug**: `Cohomology_SnapperLemma.tex`
**Core nodes needed**: `thm:snapper_lemma`, `lem:euler_characteristic_polynomial`,
`lem:hilbert_polynomial_projective`, linking to the existing `def:hilbert_polynomial`.

---

## Severity summary

| Severity | Finding | Chapter | Action |
|----------|---------|---------|--------|
| INFO | `lem:gr_minorDet_self` uses `\begin{theorem}` not `\begin{lemma}` | GrassmannianCells | cleanup pass (future) |
| INFO | `IsLocalization.Away.mul'` prime in Lean name; verify at build time | GrassmannianCells | verify when prover runs |
| INFO | `thm:grassmannian_representable` Lean decl underpowers prose | QuotScheme | pre-existing; strengthen later |
| INFO | `def:sectionGradedRing` blocked on Mathlib tensor products | QuotScheme | pre-existing; unblockable now |
| PROPOSAL | FBC-B chapter not yet written | (new) | writer dispatch recommended |
| PROPOSAL | SNAP-S1/S3 chapter not yet written | (new) | writer dispatch recommended (gated) |

No BLOCKING or MUST-FIX items. All three focus chapters clear the HARD GATE.

---

## Overall verdict

All three focus chapters are **complete: yes / correct: yes** and gate-ready for prover dispatch:

- **FBC-A lane**: `inner_eCancel_assemble` is the single remaining Seam-A target; it is
  precisely stated and the three helper atoms are already `\leanok`. The FBC-A prover may
  proceed.
- **QUOT-defs lane**: G1-core Route-F proof is complete and correct; step 1 is the manual
  core; gap1 non-re-pointing confirmed. The QUOT-defs mathlib-build prover may proceed.
- **GR-glue lane**: `def:gr_glued_scheme` has full glue-data field specification and
  references all 11 bridge blocks. The GR-glue prover may proceed.
