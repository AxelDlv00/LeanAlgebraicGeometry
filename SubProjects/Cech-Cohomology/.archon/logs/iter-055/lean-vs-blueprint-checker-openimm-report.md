# Lean ↔ Blueprint Check Report

## Slug
openimm

## Iteration
055

## Files audited
- Lean: `AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean`
- Blueprint: `blueprint/src/chapters/Cohomology_CechHigherDirectImage.tex`
  (relevant blocks: `lem:open_immersion_pushforward_comp`, `lem:pushforward_sections_functor`,
  `lem:isZero_presheafToSheaf_of_sections_locally_zero`, `lem:isZero_of_faithful_preservesZeroMorphisms`)

---

## Per-declaration

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_acyclic}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 250, `theorem higherDirectImage_openImmersion_acyclic`)
- **Signature matches**: yes — `[IsOpenImmersion j] [IsAffine U] [X.IsSeparated] (H : U.Modules) (hH : H.IsQuasicoherent) (q : ℕ) (hq : 0 < q) : IsZero (higherDirectImage j q H)` matches "R^q j_* H = 0 for all q ≥ 1 and every quasi-coherent O_U-module H"
- **Proof follows sketch**: partial — the outer structure (presheaf-description → reflect via toSheaf → sheafificationCompToSheaf → sectionwise-locally-zero → affine-opens sieve) matches the blueprint proof details. The corepresentability→Ext leaf (line 296–306) is a `sorry`, pending closure.
- **notes**: `sorry` at line 306 makes this a must-fix-this-iter placeholder on a substantive claim. The blueprint proof at lines 8038–8055 describes the corepresentability identification ("j_! O_U ⊣ Γ(U,−)") as a step, but the specific Lean chain (`sectionsFunctorCorepIso` → `rightDerivedNatIso` → Ext-vanishing leaf) is not spelt out in the blueprint sketch.

### `\lean{AlgebraicGeometry.higherDirectImage_openImmersion_comp}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes (line 348, `noncomputable def higherDirectImage_openImmersion_comp`)
- **Signature matches**: yes — `higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H` matches the blueprint `R^k f_*(j_* H) ≅ R^k g_* H`; the re-signing to canonical `A ≅ B` (not `Nonempty`) is correct.
- **Proof follows sketch**: no (body is `:= sorry` at line 372) — entire proof is a placeholder. Blueprint part (2) proof sketch describes the acyclic-resolution comparison route; the Lean comments (lines 355–371) correctly reproduce that route, but none of it is formalized.
- **notes**: must-fix-this-iter. Blocked on `higherDirectImage_openImmersion_acyclic`. No fake statement—signature is clean.

### `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` (chapter: `lem:open_immersion_pushforward_comp`)
- **Lean target exists**: yes, but **private** (line 208: `private lemma isAffineHom_of_affine_separated`)
- **Signature matches**: yes — `(j : U ⟶ X) [IsAffine U] [X.IsSeparated] : IsAffineHom j` matches blueprint "j is an affine morphism"
- **Proof follows sketch**: yes — three-line proof via `IsAffineHom.of_comp` and `terminal.from` is a faithful formalization of the blueprint prose
- **notes**: **major issue** — `private` visibility means `sync_leanok` cannot resolve `AlgebraicGeometry.isAffineHom_of_affine_separated` by its qualified name. The blueprint `\lean{}` pin expects a public declaration. Either the lemma should be made public, or the blueprint pin should be dropped / annotated with a NOTE explaining the private placement (like the `isZero_of_faithful_preservesZeroMorphisms` NOTE at line 7184).

### `\lean{AlgebraicGeometry.pushforwardSectionsFunctor}` + `\lean{AlgebraicGeometry.pushforwardSectionsFunctor_additive}` (chapter: `lem:pushforward_sections_functor`)
- **Lean target exists**: yes — lines 221 and 228 respectively
- **Signature matches**: yes — `pushforwardSectionsFunctor (j : U ⟶ X) (W : Opens X) : U.Modules ⥤ AddCommGrpCat` and `instance pushforwardSectionsFunctor_additive` match the blueprint statement at lines 8083–8088
- **Proof follows sketch**: N/A (definition) / yes (instance proof is an explicit `instAdditiveComp` chain with the 5-fold composite trick; blueprint prose says "composite of additive functors")
- **notes**: clean; the explicit 5-fold `instAdditiveComp` chain (documented in the Lean comments) goes slightly beyond the blueprint's prose, but mathematically correct.

### `\lean{CategoryTheory.GrothendieckTopology.isZero_presheafToSheaf_of_sections_locally_zero}` (chapter: `lem:isZero_presheafToSheaf_of_sections_locally_zero`)
- **Lean target exists**: yes (line 71)
- **Signature matches**: yes — matches blueprint statement at lines 8107–8121
- **Proof follows sketch**: yes — local-injectivity via difference-of-sections argument, local surjectivity free; matches blueprint proof at lines 8123–8131
- **notes**: clean.

### `\lean{CategoryTheory.Functor.isZero_of_faithful_preservesZeroMorphisms}` (chapter: `lem:isZero_of_faithful_preservesZeroMorphisms`)
- **Lean target exists**: yes (line 42)
- **Signature matches**: yes — matches blueprint statement at lines 7189–7192
- **Proof follows sketch**: yes — `IsZero.iff_id_eq_zero` + `map_injective`; matches blueprint proof at lines 7196–7201
- **notes**: blueprint NOTE at line 7184 correctly documents this import-isolation duplicate. Clean.

---

## Red flags

### Placeholder / suspect bodies
- `higherDirectImage_openImmersion_acyclic` at line 306: `:= sorry` — corepresentability→Ext leaf. Blueprint claims a substantive proof.
- `higherDirectImage_openImmersion_comp` at line 372: entire body `:= sorry`. Blueprint claims a substantive proof (acyclic-resolution comparison route).

### Private declarations that blueprint pins as public
- `isAffineHom_of_affine_separated` at line 208: declared `private`, but `\lean{AlgebraicGeometry.isAffineHom_of_affine_separated}` in `lem:open_immersion_pushforward_comp` expects a public declaration. `sync_leanok` will fail to resolve this pin.
- `jShriekOU_homEquiv_nat` at line 122: declared `private`; the blueprint block `lem:absolute_cohomology_zero_natural` (line 3138) lists `AlgebraicGeometry.jShriekOU_homEquiv_naturality` (different name, public). The Lean docstring says this is an import-isolation duplicate of a private declaration in `AbsoluteCohomology.lean`. No blueprint NOTE documenting the duplication (unlike the `isZero_of_faithful` pair). Minor—both copies are private helpers—but there is no blueprint NOTE.

---

## Unreferenced declarations (informational)

The following declarations appear in the Lean file but have **no** `\lean{}` block in the chapter:

| Declaration | Kind | Substantive? |
|---|---|---|
| `toPresheafOfModules_additive` (line 137) | `instance` | Yes — needed for `sectionsFunctor_additive` |
| `sectionsFunctor_additive` (line 144) | `instance` | Yes — needed for `sectionsFunctorCorepIso` |
| `sectionsFunctorCorepIso` (line 156) | `def` | Yes — geometric corepresentability natural iso, key ingredient in `_acyclic` sorry leaf |
| `rightDerivedNatIso` (line 174) | `def` | Yes — categorical transport iso for right derived functors, key ingredient in `_acyclic` sorry leaf |
| `jShriekOU_homEquiv_nat` (line 122) | `private lemma` | Yes (but private import-isolation helper) |

**All four public unreferenced declarations are substantive and should appear in the blueprint.** They are not mere local helpers — `sectionsFunctorCorepIso` and `rightDerivedNatIso` are the critical intermediate steps between the known residual and the sorry leaf, and `toPresheafOfModules_additive` / `sectionsFunctor_additive` are required instances.

---

## Blueprint adequacy for this file

- **Coverage**: 7/12 declarations have a `\lean{}` block. The 4 public unreferenced declarations (`toPresheafOfModules_additive`, `sectionsFunctor_additive`, `sectionsFunctorCorepIso`, `rightDerivedNatIso`) plus the private `jShriekOU_homEquiv_nat` are not tracked. The 4 public ones are substantive; their absence is coverage debt.

- **Proof-sketch depth**: **under-specified** for the `higherDirectImage_openImmersion_acyclic` sorry leaf. The blueprint proof details (lines 8038–8055) describe the corepresentability step as:
  > "Taking X = j_! O_{f⁻¹(V)} and Y = G, the degree-k Hom group … is identified with Γ(f⁻¹(V), I^k) by the corepresentability j_! O_U ⊣ Γ(U,−)…"
  This is the right high-level idea, but gives no indication of the specific sequence `sectionsFunctorCorepIso` (functorial upgrade of `jShriekOU_homEquiv`) → `rightDerivedNatIso` (transport of right derived functors along the NatIso) → the Ext-vanishing leaf. A prover working purely from this sketch would need to invent those two intermediate declarations independently. The sorry leaf itself (coyoneda→Ext + Serre on affine j⁻¹W) is mentioned conceptually but not broken into the two subpieces (homological algebra identification + change-of-scheme transport).

- **Hint precision**: **loose** for the sorry-leaf path. `lem:ext_homcomplex_mathlib` is cited in `\uses{}` but the two bridge declarations (`sectionsFunctorCorepIso`, `rightDerivedNatIso`) needed to reach the Ext formulation are not mentioned.

- **Generality**: matches need for the formalized parts; the gap is coverage, not generality.

- **Recommended chapter-side actions**:
  1. Add dedicated `\lean{}` blocks (within `lem:open_immersion_pushforward_comp` or as separate helper lemmas) for `sectionsFunctorCorepIso`, `rightDerivedNatIso`, `toPresheafOfModules_additive`, and `sectionsFunctor_additive`.
  2. Expand the blueprint proof sketch for the `_acyclic` sorry leaf to spell out the two-step bridge: (a) `sectionsFunctorCorepIso` identifies `Γ(j⁻¹W,-)` with `preadditiveCoyoneda.obj (op (jShriekOU (j⁻¹W)))` as additive functors; (b) `rightDerivedNatIso` transports the right derived functor along this NatIso; (c) then the Ext-vanishing + change-of-scheme Serre leaf.
  3. Either make `isAffineHom_of_affine_separated` public (so `sync_leanok` can resolve `AlgebraicGeometry.isAffineHom_of_affine_separated`), or add a blueprint NOTE explaining the private placement (analogous to the `isZero_of_faithful_preservesZeroMorphisms` NOTE at line 7184).
  4. Add a blueprint NOTE for `jShriekOU_homEquiv_nat` as an import-isolation private duplicate (analogous to the existing NOTE pattern).

---

## Severity summary

| Finding | Severity |
|---|---|
| `higherDirectImage_openImmersion_acyclic` sorry at line 306 | **must-fix-this-iter** |
| `higherDirectImage_openImmersion_comp` sorry at line 372 | **must-fix-this-iter** |
| `isAffineHom_of_affine_separated` private but blueprint pins it public | **major** |
| 4 unreferenced public substantive declarations (no `\lean{}` blocks) | **major** (coverage debt) |
| Blueprint proof sketch under-specified for sorry leaf | **major** |
| `jShriekOU_homEquiv_nat` private/name drift, no blueprint NOTE | **minor** |

**Overall verdict**: The Lean file's statement signatures are clean and faithful to the blueprint; the two active residuals (`_acyclic` line 306, `_comp` line 372) are genuine open sorries on substantive claims that must be closed this iteration. Four new corepresentability declarations added this iter (`sectionsFunctorCorepIso`, `rightDerivedNatIso`, `toPresheafOfModules_additive`, `sectionsFunctor_additive`) are untracked by the blueprint — a coverage debt that should be addressed before the sorry leaf can be closed cleanly. — 12 declarations checked, 6 red flags (2 must-fix, 4 major/minor).
