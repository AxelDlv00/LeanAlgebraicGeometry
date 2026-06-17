# Lean ↔ Blueprint Check Report

## Slug
FreePresheafComplex

## Iteration
018

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`

---

## Per-declaration (blueprint `\lean{...}` blocks targeting FreePresheafComplex.lean)

### `\lean{...}` under `def:cech_free_presheaf_complex`

Targets (all in FreePresheafComplex.lean):
`AlgebraicGeometry.cechFreePresheafComplex`, `AlgebraicGeometry.freeYoneda`,
`AlgebraicGeometry.coverOpen`, `AlgebraicGeometry.coverInterOpen`,
`AlgebraicGeometry.coverInterOpen_comp_le`, `AlgebraicGeometry.cechFreeSimplicial`,
`AlgebraicGeometry.cechFreePresheafComplex_X`, `AlgebraicGeometry.sigma_ι_eqToHom_transport`

- **Lean targets exist**: yes for all 7 public declarations. `sigma_ι_eqToHom_transport` is declared `private` so its Lean 4 name is mangled and inaccessible externally.
- **Signatures match**: yes. `cechFreePresheafComplex` is `(alternatingFaceMapComplex _).obj (cechFreeSimplicial 𝒰)`, a `ChainComplex X.PresheafOfModules ℕ` with degree-`p` term `∐_{σ : Fin(p+1) → 𝒰.I₀} freeYoneda.obj (coverInterOpen 𝒰 σ)` — exactly what the blueprint specifies.  `freeYoneda := yoneda ⋙ PresheafOfModules.free X.ringCatSheaf.obj` matches the `free ∘ yoneda` building block of the blueprint. `coverOpen`, `coverInterOpen`, `coverInterOpen_comp_le` match their described roles. `cechFreeSimplicial` is the simplicial backbone with `map_id` and `map_comp` proved.
- **Proof follows sketch**: yes. The Lean follows the blueprint's recommended simplicial route — build `cechFreeSimplicial`, apply `alternatingFaceMapComplex`; `d²=0` comes free from simplicial identities. No hand-rolled alternating-sum identity.
- **Axioms (lean_verify)**: `propext`, `Classical.choice`, `Quot.sound` only — no sorry, no custom axioms.
- **Compilation**: zero errors or warnings.
- **`\leanok` present**: no — but all named declarations are built and sorry-free. This is a `sync_leanok` phase discrepancy (informational; the sync will add `\leanok`).
- **Notes**:
  - `sigma_ι_eqToHom_transport` is a `private lemma` — its full Lean 4 name is mangled (inaccessible by the listed name externally). Including it in the `\lean{...}` list is a minor blueprint adequacy issue (see below).

---

### `\lean{AlgebraicGeometry.coverStructurePresheaf}` (chapter: `def:cover_structure_presheaf`)

- **Lean target exists**: yes.
- **Signature matches**: yes. Defined as `Limits.image (cechFreeAug 𝒰)`, the image presheaf of the degree-0 augmentation `K(𝒰)_0 → O_X`. Matches blueprint: "the image presheaf of the augmentation `⊕_i free(y U_i) → 1`."
- **Proof follows sketch**: N/A (this is a `def`, no proof body in the blueprint).
- **Axioms**: `propext`, `Classical.choice`, `Quot.sound` only.
- **`\leanok` present**: yes. ✓

---

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (chapter: `lem:cech_free_complex_quasi_iso`)

- **Lean target exists**: **no**. Declaration `cechFreeComplex_quasiIso` is absent from `FreePresheafComplex.lean`.
- **Closest built sub-infrastructure**: `cechFreeComplexAug` (the augmentation chain map `cechFreePresheafComplex 𝒰 ⟶ (ChainComplex.single₀ _).obj (coverStructurePresheaf 𝒰)`) together with `cechFreeComplexAug_f_zero`, `cechFreeAug`, and the private chain-map-condition lemmas. These are necessary prerequisites for the quasi-iso but the quasi-iso claim itself is not formalized.
- **Signature matches**: N/A (target absent).
- **Proof follows sketch**: N/A.
- **`\leanok` present**: no — consistent with the target being absent.
- **Notes**: This is the known gap flagged in the directive. The prover decomposed the target and built the augmentation infrastructure as the landing point for this iteration.

---

## Red flags

*(No must-fix-this-iter red flags found.)*

### Placeholder / suspect bodies
None. Every declaration in the file has a concrete body with no `sorry`.

### Excuse-comments
None. No `-- TODO`, `-- temporary`, `-- placeholder`, or `-- wrong but works for now` comments appear anywhere in the file.

### Axioms / Classical.choice on non-trivial claims
None. All verified declarations use only `propext`, `Classical.choice`, `Quot.sound` — the standard Lean/Mathlib baseline. No project-introduced `axiom` declarations.

---

## Unreferenced declarations (informational)

The following non-private, non-trivial declarations in `FreePresheafComplex.lean` have no `\lean{...}` reference in the blueprint chapter. Private helpers (`sigma_ι_eqToHom_transport`, `freeYonedaAug_app_freeMk`, `cechFreeSimplicial_δ_comp_aug`, `cechFree_d_comp_aug`, `cechFree_d_comp_factorThruImage`) are acceptable as implementation helpers.

| Declaration | Kind | Substantive? | Comment |
|---|---|---|---|
| `AlgebraicGeometry.freeYonedaAug` | `noncomputable def` | yes | Per-summand augmentation `freeYoneda V → O_X`; the component that assembles `cechFreeAug`. Blueprint prose describes this construction only implicitly (via the Stacks proof sketch). |
| `AlgebraicGeometry.freeYonedaHomEquiv_freeYonedaAug` | `lemma` | minor helper | Computes `freeYonedaHomEquiv` at the augmentation; used to prove naturality. Acceptable helper. |
| `AlgebraicGeometry.freeYoneda_map_comp_aug` | `lemma` | yes | Naturality of the augmentation: the cochain-map condition. Substantive lemma with a nontrivial proof. |
| `AlgebraicGeometry.cechFreeAug` | `noncomputable def` | yes | Degree-0 augmentation `K(𝒰)_0 → O_X`; assembled from `freeYonedaAug`. Central intermediate. |
| `AlgebraicGeometry.cechFreeComplexAug` | `noncomputable def` | **yes — main new sub-target** | The augmentation chain map `cechFreePresheafComplex 𝒰 ⟶ O_𝒰[0]`. This is the primary infrastructure built this iteration instead of `cechFreeComplex_quasiIso`. Its docstring references `def:cover_structure_presheaf`, but that blueprint block only covers `coverStructurePresheaf` (the image presheaf) — **inaccurate doc cross-reference** (minor). Lacks a dedicated `\lean{...}` entry. |
| `AlgebraicGeometry.cechFreeComplexAug_f_zero` | `lemma` | minor helper | Records degree-0 component of `cechFreeComplexAug`; acceptable helper. |

---

## Blueprint adequacy for this file

- **Coverage**: 9/15 public declarations have a corresponding `\lean{...}` block. The 6 unreferenced declarations are the augmentation infrastructure (`freeYonedaAug`, `freeYoneda_map_comp_aug`, `cechFreeAug`, `cechFreeComplexAug`, `cechFreeComplexAug_f_zero`, `freeYonedaHomEquiv_freeYonedaAug`). The most substantive of these — `cechFreeComplexAug` — is the iteration's primary landing point and should be referenced.

- **Proof-sketch depth**: **adequate** for the free complex backbone (`cechFreePresheafComplex` / `cechFreeSimplicial` — the simplicial route is specified clearly). **Silent** on the augmentation chain-map construction: the blueprint's proof sketch for `lem:cech_free_complex_quasi_iso` describes the contracting homotopy argument for the quasi-iso, but does not sketch the chain-map construction itself (`cechFreeComplexAug`). A prover building the prerequisite infrastructure had to infer that structure independently.

- **Hint precision**: **loose on one point** — `AlgebraicGeometry.sigma_ι_eqToHom_transport` appears in the `\lean{...}` list of `def:cech_free_presheaf_complex`, but it is declared `private` in the Lean file. Its Lean 4 name is mangled and cannot be looked up externally by this name. The `sync_leanok` and `lean_verify` tools will not find it. This should be removed from the `\lean{...}` list or the declaration should be made non-private.

- **Generality**: matches need. The Lean and blueprint agree on `[Finite 𝒰.I₀]` as the finiteness hypothesis.

- **Recommended chapter-side actions**:
  1. **(Major)** Add a `\lean{...}` entry for `AlgebraicGeometry.cechFreeComplexAug` (the augmentation chain map) — either as a sub-lemma of `lem:cech_free_complex_quasi_iso` or as a separate definition block. This declaration is the primary output of iteration 018 for this file.
  2. **(Major)** Add `\lean{...}` entries for `AlgebraicGeometry.freeYonedaAug`, `AlgebraicGeometry.cechFreeAug`, `AlgebraicGeometry.freeYoneda_map_comp_aug` — these are substantive building blocks whose absence leaves the augmentation argument untracked.
  3. **(Minor)** Remove `AlgebraicGeometry.sigma_ι_eqToHom_transport` from the `\lean{...}` list of `def:cech_free_presheaf_complex`, or promote the lemma from `private`. It cannot be referenced by that name externally.
  4. **(Informational)** Correct the docstring cross-reference on `cechFreeComplexAug`: its `(`def:cover_structure_presheaf`)` tag is inaccurate — that blueprint label covers only the image presheaf, not the chain map.

---

## Severity summary

| Finding | Severity |
|---|---|
| `cechFreeComplex_quasiIso` not built (known gap, directive-acknowledged) | Informational (pre-known) |
| `cechFreeComplexAug` and 2 other substantive declarations lack `\lean{...}` references | **major** |
| `sigma_ι_eqToHom_transport` listed in `\lean{...}` but is `private` | minor |
| Missing `\leanok` on `def:cech_free_presheaf_complex` | informational (sync_leanok pending) |
| Inaccurate doc cross-reference on `cechFreeComplexAug` docstring | minor |

**Overall verdict**: The Lean file is clean — no sorries, no errors, no unauthorized axioms, no excuse-comments, standard axioms only, and the free complex backbone fully matches the blueprint sketch. The sole gaps are blueprint-side: the augmentation infrastructure (`cechFreeComplexAug` and friends) built this iteration lacks `\lean{...}` references, and `cechFreeComplex_quasiIso` remains unbuilt (pre-known gap).
