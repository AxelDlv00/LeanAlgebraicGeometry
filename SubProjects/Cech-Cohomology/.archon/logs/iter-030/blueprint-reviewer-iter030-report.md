# Blueprint Review — iter-030 HARD GATE Report

**Chapter scope**: All 3 chapters under `blueprint/src/chapters/`
**Directive**: Whole-blueprint audit; HARD GATE on `Cohomology_CechHigherDirectImage.tex`
**Tool runs**: `leandag build --json` (clean), `archon blueprint-doctor --json` (clean)

---

## leandag summary

| Metric | Value |
|---|---|
| Blueprint nodes | 113 |
| Edges | 252 |
| Proved (`\leanok`) | 34 (30.1%) |
| Mathlib-backed | 18 |
| With sorry | 2 |
| Unknown `\uses{}` | **0** |
| Conflicts | **0** |
| Isolated | 1 (lean\_aux, not a blueprint node) |
| Unmatched `\lean{}` | 34 (all Mathlib anchors or unformalized future decls) |

`unknown_uses: []` — every `\uses{}` label resolves to an existing blueprint node. No broken edges.

---

## blueprint-doctor summary

```json
{
  "orphan_chapters": [],
  "broken_refs": [],
  "malformed_refs": [],
  "axiom_decls": [],
  "covers_problems": []
}
```
All clear. All 3 chapters included in `content.tex`. No rendering errors.

---

## Per-chapter review

### `Cohomology_HigherDirectImage.tex`

Single declaration `def:higher_direct_image` (`\leanok`, `\lean{AlgebraicGeometry.higherDirectImage}`).
**Status: COMPLETE.** No issues.

---

### `Cohomology_AcyclicResolution.tex`

Covers `AcyclicResolution.lean`. Full block set for horseshoe lemma, dimension shift, cosyzygies,
`lem:acyclic_resolution_computes_derived`. Previously audited and confirmed clean.
**Status: COMPLETE.** No changes this iter, no issues.

---

### `Cohomology_CechHigherDirectImage.tex` — HARD GATE

#### GATE TARGET G1: `lem:injective_cech_acyclic` (family-form re-parameterization)

**Statement completeness and correctness:**

The blueprint block explicitly states the lemma for *an arbitrary finite family of opens
`{ι}[Finite ι](U : ι → Opens X)` with **no covering hypothesis***. The two-part proof sketch is
present and internally coherent:
- Part 1 (injective presheaf transfer): injection `I → toPresheafOfModules I` is adjoint-injective
  (`lem:injective_of_adjoint` + `lem:mod_pmod_adjunction`).
- Part 2 (vanishing via free complex): the quasi-iso `cechFreeComplexAug` → transfer the injective
  exactness via `lem:cech_free_complex_quasi_iso` + `lem:hom_into_injective_exact`.

**`\lean{}` pin**: `AlgebraicGeometry.injective_cech_acyclic, AlgebraicGeometry.injective_toPresheafOfModules`.
Both declarations are **matched** in the project (not in the unmatched_lean list).

**`\uses{}`**: 9 deps — all resolve (unknown_uses: []).

**`\leanok` status**: NOT present (dag: `proved: false`). This is **intentional and correct**:
the blueprint was re-written for the family form by blueprint-writer; the current Lean code still
uses the old `X.OpenCover`-parameterized signature:
```lean
theorem injective_cech_acyclic (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (I : X.Modules) [Injective I]
    (p : ℕ) (hp : 0 < p) :
    IsZero ((sectionCechComplex (coverOpen 𝒰) ...) ...)
```
The iter-030 prover lane (`FreePresheafComplex.lean`) will re-parameterize this to the family form.
`sync_leanok` will restore `\leanok` once the re-parameterized proof compiles.

**`def:affine_cover_system`**: Correctly uses `lem:injective_cech_acyclic` directly for its
`injective_acyclic` field. No intermediate `lem:affine_injective_acyclic` wrapper. ✓

**VERDICT: FORMALIZE-READY.** Blueprint is correct and complete for the re-parameterization. The
prover lane can proceed directly from the blueprint statement.

---

#### GATE TARGET G2: `lem:qcoh_iso_tilde_sections` (01I8 conditional form)

**Statement correctness:** Conditional form `[IsIso F.fromTildeΓ]`. Correctly documented as a
project-conditional form pending the 01I8 instance. `\leanok` present. ✓

**`\lean{}` pins**: 3 declarations
(`qcoh_iso_tilde_sections`, `qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv`).
All matched. Lean source confirmed axiom-clean:
```lean
noncomputable def qcoh_iso_tilde_sections (F : (Spec R).Modules) [IsIso F.fromTildeΓ] :
    F ≅ tilde (moduleSpecΓFunctor.obj F) :=
  (asIso F.fromTildeΓ).symm
```

**`\uses{}`**: `{def:standard_affine_cover, lem:qcoh_iso_tilde_sections_of_presentation}`.

⚠️ **ANNOTATION (non-blocking)**: The inclusion of `lem:qcoh_iso_tilde_sections_of_presentation`
in `lem:qcoh_iso_tilde_sections`'s `\uses{}` is **spurious**. The Lean proof of
`qcoh_iso_tilde_sections` is a one-liner `(asIso F.fromTildeΓ).symm` that uses neither
`qcoh_iso_tilde_sections_of_presentation` nor `def:standard_affine_cover`. The `\uses{}`
over-declares: the blueprint proof text *mentions* the presentation form as context, but neither
declaration is a proof dependency. This creates a **`\uses{}` cycle** in the blueprint graph:

```
lem:qcoh_iso_tilde_sections → lem:qcoh_iso_tilde_sections_of_presentation
lem:qcoh_iso_tilde_sections_of_presentation → lem:qcoh_iso_tilde_sections
```

Confirmed by `leandag` cycle analysis. Structurally harmless (no broken labels, no unknown_uses),
but semantically incorrect. Recommend removing both `lem:qcoh_iso_tilde_sections_of_presentation`
and `def:standard_affine_cover` from `lem:qcoh_iso_tilde_sections`'s `\uses{}` in a future
blueprint-clean pass. **Does NOT block this iter.**

**VERDICT: FORMALIZE-READY.**

---

#### GATE TARGET G3: `lem:qcoh_iso_tilde_sections_of_presentation` (presentation form)

**Statement correctness:** Proves `F ≅ ~ΓF` for `F` with a global presentation, via
`isIso_fromTildeΓ_of_presentation` (Mathlib) + `lem:qcoh_iso_tilde_sections`. ✓

**`\lean{}` pin**: `AlgebraicGeometry.qcoh_iso_tilde_sections_of_presentation`. Matched; axiom-clean:
```lean
noncomputable def qcoh_iso_tilde_sections_of_presentation (F : (Spec R).Modules)
    (P : F.Presentation) : F ≅ tilde (moduleSpecΓFunctor.obj F) :=
  haveI := isIso_fromTildeΓ_of_presentation F P
  (asIso F.fromTildeΓ).symm
```

**`\leanok` status**: `proved: false` in dag. **Expected**: this block was newly added by
blueprint-writer in iter-030; `sync_leanok` has not run on it yet. The declaration exists with no
sorry; `sync_leanok` will add `\leanok` next phase.

**`\uses{}`**: `{lem:qcoh_iso_tilde_sections, lem:isIso_fromTildeGamma_of_presentation}`.
The `lem:isIso_fromTildeGamma_of_presentation` node has `mathlib_ok: true` — correctly marked
`\mathlibok`. The `lem:qcoh_iso_tilde_sections` edge is the correct dependency direction. ✓

**VERDICT: FORMALIZE-READY.**

---

#### GATE TARGET G4: `rem:o1i8_decomposition` (remark block)

**Completeness:** Present in chapter (lines ~3617–3664). No `\lean{}` tag (correct for a remark).
3-step decomposition: global epi from `QuasicoherentData` → `F.Presentation` → counit iso via
`isIso_fromTildeΓ_of_presentation`. Source citation from Tag 01I8 present. ✓

**`\uses{}`**: 3 labels — `lem:qcoh_iso_tilde_sections`, `lem:qcoh_iso_tilde_sections_of_presentation`,
`lem:isIso_fromTildeGamma_of_presentation`. All exist (unknown_uses: []). ✓

Note: `rem:o1i8_decomposition` does not appear as a DAG node (remarks without `\lean{}` are not
registered as separate nodes). The `\uses{}` edges are still parsed and verified by leandag. ✓

**VERDICT: COMPLETE.**

---

#### Non-gate coherence check: `lem:affine_surj_of_vanishing` / `def:affine_cover_system` (next-iter lane)

As specified in the directive, these are next-iter targets; they gate only at coherence, not
formalization-readiness.

**`lem:affine_surj_of_vanishing`**: 6 `\uses{}` deps:
`lem:ses_cech_h1`, `lem:standard_cover_cofinal`, `lem:to_sheaf_preserves_epi`,
`lem:presheaf_is_locally_surjective`, `lem:sheaf_locally_surjective_iff_epi`,
`lem:scheme_isBasis_affineOpens` — all exist. 3-step proof sketch (local surjectivity via
`toSheaf_preservesEpimorphisms` → refine to standard cover → glue via `ses_cech_h1`) is
mathematically coherent. ✓

**`def:affine_cover_system`**: 5 deps:
`def:basis_cov_system`, `lem:affine_faces_mem`, `lem:affine_surj_of_vanishing`,
`lem:injective_cech_acyclic`, `lem:affine_cech_vanishing_qcoh` — all exist. Correctly uses
`lem:injective_cech_acyclic` (family-form) directly for the `injective_acyclic` field. ✓

**Helper blocks for next-iter** (`lem:to_sheaf_preserves_epi`, `lem:presheaf_is_locally_surjective`,
`lem:sheaf_locally_surjective_iff_epi`, `lem:scheme_isBasis_affineOpens`, `lem:cover_datum_bridge`):
All have `\lean{}` pins and valid `\uses{}` edges. All correctly appear as `unmatched` in leandag
(not yet formalized — expected for next-iter work). ✓

**`\uses{}` acyclicity in this block**: Forward-only dependency chain. No cycles among the
affine surjectivity / cover system declarations (aside from the already-noted
`qcoh_iso_tilde_sections` cycle, which does not involve these blocks). ✓

---

#### Full-chapter scan: additional observations

1. **`def:section_cech_functoriality`** (lines 3744–3764): Has 4 `\lean{}` pins
   (`sectionCechCosimplicialMap`, `sectionCechCosimplicialFunctor`, `sectionCechComplexFunctor`,
   `sectionCechComplexMap`). No `\leanok`. These declarations appear to be unformalized or in a
   future file — consistent with the unmatched count. Non-blocking (not on a gate target). ✓

2. **`lem:short_exact_pi_map`**: No `\leanok` despite being referenced as `\leanok` by downstream
   blocks (`lem:cech_ses_of_basis` proof). Checking dag: `proved: false`. The downstream blocks
   that have `\leanok` include it in `\uses{}` of the proof block (which is fine — the proof block
   `\leanok` doesn't require dependencies to be `\leanok`). Non-blocking. ✓

3. **`lem:cech_to_cohomology_on_basis`**: `proved: true` (`\leanok`). `lean_name`:
   `AlgebraicGeometry.cech_eq_cohomology_of_basis`. ✓

4. **`lem:cech_computes_cohomology`** (the protected target): `proved: true` (`\leanok`).
   `lean_name`: `AlgebraicGeometry.cech_computes_higherDirectImage`. Signature still `Nonempty ...` form. ✓

5. **Two nodes with sorry** (dag: `with_sorry: 2`): These are pre-existing and not in the gate
   targets. No new sorry introduced by blueprint-writer edits. ✓

6. **`lem:affine_cech_vanishing_qcoh`**: `proved: false`, `lean_source: ""` (no Lean yet). Correctly
   unformalized — this is the 02KG affine Serre vanishing result, a future target. Its `\uses{}`
   correctly includes `lem:qcoh_iso_tilde_sections`. ✓

---

## HARD GATE Verdict: ✅ PASS

All four gate targets clear:

| Gate | Target | Blueprint | Lean | Verdict |
|---|---|---|---|---|
| G1 | `lem:injective_cech_acyclic` (family-form) | COMPLETE + CORRECT | Old form exists; re-param is this iter | FORMALIZE-READY |
| G2 | `lem:qcoh_iso_tilde_sections` | COMPLETE + CORRECT | `\leanok`, axiom-clean | FORMALIZE-READY |
| G3 | `lem:qcoh_iso_tilde_sections_of_presentation` | COMPLETE + CORRECT | axiom-clean; sync_leanok pending | FORMALIZE-READY |
| G4 | `rem:o1i8_decomposition` | COMPLETE | n/a (remark) | COMPLETE |

Non-gate coherence (next-iter `affine_surj_of_vanishing` / `affineCoverSystem`): `\uses{}` acyclic,
all labels resolve. ✓

---

## Must-fix findings (blocking)

**None.** All gate targets pass. The `\uses{}` cycle between `lem:qcoh_iso_tilde_sections` and
`lem:qcoh_iso_tilde_sections_of_presentation` is non-blocking and non-structural.

---

## Should-fix findings (non-blocking)

1. **`\uses{}` cycle / over-declaration** on `lem:qcoh_iso_tilde_sections`: Remove
   `lem:qcoh_iso_tilde_sections_of_presentation` (and possibly `def:standard_affine_cover`) from
   its `\uses{}`. The Lean proof is a one-liner with no such dependency. Queue for next
   blueprint-clean pass.

---

## Unstarted-phase blueprint gaps

The following Lean files have no corresponding blueprint content yet (outside the scope of iter-030
but noted for planning):

- `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` — `lem:affine_serre_vanishing` block is
  present in the chapter (`unmatched` → not yet formalized). Blueprint is written; Lean file is the
  active next-phase work.
- `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean` — `def:absolute_cohomology` and companions
  are `\leanok` (in the dag). ✓
- P5a (`lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`,
  `lem:cech_augmented_resolution`) — blueprint present (no `\leanok`), Lean files unstarted.
  These are the P5a lane targets.

No unstarted-phase gap affects the iter-030 gate.
