# Lean Auditor Directive

## Slug
iter064

## Files to audit (absolute paths)
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/CechSectionIdentification.lean
- /home/archon/proj/Cech-Cohomology/AlgebraicJacobian/Cohomology/OpenImmersionPushforward.lean

## Focus areas
- These two files received prover edits this iter. Audit them as Lean.
- Verify every `sorry` is an HONEST open hole (correctly-typed statement, no
  weakened/trivialized type to dodge the obligation). Flag any sorry whose
  enclosing declaration's TYPE looks weaker than its name/docstring claims.
- Pay special attention to declarations whose BODY is sorry-free but which
  TRANSITIVELY depend on sorries (e.g. a theorem closed by `exact <lemma>`
  where `<lemma>` is itself a sorry). Confirm such a decl is NOT presented in
  comments/docstrings as "done"/"closed" without the "modulo leaves" caveat.
  In particular inspect `higherDirectImage_openImmersion_acyclic` (OpenImm) —
  its `case hqc` was just rewired to `exact pushforward_iso_preserves_qcoh`,
  which depends on still-sorried sub-lemmas.
- Flag any kernel-soundness laundering: thin-category `ext`/`congr 1` that the
  LSP accepts but might be unsound; any use of `set_option maxHeartbeats`
  hiding a stuck proof; any `erw`/`rfl` that closes a goal suspiciously.
- Flag excuse-comments ("temporary", "wrong def", "will fix later").
- Check the new CSI helpers (`coprodOverIncl`, `coprodToProdMap`,
  `coprodToProdMap_comp_π`, `coprodToProd_isIso_option`, `isIso_coprodToProdMap`,
  `pushPull_coprod_prod`, `pushPull_sigma_iso`, `pushPull_eval_prod_iso`,
  `piOptionIso_inv_π_none/some`, `pushPullObjCongr_hom`,
  `pushPull_binary_coprod_prod_hom`) for genuineness.

## Output
Per-file checklist + flagged issues with severity, to your task_results report.
