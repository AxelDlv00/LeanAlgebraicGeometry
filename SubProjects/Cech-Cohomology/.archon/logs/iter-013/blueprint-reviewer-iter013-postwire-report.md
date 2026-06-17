# Blueprint Review Report

## Slug
iter013-postwire

## Iteration
013

## Focus: structural-edit faithfulness audit

This iteration's review is targeted: the DAG agent made purely structural
edits (no math-content changes) to fix two leandag gate gaps. The full
blueprint is audited as required; focus findings address the two structural
changes.

---

## Structural-edit faithfulness

### 1. Statement-level `\uses` mirroring (connectivity fix)

**`lem:injective_cech_acyclic`** — added to statement `\uses{}`:
`def:section_cech_complex`, `lem:cech_complex_hom_identification`,
`lem:cech_free_complex_quasi_iso`, `lem:injective_of_adjoint`,
`lem:mod_pmod_adjunction`.

Reading the proof block (lines ~1054–1089):
- Part 1 invokes the sheafification adjunction (`lem:mod_pmod_adjunction`)
  and Lemma `lem:injective_of_adjoint` to transfer injectivity from
  sheaves to presheaves.
- Part 2 invokes `lem:cech_free_complex_quasi_iso` to get the free-presheaf
  resolution, `lem:cech_complex_hom_identification` to identify
  `Hom(K(U)•, I)` with the section Čech complex, and
  `def:section_cech_complex` for the target of that identification.

All five additions are **genuine mathematical dependencies of the proof**.
**FAITHFUL.** ✓

**`lem:cech_to_cohomology_on_basis`** — added to statement `\uses{}`:
`lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:cech_acyclic_affine`.

Reading the proof block (lines ~1333–1390):
- `lem:injective_cech_acyclic` is explicitly cited to supply Čech vanishing
  for the injective embedding `F → I`.
- `lem:ses_cech_h1` is cited to obtain section-level exactness from `Ȟ¹ = 0`.
- `lem:cech_acyclic_affine` is cited as condition (3) of the basis criterion
  on the affine instantiation.

All three additions are **genuine mathematical dependencies of the proof**.
**FAITHFUL.** ✓

**DAG outcome (confirmed by `leandag build --json`):**
- `isolated`: **0** (was positive before fix — the 8 severed P3b nodes and
  2 `\mathlibok` anchors are now connected to the goal cone).
- `unknown_uses`: **0** (no broken `\uses{}` edges).

---

### 2. Helper bundling (1-to-1 coverage fix)

Checked each bundled group against the named mathematical content:

| Bundle target | Helpers added | Verdict |
|---|---|---|
| `def:push_pull_map` | `rawPushPullMap`, `pushPullMap_eq_raw`, `rawPushPullMap_self`, `rawPushPullMap_self_gen`, `pushforwardComp_hom_app_id`, `pushPull_unit_comp` | Raw/alternate forms of the comparison map. **Appropriate.** ✓ |
| `lem:push_pull_comp` | `rawPushPullMap_comp`, `pushPull_pentagon` | Raw composition form + pentagon coherence that drives it. **Appropriate.** ✓ |
| `def:cover_cech_nerve` | `coverCechNerveOver`, `coverCechNerveOverAug` | Over-category and augmented variants of the Čech nerve. **Appropriate.** ✓ |
| `lem:horseshoe_twist` | `horseshoeτ`, `horseshoeτ_cocycle`, `horseshoeβ`, `twistPair`, `horseshoeβ₁`, `f_comp_horseshoeβ₁`, `horseshoeH`, `g_comp_horseshoeH`, `horseshoeH_comp_d`, `horseshoeτZero`, `horseshoeτZero_hf`, `horseshoeτ_zero`, `horseshoeβ_comp_d`, `horseshoeβ_fst`, `horseshoeβ_snd`, `ιC0`, `ιC0_comp_d`, `ιC0_comp_τZero`, `ιC_comp_horseshoeτZero` | The τ (twist), β (augmentation) and ιC₀ helper infrastructure for the off-diagonal construction. All are pieces of the twist/augmentation computation. **Appropriate.** ✓ |
| `lem:horseshoe_dComp` | `twistedBiprodD_comp` | The squared-differential computation. Single helper, correct home. **Appropriate.** ✓ |
| `lem:horseshoe_chainMap` | `twistedBiprodInl`, `twistedBiprodSnd`, `twistedBiprodSplitting`, `horseshoeSES_shortExact`, `horseshoeMid`, `horseshoeSES`, `horseshoeSES_splitting`, `horseshoeι`, `horseshoeι_f_zero`, `mono_horseshoeβ`, `twistedBiprod`, `twistedBiprod_X`, `twistedBiprod_d`, `twistedBiprodD`, `twistedBiprodD_fst`, `twistedBiprodD_snd`, `twistedBiprodInl_f`, `twistedBiprodSnd_f`, `twistedBiprodInl_comp_Snd` | The twisted biproduct type, its projections/coprojections, and the short-exact-sequence data proving chain-map compatibility. All plumbing for `lem:horseshoe_chainMap`. **Appropriate.** ✓ |
| `lem:horseshoe_resolvesMiddle` | `ofShortExact_resolvesMiddle`, `horseshoeφ`, `horseshoeφ_comm₁₂`, `horseshoeφ_comm₂₃`, `horseshoeφ_τ₁`, `horseshoeφ_τ₂`, `horseshoeφ_τ₃`, `quasiIso_horseshoeι`, `single₀_hom_ext` | The morphism-of-SES data (φ and its commutation components), the quasi-iso transfer, and the degree-0 uniqueness. All required for proving the middle complex resolves B. **Appropriate.** ✓ |

No helper was placed under a wrong declaration. **All bundles correct.** ✓

---

## `\mathlibok` anchor faithfulness

Verified newly-connected anchors exist in Mathlib source under `.lake/packages/mathlib/`:

| Anchor label | Lean name | Mathlib file | Verdict |
|---|---|---|---|
| `def:standard_affine_cover` | `AlgebraicGeometry.Scheme.affineOpenCoverOfSpanRangeEqTop` | `AlgebraicGeometry/Cover/Open.lean` | ✓ exists |
| `lem:injective_of_adjoint` | `CategoryTheory.Injective.injective_of_adjoint` | `CategoryTheory/Preadditive/Injective/Basic.lean` | ✓ exists |
| `lem:mod_pmod_adjunction` | `PresheafOfModules.sheafificationAdjunction` | `Algebra/Category/ModuleCat/Presheaf/Sheafification.lean` | ✓ exists |
| `lem:right_derived_injective_resolution` | `CategoryTheory.InjectiveResolution.isoRightDerivedObj` | `CategoryTheory/Abelian/RightDerived.lean` | ✓ exists |
| `lem:right_derived_zero_iso_self` | `CategoryTheory.Functor.rightDerivedZeroIsoSelf` | `CategoryTheory/Abelian/RightDerived.lean` | ✓ exists |

All `\mathlibok` anchors checked are faithful. ✓

---

## Per-chapter

### blueprint/src/chapters/Cohomology_AcyclicResolution.tex
- **complete**: true
- **correct**: true
- **notes**:
  - P4 (Leray acyclicity lemma) fully formalized; all `\leanok` markers are
    in place. Mathlib anchors (`lem:right_derived_injective_resolution`,
    `lem:right_derived_vanishes_injective`, `lem:right_derived_zero_iso_self`,
    `lem:homology_long_exact_sequence`, `lem:horseshoe_biprod_injective`,
    `lem:horseshoe_degree_split`) verified as valid Mathlib declarations.
    Helper bundles under `lem:horseshoe_twist`, `lem:horseshoe_chainMap`,
    `lem:horseshoe_resolvesMiddle` are mathematically appropriate.
    No issues.

### blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex
- **complete**: true
- **correct**: true
- **notes**:
  - All declarations for P1 (push-pull functor laws), P2 (CechNerve/CechComplex),
    P3 (standard-cover Čech vanishing), P3b (presheaf Čech machinery, injective
    acyclicity, Serre vanishing), P5a (presheaf description of R^i f_*, open
    immersion acyclicity, Čech-term acyclicity), and P5b (main theorem
    `lem:cech_computes_cohomology`) are present with detailed proof sketches.
  - P1/P2/P3 lemmas carry `\leanok`; P3b/P5a/P5b are not yet formalized —
    expected per BLOCKED status, not a blueprint gap.
  - `lem:cech_computes_cohomology` carries `\leanok` with `sorry` — expected
    per known issues.
  - The structural `\uses` additions confirmed faithful (focus finding above).
  - Helper bundles for push-pull map and composition confirmed appropriate.
  - Source citations reference `references/stacks-coherent.tex` and
    `references/stacks-cohomology.tex` — both files exist. Citation discipline
    uses `.tex` extension (the project's actual content files) rather than `.md`
    (summary files); all referenced files exist, no fabrication.

### blueprint/src/chapters/Cohomology_HigherDirectImage.tex — complete + correct, no notes.

---

## Dependency & isolation findings

`leandag build --json` reports:
- `unknown_uses`: 0 (no broken `\uses{}` edges)
- `isolated`: 0 (no blueprint nodes with missing edges)
- `unmatched_lean`: 24 — all expected: 9 are `\mathlibok` Mathlib declarations
  (correctly not present in the project's Lean source), 15 are project
  declarations for BLOCKED phases (P3b/P5a/P5b) not yet scaffolded.

`archon blueprint-doctor --json` reports: `malformed_refs: []`, `broken_refs: []`,
`orphan_chapters: []`, `covers_problems: []`. No rendering issues.

---

## Strategy-phase coverage

All four active phases have adequate blueprint coverage:
- P3 (`lem:cech_acyclic_affine`): present in `Cohomology_CechHigherDirectImage.tex` ✓
- P3b (presheaf bridge → `lem:affine_serre_vanishing`): 5 declaration blocks present ✓
- P5a (vanishing inputs: presheaf description, open-immersion, Čech-term): 3 blocks present ✓
- P5b (`lem:cech_computes_cohomology`): present ✓

No unstarted phases — `## Unstarted-phase blueprint proposals` section omitted.

---

## Severity summary

Severity summary: HARD GATE CLEARS — no findings.

**Overall verdict**: The two structural edits are mathematically faithful —
the added statement-level `\uses` mirror genuine proof dependencies in both
amended lemmas, and every helper is bundled under a mathematically related
declaration. The blueprint DAG is fully connected (0 isolated nodes, 0 broken
edges), rendering is clean, and all active phases have adequate blueprint
coverage. HARD GATE CLEARS for all three chapters.
