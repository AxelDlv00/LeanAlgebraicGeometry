# lean-vs-blueprint-checker — QuotScheme (iter-036)

Lean file: /home/archon/proj/Quot-Foundations/AlgebraicJacobian/Picard/QuotScheme.lean
Blueprint chapter: /home/archon/proj/Quot-Foundations/blueprint/src/chapters/Picard_QuotScheme.tex

Verify bidirectionally:
- This iter added `gammaPullbackTopIso` (pinned `lem:pullback_gamma_top_iso`), plus two NEW helpers
  with no blueprint block: `gammaPullbackImageIso` (general-in-U form) and
  `gammaPullbackImageIso_hom_naturality` (the naturality/intertwines-restriction clause).
- Confirm the `lem:pullback_gamma_top_iso` `\lean{...}` pin matches `gammaPullbackTopIso`.
- CRITICAL CHECK: the chapter NOTE (around L3712-3726) reportedly claims the Hfr chaining +
  `isLocalizedModule_basicOpen_descent` + gap1 become "one-liners after gammaPullbackTopIso lands".
  The prover reports this is OVER-OPTIMISTIC: two Mathlib-absent ingredients remain — (I) a
  ring-iso-semilinear `IsLocalizedModule` transport, (II) base-change-of-localization R->R_r. Flag
  whether the chapter NOTE needs correction so the next planner does not assign a false one-liner.
- The 4 file `sorry`s are pre-existing protected stubs (lines 126/165/201/228) — confirm.
- Report broken pins or uncovered Lean decls.

Report Lean->blueprint AND blueprint->Lean findings with must-fix-this-iter flags where warranted.
