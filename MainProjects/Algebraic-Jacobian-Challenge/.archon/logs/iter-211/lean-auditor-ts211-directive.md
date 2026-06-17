# Lean Auditor Directive

## Slug
ts211

## Scope (files)
/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean

(Only this file was modified this iteration. Audit it thoroughly as Lean.)

## Focus areas
The FlatWhisker section (`isLocallySurjective_whiskerLeft`,
`isLocallyInjective_whiskerLeft_of_flat`, `W_whiskerLeft_of_flat`) and the new
`Scheme.Modules` declarations (`IsInvertible`, the unitors, `tensorObj_braiding`,
the scaffolded `tensorObj_assoc_iso`).

## Known issues
- Several typed `sorry` bodies are present and sanctioned: `tensorObj_assoc_iso` (newly
  scaffolded, single residual pinned in its docstring), `tensorObj_restrict_iso`,
  `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`. You may note them in the checklist
  but they are intentional, documented, off-critical-path or pending downstream construction —
  not surprise placeholders.
- The module-level docstring is known-stale (references the iter-202 file-skeleton state and a
  removed `monoidalCategory` declaration). Report it once if you see it; it is already tracked.
- One `erw` is used deliberately (`erw [TensorProduct.tmul_zero]; rfl`) to bridge a
  `restrictScalars` defeq where `rw`/`simp` fail to synthesize the `Module` instance.
Report anything else: dead-end proof shapes, bad Lean practices, excuse-comments, or any
suspect definition body in the newly-added code.
