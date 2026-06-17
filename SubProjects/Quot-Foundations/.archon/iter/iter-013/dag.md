# DAG iter-013 — close the 1-to-1 Lean↔blueprint coverage debt → COMPLETE

## Entry assessment

The meaningful mathematical roadmap was already in excellent shape entering this iteration: `leandag`
reported **0 ∞-effort nodes, 0 broken `\uses{}`, 0 isolated blueprint nodes, 0 blueprint decls missing
`\lean{}`**, and all 6 chapters in `content.tex`. The single failing COMPLETE-gate criterion was
**criterion 5 (1-to-1 coverage)**: 12 prover iterations had generated **44 internal helper
declarations** (`lean_aux`) with no blueprint entry — also showing up as the 44 isolated *Lean* nodes.

## Dispatches

**4 blueprint-writers (parallel, distinct files)** — one per source file carrying unmatched helpers:

- `dag-writer-flattening` → `Picard_FlatteningStratification.tex`: 11 `GenericFreeness.*` Nagata
  change-of-variables helpers (`T`, `T1`, monic-degree bookkeeping, `finSuccEquiv` compat). COMPLETE.
- `dag-writer-grassmannian` → `Picard_GrassmannianCells.tex`: 21 `Grassmannian.*` helpers (matrix/minor
  bookkeeping, double-localization plumbing, the three cocycle-Θ maps + image-matrix identity). COMPLETE.
- `dag-writer-quotscheme` → `Picard_QuotScheme.tex`: 11 helpers — the 7-member `IsRatHilb` rationality
  cluster (driving `lem:gradedHilbertSerre_rational`) + 2 power-series coeff lemmas + 2 `Scheme.Modules`
  schematic-support helpers. COMPLETE.
- `dag-writer-fbc` → `Cohomology_FlatBaseChange.tex`: `def:base_change_mate_inner_value`, wired into
  `lem:base_change_mate_fstar_reindex`. COMPLETE.

All writers wired the new blocks both ways via `\uses{}` (into their parent lemmas), so no new isolated
nodes were introduced.

**4 blueprint-clean (parallel, post-writer purity gate)** — each found and removed real Lean leakage the
writers introduced: raw Lean identifiers in prose (`finSuccEquiv`, `LocalizedModule`, `ofIdeals`, …), two
`% LEAN SIGNATURE` blocks (~40 lines) in QuotScheme, `iter-N`/"Seam N:"/"prover" history, and verbose
proof bodies. Mathematical statements were left intact. All COMPLETE.

**1 blueprint-reviewer (`dag-iter013`, whole-blueprint)** — verdict **PASS, no blockers**. Confirmed all
44 new helper blocks mathematically faithful, correctly wired, no residual Lean leakage; DAG structurally
clean. 2 INFO (a `\leanok` sync-phase note on `inner_value`; a harmless redundant statement-vs-proof
`\uses` edge on `codomain_read`) + 2 WARNING (both pre-existing deliberate staged gaps already tracked in
STRATEGY's open questions: `grassmannian_representable` prose ahead of its Lean skeleton, and the
RelativeSpec `IsAffineHom`/`IsAffine`-vs-`RepresentableBy` strengthening). None blocks completeness.

## leandag picture: before → after

| metric | before | after |
|---|---|---|
| blueprint nodes | 104 | 148 |
| lean_aux (unmatched Lean) | 44 | **0** |
| edges | 161 | 282 |
| isolated (no edges) | 44 (0 blueprint) | **0** |
| ∞-effort nodes | 0 | 0 |
| broken `\uses{}` | 0 | 0 |
| needs `\lean{}` | 0 | 0 |

The 28 blueprint→Lean unmatched `\lean{}` are unchanged and legitimate (19 Mathlib anchors + 9 project
forward-declarations the prover loop will create).

## Outcome

All six COMPLETE-gate criteria hold; reviewer PASS. Wrote `## Status: COMPLETE` to `DAG_STATUS.md`.
The roadmap is one cone, fully wired, every node finite-effort. Remaining work (14 Lean `sorry`s, 9
unproved-but-blueprinted blocks) is the prover loop's domain and does not block roadmap completeness.

## References

No new references needed; none unobtainable. TO_USER.md left as-is (current standing QUOT-encoding
notice, accurate).

## Subagent skips

- strategy-critic: STRATEGY.md was NOT modified this iteration (pure coverage-debt blueprinting of
  prover-generated internal helpers — no route swap, phase change, or new Mathlib gap). The prior
  (iter-012) strategy-critic verdict was SOUND with its FBC/QUOT challenges reconciled in-file and no
  live CHALLENGE/REJECT. Both skip conditions met.
