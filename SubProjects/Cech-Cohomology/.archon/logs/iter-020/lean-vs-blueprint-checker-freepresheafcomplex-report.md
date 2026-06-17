# Lean ↔ Blueprint Check Report

## Slug
freepresheafcomplex

## Iteration
020

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks: `def:cech_free_presheaf_complex`, `def:cover_structure_presheaf`,
  `lem:quasiIso_of_evaluation`, `lem:cech_free_eval_sectionwise`,
  `lem:cech_free_eval_empty`, `lem:cech_free_eval_prepend_homotopy`,
  `lem:cech_free_eval_prepend_homotopy_spec`, `lem:cech_free_eval_nonempty`,
  `lem:cech_free_complex_quasi_iso`)

---

## Sorry count

**0 sorries. 0 `axiom` declarations.** The file is fully axiom-clean.

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechFreePresheafComplex, freeYoneda, coverOpen, coverInterOpen, coverInterOpen_comp_le, cechFreeSimplicial, cechFreePresheafComplex_X, sigma_ι_eqToHom_transport}` (chapter: `def:cech_free_presheaf_complex`)

- **Lean targets exist**: yes — all 8 named decls present
- **Signature matches**: yes — `cechFreePresheafComplex` is `(alternatingFaceMapComplex).obj (cechFreeSimplicial 𝒰)`, which is exactly the simplicial-route plan the blueprint recommends; `cechFreeSimplicial` has the correct coproduct-of-freeYoneda structure; `cechFreePresheafComplex_X` is `rfl`; helpers are correct
- **Proof follows sketch**: yes — blueprint recommends the simplicial route for automatic `d²=0` and the Lean implementation follows this exactly; `sigma_ι_eqToHom_transport` provides the dependent-index bookkeeping for simplicial identities as the blueprint anticipates
- **Notes**: `def:cech_free_presheaf_complex` lacks `\leanok` in the blueprint — likely because `sync_leanok` has not re-run since this iter's prover session landed these decls. Once sync runs, all 8 decls will be marked.

---

### `\lean{AlgebraicGeometry.coverStructurePresheaf, cechFreeAug, cechFreeComplexAug, cechFreeComplexAug_f_zero, cechFreeSimplicial_δ_comp_aug, cechFree_d_comp_aug, cechFree_d_comp_factorThruImage, freeYonedaAug, freeYonedaAug_app_freeMk, freeYonedaHomEquiv_freeYonedaAug, freeYoneda_map_comp_aug}` (chapter: `def:cover_structure_presheaf`)

- **Lean targets exist**: yes — all 11 present (4 private helpers, 7 public)
- **Signature matches**: yes — `coverStructurePresheaf 𝒰 = Limits.image (cechFreeAug 𝒰)` matches blueprint; `cechFreeComplexAug` is the correct chain map `cechFreePresheafComplex 𝒰 ⟶ (ChainComplex.single₀).obj (coverStructurePresheaf 𝒰)`; augmentation naturality (`freeYoneda_map_comp_aug`) present
- **Proof follows sketch**: yes — `cechFree_d_comp_aug` proves `d ≫ aug = 0` from `cechFreeSimplicial_δ_comp_aug`; `cechFree_d_comp_factorThruImage` factors through the image; `cechFreeComplexAug` uses `toSingle₀Equiv`
- **Notes**: `def:cover_structure_presheaf` also lacks `\leanok` in the blueprint — same sync_leanok timing issue.

---

### `\lean{AlgebraicGeometry.quasiIso_of_evaluation, isIso_Fmap_homologyMap, isIso_of_evaluation}` (chapter: `lem:quasiIso_of_evaluation`)

- **Lean targets exist**: yes — all 3 present (`isIso_Fmap_homologyMap` and `isIso_of_evaluation` private)
- **Signature matches**: yes — `quasiIso_of_evaluation` has the correct type: given `∀ V, QuasiIso ((eval V).mapHomologicalComplex.map φ)` then `QuasiIso φ`; matches the blueprint's joint-conservativity claim
- **Proof follows sketch**: yes — proof uses `quasiIso_iff` + `quasiIsoAt_iff_isIso_homologyMap` + `isIso_of_evaluation` (joint conservativity) + `isIso_Fmap_homologyMap` (evaluation preserves homology via `ShortComplex.mapHomologyIso_hom_naturality`); blueprint's proof outline matches
- **Notes**: `lem:quasiIso_of_evaluation` lacks `\leanok` in the blueprint — sync_leanok timing issue.

---

### `\lean{AlgebraicGeometry.cechFreeEval_X}` (chapter: `lem:cech_free_eval_sectionwise`)

- **Lean target exists**: yes
- **Signature matches**: **partial** — see Red Flags §Signature mismatch
- **Proof follows sketch**: yes, for the subset the decl covers — `PreservesColimitsOfShape` via `evaluation_preservesFiniteColimits`, then `PreservesCoproduct.iso`
- **Notes**: blueprint `\leanok` present on both statement and proof blocks. The sync_leanok correctly found `cechFreeEval_X` is clean. However, the CONTENT of what `cechFreeEval_X` states is only the first step of what `lem:cech_free_eval_sectionwise` claims — see Red Flags.

---

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_isEmpty}` (chapter: `lem:cech_free_eval_empty`)

- **Lean target exists**: yes
- **Signature matches**: yes — `QuasiIso ((eval V).mapHomologicalComplex.map (cechFreeComplexAug 𝒰))` under hypothesis `∀ i, ¬ V ≤ coverOpen 𝒰 i`; exactly the blueprint's "I₁ = ∅" case
- **Proof follows sketch**: yes — `isZero_of_source_target_iso_zero` applied after showing both source and target homology vanish via `isZero_homology_of_isZero_X`; uses `cechFreeEval_isZero_of_isEmpty` and `coverStructurePresheaf_eval_isZero_of_isEmpty`
- **Notes**: blueprint `\leanok` present. The intermediate helpers `cechFreeEval_isZero_of_isEmpty` and `coverStructurePresheaf_eval_isZero_of_isEmpty` are in the Lean file but unblueprinted — see Unreferenced Declarations.

---

### `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy}` (chapter: `lem:cech_free_eval_prepend_homotopy`)

- **Lean target exists**: **NO** — declaration absent from file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **Notes**: This is the main missing nonempty-case ingredient. The blueprint designates this as a `HomologicalComplex.Homotopy`. Blueprint adequacy issues for building it — see Blueprint Adequacy section.

---

### `\lean{AlgebraicGeometry.cechFreeEvalPrependHomotopy_spec}` (chapter: `lem:cech_free_eval_prepend_homotopy_spec`)

- **Lean target exists**: **NO** — declaration absent from file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A — but the blueprint's proof sketch is wrong; it references `CombinatorialCech.combHomotopy_spec` which is private. See Must-Fix.

---

### `\lean{AlgebraicGeometry.cechFreeEval_quasiIso_of_nonempty}` (chapter: `lem:cech_free_eval_nonempty`)

- **Lean target exists**: **NO** — absent
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

---

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (chapter: `lem:cech_free_complex_quasi_iso`)

- **Lean target exists**: **NO** — the named main target is absent
- **Signature matches**: N/A
- **Proof follows sketch**: N/A

---

## Red Flags

### Signature mismatch (major)

**`cechFreeEval_X` vs `lem:cech_free_eval_sectionwise`**

The blueprint lemma `lem:cech_free_eval_sectionwise` claims the full identification:
```
K(𝒰)_p(V) = ⊕_{σ : Fin(p+1) → I₁(V)}  O_X(V)
```
where `I₁(V) = {i : V ≤ Uᵢ}` and each summand is identified with `O_X(V)` (not just `eval(freeYoneda(Uσ))`).

The Lean type of `cechFreeEval_X` is:
```lean
(evaluation V).obj ((cechFreePresheafComplex 𝒰).X p)
  ≅ ∐ fun σ : Fin (p + 1) → 𝒰.I₀ =>
      (evaluation V).obj (freeYoneda.obj (coverInterOpen 𝒰 σ))
```

This is the **evaluation-commutes-with-coproduct** step only. It does NOT filter to `I₁(V)` and does NOT identify each summand as `O_X(V)`. The two remaining steps — (1) `freeYonedaEval_isZero_of_not_le` kills non-I₁ summands, (2) `freeYonedaEval_iso_of_le` identifies surviving summands as `O_X(V)` — are in the file but are separate unnamed-from-blueprint helper lemmas.

Consequence: the `\lean{cechFreeEval_X}` hint names a declaration whose type is strictly weaker than the statement of `lem:cech_free_eval_sectionwise`. Downstream provers building `cechFreeEvalPrependHomotopy` expecting a clean `⊕_{I₁} O_X(V)` iso will need to assemble it from three pieces not described in the blueprint.

**Severity: major** (fixable in-place without a rename; the decl is correct as a helper, but the `\lean{...}` hint is attached to a lemma claiming a stronger result).

---

### Excuse-comments

None. The Lean file is clean of excuse-comments or TODOs.

### Axioms / Classical.choice

None introduced.

---

## Unreferenced declarations (informational)

The following declarations are in the file but have **no `\lean{...}` reference** in the blueprint. Sorted by significance:

### Substantive — should be blueprinted

| Declaration | Location | Why substantive |
|---|---|---|
| `FreeCechEngine.combDifferential` | line ~452 | Constant-coefficient alternating Čech differential — complete copy of `CombinatorialCech.combDifferential` |
| `FreeCechEngine.combHomotopy` | line ~457 | Prepend-i_fix contracting homotopy — core of the quasi-iso proof |
| `FreeCechEngine.combHomotopy_zero` | line ~460 | Simp lemma for homotopy at zero |
| `FreeCechEngine.cons_comp_succAbove_succ` | line ~466 | Index bookkeeping behind homotopy computation |
| `FreeCechEngine.combHomotopy_spec` | line ~477 | **`dh + hd = id`** — the contracting homotopy identity; the analytic heart of the nonempty case |
| `FreeCechEngine.combDifferential_eq_of_cocycle` | line ~492 | Every cocycle is a coboundary |
| `FreeCechEngine.combSign_flip` | line ~499 | Sign-reversal behind `d²=0` |
| `FreeCechEngine.combDifferential_comp` | line ~516 | `d²=0` |
| `FreeCechEngine.combDifferential_exact` | line ~543 | Positive-degree exactness (`Function.Exact` form) |
| `freeYonedaEval_isZero_of_not_le` | line ~594 | Evaluating `freeYoneda W` at `V≰W` gives zero — kills non-I₁ summands |
| `freeYonedaEval_iso_of_le` | line ~612 | Evaluating `freeYoneda W` at `V≤W` gives `O_X(V)` — the O_X(V) identification |
| `cechFreeEval_isZero_of_isEmpty` | line ~638 | Degreewise vanishing at V in empty case (object level) |
| `coverStructurePresheaf_eval_isZero_of_isEmpty` | line ~656 | `O_𝒰(V) = 0` in empty case |
| `isZero_homology_of_isZero_X` | line ~673 | Generic helper: homology of a zero object vanishes |

### Acceptable helpers (no blueprint reference needed)

| Declaration | Reason acceptable as local helper |
|---|---|
| `isZero_sigma_of_forall_isZero` | Generic colimit-of-zeros lemma; could be in Mathlib |

**Coverage summary**: 39 declarations in file; 24 have `\lean{...}` blueprint references (62%). 15 are unreferenced. Of the unreferenced, 14 are substantive and should be blueprinted.

---

## Blueprint adequacy for this file

### Coverage
24/39 declarations have a `\lean{...}` reference. Unreferenced substantive decls: 14 (listed above). Most critical gap: the entire `FreeCechEngine` namespace (9 decls) with no blueprint coverage at all.

### Proof-sketch depth: **under-specified / wrong for remaining nonempty-case build**

Detailed breakdown:

**`lem:cech_free_eval_prepend_homotopy`** — *under-specified*

The blueprint says to define `cechFreeEvalPrependHomotopy` as a `HomologicalComplex.Homotopy` via `Sigma.desc` of per-summand prepend maps, "under the identification of `lem:cech_free_eval_sectionwise`". But `cechFreeEval_X` only gives `eval(K_p) ≅ ∐_σ eval(freeYoneda(Uσ))`. To define the homotopy, the prover needs:
1. Apply `cechFreeEval_X` (eval commutes with coproduct)
2. Use `freeYonedaEval_isZero_of_not_le` / `freeYonedaEval_iso_of_le` to reduce to the I₁-filtered O_X(V)-coproduct
3. Build the Sigma.desc on that reduced coproduct
4. Transport back through the chain of isos to get `HomologicalComplex.Homotopy` hom-maps

The blueprint doesn't describe steps 2–4 or the transport chain. This is a significant gap: building the `HomologicalComplex.Homotopy` on the abstract `eval(K_p)` objects while connecting to `FreeCechEngine.combHomotopy` requires explicit transport through `cechFreeEval_X` + `freeYonedaEval_iso_of_le`, which is not described.

**`lem:cech_free_eval_prepend_homotopy_spec`** — *wrong* (references inaccessible declarations)

The blueprint proof sketch says (line 1541–1555):
> "This is the same alternating-sum cancellation as `CombinatorialCech.combHomotopy_spec`… the index bookkeeping is the `cons_comp_succAbove_succ` / `combSign_flip` content already discharged for the affine port."

`CombinatorialCech.combHomotopy_spec`, `CombinatorialCech.cons_comp_succAbove_succ`, and `CombinatorialCech.combSign_flip` are **all `private`** in `CechAcyclic.lean` and inaccessible from `FreePresheafComplex.lean`. This is precisely why the prover created the `FreeCechEngine` namespace — a complete parallel copy. The blueprint directs the prover to use names that do not exist in the accessible namespace.

**`lem:cech_free_eval_nonempty`** — *adequate* (conditional)

If the homotopy and spec are in place, the assembly into `HomologicalComplex.Homotopy` and then `QuasiIso` via `HomotopyEquiv.toQuasiIso` / `Homotopy.toQuasiIso` is adequately sketched.

**`lem:cech_free_complex_quasi_iso`** — *adequate as high-level outline*

The proof sketch (quasiIso_of_evaluation + case split + empty/nonempty lemmas) is now adequately described. However, it inherits the adequacy failures of `lem:cech_free_eval_sectionwise` (partial identification) and `lem:cech_free_eval_prepend_homotopy_spec` (private references).

### Hint precision: **loose / wrong**

- `\lean{cechFreeEval_X}` under `lem:cech_free_eval_sectionwise`: the hint names a real declaration but one whose type does not fully capture the lemma's claim (partial coverage, not the I₁-filtered O_X(V) form).
- All `lem:cech_free_eval_prepend_homotopy_spec` proof-sketch names (`CombinatorialCech.combHomotopy_spec` etc.) are **wrong** — those are private declarations inaccessible from this file.
- `FreeCechEngine.*` decls exist in the file but are not referenced anywhere in the blueprint.

### Generality: **matches need**

The existing declarations are at the right level of generality for downstream use.

### Recommended chapter-side actions (for blueprint-writing subagent)

1. **[Must-fix]** Add a `FreeCechEngine` section (or sub-lemma block) in the blueprint, with `\lean{AlgebraicGeometry.FreeCechEngine.combDifferential}`, `\lean{AlgebraicGeometry.FreeCechEngine.combHomotopy}`, `\lean{AlgebraicGeometry.FreeCechEngine.combHomotopy_spec}`, `\lean{AlgebraicGeometry.FreeCechEngine.combDifferential_exact}` etc. The blueprint currently says "use `CombinatorialCech.*`" but those are private; the actual Lean target namespace is `FreeCechEngine.*`.

2. **[Must-fix]** Correct the proof sketch of `lem:cech_free_eval_prepend_homotopy_spec` to reference `AlgebraicGeometry.FreeCechEngine.combHomotopy_spec` (and `FreeCechEngine.cons_comp_succAbove_succ`, `FreeCechEngine.combSign_flip`) instead of the private `CombinatorialCech.*` names.

3. **[Major]** Add `\lean{...}` references for `freeYonedaEval_isZero_of_not_le` and `freeYonedaEval_iso_of_le` under `lem:cech_free_eval_sectionwise` (or a new sub-lemma), explaining the three-step I₁-identification: eval-commutes-with-coproduct (`cechFreeEval_X`) → summand-zero (`freeYonedaEval_isZero_of_not_le`) → summand-iso (`freeYonedaEval_iso_of_le`). The current `\lean{cechFreeEval_X}` alone under `lem:cech_free_eval_sectionwise` is insufficient.

4. **[Major]** Expand the proof sketch of `lem:cech_free_eval_prepend_homotopy` to describe the transport chain from the abstract `eval(K_p)` objects through the `cechFreeEval_X` iso and the per-summand `freeYonedaEval_iso_of_le` isos to the concrete `FreeCechEngine.combHomotopy`-based maps. The prover needs to know how to transport the `HomologicalComplex.Homotopy` hom-maps through these compound isos.

5. **[Minor]** Add `\lean{AlgebraicGeometry.cechFreeEval_isZero_of_isEmpty}` and `\lean{AlgebraicGeometry.coverStructurePresheaf_eval_isZero_of_isEmpty}` and `\lean{AlgebraicGeometry.isZero_homology_of_isZero_X}` as intermediate steps under `lem:cech_free_eval_empty` (or as named sub-claims) — these are the object-level inputs used in the empty-case proof.

6. **[Minor]** Add `\leanok` manually to `def:cech_free_presheaf_complex`, `def:cover_structure_presheaf`, and `lem:quasiIso_of_evaluation` statement blocks (or rely on sync_leanok to add them after this iter completes — the decls exist and are clean).

---

## Severity summary

### must-fix-this-iter

1. **Blueprint adequacy failure — proof sketch for `lem:cech_free_eval_prepend_homotopy_spec` references inaccessible declarations**: The blueprint says "use `CombinatorialCech.combHomotopy_spec`" (and `cons_comp_succAbove_succ`, `combSign_flip`) but these are `private` in `CechAcyclic.lean`. The actual Lean namespace is `FreeCechEngine.*`, which is entirely unblueprinted. A prover following the blueprint proof sketch will fail immediately.

2. **Blueprint adequacy failure — `FreeCechEngine` namespace entirely unblueprinted**: 9 substantive declarations covering the full constant-coefficient combinatorial homotopy engine exist in the Lean file with no corresponding `\lean{...}` references in the blueprint. The chapter does not acknowledge that this duplication was necessary (because `CombinatorialCech` is private), leaving the blueprint's declared build path (`CombinatorialCech.*`) pointing at inaccessible declarations.

### major

3. **Signature mismatch — `cechFreeEval_X` vs `lem:cech_free_eval_sectionwise`**: The `\lean{cechFreeEval_X}` hint under `lem:cech_free_eval_sectionwise` names a decl whose type is the coproduct-commutation iso `eval(K_p) ≅ ∐_σ eval(freeYoneda(Uσ))`, NOT the full I₁-indexed O_X(V) identification claimed by the lemma. The downstream build for `cechFreeEvalPrependHomotopy` depends on the full description but must currently assemble it from three unblueprinted helper lemmas.

4. **Blueprint under-specified for `lem:cech_free_eval_prepend_homotopy`**: No description of the transport chain from the abstract `eval(K_p)` objects (via `cechFreeEval_X` + `freeYonedaEval_iso_of_le`) to the concrete `FreeCechEngine.combHomotopy`-based `HomologicalComplex.Homotopy` data. The degreewise-iso-to-engine differential match is the hard step but is glossed over.

5. **6 substantive unblueprinted intermediates** (`freeYonedaEval_isZero_of_not_le`, `freeYonedaEval_iso_of_le`, `cechFreeEval_isZero_of_isEmpty`, `coverStructurePresheaf_eval_isZero_of_isEmpty`, `isZero_sigma_of_forall_isZero`, `isZero_homology_of_isZero_X`) — needed by both the empty-case build (already done) and the nonempty-case build (not yet done), but no `\lean{...}` references in the blueprint.

### minor

6. Missing `\leanok` on `def:cech_free_presheaf_complex`, `def:cover_structure_presheaf`, and `lem:quasiIso_of_evaluation` — sync_leanok timing; will resolve on next sync.

---

**Overall verdict**: The file is sorry-free and the completed declarations (empty case, combinatorial engine, augmentation infrastructure) follow the blueprint faithfully, but the blueprint has two must-fix adequacy failures blocking the nonempty-case build: it directs provers to private `CombinatorialCech.*` declarations that are inaccessible from this file (a correct `FreeCechEngine` parallel copy exists but is entirely unblueprinted), and the proof sketch for the prepend homotopy does not describe the transport chain between the abstract evaluation iso and the concrete engine maps. 22 declarations checked, 4 must-fix/major red flags (2 must-fix blueprint adequacy, 1 major signature mismatch, 1 major blueprint gap).
