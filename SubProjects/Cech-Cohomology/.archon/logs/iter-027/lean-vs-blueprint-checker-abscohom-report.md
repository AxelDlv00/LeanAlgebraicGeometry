# Lean ↔ Blueprint Check Report

## Slug
abscohom

## Iteration
027

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/AbsoluteCohomology.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (section §"Form-B absolute cohomology", lines 2800–3127, plus `lem:absolute_cohomology_covariant_les` through 3127)

---

## Per-declaration

### `\lean{AlgebraicGeometry.jShriekOU}` (chapter: `def:jshriek_ou`)
- **Lean target exists**: yes (line 30)
- **Signature matches**: yes — `TopologicalSpace.Opens X → X.Modules`, defined as sheafification of the free presheaf on `yoneda.obj U`, exactly as the blueprint describes: `sheafification(free(𝐲 U))`
- **Proof follows sketch**: N/A (definition, no proof body to compare)
- **notes**: Definition is noncomputable and clean; the `\leanok` marker in the blueprint is correctly set.

---

### `\lean{AlgebraicGeometry.sheafificationHomAddEquiv}` + `\lean{AlgebraicGeometry.jShriekOU_homEquiv}` (chapter: `lem:jshriek_corepr`)
- **Lean target exists**: yes (lines 34 and 50)
- **Signature matches**: yes — both are `AddEquiv` variants expressing the corepresentability chain; `sheafificationHomAddEquiv` gives the sheafification-adjunction half and `jShriekOU_homEquiv` composes it with `freeYonedaHomAddEquiv`
- **Proof follows sketch**: yes — blueprint says "compose two natural additive isomorphisms: sheafification adjunction then free–Yoneda evaluation"; the Lean body does exactly `.trans (freeYonedaHomAddEquiv U _)` on top of the adjunction `homEquiv`, with the `map_add'` obligation discharged by `erw [Functor.map_add, Preadditive.comp_add]`
- **notes**: The additivity proof for `sheafificationHomAddEquiv` is more technical than the blueprint sketch suggests (needs explicit `Additive` instance hint via `haveI`), but this is not a mismatch — it's a Lean elaboration detail.

---

### `\lean{AlgebraicGeometry.absoluteCohomology}` (chapter: `def:absolute_cohomology`)
- **Lean target exists**: yes (line 55)
- **Signature matches**: yes — `ℕ → TopologicalSpace.Opens X → X.Modules → AddCommGrpCat`, defined as `AddCommGrpCat.of (Ext (jShriekOU U) F p)`, which is exactly `Extᵖ_{Mod(O_X)}(j_!O_U, F)` wrapped in `AddCommGrpCat`
- **Proof follows sketch**: N/A (definition)
- **notes**: `\leanok` marker in blueprint is correctly set. The `AddCommGrpCat` name is project-specific (standard Mathlib spelling); not a deviation.

---

### `\lean{AlgebraicGeometry.absoluteCohomologyZeroAddEquiv}` (chapter: `lem:absolute_cohomology_zero`)
- **Lean target exists**: yes (line 63)
- **Signature matches**: yes — `Ext (jShriekOU U) F 0 ≃+ (sections of F over U)`, assembling `Ext.homEquiv₀` and `jShriekOU_homEquiv` exactly as described
- **Proof follows sketch**: yes — blueprint says "compose `Ext⁰ ≅ Hom` (degree-zero comparison) with corepresentability `Hom ≅ Γ(U,−)`"; Lean does this as `(AddEquiv.mk' Ext.homEquiv₀ ...).trans (jShriekOU_homEquiv U F)`, with the `map_add'` obligation closed by an `injective` argument
- **notes**: Both `\leanok` blocks (statement + proof) are correctly set in the blueprint.

---

### `\lean{AlgebraicGeometry.absoluteCohomologyZeroAddEquiv_naturality}` (chapter: `lem:absolute_cohomology_zero_natural`)

**This is the primary target of this iter's check.**

- **Lean target exists**: yes (line 162)
- **Signature matches**: yes, **and matches the directive's description precisely**:
  - Bottom arrow: `ConcreteCategory.hom (((Scheme.Modules.toPresheafOfModules X).map g).app (Opposite.op U))` ✓
  - Top arrow: `e.comp (Ext.mk₀ g) (add_zero 0)` ✓
  - The equation `absoluteCohomologyZeroAddEquiv U F₂ (e.comp (Ext.mk₀ g) (add_zero 0)) = g_U (absoluteCohomologyZeroAddEquiv U F₁ e)` is exactly the commutativity of the naturality square from the blueprint.
  - The blueprint says the top horizontal arrow is "the functorial action of g on Ext⁰ in the second variable"; this is `e ↦ e.comp (Ext.mk₀ g) (add_zero 0)`, which matches.
  - The blueprint says the bottom arrow is "the sections map `g_U = g(U)`"; the Lean expression `(toPresheafOfModules X).map g` applied at `op U` is the correct rendering of this in Lean's presheaf/sheaf framework.
  - **No signature drift detected.**
- **Proof follows sketch**: yes — blueprint sketch says:
  1. "under the degree-zero Ext comparison, post-composition by `Ext.mk₀ g` corresponds to post-composition by `g` in Hom" → handled by private helper `homEquiv₀_comp_mk₀`
  2. "under corepresentability (natural in the second variable, being a composite of sheafification adjunction and free–Yoneda evaluation), this corresponds to applying `g` on sections over `U`" → handled by `jShriekOU_homEquiv_naturality`
  3. Conclude commutativity.

  Lean proof (lines 167–169):
  ```
  change jShriekOU_homEquiv U F₂ (Ext.homEquiv₀ (e.comp (Ext.mk₀ g) (add_zero 0))) = _
  rw [homEquiv₀_comp_mk₀, jShriekOU_homEquiv_naturality]
  rfl
  ```
  This is a faithful, one-to-one formalization of the two-step argument. Mathematical content matches exactly.
- **notes**: Both `\leanok` markers (statement and proof) are set correctly in the blueprint. Axiom check: only `propext`, `Classical.choice`, `Quot.sound` — the standard Lean/Mathlib axioms. No non-standard axioms, no sorry.

---

### `\lean{AlgebraicGeometry.absoluteCohomology_eq_zero_of_injective}` (chapter: `lem:absolute_cohomology_injective_vanishing`)
- **Lean target exists**: yes (line 76)
- **Signature matches**: yes — `∀ n U I [Injective I] (e : Ext (jShriekOU U) I (n+1)), e = 0`, closed by `Ext.eq_zero_of_injective e`
- **Proof follows sketch**: yes — single-line delegation to Mathlib, exactly as the blueprint describes ("Immediate from `Ext.eq_zero_of_injective` with the injective in the second argument")
- **notes**: `\leanok` set correctly.

---

### `\lean{AlgebraicGeometry.absoluteCohomology_covariant_exact₁}` + `exact₂` + `exact₃` (chapter: `lem:absolute_cohomology_covariant_les`)
- **Lean target exists**: yes (lines 83, 93, 102)
- **Signature matches**: yes for all three — each is a thin wrapper around `Ext.covariant_sequence_exact{₁,₂,₃}` at fixed first argument `jShriekOU U`
- **Proof follows sketch**: yes — blueprint says "each wrapper fixes the first Ext argument to `j_!O_U` and threads the short exact sequence and degree hypotheses unchanged"; the Lean proofs are single-line delegations, exactly this
- **notes**: No `\leanok` marker in the blueprint for `lem:absolute_cohomology_covariant_les` — but `lean_diagnostic_messages` reports no errors and `lean_verify` for the star declaration shows only standard axioms. This is a marker omission from the chapter, not a Lean error. (Minor; the `sync_leanok` phase handles `\leanok` automatically.)

---

## Red flags

### Placeholder / suspect bodies
*None found.* No `:= sorry`, no `:= True`, no `:= Classical.choice _` on substantive claims.

### Excuse-comments
*None found.* No `-- TODO replace with real def`, `-- temporary`, `-- placeholder`, or `-- wrong but works for now` comments.

### Axioms / Classical.choice on non-trivial claims
*None found.* Axiom set for `absoluteCohomologyZeroAddEquiv_naturality`:
```
propext, Classical.choice, Quot.sound
```
These are the standard Lean 4 / Mathlib foundations. No non-standard axioms introduced anywhere in the file.

### Local instance warning
- `hasExtModules` at lines 22–26: LSP reports a "local instance" warning. This is **intentional** — the doc-comment explains it avoids the slow `HasSmallLocalizedHom` typeclass search. Not a red flag; the warning is expected and the comment explains the rationale.

---

## Unreferenced declarations (informational)

The following declarations in the Lean file have **no** `\lean{...}` blueprint reference. Per the directive, they are **coverage debt** to be bundled by the planner:

| Declaration | Lines | Why unreferenced |
|---|---|---|
| `homEquiv₀_comp_mk₀` | 115–118 | `private` helper: naturality of `Ext.homEquiv₀` in the second argument (used only in `absoluteCohomologyZeroAddEquiv_naturality` proof) |
| `freeYonedaHomEquiv_naturality` | 124–131 | `private` helper: naturality of the free–Yoneda evaluation in the presheaf coefficient (used in `jShriekOU_homEquiv_naturality`) |
| `sheafificationHomAddEquiv_naturality` | 137–141 | `private` helper: naturality of the sheafification adjunction bijection in the coefficient sheaf (used in `jShriekOU_homEquiv_naturality`) |
| `jShriekOU_homEquiv_naturality` | 147–154 | `private` helper: assembles the two halves; naturality of the composite corepresentability `AddEquiv` (used in `absoluteCohomologyZeroAddEquiv_naturality` proof) |

All four are **properly private** and serve exclusively as sub-lemmas of `absoluteCohomologyZeroAddEquiv_naturality`. Their names suggest they are intermediate steps of the naturality argument, not stand-alone blueprint targets. The directive confirms this: they should be bundled into a single new blueprint block (e.g., under the proof of `lem:absolute_cohomology_zero_natural` or as a new sub-lemma `lem:jshriek_homequiv_naturality`).

One additional unreferenced declaration:
- `hasExtModules` (lines 22–26): `noncomputable local instance`. Pure infrastructure. Not a blueprint target. Not a red flag.

**Total**: 10/15 declarations are `\lean{...}`-referenced. 4 private helpers + 1 local instance are unreferenced (all acceptable or expected).

---

## Blueprint adequacy for this file

- **Coverage**: 10/10 *public* Lean declarations have a corresponding `\lean{...}` block in the chapter. The 4 private helpers and 1 local instance are unreferenced (appropriate for infrastructure). Coverage is complete for public declarations.
- **Proof-sketch depth**: **adequate** for the public targets. The sketches for `lem:absolute_cohomology_zero` (two-step compose), `lem:absolute_cohomology_zero_natural` (post-composition matches via adjunction naturality), and `lem:absolute_cohomology_injective_vanishing` / `lem:absolute_cohomology_covariant_les` (single-line delegations) are sufficiently detailed to guide formalization. The sketch for `lem:absolute_cohomology_zero_natural` correctly identifies the two-step decomposition (Ext comparison naturality + corepresentability naturality), which maps cleanly to `homEquiv₀_comp_mk₀` + `jShriekOU_homEquiv_naturality`. A prover needs to *derive* the 4 intermediate helpers without being given their names, but the proof sketch gives enough structure that a competent prover would derive them.
- **Hint precision**: **precise**. All `\lean{...}` hints pin fully-qualified Lean names that exist, have the right signatures, and match the prose. No loose or wrong hints found.
- **Generality**: **matches need**. The blueprint defines everything at the right level of generality; no parallel API was written to cover gaps.
- **Recommended chapter-side actions**:
  1. **(minor)** Bundle the 4 private helpers into a new blueprint sub-lemma block — e.g., a `lem:jshriek_homequiv_naturality` block referencing `homEquiv₀_comp_mk₀`, `freeYonedaHomEquiv_naturality`, `sheafificationHomAddEquiv_naturality`, `jShriekOU_homEquiv_naturality` — inside the proof of `lem:absolute_cohomology_zero_natural`. This closes the coverage debt flagged above.
  2. **(optional)** Add `\lean{...}` tag to `lem:absolute_cohomology_covariant_les` proof block (currently has `\leanok` on the statement block but the proof block `\leanok` is not present). This is likely handled by `sync_leanok` automatically and may not need manual action.

---

## Severity summary

| Finding | Severity |
|---|---|
| `absoluteCohomologyZeroAddEquiv_naturality` faithfully realizes `lem:absolute_cohomology_zero_natural` — no signature drift, correct realization | **clean** |
| No sorry, no fake bodies, no axioms beyond standard foundations | **clean** |
| 4 private helpers (`homEquiv₀_comp_mk₀`, `freeYonedaHomEquiv_naturality`, `sheafificationHomAddEquiv_naturality`, `jShriekOU_homEquiv_naturality`) have no blueprint block — coverage debt | **minor** |
| Blueprint proof sketches adequate but do not name the 4 intermediate sub-lemmas | **minor** |
| No must-fix-this-iter items | — |

**Overall verdict**: `AbsoluteCohomology.lean` is clean — all 10 public declarations match their blueprint blocks without signature drift or placeholder bodies, `absoluteCohomologyZeroAddEquiv_naturality` faithfully realizes `lem:absolute_cohomology_zero_natural` with standard axioms only, and the sole gap is minor coverage debt from 4 private helper lemmas that the planner should bundle into a new blueprint sub-lemma.
