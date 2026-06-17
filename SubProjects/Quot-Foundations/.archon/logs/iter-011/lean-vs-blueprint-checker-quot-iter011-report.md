# Lean ↔ Blueprint Check Report

## Slug
quot-iter011

## Iteration
011

## Files audited
- Lean: `AlgebraicJacobian/Picard/QuotScheme.lean`
- Blueprint: `blueprint/src/chapters/Picard_QuotScheme.tex`

---

## Per-declaration

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomial}` (chapter: def:hilbert_polynomial)
- **Lean target exists**: yes (line 123)
- **Signature matches**: partial — the Lean skeleton takes `(_L _F : X.Modules) (_s : S)` without a `HasProperSupport π _F` hypothesis that the blueprint prose requires ("coherent sheaf whose schematic support is proper over S"). The file header documents this as intentional for the skeleton ("here encoded as plain X.Modules for the file-skeleton"). The type is weaker than the final target.
- **Proof follows sketch**: N/A — body is `sorry`, documented as iter-177+ work pending Snapper/graded-Euler-characteristic infrastructure.
- **notes**: `\leanok` present in blueprint (skeleton exists). Blueprint NOTE on `def:sectionGradedRing` acknowledges the tensor/monoidal infrastructure block that keeps the graded route deferred.

### `\lean{AlgebraicGeometry.sectionGradedRing}` (chapter: def:sectionGradedRing)
- **Lean target exists**: no — not defined in QuotScheme.lean. Blueprint NOTE says "blocked on absent tensor/monoidal structure for SheafOfModules." No Lean file in this project carries this declaration.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` marker. The block is correctly unmarked. This is a blocked prerequisite outside the scope of QuotScheme.lean; the chapter `archon:covers` line names only QuotScheme.lean, so this is a cross-file gap.

### `\lean{AlgebraicGeometry.sectionGradedModule}` (chapter: def:sectionGradedModule)
- **Lean target exists**: no — not in QuotScheme.lean.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` marker. Same status as `sectionGradedRing`. Blocked on tensor infrastructure.

### `\lean{AlgebraicGeometry.sectionGradedModule_fg}` (chapter: lem:sectionGradedModule_fg)
- **Lean target exists**: no — not in QuotScheme.lean.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` marker. Correctly unmarked.

### `\lean{Polynomial.existsUnique_hilbertPoly}` (chapter: lem:hilbertPoly_exists_mathlib)
- **Lean target exists**: yes — Mathlib (declared `\mathlibok`)
- **Signature matches**: yes — `\mathlibok` block, no project-side obligation.
- **Proof follows sketch**: N/A
- **notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.gradedModule_hilbertSeries_rational}` (chapter: lem:gradedHilbertSerre_rational)
- **Lean target exists**: no — not in QuotScheme.lean. No marker; correctly unmarked.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: The blueprint's intended Lean signature (in a `% LEAN SIGNATURE` comment) is detailed, but the declaration doesn't exist yet. Correctly unblocked from this file.

### `\lean{AlgebraicGeometry.Scheme.hilbertPolynomialOfSectionModule}` (chapter: thm:hilbertPoly_of_sectionModule)
- **Lean target exists**: no — not in QuotScheme.lean.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: No `\leanok` marker. This is the bridge that ties `hilbertPolynomial` to the graded construction; it presupposes `gradedHilbertSerre_rational`.

### `\lean{AlgebraicGeometry.Scheme.Modules.annihilator}` (chapter: def:modules_annihilator)
- **Lean target exists**: yes (line 298)
- **Signature matches**: yes — `noncomputable def annihilator (F : X.Modules) : X.IdealSheafData`, body `IdealSheafData.ofIdeals fun U => Module.annihilator Γ(X, U.1) Γ(F, U.1)`. Matches the blueprint's description exactly, mirroring the `ofIdeals` construction cited for `Scheme.Hom.ker`.
- **Proof follows sketch**: yes — the definition is axiom-clean; `ofIdeals` sidesteps the basic-open coherence proof at definition time, exactly as the blueprint describes.
- **notes**: `\leanok` present and correct. Blueprint NOTE accurately records that the definition is closed and only the forward characterization remains bridge-gated.

### `\lean{Module.annihilator_isLocalizedModule_eq_map}` (chapter: lem:annihilator_localization_eq_map)
- **Lean target exists**: yes (line 362, in `namespace Module`)
- **Signature matches**: yes — `theorem annihilator_isLocalizedModule_eq_map {R ...} [CommRing R] (S : Submonoid R) ... (f : M →ₗ[R] Mₚ) [IsLocalizedModule S f] : Module.annihilator Rₚ Mₚ = (Module.annihilator R M).map (algebraMap R Rₚ)`. Matches the blueprint prose exactly.
- **Proof follows sketch**: yes — proof has the two-direction structure of the blueprint proof: the `⊇` direction via `Ideal.map_le_iff_le_comap`, the `⊆` direction via choosing a common denominator `U = ∏ u_i` over the finite generating set (exactly the "single common multiplier ∏u_i" step the blueprint highlights as requiring finite generation). Mathematical content matches.
- **notes**: `\leanok` present. Proof is real (no `sorry`). The `classical` opening and the `Finset.dvd_prod_of_mem` use are implementation details not in the sketch but mathematically equivalent.

### `\lean{AlgebraicGeometry.IsAffineOpen.isLocalization_basicOpen}` (chapter: lem:isLocalization_basicOpen_mathlib)
- **Lean target exists**: yes — Mathlib (`\mathlibok`)
- **Signature matches**: yes
- **Proof follows sketch**: N/A
- **notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.isLocalizedModule_basicOpen}` (chapter: lem:qcoh_section_localization_basicOpen)
- **Lean target exists**: no — not defined in QuotScheme.lean. No `\leanok` marker; correctly unmarked.
- **Signature matches**: N/A
- **Proof follows sketch**: N/A
- **notes**: This is the QCoh→IsLocalizedModule bridge (section restriction as a localization for quasi-coherent sheaves). Blocked; the blueprint's intended Lean signature is pinned in a `% LEAN SIGNATURE` comment. The forward direction of the annihilator characterization depends on this lemma.

### `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` (chapter: def:schematic_support)
- **Lean target exists**: yes (line 312)
- **Signature matches**: yes — `noncomputable def schematicSupport (F : X.Modules) : Scheme.{u}`, body `(annihilator F).subscheme`. Correctly implements "closed subscheme cut out by the annihilator ideal sheaf."
- **Proof follows sketch**: yes — directly delegates to `IdealSheafData.subscheme`.
- **notes**: `\leanok` present and correct. The closed immersion is separated as `schematicSupportι` (a Lean-only split not reflected in the blueprint block; see coverage debt below).

### `\lean{AlgebraicGeometry.IsProper}` (chapter: lem:isProper_mathlib)
- **Lean target exists**: yes — Mathlib (`\mathlibok`)
- **Signature matches**: yes
- **notes**: Correctly marked `\mathlibok`.

### `\lean{AlgebraicGeometry.Scheme.Modules.HasProperSupport}` (chapter: def:has_proper_support)
- **Lean target exists**: yes (line 328)
- **Signature matches**: yes — `def HasProperSupport {S : Scheme.{u}} (f : X ⟶ S) (F : X.Modules) : Prop := IsProper (schematicSupportι F ≫ f)`. Matches the blueprint: "schematic-support immersion ∘ f is proper."
- **Proof follows sketch**: yes — the definition is a one-liner. Blueprint's properness/base-change note is accurately reflected in the docstring.
- **notes**: `\leanok` present and correct.

### `\lean{AlgebraicGeometry.SheafOfModules.IsLocallyFreeOfRank}` (chapter: def:is_locally_free_of_rank)
- **Lean target exists**: yes (line 253, in `namespace SheafOfModules`)
- **Signature matches**: yes — `def IsLocallyFreeOfRank {X : Scheme.{u}} (M : X.Modules) (d : ℕ) : Prop := ∃ (ι : Type u) (U : ι → X.Opens), (⨆ i, U i = ⊤) ∧ ∀ i, Nonempty ((Scheme.Modules.pullback (U i).ι).obj M ≅ _root_.SheafOfModules.free (R := (U i).toScheme.ringCatSheaf) (ULift.{u} (Fin d)))`. Blueprint: "open cover {U_i} with M|_{U_i} ≅ O_{U_i}^{⊕d}." The ULift encoding is a universe technicality, not a mathematical weakening.
- **Proof follows sketch**: yes — the definition is axiomatic (a Prop).
- **notes**: `\leanok` present and correct.

### `\lean{AlgebraicGeometry.Scheme.QuotFunctor}` (chapter: def:quot_functor)
- **Lean target exists**: yes (line 161)
- **Signature matches**: yes — `noncomputable def QuotFunctor {S X : Scheme.{u}} [IsLocallyNoetherian S] (_π : X ⟶ S) [LocallyOfFiniteType _π] (_L _E : X.Modules) (_Φ : Polynomial ℚ) : (Over S)ᵒᵖ ⥤ Type u`. Matches the blueprint's `(Sch/S)^op → Set`.
- **Proof follows sketch**: N/A — body is `sorry`, documented as iter-177+ work.
- **notes**: `\leanok` present (skeleton exists). As with `hilbertPolynomial`, the proper-support hypothesis on `F` is not a parameter of the functor itself (it's part of the on-objects data), so the skeleton signature is faithful at the functor level.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian}` (chapter: def:grassmannian_scheme)
- **Lean target exists**: yes (line 198)
- **Signature matches**: yes — `noncomputable def Grassmannian {S : Scheme.{u}} [IsLocallyNoetherian S] (_V : S.Modules) (_d : ℕ) : (Over S)ᵒᵖ ⥤ Type u`. Matches the blueprint's `Grass(V, d) : (Sch/S)^op → Set`.
- **Proof follows sketch**: N/A — body is `sorry`, documented as iter-177+.
- **notes**: `\leanok` present.

### `\lean{CategoryTheory.Functor.IsRepresentable}` (chapter: lem:functor_is_representable_mathlib)
- **Lean target exists**: yes — Mathlib (`\mathlibok`)
- **Signature matches**: yes
- **notes**: Correctly marked `\mathlibok`. Note: `thm:grassmannian_representable` uses `Functor.RepresentableBy` (stronger: gives explicit bijection data) rather than `Functor.IsRepresentable` (just existence). The Lean's docstring documents this intentional choice.

### `\lean{AlgebraicGeometry.Scheme.Grassmannian.representable}` (chapter: thm:grassmannian_representable)
- **Lean target exists**: yes (line 225)
- **Signature matches**: yes — `theorem Grassmannian.representable {S : Scheme.{u}} [IsLocallyNoetherian S] (V : S.Modules) (d : ℕ) : ∃ (Y : Over S), Nonempty ((Grassmannian V d).RepresentableBy Y)`. Blueprint: "∃ representing Y : Over S, a RepresentableBy Y witness." Uses `RepresentableBy` (not `IsRepresentable`) as documented.
- **Proof follows sketch**: N/A — body is `sorry`. Blueprint NOTE records this is blocked on strengthening `thm:relative_spec_univ` or finding a RepresentableBy-free argument.
- **notes**: `\leanok` present (skeleton). The proof sketch in the blueprint chapter is detailed (gluing affine charts, separatedness, properness via valuative criterion, Plücker embedding), providing adequate guidance for when the sorry is filled.

---

## Red flags

### Placeholder / suspect bodies

- `hilbertPolynomial` (line 126): body is `:= sorry`. The blueprint's `\leanok` is correct per project semantics (skeleton exists); the blueprint `def:hilbert_polynomial` carries a detailed `% ENCODING` note marking this as a graded-construction dependency. **Not a must-fix** — this is an explicitly deferred obligation (iter-177+).
- `QuotFunctor` (line 165): body is `:= sorry`. Correctly deferred; documented.
- `Grassmannian` (line 201): body is `:= sorry`. Correctly deferred; documented.
- `Grassmannian.representable` (line 228): body is `by sorry`. Correctly blocked on RepresentableBy infrastructure; documented in blueprint NOTE.

No excuse-comments found. No `axiom` declarations introduced. No `Classical.choice` on substantive claims (the proof of `annihilator_isLocalizedModule_eq_map` uses `classical` for decidability in the Finset product step, which is normal and mathematically correct).

---

## Unreferenced declarations (informational)

### `Scheme.Modules.annihilator_ideal_le` (line 305)
- No `\lean{...}` block in the blueprint.
- The blueprint NOTE on `def:modules_annihilator` explicitly references this lemma by name ("the `ofIdeals` inclusion direction is the landed lemma `Scheme.Modules.annihilator_ideal_le`"), but there is no formal `\lean{}` block or `\label` for it.
- This is a substantive helper (it proves the only currently-available direction of the full characterization), not a private implementation detail. It should have a blueprint block.

### `Scheme.Modules.schematicSupportι` (line 320)
- No `\lean{...}` block in the blueprint.
- The blueprint's `def:schematic_support` says the schematic support is "equipped with its canonical closed immersion into X" but folds this into the single `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupport}` pin. In Lean, the closed immersion is a separate definition.
- Since `schematicSupportι` is used directly in `HasProperSupport`, it is a visible API surface that should be reflected in the blueprint.

---

## Blueprint adequacy for this file

- **Coverage**: 13 of 19 `\lean{...}` blocks in the chapter resolve to declarations in QuotScheme.lean or Mathlib (the `\mathlibok` items). The 6 unresolved blocks (`sectionGradedRing`, `sectionGradedModule`, `sectionGradedModule_fg`, `gradedHilbertSerre_rational`, `hilbertPolynomialOfSectionModule`, `isLocalizedModule_basicOpen`) are declarations not in QuotScheme.lean — all correctly unmarked. They are either in other Lean files (graded-Hilbert-polynomial infrastructure, presumably in a separate sub-build) or blocked on deep prerequisites. Cross-file consistency is outside this checker's scope, but the `% archon:covers AlgebraicJacobian/Picard/QuotScheme.lean` header on the chapter appears too narrow if the chapter is intended to cover those graded declarations when they land.
- **Proof-sketch depth**: adequate. The four sorry-bearing declarations all have detailed blueprint sketches (the graded-section-ring argument for `hilbertPolynomial`, the `Setoid`/pullback description for `QuotFunctor`, and the full five-step Grassmannian construction for `thm:grassmannian_representable`). The `annihilator_isLocalizedModule_eq_map` proof sketch was detailed enough to guide a correct formalization (the landed proof matches it).
- **Hint precision**: mostly precise. One point of divergence: `thm:grassmannian_representable` uses `Functor.RepresentableBy` (a structure giving the Yoneda bijection data) while the `\uses{}` block cites `lem:functor_is_representable_mathlib` → `CategoryTheory.Functor.IsRepresentable` (a Prop). The Lean file documents the intentional choice of the stronger form. The `\lean{}` hint is consistent; the `\uses{}` reference is slightly misleading (it implies `IsRepresentable` is the direct tool used, when actually `RepresentableBy` is). Minor.
- **Generality**: matches need for all currently-implemented declarations.
- **Recommended chapter-side actions**:
  1. Add a `\begin{lemma}...\end{lemma}` block for `Scheme.Modules.annihilator_ideal_le` with `\lean{AlgebraicGeometry.Scheme.Modules.annihilator_ideal_le}` pin. This is the `ofIdeals`-inclusion direction and is part of the public API.
  2. Add a `\lean{AlgebraicGeometry.Scheme.Modules.schematicSupportι}` pin inside `def:schematic_support` (or as a companion remark), since the Lean separates the closed immersion as a standalone def that is directly consumed by `HasProperSupport`.
  3. Optionally strengthen the `\uses{}` of `thm:grassmannian_representable` to reference `Functor.RepresentableBy` explicitly (or add a note that the proof uses the stronger structure).
  4. Verify whether the chapter `archon:covers` annotation should be widened to include the Lean files that will carry the graded-Hilbert-polynomial infrastructure (`sectionGradedRing`, `gradedHilbertSerre_rational`, etc.) when those land.

---

## Verification of the 4 remaining sorries

All 4 `sorry` bodies in QuotScheme.lean correspond to genuinely blocked or explicitly deferred blueprint nodes:

| Declaration | Blueprint node | Reason deferred |
|---|---|---|
| `hilbertPolynomial` | `def:hilbert_polynomial` | Blocked on graded-Euler-characteristic/Snapper infrastructure (`sectionGradedRing` blocked on tensor product of sheaves). Iter-177+. |
| `QuotFunctor` | `def:quot_functor` | Blocked on `Scheme.Modules.pullback` bifunctor + `Setoid`/`Quotient` packaging for the on-objects/on-morphisms data. Iter-177+. |
| `Grassmannian` | `def:grassmannian_scheme` | Blocked on `QuotFunctor` (which it re-exports as the constant-polynomial case). Iter-177+. |
| `Grassmannian.representable` | `thm:grassmannian_representable` | Blocked on `thm:relative_spec_univ` delivering a `RepresentableBy` witness (or an alternative chart-gluing argument). Blueprint NOTE documents this. |

None of the 4 sorries represents a silently dropped obligation. The blueprint's `\leanok` markers on these nodes are correctly set (skeleton present).

The QCoh→`IsLocalizedModule` bridge (`isLocalizedModule_basicOpen`) is NOT a sorry in this file — the characterization lemma that depends on it (`annihilator_ideal`, the reverse direction of `annihilator_ideal_le`) simply has not been written yet. The forward direction (`annihilator_ideal_le`) is axiom-clean. This is the correct state given the bridge is unresolved.

---

## Severity summary

- **must-fix-this-iter**: none.
- **major**:
  1. `Scheme.Modules.annihilator_ideal_le` (line 305): landed declaration with no `\lean{...}` block in blueprint. The NOTE references it by name but stops short of adding a formal block. Blueprint-side action needed.
  2. `Scheme.Modules.schematicSupportι` (line 320): landed declaration with no `\lean{...}` block. The blueprint folds the closed immersion into `def:schematic_support` without pinning this API element separately. Blueprint-side action needed.
- **minor**:
  1. `hilbertPolynomial` drops the `HasProperSupport` hypothesis in the skeleton (documented intentional; does not affect axiom cleanliness or downstream users since the body is `sorry`).
  2. `thm:grassmannian_representable` uses `Functor.RepresentableBy` where `\uses{}` references `CategoryTheory.Functor.IsRepresentable`; the divergence is documented and intentional.
  3. The chapter's `archon:covers` annotation may need widening when the graded-Hilbert constructions land.

**Overall verdict**: The 5 new axiom-clean declarations (`annihilator`, `annihilator_ideal_le`, `schematicSupport`, `schematicSupportι`, `HasProperSupport`) and the real proof of `annihilator_isLocalizedModule_eq_map` faithfully implement their blueprint descriptions; the 4 remaining `sorry`s are correctly deferred and documented; two blueprint coverage gaps (missing `\lean{}` blocks for `annihilator_ideal_le` and `schematicSupportι`) are major but not blocking.
