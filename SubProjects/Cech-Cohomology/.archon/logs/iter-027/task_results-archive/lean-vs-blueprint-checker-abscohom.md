# Lean ↔ Blueprint Check Report

## Slug
abscohom

## Iteration
026

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (section "Absolute sheaf cohomology as Ext of the corepresenting object", lines 2788–3017)

---

## Per-declaration

### `\lean{AlgebraicGeometry.jShriekOU}` (chapter: `def:jshriek_ou`)
- **Lean target exists**: yes (`AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`, line 30)
- **Signature matches**: yes — `jShriekOU (U : Opens X) : X.Modules` defined as `sheafification.obj (free.obj (yoneda.obj U))`, exactly `j_!O_U = sheafification(free(y U))` from the blueprint.
- **Proof follows sketch**: N/A (definition, no proof body)
- **notes**: Body is 2-line application of the sheafification and free functors. No sorries. `lean_verify` confirms axioms = {propext, Classical.choice, Quot.sound}.

### `\lean{AlgebraicGeometry.jShriekOU_homEquiv}` (chapter: `lem:jshriek_corepr`)
- **Lean target exists**: yes (line 50)
- **Signature matches**: yes — `(jShriekOU U ⟶ F) ≃+ F.presheaf.obj (op U)` where the right-hand side is `Γ(U, F)` (the presheaf sections). Blueprint states `Hom(j_!O_U, F) ≅ Γ(U, F)`. MATCHES.
- **Proof follows sketch**: yes — composed as `sheafificationHomAddEquiv.trans (freeYonedaHomAddEquiv U _)`, exactly the two-step chain (sheafification adjunction then free-Yoneda equivalence) described in the blueprint proof of `lem:jshriek_corepr`.
- **notes**: `lean_verify` confirms axioms = {propext, Classical.choice, Quot.sound}. Relies on helper `sheafificationHomAddEquiv` (see unreferenced declarations).

### `\lean{AlgebraicGeometry.absoluteCohomology}` (chapter: `def:absolute_cohomology`)
- **Lean target exists**: yes (line 56)
- **Signature matches**: yes — `absoluteCohomology (p : ℕ) (U : Opens X) (F : X.Modules) : AddCommGrpCat` defined as `AddCommGrpCat.of (Ext (jShriekOU U) F p)`. Blueprint states `H^p(U, F) := Ext^p(j_!O_U, F)`. The `AddCommGrpCat.of` wrapper makes it a categorical abelian group object; this is consistent with the intended type. MATCHES.
- **Proof follows sketch**: N/A (one-liner definition)
- **notes**: `lean_verify` confirms axioms clean. Universe pin `HasExt.{u+1,u,u+1}` on the local instance `hasExtModules` (line 25) is needed for typeclass resolution; blueprint does not mention universe details (acceptable).

### `\lean{CategoryTheory.Abelian.Ext}` (chapter: `lem:ext_bifunctor_mathlib`, `\mathlibok`)
- **Lean target exists**: yes — confirmed present in Mathlib (`Mathlib.Algebra.Homology.DerivedCategory.Ext.Basic`)
- **Signature matches**: yes — `Abelian.Ext X Y n` is the Ext group, functorial and equipped with composition pairing, as stated.
- **Proof follows sketch**: N/A (`\mathlibok`)

### `\lean{CategoryTheory.HasExt.standard}` (chapter: `lem:hasext_standard_mathlib`, `\mathlibok`)
- **Lean target exists**: yes — confirmed: `HasExt.standard : ∀ (C : Type u) [Category C] [Abelian C], HasExt C`
- **Signature matches**: yes — provides `HasExt` for any abelian category, used directly as `hasExtModules := HasExt.standard _` at line 25.
- **Proof follows sketch**: N/A (`\mathlibok`)

### `\lean{CategoryTheory.Abelian.Ext.homEquiv₀, CategoryTheory.Abelian.Ext.addEquiv₀}` (chapter: `lem:ext_homequiv_zero_mathlib`, `\mathlibok`)
- **Lean target exists**: yes for both — `homEquiv₀ : Ext X Y 0 ≃ (X ⟶ Y)` (confirmed by hover); `addEquiv₀ : Ext X Y 0 ≃+ (X ⟶ Y)` (confirmed by `lean_run_code #check`)
- **Signature matches**: yes — both exist with the stated signatures. `homEquiv₀` is the plain equivalence; `addEquiv₀` is the additive version.
- **Proof follows sketch**: N/A (`\mathlibok`)
- **notes**: The Lean file uses `Ext.homEquiv₀` (the plain equivalence) and builds additivity manually via `AddEquiv.mk'` rather than using `Ext.addEquiv₀` directly. This is slightly redundant since `addEquiv₀` exists, but mathematically correct. See minor findings.

### `\lean{CategoryTheory.Abelian.Ext.eq_zero_of_injective}` (chapter: `lem:ext_eq_zero_of_injective_mathlib`, `\mathlibok`)
- **Lean target exists**: yes — confirmed: `eq_zero_of_injective {X I : C} {n : ℕ} [Injective I] (e : Ext X I (n+1)) : e = 0`
- **Signature matches**: yes
- **Proof follows sketch**: N/A (`\mathlibok`)

### `\lean{CategoryTheory.Abelian.Ext.covariantSequence_exact, ..._exact₁, ..._exact₂, ..._exact₃}` (chapter: `lem:ext_covariant_les_mathlib`, `\mathlibok`)
- **Lean target exists**: yes for `_exact₁`, `_exact₂`, `_exact₃` (confirmed by hover and `lean_run_code`). `covariantSequence_exact` not directly verified, but referenced as the five-term packaging.
- **Signature matches**: yes for all three step-lemmas verified
- **Proof follows sketch**: N/A (`\mathlibok`)

---

## Red flags

None found.

### Placeholder / suspect bodies
None. Every declaration has a substantive body; no `:= sorry`, `:= True`, or `Classical.choice _` on non-trivial claims.

### Excuse-comments
None. No `-- TODO`, `-- placeholder`, `-- temporary`, or similar in the file.

### Axioms / Classical.choice on non-trivial claims
None. `lean_verify` on all checked declarations returns axiom set = {propext, Classical.choice, Quot.sound} — the three standard Lean 4 kernel axioms. No unauthorized axioms introduced.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have no `\lean{...}` reference in the blueprint:

| Declaration | Lines | Assessment |
|---|---|---|
| `hasExtModules` | 24–27 | Local instance (helper). Blueprint acknowledges `HasExt.standard` is used; this is the project-local instantiation to dodge slow typeclass search. Acceptable to omit from blueprint. |
| `sheafificationHomAddEquiv` | 36–48 | Helper — the additive upgrade of the sheafification adjunction hom-equivalence needed to compose with `freeYonedaHomAddEquiv`. Not mathematical content in its own right; internal step of `jShriekOU_homEquiv`. Acceptable to omit. |
| `absoluteCohomologyZeroAddEquiv` | 63–71 | **Substantive**. Establishes `Ext(jShriekOU U, F, 0) ≃+ Γ(U, F)` — the H⁰ ≅ Γ isomorphism. This is described in item (1) of `def:absolute_cohomology`'s prose but never pinned by a `\lean{}` tag. Should have a blueprint block. |
| `absoluteCohomology_eq_zero_of_injective` | 76–78 | **Substantive**. The thin injective-vanishing wrapper. Described in item (2) of `def:absolute_cohomology` and the `lem:ext_eq_zero_of_injective_mathlib` block but no project-level `\lean{}` tag pinning this wrapper. Should be pinned. |
| `absoluteCohomology_covariant_exact₁` | 83–88 | **Substantive**. LES surjectivity wrapper. Same situation. |
| `absoluteCohomology_covariant_exact₂` | 93–97 | **Substantive**. LES exactness-at-F₂ wrapper. Same situation. |
| `absoluteCohomology_covariant_exact₃` | 102–107 | **Substantive**. LES exactness-at-connecting-map wrapper. Same situation. |

Summary: 2 helpers (acceptable to omit) + 5 substantive declarations with no `\lean{}` blocks (should be added).

---

## Blueprint adequacy for this file

- **Coverage**: 3/10 Lean declarations have a corresponding `\lean{...}` block directly in the chapter (`jShriekOU`, `jShriekOU_homEquiv`, `absoluteCohomology`). An additional 5 Mathlib targets are pinned via `\mathlibok`. Unreferenced: 2 helpers (acceptable) + **5 substantive** (flagged above).

- **Proof-sketch depth**: **adequate**. The prose of `def:absolute_cohomology` spells out all three structural facts (H⁰ ≅ Γ, injective vanishing, LES) in enough detail that a prover could produce the corresponding thin wrappers. The proof of `lem:jshriek_corepr` gives the two-step composition chain precisely. A prover had enough to work from.

- **Hint precision**: **partial** — the `\lean{}` hints for the 3 project-side declarations (`jShriekOU`, `jShriekOU_homEquiv`, `absoluteCohomology`) are precise and correct. The `\mathlibok` anchors are accurate: all named Mathlib declarations exist with the stated signatures (`hasExtModules`, `homEquiv₀`, `addEquiv₀`, `eq_zero_of_injective`, `covariant_sequence_exact₁,₂,₃`). The 5 missing `\lean{}` pins for the project wrappers (`absoluteCohomologyZeroAddEquiv`, etc.) leave the chapter structurally incomplete.

- **Generality**: matches need — the formulation (`Ext(jShriekOU U, -, p)` in a single abelian category) is exactly what the downstream arguments require, avoiding any restriction-of-module-sheaves issue.

- **Recommended chapter-side actions** (for the blueprint-writing subagent):
  1. Add a `\begin{lemma}...\end{lemma}` block with `\lean{AlgebraicGeometry.absoluteCohomologyZeroAddEquiv}` for the H⁰ ≅ Γ additive isomorphism, immediately after `def:absolute_cohomology`. Note that `addEquiv₀` exists in Mathlib and the Lean proof does so manually via `AddEquiv.mk'` — either approach is valid, but the hint should point to the project-level declaration.
  2. Add `\lean{AlgebraicGeometry.absoluteCohomology_eq_zero_of_injective}` — a one-sentence block suffices (thin wrapper of `Ext.eq_zero_of_injective`).
  3. Add `\lean{AlgebraicGeometry.absoluteCohomology_covariant_exact₁}`, `..._exact₂`, `..._exact₃` — three one-sentence blocks, or one block naming all three.
  4. (Minor) Note in the proof of `lem:jshriek_corepr` that the intermediate helper `sheafificationHomAddEquiv` builds the additive structure of the sheafification adjunction hom-bijection. Not a blueprint block needed, but a sentence in the proof body would document the manual additivity step.

---

## Severity summary

| Finding | Severity |
|---|---|
| 5 substantive Lean declarations (`absoluteCohomologyZeroAddEquiv`, `absoluteCohomology_eq_zero_of_injective`, `_exact₁`, `_exact₂`, `_exact₃`) have no `\lean{...}` blueprint blocks | **major** |
| `absoluteCohomologyZeroAddEquiv` uses `homEquiv₀` + manual `AddEquiv.mk'` rather than `addEquiv₀` directly (both exist; result is identical) | **minor** |

**Overall verdict**: The file is axiom-clean, all 3 explicitly-pinned declarations faithfully match their blueprint statements, and all 5 `\mathlibok` anchors resolve to confirmed Mathlib declarations — but 5 substantive project-level wrappers lack `\lean{}` blueprint blocks, a **major** blueprint adequacy gap that should be closed by adding the missing blocks.

---

## Counts
- Declarations checked (Lean file): 10 total (3 pinned in blueprint, 5 `\mathlibok` anchors, 2 helpers)
- `\lean{}` blocks verified: 3 project declarations + 5 Mathlib anchors = 8 targets checked
- Red flags: 0
- Must-fix findings: 0
- Major findings: 1 (5 missing `\lean{}` blocks)
- Minor findings: 1 (`addEquiv₀` unused)
