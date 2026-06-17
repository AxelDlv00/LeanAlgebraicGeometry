# Blueprint Audit Report

**slug**: blueprint-reviewer-iter025
**iteration**: 025
**date**: 2026-06-07
**reviewer**: blueprint-reviewer subagent

---

## Tool outputs (reproduced)

**`leandag build --json` summary**

```
blueprint_nodes: 81  |  proved: 21  |  mathlib_ok: 15  |  with_sorry: 2
edges: 170  |  isolated: 0  |  unknown_uses: 0  |  unmatched_lean: 28
```

- Zero isolated nodes — DAG is fully connected.
- Zero unknown_uses — no broken `\uses{}` cross-references.
- 28 unmatched_lean — all are declarations that carry `\lean{...}` hints but no `\leanok` yet; expected for unproven blocks.

**`archon blueprint-doctor --json` findings**

```
orphan_chapters: []
broken_refs:    []
malformed_refs: [
  { chapter: Cohomology_CechHigherDirectImage.tex,
    kind: "undefined-macro",
    reason: "\\restriction is used but defined nowhere (macros/*.tex or a chapter-local \\providecommand)" }
]
axiom_decls: []
covers_problems: []
```

One `undefined-macro` finding; all other checks clean.

---

## Per-chapter verdicts

### `Cohomology_HigherDirectImage.tex`

**complete: true | correct: true**

Intentionally minimal (57 lines); contains only `def:higher_direct_image` with `\leanok`. Statement is the standard right-derived pushforward, citing Stacks. No findings.

---

### `Cohomology_AcyclicResolution.tex`

**complete: true | correct: true**

Comprehensive coverage (1052 lines) for the completed P4 phase (`AcyclicResolution.lean`). All declarations present: horseshoe lemma, dimension shift, cosyzygy tower, comparison theorem `lem:rightDerivedIsoOfAcyclicResolution`. `\leanok` on all proved blocks; `\mathlibok` on all Mathlib anchors. `\uses{}` chains correct throughout. No findings.

---

### `Cohomology_CechHigherDirectImage.tex`

**complete: true | correct: true**

The main chapter (3632 lines), covering 6 Lean files across P3/P3b/P5a/P5b. All phase-landmark declarations are present with source quotes, `\uses{}` chains, and proof sketches. One must-fix rendering finding; no semantic errors.

#### HARD GATE: `lem:injective_cech_acyclic` (~L2583)

**GATE CLEARS — complete + correct + formalize-ready.**

Detailed assessment:

- **Statement**: Faithful to Stacks `lemma-injective-trivial-cech`. Ringed-space hypothesis, injective O_X-module `ℐ`, arbitrary open covering `𝒰`. Conclusion: Čech cohomology concentrated in degree zero (`Ȟ^0=ℐ(U)`, `Ȟ^p=0` for `p>0`). Source-quoted verbatim from Stacks.

- **`\uses{}` completeness**: 9 deps listed — `def:cech_complex`, `def:section_cech_complex`, `lem:cech_complex_hom_identification`, `lem:cech_free_complex_quasi_iso`, `lem:injective_of_adjoint`, `lem:mod_pmod_adjunction`, `lem:cech_complex_op_identification`, `lem:section_cech_complex_mapop_iso`, `lem:hom_into_injective_exact`. Both gate dependencies carry `\leanok`:
  - `lem:cech_free_complex_quasi_iso` — `\leanok` present (FreePresheafComplex iter-022)
  - `lem:ses_cech_h1` — `\leanok` present (CechBridge iter-024)

- **Proof sketch**: Two explicit parts plus categorical-assembly paragraph.
  - *Part 1*: Injective sheaf → injective presheaf, via `lem:mod_pmod_adjunction` + `lem:injective_of_adjoint` (sheafification is exact left adjoint). Named Lean identifiers cited: `sheafificationAdjunction`, `Injective.injective_of_adjoint`.
  - *Part 2*: Free-complex resolution + Hom-exact. `K(𝒰)_•` resolves `O_𝒰` by `lem:cech_free_complex_quasi_iso`; applying the exact functor `Hom(-,ℐ)` (Part 1) to the augmented exact complex, and using `lem:cech_complex_hom_identification`, yields the Čech complex exact in positive degrees.
  - *Categorical assembly*: Op-transport via `HomologicalComplex.op`; `quasiIso_map_preadditiveYoneda_of_injective` (from `lem:hom_into_injective_exact`); transported across `homCechComplexMapOpIso` (`lem:cech_complex_op_identification`) and `sectionCechComplexMapOpIso` (`lem:section_cech_complex_mapop_iso`). The assembly avoids `presheafModules_enoughInjectives` and the δ-functor route — consistent with the direct-route directive in STRATEGY.md.

- **`\lean{}` hints**: `AlgebraicGeometry.injective_cech_acyclic, AlgebraicGeometry.injective_toPresheafOfModules`. Names are plausible given the file split (CechBridge.lean); no local-search conflict.

- **Note (informational)**: `lem:injective_cech_acyclic` has no `\leanok` yet — correct; the sync_leanok phase sets that after the prover lands the declaration.

#### `def:absolute_cohomology` + six `\mathlibok` anchors

All six Lean names verified against Mathlib `.lake` cache:

| anchor label | `\lean{}` name | verified location |
|---|---|---|
| `lem:ext_bifunctor_mathlib` | `CategoryTheory.Abelian.Ext` | `Mathlib/Algebra/Homology/DerivedCategory/Ext/Basic.lean` |
| `lem:hasext_standard_mathlib` | `CategoryTheory.HasExt.standard` | `…/Ext/Basic.lean` |
| `lem:ext_homequiv_zero_mathlib` | `CategoryTheory.Abelian.Ext.homEquiv₀, addEquiv₀` | `…/Ext/Basic.lean` |
| `lem:ext_eq_zero_of_injective_mathlib` | `CategoryTheory.Abelian.Ext.eq_zero_of_injective` | `…/Ext/EnoughInjectives.lean` |
| `lem:ext_covariant_les_mathlib` | `CategoryTheory.Abelian.Ext.covariantSequence_exact, covariant_sequence_exact₁/₂/₃` | `…/Ext/ExactSequences.lean` |
| `lem:modules_restrict_functor_mathlib` | `AlgebraicGeometry.Scheme.Modules.restrictFunctor` | `Mathlib/AlgebraicGeometry/Modules/Sheaf.lean` |

Specifically regarding `lem:ext_eq_zero_of_injective_mathlib`: the blueprint claims "requires only the second argument to be injective". Verified correct — the Lean signature is `[HasExt.{w} C] {X I : C} {n : ℕ} [Injective I]` with no `HasEnoughInjectives` constraint. The `HasExt` structure is unconditionally available from `HasExt.standard`. The "soon" concern about `HasEnoughInjectives` is **dismissed**.

`\uses{def:absolute_cohomology}` is correctly wired into `lem:cech_to_cohomology_on_basis` and `lem:affine_serre_vanishing`. The chain `lem:injective_cech_acyclic → lem:ses_cech_h1 → lem:cech_to_cohomology_on_basis → lem:affine_serre_vanishing` (Stacks 01EO → 02KG) is complete and non-circular (`def:absolute_cohomology` uses Ext-based cohomology; `lem:cech_acyclic_affine` does not depend on `affine_serre_vanishing`).

---

## Severity summary

### Must-fix this iter

**R1 — `\restriction` undefined macro** (`Cohomology_CechHigherDirectImage.tex`, L2935, inside `lem:modules_restrict_functor_mathlib`)

The blueprint-doctor reports `\restriction` as `undefined-macro`: it appears in inline math but is not defined in `blueprint/src/macros/common.tex`, `macros/print.tex`, or `macros/web.tex`. Standard LaTeX `amssymb` does provide `\restriction` as `\upharpoonright`, so the compiled PDF may render; however the doctor's project-scope macro check flags it and it will cause failures in CI pipeline macro validation.

**Fix**: Add to `blueprint/src/macros/common.tex`:
```latex
\providecommand{\restriction}{\upharpoonright}
```
or replace the one occurrence at L2935 directly with `\upharpoonright` or `|_`.

### No further findings

All other checks pass: no broken refs, no axiom declarations, no covers problems, no unknown_uses, no isolated nodes. All `\mathlibok` anchors verified. No missing `\uses{}` edges found.

---

## Unstarted-phase blueprint proposals

None required.

- **P3b** (ACTIVE): adequate coverage in `Cohomology_CechHigherDirectImage.tex` — all landmark declarations present (`lem:cech_free_complex_quasi_iso`, `lem:ses_cech_h1`, `lem:injective_cech_acyclic`, `lem:affine_serre_vanishing`), with complete `\uses{}` chains.
- **P5a** (ACTIVE): `lem:open_immersion_pushforward_comp`, `lem:cech_term_pushforward_acyclic`, `lem:cech_augmented_resolution` all present with proof sketches; `def:absolute_cohomology` anchored for the deferred bridge obligation.
- **P5b** (BLOCKED): `lem:cech_computes_cohomology` present at ~L3527 with `\uses{lem:cech_augmented_resolution, lem:cech_term_pushforward_acyclic, lem:acyclic_resolution_computes_derived}` — Route A assembly coverage adequate.

---

## Overall verdict

Blueprint is in good shape. The HARD GATE declaration `lem:injective_cech_acyclic` is **complete, correct, and formalize-ready** — the prover lane may proceed. Both gate dependencies (`lem:cech_free_complex_quasi_iso`, `lem:ses_cech_h1`) have `\leanok`; the proof sketch is detailed enough to guide op-transport assembly in Lean. The new `def:absolute_cohomology` block and its six `\mathlibok` anchors are all correct (all Lean names verified in Mathlib). One must-fix rendering finding (`\restriction` undefined macro) requires a two-line patch to `macros/common.tex` before the next blueprint-doctor run.
