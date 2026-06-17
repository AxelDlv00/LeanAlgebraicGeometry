# iter-033 review

## Overall progress this iter
- **Total sorry**: 2 → 2 (no regression). Both frozen/superseded (`CechAcyclic.lean` dead `affine`,
  `CechHigherDirectImage.lean:679` frozen P5b). New file `TildeExactness.lean` is 0-sorry.
- **Build**: GREEN. `TildeExactness.lean` `lake env lean … EXIT 0`, diagnostics empty; all 3 new
  decls `lean_verify` axiom-clean `{propext, Classical.choice, Quot.sound}`.
- **Lanes planned 2, ran 1.** +3 axiom-clean decls (all Lane B / `TildeExactness.lean`); 0 new sorries.
- `archon dag-query`: **gaps = 0**, **unmatched = 4** (3 new TildeExactness helpers + dead
  `CechAcyclic.affine`).

## The headline: Lane B delivered its provable leaves; the 01I8 P3 gap is now a single named build
The new `TildeExactness.lean` (01I8 Route-P step P3) landed the right-exact half
(`tilde_preservesFiniteColimits := inferInstance`, `~` is a left adjoint), the flatness core
(`tilde_toStalk_map_injective` via `IsLocalizedModule.map_injective` on the public stalk
localization instances), and the kernel-route reduction
(`tilde_preservesFiniteLimits_of_preservesKernels` via the Mathlib lemma
`Functor.preservesFiniteLimits_of_preservesKernels`). The named target
`tildePreservesFiniteLimits` was correctly left ABSENT (no sorry), gated on a genuine geometry
build. The prover verified the ModuleCat-valued stalk route is a hard dead-end (Mathlib
module-privacy of `toStalkₗ'`/`stalkIsoₗ`/`stalkToLocalizationₗ`/`structurePresheafInModuleCat`).

## The one substantive finding — a self-contradictory `.lean` docstring (lean-auditor MAJOR)
The file's module docstring claims TWO obstructions remain; lean-auditor `iter033` showed the
second ("missing categorical glue: right-exact + preserves-monos ⟹ left-exact") is **false as
written** — the file's own `tilde_preservesFiniteLimits_of_preservesKernels` already supplies that
glue via the Mathlib kernel-route lemma. Only **obstruction 1** (the Ab-stalk germ-naturality
transport landing per-`f` `PreservesLimit (parallelPair f 0)`, ~100–200 LOC) remains. This matters
strategically: the planner should record the 01I8 P3 residual as ONE build, not two, and have the
next prover/refactor correct the docstring (a `.lean` edit outside the review agent's domain).
lean-vs-blueprint-checker `tilde-iter033` returned CLEAN (the 3 decls genuine, non-vacuous; the
named-target absence honestly documented in the blueprint `% NOTE` with no false `\leanok`).

## Process snag — a planned lane silently did not run
The plan dispatched two parallel mathlib-build lanes (Lane A toSheaf/`AffineSerreVanishing`,
Lane B tilde), but `provers-combined.jsonl` shows a **single** `session_start` and
`AffineSerreVanishing.lean` is byte-unchanged since iter-032. Lane A was blueprint-gate-cleared and
recipe-ready (`analogies/tosheaf-epi.md`), so this is a dispatch/parallelism shortfall, not a math
block. Surfaced HIGH in recommendations: re-dispatch Lane A unchanged and verify the loop launches
both provers. No iter was "wasted" mathematically, but a full lane of intended throughput was lost.

## This iter's analysis
- No forced mathematics; Lane B stopped cleanly on a named, real obstruction with a precise recipe.
- No Lean-side must-fix. The lone major is a misleading in-file docstring (planner-actionable, not a
  correctness defect — the code is sound and axiom-clean). One trivial minor (`(H :)` → `[H :]`).
- Only debt is coverage prose (4 unmatched) + the lost Lane A throughput.

## Markers / coverage
- **No manual marker edits.** No `\mathlibok` (new decls are project theorems, not bare re-exports),
  no `\lean{}` rename, no stale `\notready`. Both unbuilt named targets correctly lack `\leanok`;
  `sync_leanok` (iter=33, sha 49b3df2) removed 2 stale `\leanok`, consistent with both targets absent.
- **Coverage debt = 4 unmatched** (3 TildeExactness helpers + dead `CechAcyclic.affine`), listed for
  the planner.

## Blueprint-doctor
Clean — no orphan chapters, no broken `\ref`/`\uses`/`\proves`, no new `axiom` decls.

## Subagent skips
- (none) — both highly-recommended review subagents dispatched: lean-auditor `iter033`,
  lean-vs-blueprint-checker `tilde-iter033`.
