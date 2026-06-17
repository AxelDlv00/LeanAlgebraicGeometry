# Refactor Report

## Slug
fix-csi-build

## Status
COMPLETE

## Directive
**Problem:** `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` had signature-level
errors making the whole project RED. Root cause: `open Scheme.Modules` placed before
`namespace AlgebraicGeometry`, plus `∏` instead of `∏ᶜ` in one signature, plus cascading
identifier failures from the namespace error.

**Changes requested:**
1. Move `open Scheme.Modules` inside `namespace AlgebraicGeometry` (after line 39).
2. Fix `∏` → `∏ᶜ` at the `pushPull_sigma_iso` return type.
3. Fix `Over.mk` / `evaluation` identifier scoping if not auto-resolved.

## Changes Made

### File: `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`

**Change 1 — namespace/open fix (directive error 1)**
- **What:** Removed `Scheme.Modules` from the top-level `open` (line 37) and added
  `open Scheme.Modules` as its own line immediately after `namespace AlgebraicGeometry`.
  Before: `open CategoryTheory Limits Scheme.Modules Opposite` (outside namespace)
  After: `open CategoryTheory Limits Opposite` + `open Scheme.Modules` (inside namespace)
- **Why:** `Scheme.Modules` is `AlgebraicGeometry.Scheme.Modules`; it resolves only inside
  `namespace AlgebraicGeometry`. Mirrors canonical placement in `CechAugmentedResolution.lean`.
- **Cascading:** This was the root error; resolved `Over.mk` and `evaluation` automatically
  (directive errors 3 and 4). No explicit qualification needed for either.

**Change 2 — `∏` → `∏ᶜ` (directive error 2)**
- **What:** Changed the `∏` notation to `∏ᶜ` in the return type of `pushPull_sigma_iso`
  (categorical product in `X.Modules`, not a `Pi` type).
- **Why:** `∏` is for Pi types; `∏ᶜ` is the categorical product. Stub 4 already used `∏ᶜ`
  correctly.

**Change 3 — `(coverInterOpen 𝒰 σ).ι` → `Scheme.Opens.ι (coverInterOpen 𝒰 σ)` (not in directive)**
- **What:** Three call sites changed. `coverInterOpen 𝒰 σ : TopologicalSpace.Opens ↥X` and
  Lean looks up dot notation as `TopologicalSpace.Opens.ι` which does not exist; the real
  declaration is `Scheme.Opens.ι` (in `namespace Scheme.Opens`, `Mathlib.AlgebraicGeometry.Restrict:52`).
  Using explicit function application resolves this.
- **Why:** This error was masked by the original namespace cascade and surfaced after fix 1.
  Not listed in the directive but necessary for compilation.

**Change 4 — `set_option synthInstance.maxHeartbeats 800000 in` before `pushPull_sigma_iso`**
- **What:** Added the heartbeat override before stub 2's definition.
- **Why:** After fix 3, Lean successfully found the `HasLimit` instance for
  `Discrete.functor fun σ => pushPullObj F (Over.mk ...)` in `X.Modules` but the default
  20 000 heartbeat limit was insufficient. The project uses this pattern in
  `QcohRestrictBasicOpen.lean:292` and `CechAcyclic.lean:1204`.

## New Sorries Introduced
None. All six stubs already carried `sorry`; no new sorry sites added.

## Compilation Status
- `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`: compiles — exit 0, six
  `declaration uses sorry` warnings only (lines 76, 125, 163, 200, 252, 317), plus three
  style `longLine` warnings and one `maxHeartbeats` comment reminder (non-blocking).
- `lake build` (full project, 8335 jobs): `Build completed successfully`.

## Notes for Plan Agent
- **Errors 3/4 resolved automatically** after fixing the namespace (no explicit qualification
  needed for `Over.mk` or `evaluation`).
- **Additional fix needed (not in directive):** `.ι` dot notation on `TopologicalSpace.Opens`
  required switching to `Scheme.Opens.ι (...)` at three call sites (stubs 1, 2, 3).
- **Heartbeat override needed:** `pushPull_sigma_iso`'s `∏ᶜ` in `X.Modules` requires
  `synthInstance.maxHeartbeats 800000`. A style lint asks for a comment; could add one in a
  future cosmetic pass but does not block compilation.
- **Linter warnings (non-blocking):** three `longLine` warnings in comment lines 48, 85, 113
  (these are in the planner-strategy comments, not code lines). Optional to wrap.
- **Blueprint:** The six stubs' signatures are unchanged mathematically — the only code-level
  change to signatures was the `.ι` notation form and the `∏`→`∏ᶜ` fix; both preserve the
  mathematical content exactly as confirmed by the lean-vs-blueprint-checker.

## Declarations deleted / renamed
None.
