# Progress-critic directive — iter-208

One active route this iter. Render a per-route verdict.

## Route: Lane TS — `Picard/TensorObjSubstrate.lean` (A.1.c.SubT, line-bundle tensor group law)

Strategy estimate (verbatim from STRATEGY.md `## Phases & estimations`):
- Iters left: **~3–5**
- Phase: this lane entered its current "build the tensor group-law substrate"
  phase around **iter-202** (so ~6 iters elapsed in-phase).

Signals, last 4 iters (TS-file sorry count is the critical-path metric; the
file has 3 critical-path sorries: `tensorObj_restrict_iso`,
`exists_tensorObj_inverse`, `addCommGroup_via_tensorObj`):

| iter | TS sorries | helpers/infra added | prover status | recurring blocker phrase |
|---|---|---|---|---|
| 204 | 4→4 | +3 axiom-clean helpers (`tensorObjIsoOfIso`, `tensorObj_unit_iso`, `restrictIsoUnitOfLE`); `tensorObj_isLocallyTrivial` body given | PARTIAL | "reduces to one ingredient `tensorObj_restrict_iso`" |
| 205 | 4→4 | +2 axiom-clean defs (`isMonoidal_W_of_whiskerLeft`, `monoidalCategoryOfIsMonoidalW`) | PARTIAL | "needs `MonoidalClosed (PresheafOfModules R₀)` — absent in Mathlib" |
| 206 | 4→3 | removed dead `monoidalCategory := sorry` + 2 transport lemmas; advanced `tensorObj_restrict_iso` 2 reduction steps | PARTIAL (net −1 = dead-code removal) | "flat/line-bundle pivot premise DISPROVEN — comparison map absent" |
| 207 | 3→3 | +3 axiom-clean (`restrictScalarsLaxε/μ/Monoidal`) | PARTIAL | "δ-route premise DISPROVEN: RingCat/CommRingCat ring-layer mismatch; `(PresheafOfModules.pullback φ).Monoidal` absent in Mathlib" |

Pattern to assess: each of the last 4 iters landed "the foundational input"
(a helper, a reduction step, or an axiom-clean instance) while the
critical-path sorry count held essentially flat (4→4→3→3, the one −1 being a
dead-code removal). Every iter the framing was "one more ingredient and the
iso closes"; every iter that framing was subsequently disproven. The blocker
has been *renamed* across iters (whiskerLeft → MonoidalClosed → comparison map
→ ring-layer mismatch) but the critical-path closure `tensorObj_restrict_iso`
has never moved.

## Planner's PROGRESS.md `## Current Objectives` proposal for iter-208

1 file: `Picard/TensorObjSubstrate.lean`. The planner intends a **structural
re-route** (NOT another "one more ingredient" helper round): abandon the
abstract-adjoint δ comparison-map route entirely; add line-bundle hypotheses
to `tensorObj_restrict_iso` and prove the iso sectionwise via free-rank-one
trivialisations (the map `f` is an open immersion, so pullback is sectionwise
restriction). A blueprint-writer rewrite of the proof precedes the prover
dispatch; the prover runs `prove` mode on the rewritten sectionwise route.

Question for you: is this route CHURNING/STUCK (and is the planner's proposed
structural re-route the right corrective TYPE, or is pause/pivot indicated)?
