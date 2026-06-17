# Lean ↔ Blueprint Check Report

## Slug
freepresheafcomplex

## Iteration
016

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/FreePresheafComplex.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (focused on `def:cech_free_presheaf_complex` and `lem:cech_free_complex_quasi_iso`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.cechFreePresheafComplex}` (chapter: `def:cech_free_presheaf_complex`)

- **Lean target exists**: yes — `AlgebraicGeometry.cechFreePresheafComplex` at line 193
- **Signature matches**: partial — signature is `(𝒰 : X.OpenCover) [Finite 𝒰.I₀] : ChainComplex X.PresheafOfModules ℕ`; the blueprint definition says "Let X be a ringed space and U: U = ∪ Uᵢ an open covering" **without any finiteness hypothesis**. The `[Finite 𝒰.I₀]` instance is absent from the blueprint. (See also coproduct discussion under Red flags.)
- **Proof follows sketch**: yes — the blueprint's recommended simplicial route (build a `SimplicialObject`, apply `alternatingFaceMapComplex`) is exactly what the Lean does via `cechFreeSimplicial`.
- **notes**: Axiom check: only `propext`, `Classical.choice`, `Quot.sound` — 0 sorries. Degree-p term confirmed as `∐ fun σ : Fin(p+1) → 𝒰.I₀ => freeYoneda.obj (coverInterOpen 𝒰 σ)`, which mathematically equals the blueprint's `⨁_{(i₀,…,iₚ)} free(y U_{i₀…iₚ})` given the finiteness hypothesis.

### `\lean{AlgebraicGeometry.cechFreeComplex_quasiIso}` (chapter: `lem:cech_free_complex_quasi_iso`)

- **Lean target exists**: no — declaration is absent from the file. Pre-acknowledged in directive.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: Blocked on the augmentation object `O_𝒰` (the image presheaf `⊕ (jᵢ)₊ O_X|_{Uᵢ} → O_X`) which does not yet exist as a Lean object in the project. The blueprint's proof sketch (sectionwise contracting homotopy via I₁/I₂ index split, fix i_fix ∈ I₁, prescription h(s)_{i₀…i_{p+1}} = s_{i₁…i_{p+1}} if i₀ = i_fix else 0, verification dh+hd = id) is detailed and adequate to guide future formalization once `O_𝒰` exists.

---

## Red flags

### Coproduct (`∐`) vs biproduct (`⨁`) — assessment

The blueprint writes `K(U)_p = ⨁_{(i₀,…,iₚ) ∈ I^{p+1}} free(y U_{i₀…iₚ})` using `⊕`/`\bigoplus` notation. The Lean uses `∐` (categorical coproduct, `Limits.Sigma`). **Mathematical conclusion: no discrepancy.** In the abelian presheaf category `PMod(O_X)`, the `\bigoplus` notation denotes the categorical direct sum, which *is* the categorical coproduct — not specifically the finite biproduct. Using `∐` is therefore the correct Lean rendering; for finite index types the two coincide anyway (abelian category). The notation divergence is cosmetic.

### Finiteness restriction absent from blueprint — `[Finite 𝒰.I₀]`

The declarations `cechFreeSimplicial` and `cechFreePresheafComplex` both carry `[Finite 𝒰.I₀]`. The blueprint's `def:cech_free_presheaf_complex` block states the definition for a general open covering with **no finiteness hypothesis**. The Lean docstring justifies the restriction: `X.PresheafOfModules` requires `HasCoproductsOfShape (Fin(p+1) → 𝒰.I₀)`, which holds when `𝒰.I₀` is finite, and this matches the downstream protected theorem `cech_computes_higherDirectImage`. This is a legitimate engineering constraint, but it **narrows the blueprint's stated generality** and must be reflected in the blueprint definition.

*(No placeholder bodies, no excuse-comments, no non-standard axioms found.)*

---

## Unreferenced declarations (informational)

All public declarations in the Lean file and their blueprint status:

| Declaration | Blueprint `\lean{...}` | Assessment |
|---|---|---|
| `AlgebraicGeometry.freeYoneda` (line 111) | **missing** | Substantive building block (composite `yoneda ⋙ free`, described in blueprint prose but not given its own hint) — should be promoted |
| `AlgebraicGeometry.coverOpen` (line 115) | missing | Thin helper (`(𝒰.f i).opensRange`) — acceptable unlisted |
| `AlgebraicGeometry.coverInterOpen` (line 121) | **missing** | Substantive: the key `⨅ k, U(σ k)` intersection open; blueprint prose describes this as the indexing object but gives no `\lean{...}` hint |
| `AlgebraicGeometry.coverInterOpen_comp_le` (line 127) | missing | Helper lemma for index-dropping inclusion — acceptable unlisted |
| `AlgebraicGeometry.cechFreeSimplicial` (line 151) | **missing** | Backbone declaration: the entire simplicial object whose `alternatingFaceMapComplex` yields the deliverable; blueprint prose mentions the simplicial route in passing but provides no `\lean{...}` hint or standalone definition block |
| `AlgebraicGeometry.cechFreePresheafComplex_X` (line 201) | missing | Degreewise unfolding lemma (`rfl`); utility for downstream rewrites — acceptable unlisted, but useful to mention in blueprint as an available API lemma |

---

## Blueprint adequacy for this file

- **Coverage**: 1/2 blueprint `\lean{...}` targets have Lean counterparts (the definition; the quasi-iso is pre-acknowledged absent). Among the 6 public Lean declarations, **3 substantive ones** (`freeYoneda`, `coverInterOpen`, `cechFreeSimplicial`) have no corresponding blueprint block, meaning a prover working only from the blueprint would have to invent these names and types without guidance.

- **Proof-sketch depth**: **adequate** for both formalizable blocks.
  - `def:cech_free_presheaf_complex`: the recommended simplicial route (dead-end note on hand-rolling d²=0, instruction to use `alternatingFaceMapComplex`) is precise enough that the Lean followed it exactly.
  - `lem:cech_free_complex_quasi_iso`: the contracting homotopy prescription (`h(s)_{i₀…i_{p+1}} = s_{i₁…i_{p+1}}` if `i₀ = i_fix`, else `0`, verification `dh+hd=id`) is fully worked out and adequate to guide Lean once `O_𝒰` exists.

- **Hint precision**: **loose** for the delivered declaration. The `\lean{AlgebraicGeometry.cechFreePresheafComplex}` hint is present and correct, but:
  - No hint for `freeYoneda` (used as the atomic building block throughout).
  - No hint for `coverInterOpen` (the intersection object named throughout the construction).
  - No hint for `cechFreeSimplicial` (the intermediate simplicial object the entire proof pivots on).
  - No finiteness hypothesis `[Finite 𝒰.I₀]` stated in the definition block.

- **Generality**: **too narrow** as stated. The blueprint claims the definition applies to a general open covering; the Lean restricts to finite covers (justified by downstream needs, but not indicated in the blueprint).

- **Recommended chapter-side actions** (for a blueprint-writing subagent):
  1. **Add `[Finite I]` (finiteness of the index set) to the hypothesis of `def:cech_free_presheaf_complex`.** State that this matches the finiteness hypothesis of the ambient formalization target and is needed for `PresheafOfModules` to have the required coproducts.
  2. **Add a standalone definition block** for `freeYoneda` (the composite `yoneda ⋙ free`, the "extension-by-zero free presheaf" building block) with `\lean{AlgebraicGeometry.freeYoneda}`.
  3. **Add a `\lean{AlgebraicGeometry.coverInterOpen}` hint** in the body of `def:cech_free_presheaf_complex` (or a sub-definition) for the intersection open `⨅ k, U(σ k)`.
  4. **Add a definition block for `cechFreeSimplicial`** (`\lean{AlgebraicGeometry.cechFreeSimplicial}`) — the simplicial backbone whose `alternatingFaceMapComplex` yields the deliverable. This is the proof-engineering crux; naming it in the blueprint would let a future prover find it in the file without searching.
  5. **Clarify notation**: note that `⨁` in `def:cech_free_presheaf_complex` is the categorical coproduct (`∐`) in `PMod(O_X)`, not specifically a finite biproduct; the Lean uses `Limits.Sigma` (`∐`) which is correct.

---

## Severity summary

| Finding | Severity |
|---|---|
| `[Finite 𝒰.I₀]` absent from `def:cech_free_presheaf_complex` blueprint | **major** |
| No `\lean{...}` blueprint hints for `freeYoneda`, `coverInterOpen`, `cechFreeSimplicial` | **major** |
| `cechFreeComplex_quasiIso` absent from Lean (blocked on `O_𝒰`) | informational (pre-acknowledged) |
| Coproduct (`∐`) vs biproduct (`⨁`) notation drift | **minor** |

**Overall verdict**: The Lean file faithfully and axiom-cleanly (0 sorries) implements `def:cech_free_presheaf_complex` via the correct simplicial route; the two major findings are both blueprint-side adequacy gaps — the finiteness hypothesis `[Finite 𝒰.I₀]` is missing from the definition block and three substantive helper declarations lack `\lean{...}` hints — neither blocks the current Lean code but both reduce the blueprint's reproducibility score and should be addressed in the next blueprint-writing pass.
