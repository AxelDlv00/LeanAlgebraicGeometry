# Lean Audit Report

## Slug
iter055

## Iteration
055

## Scope
- files audited: 3
- files skipped (per directive): 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechSectionIdentification.lean

- **outdated comments**: none
- **suspect definitions**: none (all 6 stubs are `sorry`-only; mathematically reasonable)
- **dead-end proofs**: none (all are scaffolded sorries, not dead-end attempts)
- **bad practices**: 1 flagged (see notes)
- **excuse-comments**: none
- **notes**:
  - **Build state: DOES NOT COMPILE.** LSP reports `success: false` with the following errors:
    1. **Line 37, col 28 — `unknown namespace 'Scheme.Modules'`.**
       Root cause: `open CategoryTheory Limits Scheme.Modules Opposite` is at the TOP LEVEL
       (before `namespace AlgebraicGeometry` on line 39). The namespace
       `AlgebraicGeometry.Scheme.Modules` only resolves INSIDE `namespace AlgebraicGeometry`.
       Sibling files (`OpenImmersionPushforward.lean`, `CechAugmentedResolution.lean`) put
       `open Scheme.Modules` AFTER their `namespace AlgebraicGeometry` declaration and compile
       without this error. Fix: move `open Scheme.Modules` to after line 39.
    2. **Lines 77 and 164 — `Unknown identifier 'Over.mk'`.**
       `CategoryTheory.Over.mk` should be in scope after `open CategoryTheory`, but the error
       may be caused by the preceding namespace error partially degrading the elaboration
       context, or by `Over.mk` needing an explicit import that the current imports don't
       provide. Since no other file in the project uses `Over.mk` in a type position, this
       needs investigation beyond the namespace fix to confirm it is not a deeper API name
       mismatch. Not a deeper type error in the mathematical content.
    3. **Line 126, col 54 — `unexpected token ':='; expected ','`.**
       Stub 2 (`pushPull_sigma_iso`) uses `∏ fun σ =>` (mathematical `∏`) at line 125.
       Stub 4 (`pushPull_eval_prod_iso`) correctly uses `∏ᶜ fun σ =>` at line 203 (and
       compiles). One-character fix: change `∏` to `∏ᶜ`.
    4. **Lines 258–259 — `Unknown identifier 'evaluation'` and cascading
       `failed to synthesize GV.PreservesZeroMorphisms`.**
       These are cascade errors from the earlier failures. The identical construction
       `PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙ (evaluation ...).obj (op V)`
       elaborates without error in CechAugmentedResolution.lean (line 204–205), confirming
       this is a cascade not an intrinsic type error.
  - **Stubs 4 and 6 reach the sorry-warning stage** (LSP lines 197 and 314): their
    signatures are fully well-formed and type-check. Stubs 1, 2, 3, 5 are blocked by the
    errors above, not by deep type issues.
  - **Repairability verdict:** The scaffold is repairable by fixes to opens and notation
    (and possibly one API name: `Over.mk`). All mathematical content of the 6 stubs is
    structurally sound given the blueprint intent encoded in the "Planner strategy" block
    comments.
  - **Line 111 style warning:** over 100 characters, flagged by the style linter. Minor.
  - **No excuse-comments, no weakened definitions, no axioms.**

---

### AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (duplication — see notes)
- **excuse-comments**: none
- **notes**:
  - **Build state: COMPILES.** LSP reports `success: true`. Two `sorry` warnings:
    - Line 250: `higherDirectImage_openImmersion_acyclic` — sorry at line 306
    - Line 348: `higherDirectImage_openImmersion_comp` — sorry at line 372
  - **Subsingleton trap audit (Focus 2):**
    - `isZero_presheafToSheaf_of_sections_locally_zero` (lines 71–102):
      - Line 100: `Subsingleton.elim _ _` on `Z.obj (op V) = AddCommGrpCat.of PUnit`.
        `Z` is the constant-PUnit presheaf; PUnit is a genuine subsingleton. **Sound.**
      - Line 99: `haveI : Subsingleton (Z.obj (op V)) := AddCommGrpCat.subsingleton_of_isZero ...`
        — subsingleton is explicitly derived from `IsZero`. Not a bare/auto invocation. **Sound.**
    - Sieve proof in `higherDirectImage_openImmersion_acyclic` (lines 325–331):
      - Line 327: `haveI : Subsingleton (ToType (Q.obj (Opposite.op A))) :=
        AddCommGrpCat.subsingleton_of_isZero (hSec A hA)` — explicit derivation from `IsZero`.
      - Line 331: `Subsingleton.elim (...) 0` — term form with a concrete witness; not bare
        `ext`. **Sound.**
      - Line 329: `congr 1` on goal `g.op = (homOfLE hAU).op ≫ (homOfLE hVA).op` (after
        `rw [← op_comp]`), which reduces to `g = homOfLE hAU ≫ homOfLE hVA` in the poset
        `Opens X`. In the thin poset category, there is at most one morphism between any two
        objects, so `congr 1` + definitional equality closes correctly. **Sound.**
    - No bare `ext`-on-subsingleton-morphism trap found anywhere in the file.
  - **New completed decls (Focus 3):**
    - `jShriekOU_homEquiv_nat` (private, line 122): non-vacuous; unpacks adjunction
      naturality through three explicit rewrite steps. No `Classical.choice`. **Sound.**
    - `toPresheafOfModules_additive` (line 137): one-line `inferInstanceAs` redirection
      to the composite instance. **Sound.**
    - `sectionsFunctor_additive` (line 144): explicit two-level `instAdditiveComp` chain
      (`haveI i2` + final `exact`). Correct pattern matching the known 5-fold additivity
      trap documented in project history. **Sound.**
    - `sectionsFunctorCorepIso` (line 156): `NatIso.ofComponents` with explicit naturality
      proof using `jShriekOU_homEquiv_nat` and `AddEquiv.apply_symm_apply`. Non-vacuous.
      No `Classical.choice`. **Sound.**
    - `rightDerivedNatIso` (line 174): standard `Iso` construction from
      `NatTrans.rightDerived_comp` + `NatTrans.rightDerived_id`. Non-vacuous.
      No `Classical.choice`. **Sound.**
    - `isAffineHom_of_affine_separated` (private, line 208): `IsAffineHom.of_comp` + a
      `terminal.hom_ext` rewrite. Correct. **Sound.**
    - `pushforwardSectionsFunctor` (line 221): definition only; sound.
    - `pushforwardSectionsFunctor_additive` (line 228): explicit 5-fold chain with the tail
      instance passed via `@CategoryTheory.Functor.instAdditiveComp ... i2`. Matches the
      known project pattern. **Sound.**
  - **Residual sorry at line 306 (Focus 4):**
    Actual goal: `⊢ IsZero (((preadditiveCoyoneda.obj (op (jShriekOU (j ⁻¹ᵁ W)))).rightDerived q).obj H)`
    This is the vanishing of `Rᵠ Hom(jShriekOU(j⁻¹W), -)` at `H` for `q ≥ 1`. Exactly
    matches the documented intent (Bridge 1/2 remainder: Hom-complex identification to
    `Ext^q(jShriekOU, H)` plus Serre vanishing). **Honest residual.**
  - **Residual sorry at line 372 (Focus 4):**
    Actual goal: `⊢ higherDirectImage f k ((pushforward j).obj H) ≅ higherDirectImage (j ≫ f) k H`
    This is the full statement of the pinned declaration. The sorry covers the acyclic
    resolution assembly (both exactness of `j_*I•` and `f_*`-acyclicity of `j_*Iⁿ`).
    **Honest residual.**
  - **Duplication (major):** `isZero_of_faithful_preservesZeroMorphisms` appears both here
    (namespace `CategoryTheory.Functor`, line 42) and in `CechAugmentedResolution.lean`
    (namespace `AlgebraicGeometry`, line 52). The comment explains the reason (import chain
    prevents sharing). This is project-internal duplication, not a Mathlib parallel API.
    The appropriate fix is a shared utilities/supplement file, but it is not urgent.

---

### AlgebraicJacobian/Cohomology/CechAugmentedResolution.lean

- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged (duplication — see OpenImmersionPushforward notes)
- **excuse-comments**: none
- **notes**:
  - **Build state: COMPILES.** LSP reports `success: true`. One `sorry` warning at line 176
    (`cechAugmented_exact`), sorry at line 229.
  - **Subsingleton trap audit (Focus 2):**
    - `isZero_presheafToSheaf_of_locally_isZero` (lines 111–142):
      - Line 132: `Subsingleton.elim _ _` — goal is equality of two elements of
        `Q.obj (op V)`, which is a subsingleton because `IsZero (Q.obj (op V))` was obtained
        via `AddCommGrpCat.subsingleton_of_isZero (hSzero hg)` in the preceding `haveI`.
        Genuine subsingleton. Explicit call. **Sound.**
      - Lines 138–139: `Subsingleton.elim _ _` on `Z.obj (op V) = AddCommGrpCat.of PUnit`.
        PUnit is a genuine subsingleton. **Sound.**
    - No bare `ext`-on-subsingleton-morphism trap found.
  - **`isZero_homology_of_iso_homotopy_id_zero` (Focus 3, lines 89–94):**
    The `IsZero.of_iso` direction was confirmed via hover:
    `IsZero.of_iso (hY : IsZero Y) (e : X ≅ Y) : IsZero X` — backward transport.
    Applied here:
    - `hY = isZero_homology_of_homotopy_id_zero D' p ho : IsZero (D'.homology p)` → Y = D'.homology p
    - `e = (homologyFunctor C c p).mapIso e : D.homology p ≅ D'.homology p` → X = D.homology p
    - Result: `IsZero (D.homology p)` ✓ — matches the stated conclusion.
    Non-vacuous. No `Classical.choice`. **Sound.**
  - **`isZero_homology_of_homotopy_id_zero` (lines 76–80):** uses
    `ho.homologyMap_eq p` + `homologyMap_id` + `homologyMap_zero` + `IsZero.iff_id_eq_zero`.
    Standard homotopy-invariance chain. Non-vacuous. **Sound.**
  - **`isZero_presheafToSheaf_of_locally_isZero` (lines 111–142):**
    Constructs `IsLocallyInjective` and `IsLocallySurjective` for `0 : Q ⟶ Z` then applies
    `isZero_presheafToSheaf_obj_of_isLocallyBijective`. Non-vacuous. **Sound.**
  - **Residual sorry at line 229 (Focus 4):**
    Actual goal:
    `⊢ Homotopy (𝟙 ((GV.mapHomologicalComplex cc).obj Kp)) 0`
    Context has all of: `𝒰`, `F`, `V`, `i : 𝒰.I₀`, `hiV : V ≤ coverOpen 𝒰 i`, and the
    fully elaborated `GV`, `Kp`. Exactly the "Sub-brick A" contracting homotopy on the
    evaluated augmented Čech section complex documented in the inline comment (lines
    215–227). The comment correctly identifies that this is discharged by
    `isZero_homology_of_iso_homotopy_id_zero (cechSection_complex_iso ...) p
    (cechSection_contractible ...)` once CechSectionIdentification.lean compiles.
    **Honest residual.** Not a papered/weakened stand-in.
  - **Comment lines 221–227** notes that CechSectionIdentification.lean has compile errors
    and the import is held back. This is accurate and not an excuse-comment (it describes
    a dependency state, not a correctness failure of THIS file).

---

## Must-fix-this-iter

- `CechSectionIdentification.lean:37` — `open Scheme.Modules` is placed BEFORE
  `namespace AlgebraicGeometry`, causing `unknown namespace 'Scheme.Modules'` (the correct
  name is `AlgebraicGeometry.Scheme.Modules`). This is the root error that cascades into
  the `Over.mk` and `evaluation` failures. **Why must-fix:** the file does not compile;
  it cannot be imported by `CechAugmentedResolution.lean`; the residual sorry at
  `CechAugmentedResolution:229` is explicitly waiting on this file's repair. The cascade
  blocks the entire Sub-brick A chain.

- `CechSectionIdentification.lean:126` — `∏ fun σ : Fin (p + 1) → 𝒰.I₀ =>` in stub 2
  uses the wrong notation `∏` instead of `∏ᶜ`. Stub 4 correctly uses `∏ᶜ` and compiles.
  **Why must-fix:** this is a syntax error that prevents elaboration of `pushPull_sigma_iso`'s
  type entirely; the stub cannot even register as a sorry.

## Major

- `OpenImmersionPushforward.lean:42` and `CechAugmentedResolution.lean:52` — duplicate
  definition of `isZero_of_faithful_preservesZeroMorphisms` in different namespaces
  (`CategoryTheory.Functor` vs `AlgebraicGeometry`). The comment on the
  OpenImmersionPushforward copy documents the import-chain reason. Both are correct, but
  this is project-internal code duplication that will need a shared utilities module.

- `CechSectionIdentification.lean:77,164` — `Unknown identifier 'Over.mk'`. After fixing
  the `open Scheme.Modules` placement (must-fix above), this may resolve automatically.
  If not, it requires investigation of whether `CategoryTheory.Over.mk` is the correct
  constructor name in the current Mathlib version (no other file uses `Over.mk` in a type
  position, so there is no cross-reference to validate against). Must be confirmed as part
  of the line-37 fix.

## Minor

- `CechSectionIdentification.lean:111` — line exceeds 100-char limit (style linter warning).

- `CechAugmentedResolution.lean:221–227` — inline comment accurately describes
  CechSectionIdentification.lean's current broken state. This comment should be removed
  or revised once CechSectionIdentification.lean is repaired and imported.

---

## Excuse-comments (always called out separately)

None found in any of the three files. The inline "Planner strategy" block comments in
CechSectionIdentification.lean are documentation of stub intent, not admissions of
incorrectness. The comment at CechAugmentedResolution.lean:221–227 describes a transient
dependency state accurately.

---

## Severity summary

- **must-fix-this-iter**: 2 — `CechSectionIdentification.lean:37` (wrong `open` placement)
  and `CechSectionIdentification.lean:126` (`∏` → `∏ᶜ`)
- **major**: 2 — duplicate lemma across files; `Over.mk` identity pending verification
- **minor**: 2 — style line length; stale comment once dependency is fixed
- **excuse-comments**: 0

Overall verdict: `CechAugmentedResolution.lean` and `OpenImmersionPushforward.lean` are in
sound shape — all completed declarations are non-vacuous and mathematically correct, no
subsingleton traps, honest sorries under the right goals. `CechSectionIdentification.lean`
does not compile due to two repairable opens/notation errors; fixing these is the only
blocker to closing `CechAugmentedResolution:229`.
