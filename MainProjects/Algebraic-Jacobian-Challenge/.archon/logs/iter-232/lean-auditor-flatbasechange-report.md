# Lean Audit Report

## Slug
flatbasechange

## Iteration
232

## Scope
- files audited: 1
- files skipped (per directive): 0

---

## Per-file checklist

### `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: none
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - **`pushforwardBaseChangeMap` (lines 76–83) — construction is sound.** LSP hover confirms every intermediate type in the 4-step composite:
    1. `(pushforward f).map (pullbackPushforwardAdjunction g').unit.app F` : `f_*F ⟶ f_*(g'_*(g')^*F)`
    2. `(pushforwardComp g' f).hom.app _` : `f_*(g'_*M) ⟶ (g'≫f)_*M`
    3. `(pushforwardCongr comm).hom.app _` : `(g'≫f)_*M ⟶ (f'≫g)_*M`
    4. `(pushforwardComp f' g).inv.app _` : `(f'≫g)_*M ⟶ g_*(f'_*M)`
    The overall composite has type `f_*F ⟶ g_*(f'_*(g')^*F)`, and `.symm` of `(pullbackPushforwardAdjunction g).homEquiv _ _` then gives the adjoint transpose `g^*(f_*F) ⟶ f'_*((g')^*F)` as intended. No type aliasing or collapsed-identity defects detected.
  - **`affineBaseChange_pushforward_iso` sorry (line 114) — honest.** `rw [Scheme.Modules.Hom.isIso_iff_isIso_app]` is a live Mathlib lemma (`Mathlib/AlgebraicGeometry/Modules/Sheaf.lean`) that genuinely transforms the goal from `IsIso (pushforwardBaseChangeMap …)` to `∀ U, IsIso (Hom.app (pushforwardBaseChangeMap …) U)` (confirmed by LSP goals at lines 97–98). `intro U` then fixes the open. The sorry lands on the correct residual goal `IsIso (Hom.app (pushforwardBaseChangeMap f g f' g' ⋯ F) U)`. The comment block (lines 100–113) accurately identifies the missing Mathlib bridge (affine dictionary for `pushforward`/`pullback` of tilde-modules, and the affine-cover localisation criterion for `SheafOfModules` isos). No preceding fake tactics.
  - **`flatBaseChange_pushforward_isIso` sorry (line 136) — honest bare sorry.** Goal at the sorry site is the unchanged `IsIso (pushforwardBaseChangeMap …)` (no preceding tactics). The comment (lines 127–135) gives a correct proof sketch (Čech complex argument using `affineBaseChange_pushforward_iso` for term-by-term isomorphism + flatness to commute with `H⁰`) and transparently identifies the missing infrastructure (`SheafOfModules` Čech/affine-cover infrastructure). The phrase "deferred to a later iteration" is honest workflow language, not an excuse for wrong code; the theorem statement itself is not wrong.
  - **`import Mathlib` (line 6) — whole-Mathlib import.** This imports all of Mathlib. Common in development, but should be replaced with specific imports (`AlgebraicGeometry.Modules.Sheaf`, `CategoryTheory.Adjunction.Basic`, etc.) before the file is used in a build that compiles from scratch. Minor practice issue.
  - **Docstring correctness.** The module-doc description of `pushforwardBaseChangeMap` (lines 64–74) accurately describes the adjoint-mate construction. The "image under the (g^*, g_*)-adjunction transpose" phrasing matches the `.symm` of `homEquiv`. The step-by-step description `f_*F → f_*(g')_*(g')^*F = (g'≫f)_*(g')^*F = (f'≫g)_*(g')^*F = g_*f'_*(g')^*F` matches the Lean composite exactly.
  - **`IsPullback` argument order (lines 91, 123).** `IsPullback g' f' f g` is used with `g' : X'⟶X`, `f' : X'⟶S'`, `f : X⟶S`, `g : S'⟶S`. Lean's `IsPullback` takes `(fst snd f g)` for a square `fst ≫ f = snd ≫ g`, which maps to `g' ≫ f = f' ≫ g` — consistent with `comm` and `h.w`. Correct.
  - **Author header (line 4).** States `Authors: Christian Merten`, while the git user is `Axel Delaval`. This may reflect authorship attribution to a Mathlib contributor from whom the construction derives. Not a Lean correctness issue, but worth verifying attribution intent.

---

## Must-fix-this-iter

None.

The two sorry sites are honest (one with a real preceding reduction, one as a documented bare placeholder). No definitions are structurally wrong. No excuse-comments are present. No axioms are introduced on non-trivial claims.

---

## Major

- `FlatBaseChange.lean:125–136` — `flatBaseChange_pushforward_isIso` is sorry-bodied on a load-bearing theorem. The sorry is honest but the theorem is the main deliverable of the file. The proof depends on Čech/affine-cover infrastructure that does not yet exist; the correct next action is building `affineBaseChange_pushforward_iso` first (it has a simpler sorry and all the scaffolding is in place).

- `FlatBaseChange.lean:93–114` — `affineBaseChange_pushforward_iso` is sorry-bodied. The honest reduction is present and correct, but the residual `IsIso (Hom.app …)` goal requires the affine dictionary (tilde-module pushforward/pullback on `Spec` = restriction/base-change + affine-cover iso criterion). Neither component appears in the current file or in reachable local declarations (`lean_local_search` returned empty for both needed lemmas). This is the closer dependency.

---

## Minor

- `FlatBaseChange.lean:6` — `import Mathlib` should be replaced with fine-grained imports before production use. Currently necessary for development velocity but imposes full Mathlib rebuild on change.

- `FlatBaseChange.lean:4` — Author attribution `Christian Merten` vs. git user `Axel Delaval`. Verify that attribution is intentional (Mathlib-style attribution to the mathematical source, or mis-copy from a template).

- `FlatBaseChange.lean:113` / `FlatBaseChange.lean:135` — Both sorry comments reference `informal/affineBaseChange_pushforward_iso.md`. Verify that file exists; if it does not, the reference is a dangling pointer and should be created or removed.

---

## Excuse-comments (always called out separately)

None. The "deferred to a later iteration" language at line 127 documents an intentional sorry in a formalization project; it is not an admission that the theorem statement or surrounding definition is wrong.

---

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 2 (both sorry-bodied load-bearing theorems, honest scaffolding)
- **minor**: 3 (import style, author attribution, dangling informal reference)
- **excuse-comments**: 0

Overall verdict: `FlatBaseChange.lean` is a clean scaffold — the sole `noncomputable def` is a mathematically sound adjoint-mate construction that typechecks correctly at every intermediate step, and both sorry sites are honest with no deceptive tactics or wrong definitions.
