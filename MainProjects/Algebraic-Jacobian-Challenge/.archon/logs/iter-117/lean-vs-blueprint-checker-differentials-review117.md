# Lean ↔ Blueprint Check Report

## Slug
differentials-iter117

## Iteration
117

## Files audited
- Lean: `AlgebraicJacobian/Differentials.lean` (83 LOC)
- Blueprint: `blueprint/src/chapters/Differentials.tex` (116 LOC)

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf}` (chapter: `def:relative_kaehler_presheaf`)
- **Lean target exists**: yes (line 49)
- **Signature matches**: yes — `(f : X ⟶ S) : X.PresheafOfModules`, matches the prose "morphism of schemes ... produces a presheaf of `O_X`-modules on `X`".
- **Proof follows sketch**: yes — body is exactly `PresheafOfModules.DifferentialsConstruction.relativeDifferentials' φ'` where `φ'` is the adjunction-transpose of `f.c`. This is precisely the construction the blueprint describes ("inverse-image presheaf ... canonical adjunction-transpose ... apply `relativeDifferentials'`").
- **notes**: Construction is `noncomputable` (appropriate for sheaf-theoretic machinery; blueprint does not need to say this).

### `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_obj_kaehler}` (chapter: `lem:relative_kaehler_presheaf_obj`)
- **Lean target exists**: yes (line 58)
- **Signature matches**: partial — the Lean states `(carrier-type-of Ω.presheaf.obj V) = CommRingCat.KaehlerDifferential (...)`, i.e. an equality of `Type _`. The blueprint claims `Ω_{X/S}(V) = Ω_{O_X(V)/(f^{-1}O_S)(V)}`, which a reader could reasonably interpret as an equality of modules (carrier + scalar action), not just of underlying types. In practice the two coincide by `rfl`, so no working-prover would be misled, but the Lean statement is strictly weaker than the most natural reading.
- **Proof follows sketch**: yes — body is `rfl`, matching the blueprint proof ("identification is by `rfl` after unfolding the definition").
- **notes**: The blueprint's "affine specialisation" sentence (identification of `(f⁻¹O_S)(V)` with `O_S(U)` along an affine chart `V = Spec B → U = Spec A`) has no Lean counterpart in this file. That is acceptable because the lemma is purely about the open-by-open definition, not about the affine reduction; the affine bridge surfaces in the smoothness theorem.

### `\lean{AlgebraicGeometry.Scheme.smooth_iff_locally_free_omega}` (chapter: `thm:smooth_iff_locally_free_omega`)
- **Lean target exists**: yes (line 74)
- **Signature matches**: yes — the Lean reads
  ```
  (f : X ⟶ S) (hfp : LocallyOfFinitePresentation f) (n : ℕ) :
    IsSmoothOfRelativeDimension n f ↔
      ∀ x, ∃ U, x ∈ U.1 ∧ IsAffineOpen U ∧
        Module.Free R M ∧ Module.rank R M = n
  ```
  where `R = X.ringCatSheaf.presheaf.obj (.op U)` and `M = (relativeDifferentialsPresheaf f).presheaf.obj (.op U)`. The blueprint statement is the matching presheaf form ("free `O_X(U)`-module of rank `n`"). The presheaf-form refactor flagged in "Known issues" is faithfully reflected on both sides.
- **Proof follows sketch**: N/A — body is `sorry` (acknowledged as intentional in the directive; the blueprint has a substantive proof sketch intended to guide an iter-118 prover lane).
- **notes**: see Red flags below for two issues with the cited Mathlib lemma names in the blueprint proof sketch, and one issue with the H1-cotangent gap.

## Red flags

### Placeholder / suspect bodies
- `smooth_iff_locally_free_omega` (line 74): body is `:= by sorry`. **Acknowledged by directive** (refactored this iter from sheafified form to presheaf form; closure deferred to a future prover lane). Not re-classified as must-fix because the directive's "Known issues" explicitly authorises this state and the new statement is mathematically correct.

### Excuse-comments
None. The file has no `-- TODO`, `-- temporary`, `-- placeholder`, `-- will fix`, or similar excuse comments.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations; the body of `relativeDifferentialsPresheaf` is built from the Mathlib `relativeDifferentials'` construction (no smuggled choice).

### Mathlib name accuracy in the proof sketch
The blueprint's proof of `thm:smooth_iff_locally_free_omega` tags five Mathlib lemmas as `[verified]`. Two of those names do **not** exist in the pinned Mathlib snapshot:
- `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential` — **not found**. The actual API in `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean` is `Algebra.SubmersivePresentation.basisKaehler` / `basisKaehlerOfIsCompl` (camelCase, defined on a `SubmersivePresentation`, not directly on `IsStandardSmoothOfRelativeDimension`). The rank companion `Algebra.IsStandardSmoothOfRelativeDimension.rank_kaehlerDifferential` **does** exist, so the rank citation is correct.
- `AlgebraicGeometry.isSmoothOfRelativeDimension_iff` — **not found**. The actual name is `AlgebraicGeometry.smoothOfRelativeDimension_iff` (note: no `is` prefix; this matches the post-deprecation `SmoothOfRelativeDimension` class).

The other three names (`rank_kaehlerDifferential`, `IsStandardSmooth.iff_exists_basis_kaehlerDifferential`, `IsStandardSmoothOfRelativeDimension.iff_of_isStandardSmooth`) are verified present.

This is a **blueprint adequacy** issue, not a Lean-side issue. A prover following the chapter would search for these names, fail, and have to rediscover the correct API. Severity: **major** — the names are close enough to find by hand-search, but the `[verified]` annotation is wrong on two of five cited lemmas.

### Deprecation
- `Differentials.lean:76`: uses `AlgebraicGeometry.IsSmoothOfRelativeDimension`, which is deprecated in the current Mathlib snapshot in favour of `AlgebraicGeometry.SmoothOfRelativeDimension`. The compiler emits a deprecation warning (it still type-checks). Severity: **minor** — should be migrated at the same time as the sorry is closed, but doesn't block this iter.

## Unreferenced declarations (informational)
None. All three declarations in the Lean file are referenced by `\lean{...}` blocks in the blueprint chapter.

## Blueprint adequacy for this file

- **Coverage**: 3/3 Lean declarations have a corresponding `\lean{...}` block. Unreferenced: 0 helpers + 0 substantive.
- **Proof-sketch depth**: **under-specified for the converse direction of `thm:smooth_iff_locally_free_omega`**. The sketch correctly identifies that `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` requires a `Subsingleton (Algebra.H1Cotangent A B)` side-hypothesis, and asserts that "the project's local-freeness hypothesis combined with the locally-of-finite-presentation hypothesis on `f` supplies the required vanishing on each affine chart" — but does **not** explain *how*. This is the genuine deformation-theoretic content of the converse and the blueprint hand-waves it. A prover would need a separate sub-sketch (or an explicit Mathlib citation) of the H1-cotangent-vanishing argument before they could close the converse direction. The forward direction and local-to-global step are adequate.
- **Hint precision**: **loose**. The `\lean{...}` declaration-name hints are precise (full namespaced names matching the Lean), but two of the five `[verified]`-tagged Mathlib lemma names in the proof sketch are inaccurate (see Red flags). The `[verified]` marker connotes a claim about Mathlib availability that the chapter does not deliver on.
- **Generality**: **matches need**. The presheaf-form statement is exactly the level of generality the Lean exposes, the section-level identification lemma `relativeDifferentialsPresheaf_obj_kaehler` is the right bridge, and the "out of autonomous-loop scope" disclosure section honestly lists what was removed (sheaf condition, cotangent exact sequence, cotangent space at a section, Serre-duality genus identity) with concrete Mathlib gaps and cross-references.
- **`\leanok` discipline check**: the proof block of `thm:smooth_iff_locally_free_omega` (Differentials.tex:64) currently carries `\leanok` despite the Lean body being `sorry`. This will be corrected by the deterministic `sync_leanok` phase that runs between prover and review; flagging it here only as a heads-up (not my domain to fix).
- **Recommended chapter-side actions**:
  - Replace `Algebra.IsStandardSmoothOfRelativeDimension.basis_kaehlerDifferential [verified]` in `thm:smooth_iff_locally_free_omega`'s proof with `Algebra.SubmersivePresentation.basisKaehlerOfIsCompl` (or `basisKaehler` for the canonical complement case) and adjust the surrounding prose to reflect that a `SubmersivePresentation` witness needs to be extracted from `IsStandardSmoothOfRelativeDimension` first.
  - Replace `AlgebraicGeometry.isSmoothOfRelativeDimension_iff [verified]` with `AlgebraicGeometry.smoothOfRelativeDimension_iff` (drop the `is`).
  - Expand the converse-direction sketch with one paragraph on how `Subsingleton (Algebra.H1Cotangent A B)` is supplied — either via a concrete Mathlib lemma (and cite its name), or via an explicit "still to be supplied" admission that the iter-118 prover is responsible for proving. The current "supplies the required vanishing on each affine chart" wording is too thin to formalize from.
  - Optional minor: note in the "out of scope" section that the Lean file currently uses the deprecated `IsSmoothOfRelativeDimension` predicate (warning, not error) and is expected to migrate to `SmoothOfRelativeDimension` when the sorry is closed.

## Severity summary

- **must-fix-this-iter**: none. The lone `sorry` is explicitly authorised by the directive's "Known issues" as a deliberate, intentional refactor artefact, and the new presheaf-form statement is mathematically correct.
- **major**:
  - Two of five `[verified]`-tagged Mathlib lemma names in the proof sketch of `thm:smooth_iff_locally_free_omega` are inaccurate (`basis_kaehlerDifferential`, `isSmoothOfRelativeDimension_iff`).
  - Converse-direction proof sketch hand-waves the `Subsingleton (Algebra.H1Cotangent A B)` side-condition that is the actual mathematical content; an iter-118 prover lane cannot close the sorry from prose alone without an expansion here.
- **minor**:
  - `Differentials.lean:76` uses the deprecated predicate `IsSmoothOfRelativeDimension`; should migrate to `SmoothOfRelativeDimension` when the sorry is closed.
  - `lem:relative_kaehler_presheaf_obj`'s Lean statement is a `Type _` equality (carrier-level) where the blueprint prose reads more naturally as a module equality; harmless in practice but a precise prose update would prevent confusion.
  - The proof block of `thm:smooth_iff_locally_free_omega` carries `\leanok` while the Lean is `sorry`; `sync_leanok` will handle this between prover and review.

**Overall verdict**: The Lean file faithfully reflects the trimmed iter-117 scope (3 declarations, all blueprint-referenced, signatures and bodies match the chapter), and the chapter's "out of scope" disclosure is honest; the chapter's smoothness-theorem proof sketch needs name corrections and an expansion on H1-cotangent vanishing before an iter-118 prover can reasonably close the lone remaining `sorry`.
