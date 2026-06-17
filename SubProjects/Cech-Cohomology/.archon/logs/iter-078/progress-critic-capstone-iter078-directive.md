Assess convergence of the single active route. Use ONLY the signals below.

## Route: P5b capstone — Čech computes higher direct images (Route A acyclic-resolution comparison)
Files: `CechTermAcyclic.lean` (producer, deep) + `CechToHigherDirectImage.lean` (consumer, seams+assembly).
STRATEGY `Iters left` for this phase: ~1. Phase entered: P5b assembly has been the active phase since ~iter-067 (capstone leaf split at iter-077).

## Signals, last 5 iters
- iter-074: CSI route — closed 2 sorries (sectionCechAugV_π, backboneIncl_proj). Status COMPLETE. Project sorries → ~3.
- iter-075: closed 1 sorry (pushPull_interLegHom_sections, last CSI leaf). COMPLETE. CONVERGING.
- iter-076: closed 1 sorry (cechAugmented_exact glue). COMPLETE. Project inline sorries → 1 (frozen) +0. CONVERGING.
- iter-077: split capstone into 2 PARALLEL lanes (producer+consumer). Producer found its planned signature false, amended it (added [S.IsSeparated]+hres). Consumer written against OLD sig → ill-typed at line 207. Net verified closes = 0. Helpers added: ~18 (restrict-over bridge ~17 + mapAlternatingCofaceMapComplexIso). Status PARTIAL/mis-converged (producer+consumer parallelised mid-signature-change).
- iter-078 (this iter, pre-dispatch): GROUND-TRUTH BUILD — `lake env lean CechTermAcyclic.lean` exit-0, empty output, 0 sorries. The iter-077 review's "producer broken" claim was a FALSE-POSITIVE cascade (auditor mis-stated `IsZero.of_iso` direction; both flagged sites are correct). Producer = DONE. Consumer's only defect = signature threading (add [S.IsSeparated]+hres to sig + pass hres n at line 207); seams + assembly already written.

## Planner's PROGRESS proposal this iter
ONE lane: `CechToHigherDirectImage.lean` [prover-mode: prove] — amend the (non-protected) capstone signature, thread `hres`, verify the file builds. NO producer lane (CechTermAcyclic is frozen-done). NO parallelism (the iter-077 mis-convergence lesson).

Question: Is this route CONVERGING, or is the 2-helper-heavy iter-077 a churn signal? Is the single-lane consumer-only dispatch the right call vs the parallel split that mis-converged? Verdict per route: CONVERGING / UNCLEAR / CHURNING / STUCK + the corrective type if not converging.
