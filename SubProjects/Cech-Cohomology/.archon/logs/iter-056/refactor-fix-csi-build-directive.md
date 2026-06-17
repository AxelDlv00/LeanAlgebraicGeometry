# Refactor directive — repair the RED build in `CechSectionIdentification.lean`

## Goal
The file `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` was scaffolded last
iteration with **signature-level (not proof-body) errors** that make it fail to compile. Because
the root barrel `AlgebraicJacobian.lean` imports it, the WHOLE project build is RED. Your job is to
make this ONE file compile green, leaving the six `sorry` stub BODIES exactly as they are (do not
attempt any proofs). After your fix, `lake build` must succeed with only the six expected
`declaration uses sorry` warnings.

## Scope
Edit ONLY `AlgebraicJacobian/Cohomology/CechSectionIdentification.lean`. Do not touch any other file.

## The exact errors to fix (diagnosed by the lean-auditor and two provers)

1. **Line 37 — `open ... Scheme.Modules ...` is placed BEFORE `namespace AlgebraicGeometry`**, which
   causes `unknown namespace 'Scheme.Modules'` (the real name is `AlgebraicGeometry.Scheme.Modules`,
   only resolvable inside `namespace AlgebraicGeometry`). This is the ROOT error; it cascades into the
   `Over.mk` and `evaluation` failures below.
   - Fix: move `open Scheme.Modules` (keep `open CategoryTheory Limits Opposite` where appropriate) to
     AFTER the `namespace AlgebraicGeometry` line (line 39), exactly as the sibling files
     `OpenImmersionPushforward.lean` and `CechAugmentedResolution.lean` do. Inspect those two files for
     the canonical `open` placement and mirror it.

2. **Line 126 — wrong product notation `∏` instead of `∏ᶜ`** in `pushPull_sigma_iso`'s type. Stub 4
   (`pushPull_eval_prod_iso`, line ~203) correctly uses `∏ᶜ` and elaborates. One-character fix:
   change `∏` to `∏ᶜ` at line 126 (the categorical product in `X.Modules`).

3. **Lines 77, 164 — `Unknown identifier 'Over.mk'`.** After fixing (1) this may resolve
   automatically (the namespace error was degrading elaboration). If it does NOT resolve, qualify as
   `CategoryTheory.Over.mk` or add the appropriate `open` so `Over.mk` is in scope. Confirm `Over.mk`
   is the correct constructor in the current Mathlib (it is used to build an `Over X` object from a
   morphism into `X`).

4. **Lines 258–259 — `Unknown identifier 'evaluation'`** and the cascading
   `failed to synthesize GV.PreservesZeroMorphisms`. The identical construction
   `PresheafOfModules.toPresheaf X.ringCatSheaf.obj ⋙ (evaluation ...).obj (op V)` elaborates fine in
   `CechAugmentedResolution.lean` (around line 204–205). These are cascade errors from (1); they
   likely vanish once (1) is fixed. If `evaluation` still fails to resolve, qualify it as
   `CategoryTheory.evaluation` (mirror the working `CechAugmentedResolution.lean` site).

## Constraints
- **Do NOT modify any of the six stub SIGNATURES' mathematical content** — the lean-vs-blueprint
  checker confirmed all six match the blueprint Sub-brick A chain exactly. Only fix `open`/`namespace`
  placement, the `∏`→`∏ᶜ` notation, and identifier scoping/qualification.
- **Do NOT fill any `sorry`.** Leave all six bodies as `sorry`.
- The minor 100-char style warning at line 111 may be wrapped if trivial, but it is optional.

## Verification (REQUIRED before you report success)
- Run `lake env lean AlgebraicJacobian/Cohomology/CechSectionIdentification.lean` (or
  `lake build AlgebraicJacobian.Cohomology.CechSectionIdentification`) and confirm exit 0 with ONLY
  six `declaration uses sorry` warnings and no errors.
- Then run `lake build` (root) and confirm the whole project is green again.
- Report the exact final `open`/`namespace` block you settled on and which of errors (3)/(4) needed an
  explicit qualification vs. resolved automatically.
