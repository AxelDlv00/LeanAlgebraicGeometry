# Lean Audit Report

## Slug
iter035

## Iteration
035

## Scope
- files audited: 2
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 25: `specBasicOpen` is an extremely thin `abbrev` that directly wraps `PrimeSpectrum.basicOpen f`. It is used locally and harmless, but may cause confusion (two names for the same thing). Minor.
  - Line 33–40: `modulesRestrictBasicOpen` — genuinely constructs the iterated restriction `(F.restrict ι).restrict inv`. Non-vacuous; the definition is meaningful (two Mathlib `restrict` calls chained). Axiom-clean (standard axioms only).
  - Line 42–51: `modulesRestrictBasicOpenIso` — proof body `((restrictFunctorComp g h).app F).symm ≪≫ (restrictFunctorIsoPullback f).app F` correctly assembles the comparison iso: `.symm` flips `pullback(g ≫ h) ≅ restrict h ⋙ restrict g` to give `modulesRestrictBasicOpen ≅ restrict(specAwayToSpec)`, then `restrictFunctorIsoPullback` identifies that with the actual pullback functor. Non-vacuous; iso is a real geometric comparison. Axiom-clean.
  - Lines 33, 42 (docstring header): Both `modulesRestrictBasicOpen` and `modulesRestrictBasicOpenIso` are headed "**Stacks 01I8, `lemma-widetilde-pullback`.**" These declarations are *infrastructure* for that lemma (iterated restriction and its comparison iso), not the lemma itself. The full `lemma-widetilde-pullback` additionally requires quasi-coherence of `F` and tilde-base-change compatibility. The docstring bodies are honest ("project-local: assembles two Mathlib restrictions"), but the opening citation sets an overly strong expectation. MINOR.
  - Lines 56–59: `specAwayToSpec_eq` — proof uses `Iso.inv_comp_eq` + `IsOpenImmersion.isoOfRangeEq_hom_fac`. Genuinely non-trivial: identifies the geometric composite with `Spec.map (algebraMap R R_f)`. Axiom-clean.
  - No `sorry`, no `axiom`, no `opaque`. Diagnostics: zero errors, zero warnings.

---

### AlgebraicJacobian/Cohomology/TildeExactness.lean
- **outdated comments**: 1 flagged (see notes)
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - **`opaque` scanner warnings at lines 37, 117, 208** — all three are the English phrase "otherwise opaque" appearing in docstring prose. No real `opaque` keyword was introduced this iter. This matches the pattern noted in prior iter scans.
  - Line 57: Module docstring "What still has to be built" lists two sub-tasks, (a) and (b). Sub-task **(a) "prove the `Ab` stalk map is `R`-linear … so it equals `IsLocalizedModule.map …`"** is now *delivered* by `tilde_germ_algebraMap_smul` + `stalkMapₗ` + `stalkMapₗ_eq`. The docstring's (a) description is stale and implies work that has been completed. Sub-task (b) (jointly-reflecting stalk family for `∀ x, PreservesFiniteLimits (~ ⋙ toPresheaf ⋙ stalkFunctor x)`) is still open. MINOR — not an excuse-comment (it doesn't excuse wrong code), but it does mislead future readers about what remains.
  - Lines 57–58: The docstring says item (a) should use "`germₗ`". The actual proof bypasses the private `germₗ` and uses `PresheafOfModules.germ_smul` + `StructureSheaf.algebraMap_germ_apply` instead. The approach description in the docstring is therefore also stale. MINOR.
  - Lines 169–177: `tilde_germ_algebraMap_smul` — genuine scalar-compatibility fact. Proof: `erw [PresheafOfModules.germ_smul, StructureSheaf.algebraMap_germ_apply]; rfl`. The final `rfl` is not suspicious — after the two rewrites the remaining goal is a definitional equality between two scalar-multiplication expressions (the `R`-module action on the stalk is via `algebraMap`, so both sides are definitionally equal). Axiom-clean.
  - Lines 185–202: `stalkMapₗ` — packages the `Ab`-stalk map as a genuine `R`-linear map. The key field `map_smul'` is a real R-linearity proof:
    1. Destructs the stalk element `ζ` as a germ `(U, hxU, s)` via `germ_exist`.
    2. Rewrites `r • germ s = germ (algebraMap r • s)` using `tilde_germ_algebraMap_smul`.
    3. Applies `stalkFunctor_map_germ_apply` twice (to LHS germ and RHS germ respectively) to commute the stalk map through germs.
    4. Unfolds via `toPresheaf_map` / `mapPresheaf_app` and closes with `Hom.app_smul` + `tilde_germ_algebraMap_smul`.
    The two `erw [stalkFunctor_map_germ_apply ...]` calls with the same map but different occurrences (LHS vs RHS germ) are standard and non-fragile. Axiom-clean.
  - Lines 210–219: `stalkMapₗ_eq` — identifies `stalkMapₗ f x` with `IsLocalizedModule.map`. Proof applies `IsLocalizedModule.ext` (comparing two linear maps out of the localized module by checking agreement on the image of the localization map `tilde.toStalk M x`), then closes with `tilde_stalkFunctor_map_toStalk f x m`. Non-vacuous: it genuinely equates two a-priori different constructions of the stalk map. Axiom-clean.
  - Lines 226–229: `stalkMapₗ_injective` — direct composition of `stalkMapₗ_eq` and `tilde_toStalk_map_injective`. The proof is short but not trivial: it depends on both of these non-trivially proved lemmas. Not a tautology. Axiom-clean.
  - No `sorry`, no `axiom`, no `opaque`. Diagnostics: zero errors, zero warnings.

---

## Must-fix-this-iter

*(none)*

---

## Major

*(none)*

---

## Minor

- `QcohRestrictBasicOpen.lean:33,42` — Docstrings open with "**Stacks 01I8, `lemma-widetilde-pullback`.**" but the declarations are only infrastructure for that lemma. A reader may interpret these as the full proof of the Stacks lemma. The body text clarifies scope ("project-local: assembles two Mathlib restrictions"), so this is minor, but the header citation is over-claimed.
- `TildeExactness.lean:57–63` — Module docstring sub-task (a) "prove the `Ab` stalk map is `R`-linear … so it equals `IsLocalizedModule.map …`" is now delivered by `stalkMapₗ` and `stalkMapₗ_eq`. The description is stale and should be removed or updated to reflect that (a) is closed and only (b) remains (the jointly-reflecting stalk assembly).
- `TildeExactness.lean:57–58` — Same section says item (a) uses "`germₗ`". The proof instead uses the public `PresheafOfModules.germ_smul`; `germₗ` is never referenced. Minor technical inaccuracy in the docstring approach description.

---

## Excuse-comments (always called out separately)

*(none — no excuse-comments found in either file)*

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: Both files are axiom-clean with no sorry, no opaque, no excuse-comments, and zero compiler diagnostics; all new declarations are genuine and non-vacuous — the only findings are stale docstring fragments in TildeExactness.lean (item (a) of "What still has to be built" is now delivered, and the approach description references a private handle that was bypassed in the actual proof).
