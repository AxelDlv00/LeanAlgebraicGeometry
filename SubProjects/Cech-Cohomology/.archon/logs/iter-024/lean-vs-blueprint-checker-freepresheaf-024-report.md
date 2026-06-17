# Lean ↔ Blueprint Check Report

## Slug
freepresheaf-024

## Iteration
024

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (covers `FreePresheafComplex.lean` via `% archon:covers` at line 6)

---

## Per-declaration (all `\lean{}`-pinned blocks)

### `\lean{AlgebraicGeometry.cechFreePresheafComplex}` (chapter: `def:cech_free_presheaf_complex`, line ~1374)
- **Lean target exists**: yes (line 207)
- **Signature matches**: yes — `ChainComplex X.PresheafOfModules ℕ` via `alternatingFaceMapComplex` of `cechFreeSimplicial`, exactly as described
- **Proof follows sketch**: yes — built as `(AlgebraicTopology.alternatingFaceMapComplex _).obj (cechFreeSimplicial 𝒰)`; blueprint prescribes the simplicial route to avoid hand-rolling `d² = 0`
- **notes**: `d² = 0` is free from simplicial identities as the blueprint dictates. Helper `sigma_ι_eqToHom_transport` is private.

### `\lean{AlgebraicGeometry.cechFreeSimplicial}` (chapter: `def:cech_free_presheaf_complex`)
- **Lean target exists**: yes (line 165)
- **Signature matches**: yes — `SimplicialObject X.PresheafOfModules` with the described degree-`p` coproduct and reindexing maps
- **Proof follows sketch**: yes — simplicial map identity/composition proofs use the `sigma_ι_eqToHom_transport` helper
- **notes**: clean

### `\lean{AlgebraicGeometry.coverStructurePresheaf}` etc. (chapter: `def:cover_structure_presheaf`, line ~1632)
The block pins: `coverStructurePresheaf`, `cechFreeAug`, `cechFreeComplexAug`, `cechFreeComplexAug_f_zero`, `freeYonedaAug`, `freeYonedaHomEquiv_freeYonedaAug`, `freeYoneda_map_comp_aug`; plus several private helpers.
- **Lean targets exist**: all yes (lines 230–356)
- **Signature matches**: yes — `coverStructurePresheaf = Limits.image (cechFreeAug 𝒰)`; `cechFreeComplexAug` is the chain map `cechFreePresheafComplex 𝒰 ⟶ (ChainComplex.single₀ _).obj (coverStructurePresheaf 𝒰)`; blueprint confirms both
- **Proof follows sketch**: yes
- **notes**: Private helpers `cechFreeSimplicial_δ_comp_aug`, `cechFree_d_comp_aug`, `cechFree_d_comp_factorThruImage` are pinned in the blueprint but marked private in Lean — acceptable, they're internal chain-map conditions

### `\lean{AlgebraicGeometry.quasiIso_of_evaluation}` (chapter: `lem:quasiIso_of_evaluation`, line ~1671)
The block also pins `isIso_Fmap_homologyMap` and `isIso_of_evaluation` (both private in Lean).
- **Lean target exists**: yes (line 420)
- **Signature matches**: yes — takes a morphism `φ : K ⟶ L` of presheaf-of-module complexes, assumes every evaluation is a quasi-iso, concludes `QuasiIso φ`; matches blueprint exactly
- **Proof follows sketch**: yes — uses `quasiIso_iff` + `quasiIsoAt_iff_isIso_homologyMap` + `isIso_of_evaluation` (joint conservativity) + `isIso_Fmap_homologyMap` (evaluation preserves homology)
- **notes**: clean

### `\lean{AlgebraicGeometry.cechFreeEval_X}` etc. (chapter: `lem:cech_free_eval_sectionwise`, line ~1721)
Block pins: `cechFreeEval_X`, `freeYonedaEval_iso_of_le`, `freeYonedaEval_isZero_of_not_le`.
- **Lean targets exist**: all yes (lines 580–623)
- **Signature matches**: yes — `cechFreeEval_X` is the degreewise evaluation-commutes-with-coproduct iso; `freeYonedaEval_iso_of_le` is the per-summand identification `∼ O_X(V)`; `freeYonedaEval_isZero_of_not_le` is the vanishing of non-surviving summands
- **Proof follows sketch**: yes
- **notes**: clean

### `\lean{AlgebraicGeometry.FreeCechEngine.combDifferential}` etc. (chapter: `lem:free_cech_engine`, line ~1806)
Block pins all declarations in `FreeCechEngine` namespace plus `isZero_sigma_of_forall_isZero`.
- **Lean targets exist**: all yes (lines 451–635)
- **Signature matches**: yes — combinatorial alternating Čech differential, prepend homotopy, contracting identity `d ∘ h + h ∘ d = id`, sign bookkeeping
- **Proof follows sketch**: yes — `combHomotopy_spec` uses `Fin.sum_univ_succ` and the `cons_comp_succAbove_succ` / sign-flip involution route described in the blueprint
- **notes**: clean; `combHomotopy_zero` carries `@[simp]`

### `\lean{AlgebraicGeometry.le_coverInterOpen_iff}` etc. (chapter: `lem:cech_engine_complex`, line ~1873)
Block pins: `le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`, `cechFreeEvalEngine_X`, `coverSectionModule`, `cechEngineX`, `cechEngineD`, `cechEngineD_ι`, `cechEngineD_comp`, `cechEngineComplex`, `cechEnginePrepend`, `cechEnginePrepend_ι`, `cechEnginePrepend_spec`, `cechEngineD_exact`.
- **Lean targets exist**: all yes (lines 729–966)
- **Signature matches**: yes — engine complex `C_p = ∐_{σ : Fin(p+1) → I₁(V)} O_X(V)` with index-drop alternating differential; blueprint describes exactly this
- **Proof follows sketch**: yes — `cechEngineD_comp` and `cechEnginePrepend_spec` both use `Limits.Sigma.hom_ext` and reduce to `FreeCechEngine.*`
- **notes**: The block does **not** pin `cechEngineComplex_exactAt` (line 1171), `cechEngineAug0` (1194), `cechEngineAug0_ι` (1199), `cechEngineD_comp_aug` (1207), `cechEngineComplexAug` (1219), `cechEngineAug0_split` (1234), `cechEngineComplexAug_f_zero` (1258), `cechEngineComplexAug_quasiIso` (1267) — see Unreferenced Declarations below

### `\lean{AlgebraicGeometry.cechFreeEvalEngineIso}` (chapter: `lem:cech_free_eval_engine_iso`, line 1985)
- **Lean target exists**: yes (line 1150)
- **Signature matches**: yes — `((PresheafOfModules.evaluation _).mapHomologicalComplex _).obj (cechFreePresheafComplex 𝒰) ≅ cechEngineComplex 𝒰 V`; blueprint states exactly this isomorphism of chain complexes
- **Proof follows sketch**: yes — uses `HomologicalComplex.Hom.isoOfComponents` with `cechFreeEvalEngine_X` as degreewise isos and `cechFreeEvalEngine_comm` as the differential comm-square
- **notes**: Private helpers `cechFreeEvalEngine_comm`, `cechFreeEvalEngine_map_ι`, `cechFreeEval_X_ι_inv`, `cechFreeEvalEngine_X_inv_hom_ι` are all clean. Two **non-private** helpers (`freeYonedaEval_iso_of_le_hom_eq_aug` line 980, `freeYonedaEval_iso_of_le_natural` line 1000) are used by this proof but not pinned in `lem:cech_engine_complex` or `lem:cech_free_eval_engine_iso` — informational (see below)

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_isEmpty}` etc. (chapter: `lem:cech_free_eval_empty`, line ~2116)
Block pins: `cechFreeEval_quasiIso_of_isEmpty`, `cechFreeEval_isZero_of_isEmpty`, `coverStructurePresheaf_eval_isZero_of_isEmpty`.
- **Lean targets exist**: all yes (lines 644–709)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `isZero_homology_of_isZero_X` (line 679) is a generic helper used by this proof but not pinned; informational

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty}` (chapter: `lem:cech_free_eval_nonempty`, line 2281)
- **Lean target exists**: yes (line 1404)
- **Signature matches**: yes — `QuasiIso (((evaluation _).mapHomologicalComplex _).map (cechFreeComplexAug 𝒰))` with hypothesis `i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}`; matches blueprint
- **Proof follows sketch**: **partial** — blueprint sketch (lines 2299–2313) says the prepend homotopy maps assemble into a `HomologicalComplex.Homotopy` packaging used via `HomotopyEquiv.toQuasiIso`. The Lean proof instead transfers the engine quasi-iso `cechEngineComplexAug_quasiIso` across `cechFreeEvalEngineIso` via `quasiIso_of_arrow_mk_iso`. Mathematically equivalent (the contracting homotopy content is inside `cechEngineComplexAug_quasiIso`), but the packaging differs from what the blueprint sketches.
- **notes**: The divergence is minor — same conclusion, equivalent mathematics. Blueprint lemmas `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` (both carry `% NOTE:` comments saying they have no standalone `\lean{}` pin) are subsumed into `cechEngineComplexAug_quasiIso`. No error in the Lean proof.

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (chapter: `lem:cech_free_complex_quasi_iso`, line 2321) — THE NAMED TARGET
- **Lean target exists**: yes (line 1439)
- **Signature matches**: yes — `QuasiIso (cechFreeComplexAug 𝒰)` where `cechFreeComplexAug 𝒰 : cechFreePresheafComplex 𝒰 ⟶ (ChainComplex.single₀ _).obj (coverStructurePresheaf 𝒰)`; this directly expresses that `K(𝒰)_•` is a resolution of `O_𝒰`
- **Proof follows sketch**: yes — proof (lines 1441–1448) calls `quasiIso_of_evaluation`, splits on `∃ i, W ≤ coverOpen 𝒰 i`, dispatches to `cechFreeEval_quasiIso_of_nonempty` and `cechFreeEval_quasiIso_of_isEmpty`; blueprint proof (lines 2392–2424) prescribes exactly this two-case split via `lem:cech_free_eval_empty` / `lem:cech_free_eval_nonempty`
- **notes**: The resolution claim is **genuine**: `QuasiIso` on the augmentation map is not weakened — it asserts actual quasi-isomorphism at every homology degree. Axiom check: `{"axioms":["propext","Classical.choice","Quot.sound"]}` — **axiom-clean** (standard Lean kernel axioms only).

---

## Red flags

None found.

### Placeholder / suspect bodies
No `:= sorry`, `:= True`, or suspect bodies found anywhere in the file.

### Excuse-comments
No `-- TODO replace with real def`, `-- temporary`, `-- placeholder`, `-- wrong but works for now` comments found.

### Axioms / Classical.choice on non-trivial claims
`cechFreeComplex_quasiIso`: axioms = `[propext, Classical.choice, Quot.sound]`. These are the standard Lean4 / Mathlib baseline — no additional axioms introduced. Clean.

`cechFreeEval_quasiIso_of_nonempty`: same baseline set. Clean.

`cechFreeEvalEngineIso`: same. Clean.

`coverStructurePresheafEval_iso`: same. Clean.

---

## Unreferenced declarations (informational)

These non-private declarations appear in the file but are not pinned by any `\lean{...}` block. Most are helpers consumed internally by the nonempty-case argument, but several are substantive enough to warrant blueprint coverage.

**Substantive — should be added to blueprint (major coverage debt):**

| Declaration | Line | Notes |
|---|---|---|
| `cechEngineComplex_exactAt` | 1171 | Positive-degree exactness of engine complex from contracting homotopy; consumed by `cechEngineComplexAug_quasiIso` |
| `cechEngineAug0` | 1194 | Degree-0 engine augmentation (codiagonal); consumed by `cechEngineComplexAug` |
| `cechEngineD_comp_aug` | 1207 | Cochain-map condition for `cechEngineComplexAug`; consumed by `cechEngineComplexAug` |
| `cechEngineComplexAug` | 1219 | The engine augmentation chain map `C• → O_X(V)[0]`; the engine-side resolution map |
| `cechEngineAug0_split` | 1234 | **New this iter.** Degree-0 splitting identity proving `cechEngineAug0` is a cokernel of `d_0`; key to degree-0 quasi-iso |
| `cechEngineComplexAug_f_zero` | 1258 | **New this iter.** Degree-0 component lemma for `cechEngineComplexAug` |
| `cechEngineComplexAug_quasiIso` | 1267 | **New this iter.** The engine augmentation is a quasi-isomorphism (nonempty case); the core of `cechFreeEval_quasiIso_of_nonempty` |
| `coverStructurePresheafEval_iso` | 1359 | **New this iter.** Geometric identification `(eval V)(O_𝒰) ≅ O_X(V)` in the nonempty case; used as the target iso in `cechFreeEval_quasiIso_of_nonempty` |

**Smaller helpers (minor — could be added to a new blueprint block or prose notes):**

| Declaration | Line | Notes |
|---|---|---|
| `cechEngineAug0_ι` | 1199 | Injection action of `cechEngineAug0`; minor |
| `freeYonedaEval_iso_of_le_hom_eq_aug` | 980 | Bridge: identification iso = evaluation of augmentation; used by `cechFreeEvalEngine_comm` |
| `freeYonedaEval_iso_of_le_natural` | 1000 | Naturality of the per-summand id; used by `cechFreeEvalEngine_comm`; fits under `lem:cech_free_eval_engine_iso` |
| `isZero_homology_of_isZero_X` | 679 | Generic helper (homology of zero object is zero); used by `cechFreeEval_quasiIso_of_isEmpty` |

---

## Blueprint adequacy for this file

- **Coverage**: 35 of ~55 non-private Lean declarations have a corresponding `\lean{...}` block. Of the ~20 unreferenced, 8 are substantive (the engine augmentation cluster listed above), ~5 are minor/generic helpers, and the rest are obvious combinatorial helpers.

- **Proof-sketch depth**: **adequate** — the blueprint chapter gives specific Lean API references (`quasiIso_of_evaluation`, `HomologicalComplex.Hom.isoOfComponents`, `ChainComplex.of`, `Limits.Sigma.hom_ext`, etc.), index formulas, and step-by-step proof outlines. The nonempty proof sketch describes the homotopy route, which differs from the Lean implementation but maps to the same mathematical content. A prover could have correctly formalized this file from the chapter.

- **Hint precision**: **precise** — `\lean{...}` pins use fully qualified names that match the Lean declarations exactly. No cases where the hint names the wrong Lean predicate.

- **Generality**: **matches need** — the blueprint works at the right level (`PresheafOfModules`, `X.OpenCover`, `Finite 𝒰.I₀`) matching the Lean context.

- **Recommended chapter-side actions**:
  1. Add a new blueprint block (e.g. `lem:cech_engine_aug_quasiIso`) pinning the engine augmentation cluster: `cechEngineAug0`, `cechEngineAug0_ι`, `cechEngineD_comp_aug`, `cechEngineComplexAug`, `cechEngineAug0_split`, `cechEngineComplexAug_f_zero`, `cechEngineComplexAug_quasiIso`. The prose should describe the degree-0 splitting identity and the nonempty engine quasi-iso.
  2. Add `coverStructurePresheafEval_iso` and `cechEngineComplex_exactAt` to either the new augmentation block or `lem:cech_free_eval_nonempty`.
  3. Add `freeYonedaEval_iso_of_le_natural` and `freeYonedaEval_iso_of_le_hom_eq_aug` to `lem:cech_free_eval_engine_iso` (they are the key bridges for its differential comm-square proof).
  4. Update the `lem:cech_free_eval_nonempty` proof sketch to reflect the actual Lean route: transfer via `quasiIso_of_arrow_mk_iso` across `cechFreeEvalEngineIso` from `cechEngineComplexAug_quasiIso`, rather than explicit `HomologicalComplex.Homotopy` packaging.

---

## Severity summary

- **must-fix-this-iter**: *none*. No placeholder bodies, no wrong signatures, no excuse-comments, no axioms.
- **major**: 8 substantive non-private declarations (`cechEngineComplexAug_quasiIso`, `cechEngineComplexAug`, `cechEngineComplex_exactAt`, `cechEngineAug0_split`, `coverStructurePresheafEval_iso`, `cechEngineAug0`, `cechEngineD_comp_aug`, `cechEngineComplexAug_f_zero`) lack `\lean{...}` pins in the blueprint. These represent coverage debt requiring a new blueprint augmentation block.
- **minor**: Proof of `cechFreeEval_quasiIso_of_nonempty` uses `quasiIso_of_arrow_mk_iso` transfer route rather than explicit `HomologicalComplex.Homotopy` packaging described in the sketch — equivalent mathematics, different packaging; `freeYonedaEval_iso_of_le_natural` and `freeYonedaEval_iso_of_le_hom_eq_aug` lack blueprint pins; `isZero_homology_of_isZero_X` generic helper not pinned.

**Overall verdict**: `cechFreeComplex_quasiIso` (the named P3b bottleneck) is axiom-clean and faithfully realizes `lem:cech_free_complex_quasi_iso`; the resolution claim is genuine. All `\lean{}`-pinned declarations pass with no red flags. The main finding is blueprint coverage debt: 8 substantive declarations in the engine augmentation cluster (including the new `cechEngineComplexAug_quasiIso`) are unpin­ned and should be added to the chapter.
