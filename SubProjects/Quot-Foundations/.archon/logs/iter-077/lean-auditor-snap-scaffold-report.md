# Lean Audit Report

## Slug
snap-scaffold

## Iteration
077

## Scope
- files audited: 1 (focused scope per directive)
- files skipped: 0

---

## Per-file checklist

### `AlgebraicJacobian/Picard/SectionGradedRing.lean`

Audit focused on the two new scaffold declarations at L1604 and L1677 plus their surrounding strategy comments.

- **outdated comments**: 0 flagged
- **suspect definitions**: 0 flagged
- **dead-end proofs**: 1 flagged (step (b) of `tensorPowAdd` — implementation gap for left-whiskering at sheaf level)
- **bad practices**: 0 flagged
- **excuse-comments**: 0 flagged
- **notes**:

  **`tensorObjAssoc` (L1604)**

  - Signature `tensorObj (tensorObj A B) C ≅ tensorObj A (tensorObj B C)` with `A B C : X.Modules` is correctly typed (LSP: only sorry warning, no errors). Non-trivial and faithful. ✓
  - All strategy lemma references are real:
    - `isIso_sheafification_whiskerRight_unit` → L1535, axiom-clean ✓
    - `sheafification.mapIso` → standard Functor method ✓
    - `MonoidalCategory.associator (C := MonoidalPresheaf X)` → Mathlib ✓
    - `BraidedCategory.braiding (C := MonoidalPresheaf X)` → Mathlib ✓
  - **IsDefEq risk: LOW.** Filling the sorry requires unfolding `tensorObj` (a `noncomputable def`), but this involves only transparent `def`-level reduction — NOT quotient modules, `iSup`, or `M⧸p`-coercions that trigger the known `X.Modules` elaborator pathology.
  - **Minor issue — segment 3 whiskerLeft detour (L1575–1577):** Strategy says "Alternatively, use `MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X) a` version if it exists." No `isIso_sheafification_whiskerLeft_unit` exists in-file. The braiding-conjugation route (3-step: `braidPsh(a, b⊗c)` → `isIso_whiskerRight_unit (b⊗c) a` → `braidPsh((b⊗c)^#, a)`) is the ONLY route and is correct. The "if it exists" hedge is honest but could cause prover detour. Flag: **minor**.
  - Carrier idiom checklist is accurate and matches in-file patterns. ✓

  **`tensorPowAdd` (L1677)**

  - Signature `tensorObj (tensorPow L m) (tensorPow L m') ≅ tensorPow L (m + m')` is correctly typed (LSP: only sorry warning). Non-trivial and faithful. ✓
  - All strategy lemma references are real in-file:
    - `tensorPow_zero`, `tensorPow_succ` → L110/112, `@[simp] private`, `rfl`-transparent ✓
    - `tensorObjUnitIso` → L146, axiom-clean ✓
    - `tensorObjAssoc` → L1604, **currently sorry** (dependency ordering concern, see below)
    - `tensorBraiding` → L170, axiom-clean ✓
  - **IsDefEq risk: LOW** for the same reason as `tensorObjAssoc`. `tensorPow_succ` is `rfl`-transparent so induction case boundaries are isDefEq-clean.
  - **Major issue — step (b) implementation gap (L1625–1631):** The strategy says the braiding `tensorBraiding L (tensorPow L m')` should be "whiskered to act on the right factor of tensorPow L k" but gives no implementation for how to left-whisker at the sheaf level (no `whiskerLeft` on `X.Modules`). After step (a) the goal is `tensorObj (tensorPow L k) (tensorObj L (tensorPow L m')) ≅ tensorObj (tensorPow L k) (tensorObj (tensorPow L m') L)`, which requires the same presheaf-level construction as step (d): build an `Iso.mk` using `sheafification.map (MonoidalCategory.whiskerLeft (C := MonoidalPresheaf X) ((toPresheafOfModules X).obj (tensorPow L k)) ((toPresheafOfModules X).map (tensorBraiding L (tensorPow L m')).hom/inv))`. The strategy details step (d) but omits this same pattern for step (b). Flag: **major**.
  - **Major issue — `toPresheaf L` typo in strategy (L1649):** The pseudocode reads `sheafification.map (whiskerRight ((toPresheafOfModules X).map IH.hom) (toPresheaf L))`. `toPresheaf L` is not valid Lean — `PresheafOfModules.toPresheaf X.ringCatSheaf.obj` is the **abelian-group** presheaf forgetful functor (to `(Opens X)ᵒᵖ ⥤ Ab`), not a presheaf-of-modules object. The `whiskerRight` in `MonoidalPresheaf X` requires an argument in `X.PresheafOfModules`; the correct expression is `(toPresheafOfModules X).obj L`. Using `toPresheaf L` will produce a type mismatch. Flag: **major**.
  - **Minor issue — sorry dependency ordering (L1677):** `tensorPowAdd` calls `tensorObjAssoc` (steps a, c) which is itself sorry. When `tensorPowAdd` is filled, `tensorObjAssoc` must be filled first; otherwise the proof chain retains a sorry dependency that propagates through the SNAP ladder. This is an expected scaffold ordering constraint but should be explicit in the plan. Flag: **minor**.

---

## Must-fix-this-iter

None. Both scaffold definitions are `sorry`-bodied with correct signatures; no wrong definitions, no excuse-comments, no unauthorized axioms.

---

## Major

- `SectionGradedRing.lean:1625–1631` — **`tensorPowAdd` step (b) construction underdescribed.** Strategy says the braiding should be "whiskered to act on the right factor" but does not provide the sheaf-level implementation (analogous to step (d)'s `(toPresheafOfModules X).map`-based `Iso.mk` construction). A prover not already familiar with step (d) will be blocked here.
- `SectionGradedRing.lean:1649` — **`toPresheaf L` in strategy pseudocode is wrong Lean.** `PresheafOfModules.toPresheaf X.ringCatSheaf.obj` is the abelian-group forgetful functor; using it as a `whiskerRight` argument in `MonoidalPresheaf X` produces a type mismatch. Should be `(toPresheafOfModules X).obj L`.

---

## Minor

- `SectionGradedRing.lean:1575–1577` — Strategy for `tensorObjAssoc` segment 3 mentions a non-existent `isIso_sheafification_whiskerLeft_unit` as an "if it exists" alternative. No such declaration is in-file. Braiding-conjugation route is the only option; the conditional note risks a prover detour. Recommend: either remove the alternative note or replace with "no whiskerLeft variant exists in-file; use braiding conjugation."
- `SectionGradedRing.lean:1677` — `tensorPowAdd` depends on `tensorObjAssoc` (sorry). Plan should schedule `tensorObjAssoc` first; filling `tensorPowAdd` while `tensorObjAssoc` is sorry propagates sorry in the SNAP chain.

---

## Excuse-comments (always called out separately)

None.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2
- **minor**: 2
- **excuse-comments**: 0

Overall verdict: Both scaffolds are correctly typed and the strategies reference real lemmas, but the `tensorPowAdd` strategy has two major gaps (underdescribed step (b) left-whisker construction and a `toPresheaf L` typo that would cause a type mismatch) that should be corrected before the prover attempts to fill the sorry.
