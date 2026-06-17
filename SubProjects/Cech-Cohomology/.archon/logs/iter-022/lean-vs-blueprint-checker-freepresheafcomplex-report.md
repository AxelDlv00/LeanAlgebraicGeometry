# Lean ↔ Blueprint Check Report

## Slug
freepresheafcomplex

## Iteration
022

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean` (995 lines)
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex` (relevant section: `\subsection{Presheaf-level Čech machinery}`, lines 1315–2155+)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechFreePresheafComplex}` (def:cech_free_presheaf_complex)
- **Lean target exists**: yes (line 201)
- **Signature matches**: yes — `ChainComplex X.PresheafOfModules ℕ` indexed by a finite cover
- **Proof follows sketch**: yes — built as `alternatingFaceMapComplex.obj (cechFreeSimplicial 𝒰)`, exactly the simplicial route the blueprint recommends
- **notes**: All 7 helper decls in this block (`freeYoneda`, `coverOpen`, `coverInterOpen`, `coverInterOpen_comp_le`, `cechFreeSimplicial`, `cechFreePresheafComplex_X`, `sigma_ι_eqToHom_transport`) present and type-match the prose. `sigma_ι_eqToHom_transport` is `private`, which is fine.

### `\lean{AlgebraicGeometry.coverStructurePresheaf}` etc. (def:cover_structure_presheaf)
- **Lean target exists**: yes — all 11 decls in the `\lean{}` list exist (lines 224–350)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `cechFreeSimplicial_δ_comp_aug`, `cechFree_d_comp_aug`, `cechFree_d_comp_factorThruImage`, `freeYonedaAug_app_freeMk` are `private`; that matches their use as internal helpers.

### `\lean{AlgebraicGeometry.quasiIso_of_evaluation}` etc. (lem:quasiIso_of_evaluation)
- **Lean target exists**: yes — `quasiIso_of_evaluation` (line 414), `isIso_Fmap_homologyMap` (line 366), `isIso_of_evaluation` (line 391)
- **Signature matches**: yes
- **Proof follows sketch**: yes — joint-conservativity + evaluation-preserves-homology route exactly as described
- **notes**: `isIso_Fmap_homologyMap` and `isIso_of_evaluation` are `private` helpers.

### `\lean{AlgebraicGeometry.cechFreeEval_X}` etc. (lem:cech_free_eval_sectionwise)
- **Lean target exists**: yes — all 3 decls (`cechFreeEval_X` line 574, `freeYonedaEval_iso_of_le` line 612, `freeYonedaEval_isZero_of_not_le` line 594)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: Clean.

### `\lean{AlgebraicGeometry.FreeCechEngine.combDifferential}` etc. (lem:free_cech_engine)
- **Lean target exists**: yes — all 10 decls in this block exist (lines 452–551, 621–628)
- **Signature matches**: yes — constant-coefficient engine with the Stacks-matching definitions
- **Proof follows sketch**: yes — `combHomotopy_spec` is the exact `dh + hd = id` cancellation
- **notes**: `isZero_sigma_of_forall_isZero` (line 621) is listed in this block; it lives after the `FreeCechEngine` namespace, which is fine.

### `\lean{AlgebraicGeometry.cechFreeEvalEngineIso}` (lem:cech_free_eval_engine_iso)
- **Lean target exists**: **no** — `cechFreeEvalEngineIso` does not appear anywhere in the file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The file has an explicit honest "REMAINING BOTTLENECK" comment at lines 961–992 that (a) reproduces the intended signature in full, (b) explains the proof route, and (c) explicitly states "This is an all-or-nothing `def`, so it is NOT pinned with a `sorry` here." There is no fake statement, no sorry, no axiom. This is a documented unbuilt declaration.

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_isEmpty}` etc. (lem:cech_free_eval_empty)
- **Lean target exists**: yes — all 4 decls (`cechFreeEval_quasiIso_of_isEmpty` line 687, `cechFreeEval_isZero_of_isEmpty` line 638, `coverStructurePresheaf_eval_isZero_of_isEmpty` line 656, `isZero_homology_of_isZero_X` line 673)
- **Signature matches**: yes
- **Proof follows sketch**: yes
- **notes**: `isZero_homology_of_isZero_X` is also used by `lem:cech_free_eval_empty`. Clean.

### `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy}` (lem:cech_free_eval_prepend_homotopy)
- **Lean target exists**: **no** — `cechFreeEvalPrependHomotopy` does not exist
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: ⚠ MISMATCH (see §Critical re-leveling below). The blueprint prose describes the homotopy on the *evaluated* complex `K(𝒰)_•(V)`. The prover instead built `cechEnginePrepend` (line 893) at the *engine complex* level (`cechEngineComplex`). Closest existing declaration: `AlgebraicGeometry.cechEnginePrepend`.

### `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy_spec}` (lem:cech_free_eval_prepend_homotopy_spec)
- **Lean target exists**: **no** — `cechFreeEvalPrependHomotopy_spec` does not exist
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: ⚠ MISMATCH (same as above). Blueprint pins the contracting identity on the evaluated complex. Built: `cechEnginePrepend_spec` (line 913) at engine level. Closest existing declaration: `AlgebraicGeometry.cechEnginePrepend_spec`.

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty}` (lem:cech_free_eval_nonempty)
- **Lean target exists**: **no**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blocked on `cechFreeEvalEngineIso`; consistent with documented bottleneck. No placeholder.

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (lem:cech_free_complex_quasi_iso)
- **Lean target exists**: **no**
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blocked on `cechFreeEval_quasiIso_of_nonempty` → `cechFreeEvalEngineIso`. No placeholder.

---

## Red flags

No `sorry`, no `axiom`, no `:= True`, no excuse-comments on existing declarations. The "REMAINING BOTTLENECK" comment (lines 961–992) is an honest unbuilt-note, not an excuse for wrong code — the declaration it describes does not exist at all in the file. **No red flags.**

---

## Critical re-leveling finding

**`lem:cech_free_eval_prepend_homotopy` / `lem:cech_free_eval_prepend_homotopy_spec` — blueprint pins wrong abstraction level.**

The blueprint `\lean{}` hints pin declarations at the *evaluated-complex* level:
- `AlgebraicGeometry.cechFreeEvalPrependHomotopy` — homotopy on `K(𝒰)_•(V)`
- `AlgebraicGeometry.cechFreeEvalPrependHomotopy_spec` — contracting identity `dh + hd = id` on `K(𝒰)_•(V)`

What was built are the equivalent declarations at the *engine-complex* level:
- `AlgebraicGeometry.cechEnginePrepend` (line 893) — homotopy on `cechEngineComplex`
- `AlgebraicGeometry.cechEnginePrepend_spec` (line 913) — contracting identity on `cechEngineComplex`

The evaluated-complex-level names are *unreachable* until `cechFreeEvalEngineIso` exists (it is the transport bridge between the two levels). Building the evaluated-level declarations by wrapping the engine-level ones via `cechFreeEvalEngineIso` is option (b); but that iso is the documented bottleneck.

**Recommended fix: option (a) — blueprint-side re-leveling.**

In the blueprint:
1. Add a new `\begin{lemma}...\end{lemma}` block `lem:cech_engine_complex` (the prover explicitly flagged this gap, see module comment lines 798–806) that pins the 14 engine-complex declarations listed in §Unreferenced declarations below.
2. Re-point `lem:cech_free_eval_prepend_homotopy` to pin `AlgebraicGeometry.cechEnginePrepend` (dropping the evaluated-complex framing), and `lem:cech_free_eval_prepend_homotopy_spec` to pin `AlgebraicGeometry.cechEnginePrepend_spec`.
3. Add a sentence noting that the evaluated-complex forms (`cechFreeEvalPrependHomotopy`, `_spec`) follow by transport across `cechFreeEvalEngineIso` once that iso is built — they are not separate targets but corollaries of `lem:cech_engine_complex` + `lem:cech_free_eval_engine_iso`.

Option (b) — building the evaluated-level names now — is blocked until `cechFreeEvalEngineIso` is proved, so option (a) is the correct immediate action.

---

## Unreferenced declarations (informational)

The following 14 declarations in the Lean file have no `\lean{}` reference in any blueprint block. All are substantive (not mere `private` bookkeeping); they correspond to the "14 axiom-clean decls" claimed landed this iteration. They all have fully closed non-sorry bodies.

| Declaration | Line | Blueprint home (proposed) |
|---|---|---|
| `le_coverInterOpen_iff` | 723 | new `lem:cech_engine_complex` |
| `survivingEquiv` | 733 | new `lem:cech_engine_complex` |
| `cechFreeEvalDropZeros` | 747 | new `lem:cech_engine_complex` |
| `cechFreeEvalEngine_X` | 784 | new `lem:cech_engine_complex` (object half of engine iso) |
| `coverSectionModule` | 810 | new `lem:cech_engine_complex` |
| `cechEngineX` | 815 | new `lem:cech_engine_complex` |
| `cechEngineD` | 823 | new `lem:cech_engine_complex` |
| `cechEngineD_ι` | 831 | new `lem:cech_engine_complex` |
| `cechEngineD_comp` | 842 | new `lem:cech_engine_complex` |
| `cechEngineComplex` | 879 | new `lem:cech_engine_complex` |
| `cechEnginePrepend` | 893 | new `lem:cech_engine_complex` (+ re-pointed from `lem:cech_free_eval_prepend_homotopy`) |
| `cechEnginePrepend_ι` | 901 | new `lem:cech_engine_complex` |
| `cechEnginePrepend_spec` | 913 | new `lem:cech_engine_complex` (+ re-pointed from `lem:cech_free_eval_prepend_homotopy_spec`) |
| `cechEngineD_exact` | 941 | new `lem:cech_engine_complex` |

These 14 decls are the complete engine-complex layer. They form a self-contained block: differential (`cechEngineD`) with `d²=0` (`cechEngineD_comp`), assembled into a chain complex (`cechEngineComplex`), plus a contracting homotopy (`cechEnginePrepend` / `_spec`) yielding positive-degree exactness (`cechEngineD_exact`). `le_coverInterOpen_iff`, `survivingEquiv`, `cechFreeEvalDropZeros`, and `cechFreeEvalEngine_X` are the degreewise-iso building blocks (object half of `cechFreeEvalEngineIso`).

---

## Honest not-built note verification

**`cechFreeEvalEngineIso` — verdict: honest unbuilt.**

The comment block at lines 961–992 is confirmed honest:
- No declaration stub (no `def cechFreeEvalEngineIso ... := sorry`)
- No axiom
- No weakened-wrong stand-in definition
- The comment accurately describes the missing proof obligation (the differential comm-square) and a concrete proof route
- The explicit line "This is an all-or-nothing `def`, so it is NOT pinned with a `sorry` here" correctly identifies the engineering choice

This is the appropriate treatment for an all-or-nothing chain-iso (a sorry here would give a false `\leanok` and hide the actual gap from the sync_leanok phase).

---

## Blueprint adequacy for this file

- **Coverage**: 22/36 Lean declarations have a `\lean{}` reference (counting all private helpers). Of the 14 unreferenced declarations, all 14 are substantive and need a new `lem:cech_engine_complex` blueprint block.
- **Proof-sketch depth**: **under-specified** for `lem:cech_free_eval_engine_iso`. The proof sketch describes the degreewise part and mentions `Limits.Sigma.hom_ext` + `Limits.PreservesCoproduct.iso`, but does not describe:
  - The role of the `cechFreeEvalDropZeros` / `survivingEquiv` / `Limits.Sigma.whiskerEquiv` layers
  - The naturality of `survivingEquiv` w.r.t. the face reindex `σ ↦ σ ∘ Fin.succAbove i` (the key step needed to commute the drop-zeros and whisker layers past the differential)
  - The collapse of `freeYoneda.map (homOfLE …)` to the identity via `freeYonedaEval_iso_of_le` on surviving summands

  The Lean remaining-bottleneck comment (lines 972–992) provides a more complete route than the blueprint sketch. This gap may be part of why the comm-square has not been discharged.
- **Hint precision**: **loose** for `lem:cech_free_eval_prepend_homotopy` and `lem:cech_free_eval_prepend_homotopy_spec` — the pinned names do not exist (wrong abstraction level). **Wrong** in the sense that these `\lean{}` references will never resolve without `cechFreeEvalEngineIso`.
- **Generality**: matches need — no level-of-generality complaint.

**Recommended chapter-side actions:**
1. **Add `lem:cech_engine_complex`**: A new blueprint lemma covering the 14 engine-complex declarations. Suggested scope: the chain complex `C_p = ∐_{σ : Fin(p+1) → I₁(V)} O_X(V)`, its differential, `d²=0`, the prepend-`i_fix` contracting homotopy, and positive-degree exactness. This is the chain-dual / coproduct-version counterpart of `FreeCechEngine`.
2. **Re-point `lem:cech_free_eval_prepend_homotopy` `\lean{}`**: change to `AlgebraicGeometry.cechEnginePrepend`; re-level prose to say the homotopy is on `cechEngineComplex`, with a note that the evaluated-complex form follows by transport across `cechFreeEvalEngineIso`.
3. **Re-point `lem:cech_free_eval_prepend_homotopy_spec` `\lean{}`**: change to `AlgebraicGeometry.cechEnginePrepend_spec`; same note.
4. **Expand `lem:cech_free_eval_engine_iso` proof sketch**: add a paragraph describing the `cechFreeEvalDropZeros` / `survivingEquiv` / `Limits.Sigma.whiskerEquiv` naturality step for the differential match. Specifically: why `survivingEquiv` is natural with respect to `σ ↦ σ ∘ Fin.succAbove i` (so the whiskerEquiv layer commutes with each face), and why `freeYoneda.map (homOfLE …)` collapses to the identity under `freeYonedaEval_iso_of_le`.

---

## Severity summary

| Finding | Severity |
|---|---|
| `\lean{}` in `lem:cech_free_eval_prepend_homotopy` pins non-existent `cechFreeEvalPrependHomotopy` (wrong level) | **major** |
| `\lean{}` in `lem:cech_free_eval_prepend_homotopy_spec` pins non-existent `cechFreeEvalPrependHomotopy_spec` (wrong level) | **major** |
| 14 axiom-clean substantive decls have no `\lean{}` reference (missing `lem:cech_engine_complex` block) | **major** |
| `cechFreeEvalEngineIso` not built (documented bottleneck; no sorry/axiom) | **major** |
| `cechFreeEval_quasiIso_of_nonempty` and `cechFreeComplex_quasiIso` not built (downstream of bottleneck) | **major** |
| `lem:cech_free_eval_engine_iso` proof sketch under-specified for the `cechFreeEvalDropZeros`/`survivingEquiv` naturality step | **major** |

No **must-fix-this-iter** findings: there are no placeholder bodies, no axioms on substantive claims, no excuse-comments on existing declarations, and no wrong signatures on declarations that exist.

**Overall verdict**: The file is axiom-clean and internally consistent; the four missing declarations (`cechFreeEvalEngineIso`, `cechFreeEvalPrependHomotopy`, `cechFreeEvalPrependHomotopy_spec`, `cechFreeEval_quasiIso_of_nonempty`) are all blocked on the single differential comm-square, the bottleneck is honestly documented, and the 14 landed declarations need a new `lem:cech_engine_complex` blueprint block plus re-pointing of two `\lean{}` hints from the evaluated-complex level to the engine-complex level. — 22 declarations checked (against `\lean{}` refs), 14 unreferenced, 0 red flags.
