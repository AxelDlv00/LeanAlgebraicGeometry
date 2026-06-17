# Lean ↔ Blueprint Check Report

## Slug
freepresheaf-i23

## Iteration
023

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` (1224 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant section: `\label{sec:presheaf_cech_machinery}`, ~lines 1345–2555)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechFreePresheafComplex}` (chapter: `def:cech_free_presheaf_complex`)
- **Lean target exists**: yes (line 204)
- **Signature matches**: yes — `ChainComplex X.PresheafOfModules ℕ` built as `alternatingFaceMapComplex` of `cechFreeSimplicial`; blueprint says "the chain complex K(𝒰)_• in PMod(O_X) whose degree-p term is ⊕_{σ: Fin(p+1)→I} free(y·U_σ)"
- **Proof follows sketch**: yes — simplicial route as recommended; `d²=0` is free from simplicial identities
- **notes**: All companion decls pinned by this block (`freeYoneda`, `coverOpen`, `coverInterOpen`, `coverInterOpen_comp_le`, `cechFreeSimplicial`, `cechFreePresheafComplex_X`, `sigma_ι_eqToHom_transport`) exist and are faithful.

### `\lean{AlgebraicGeometry.coverStructurePresheaf}` (chapter: `def:cover_structure_presheaf`)
- **Lean target exists**: yes (line 285)
- **Signature matches**: yes — `Limits.image (cechFreeAug 𝒰)` as the image presheaf of the augmentation; matches blueprint description
- **Proof follows sketch**: yes — all companion decls (`cechFreeAug`, `cechFreeComplexAug`, `cechFreeComplexAug_f_zero`, `cechFreeSimplicial_δ_comp_aug`, `cechFree_d_comp_aug`, `cechFree_d_comp_factorThruImage`, `freeYonedaAug`, `freeYonedaAug_app_freeMk`, `freeYonedaHomEquiv_freeYonedaAug`, `freeYoneda_map_comp_aug`) exist with real proofs
- **notes**: Clean.

### `\lean{AlgebraicGeometry.quasiIso_of_evaluation}` (chapter: `lem:quasiIso_of_evaluation`)
- **Lean target exists**: yes (line 417)
- **Signature matches**: yes — takes `h : ∀ V, QuasiIso ((eval R V).mapHomologicalComplex c).map φ`, returns `QuasiIso φ`; matches blueprint
- **Proof follows sketch**: yes — chains `quasiIso_iff`, `quasiIsoAt_iff_isIso_homologyMap`, joint conservativity (`isIso_of_evaluation`), and `isIso_Fmap_homologyMap` for preservation of homology
- **notes**: Private helpers `isIso_Fmap_homologyMap` and `isIso_of_evaluation` are pinned in the blueprint and exist. Clean.

### `\lean{AlgebraicGeometry.cechFreeEval_X}` etc. (chapter: `lem:cech_free_eval_sectionwise`)
- **Lean target exists**: yes (`cechFreeEval_X` line 577, `freeYonedaEval_iso_of_le` line 615, `freeYonedaEval_isZero_of_not_le` line 597)
- **Signature matches**: yes — all three match their blueprint descriptions exactly
- **Proof follows sketch**: yes
- **notes**: Clean.

### `AlgebraicGeometry.FreeCechEngine.*` (chapter: `lem:free_cech_engine`)
- **Lean target exists**: yes — all 9 decls listed (`combDifferential`, `combHomotopy`, `combHomotopy_zero`, `combHomotopy_spec`, `combDifferential_eq_of_cocycle`, `combSign_flip`, `combDifferential_comp`, `combDifferential_exact`, `cons_comp_succAbove_succ`) exist in namespace `FreeCechEngine`, plus `isZero_sigma_of_forall_isZero`
- **Signature matches**: yes
- **Proof follows sketch**: yes — all proofs are real alternating-sum cancellations, consistent with blueprint
- **notes**: Clean.

### `AlgebraicGeometry.cechEngineComplex` etc. (chapter: `lem:cech_engine_complex`)
- **Lean target exists**: yes — all 14 `\lean{}`-pinned decls (`le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`, `cechFreeEvalEngine_X`, `coverSectionModule`, `cechEngineX`, `cechEngineD`, `cechEngineD_ι`, `cechEngineD_comp`, `cechEngineComplex`, `cechEnginePrepend`, `cechEnginePrepend_ι`, `cechEnginePrepend_spec`, `cechEngineD_exact`) exist
- **Signature matches**: yes — differentials, contracting homotopy, and positive-degree exactness all match blueprint
- **Proof follows sketch**: yes
- **notes**: `cechEngineComplex_exactAt` (line 1168) is built in the Lean file but is NOT in the `\lean{}` list of `lem:cech_engine_complex` — see Unreferenced Declarations below.

### `\lean{AlgebraicGeometry.cechFreeEvalEngineIso}` (chapter: `lem:cech_free_eval_engine_iso`) — **THE NAMED (1) TARGET**
- **Lean target exists**: yes (line 1147)
- **Signature matches**: yes — `((PresheafOfModules.evaluation X.ringCatSheaf.obj (Opposite.op V)).mapHomologicalComplex (ComplexShape.down ℕ)).obj (cechFreePresheafComplex 𝒰) ≅ cechEngineComplex 𝒰 V`; matches blueprint statement exactly (chain iso from evaluated free Čech complex to the constant-coefficient engine complex)
- **Proof follows sketch**: yes — built by `HomologicalComplex.Hom.isoOfComponents` with degreewise isos `cechFreeEvalEngine_X` and differential comm-square `cechFreeEvalEngine_comm`; the blueprint proof (lines 2029–2110) describes exactly this 3-layer construction and differential-match verification; `cechFreeEvalEngine_comm` (private, line 1105) implements the naturality-past-layers argument the blueprint traces
- **notes**: The proof is REAL — no sorry, no placeholder. The `\leanok` on the proof block (blueprint line 2031) is correct. **RESOLVED this iter: confirmed.**

### `\lean{AlgebraicGeometry.cechFreeEval_isZero_of_isEmpty}` etc. (chapter: `lem:cech_free_eval_empty`)
- **Lean target exists**: yes — all 4 pinned decls (`cechFreeEval_quasiIso_of_isEmpty`, `cechFreeEval_isZero_of_isEmpty`, `coverStructurePresheaf_eval_isZero_of_isEmpty`, `isZero_homology_of_isZero_X`) exist (lines 641–705)
- **Signature matches**: yes
- **Proof follows sketch**: yes — both-sides-zero argument via `Limits.isIso_of_source_target_iso_zero`
- **notes**: Clean.

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty}` (chapter: `lem:cech_free_eval_nonempty`)
- **Lean target exists**: **no** — declaration is absent from the file entirely (no def, no lemma, no sorry placeholder)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The blueprint correctly has no `\leanok` on this block. The prerequisites (`cechEngineComplexAug`, `cechEngineComplex_exactAt`) are built but the nonempty quasi-iso itself is not yet assembled. No fake placeholder. Clean absence.

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (chapter: `lem:cech_free_complex_quasi_iso`)
- **Lean target exists**: **no** — declaration is absent from the file (no def, no sorry, no placeholder of any kind)
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The file's module docstring (lines 21–25) explicitly states "not yet built" with a parenthetical explaining what remains. The blueprint correctly has no `\leanok`. No overclaiming. Absence is correct and consistent.

---

## Red flags

None found.

### Placeholder / suspect bodies
*None.* Every proved declaration has a real proof body. No `:= sorry`, no `:= True`, no `Classical.choice _` on non-trivial claims.

### Excuse-comments
*None that are misleading.* The module docstring mentions `cechFreeComplex_quasiIso` is "not yet built" — this is an accurate status note, not an excuse for a wrong-but-present declaration. No `-- TODO replace with real def` on any proved decl.

### Axioms / Classical.choice on non-trivial claims
*None.* No `axiom` declarations in the file.

---

## Unreferenced declarations (informational)

The following Lean declarations in the file have **no `\lean{}`-pin** in the blueprint:

| Declaration | Line | Status | Notes |
|---|---|---|---|
| `freeYonedaEval_iso_of_le_hom_eq_aug` | 977 | `lemma` (non-private) | Shows iso = augmentation app; feeds `freeYonedaEval_iso_of_le_natural`; minor — add to `lem:cech_engine_complex` |
| `freeYonedaEval_iso_of_le_natural` | 997 | `lemma` (non-private) | **Key naturality lemma** used directly in `cechFreeEvalEngine_comm`; the differential-match proof in `lem:cech_free_eval_engine_iso` relies on this; should be `\lean{}`-pinned in `lem:cech_free_eval_engine_iso` |
| `cechFreeEval_X_ι_inv` | 1009 | `private lemma` | Helper for `cechFreeEvalEngine_comm`; private — acceptable as `lean_aux` |
| `cechFreeEvalEngine_X_inv_hom_ι` | 1028 | `private lemma` | Helper for `cechFreeEvalEngine_comm`; private — acceptable |
| `freeYonedaAug_app_comp` | 1048 | `private lemma` | Helper; private — acceptable |
| `cechFree_d_ι` | 1058 | `private lemma` | Unfolds evaluated differential on injection; private — acceptable |
| `cechFreeEvalEngine_map_ι` | 1089 | `private lemma` | Helper for comm-square; private — acceptable |
| `cechFreeEvalEngine_comm` | 1105 | `private lemma` | The differential comm-square of `cechFreeEvalEngineIso`; private — the blueprint proof sketch for `lem:cech_free_eval_engine_iso` describes its content adequately without needing a `\lean{}` pin |
| `cechEngineComplex_exactAt` | 1168 | `lemma` (non-private) | `HomologicalComplex.ExactAt` form of positive-degree exactness; the blueprint `lem:cech_engine_complex` bullet says "cechEngineD_exact" but not the `ExactAt` packaging; **should be added to `lem:cech_engine_complex` `\lean{}` list** |
| `cechEngineAug0` | 1191 | `noncomputable def` | Degree-0 engine augmentation; needed for `cechEngineComplexAug` and thereby for `cechFreeEval_quasiIso_of_nonempty` route; **no blueprint block** |
| `cechEngineAug0_ι` | 1196 | `lemma` | Injection action of degree-0 augmentation; **no blueprint block** |
| `cechEngineD_comp_aug` | 1204 | `lemma` | Chain-map condition `d ≫ aug = 0`; **no blueprint block** |
| `cechEngineComplexAug` | 1216 | `noncomputable def` | The augmentation chain map `cechEngineComplex 𝒰 V ⟶ O_X(V)[0]`; this is the direct engine-level input to the nonempty quasi-iso route; **no blueprint block** |

The four engine-augmentation declarations (`cechEngineAug0`, `cechEngineAug0_ι`, `cechEngineD_comp_aug`, `cechEngineComplexAug`) form a coherent cluster not covered by any blueprint `\lean{}` block. The blueprint's `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` have `% NOTE:` annotations saying the contracting homotopy is handled at the engine level — but neither names these specific engine-augmentation declarations. A prover building `cechFreeEval_quasiIso_of_nonempty` next iter must discover this cluster from the Lean file, not from the blueprint.

---

## Blueprint adequacy for this file

### For the *built* declarations (everything except the two absent targets)

- **Coverage**: ~35/49 Lean declarations have a corresponding `\lean{...}` block. The 14 unreferenced declarations are: 8 private helpers (acceptable as `lean_aux`), 1 important non-private lemma (`freeYonedaEval_iso_of_le_natural`) that feeds the key engine-iso proof, 1 non-private packaging lemma (`cechEngineComplex_exactAt`), and 4 non-private engine-augmentation declarations.
- **Proof-sketch depth**: **adequate** for the built targets. `lem:cech_free_eval_engine_iso` (lines 2029–2110) is detailed: it describes the 3-layer composite of `cechFreeEval_X` / `cechFreeEvalDropZeros` / `whiskerEquiv`, the differential-match argument via injection-testing on `Limits.Sigma.hom_ext`, and the variance reconciliation between chain and cochain perspectives. A prover could formalize `cechFreeEvalEngineIso` from this sketch — and did.
- **Hint precision**: **precise** — `\lean{AlgebraicGeometry.cechFreeEvalEngineIso}` uniquely names the target.
- **Generality**: **matches need** — all blueprint definitions are at the level of generality the Lean file actually uses.

### For the *absent* targets (`cechFreeEval_quasiIso_of_nonempty`, `cechFreeComplex_quasiIso`)

- **Coverage**: The blueprint's `lem:cech_free_eval_nonempty` names `cechFreeEval_quasiIso_of_nonempty` as a `\lean{}` target. Its proof sketch (lines 2297–2311) describes assembling `HomologicalComplex.Homotopy` from the prepend maps and using `QuasiIso.ofHomotopyEquiv`. This is conceptually correct but **under-specified at the intermediate-declaration level**: neither `cechEngineComplexAug` (the engine-level augmentation chain map) nor the transport route across `cechFreeEvalEngineIso` is named as a Lean decl to build. A prover must infer these from the Lean file, not from the blueprint.
- **Proof-sketch depth**: **under-specified** for `lem:cech_free_eval_nonempty`. `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` both carry `% NOTE:` tags saying they have no standalone `\lean{}` pin. This is intentional (the homotopy exists at engine level) but leaves the prover without a named intermediate Lean target for the "transport across `cechFreeEvalEngineIso`" step, forcing discovery from the code.
- **Recommended chapter-side actions**:
  1. Add `\lean{AlgebraicGeometry.freeYonedaEval_iso_of_le_natural}` to `lem:cech_free_eval_engine_iso` (the naturality lemma is the core of the differential match; the proof sketch describes it in prose on lines 2083–2098 but doesn't pin it).
  2. Add `\lean{AlgebraicGeometry.cechEngineComplex_exactAt}` to `lem:cech_engine_complex` (the `ExactAt` packaging is distinct from `cechEngineD_exact` and needed for the HomologicalComplex API).
  3. Add a new sub-block (or expand `lem:cech_engine_complex`) to pin the engine-augmentation cluster: `\lean{AlgebraicGeometry.cechEngineAug0}`, `\lean{AlgebraicGeometry.cechEngineAug0_ι}`, `\lean{AlgebraicGeometry.cechEngineD_comp_aug}`, `\lean{AlgebraicGeometry.cechEngineComplexAug}`. These are the direct prerequisites for the nonempty quasi-iso that the blueprint's `lem:cech_free_eval_prepend_homotopy` defers to but does not name.
  4. Either elevate `lem:cech_free_eval_prepend_homotopy` / `lem:cech_free_eval_prepend_homotopy_spec` to have `\lean{}` pins (specifying that the transport route uses `cechEngineComplexAug` + `cechFreeEvalEngineIso`), or fold this guidance into `lem:cech_free_eval_nonempty`'s proof sketch.

---

## Severity summary

### must-fix-this-iter
*None.* The (1) named target `cechFreeEvalEngineIso` is built with a real proof, its signature matches the blueprint, and its proof follows the blueprint sketch. The two absent targets (`cechFreeEval_quasiIso_of_nonempty`, `cechFreeComplex_quasiIso`) have no sorry placeholders — their absence is correctly reflected by the absence of `\leanok` in the blueprint. No fake statements, no axioms, no excuse-comments on proved declarations.

### major
- **Blueprint adequacy gap for the next-step route**: The engine-augmentation cluster (`cechEngineAug0`, `cechEngineAug0_ι`, `cechEngineD_comp_aug`, `cechEngineComplexAug`) has 4 non-private substantive declarations with no blueprint `\lean{}` pin. These are the direct inputs for the next-iter target (`cechFreeEval_quasiIso_of_nonempty`). A blueprint-writing pass is needed before the next prover can be guided efficiently.
- **`freeYonedaEval_iso_of_le_natural` (line 997) unregistered**: This is the explicit naturality lemma that enables the differential comm-square (`cechFreeEvalEngine_comm`) of `cechFreeEvalEngineIso`. The blueprint proof sketch for `lem:cech_free_eval_engine_iso` describes its content in prose but does not give it a `\lean{}` pin. Should be added.

### minor
- `cechEngineComplex_exactAt` (line 1168) not in `lem:cech_engine_complex` `\lean{}` list: the bullet "Hence C• is exact in positive degree (`cechEngineD_exact`)" (blueprint line 1941) covers the `Function.Exact` form but not the `HomologicalComplex.ExactAt` packaging; the latter requires separate API (`exactAt_iff'`, `ModuleCat.shortComplex_exact`).
- `freeYonedaEval_iso_of_le_hom_eq_aug` (line 977): substantive bridge (showing the iso = augmentation app) but not pinned; low impact since it feeds only the immediately-following `freeYonedaEval_iso_of_le_natural`.

---

**Overall verdict**: `cechFreeEvalEngineIso` (the (1) named target) is axiom-clean, signature-faithful, and proof-sketch-faithful — 0 must-fix findings for iter-023; the sole gap is a **major blueprint adequacy shortfall** in the engine-augmentation layer that blocks efficient guidance for the next prover step toward `cechFreeEval_quasiIso_of_nonempty`.
