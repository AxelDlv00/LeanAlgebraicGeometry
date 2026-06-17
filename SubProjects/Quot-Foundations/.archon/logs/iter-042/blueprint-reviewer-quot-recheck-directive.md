# Blueprint review — FAST-PATH re-review (iter-042), HARD GATE for QuotScheme G1-core

This is a HARD-GATE fast-path re-confirmation. The whole-blueprint audit
(`blueprint-reviewer-iter042`) flagged `Picard_QuotScheme.tex` with three stale
`\lean{}` pin mismatches + four missing helper blocks (MUST-fix pre-G1-core). A
blueprint-writer (`quot-reconcile`) then fixed all of them and a blueprint-clean pass
ran. `lake build` is green (no Lean changed this iter).

## What I need (focus your verdict here)

Confirm `blueprint/src/chapters/Picard_QuotScheme.tex` is now **complete: true** AND
**correct: true** with **no must-fix-this-iter finding**, specifically for sending a
prover at these two NEW Lean targets THIS iter:

1. **G1-core** — `lem:qcoh_affine_section_localization` → Lean
   `isLocalizedModule_basicOpen_of_isQuasicoherent` (Spec R, a one-line corollary of
   the now-closed gap1). Confirm the block's statement, `\uses{}`, and proof sketch are
   adequate to formalize, and the `% NOTE: does NOT yet exist` (correct) is preserved.
2. **gap2** — `lem:qcoh_section_localization_basicOpen` → Lean
   `isLocalizedModule_basicOpen` (general scheme X, the next step after G1-core). The
   writer reports gap2 is single-chart transport (U fixed affine → G1-core on
   `Spec Γ(X,U)` + a one-shot `IsLocalizedModule`-across-affine-iso transport), NOT
   cover-and-glue. Confirm the gap2 proof sketch is honest and prover-attemptable.

Also verify: the 3 reconciled pin blocks no longer pin non-existent decls, the 4 new
helper blocks have correct `\lean{}`/`\uses{}`, and leandag `unmatched` is clear for
this chapter's neighbourhood.

You may read the whole blueprint as usual, but the gate verdict I act on is for
`Picard_QuotScheme.tex` only. Report any residual must-fix that would block the
G1-core/gap2 prover dispatch.
