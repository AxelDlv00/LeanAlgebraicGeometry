# Blueprint Review: capstone-iter077
**Iter:** 077

## Top-level summaries

- **Incomplete**: `Cohomology_CechHigherDirectImage.tex` — `lem:cech_computes_cohomology` proof missing sub-lemmas for seams (a)+(b); `lem:cech_term_pushforward_acyclic` missing `\uses{lem:pushPull_sigma_iso}` + product-acyclicity dep.
- **Correctness**: `Cohomology_CechHigherDirectImage.tex` — proof of `lem:cech_computes_cohomology` glosses two non-definitional Lean seams as "by construction"; seam (a) is NOT definitional, seam (b) requires explicit construction.
- **Missing covers**: `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` (planned P5b relocation target) absent from `% archon:covers` list.
- **Deps/DAG**: `unknown_uses: []`, `isolated: 0`, `broken_refs: []`. DAG is structurally clean.
- **Rendering**: blueprint-doctor clean — no `malformed_refs`, no `orphan_chapters`, no `axiom_decls`.

## Unstarted-phase proposals

NONE — all strategy phases are either Complete or Active (P5b).

## Per-chapter

### `Cohomology_HigherDirectImage.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: Single `def:higher_direct_image` with `\leanok`. Nothing to fix.

### `Cohomology_AcyclicResolution.tex`
- **Complete**: true
- **Correct**: true
- **Notes**: All P4 machinery (`rightDerivedIsoOfAcyclicResolution`, horseshoe, dimension-shift) is `\leanok` or `\mathlibok`. All `\uses` resolve. No gaps.

### `Cohomology_CechHigherDirectImage.tex`
- **Complete**: partial
- **Correct**: partial
- **Notes**: Details below (capstone focus findings).

---

## Capstone focus: `lem:cech_computes_cohomology` seam audit

### Seam (a) — functor-commutation iso `(f_*).mapHomologicalComplex (cechComplexOnX 𝒰 F) ≅ CechComplex f 𝒰 F`

**Finding: NOT definitional. Must-fix sub-lemma missing.**

Lean facts:
- `cechComplexOnX 𝒰 F = (alternatingCofaceMapComplex X.Modules).obj (Augmented.drop.obj (CechNerve 𝒰 F))` — alternating coface sum computed BEFORE any f_* is applied.
- `CechComplex f 𝒰 F = (alternatingCofaceMapComplex S.Modules).obj ((whiskering.obj (pushforward f)).obj (Augmented.drop.obj (CechNerve 𝒰 F)))` — alternating coface sum computed AFTER whiskering with f_*.
- `(f_*).mapHomologicalComplex (cechComplexOnX)` applies `(pushforward f).map` to each differential of `cechComplexOnX`; in particular it maps `d = ∑_j (-1)^j coface_j` through `(pushforward f).map`.

The differential of `CechComplex f` is `∑_j (-1)^j (pushforward f).map(coface_j)`.
The differential of `(f_*).mapHomologicalComplex (cechComplexOnX)` is `(pushforward f).map(∑_j (-1)^j coface_j)`.

These are equal by additivity (`map_sum`) but NOT definitionally equal in Lean 4. The blueprint proof at L11796 writes "by construction (Definition~\ref{def:cech_complex}) the complex `f_* C•` is precisely the relative Čech complex" — this is mathematically fine but Lean-incorrect (the equation requires a proof step using `Functor.map_sum` / additive functor distributivity).

**Required sub-lemma** (before final assembly prover dispatch):
```
\begin{lemma}[Pushforward commutes with alternating coface complex]
  \label{lem:pushforward_mapHC_cechComplexOnX}
  \lean{AlgebraicGeometry.pushforward_mapHomologicalComplex_cechComplexOnX} [expected]
  \uses{def:cech_complex_on_X, def:cech_complex}
  For f : X → S, 𝒰 a cover, F quasi-coherent, there is a canonical iso of cochain
  complexes in S.Modules:
  (pushforward f).mapHomologicalComplex (cechComplexOnX 𝒰 F) ≅ CechComplex f 𝒰 F.
  (This is naturality of alternatingCofaceMapComplex with respect to additive functors.)
\end{lemma}
```
In practice this is a natural iso `mapHomologicalComplex F ∘ alternatingCofaceMapComplex A ≅ alternatingCofaceMapComplex B ∘ (whiskering A B).obj F` for any additive functor F; it follows from `F.map_sum`. May exist in Mathlib as `AlgebraicTopology.alternatingCofaceMapComplex` functoriality — check before writing project code.

### Seam (b) — extraction of `(e : F ≅ K.cycles 0, hexact)` from `cechAugmented_exact`

**Finding: Non-trivial Lean conversion. Must-fix sub-lemma missing.**

P4 (`rightDerivedIsoOfAcyclicResolution`) takes input:
```
K : CochainComplex 𝒜 ℕ, A : 𝒜, e : A ≅ K.cycles 0, hexact : ∀ n, K.ExactAt (n+1)
```
And yields `G.obj A ≅ ((G.mapHomologicalComplex _).obj K).homology n`.

`cechAugmented_exact` provides: `∀ p, IsZero ((cechAugmentedComplex 𝒰 F).homology p)` where `cechAugmentedComplex = (cechComplexOnX 𝒰 F).augment (cechAugmentation 𝒰 F) _`.

Converting to P4's input form K = `cechComplexOnX 𝒰 F`:
- For `hexact (n : ℕ) : K.ExactAt (n+1)`: needs `IsZero (K.homology (n+1))` = `cechAugmented_exact (n+2)` (shifting by 2: the augmented complex at p = n+2 is K at position n+1). This requires the shift lemma `(K.augment ε h).homology (n+2) ≅ K.homology (n+1)`.
- For `e : F ≅ K.cycles 0`: needs to combine:
  - `cechAugmented_exact 0`: `IsZero ((K.augment).homology 0)` → kernel of ε : F → K.X 0 is zero → ε is mono.
  - `cechAugmented_exact 1`: `IsZero ((K.augment).homology 1)` = `IsZero (K.cycles 0 / im(ε))` → ε surjects onto K.cycles 0.
  - Together: ε corestricts to an iso F ≅ K.cycles 0.

None of this is spelled out in the blueprint proof block. The proof at L11772-11785 simply writes "By Lemma~\ref{lem:cech_augmented_resolution} the augmented Čech complex is exact", skipping the entire conversion.

**Required sub-lemma** (before final assembly prover dispatch):
```
\begin{lemma}[Augmented-exact implies augmentation-dropped form]
  \label{lem:cechAugmented_to_acyclicResolutionInput}
  \lean{AlgebraicGeometry.cechAugmented_to_acyclicResolutionInput} [expected]
  \uses{lem:cech_augmented_resolution, def:cech_complex_on_X, def:cech_augmented_complex}
  From cechAugmented_exact (∀ p, IsZero (cechAugmentedComplex.homology p)), extract:
    e : F ≅ (cechComplexOnX 𝒰 F).cycles 0
    hexact : ∀ n, (cechComplexOnX 𝒰 F).ExactAt (n+1)
\end{lemma}
```
Proof outline: use the augmented-complex shift to get ExactAt from homology vanishing at positions ≥ 2; use positions 0 and 1 to build the augmentation iso.

### Seam (c) — term structure `(cechComplexOnX 𝒰 F).X p ≅ ∏_s (j_s)_*(F|_{U_s})`

**Finding: NOT definitional (uses `lem:pushPull_sigma_iso`), but already blueprinted. Used implicitly by `lem:cech_term_pushforward_acyclic`.**

`(cechComplexOnX 𝒰 F).X p = (Augmented.drop.obj (CechNerve 𝒰 F)).obj ⟦p⟧ = pushPullObj F (coverCechNerveObj 𝒰 p)` where `coverCechNerveObj 𝒰 p = ∐_σ U_σ`. The iso to `∏_σ (j_σ)_*(F|_{U_σ})` is `lem:pushPull_sigma_iso` (L8561). This is EXISTING infrastructure.

The `lem:cech_term_pushforward_acyclic` proof uses this implicitly ("it suffices to treat a single factor") without citing `lem:pushPull_sigma_iso`. This is a missing `\uses`. Since the iso exists and is proved, a prover can find it, but the dependency should be declared.

---

## `lem:cech_term_pushforward_acyclic` formalizability assessment

**Verdict: Mostly adequate for prover dispatch, with two must-fix \uses gaps.**

The proof (L11669–L11699) correctly identifies the argument chain:
1. Reduce to single term via product decomposition.
2. Use `lem:higher_direct_image_presheaf` for presheaf description of R^k f_*.
3. Use `lem:open_immersion_pushforward_comp`: R^k f_*(j_s)_*(H) ≅ R^k(g_s)_*(H).
4. Locally over affine V, g_s restricts to affine-to-affine → apply `lem:affine_serre_vanishing`.

**Missing \uses:**
- `lem:pushPull_sigma_iso` — needed for step 1 (term structure identification).
- No lemma for "finite product/biproduct of right-G-acyclic objects is right-G-acyclic" — needed for step 1. In Lean this follows from `(R^k G)(A ⊕ B) ≅ (R^k G)(A) ⊕ (R^k G)(B)` (derived functors commute with biproducts in abelian categories with enough injectives). Should be expressible via `Functor.rightDerived_biprod` or similar; blueprint should cite the Mathlib lemma or add a `\mathlibok` anchor for it.

**Hard-gate result for `lem:cech_term_pushforward_acyclic`:** Gates CLEARED for prover dispatch. The proof sketch is adequate; the two missing `\uses` are known infrastructure that a prover can locate. The plan agent should note these gaps and ask the prover to add them during formalization.

---

## Missing `% archon:covers` entry

The P5b strategy calls for moving `cech_computes_higherDirectImage` to a new file `AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean`. This file is NOT listed in the chapter's `% archon:covers` headers. When the refactor/relocation happens, the blueprint writer must add:
```
% archon:covers AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean
```
The `archon-protected.yaml` path key also needs updating from `CechHigherDirectImage.lean` to `CechToHigherDirectImage.lean`. Flag for the plan agent: the relocation hasn't happened yet (the sorry is currently in `CechHigherDirectImage.lean:773`); if the prover attempts the relocation this iter, they need writer+YAML update first.

---

## Severity summary

- **must-fix (blocks final assembly prover dispatch)**:
  - Add sub-lemma `lem:pushforward_mapHC_cechComplexOnX` (seam a).
  - Add sub-lemma `lem:cechAugmented_to_acyclicResolutionInput` (seam b).
  - Both must be in `lem:cech_computes_cohomology`'s `\uses` before that prover runs.
- **must-fix (before `lem:cech_term_pushforward_acyclic` prover closes)**:
  - Add `\uses{lem:pushPull_sigma_iso}` to `lem:cech_term_pushforward_acyclic`.
  - Add `\mathlibok` anchor or `\uses` for "biproduct preserves right-acyclicity".
- **soon (non-blocking for this iter)**:
  - Add `% archon:covers AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean` when relocation is executed.
