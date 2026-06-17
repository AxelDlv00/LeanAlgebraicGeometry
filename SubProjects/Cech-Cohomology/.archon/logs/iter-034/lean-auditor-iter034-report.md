# Lean Audit Report

## Slug
iter034

## Iteration
034

## Scope
- files audited: 2 (per directive)
- files skipped (per directive): all other project files — scope restricted by directive to the two prover-touched files

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/AffineSerreVanishing.lean

- **outdated comments**: 1 flagged
- **suspect definitions**: 1 flagged
- **dead-end proofs**: none
- **bad practices**: 2 flagged (Mathlib style linter warnings)
- **excuse-comments**: none
- **notes**:
  - **Line 362–364** — `affineCoverSystem.Cov` definition is semantically wrong relative to its docstring and the intended downstream use. The docstring (line 353) says "admissible coverings `Cov` are the **standard finite covers** `i ↦ D(gᵢ)`," but the actual predicate is `{ c | ∃ n g, c = ⟨ULift (Fin n), fun i => D(g i.down)⟩ }` — ALL finite basic-open families, no spanning/covering condition. The `Cov` set should restrict to families where `D(gᵢ)` cover `Spec R` (i.e., `Ideal.span (Set.range g) = ⊤`). Without this gate, `HasVanishingHigherCech affineCoverSystem F` demands `Ȟᵠ(arbitrary finite D-family, F) = 0` for all `q > 0`. This is FALSE for quasi-coherent sheaves on non-trivial affines: on `Spec k[x,y]`, taking the non-covering family `{D(x), D(y)}`, the Čech complex gives `Ȟ¹ = k[x,x⁻¹,y,y⁻¹]/(k[x,x⁻¹,y] + k[x,y,y⁻¹]) ≠ 0` (the monomial `x⁻¹y⁻¹` is not in the image). Therefore the downstream quasi-coherent seed `affine_cech_vanishing_qcoh` will be **unprovable** with the current Cov. The fix: add `Ideal.span (Set.range g) = ⊤` to the `Cov` predicate; `affine_surj_of_vanishing` already handles the surjectivity via `standard_cover_cofinal` and needs only actual covers from `Cov`. The `injective_acyclic` field is unaffected (uses `injective_cech_acyclicFam`, which is cover-agnostic). Severity: **major**.
  - **Lines 215, 351** — `set_option maxHeartbeats 1600000` and `set_option maxHeartbeats 2000000` without explanatory inline comments. Mathlib style linter fires (`linter.style.maxHeartbeats`). The heartbeat increases are plausible (both proofs involve heavy elaboration of `erw`/`simp` chains over module sheaves), so these are not masking a correctness problem — but a one-line comment explaining the bottleneck is required by linter policy. Severity: **minor**.
  - **Lines 324, 343** — `show` tactic used where the goal is actually changed (not just a readability annotation). Mathlib linter flags these as `change` sites (`linter.style.show`). Severity: **minor**.
  - **Lines 220, 357, 358, 360** — lines exceed the 100-character limit (`linter.style.longLine`). Severity: **minor**.
  - `toSheaf_preservesFiniteColimits` proof (lines 118–139): the sheafification-square route is mathematically sound. Step 1 (the iso `L ⋙ toSheaf ≅ toPresheaf ⋙ presheafToSheaf`) and step 2 (descent via the counit iso) are correctly assembled.
  - `toSheaf_preservesEpimorphisms` (lines 146–152): one-liner from `toSheaf_preservesFiniteColimits` via `WalkingSpan`; sound.
  - `standard_cover_cofinal` (lines 162–211): quasi-compactness of `D(f)` is invoked correctly; the `Finset`-repackaging into `Fin n` is standard; the resulting existential has the intended parse (confirmed via LSP goal at line 199: `⊢ ∃ n g φ, Uf = ⨆ i, D(g i) ∧ ∀ i, D(g i) ≤ W (φ i)`); proof is sound.
  - `affine_injective_acyclic` (lines 74–85): the bridge `hbridge` correctly equates the raw family to `coverOpen` via `coverOpen_affineOpenCoverOfSpan`; `injective_cech_acyclic` is applied without cover-agnostic assumption (works because the bridge identifies the two descriptions). Sound.
  - `affine_surj_of_vanishing` (lines 228–347): logically correct — even though `Cov` doesn't encode covering, the internal usage of `standard_cover_cofinal` always extracts a real covering and uses the Čech vanishing for that cover. The BasisCovSystem.surj_of_vanishing field is therefore discharged correctly. The issue is purely that the **external** Cov is over-large.
  - `affineCoverSystem` (lines 361–378): all three field-proof obligations (`faces_mem`, `surj_of_vanishing`, `injective_acyclic`) are discharged correctly. The structure is a valid `BasisCovSystem` instance. The design flaw is in the Cov definition only.

---

### AlgebraicJacobian/Cohomology/TildeExactness.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Module docstring (lines 11–66): the retraction of "obstruction 2" (old claim: right-exact + mono ⟹ left-exact lemma needed, which doesn't exist) is accurate. `tildePreservesFiniteLimits_of_toPresheaf` uses `Limits.preservesFiniteLimits_of_reflects_of_preserves` (confirmed via LSP hover: takes `[PreservesFiniteLimits (F ⋙ G)]` and `[ReflectsFiniteLimits G]`), bypassing the "right-exact + mono" route entirely. The docstring correctly describes this.
  - `tilde_preservesFiniteColimits` (line 83–84): `inferInstance` — claims the adjunction left-adjoint instance is synthesized. No diagnostics; sound.
  - `tilde_toStalk_map_injective` (lines 93–97): one-liner applying `IsLocalizedModule.map_injective`; non-vacuous (injectivity is a real property); sound.
  - `tilde_preservesFiniteLimits_of_preservesKernels` (lines 105–110): the hypothesis `H : ∀ {M N} (f), PreservesLimit (parallelPair f 0) (tilde.functor R)` has exactly the type of the `[∀ {X Y} (f), PreservesLimit (parallelPair f 0) F]` instance required by `Functor.preservesFiniteLimits_of_preservesKernels` (confirmed via LSP hover). Lean 4's instance synthesis uses local hypotheses of the matching instance type, so `H` IS consumed; no unused-variable warning appears in diagnostics (zero diagnostics on this file). The theorem is a genuine reduction: it is non-trivially conditional on `H` and is not vacuously proved.
  - `tilde_stalkFunctor_map_toStalk` (lines 120–142): the germ-naturality identity is **non-vacuous** — it equates two specific maps on a concrete stalk element `m : M`. The proof route (`stalkFunctor_map_germ_apply` + `StructureSheaf.comapₗ_const`) is genuine; the `erw` and `congr 1` steps are correct applications of definitional unfolding. Sound.
  - `tildePreservesFiniteLimits_of_toPresheaf` (lines 153–160): the proof `haveI := H; Limits.preservesFiniteLimits_of_reflects_of_preserves (tilde.functor R) (Scheme.Modules.toPresheaf ...)` is a correct one-liner — Lean provides `ReflectsFiniteLimits (Scheme.Modules.toPresheaf ...)` as a synthesized instance. The informal justification in the docstring ("faithful + preserves limits + reflects isos ⟹ reflects finite limits") is a standard category-theory argument for why the instance should exist; the Lean proof relies on Mathlib having registered this instance, which it does. No inaccuracy.
  - Minor formatting: the docstring has two separate "## What is delivered (axiom-clean)" sections (lines 22 and 32) where the second could be a continuation of the first. Not an error.
  - The note "The `ModuleCat R`-valued stalk path is dead (Mathlib privacy of `toStalkₗ'`, `stalkIsoₗ`, `stalkToLocalizationₗ`, `structurePresheafInModuleCat`); use the public `Ab` path throughout." is accurate guidance and consistent with what the proof of `tilde_stalkFunctor_map_toStalk` actually does (`StructureSheaf.toOpenₗ` and `comapₗ_const`).

---

## Must-fix-this-iter

None. The four declarations in `AffineSerreVanishing.lean` are axiom-clean and compile without sorry. The design flaw in `Cov` does not corrupt any currently-proved result; it will block the future quasi-coherent seed, but that seed is explicitly gated on Lane 2 and is not this iteration's target.

---

## Major

- `AffineSerreVanishing.lean:362` — `affineCoverSystem.Cov` is missing the covering condition `Ideal.span (Set.range g) = ⊤`. The docstring says "standard finite covers" but the definition is ALL finite basic-open families. `HasVanishingHigherCech affineCoverSystem F` then requires `Ȟᵠ(any finite D-family, F) = 0`, which is false for quasi-coherent sheaves (e.g., `Ȟ¹({D(x),D(y)}, O_{Spec k[x,y]}) ≠ 0`). The quasi-coherent seed `affine_cech_vanishing_qcoh` will be unprovable. Fix: add `Ideal.span (Set.range g) = ⊤` (or the topological equivalent `⨆ i, D(g i) = ⊤`) to the Cov predicate; no change to the field proofs is needed since `injective_cech_acyclicFam` is already cover-agnostic.

---

## Minor

- `AffineSerreVanishing.lean:215` — `set_option maxHeartbeats 1600000` missing inline comment (`linter.style.maxHeartbeats`).
- `AffineSerreVanishing.lean:351` — `set_option maxHeartbeats 2000000` missing inline comment (`linter.style.maxHeartbeats`).
- `AffineSerreVanishing.lean:324` — `show` should be `change` (`linter.style.show`).
- `AffineSerreVanishing.lean:343` — `show` should be `change` (`linter.style.show`).
- `AffineSerreVanishing.lean:220,357,358,360` — lines exceed 100-character limit (`linter.style.longLine`).

---

## Excuse-comments (always called out separately)

None in either file.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 — `affineCoverSystem.Cov` missing covering condition; blocks the quasi-coherent seed
- **minor**: 5 — Mathlib style linter violations (maxHeartbeats without comment × 2, `show` vs `change` × 2, long lines × 1 count as 4, but sharing the long-line bucket)
- **excuse-comments**: 0

Overall verdict: `TildeExactness.lean` is clean and its two new declarations are sound and non-vacuous; `AffineSerreVanishing.lean` compiles correctly but carries a major design flaw in `affineCoverSystem.Cov` — the missing covering condition will make the quasi-coherent seed unprovable and should be corrected before that lane begins.
