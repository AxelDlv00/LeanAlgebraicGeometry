# Refactor Directive

## Slug
split-regroup

## Problem
In `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`, the object-level
`ModuleCat R'` isomorphism `AlgebraicGeometry.base_change_mate_regroupEquiv`
(around line 918) carries a `sorry` in its bundled `map_smul'` field (around line
978). The iter-004 prover established that this is a pure Lean instance-diamond
wall, NOT a mathematical gap: after `TensorProduct.induction_on` strips the
`restrictScalars` object wrapper, the object `R'`-scalar action on the bare tensor
carrier is defeq-but-syntactically-opaque to every standard smul lemma, so
`map_smul'` cannot be discharged in-file.

The prover verified end-to-end (in a scratch `import`-based definition) that the
clean closure
`exact LinearEquiv.toModuleIso (base_change_regroup_linearEquiv ↑M)`
typechecks and is sorry-free **only when** `base_change_regroup_linearEquiv` lives
in a SEPARATELY COMPILED module: the imported type normalises the
`Module A (A ⊗[R] R')` instance diamond that blocks the same-file construction.
Same-file, the diamond does not reduce.

Your job is the file-split that enables that closure. You do NOT close the sorry
(that is the prover's one-liner next iter); you only relocate the helper into its
own compilation unit and rewire imports.

## Mathematical Justification
`AlgebraicGeometry.base_change_regroup_linearEquiv` (currently in
FlatBaseChange.lean, approx lines 846–887) is the already-proved, axiom-clean
(`propext`, `Quot.sound`) pure-tensor-algebra core: the `R'`-linear equivalence
`(A ⊗[R] R') ⊗[A] M ≃ₗ[R'] R' ⊗[R] M`, built as
`comm ≪≫ cancelBaseChange ≪≫ comm` with `R'` acting through
`Algebra.TensorProduct.rightAlgebra`. Its mathematics is unchanged by relocation;
only the elaboration environment at the call site changes. Moving it to a new
imported file is therefore behaviour-preserving for the helper itself and unblocks
the diamond at the consumer.

Blueprint side (already done by the plan agent): the helper now has its own chapter
`blueprint/src/chapters/Cohomology_RegroupHelper.tex` (1:1 slug for the new file),
with block `lem:base_change_regroup_linearEquiv`; the consumer
`lem:base_change_mate_regroupEquiv` now `\uses` it.

## Changes Requested
- File: `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (NEW)
  - Create it. Header: `import Mathlib` then `set_option autoImplicit false` then
    `namespace AlgebraicGeometry` (matching the existing namespace so the
    fully-qualified name stays `AlgebraicGeometry.base_change_regroup_linearEquiv`).
  - Move the definition `base_change_regroup_linearEquiv` here VERBATIM (its full
    body — the `comm`/`cancelBaseChange`/`comm` composite re-bundled as `≃ₗ[R']`
    with the by-hand `map_smul'` proof on generators). Carry over EXACTLY the
    `variable`/section context and any instance bindings it needs (the ring/algebra
    setup `R R' A`, `[CommRing …]`, `[Algebra R R']`, `[Algebra R A]`, the
    `Algebra.TensorProduct.rightAlgebra` instance usage, and the module `M`). It
    depends only on Mathlib otherwise — no other project-local declaration moves.
  - Close with `end AlgebraicGeometry`.

- File: `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`
  - Remove the `base_change_regroup_linearEquiv` definition (now in RegroupHelper).
  - Add `import AlgebraicJacobian.Cohomology.RegroupHelper` near the top with the
    other imports.
  - Leave `base_change_mate_regroupEquiv` (and its `map_smul'` `sorry`) UNCHANGED —
    do NOT fill it. Its reference to `base_change_regroup_linearEquiv` must continue
    to resolve via the new import (it currently references the same name).
  - Leave every other declaration and every other `sorry` untouched.

## Affected Files
- `AlgebraicJacobian/Cohomology/RegroupHelper.lean` (new — must compile, no sorry).
- `AlgebraicJacobian/Cohomology/FlatBaseChange.lean` (loses one def, gains one
  import; must still compile with its existing 4 sorries: `base_change_mate_regroupEquiv`
  map_smul', `base_change_mate_generator_trace_eq`, `affineBaseChange_pushforward_iso`,
  `flatBaseChange_pushforward_isIso`).

## Expected Outcome
- `RegroupHelper.lean` compiles, contains only `base_change_regroup_linearEquiv`
  (axiom-clean, no sorry).
- `FlatBaseChange.lean` compiles, imports RegroupHelper, and still has EXACTLY the
  same 4 sorries it had before (the hms sorry in `base_change_mate_regroupEquiv` is
  NOT closed by you — the prover does that next via the one-liner now that the
  helper is in a separate unit).
- No new sorries introduced. Verify with `lean_diagnostic_messages` on both files.
- If the move surfaces an unexpected local dependency of the helper (a non-Mathlib
  decl it needs), STOP, leave FlatBaseChange.lean compiling, and report it under
  "Notes for Plan Agent" rather than dragging extra declarations across.
