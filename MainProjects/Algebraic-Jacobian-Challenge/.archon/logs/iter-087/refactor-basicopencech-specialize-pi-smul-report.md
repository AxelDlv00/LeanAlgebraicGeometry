# Refactor Report

## Slug
basicopencech-specialize-pi-smul

## Status
COMPLETE

## Directive

### Problem (soundness)

The previous iter-087 refactor extracted `cechCofaceMap_pi_smul` as a top-level
theorem with **universally-quantified abstract signature** over
`(Z₁, Z₂, e₁, e₂, scK₀_f, h_mod_pi₁, h_mod_pi₂, R)`. The conclusion
`e₂ (scK₀_f.hom (e₁.symm (r • y))) = r • e₂ (scK₀_f.hom (e₁.symm y))` is
mathematically FALSE for arbitrary `scK₀_f`. Combined with the `sorry` body,
this is functionally a false axiom. Per the project's soundness rule, no
helper with a universally-false signature may be introduced even with `sorry`.

### Changes

1. Replace abstract `cechCofaceMap_pi_smul` (L466–L481) with a concrete one
   specialized to the project's Čech-cochain context (explicit args
   `hU : IsAffineOpen U`, `s₀ : Finset Γ(C.left, U)`, `hn : 0 < n`).
2. Update call site at L1069–L1070 to `cechCofaceMap_pi_smul hU s₀ hn`.
3. Preserve `presheafMap_restrict_collapse` byte-for-byte.
4. Preserve everything else byte-for-byte.
5. Duplicate the `letI perI_i / h_mod_pi_i` block inside the new theorem (the
   `Z_i`/`e_i`/`h_mod_pi_i` quantities must be reproduced to state the
   conclusion).

## Changes Made

### File: `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`

- **What:** Replaced the abstract `cechCofaceMap_pi_smul` theorem (former
  L466–L481) with a concrete version. The new statement (L455–L495) takes
  `hU : IsAffineOpen U`, `s₀ : Finset Γ(C.left, U)`, `hn : 0 < n` as explicit
  arguments and internally `let`-binds the Čech-cochain quantities
  `R := Γ(C.left, U)`, `K₀ := cechCochain C (toModuleKSheaf C) (basicOpenCover ↑s₀)`,
  `scK₀ := HomologicalComplex.sc K₀ n`, `Z₁`/`Z₂` (the indexed families), and
  `e₁`/`e₂` (the `ModuleCat.piIsoPi`-based linear equivalences). The block
  `letI perI₁ / h_mod_pi₁ / perI₂ / h_mod_pi₂` reproduces the per-i R-module
  structures and the `Pi.module` derivations using the same definitions as
  the inline let-block inside `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`.
  The body remains `sorry` (active iter-088+ prover target).
- **Why:** The previous abstract signature was mathematically false for
  arbitrary `scK₀_f`. Specializing to the Čech-cochain context makes the
  conclusion provable in principle (the Čech differential is an alternating
  sum of presheaf-restriction maps, each R-linear — see
  `presheafMap_restrict_collapse`). This honors the project's soundness rule
  forbidding universally-false signatures.
- **Cascading:** Updated the call site at L1084 from
  `cechCofaceMap_pi_smul (R := R) e₁ e₂ h_mod_pi₁ h_mod_pi₂ scK₀.f` to
  `cechCofaceMap_pi_smul hU s₀ hn`. The local `h_diff_pi_smul_f` continues
  to have the same equational type after let-unfolding, so the downstream
  `h_diff_pi_smul_f r (e₁ x)` rewrite in `f_R.map_smul'` (L1112) continues to
  type-check by definitional equality of the let-bound `R`/`scK₀`/`Z_i`/`e_i`/`h_mod_pi_i`.

- **What (preserved):** `presheafMap_restrict_collapse` at L412–L434 is
  byte-for-byte unchanged. The inline `let`/`letI` block inside
  `basicOpenCover_isCechAcyclicCover_toModuleKSheaf`
  (`Z₁/Z₂/Z₃/e₁/e₂/e₃/perI₁/perI₂/perI₃/h_mod_pi₁/h_mod_pi₂/h_mod_pi₃/h_mod_X₁/h_mod_X₂/h_mod_X₃`)
  at L980–L1069 (post-edit numbering) is byte-for-byte unchanged. The
  `f_R`/`g_R`/`h_loc_X_i`/`h_loc_exact` blocks below are also unchanged.

## New Sorries Introduced

No net new sorries. The previous abstract `cechCofaceMap_pi_smul` carried a
sorry; the new concrete version carries one sorry at the corresponding
location. Sorry count stays at **6** in this file.

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean:495` — body of the new
  concrete `cechCofaceMap_pi_smul`. Same as the previous abstract version,
  but now mathematically true (specialized to the Čech-cochain context).
  The iter-088+ prover closes this body.

## Compilation Status

- `AlgebraicJacobian/Cohomology/BasicOpenCech.lean`:
  **Cannot directly verify in this environment.** Project-level `lake build`
  fails with cascading `permission denied (error code: 13)` errors because
  the package directories under `.lake/packages/` are owned by `root` (not
  `archon`), preventing lake from creating the per-package `.lake` build
  state subdirectories. This is a pre-existing environmental issue unrelated
  to this refactor. The LSP MCP `lean_diagnostic_messages` returns
  `success: false` with empty items on every project file (not just this
  one), confirming the LSP cannot bootstrap due to the same underlying
  permission problem.

  **Indirect verification performed:**
  1. The new theorem's statement structure (let + letI bindings in type
     position, `fun i => by ...` tactic bodies for `perI₁`/`perI₂`,
     `Pi.module _ _ _` for `h_mod_pi₁`/`h_mod_pi₂`, ∀-quantified conclusion)
     was validated standalone via `mcp__archon-lean-lsp__lean_run_code` —
     compiles cleanly with `sorry` body (`success: true`, no diagnostics).
  2. The application/instance-matching pattern (applying a theorem whose
     conclusion contains let-bound module instances at a call site with
     matching local let-bound instances, then using the application term in
     a `rw`) was validated standalone — compiles cleanly.
  3. The replaced theorem differs from the previous abstract version only
     in the *shape* of how `R`, `e₁`, `e₂`, `h_mod_pi₁`, `h_mod_pi₂`,
     `scK₀.f` are reached (let-bound from `hU/s₀/hn` rather than supplied as
     explicit arguments). The conclusion's underlying *expression* after
     let-unfolding is byte-for-byte the same as the previous abstract
     version specialized to the call-site arguments. Hence the downstream
     `f_R.map_smul'` proof (which only references `h_diff_pi_smul_f r (e₁ x)`
     and standard `LinearEquiv` lemmas) continues to type-check.

  Once the environmental permission issue is resolved (a follow-up
  `chown -R archon:archon .lake/packages/`), running `lake build
  AlgebraicJacobian.Cohomology.BasicOpenCech` is expected to succeed with
  the same 6-sorry footprint as iter-086 (one of which is the new
  concrete `cechCofaceMap_pi_smul`).

## Notes for Plan Agent

- **Soundness restored.** The new concrete `cechCofaceMap_pi_smul` cannot be
  used as a false-axiom bypass at unrelated call sites: applying it requires
  a `Finset Γ(C.left, U)` and `IsAffineOpen U`, and its conclusion is
  specifically about `(HomologicalComplex.sc (cechCochain C (toModuleKSheaf C)
  (basicOpenCover ↑s₀)) n).f` — not arbitrary morphisms of products of
  module-cat objects. The mathematical claim (Čech differential is R-linear)
  is true.

- **Letting `perI`/`h_mod_pi` inside the conclusion type works correctly.**
  The standalone test (Test 2 in indirect verification) confirmed that
  `letI` in the type ascription registers the instance for downstream
  resolution within the conclusion and produces an applied term whose type
  reduces correctly at consumer sites. The risk that the theorem's
  `h_mod_pi₁` instance differs from the call site's `h_mod_pi₁` is mitigated
  by definitional equality: both are constructed via byte-identical
  `letI perI := fun i => by apply RingHom.toModule; ...` followed by
  `letI h_mod_pi := Pi.module _ _ _` chains.

- **File line count.** Original (pre-refactor): 1154 LOC. Post-refactor:
  1168 LOC (+14 LOC). The directive estimated +75 LOC because it suggested
  reproducing the *full* letI block (Z₁/Z₂/Z₃/e₁/e₂/e₃/perI₁/perI₂/perI₃/...). I only reproduced the strict subset needed to state the theorem's
  conclusion (Z₁/Z₂/e₁/e₂/perI₁/perI₂/h_mod_pi₁/h_mod_pi₂). The Z₃/h_mod_X_i
  quantities are not referenced in the theorem's conclusion, so they do not
  need to be reproduced.

- **Unused-argument warning may fire on `hU` and `hn`.** Both are accepted
  per the directive's spec but neither is currently referenced in the
  theorem body (the body is `sorry`). The iter-088+ prover filling the body
  will use `hU` (for affine-locality arguments) and `hn` (for positive-degree
  reductions). Lean's `linter.unusedVariables` typically warns but does not
  error on this.

- **Environmental permission issue.** Verified that
  `.lake/packages/*` are owned by `root`, blocking `lake build`. This is a
  pre-existing condition (not caused by this refactor) and affects every
  Lean-build operation in this directory tree. Consider asking the user to
  run `sudo chown -R archon:archon /home/archon/Lean_tests/AlgebraicJacobian/.lake/packages` once.
