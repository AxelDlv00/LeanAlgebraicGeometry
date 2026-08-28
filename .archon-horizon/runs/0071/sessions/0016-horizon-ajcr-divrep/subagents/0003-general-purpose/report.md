All 42 non-census hits above are prose inside docstrings/comments (they mention "sorry-free", "a sorry census", etc.), so the stripped-comment count is the right one.

## Census

| file | code sorries | reachability |
|---|---|---|
| `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Challenge.lean` | 15 | ROOTED |
| `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian/Picard/Pic0ThetaCocycle.lean` | 1 | UNROOTED |
| `/home/axel/LeanAlgebraicGeometry-Horizon/MainProjects/Algebraic-Jacobian-Challenge-Rebuild/scripts/charts-probe.lean` | 1 | UNROOTED |

Total: 17 code `sorry` terms in 3 of 746 project `.lean` files. 15 rooted (all in `Challenge.lean`), 2 unrooted.

Root file: `/home/axel/.../Algebraic-Jacobian-Challenge-Rebuild/AlgebraicJacobian.lean`, identified from `lakefile.toml` (`defaultTargets = ["AlgebraicJacobian"]`, `[[lean_lib]] name = "AlgebraicJacobian"`). Transitive closure from it reaches 728 of 746 files; the 18 unreachable ones are 17 under `AlgebraicJacobian/Picard/` (the `DivSchemeRedesign*`/`DivScheme*` cluster, `EntryIdeal`, `Pic0ThetaCocycle`, `ScratchChartLocal`) plus `scripts/charts-probe.lean`.

Classification method: a Python pass over each file replacing (a) nesting-aware `/- ... -/` blocks including `/-- ... -/` docstrings, (b) `--` line comments, and (c) string/char literal bodies, with spaces (newlines preserved), then matching `sorry` with non-identifier boundaries on both sides (excludes `sorryAx`, `sorry_free`, `sorry-free` is excluded by comment stripping anyway). Import graph built by parsing `import` lines from the same stripped text, mapping module names to paths via the directory layout; `.lake/` and `.git*` directories excluded. Script lived in `/tmp` and is deleted. No project file was modified and no build was run.

Line locations, if useful:
- `Challenge.lean`: 99, 108, 113, 117, 121, 126, 134, 147, 156-158 (`map _`/`map_id`/`map_comp` of a functor), 248, 259, 272, 283 — these are the mathematician-owned challenge signatures (`Jacobian`, etc.).
- `Pic0ThetaCocycle.lean`: 268 (a documented cocycle-identity gap, with a proof sketch in the preceding comment).
- `scripts/charts-probe.lean`: 3 (`theorem controlA : 1 = 1 := by sorry` — a deliberate axiom-probe control, not project math).
