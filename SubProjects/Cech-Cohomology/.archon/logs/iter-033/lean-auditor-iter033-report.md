# Lean Audit Report

## Slug
iter033

## Iteration
033

## Scope
- files audited: 1 (directive specified a single new file; scope is this file only)
- files skipped (per directive): all other project `.lean` files — directive narrows scope to `TildeExactness.lean` for this iter

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/TildeExactness.lean`

- **outdated comments**: 1 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 0 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: 0 flagged

**notes**:

- **Line 74 — `tilde_preservesFiniteColimits := inferInstance`.**  
  `inferInstance` resolves correctly: the chain is `tilde.adjunction ⊣ moduleSpecΓFunctor` → `Adjunction.leftAdjoint_preservesColimits` → `PreservesColimitsOfSize.preservesFiniteColimits`. Verified by: (a) LSP diagnostics for the file are empty; (b) `lean_verify` reports only standard axioms; (c) manually running `example : Limits.PreservesColimits (tilde.functor R) := inferInstance` succeeds and `Adjunction.leftAdjoint_preservesColimits` is the relevant lemma.  The docstring's "left adjoint" justification is accurate. ✓

- **Line 83–87 — `tilde_toStalk_map_injective`.**  
  Application of `IsLocalizedModule.map_injective` is sound. The required `IsLocalizedModule x.asIdeal.primeCompl (tilde.toStalk M x).hom` instance exists via `inferInstance` (verified by standalone snippet). The type signature of `IsLocalizedModule.map_injective` matches what the theorem applies: `Function.Injective ⇑h → Function.Injective ⇑((IsLocalizedModule.map S f g) h)` with `h := f.hom`, `f := (tilde.toStalk M x).hom`, `g := (tilde.toStalk N x).hom`. Clean and sound. ✓  
  The docstring calling this "the flatness core" is a mild overstatement (it is a consequence of localization flatness instantiated via `IsLocalizedModule`, not flatness itself), but not misleading.

- **Line 95–99 — `tilde_preservesFiniteLimits_of_preservesKernels` — `H` is a regular arg `(H : ...)`, not an instance `[H : ...]`.**  
  **Bad practice**: The hypothesis `H : ∀ {M N : ModuleCat R} (f : M ⟶ N), PreservesLimit (parallelPair f 0) (tilde.functor R)` is bound as a regular term argument but the proof body `Functor.preservesFiniteLimits_of_preservesKernels _` relies on Lean 4's local-hypothesis instance synthesis to pick `H` up as the typeclass argument `[∀ {X Y : C} (f : X ⟶ Y), PreservesLimit (parallelPair f 0) F]`. Verified: (a) without `H` in scope the conclusion does not hold (`inferInstance` and `Functor.preservesFiniteLimits_of_preservesKernels _` both fail), so `H` is genuine; (b) the theorem compiles correctly because Lean 4's elaborator finds `H` in the local context during instance synthesis; (c) the additional typeclass prerequisites of `Functor.preservesFiniteLimits_of_preservesKernels` (Preadditive, HasBinaryBiproducts, HasFiniteProducts, HasEqualizers, HasZeroObject for both categories, PreservesZeroMorphisms) all resolve via `inferInstance` independently of `H`. The theorem is mathematically sound but should be written with `[H : ...]` notation to make the local-instance nature of the argument explicit.

- **Lines 31–55 — Module docstring obstruction 2 is inconsistent with the code in the same file.**  
  The docstring (lines 51–54) states: *"The categorical glue is absent from Mathlib. Even granting mono-preservation, there is no Mathlib lemma 'additive + preserves finite colimits (right exact) + preserves monomorphisms ⟹ preserves finite limits (left exact)'. It must be built."*  
  This is **inconsistent with the actual code**: `tilde_preservesFiniteLimits_of_preservesKernels` (line 95–99 of the *same file*) directly applies `Functor.preservesFiniteLimits_of_preservesKernels`, which IS a Mathlib lemma providing exactly the categorical reduction (kernel-preservation ⟹ PreservesFiniteLimits) for additive functors between preadditive categories with the requisite structure.  
  The docstring describes a different route (right-exact + mono ⟹ left-exact) and claims its glue is absent, but the code uses the kernel route whose glue IS present. The file has already circumvented obstruction 2 as written; obstruction 2 no longer exists as a gap. The real remaining obstacle is entirely within obstruction 1 (completing the stalk-map mono identification to conclude `PreservesLimit (parallelPair f 0) (tilde.functor R)` for each `f`).  
  This docstring misleads a planner into believing two gaps remain when there is one. Severity: **major**.

- **Lines 40–50 — Module docstring obstruction 1 (module-private stalk symbols): honest.**  
  Claims `toStalkₗ'`, `stalkIsoₗ`, `stalkToLocalizationₗ`, `structurePresheafInModuleCat` are all module-private in `Mathlib/AlgebraicGeometry/StructureSheaf.lean` and inaccessible downstream. Verified: `#check` on all four fails with "Unknown identifier". ✓

- **Line 55 — Reference to `task_results/AlgebraicJacobian.Cohomology.TildeExactness.md`.**  
  File exists at `.archon/task_results/AlgebraicJacobian.Cohomology.TildeExactness.md`. Reference is valid (minor: the path uses `.` for `/` separator, consistent with Lean namespace notation).

---

## Must-fix-this-iter

None. No sorry, no unauthorized axioms, no excuse-comments, no weakened-wrong definitions.

---

## Major

- `TildeExactness.lean:31–54` — **Module docstring obstruction 2 is false as written.** The docstring says categorical glue (right-exact + mono ⟹ left-exact) is absent from Mathlib and must be built. But the code in lines 95–99 of the same file already uses `Functor.preservesFiniteLimits_of_preservesKernels` (a Mathlib lemma providing the kernel-preservation → finite-limit-preservation reduction). Obstruction 2 as stated is already circumvented; the docstring should be revised to say the only remaining gap is the stalk-map mono identification (obstruction 1). A planner reading the current docstring will overestimate remaining work.

---

## Minor

- `TildeExactness.lean:95` — `H` is bound as `(H : ...)` (regular argument) but acts as a local instance for the typeclass argument of `Functor.preservesFiniteLimits_of_preservesKernels`. The proof body relies implicitly on Lean 4's local-hypothesis instance synthesis. The declaration should use `[H : ...]` notation to make the intent explicit and avoid surprising behavior if the elaborator order changes.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 1 — misleading module docstring claiming categorical glue is absent when the code already uses the Mathlib kernel-route lemma
- **minor**: 1 — `(H : ...)` vs `[H : ...]` instance notation style
- **excuse-comments**: 0

**Overall verdict**: The three declarations are all axiom-clean with standard axioms only, and the `inferInstance` / `IsLocalizedModule.map_injective` applications are sound; however the module docstring's second obstruction is directly contradicted by the code in the same file and should be revised to reflect that only one gap remains.
