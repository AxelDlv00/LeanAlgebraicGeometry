# Blueprint Review — iter-023

**Slug:** blueprint-reviewer-iter023  
**Iteration:** 023  
**Reviewer role:** whole-blueprint audit + HARD GATE for two prover files  
**Chapters audited:** 3 (all)

---

## Per-chapter checklist

### 1. `Cohomology_AcyclicResolution.tex` (P4)

| Check | Status |
|---|---|
| All lemmas have `\lean{}` pins | Yes |
| All cited labels resolve (`\uses{}`) | Yes — 0 unknown_uses from leandag |
| `\leanok` / `\mathlibok` markers consistent | Yes — all blocks marked |
| Proof sketches detailed enough to formalize | Yes — P4 is done (axiom-clean) |
| Citation discipline (`SOURCE:` / `SOURCE QUOTE:`) | Yes — present on sourced blocks |
| No isolated nodes | Yes — 0 isolated |

**`complete: true` | `correct: true`**

No must-fix-this-iter findings.

---

### 2. `Cohomology_HigherDirectImage.tex` (P5a leaf, 01XJ engine)

| Check | Status |
|---|---|
| All lemmas have `\lean{}` pins | Yes — `def:higher_direct_image` pinned + `\leanok` |
| All cited labels resolve (`\uses{}`) | Yes — 0 unknown_uses |
| `\leanok` present on proved decls | Yes |
| Proof sketches sufficient | Yes — P5a leaf axiom-clean |
| No isolated nodes | Yes |

**`complete: true` | `correct: true`**

No must-fix-this-iter findings.

---

### 3. `Cohomology_CechHigherDirectImage.tex` (consolidated, `% archon:covers` 6 files)

Covers: `CechHigherDirectImage.lean`, `CechAcyclic.lean`, `PresheafCech.lean`, `FreePresheafComplex.lean`, `CechBridge.lean`, `HigherDirectImagePresheaf.lean`.

| Check | Status |
|---|---|
| `% archon:covers` declared + covers correct files | Yes |
| All `\uses{}` edges resolve | Yes — 0 unknown_uses |
| No isolated blueprint nodes | Yes — 0 isolated |
| No orphan chapters | Yes — blueprint-doctor: `"orphan_chapters": []` |
| No broken `\ref{}` / `\uses{}` | Yes — blueprint-doctor: `"broken_refs": []` |
| No malformed refs | Yes — `"malformed_refs": []` |
| No covers-mapping problems | Yes — `"covers_problems": []` |
| Citation discipline | Yes — `SOURCE:` / `SOURCE QUOTE:` / `SOURCE QUOTE PROOF:` present on every sourced block in the HARD GATE blocks |
| Proof sketches sufficient for formalization | See HARD GATE detail below |

**`complete: true` | `correct: true`**

---

## HARD GATE — FreePresheafComplex.lean

**Verdict: CLEARED**

### `lem:cech_engine_complex`

- **14 engine declarations** all listed: `cechEngineObject`, `cechEngineMap`, `cechEngineComplex`, `cechEngineDiff_sq`, `cechEngineContracting`, `cechEngineExact`, `cechEngineZero`, `cechEngineAugmentation`, `cechFreeSimplicial`, `cechFreeSimplicialAugmented`, `cechFreePresheafComplex`, `cechFreeComplex_augmented`, `cechFreeComplex_exact`, `cechFreeComplex_zero`.
- `\lean{}` pin: `cechEngineComplex` (existing decl, axiom-clean in FreePresheafComplex.lean).
- `\uses{lem:free_cech_engine}` — label exists, resolves.
- Proof sketch: complete. Variance discussion (chain complex lowers face index; coproduct dual) fully documented.
- **No non-existent `\lean{}` pin.**

### `lem:cech_free_eval_engine_iso`

- `\lean{}` pin: `cechFreeEvalEngineIso` — the declared prover target for this iter; correctly identified as the remaining blocker.
- `\uses{lem:cech_free_eval_sectionwise, lem:free_cech_engine, lem:cech_engine_complex}` — all 3 labels exist and resolve.
- 3-layer proof sketch: (L1) sectionwise iso `cechFreeEval_X ≅ cechEngineComplex_X`; (L2) naturality in `X` (coherence square via Fin.cons decomposition); (L3) transport to chain-complex iso via uniqueness of the differential. The variance bottleneck is explicitly addressed (DFin vs Fin, biproduct vs product, coface vs face duality).
- **Complete and correct.**

### `lem:cech_free_eval_prepend_homotopy`

- `% NOTE:` annotation explicitly documents: **no standalone `\lean{}` pin by design** — this block is a transport corollary of the engine iso and the homotopy already proved; it does not correspond to a new Lean declaration.
- `\uses{lem:cech_free_eval_engine_iso, lem:cech_engine_complex, lem:free_cech_engine, lem:cech_free_eval_sectionwise}` — all 4 labels exist and resolve.
- Proof sketch describes the `prepend` algebra: transport the contracting homotopy through the engine→eval iso.
- **Complete and correct. Intentional pin absence is documented.**

### `lem:cech_free_eval_prepend_homotopy_spec`

- Same design decision: **no standalone `\lean{}` pin** (% NOTE present), same rationale.
- `\uses{lem:cech_free_eval_engine_iso, lem:cech_engine_complex, lem:cech_free_eval_prepend_homotopy, lem:free_cech_engine}` — all 4 labels resolve.
- **Complete and correct. Intentional pin absence is documented.**

### `lem:cech_free_eval_nonempty`

- `\lean{}` pin: `cechFreeEval_quasiIso_of_nonempty` — the declared prover target (nonempty glue step).
- `\uses{lem:cech_free_eval_engine_iso, lem:cech_free_eval_prepend_homotopy, lem:cech_free_eval_prepend_homotopy_spec, lem:cech_engine_complex, lem:free_cech_engine}` — all 5 labels resolve.
- Proof sketch: transport quasi-iso from the augmented engine complex to the eval complex when the cover is nonempty. Covers the `Fin.cons`/`h0` branch cleanly.
- **Complete and correct.**

### `lem:cech_free_complex_quasi_iso`

- `\lean{}` pin: `cechFreeComplex_quasiIso` — the final P3b free-side target.
- `\uses{lem:cech_free_eval_nonempty, lem:cech_free_eval_engine_iso, lem:cech_free_eval_prepend_homotopy, lem:cech_free_eval_prepend_homotopy_spec, lem:cech_engine_complex, lem:free_cech_engine, lem:cech_free_eval_sectionwise}` — all 7 labels resolve.
- Full `SOURCE QUOTE PROOF` present (Stacks reference).
- Proof sketch: reduce to `cechFreeEval_quasiIso_of_nonempty` (cover non-empty by assumption) + assemble via nonempty augmentation.
- **Complete and correct.**

**Prior iter "6 blueprint-side majors" confirmed RESOLVED**: leandag reports 0 `unknown_uses`. Every `\uses{}` in the 6 HARD GATE blocks now resolves.

---

## HARD GATE — CechBridge.lean

**Verdict: CLEARED**

### `lem:ses_cech_h1`

- `\lean{}` pin: `ses_cech_h1`.
- `\uses{def:cech_complex}` — **only one** dependency, resolves. Does NOT use `injective_cech_acyclic`, `cechFreeComplex_quasiIso`, or any other active prover target — self-contained as required.
- Statement block: verbatim source quote from `stacks-cohomology.tex` (`lemma-ses-cech-h1`), correctly attributed.
- Proof block: `SOURCE QUOTE PROOF` present, full Stacks argument (surjectivity on sections from Ȟ¹(𝒰,F)=0 via exactness of the degree-0/1 segment), sufficiently detailed for direct Lean formalization.
- Hypothesis: Ȟ¹(𝒰,F)=0 taken as a `h : IsZero ((cechComplex 𝒰 F).homology 1)` parameter — no circularity with `injective_cech_acyclic` or `cechFreeComplex_quasiIso`.
- **Complete, correct, and self-contained.**

---

## leandag / blueprint-doctor summary

```
unknown_uses : 0          ← no broken \uses{} edges
isolated     : 0          ← no orphan blueprint nodes
broken_refs  : []         ← blueprint-doctor clean
covers_problems: []       ← archon:covers mapping correct
```

`unmatched_lean` list (22 entries) is expected and non-blocking: entries are either unproven project targets (the prover's job this or future iters) or `\mathlibok` Mathlib items not expected in project Lean files.

---

## Must-fix-this-iter findings

**None.**

---

## Unstarted-phase blueprint proposals

**None.** All strategy phases have blueprint coverage:

- **P3** (`CechAcyclic.lean`) — active, chapter present, HARD GATE previously cleared.
- **P3b** (`PresheafCech.lean`, `FreePresheafComplex.lean`, `CechBridge.lean`) — active, chapter present, HARD GATE CLEARED this iter.
- **P5a** (`HigherDirectImagePresheaf.lean`) — active, chapter present, HARD GATE previously cleared (P5a leaf axiom-clean).
- **P5b** — blocked, but `cech_computes_higherDirectImage` assembly block present in chapter.

---

## Severity summary

| Severity | Count |
|---|---|
| Must-fix-this-iter (blocking HARD GATE) | 0 |
| Should-fix (non-blocking, next writer pass) | 0 |
| Informational | 0 |

---

## Overall verdict

**HARD GATE: CLEARED for both `FreePresheafComplex.lean` and `CechBridge.lean`.**

Both files may proceed to prover dispatch this iter. All `\uses{}` edges resolve. All `\lean{}` pins are either existing axiom-clean declarations (engine complex) or correctly identified as the prover's targets for this iter. The two intentionally pin-free homotopy-spec blocks are correctly annotated with `% NOTE:`. `ses_cech_h1` is self-contained and carries no circular dependency.
