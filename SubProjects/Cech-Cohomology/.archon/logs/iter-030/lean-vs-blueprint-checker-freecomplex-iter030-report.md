# Lean ↔ Blueprint Check Report

## Slug
freecomplex-iter030

## Iteration
030

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration

The blueprint covers the `X.OpenCover`-indexed chain via 10 `\lean{...}` blocks. All ~75 pinned declarations exist in the Lean file at their expected names. Below is each block's verdict.

### `\lean{AlgebraicGeometry.cechFreePresheafComplex, ...}` (def:cech_free_presheaf_complex)

Pins 8 declarations: `freeYoneda`, `coverOpen`, `coverInterOpen`, `coverInterOpen_comp_le`,
`cechFreeSimplicial`, `cechFreePresheafComplex`, `cechFreePresheafComplex_X`,
`sigma_ι_eqToHom_transport`.

- **Lean targets exist**: yes — all 8 present
- **Signatures match**: yes — `cechFreePresheafComplex (𝒰 : X.OpenCover) [Finite 𝒰.I₀] : ChainComplex X.PresheafOfModules ℕ`; degree-p term `∐_{σ : Fin(p+1) → 𝒰.I₀} freeYoneda (coverInterOpen 𝒰 σ)` via `alternatingFaceMapComplex`, matching the blueprint's Stacks citation exactly.
- **Proof follows sketch**: yes — simplicial route; `d² = 0` from simplicial identities; `sigma_ι_eqToHom_transport` handles identity/composition bookkeeping as described.
- **notes**: The private `sigma_ι_eqToHom_transport` helper is listed in the `\lean{...}` block; it is indeed a private lemma in Lean, which is fine.

### `\lean{AlgebraicGeometry.coverStructurePresheaf, ...}` (def:cover_structure_presheaf)

Pins 12 declarations: `coverStructurePresheaf`, `cechFreeAug`, `cechFreeComplexAug`,
`cechFreeComplexAug_f_zero`, `cechFreeSimplicial_δ_comp_aug` (private),
`cechFree_d_comp_aug` (private), `cechFree_d_comp_factorThruImage` (private),
`freeYonedaAug`, `freeYonedaAug_app_freeMk` (private),
`freeYonedaHomEquiv_freeYonedaAug`, `freeYoneda_map_comp_aug`.

- **Lean targets exist**: yes — all 12 present
- **Signatures match**: yes — `coverStructurePresheaf (𝒰 : X.OpenCover) [Finite 𝒰.I₀] : X.PresheafOfModules := Limits.image (cechFreeAug 𝒰)`, matching blueprint's "image presheaf of the augmentation".
- **Proof follows sketch**: yes — chain-map condition `d ≫ aug = 0` via δ-level identity then image-mono cancellation; `cechFreeComplexAug` via `toSingle₀Equiv` following the plan.
- **notes**: none

### `\lean{AlgebraicGeometry.quasiIso_of_evaluation, ...}` (lem:quasiIso_of_evaluation)

Pins 3 declarations: `quasiIso_of_evaluation`, `isIso_Fmap_homologyMap` (private),
`isIso_of_evaluation` (private).

- **Lean targets exist**: yes
- **Signatures match**: yes — `quasiIso_of_evaluation` takes `(h : ∀ V, QuasiIso (...mapHomologicalComplex....map φ)) : QuasiIso φ`, exactly the blueprint's joint-conservativity statement.
- **Proof follows sketch**: yes — `quasiIso_iff`, `isIso_of_evaluation` for joint conservativity, `isIso_Fmap_homologyMap` for naturality of evaluation past homology.
- **notes**: none

### `\lean{AlgebraicGeometry.cechFreeEval_X, ...}` (lem:cech_free_eval_sectionwise)

Pins 3 declarations: `cechFreeEval_X`, `freeYonedaEval_iso_of_le`,
`freeYonedaEval_isZero_of_not_le`.

- **Lean targets exist**: yes
- **Signatures match**: yes — `cechFreeEval_X` iso for evaluation commuting with coproduct; `freeYonedaEval_iso_of_le (h : V ≤ W)` identifies the evaluated summand with `O_X(V)`; `freeYonedaEval_isZero_of_not_le (h : ¬ V ≤ W)` gives zero.
- **Proof follows sketch**: yes
- **notes**: `cechFreePresheafComplex_X` (rfl-level unfolding) is referenced by the blueprint prose ("the Lean entry point for the degree-p unfolding") but NOT explicitly in this `\lean{...}` block; it is pinned under `def:cech_free_presheaf_complex`. No gap.

### `\lean{AlgebraicGeometry.FreeCechEngine.combDifferential, ...}` (lem:free_cech_engine)

Pins 10 declarations: `combDifferential`, `combDifferential_comp`, `combDifferential_eq_of_cocycle`,
`combDifferential_exact`, `combHomotopy`, `combHomotopy_spec`, `combHomotopy_zero`,
`combSign_flip`, `cons_comp_succAbove_succ`, `isZero_sigma_of_forall_isZero`.

- **Lean targets exist**: yes — all 10 present
- **Signatures match**: yes — types are consistent; `combHomotopy_spec` is `d(h t) + h(d t) = t` which is the contracting homotopy identity.
- **Proof follows sketch**: yes
- **notes**: **Minor blueprint prose discrepancy.** The blueprint (line ~1851) describes `combHomotopy i_fix` as a map `K_p → K_{p+1}` (raising chain degree) with formula `(h u)_{i₀,...,i_{p+1}} = u_{i₁,...,i_{p+1}}` when `i₀ = i_fix`. The Lean implementation has the _dual_ orientation: `combHomotopy r : ((Fin(n+1)→ι)→M) → ((Fin n→ι)→M)` (lowering arity), defined as `(combHomotopy r u)(τ) = u(Fin.cons r τ)`. These are the cochain-dual of each other and both correctly represent the contracting homotopy; the `combHomotopy_spec` identity is mathematically equivalent to the Stacks formula. The blueprint prose describes the _chain_ direction (Stacks K_p → K_{p+1}) while the Lean implements the _cochain_ direction (arity-lowering), which is consistent with the coproduct-dual engine described in the text just before `lem:cech_engine_complex`. The discrepancy is in the prose description of `combHomotopy`'s direction, not in the mathematical content.

### `\lean{AlgebraicGeometry.le_coverInterOpen_iff, ...}` (lem:cech_engine_complex)

Pins 21 declarations: `le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`,
`cechFreeEvalEngine_X`, `coverSectionModule`, `cechEngineX`, `cechEngineD`, `cechEngineD_ι`,
`cechEngineD_comp`, `cechEngineComplex`, `cechEnginePrepend`, `cechEnginePrepend_ι`,
`cechEnginePrepend_spec`, `cechEngineD_exact`, `cechEngineAug0`, `cechEngineAug0_split`,
`cechEngineAug0_ι`, `cechEngineComplexAug`, `cechEngineComplexAug_f_zero`,
`cechEngineComplex_exactAt`, `cechEngineD_comp_aug`.

- **Lean targets exist**: yes — all 21 present
- **Signatures match**: yes
- **Proof follows sketch**: yes — `cechEngineD_comp` via involution argument reusing `FreeCechEngine.combSign_flip`; `cechEnginePrepend_spec` reusing `FreeCechEngine.cons_comp_succAbove_succ`; `cechEngineD_exact` from contracting identity.
- **notes**: none

### `\lean{AlgebraicGeometry.cechFreeEvalEngineIso, ...}` (lem:cech_free_eval_engine_iso)

Pins 11 declarations: `cechFreeEvalEngineIso`, `cechFreeAug_eval_eq` (private),
`cechFreeEvalEngineIso_hom_f` (private), `cechFreeEvalEngine_X_inv_hom_ι` (private),
`cechFreeEvalEngine_comm` (private), `cechFreeEvalEngine_map_ι` (private),
`cechFreeEval_X_ι_inv` (private), `cechFree_d_ι` (private), `freeYonedaAug_app_comp` (private),
`freeYonedaEval_iso_of_le_hom_eq_aug`, `freeYonedaEval_iso_of_le_natural`.

- **Lean targets exist**: yes — all 11 present
- **Signatures match**: yes — `cechFreeEvalEngineIso` gives the chain complex iso `(eval V).mapHomologicalComplex(down ℕ)(cechFreePresheafComplex 𝒰) ≅ cechEngineComplex 𝒰 V`.
- **Proof follows sketch**: yes — `HomologicalComplex.Hom.isoOfComponents` from degreewise isos + comm-square.
- **notes**: none

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_isEmpty, ...}` (lem:cech_free_eval_empty)

Pins 4 declarations: `cechFreeEval_quasiIso_of_isEmpty`, `cechFreeEval_isZero_of_isEmpty`,
`coverStructurePresheaf_eval_isZero_of_isEmpty`, `isZero_homology_of_isZero_X`.

- **Lean targets exist**: yes
- **Signatures match**: yes
- **Proof follows sketch**: yes
- **notes**: none

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty, ...}` (lem:cech_free_eval_nonempty)

Pins 5 declarations: `cechFreeEval_quasiIso_of_nonempty`, `cechEngineComplexAug_quasiIso`,
`coverStructurePresheafEval_iso`, `coverStructurePresheafEval_iso_hom` (private),
`epi_cechEngineAug0` (private).

- **Lean targets exist**: yes
- **Signatures match**: yes — `cechFreeEval_quasiIso_of_nonempty (𝒰 : X.OpenCover) [Finite 𝒰.I₀] (V) (i_fix : {i : 𝒰.I₀ // V ≤ coverOpen 𝒰 i}) : QuasiIso (...cechFreeComplexAug 𝒰)`.
- **Proof follows sketch**: yes — transfer across `cechFreeEvalEngineIso` from `cechEngineComplexAug_quasiIso`; degree-0 comm-square via `cechFreeAug_eval_eq`; target iso via `coverStructurePresheafEval_iso`.
- **notes**: none

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (lem:cech_free_complex_quasi_iso)

- **Lean target exists**: yes — `theorem cechFreeComplex_quasiIso (𝒰 : X.OpenCover) [Finite 𝒰.I₀] : QuasiIso (cechFreeComplexAug 𝒰)`
- **Signature matches**: yes
- **Proof follows sketch**: yes — `quasiIso_of_evaluation`; splits on `∃ i, W ≤ coverOpen 𝒰 i` for empty vs nonempty case.
- **notes**: Blueprint carries `\leanok` on this block. Lean has no `sorry`. ✓

---

## Red flags

*(None.)*

No `sorry` bodies, no `:= True` / `:= Classical.choice _` on substantive claims, no excuse-comments, no unauthorized `axiom` declarations. The directive states all declarations in the `X.OpenCover` chain are axiom-clean; this is consistent with everything observed.

---

## Unreferenced declarations (informational)

### `section FamilyParameterized` — ~50 `…Fam` declarations, none blueprinted

The `section FamilyParameterized` block (lines 1451–2357 of the Lean file) introduces a
parallel family-parameterized re-indexing over a raw finite family `{ι : Type u} [Finite ι]
(U : ι → Opens ↥X)` (no covering hypothesis). Every `…Fam` declaration mirrors its `…` (X.OpenCover) counterpart exactly, with the mechanical substitution `𝒰.I₀ ↦ ι`, `coverOpen 𝒰 ↦ U`, `coverInterOpen 𝒰 ↦ coverInterOpenFam U`.

None of these declarations appear in any `\lean{...}` block in the blueprint. The substantive ones (those that should be blueprinted) are:

| Declaration | Type | Notes |
|---|---|---|
| `coverInterOpenFam` | `def` | parallel of `coverInterOpen` |
| `coverInterOpen_comp_leFam` | `lemma` | parallel of `coverInterOpen_comp_le` |
| `cechFreeSimplicialFam` | `noncomputable def` | parallel of `cechFreeSimplicial` |
| `cechFreePresheafComplexFam` | `noncomputable def` | parallel of `cechFreePresheafComplex` |
| `cechFreePresheafComplex_XFam` | `lemma` | parallel of `cechFreePresheafComplex_X` |
| `cechFreeAugFam` | `noncomputable def` | parallel of `cechFreeAug` |
| `coverStructurePresheafFam` | `noncomputable def` | parallel of `coverStructurePresheaf` |
| `cechFreeComplexAugFam` | `noncomputable def` | parallel of `cechFreeComplexAug` |
| `cechFreeComplexAug_f_zeroFam` | `lemma` | parallel of `cechFreeComplexAug_f_zero` |
| `cechFreeEval_XFam` | `noncomputable def` | parallel of `cechFreeEval_X` |
| `cechFreeEval_isZero_of_isEmptyFam` | `lemma` | parallel of `cechFreeEval_isZero_of_isEmpty` |
| `coverStructurePresheaf_eval_isZero_of_isEmptyFam` | `lemma` | parallel of `coverStructurePresheaf_eval_isZero_of_isEmpty` |
| `cechFreeEval_quasiIso_of_isEmptyFam` | `lemma` | parallel of `cechFreeEval_quasiIso_of_isEmpty` |
| `le_coverInterOpen_iffFam` | `lemma` | parallel of `le_coverInterOpen_iff` |
| `survivingEquivFam` | `def` | parallel of `survivingEquiv` |
| `cechFreeEvalDropZerosFam` | `noncomputable def` | parallel of `cechFreeEvalDropZeros` |
| `cechFreeEvalEngine_XFam` | `noncomputable def` | parallel of `cechFreeEvalEngine_X` |
| `cechEngineXFam` | `noncomputable abbrev` | parallel of `cechEngineX` |
| `cechEngineDFam` | `noncomputable def` | parallel of `cechEngineD` |
| `cechEngineD_ιFam` | `lemma` | parallel of `cechEngineD_ι` |
| `cechEngineD_compFam` | `lemma` | parallel of `cechEngineD_comp` |
| `cechEngineComplexFam` | `noncomputable def` | parallel of `cechEngineComplex` |
| `cechEnginePrependFam` | `noncomputable def` | parallel of `cechEnginePrepend` |
| `cechEnginePrepend_ιFam` | `lemma` | parallel of `cechEnginePrepend_ι` |
| `cechEnginePrepend_specFam` | `lemma` | parallel of `cechEnginePrepend_spec` |
| `cechEngineD_exactFam` | `lemma` | parallel of `cechEngineD_exact` |
| `cechFreeEvalEngineIsoFam` | `noncomputable def` | parallel of `cechFreeEvalEngineIso` |
| `cechEngineComplex_exactAtFam` | `lemma` | parallel of `cechEngineComplex_exactAt` |
| `cechEngineAug0Fam` | `noncomputable def` | parallel of `cechEngineAug0` |
| `cechEngineAug0_ιFam` | `lemma` | parallel of `cechEngineAug0_ι` |
| `cechEngineD_comp_augFam` | `lemma` | parallel of `cechEngineD_comp_aug` |
| `cechEngineComplexAugFam` | `noncomputable def` | parallel of `cechEngineComplexAug` |
| `cechEngineAug0_splitFam` | `lemma` | parallel of `cechEngineAug0_split` |
| `cechEngineComplexAug_f_zeroFam` | `lemma` | parallel of `cechEngineComplexAug_f_zero` |
| `cechEngineComplexAug_quasiIsoFam` | `lemma` | parallel of `cechEngineComplexAug_quasiIso` |
| `coverStructurePresheafEval_isoFam` | `noncomputable def` | parallel of `coverStructurePresheafEval_iso` |
| `cechFreeEval_quasiIso_of_nonemptyFam` | `lemma` | parallel of `cechFreeEval_quasiIso_of_nonempty` |
| `cechFreeComplex_quasiIsoFam` | **`theorem`** | **top result; parallel of `cechFreeComplex_quasiIso`; consumed by `injective_cech_acyclic`** |

Plus ~11 private helpers (`cechFreeEval_X_ι_invFam`, `cechFreeEvalEngine_X_inv_hom_ιFam`,
`cechFree_d_ιFam`, `cechFreeEvalEngine_map_ιFam`, `cechFreeEvalEngine_commFam`,
`cechFreeSimplicial_δ_comp_augFam`, `cechFree_d_comp_augFam`,
`cechFree_d_comp_factorThruImageFam`, `cechFreeAug_eval_eqFam`,
`epi_cechEngineAug0Fam`, `coverStructurePresheafEval_iso_homFam`,
`cechFreeEvalEngineIso_hom_fFam`).

**Faithfulness check.** Every `…Fam` declaration is a faithful re-parameterization: the Lean proof body is structurally identical to its `…` counterpart, with the only changes being `𝒰.I₀ ↦ ι`, `coverOpen 𝒰 (σ k) ↦ U (σ k)`, and `coverInterOpen 𝒰 σ ↦ coverInterOpenFam U σ`. No new hypotheses are added; the covering hypothesis is absent by design (the family form requires no surjectivity, only `[Finite ι]`). The top theorem `cechFreeComplex_quasiIsoFam` has the same proof structure as `cechFreeComplex_quasiIso`.

**X.OpenCover byte-identity check.** The original `X.OpenCover`-indexed declarations (lines 1–1449) are unchanged. The section comment at line 1460 explicitly says "The X.OpenCover-named declarations above are kept byte-identical (so CechBridge.lean stays green)". Every original declaration was verified present at its expected signature above.

---

## Blueprint adequacy for this file

- **Coverage**: ~75/~125 total non-private declarations have a corresponding `\lean{...}` block. The 75 blueprinted declarations are the entire X.OpenCover-indexed chain. The ~50 unreferenced declarations are the `…Fam` re-parameterization — all substantive, none are trivial helpers.

- **Proof-sketch depth**: **adequate** for the X.OpenCover chain. Every major proof step is previewed in the blueprint (objectwise reduction, degreewise iso assembly, empty/nonempty split). The proofs in the Lean file follow these sketches faithfully.

- **Hint precision**: **precise** for all 10 `\lean{...}` blocks. The pinned names are correct and well-resolved.

- **Generality**: **too narrow** for the family-parameterized use-case. The entire blueprint is written for `(𝒰 : X.OpenCover) [Finite 𝒰.I₀]`. The project ended up writing a parallel ~50-declaration section for `{ι : Type u} [Finite ι] (U : ι → Opens X)` because `injective_cech_acyclic` in `CechBridge.lean` requires the cover-agnostic form (no surjectivity of the family). The blueprint does not describe this generalization at all; a prover dispatched on only the blueprint could not have derived the `…Fam` section without additional guidance.

- **Recommended chapter-side actions**:
  - **Add a `section FamilyParameterized` note** to the blueprint (a `% NOTE:` or a new subsection near the end of the `Presheaf-level Čech machinery` section) explaining the re-parameterization strategy, with `\lean{...}` pins for at minimum: `AlgebraicGeometry.coverInterOpenFam`, `AlgebraicGeometry.cechFreePresheafComplexFam`, `AlgebraicGeometry.coverStructurePresheafFam`, `AlgebraicGeometry.cechFreeComplexAugFam`, and the top theorem `AlgebraicGeometry.cechFreeComplex_quasiIsoFam`.
  - **Correct the `combHomotopy` direction description** in the prose of `lem:free_cech_engine` (line ~1851): the blueprint describes `combHomotopy i_fix` as mapping `K_p → K_{p+1}` (chain-complex convention), but the Lean implementation is the cochain dual (lowering arity). The description should either be updated to the cochain direction or note the dual relationship explicitly to avoid confusing a reader who looks at the Lean type.

---

## Severity summary

| Finding | Severity | Declaration(s) |
|---|---|---|
| ~50 `…Fam` declarations (incl. `cechFreeComplex_quasiIsoFam`) have no `\lean{...}` blueprint coverage | **major** | entire `section FamilyParameterized` |
| `combHomotopy` prose describes chain-raising direction; Lean implements cochain-lowering direction | **minor** | `FreeCechEngine.combHomotopy` |

No must-fix-this-iter findings:
- No sorrys or placeholder bodies anywhere.
- No excuse-comments.
- No unauthorized axioms.
- No signature mismatches for any blueprinted declaration.
- The coverage gap for the `…Fam` section is mathematically sound (faithful re-parameterization, axiom-clean) and does not block the existing X.OpenCover proofs.

**Overall verdict**: The X.OpenCover-indexed chain (75 declarations across 10 blueprint blocks) is axiom-clean and faithful to its blueprint; the new `section FamilyParameterized` (~50 `…Fam` declarations including the top-result `cechFreeComplex_quasiIsoFam`) is a faithful cover-agnostic re-parameterization with no blueprint coverage — a **major** gap requiring a blueprint writer pass.
