# Directive — lean-auditor (iter-046)

Audit the Lean file below as Lean. No strategy framing is provided on purpose.

## Files to read (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohTildeSections.lean

## Focus areas
- The declarations added/changed at the END of the file (roughly lines ~1000–1140):
  `isScalarTower_restrictScalars_obj` (instance), `tileReconcileEquiv` (noncomputable def),
  `tileReconcileEquiv_apply` / `tileReconcileEquiv_symm_apply` (`@[simp]` private lemmas),
  `tile_restrict_map_apply` (private lemma), and `tile_section_localization` (the target lemma).
- Pay extra attention to any proof that closes a morphism/subsingleton goal. The project has a
  documented kernel-soundness trap: bare `ext`/`congr 1`/`congr` can auto-close a subsingleton-morphism
  goal with an UNSOUND rfl-term the LSP accepts but `lake env lean` rejects. Check whether the closing
  step uses an explicit `congrArg (… .hom) (Subsingleton.elim _ _)` (the safe form) or a bare tactic.
- `rfl`-bodied lemmas stated at the `⇑`-coercion / applied-value level (`tile_restrict_map_apply`):
  confirm they are genuine, not papering over a real type mismatch.
- The `set_option maxHeartbeats 1000000 in` blocks: are they justified (a real heavy `isDefEq`), and is
  the required explanatory comment present?
- Outdated comments, dead-end proofs, suspect definitions, bad Lean practices anywhere in the file.

## Output
Per-file checklist + flagged-issues block with severity (CRITICAL/HIGH/MEDIUM/LOW). For each new decl,
state whether it is axiom-clean-looking and whether any proof relies on a trap pattern.
