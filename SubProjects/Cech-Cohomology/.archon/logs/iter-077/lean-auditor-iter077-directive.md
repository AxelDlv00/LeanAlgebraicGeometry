# Audit — two prover-touched files (iter-077)

## Files (absolute)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechTermAcyclic.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechToHigherDirectImage.lean

## Focus
- CechTermAcyclic.lean added ~330 LOC / 17 new decls (general-opens restrict–over bridge). Audit for: dead-end/duplicate helpers, kernel-soundness traps (bare `ext`/`congr` on thin-cat morphism goals — must use explicit `Subsingleton.elim`/`congrArg`), `local instance` hygiene, suspect `rfl`/defeq claims (`pushPull_sigma_iso`, `hX : … = … := rfl`).
- CechToHigherDirectImage.lean: check whether the call `cechTerm_pushforward_acyclic f 𝒰 h𝒰 F hF n` at ~line 207 type-checks against the lemma's actual signature in CechTermAcyclic.lean:699 (which now requires `[S.IsSeparated]` + an `hres` argument). Report any arity/instance mismatch as MUST-FIX.
- Note: review sandbox has only 2 GB RAM; do NOT attempt a full `lake build` of these (Mathlib import). Audit by source reading + targeted LSP if available.

## Output
Per-file checklist + flagged issues by severity.
