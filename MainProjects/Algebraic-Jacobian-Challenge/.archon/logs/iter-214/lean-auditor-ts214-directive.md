# lean-auditor directive — iter-214

## Files to audit (absolute paths)

- `/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

## Focus areas

- A new section `StalkLinearMap` was added near the end of the `FlatWhisker`
  region (roughly L500–600+). It introduces four declarations:
  `stalkLinearMap`, `stalkLinearMap_germ`, `stalkLinearMap_bijective_of_isIso`,
  `stalkLinearEquivOfIsIso`. Pay extra attention to the `map_smul'` proof of
  `stalkLinearMap` — it is a germ-chase (`germ_exist` / `germ_res_apply` /
  `germ_smul` / `stalkFunctor_map_germ_apply`). Verify the chase is honest (no
  vacuous rewrite, no `sorry`, no hidden `admit`/`native_decide` shortcut).
- Check whether any docstrings or `--` comments in the file are now stale or
  internally contradictory (the file has accumulated multi-iter route narrative:
  routes c/d/e, "flatness", "local triviality", "stalk port"). Flag comments
  that describe a state of the file that no longer holds.
- The lemma `isLocallyInjective_whiskerLeft_of_W` (around L443) is a typed
  `sorry`. Confirm its body comment accurately describes the residual and does
  not over-claim. Confirm the three other sorries (`tensorObj_restrict_iso`,
  `exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`) are untouched typed
  sorries, not regressions.
- Note any declaration whose stated generality looks wrong for its only
  consumer (e.g. a lemma stated over a general site `C` that can only ever be
  used over `Opens X`).

Report your standard per-file checklist plus a flagged-issues block. Do not
read PROGRESS.md / STRATEGY.md / the blueprint — audit the Lean as Lean.
