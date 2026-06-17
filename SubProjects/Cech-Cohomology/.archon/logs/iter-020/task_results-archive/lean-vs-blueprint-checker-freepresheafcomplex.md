# Lean ↔ Blueprint Check Report

## Slug
freepresheafcomplex

## Iteration
019

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (blocks with `\lean{...}` targets in FreePresheafComplex.lean only, per directive)

---

## Per-declaration

### `def:cech_free_presheaf_complex` (8 \lean{} targets)

#### `\lean{AlgebraicGeometry.freeYoneda}`
- **Lean target exists**: yes (line 111)
- **Signature matches**: yes — `TopologicalSpace.Opens ↥X ⥤ X.PresheafOfModules`, the composite `yoneda ⋙ PresheafOfModules.free X.ringCatSheaf.obj`.  Blueprint says `free ∘ yoneda`.
- **Proof follows sketch**: N/A (definition, no proof block in chapter)

#### `\lean{AlgebraicGeometry.coverOpen}`
- **Lean target exists**: yes (line 115)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) (i : 𝒰.I₀) : TopologicalSpace.Opens ↥X`, the open `(𝒰.f i).opensRange`.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.coverInterOpen}`
- **Lean target exists**: yes (line 121)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) {κ : Type} (σ : κ → 𝒰.I₀) : TopologicalSpace.Opens ↥X`, defined as `⨅ k, coverOpen 𝒰 (σ k)`.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.coverInterOpen_comp_le}`
- **Lean target exists**: yes (line 127)
- **Signature matches**: yes — `coverInterOpen 𝒰 σ ≤ coverInterOpen 𝒰 (σ ∘ α)`.  Blueprint says reindexing along `α` enlarges the intersection.
- **Proof follows sketch**: N/A (one-line proof by `le_iInf` / `iInf_le`)

#### `\lean{AlgebraicGeometry.sigma_ι_eqToHom_transport}`
- **Lean target exists**: yes (line 134), but declared `private`.
- **Signature matches**: yes — transports a coproduct injection along an equality of indices.
- **notes**: Private lemma listed in a public `\lean{...}` tag; unusual but not harmful. The blueprint lists it as a helper for the simplicial bookkeeping.

#### `\lean{AlgebraicGeometry.cechFreeSimplicial}`
- **Lean target exists**: yes (line 151)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] : SimplicialObject X.PresheafOfModules`, n-simplices = `∐_{σ : Fin(n+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)`.
- **Proof follows sketch**: yes — simplicial maps defined by reindexing + inclusion; `map_id`/`map_comp` proved.

#### `\lean{AlgebraicGeometry.cechFreePresheafComplex}`
- **Lean target exists**: yes (line 193)
- **Signature matches**: yes — `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] : ChainComplex X.PresheafOfModules ℕ`, defined as `alternatingFaceMapComplex.obj (cechFreeSimplicial 𝒰)`.  Blueprint says chain complex via the simplicial route.
- **Proof follows sketch**: yes

#### `\lean{AlgebraicGeometry.cechFreePresheafComplex_X}`
- **Lean target exists**: yes (line 201)
- **Signature matches**: yes — degreewise `rfl` unfolding.
- **Proof follows sketch**: N/A (definitional lemma, `rfl` body is legitimate)

---

### `def:cover_structure_presheaf` (11 \lean{} targets)

#### `\lean{AlgebraicGeometry.freeYonedaAug}`
- **Lean target exists**: yes (line 216)
- **Signature matches**: yes — `freeYoneda.obj V ⟶ PresheafOfModules.unit X.ringCatSheaf.obj`, defined via the free–Yoneda hom equiv applied to `1`.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.freeYonedaHomEquiv_freeYonedaAug}`
- **Lean target exists**: yes (line 222)
- **Signature matches**: yes — value of the hom-equiv on the augmentation is `1`.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.freeYonedaAug_app_freeMk}`
- **Lean target exists**: yes (line 229), `private`.
- **Signature matches**: yes — augmentation on `freeMk g` is `1`.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.freeYoneda_map_comp_aug}`
- **Lean target exists**: yes (line 252)
- **Signature matches**: yes — naturality of augmentation: `freeYoneda.map (homOfLE h) ≫ freeYonedaAug V' = freeYonedaAug V`.
- **Proof follows sketch**: yes

#### `\lean{AlgebraicGeometry.cechFreeAug}`
- **Lean target exists**: yes (line 262)
- **Signature matches**: yes — `(cechFreePresheafComplex 𝒰).X 0 ⟶ PresheafOfModules.unit X.ringCatSheaf.obj`, assembled via `Sigma.desc`.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.coverStructurePresheaf}`
- **Lean target exists**: yes (line 274)
- **Signature matches**: yes — `Limits.image (cechFreeAug 𝒰)`.  Blueprint says image presheaf of the augmentation.
- **Proof follows sketch**: N/A

#### `\lean{AlgebraicGeometry.cechFreeSimplicial_δ_comp_aug}`
- **Lean target exists**: yes (line 282), `private`.
- **Signature matches**: yes — both faces of `cechFreeSimplicial` after augmenting collapse to the same map.
- **Proof follows sketch**: yes

#### `\lean{AlgebraicGeometry.cechFree_d_comp_aug}`
- **Lean target exists**: yes (line 295), `private`.
- **Signature matches**: yes — `d 1 0 ≫ cechFreeAug = 0`.
- **Proof follows sketch**: yes

#### `\lean{AlgebraicGeometry.cechFree_d_comp_factorThruImage}`
- **Lean target exists**: yes (line 318), `private`.
- **Signature matches**: yes — `d 1 0 ≫ factorThruImage (cechFreeAug) = 0`.
- **Proof follows sketch**: yes

#### `\lean{AlgebraicGeometry.cechFreeComplexAug}`
- **Lean target exists**: yes (line 332)
- **Signature matches**: yes — `cechFreePresheafComplex 𝒰 ⟶ (ChainComplex.single₀ _).obj (coverStructurePresheaf 𝒰)`, the augmentation chain map.
- **Proof follows sketch**: yes

#### `\lean{AlgebraicGeometry.cechFreeComplexAug_f_zero}`
- **Lean target exists**: yes (line 340)
- **Signature matches**: yes — degree-0 component is `factorThruImage (cechFreeAug)`.
- **Proof follows sketch**: N/A

---

### `lem:cech_free_complex_quasi_iso` (1 \lean{} target)

#### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}`
- **Lean target exists**: **no** — declaration absent from the file; referenced only in the module header comment at line 21.
- **Signature matches**: N/A (not yet built)
- **Proof follows sketch**: N/A (not yet built)
- **notes**: Per directive, this is **legitimately-not-yet-built**, not a sorry/placeholder defect. The prover this iteration landed the objectwise-reduction step (`quasiIso_of_evaluation`) but the sectionwise contracting homotopy (steps 2–3 of the build) remains.

---

## Red flags

### Placeholder / suspect bodies
None. No `:= sorry`, `:= True`, or suspect `Classical.choice` patterns found anywhere in the file. All proof bodies use real tactics.

### Excuse-comments
None. The `/-!` planning comment block (lines 31–86) records build strategy and dead-end warnings — these are pre-proof notes, not comments excusing wrong or incomplete Lean code. They are acceptable workflow documentation.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations.

---

## Unreferenced declarations (informational)

| Declaration | Line | Visibility | Remark |
|---|---|---|---|
| `isIso_Fmap_homologyMap` | 358 | private | Helper for `quasiIso_of_evaluation`; no blueprint block needed. |
| `isIso_of_evaluation` | 383 | private | Helper for `quasiIso_of_evaluation`; no blueprint block needed. |
| `quasiIso_of_evaluation` | 406 | **public** | Key objectwise-reduction lemma; absent from any blueprint `\lean{}` block. Per directive: known coverage debt, not a new defect this iter. Requires a `\lean_aux{}` (or blueprint block) — see Blueprint adequacy below. |

---

## Blueprint adequacy for this file

### Coverage
19/20 existing declarations have a corresponding `\lean{...}` block in the chapter (private helpers are correctly grouped under the relevant `def:` / `lem:` blocks).  1 public declaration (`quasiIso_of_evaluation`) has no blueprint coverage — known debt per directive.

### Proof-sketch depth for `lem:cech_free_complex_quasi_iso`

**Overall rating: under-specified (must-fix)**

The mathematical argument in the proof sketch is correct and present:
- Sectionwise reduction: objectwise exactness, split I = I₁ ∪ I₂. ✓
- Explicit formula for the contracting homotopy h (prepend i_fix). ✓
- "Direct computation gives (dh + hd)(s) = s." ✓
- Note that this is the "same combinatorial content as the CombinatorialCech.* port." ✓

**What is missing for the next prover to complete `cechFreeComplex_quasiIso` from blueprint prose alone:**

1. **No Lean API pathway for packaging the homotopy.**  The proof sketch says "defines a contracting homotopy" but does not name `HomologicalComplex.Homotopy` or `HomotopyEquiv.toQuasiIso`.  The file's own internal planning comment (lines 73–78) has this information, but those comments are not part of the blueprint and a prover reading only the blueprint would not see them.

2. **`quasiIso_of_evaluation` is absent from the `\lean{}` reference for this lemma.**  This is the formal bridge from the sectionwise homotopy argument to the quasi-iso conclusion.  The proof sketch mentions objectwise homology computation in passing (last paragraph, line ~1277–1283) but does not name the Lean declaration that implements it or indicate that the prover is expected to introduce it as an auxiliary.

3. **No guidance on evaluating `K(𝒰)_p(W)` in Lean.**  The sketch states "by the explicit description of the free presheaves, K(𝒰)_p(W) = ⊕_{i₀…i_p ∈ I₁} O_X(W)" but does not point to `cechFreePresheafComplex_X` (the degreewise-unfolding lemma already in the file) as the rewrite entry point, nor explain that the sectional evaluation factors through `PresheafOfModules.evaluation`.

4. **"Same combinatorial content as CombinatorialCech.\* port" not linked.**  The cross-reference to `lem:cech_acyclic_affine` is present but the specific lemma to port (the prepend homotopy in `CechAcyclic.lean`) is not named, leaving the prover to discover the connection without a hint.

**Concretely**: the prover who picks up the remaining build from the blueprint will have the mathematical formula but will need to independently discover that the strategy is: (a) use `quasiIso_of_evaluation` to reduce to each `V`, (b) construct the degree-wise homotopy morphisms as `Sigma.desc` maps over the I₁ index set, (c) package them as a `HomologicalComplex.Homotopy`, and (d) invoke `Homotopy.toQuasiIso` or `QuasiIso.ofHomotopyEquiv`. None of these Lean choices appear in the proof sketch.

### Hint precision
**Loose** for `lem:cech_free_complex_quasi_iso`: the `\lean{}` tag names only `cechFreeComplex_quasiIso` but omits `quasiIso_of_evaluation`, which the prover needs to name and build first.

For all other blocks: **precise** — each `\lean{}` tag correctly enumerates the Lean declarations.

### Generality
Matches need for all built declarations.

### Recommended chapter-side actions (for blueprint-writing subagent)

1. **Add a `\lean_aux{}` reference for `quasiIso_of_evaluation`** to the `lem:cech_free_complex_quasi_iso` block (or a short `\lean_aux` block) naming it as a bridge lemma the prover should build first.

2. **Expand the proof sketch** to include the Lean packaging pathway:
   - "Package the sectionwise homotopy as `HomologicalComplex.Homotopy`; then invoke `Homotopy.toQuasiIso` (or `QuasiIso.ofHomotopyEquiv`) to obtain `QuasiIso`."
   - "The objectwise reduction uses `quasiIso_of_evaluation` (already in FreePresheafComplex.lean): it suffices to show that for each `V`, the evaluation `(PresheafOfModules.evaluation R V).mapHomologicalComplex` applied to the augmentation is a quasi-isomorphism."

3. **Name the CombinatorialCech cross-reference explicitly**: replace the vague "same combinatorial content as the CombinatorialCech.\* port" with a direct pointer, e.g. "the same as `AlgebraicGeometry.cechLocalized_exact` / the prepend-homotopy construction in `CechAcyclic.lean`."

4. **Add a sentence on evaluating K(𝒰)_p(W)**: "Use `cechFreePresheafComplex_X` to unfold the degree-p term; sectional evaluation at V then yields the coproduct over tuples σ with V ⊆ coverInterOpen 𝒰 σ."

---

## Severity summary

| Finding | Severity |
|---|---|
| `cechFreeComplex_quasiIso` not yet in file | informational (legitimately-not-yet-built per directive) |
| `quasiIso_of_evaluation` has no blueprint block | informational this iter (known coverage debt per directive); should be major for planning purposes |
| Blueprint proof sketch for `lem:cech_free_complex_quasi_iso` under-specified for Lean packaging | **must-fix** |

**Overall verdict**: All existing declarations are correct and match the blueprint faithfully (no red flags, no sorries, no axioms). The sole must-fix is blueprint adequacy: the proof sketch for `lem:cech_free_complex_quasi_iso` omits the Lean API pathway (`HomologicalComplex.Homotopy`, `HomotopyEquiv.toQuasiIso`, `quasiIso_of_evaluation` as entry point) that a prover needs to complete the sectionwise contracting homotopy build. A blueprint-writer expansion of the proof sketch is required before the next prover attempt on `cechFreeComplex_quasiIso`.
