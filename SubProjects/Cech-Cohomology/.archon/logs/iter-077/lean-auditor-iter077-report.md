# Lean Audit Report

## Slug
iter077

## Iteration
077

## Scope
- files audited: 2
- files skipped: 0

---

## Per-file checklist

### AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: 1 flagged
- **excuse-comments**: none
- **notes**:
  - Line 99 (`isRightAcyclic_of_iso` proof body): `h.of_iso ((G.rightDerived (k + 1)).mapIso e).symm` uses the iso in the **wrong direction**. `h : IsZero ((G.rightDerived (k+1)).obj A)` and `IsZero.of_iso (h : IsZero X) (e : X ≅ Y) : IsZero Y` requires `e : X ≅ Y` with source `X = obj A`. The iso `(mapIso e).symm` has source `obj B`, not `obj A`. The correct term is `(G.rightDerived (k + 1)).mapIso e` (no `.symm`). This is a type error: the proof body fails to elaborate.
  - Line 668 (`pushPullObj_opens_pushforward_acyclic`): `h.of_iso (higherDirectImage_openImmersion_comp V.ι f _ hFV (k + 1))` uses the iso in the **wrong direction**. `h : IsZero (higherDirectImage (V.ι ≫ f) (k+1) H)`, and `higherDirectImage_openImmersion_comp V.ι f _ hFV (k+1) : higherDirectImage f (k+1) (V.ι_* H) ≅ higherDirectImage (V.ι ≫ f) (k+1) H` — its **source** is the goal type and its **target** is the type `h` is about. For `h.of_iso e` (where `e : X ≅ Y`, `h : IsZero X`) to give `IsZero goal`, we need `e.symm`. The correct term is `(higherDirectImage_openImmersion_comp V.ι f _ hFV (k + 1)).symm`. Type error.
  - Lines 315–526 (`RestrictOverBridge` section): eight declarations port project-internal code from `QcohRestrictBasicOpen.lean`, which was outside the prover's write domain. The comment acknowledges this. No correctness issue, but the duplication creates long-term maintenance risk.
  - Line 152–158 (`isAffineHom_of_isAffine_of_isSeparated`): docstring acknowledges this duplicates a `private` lemma in `OpenImmersionPushforward.lean`. Minor.
  - Line 707–708: `have hX : ... := rfl` immediately rewritten away; the defeq claim looks plausible given how `cechComplexOnX` is built, but cannot be independently verified without LSP.

### AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean
- **outdated comments**: none
- **suspect definitions**: none
- **dead-end proofs**: 2 flagged
- **bad practices**: none
- **excuse-comments**: none
- **notes**:
  - Line 207: `fun n => cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n` — **arity mismatch**: the actual signature of `cechTerm_pushforward_acyclic` (CechTermAcyclic.lean:699–704) has an explicit final argument `(hres : ∀ σ : Fin (p + 1) → 𝒰.I₀, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules)`. This is in round brackets, so it is not a typeclass and cannot be auto-synthesized. The call provides only 6 explicit args but the lemma requires 7. Lean will reject this as an unsaturated application.
  - Lines 197–200 (`cech_computes_higherDirectImage_of_affineCover` signature): `cechTerm_pushforward_acyclic` requires `[S.IsSeparated]` (CechTermAcyclic.lean:700). The outer theorem's hypothesis list is `[HasInjectiveResolutions X.Modules]`, `[QuasiCompact f]`, `[IsSeparated f]`, `[X.IsSeparated]` — **`[S.IsSeparated]` is absent**. The module docstring of `CechTermAcyclic.lean` (lines 28–31) explicitly states this hypothesis "is consequently REQUIRED by the capstone", so the omission is known but was not applied. Lean will fail to synthesize `S.IsSeparated` when elaborating the call.
  - Lines 25–28: module docstring cites blueprint at specific line numbers (`L11819`, `L11635`, etc.) in the LaTeX source. These will rot as the blueprint evolves. Minor documentation issue.

---

## Must-fix-this-iter

- `CechTermAcyclic.lean:99` — `isRightAcyclic_of_iso` proof body: extraneous `.symm` on the iso argument. `h : IsZero (obj A)` requires iso `obj A ≅ Y`; the code supplies `(mapIso e).symm : obj B ≅ obj A` (wrong source). Fix: remove `.symm`. Why must-fix: the proof body has a type error; the lemma fails to compile and all downstream callers (`pushPullObj_opens_pushforward_acyclic` line 669, `cechTerm_pushforward_acyclic` line 725) silently inherit the broken module.

- `CechTermAcyclic.lean:668` — `pushPullObj_opens_pushforward_acyclic` proof: `of_iso` applied without `.symm` when `.symm` is required. `h : IsZero (R^{k+1}(V.ι ≫ f)_* H)` requires iso `R^{k+1}(V.ι ≫ f)_* H ≅ Y`; `higherDirectImage_openImmersion_comp` returns `R^{k+1}f_*(V.ι_* H) ≅ R^{k+1}(V.ι ≫ f)_* H` (wrong source). Fix: append `.symm`. Why must-fix: type error in proof body of a helper that `cechTerm_pushforward_acyclic` depends on.

- `CechToHigherDirectImage.lean:207` — call `cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n` is missing the explicit `hres` argument. The lemma signature ends with `(hres : ∀ σ : Fin (p + 1) → 𝒰.I₀, HasInjectiveResolutions (coverInterOpen 𝒰 σ).toScheme.Modules)` which is not a typeclass. Fix: either (a) supply `hres` by adding a suitable hypothesis to `cech_computes_higherDirectImage_of_affineCover`, or (b) redesign `cechTerm_pushforward_acyclic` to infer `hres` from a typeclass (but the module docstring says Mathlib cannot synthesize these). Why must-fix: unsaturated application; the capstone theorem's proof cannot elaborate.

- `CechToHigherDirectImage.lean:197–200` — `cech_computes_higherDirectImage_of_affineCover` is missing `[S.IsSeparated]` in its hypothesis list. `cechTerm_pushforward_acyclic` (line 700) requires it; the module docstring of `CechTermAcyclic.lean` (lines 28–31) explicitly records this requirement was identified but not yet propagated to the capstone. Fix: add `[S.IsSeparated]` to the capstone's typeclass assumptions. Why must-fix: typeclass synthesis will fail at the call site.

---

## Major

- `CechTermAcyclic.lean:315–526` — `RestrictOverBridge` section duplicates ~210 lines of project-internal infrastructure from `QcohRestrictBasicOpen.lean` because the prover's write domain excluded that file. The comment acknowledges this. Not a correctness bug, but if `QcohRestrictBasicOpen.lean` is updated the duplicate must be kept in sync manually.

---

## Minor

- `CechTermAcyclic.lean:152–158` — `isAffineHom_of_isAffine_of_isSeparated` duplicates a `private` lemma in `OpenImmersionPushforward.lean` (acknowledged in docstring). The `private` qualifier prevents import re-use; either make the original non-`private` or consolidate.

- `CechTermAcyclic.lean:707–708` — `have hX : ... := rfl` on the `cechComplexOnX` definitional unfolding, immediately `rw`d away. Likely valid; worth a one-line comment confirming the defeq if LSP becomes available.

- `CechToHigherDirectImage.lean:25–28` — Blueprint line-number citations in the module docstring (`L11819`, `L11635`, etc.) will become stale as the LaTeX evolves; replace with `\label`-name references.

---

## Excuse-comments (always called out separately)

None found. The long module docstring in `CechTermAcyclic.lean` (lines 12–37) is a mathematical analysis, not an excuse.

---

## Severity summary

- **must-fix-this-iter**: 4 — these four issues form a cascading chain: the two `of_iso` direction errors (lines 99 and 668) break every helper that downstream callers depend on, and the two call-site gaps (missing `hres` and `[S.IsSeparated]`) mean the capstone theorem `cech_computes_higherDirectImage_of_affineCover` cannot compile even after the direction errors are fixed.
- **major**: 1
- **minor**: 3
- **excuse-comments**: 0

Overall verdict: both files are blocked — four must-fix type errors or arity mismatches form a cascading chain from the `isRightAcyclic_of_iso` helper (wrong `of_iso` direction) through `pushPullObj_opens_pushforward_acyclic` (wrong `of_iso` direction) to the capstone `cech_computes_higherDirectImage_of_affineCover` (missing `[S.IsSeparated]` and explicit `hres` argument); none of these declarations will compile until all four are corrected.
