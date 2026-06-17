# Lean ↔ Blueprint Check Report

## Slug
presheafcech

## Iteration
016

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/PresheafCech.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (focused on `def:section_cech_complex`, `lem:cech_complex_hom_identification`,
  `lem:injective_cech_acyclic`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.sectionCechComplex}` (chapter: `def:section_cech_complex`)
- **Lean target exists**: yes — `sectionCechComplex` at line 333
- **Signature matches**: **partial** — see detailed analysis below
- **Proof follows sketch**: N/A (definition, not a proof)
- **notes**:
  - The Lean type is `CochainComplex Ab.{u} ℕ`; the blueprint prose says "cochain complex of
    **$\mathcal{O}_X(U)$-modules**". This is the key discrepancy flagged by the directive.
  - Blueprint `\leanok` is present on the statement block, consistent with the definition being
    complete (0 sorry).
  - The Lean input signature is `{ι : Type u} (U : ι → Opens X) (F : X.PresheafOfModules)`.
    The blueprint says the input is a "ringed space X and an open covering 𝒰 : U = ⋃ U_i" with a
    base open U; the Lean drops the covering condition and the base open U, taking any family of
    opens. This is a minor, mathematically benign generalisation: the covering condition is not
    needed to define the complex, only for the vanishing result.
  - The blueprint's embedded Stacks source quote says "This is an **abelian group**" for each
    term, which IS consistent with the Lean's `Ab`-valued choice. The interpretive prose ("cochain
    complex of O_X(U)-modules") diverges from both the Lean and the Stacks source.

### `\lean{AlgebraicGeometry.freeYonedaHomEquiv}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: yes — `freeYonedaHomEquiv` at line 244
- **Signature matches**: yes — blueprint states
  `Hom_{PMod}(free(yoneda V), F) ≃ F(V)`;
  Lean type is
  `((PresheafOfModules.free …).obj (yoneda.obj V) ⟶ F) ≃ (F.presheaf ⋙ forget Ab).obj (op V)`,
  i.e. a `Equiv` (set bijection). The target `(F.presheaf ⋙ forget Ab).obj (op V)` is the
  underlying set of the abelian group F(V), consistent with the blueprint's description of the
  two-step composition: free–forgetful adjunction (`freeHomEquiv`) then Yoneda (`yonedaEquiv`).
- **Proof follows sketch**: yes — body is `PresheafOfModules.freeHomEquiv.trans yonedaEquiv`,
  exactly the blueprint's two-step composition.
- **notes**:
  - Blueprint says this is the "per-multi-index core" of the hom-identification, which the Lean
    docstring also states explicitly.
  - No `\leanok` on `lem:cech_complex_hom_identification` (correct — the main lemma
    `cechComplex_hom_identification` is not yet formalized).

### `\lean{AlgebraicGeometry.cechComplex_hom_identification}` (chapter: `lem:cech_complex_hom_identification`)
- **Lean target exists**: no — declaration absent from the Lean file
- **Signature matches**: N/A (not formalized)
- **Proof follows sketch**: N/A
- **notes**:
  - Correctly unformalized per the known cross-file blocker: `cechFreePresheafComplex` lives in
    `FreePresheafComplex.lean` and is not yet importable here.
  - Blueprint proof sketch is well-structured (degree-by-degree via free–forgetful + Yoneda, then
    differential intertwining check). Adequate for eventual formalization.
  - One reconciliation needed before formalizing: if `sectionCechComplex` stays `Ab`-valued, the
    blueprint's "isomorphism of cochain complexes of O_X(U)-modules" must be weakened to
    "isomorphism of cochain complexes of abelian groups" in both the statement and proof. The
    helper `freeYonedaHomAddEquiv` (AddEquiv, not LinearEquiv) already signals the Ab-level intent.

### `\lean{AlgebraicGeometry.injective_toPresheafOfModules}` (chapter: `lem:injective_cech_acyclic`)
- **Lean target exists**: yes — `injective_toPresheafOfModules` at line 215
- **Signature matches**: yes — blueprint Part 1 states: injective O_X-module ⟹ injective
  presheaf of modules, obtained via `sheafificationAdjunction` + `Injective.injective_of_adjoint`.
  Lean signature: `(I : X.Modules) [Injective I] : Injective ((Scheme.Modules.toPresheafOfModules X).obj I)`.
  Perfectly matches.
- **Proof follows sketch**: yes — proof uses exactly the two steps described:
  (1) `haveI : (PresheafOfModules.sheafification _).PreservesMonomorphisms := inferInstance` and
  (2) `Injective.injective_of_adjoint (PresheafOfModules.sheafificationAdjunction …) I`.
- **notes**:
  - Blueprint `lem:injective_cech_acyclic` lists this name under `\lean{...}` and has no `\leanok`
    (correct — the main `injective_cech_acyclic` is absent; `injective_toPresheafOfModules` is
    the Part-1 ingredient only).

### `\lean{AlgebraicGeometry.injective_cech_acyclic}` (chapter: `lem:injective_cech_acyclic`)
- **Lean target exists**: no — declaration absent from the Lean file
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**:
  - Correctly absent; depends on both `cechComplex_hom_identification` and
    `cechFreeComplex_quasiIso` (and hence on `cechFreePresheafComplex`), none of which are yet in
    this file.
  - Blueprint proof sketch for Part 2 (exactness via exact Hom applied to the resolution) is
    adequate once the cross-file dependencies land.

---

## Red flags

### Stale/wrong comment in the Lean file
- `PresheafCech.lean:46-50`: The planning comment block (lines 33–195) states:
  ```
  Č•(𝒰, F, U) : CochainComplex (ModuleCat (X.ringCatSheaf.val.obj (op U))) ℕ
  ```
  This contradicts the actual implementation at line 333 (`CochainComplex Ab.{u} ℕ`). The comment
  is stale documentation from the planning phase, not an excuse comment ("TODO: replace") but
  materially misleading: a reader of the file sees a planned type that was never implemented.
  **Minor red flag** (comment, not code).

No placeholders (`:= sorry`), no axioms, no classical-choice abuses found.

---

## Unreferenced declarations (informational)

| Declaration | Line | Status |
|---|---|---|
| `sectionCechCosimplicial` | 302 | Helper for `sectionCechComplex`; unnamed in blueprint. Acceptable intermediate. |
| `freeYonedaHomEquiv_apply` | 255 | Helper lemma giving the concrete generator formula for `freeYonedaHomEquiv`. Unnamed in blueprint; needed for the `map_add'` proof of `freeYonedaHomAddEquiv`. |
| `freeYonedaHomAddEquiv` | 273 | **Notable**: this is the additive (`AddEquiv`) upgrade of `freeYonedaHomEquiv` and will be the actual building block of `cechComplex_hom_identification` (the blueprint only references the Set-level `freeYonedaHomEquiv`). Its existence pins the intended Ab-level target for the hom-identification. Worth a `\lean{...}` mention under `lem:cech_complex_hom_identification`. Currently unreferenced. |

`freeYonedaHomAddEquiv` is the only unreferenced declaration whose name suggests blueprint coverage is warranted; the others are conventional helpers.

---

## Blueprint adequacy for this file

### Key question: Ab vs. O_X(U)-modules for `sectionCechComplex`

**Finding**: The blueprint's `def:section_cech_complex` prose says the section Čech complex is a
"cochain complex of $\mathcal{O}_X(U)$-modules", but the Lean implementation is
`CochainComplex Ab.{u} ℕ`. The two are **inconsistent**: `ModuleCat R ≠ Ab` as ambient
categories. The choice `Ab` is however:
- Consistent with the Stacks Project source quoted in the same blueprint block ("This is an
  **abelian group**").
- Consistent with the Ab-level helpers `freeYonedaHomAddEquiv` (AddEquiv, not LinearEquiv).
- Sufficient for the full Čech-acyclicity argument: the Hom-complex `Hom(K(𝒰)_•, I)` and the
  proof of exactness are intrinsically Ab-level operations.

**Consequence for `lem:cech_complex_hom_identification`**: The blueprint says the isomorphism is
"of cochain complexes of O_X(U)-modules". If `sectionCechComplex` is in Ab, the eventual Lean
target for `cechComplex_hom_identification` is a chain-complex isomorphism in Ab, not in ModuleCat.
The blueprint prose needs reconciliation before the prover can build that declaration.

### Coverage
- 3/5 Lean declarations with a `\lean{...}` reference in the chapter (`sectionCechComplex`,
  `freeYonedaHomEquiv`, `injective_toPresheafOfModules`). 2 remain: `cechComplex_hom_identification`
  and `injective_cech_acyclic` are correctly absent (cross-file blocked).
- 3 unreferenced helpers: 2 are routine (`sectionCechCosimplicial`, `freeYonedaHomEquiv_apply`);
  1 is substantive (`freeYonedaHomAddEquiv`).

### Proof-sketch depth
**Adequate** for the formalized declarations. The sketch for `injective_toPresheafOfModules`
(Part 1 of `lem:injective_cech_acyclic`) is precisely reproduced. The sketch for
`sectionCechComplex` is structural (alternating-coface-map complex of a cosimplicial object). The
unformalized `cechComplex_hom_identification` and `injective_cech_acyclic` have detailed proofs
in the blueprint; they are adequate for eventual formalization once cross-file dependencies land.

### Hint precision
**Loose in one place**: `lem:cech_complex_hom_identification` says "isomorphism of cochain
complexes of O_X(U)-modules" but the Lean's `freeYonedaHomAddEquiv` is an `AddEquiv` (Ab),
signalling the intended target is an Ab-complex isomorphism. The `\lean{...}` hint for
`cechComplex_hom_identification` does not specify which category (Ab vs. ModuleCat) the isomorphism
lives in, leaving an ambiguity that must be resolved before formalization.

### Generality
**Matches need** for formalized declarations. `sectionCechComplex` is slightly more general than
the blueprint (no covering condition required), which is a virtue.

### Recommended chapter-side actions
1. **Update `def:section_cech_complex` prose**: Change "cochain complex of
   $\mathcal{O}_X(U)$-modules" to "cochain complex of **abelian groups**". Add a remark that the
   underlying Ab-structure is what is used in the hom-identification and acyclicity arguments,
   consistent with the Stacks source quote in the block.
2. **Update `lem:cech_complex_hom_identification` statement and proof**: Change "isomorphism of
   cochain complexes of $\mathcal{O}_X(U)$-modules" to "isomorphism of cochain complexes of
   **abelian groups**" in both the statement paragraph and the proof. Update the proof to note
   that the per-multi-index bijection is promoted to an AddEquiv (via `freeYonedaHomAddEquiv`) and
   the complex isomorphism is in Ab.
3. **Add `\lean{AlgebraicGeometry.freeYonedaHomAddEquiv}` to `lem:cech_complex_hom_identification`**
   (alongside the existing `freeYonedaHomEquiv`), since it is the actual per-term building block
   for the complex isomorphism.
4. **Fix stale planner comment** in `PresheafCech.lean` lines 46–50: update
   `CochainComplex (ModuleCat (X.ringCatSheaf.val.obj (op U))) ℕ` to `CochainComplex Ab ℕ`
   to reflect what was actually built. (Review agent action — not Lean-code modification.)

---

## Severity summary

| Finding | Severity |
|---|---|
| Blueprint `def:section_cech_complex` prose says "O_X(U)-modules" but Lean is `CochainComplex Ab ℕ`; direct inconsistency will confuse the prover building `cechComplex_hom_identification` | **must-fix-this-iter** (blueprint reconciliation) |
| Blueprint `lem:cech_complex_hom_identification` says "complexes of O_X(U)-modules"; inconsistent with Ab-valued `sectionCechComplex`; must be reconciled before the lemma can be formalized | **must-fix-this-iter** (blueprint reconciliation) |
| `freeYonedaHomAddEquiv` (AddEquiv upgrade, key building block) not referenced by any `\lean{...}` in the chapter | **major** (missing reference; blueprint should document it) |
| Stale planning comment in `PresheafCech.lean:46-50` describing planned type `CochainComplex (ModuleCat ...)` that was never implemented | **minor** (stale comment, not executable code) |
| No base-open `U` parameter in `sectionCechComplex` vs. blueprint's U-parametrised statement | **minor** (Lean is strictly more general, no mathematical loss) |

**Overall verdict**: The formalized declarations (`sectionCechComplex`, `freeYonedaHomEquiv`,
`injective_toPresheafOfModules`) are axiom-clean and mathematically correct; the Lean file is in
good shape. Two must-fix blueprint reconciliations are required — both are prose/hint changes to
`def:section_cech_complex` and `lem:cech_complex_hom_identification` to replace "O_X(U)-modules"
with "abelian groups" — needed before `cechComplex_hom_identification` can be safely formalized.
5 declarations checked (3 formalized + 2 correctly pending), 2 blueprint red flags.
