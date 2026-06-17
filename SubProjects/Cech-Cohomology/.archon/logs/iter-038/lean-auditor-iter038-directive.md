# Lean audit — iter-038

Audit the Lean file that received prover work this iteration.

## File to audit (absolute path)
- `/home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean`

## Focus areas
- This iteration added 8 declarations near the end of the file (a `RestrictOverBridge` section):
  `overEquivalence_functor_isContinuous_toScheme`, `overEquivalence_inverse_isContinuous_toScheme`
  (instances), `specBasicOpen_ι_image_overEquivalence_functor` (private), `overForgetIso`,
  `overForgetInvIso`, `overBasicOpenRingHom`, `overBasicOpenRingInvHom`,
  `modulesOverBasicOpenEquivalence`.
- Pay extra attention to the two coherence obligations (`H₁`/`H₂`) inside
  `modulesOverBasicOpenEquivalence`. During the session a bare `ext` tactic was reported to close one of
  them via an apparently-unsound `rfl` (LSP showed "solved" but `lake env lean` raised
  `unknown free variable _fvar…`); the final code switched to explicit `NatTrans.ext` + `congrArg` +
  `Subsingleton.elim`. Verify the committed proof is genuine, non-vacuous, and that no decl is
  accidentally trivial (e.g. an `Iso.refl`/`eqToIso` that hides a real obligation, or a `Subsingleton.elim`
  used where the two sides are NOT in a genuine subsingleton).
- Check the in-file `TODO` block (after `modulesOverBasicOpenEquivalence`) for accuracy — it describes a
  not-yet-built `overBasicOpenIsoRestrict`; confirm it is a comment, not a disguised stub.
- Flag any stale/inaccurate docstrings, dead code, leftover scratch (`testE`/`testPhi`/`thetaTest`-style
  names were renamed — confirm none survive), and bad Lean practices.

## Output
Per-file checklist + flagged-issues block with severity. Write your report to your task_results file.
