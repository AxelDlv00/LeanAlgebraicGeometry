# lean-auditor directive — iter-040

Audit the Lean code for correctness, dead ends, bad practices, and spurious/unsound proofs.

## Files to read (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/QcohRestrictBasicOpen.lean

## Focus areas
- The four declarations added this iter (lines ~243–315):
  `overBasicOpenIsoRestrict`, `pullbackObjUnitToUnit_isIso_basicOpen`,
  `restrictBasicOpenUnitIso`, `presentationModulesRestrictBasicOpen`.
- Pay extra attention to two risk patterns:
  1. `set_option backward.isDefEq.respectTransparency false` on `overBasicOpenIsoRestrict` —
     confirm it is not masking a defeq that is unsound at kernel level.
  2. The `ext U : 3; simp [...]; rfl` closing of the `pushforwardCongr` data equality — confirm
     this is a genuine equality of ring-sheaf morphisms, not a spurious-rfl that the kernel would
     reject (there is a known kernel-soundness trap in this project where bare `ext`/`congr 1`
     auto-close thin-category coherence goals with an unsound rfl-term the LSP accepts).
  3. Explicit `@`-application with hand-supplied instance args (`hpc`, the `@asIso`,
     `@SheafOfModules.Presentation.map`) — confirm the supplied instances are the right ones and
     nothing is being coerced past a type mismatch.
- General: outdated comments, dead code, deprecated API (`Sheaf.val` is known-deprecated — flag
  but it is pre-existing).

Report a per-file checklist plus a flagged-issues block with severity (CRITICAL/MAJOR/MINOR).
