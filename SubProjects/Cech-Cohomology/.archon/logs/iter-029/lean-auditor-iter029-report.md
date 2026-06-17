# Lean Audit Report

## Slug
iter029

## Iteration
029

## Scope
- files audited: 2 (per directive — focused audit of the two new files)
- files skipped (per directive): all other project `.lean` files — directive limits scope to the two new files this iteration

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (orphaned from root import)
- **excuse-comments**: none
- **notes**:
  - **axiom check**: all 3 declarations (`affine_faces_mem`, `coverOpen_affineOpenCoverOfSpan`, `affine_injective_acyclic`) axiom-clean — only `propext`, `Classical.choice`, `Quot.sound`. No `sorry`, no unauthorised axioms.
  - **`affine_faces_mem` (line 37–41)**: genuine one-line proof. Witness is `∏ k, s (σ k)`, using `(basicOpen_sprod (p+1) s σ).symm`. `basicOpen_sprod` is defined in `CechAcyclic.lean` (reached via the import chain `AffineSerreVanishing → CechToCohomology → CechBridge → CechAcyclic`). Statement correctly asserts the `(p+1)`-fold intersection of basic opens is again a basic open (of the product element). Non-vacuous and correct.
  - **`coverOpen_affineOpenCoverOfSpan` (line 53–62)**: genuine proof. Uses two `change` steps that rely on the definitional expansion of `coverOpen` (= `.opensRange` by definition in `FreePresheafComplex.lean:129`) and `affineOpenCoverOfSpanRangeEqTop.openCover.f i` (definitionally `Spec.map (CommRingCat.ofHom (algebraMap R (Localization.Away (s i))))`). After `Opens.ext` and `Spec.map_base`, closes with `PrimeSpectrum.localization_away_comap_range` (Mathlib). The `change` steps are mildly fragile (would break on upstream Mathlib refactors), but this is unavoidable given the mismatch between the definitional form and the goal; no better alternative exists short of an upstream simp lemma. LSP reports no errors.
  - **`affine_injective_acyclic` (line 74–85)**: genuine proof. Scope restriction `hs : Ideal.span (Set.range s) = ⊤` (spanning family — covering the whole affine) is **explicitly and honestly disclosed** in both the docstring ("For a spanning family `s : ι → R` (so the distinguished opens `D(s_i)` cover `Spec R`)") and the module header ("discharging the `BasisCovSystem.injective_acyclic` field for **standard covers of the whole affine**"). No hidden weakening: the proof correctly rewrites the raw family `fun i => PrimeSpectrum.basicOpen (s i)` to `coverOpen 𝒰` via `hbridge`, then applies the general `injective_cech_acyclic`. The `hs` hypothesis is used only to form the cover via `Scheme.affineOpenCoverOfSpanRangeEqTop s hs`.
  - **Scope mismatch vs `BasisCovSystem.injective_acyclic`**: The `BasisCovSystem.injective_acyclic` field (in `CechToCohomology.lean`) requires acyclicity for all `c ∈ Cov`. If the affine `BasisCovSystem` instance (not yet assembled) includes coverings of arbitrary basic opens `D(f)` (not just the whole `Spec R`), then `affine_injective_acyclic` alone would not discharge the full field. However, this is a downstream concern for the assembly step: (a) the file explicitly defers assembly to the next iteration ("handed off to the assembly iteration"); (b) the general `injective_cech_acyclic` (CechBridge.lean) can cover arbitrary open covers of `D(f)` without this lemma; (c) `affine_injective_acyclic` is correctly self-described as an instantiation for the specific full-affine parameterized family.
  - **Docstring imprecision (line 35)**: `affine_faces_mem` docstring says "Project-local: re-export of `basicOpen_sprod`". The word "re-export" is slightly misleading — it is an application of `basicOpen_sprod` packaged in the shape `BasisCovSystem.faces_mem` consumes, not a re-export (no alias or `export` declaration). Trivially inaccurate but not harmful.
  - **Orphaned file (major)**: `AffineSerreVanishing.lean` is not listed in `AlgebraicJacobian.lean`. It will not be compiled by `lake build` in the default build path. (This is a known pending step per project state; flagged for completeness.)

---

### AlgebraicJacobian/Cohomology/QcohTildeSections.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 2 flagged (orphaned from root import; `import Mathlib` whole-library import)
- **excuse-comments**: none
- **notes**:
  - **axiom check**: all 4 declarations (`qcoh_iso_tilde_sections`, `qcoh_iso_tilde_sections_of_presentation`, `qcoh_iso_tilde_sections_hom`, `qcoh_iso_tilde_sections_inv`) axiom-clean — only `propext`, `Classical.choice`, `Quot.sound`. No `sorry`.
  - **`qcoh_iso_tilde_sections` (line 62–64)**: honest conditional form. `[IsIso F.fromTildeΓ]` is a genuine non-vacuous hypothesis — it is the counit-is-isomorphism condition that the file explicitly says is not yet derivable from `[IsQuasicoherent F]` in Mathlib. The proof `(asIso F.fromTildeΓ).symm` is correct: `F.fromTildeΓ : tilde (Γ F) ⟶ F`, so `asIso F.fromTildeΓ : tilde (Γ F) ≅ F` (via the `IsIso` instance), and `.symm : F ≅ tilde (Γ F)`. The declared return type `F ≅ tilde (moduleSpecΓFunctor.obj F)` matches because `moduleSpecΓFunctor.obj F` is definitionally `(modulesSpecToSheaf.obj F).presheaf.obj (Opposite.op ⊤)` (confirmed via hover: `asIso F.fromTildeΓ` has type `tilde ((modulesSpecToSheaf.obj F).presheaf.obj (Opposite.op ⊤)) ≅ F`). Lean accepts the body without `change` or coercion, confirming definitional equality.
  - **`qcoh_iso_tilde_sections_of_presentation` (line 71–74)**: correct discharge of the `IsIso` hypothesis via `isIso_fromTildeΓ_of_presentation` (Mathlib). Non-vacuous: requires an actual `F.Presentation` argument, not a tautology.
  - **`_hom` and `_inv` simp lemmas (lines 78–85)**: `:= rfl` proofs are genuine definitional equalities. `(asIso h).symm.hom = (asIso h).inv = inv h` (by `Iso.symm_hom`), and `(asIso h).symm.inv = (asIso h).hom = h` (by `Iso.symm_inv`). Both hold by `rfl` because `asIso` and `Iso.symm` unfold definitionally. Not a non-trivial claim dressed as `rfl`.
  - **Gap disclosure (lines 26–43 and `## Handoff`)**: thorough and accurate. The module header explicitly names the gap (`[IsQuasicoherent F] → IsIso F.fromTildeΓ` not in Mathlib), correctly locates it in the 01I8 affine equivalence, and explains *why* it is not yet available (local presentation data from `QuasicoherentData` vs. global presentation needed for the tilde essential image). The `## Handoff` section correctly decomposes the remaining work into 3 sub-steps (global generation from IsQuasicoherent → kernel quasi-coherent → presentation → `isIso_fromTildeΓ_of_presentation`). The step-1 description ("compactness of `Spec R` and localisation-of-sections property") is mathematically accurate.
  - **`import Mathlib` (line 6)**: whole-library import for a 4-declaration file whose only Mathlib dependency is `Mathlib.AlgebraicGeometry.Modules.Tilde` (plus `CategoryTheory` basics). This is unnecessary build cost: every file importing `QcohTildeSections.lean` will trigger a full Mathlib recompilation. Should be narrowed to `import Mathlib.AlgebraicGeometry.Modules.Tilde` (and whatever `asIso`, `IsIso` imports that pulls in). Flagged minor since the file is currently orphaned (so no downstream build-cost is incurred yet), but must be fixed before wiring into the root import.
  - **Orphaned file (major)**: `QcohTildeSections.lean` is not listed in `AlgebraicJacobian.lean`. Not compiled by `lake build`. (Known pending step; the `import Mathlib` narrowing should happen before the root import is added.)

---

## Must-fix-this-iter

None. No excuse-comments, no `sorry`, no weakened definitions, no unauthorized axioms, no suspect bodies on substantive claims.

---

## Major

- `AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean` — **orphaned file**: not listed in `AlgebraicJacobian.lean`; excluded from `lake build`. Must be added to root imports before assembly iteration can proceed.
- `AlgebraicJacobian/Cohomology/QcohTildeSections.lean` — **orphaned file**: not listed in `AlgebraicJacobian.lean`; excluded from `lake build`. Must be added (after narrowing `import Mathlib`).

---

## Minor

- `AffineSerreVanishing.lean:35` — docstring for `affine_faces_mem` says "re-export of `basicOpen_sprod`"; correct word is "application" or "packaging" (no Lean `export` or alias occurs).
- `AffineSerreVanishing.lean:57–60` — `change` steps in `coverOpen_affineOpenCoverOfSpan` are fragile to upstream Mathlib refactors of `Scheme.affineOpenCoverOfSpanRangeEqTop`. Acceptable for now; worth a note if Mathlib updates break it.
- `QcohTildeSections.lean:6` — `import Mathlib` (full library) for a 4-declaration file. Should be narrowed to `import Mathlib.AlgebraicGeometry.Modules.Tilde` before the file enters the root import graph, to avoid propagating full-Mathlib build cost to all downstream files.

---

## Excuse-comments (always called out separately)

None found in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (both are orphaned-file issues, known pending root-import additions)
- **minor**: 3 (docstring imprecision ×1, change fragility ×1, import Mathlib ×1)
- **excuse-comments**: 0

Overall verdict: Both files are mathematically honest, axiom-clean, and correctly scoped; the two orphaned-file findings are known pending tasks (add root imports), and the `import Mathlib` in `QcohTildeSections.lean` should be narrowed before that file is wired in.
