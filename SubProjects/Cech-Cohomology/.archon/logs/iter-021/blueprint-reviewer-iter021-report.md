# Blueprint Review Report — iter-021

- **Slug**: iter021
- **Iteration**: 021
- **Reviewer**: blueprint-reviewer subagent
- **Gate target**: `FreePresheafComplex.lean` + `CechAcyclic.lean` prover dispatch

---

## Summary verdict

**HARD GATE CLEARS — no must-fix findings.**

Both `FreePresheafComplex.lean` and `CechAcyclic.lean` may proceed to prover dispatch this iter.

All three blueprint chapters are `complete: true` and `correct: true`.

---

## Directive-specific confirmations (5 items)

### Item 1 — No `CombinatorialCech.*` names in free-eval proof sketches

**RESOLVED.**

Searched all proof sketches under `lem:cech_free_eval_*`. The NOTE block at lines 1628–1631 explicitly
documents the design decision:

> "FreeCechEngine replicates the API of the private CombinatorialCech namespace, visible only to
> CechAcyclic.lean. This is a deliberate copy to cross the module-privacy barrier."

All proof sketches reference `FreeCechEngine.combHomotopy`, `FreeCechEngine.combHomotopy_spec`,
`FreeCechEngine.combDifferential`, etc. No `CombinatorialCech.*` name appears in any free-eval block.

### Item 2 — `FreeCechEngine` namespace blueprinted (`lem:free_cech_engine`)

**RESOLVED.**

`lem:free_cech_engine` block is present at lines 1632–1697. It lists:

```
\lean{AlgebraicGeometry.FreeCechEngine.combDifferential,
    AlgebraicGeometry.FreeCechEngine.combSign,
    AlgebraicGeometry.FreeCechEngine.combHomotopy,
    AlgebraicGeometry.FreeCechEngine.combHomotopy_spec,
    AlgebraicGeometry.FreeCechEngine.cons_comp_succAbove_succ,
    AlgebraicGeometry.FreeCechEngine.combSign_flip}
```

Statement prose characterises the namespace as the public constant-coefficient combinatorial Čech
homotopy engine. SOURCE: comment points to `references/stacks-cohomology.tex` (L1245–1268).

### Item 3 — `lem:cech_free_eval_engine_iso` with accurate `\uses{}` and real proof sketch

**RESOLVED.**

Block present at lines 1699–1775. Key fields:

```
\label{lem:cech_free_eval_engine_iso}
\lean{AlgebraicGeometry.cechFreeEvalEngineIso}
\uses{lem:cech_free_eval_sectionwise, lem:free_cech_engine}
```

The `\uses{}` is accurate and minimal:
- `lem:cech_free_eval_sectionwise` supplies the degreewise `cechFreeEval_X` identification;
- `lem:free_cech_engine` supplies `FreeCechEngine.combDifferential` for the differential match.

The proof sketch is substantive:
- **Degreewise identification**: applies `cechFreeEval_X` degree-by-degree via `ChainComplex.ext`;
  each degree-`p` component is `⊕_{σ : Fin(p+1)→I₁} O_X(V)`, matching the evaluated free complex and
  the engine complex by `Limits.Sigma.hom_ext` + `Limits.PreservesCoproduct.iso`.
- **Differential match**: shows `FreeCechEngine.combDifferential` coincides with the differential
  induced by `PresheafOfModules.evaluation V`, term by term via sigma-decomposition.

This node unblocks the `cechFreeComplex_quasiIso` route: the 6-link `\uses` chain at
`lem:cech_free_complex_quasi_iso` (line 1969) now includes `lem:cech_free_eval_engine_iso`.

### Item 4 — `lem:section_cech_homology_exact` uses `ShortComplex.ab_exact_iff`, 3-sub-lemma chain

**RESOLVED.**

Block at lines 605–747. Lines 680–688 give the explicit rationale:

> "The degree-p object of `sectionCechComplex R s F` is the categorical product `∏_{σ : Fin(p+1)→I} F(D(sσ))`
> in the category **Ab** of abelian groups, not an R-module product. Therefore
> `ShortComplex.moduleCat_exact_iff` does NOT apply. The correct reduction uses
> `ShortComplex.ab_exact_iff` (Lemma \ref{lem:section_cech_ab_exact})."

The three sub-lemmas are present with explicit intended Lean names:

| Block | `\lean{}` name | Purpose |
|---|---|---|
| `lem:section_cech_product_equiv` | `AlgebraicGeometry.sectionCechProductEquiv` | degreewise ≅ with module-level product |
| `lem:section_cech_coface_match` | `AlgebraicGeometry.sectionCechCofaceMatch` | coface differentials match under the equiv |
| `lem:section_cech_ab_exact` | `AlgebraicGeometry.sectionCechAbExact` | ShortComplex.ab_exact_iff closes exactness |

The parent block `\uses{}` includes all three sub-lemmas plus `def:qcoh_sections_localized` and
`def:section_cech_complex`.

### Item 5 — `def:qcoh_sections_localized` lists `basicOpen_sprod` + `qcohRestriction_eq_comparison`

**RESOLVED.**

Block at lines 528–603. `\lean{}` list (lines 535–545):

```
\lean{AlgebraicGeometry.qcohSectionsAwayLocalized,
    AlgebraicGeometry.basicOpen_sprod,
    AlgebraicGeometry.iInf_fin_succ,
    AlgebraicGeometry.qcohRestriction_eq_comparison}
```

Prose at lines 565–585 explains their roles:
- `basicOpen_sprod`: the multi-index intersection identity `⋂ D(s_{σ(k)}) = D(∏ s_{σ(k)})`;
- `qcohRestriction_eq_comparison`: identifies the restriction map `F(D(g₁)) → F(D(g₁g₂))` with the
  away-localization comparison `M_{g₁} → M_{g₁g₂}`.

The block carries `\leanok` (set by `sync_leanok` — authoritative).

---

## Per-chapter verdicts

### `Cohomology_HigherDirectImage.tex`

```
complete: true
correct:  true
notes:    Single block def:higher_direct_image, \leanok, SOURCE present, citation file exists.
          No issues.
```

### `Cohomology_AcyclicResolution.tex`

```
complete: true
correct:  true
notes:    All declaration blocks carry either \leanok or \mathlibok. No broken \uses{} edges.
          All SOURCE: pointers verified against references/. No isolated nodes. No issues.
```

### `Cohomology_CechHigherDirectImage.tex`

```
complete: true
correct:  true
notes:    See detailed findings below.
```

**Blocks for `FreePresheafComplex.lean`** (8 gate blocks):

| Block | Status | Notes |
|---|---|---|
| `lem:free_cech_engine` | ready | full `FreeCechEngine.*` namespace, NOTE explaining copy rationale |
| `lem:cech_free_eval_engine_iso` | ready | new node; `\lean{cechFreeEvalEngineIso}`; directive item 3 resolved |
| `lem:cech_free_eval_sectionwise` | ready | `\lean{cechFreeEval_X}`; degreewise reduction, augmentation handled |
| `lem:cech_free_eval_empty` | ready | trivial quasi-iso for empty `I₁` case |
| `lem:cech_free_eval_prepend_homotopy` | ready | references `FreeCechEngine.combHomotopy`; `\uses` includes engine iso |
| `lem:cech_free_eval_prepend_homotopy_spec` | ready | hard-core `d∘h+h∘d=id`; index bookkeeping detailed; references `FreeCechEngine.combHomotopy_spec`, `cons_comp_succAbove_succ`, `combSign_flip` |
| `lem:cech_free_eval_nonempty` | ready | packages homotopy → `QuasiIso`; references `Homotopy.toQuasiIso` / `HomotopyEquiv.toQuasiIso` |
| `lem:cech_free_complex_quasi_iso` | ready | 6-link `\uses` chain complete; glue proof via `quasiIso_of_evaluation` |

**Blocks for `CechAcyclic.lean`** (6 gate blocks):

| Block | Status | Notes |
|---|---|---|
| `def:qcoh_sections_localized` | ready (`\leanok`) | directive item 5 resolved; `basicOpen_sprod` + `qcohRestriction_eq_comparison` present |
| `lem:section_cech_homology_exact` | ready | directive item 4 resolved; `ShortComplex.ab_exact_iff`; 3 sub-lemma chain |
| `lem:section_cech_product_equiv` | ready | `\lean{sectionCechProductEquiv}`; prover target, absence not a defect |
| `lem:section_cech_coface_match` | ready | `\lean{sectionCechCofaceMatch}`; prover target, absence not a defect |
| `lem:section_cech_ab_exact` | ready | `\lean{sectionCechAbExact}`; prover target, absence not a defect |
| `lem:cech_acyclic_affine` §section form | ready | `\lean{sectionCech_affine_vanishing}`; assembles (b)+(c); `\uses` correct |
| `def:section_cech_module_complex` | ready (`\leanok`) | D• infra block; `\leanok` |
| `lem:section_cech_module_exact` | ready (`\leanok`) | `dDiff_exact` landed iter-019; `\leanok` |

---

## DAG health (leandag)

```
unknown_uses:  []    (0 broken \uses{} edges)
isolated:      0     (no node unreachable from the root)
gaps:          0     (all nodes have at least one \lean{} hint)
proved:        19    (\leanok nodes)
with_sorry:    2     (both intentional: line-109 superseded relative form; frozen P5b)
unmatched:     29    (see below)
```

**Unmatched `\lean{}` (29 total — all expected, zero defects):**

- 9 entries: `\mathlibok`-tagged Mathlib declarations (not project-side Lean files; they are
  intentionally unmatched by design).
- 20 entries: prover targets for this and future iters that do not yet exist in Lean:
  `cechFreeEvalEngineIso`, `sectionCechProductEquiv`, `sectionCechCofaceMatch`, `sectionCechAbExact`,
  and 16 further unbuilt declarations across the FreePresheafComplex / CechBridge / CechAcyclic /
  HigherDirectImagePresheaf lanes. Absence is not a defect.

---

## Rendering health (archon blueprint-doctor)

```
malformed_refs:  []
broken_refs:     []
orphan_chapters: []
axiom_decls:     []
covers_problems: []
```

Clean pass. All `\ref{}` / `\uses{}` targets resolve. No undefined macros or missing `\label{}` entries.
All reference files confirmed present under `references/`.

---

## Strategy coverage

All four strategy phases have adequate blueprint coverage. No unstarted-phase proposals.

| Phase | Coverage |
|---|---|
| P3 standard-cover Čech vanishing | `def:qcoh_sections_localized`, `lem:section_cech_homology_exact` + 3 sub-lemmas, `lem:cech_acyclic_affine` |
| P3b Čech↔derived bridge | `lem:free_cech_engine`, `lem:cech_free_eval_*` (6 nodes), `lem:cech_free_complex_quasi_iso`, `lem:cech_complex_hom_identification`, `lem:injective_cech_acyclic`, `lem:ses_cech_h1`, `lem:cech_vanish_basis`, `def:affine_serre_vanishing` |
| P5a vanishing inputs | `lem:higher_direct_image_presheaf` (`\leanok`), `lem:homology_iso_sheafify` engine nodes |
| P5b comparison assembly | frozen `lem:cech_computes_cohomology` + cone (P5b BLOCKED; blueprint coverage present) |

---

## Informational note (non-blocking, for plan agent)

**PROGRESS.md line 86 is stale.** The CechAcyclic step (c) description still reads:

> `ShortComplex.moduleCat_exact_iff` turn `dDiff_exact` into `IsZero (homology p)`

The blueprint was correctly updated (blueprint-writer + blueprint-clean pass, this iter) to
`ShortComplex.ab_exact_iff`. The PROGRESS.md objective for step (c) should be updated to match.
The prover recipe (`task_results/CechAcyclic.md`) should also be verified for consistency.
This is informational only — it does not block prover dispatch; the blueprint is the authoritative
source for prover instructions.

---

## Final verdict

```
FreePresheafComplex.lean:  HARD GATE CLEARS
CechAcyclic.lean:          HARD GATE CLEARS

All 5 directive items:     RESOLVED
Blueprint chapters:        complete: true, correct: true (all 3)
Must-fix findings:         none
Soon findings:             none
Unstarted-phase proposals: none
```

Both `FreePresheafComplex.lean` and `CechAcyclic.lean` may proceed to prover dispatch for iter-021.
