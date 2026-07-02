Both inbox items filed (`I-0008` comment updated, `I-0024` info to human). Durable facts are already captured in existing memory (`gmscaling-collapse-at-zero-solved`, `albanese-t3-sorries-are-structural`); no new memory or roadmap edit is warranted (this is substrate sorry-closure, not a milestone flip). My write scope is clean (scratch removed, git tree clean).

## Summary
- Reviewed Horizon's T3 round (`gmScalingP1_collapse_at_zero` closure + blueprint fill). **Work is sound; build green; blueprint faithful.** No Ground source/blueprint edits were needed — Horizon reconciled the blueprint itself, correctly.

## Progress (verification performed)
- **Build**: `lake build` Albanese → **EXIT=0**, 8580 jobs (mostly cached; 5 sorry warnings, all in `CodimOneExtension`/`Thm32`).
- **Axioms** (`#print axioms` against built oleans): `gm_geometricallyReduced`, `projectiveLineBar_geomIrred`, `homogeneousLocalizationAwayIso`, `projectiveLineBarAffineCover_span`, and `gm_geomIrred`/`projGm_geomIrred`/`projGm_isReduced` all **axiom-clean** — confirms the blueprint `%`-comment claim.
- `gmScalingP1_collapse_at_zero` carries `sorryAx` **only** via pre-existing `hCP_check` (`GmScaling.lean:770`); Horizon added **no new sorry**. `GmScaling.lean` = 1 live sorry.
- **Blueprint**: 10 new `\leanok` nodes in `sec:genus0_helpers` — all `\lean{}` names resolve, all `\uses` labels exist, complete pure-math proofs matching the Lean. DAG: **0 dangling**.
- **Inbox**: commented `I-0008` (updated T3 target list); filed `I-0024` (ground review → human).

## Issues
- **`hCP_check` (`GmScaling.lean:770`) still open** — per-closed-point chart evaluation, genuinely hard; `gmScalingP1_collapse_at_zero` remains transitively `sorryAx`. Not blueprinted in Albanese (rigidity chapter lives in AJC).
- **6 new blueprint `\lean{}` targets are `private`** (`chartAway_*`, `irreducibleSpace_of_two_irreducible_opens`, `projectiveLineBarGenericPt`, etc.) — leandag resolves them, but they can't be externally axiom-checked. Minor.
- **Albanese leandag: 170 isolated `lean:` nodes** — pre-existing broad `\uses`-linkage gap (matches I-0010 engine-count note), not from this round; left as-is.
- Orphaned root fragments `RationalCurveIso.{body,new,skeletal}` (cover a non-existent Lean file, chapter not `\input`) persist; left in place (tracked, not my creation) — already memory-flagged.
- Pre-existing MR0555258 mathlib pin mismatch (v4.30 vs v4.31) still warned by CLI; out of T3 scope.

## Next
- Remaining Albanese sorries: `hCP_check` (hard) + ~15 blocked on `AJC.pic0av`/`AJC.picrep`/Mathlib upstream. **No further generic "restore-to-0-sorry" T3 session** is fruitful.
- If Albanese work continues, launch **`ALB.codim1`** specifically (`CodimOneExtension.lean` 1348/1630/1698 — real codim-1 extension math).
- On AJC re-merge, pick up `gmScalingP1_collapse_at_zero` + the two new `Points` lemmas (no signature changes) and sync `\leanok` in the AJC rigidity chapter.
