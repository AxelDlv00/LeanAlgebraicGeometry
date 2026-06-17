# Iter 037 — Objectives

| Lane | File | Mode | Target | Residual after |
|---|---|---|---|---|
| FBC-A1 | Cohomology/FlatBaseChange.lean | fine-grained | close `gstar_transpose` (@2167) by assembling proved atoms (inline step-(a) reindex + (b) + (c) `huce` + dictionary cancel); prune dead `_legs` cluster | A2 affine reduction @2348 (gated) |
| QUOT-Hfr | Picard/QuotScheme.lean | mathlib-build | build (I) ring-iso-semilinear `IsLocalizedModule` transport + (II) base-change-of-localization → `Hfr` → close `isLocalizedModule_basicOpen_descent` + gap1 | gap1 closed ⟹ unblocks GF-G1, annihilator |
| GR-E3full | Picard/GrassmannianCells.lean | mathlib-build | build cofactor helper (`cramer_apply`/`det_succ_column`) → close E3-full `existence_factor_through_valuationRing` | E4 → valuativeExistence → isProper |

Critics: strategy-critic `iter037` (FBC A2-scope/prune/anchor must-fixes ADDRESSED), progress-critic
`iter037` (FBC STUCK-assembly-pass-endorsed + tripwire ENFORCED; QUOT/GR CONVERGING; dispatch OK).
blueprint-reviewer SKIPPED (rationale in plan.md).
