# lean-vs-blueprint-checker ab-iter201 directive

## Scope

Bidirectional verification:

- Lean: `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`
- Blueprint: `blueprint/src/chapters/Albanese_AuslanderBuchsbaum.tex`

## What to check

1. **Lean → blueprint**: iter-201 added 4 new private declarations
   in the `RingTheory.Module` namespace forming the **matrix-collapse
   substrate** for the Path B base case of
   `auslander_buchsbaum_formula_succ_pd`:
   - `Module.elemMap`
   - `Module.elemMap_apply`
   - `Module.linearMap_finFunR_matrix_decomp`
   - `Module.ext_comp_mk₀_ofHom_eq_zero_of_entries_mem_annihilator`

   The chapter has `\subsec:succ_pd_gap_sequence` (gap (2)) with a
   Stacks 00MF recipe paragraph plus a "matrix-collapse" mention.
   Verify whether the chapter's iter-201 Path B narrative aligns
   with the new substrate decls (no `\lean{...}` pins expected for
   `private` helpers, but inline prose pointer is appropriate).

2. **Blueprint → Lean**: every `\lean{...}` pin in the chapter
   resolves to an existing project declaration. In particular
   `lem:auslander_buchsbaum_formula_succ_pd` →
   `RingTheory.auslander_buchsbaum_formula_succ_pd` (still
   `private`; the iter-201 plan committed option (1) — remove
   `private` as part of the closure landing; that is still pending
   because the body is not yet closed).

3. **Body status drift**: the chapter's gap-sequence table /
   sub-status enumeration should reflect iter-201 outcome:
   matrix-collapse substrate landed (path-B base-case
   prerequisite), inductive-step assembly + matrix-collapse-driven
   LES bookkeeping remain.

4. **Severity tags**: `must-fix-this-iter` (downstream blocked), or
   `soon` (chapter narrative drift; not blocking).

## Output

Per-file report. Write to
`task_results/lean-vs-blueprint-checker-ab-iter201.md`.
