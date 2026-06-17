# Progress-critic directive — iter-030

Assess convergence per active route. Render CONVERGING / CHURNING / STUCK / UNCLEAR
per route, with a named corrective for any CHURNING/STUCK.

## Route FBC — `AlgebraicJacobian/Cohomology/FlatBaseChange.lean`

Goal: close the `_legs` eCancel assembly (`base_change_mate_fstar_reindex_legs`, sorry @1446),
which cascades to `gstar_transpose` (@1818) → the FBC affine lemma.

Last 4 prover rounds (signals):
- R1: 5 sorries; broke a 4-iter "literal-form lock" via `erw`. No sorry closed. Status PARTIAL.
- R2: 5→4. Closed `inner_value_eq` (cascade). Helpers added: 0 new (consolidation). Status PARTIAL.
- R3: 4→4. No sorry closed. Diagnostic round: established the keyed-rewriting family is conclusively
  dead (rw/simp/erw/conv/set/dsimp ALL fail vs the `X.Modules` instance diamond). Status PARTIAL.
- R4 (this round): 4→4. No sorry closed. Final diagnosis: the crux requires ONE hand-built ~100–150
  LOC proof term closed by a single `exact`/`convert`; all genuine-content helpers already exist;
  the sole remaining work is the assembly chain (validated one `.trans` link at a time). Riders:
  removed dead `hpfc`, de-privatized 3 atoms, fixed 2 docstrings (all compile). Status PARTIAL.

Recurring blocker phrase: "X.Modules instance diamond"; now refined to "single hand-built exact
term, ~6 nontrivial factors, ~5 KB goal states — engineering grind, not a missing ingredient."
Helpers added per round: ~1, 0, 0, 0 (riders only the last two rounds).

Strategy estimate: phase FBC-A, `Iters left` = 2–4; entered at iter-018; ~12 iters elapsed.

Planner's iter-030 intent for FBC: STOP re-dispatching "build the assembly" verbatim. Dispatch
**effort-breaker** to split the assembly into per-`.trans`-link clean-term equality sub-lemmas
(each provable in isolation, single instance ⇒ no diamond), then a fine-grained prover fills them.
Assess whether this is a genuine corrective vs another reworded re-dispatch.

## Route QUOT — `AlgebraicJacobian/Picard/QuotScheme.lean`

Goal: gap1 `isIso_fromTildeΓ_of_isQuasicoherent` (keystone; also unblocks GF-G1).

Last 3 prover rounds:
- R1: +2 axiom-clean helpers (G1-core reduced to the single lemma gap1; engine in-file).
- R2: +1 axiom-clean (`exists_isIso_fromTildeΓ_basicOpen_cover` partial). gap1 not closed.
- R3 (this round): +1 axiom-clean (`exists_finite_basicOpen_cover_le_quasicoherentData`, the
  topological finite-cover front). gap1 NOT closed — precise blocker identified: the per-element
  presentation **transport** `(M.over (q.X i)).Presentation → M|_{D(r)} : (Spec R_r).Modules` has
  ZERO Mathlib support (no restriction-to-basic-open functor, no over↔pullback bridge); even
  *stating* `q.presentation i` triggers a synthInstance timeout on the slice site. All 3 routes
  (cover-transport / stalk / section-MV) funnel through this transport.

Blocker phrase: "presentation transport across `D(g) ≅ Spec R_g`"; "slice instances time out."
Helpers added per round: 2, 1, 1. sorry count unchanged (4 protected stubs throughout).

Strategy estimate: phase QUOT-defs, `Iters left` = 4–7; gap1 sub-build is within it.

Planner's iter-030 intent for QUOT: the transport is a genuine multi-iter sub-build; dispatch a
**mathlib-analogist** consult on the route shape FIRST (the synthInstance timeout signals a wrong
shape), then blueprint the transport, then mathlib-build it. Assess whether QUOT is narrowing
(precise blocker each iter) or churning.

## Route GR — `AlgebraicJacobian/Picard/GrassmannianCells.lean`

Goal: `def:gr_glued_scheme` — close `cocycle` field (ring identity `Φ=id`), then `theGlueData` +
`Grassmannian.scheme` (all NEW declarations; the file has the HANDOFF recipe in-comment).

Last 2 prover rounds:
- R1: +4 axiom-clean (`t'`, `t_fac`, ring identity; reduced `cocycle` to the ring identity `Φ=id`).
- R2 (this round): **NO task result, no edits committed** — the prover produced nothing on the
  `cocycle` ring-identity + glued-scheme target.

The cocycle target is a "ready" rotated ring-identity (recipe in-file: `ringHom_ext` + reuse
`cocycle_imageMatrix_eq`); ~30–50 LOC. A no-output round on a ready target is the concern.
Strategy estimate: phase QUOT-repr / GR-glue, CONVERGING last iter.

Planner's iter-030 intent for GR: re-dispatch mathlib-build with a sharpened directive — prove the
RING identity `Φ=id` as a STANDALONE named lemma first (pure ring, no diamond), then assemble the
GlueData. Assess: is one no-output round STUCK yet, or proceed-and-watch?

## Planner's PROGRESS.md proposal for iter-030 (dispatch-sanity check)

3 files, one prover each: `FlatBaseChange.lean` (FBC, fine-grained on decomposed pieces),
`QuotScheme.lean` (QUOT, mathlib-build on transport), `GrassmannianCells.lean` (GR, mathlib-build
cocycle). All import-independent.
