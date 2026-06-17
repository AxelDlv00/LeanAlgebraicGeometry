# progress-critic — directive (slug: route176)

## Mode

Fresh-context convergence audit on the active prover routes. Verdict per
active route: CONVERGING / UNCLEAR / CHURNING / STUCK.

## Important context — iter-175 prover phase was DAMAGED by external session-limit reset at 06:14 UTC

The Anthropic session-limit-reset window hit during the iter-175 prover
phase. Concretely (verified from `.archon/logs/iter-175/provers/*.jsonl`
session_end events):

- 5 of 10 prover lanes hit `summary: "You've hit your session limit ·
  resets 7:30am (UTC)"` after **1 turn / 0 ms / $0** — i.e. they died
  before the first tool call. Files for these lanes were NEVER CREATED.
  Lanes affected: `Picard/FlatteningStratification.lean`,
  `Picard/RelPicFunctor.lean`, `Picard/QuotScheme.lean`,
  `Picard/FGAPicRepresentability.lean`, `RiemannRoch/OCofP.lean`.
- Lane B `Picard/RelativeSpec.lean` and Lane D
  `RiemannRoch/WeilDivisor.lean` also died with the same 1-turn /
  session-limit summary.
- Lane A1 `Genus0BaseObjects/GmScaling.lean` started before the limit
  hit (06:00→06:14 UTC, 57 turns, $7.74 spent on exploration), but
  the session ended hitting the same "You've hit your session limit"
  summary at 06:14. Only 1 Edit was committed.
- Only 3 lanes ran to completion before the limit hit:
  Lane F `Albanese/AuslanderBuchsbaum.lean` (file landed, 6 sorries),
  Lane J `Albanese/Thm32RationalMapExtension.lean` (file landed,
  1 sorry), and `Picard/FGAPicRepresentability.lean` which DID run
  for 32 turns but the prover never used Write — it explored, hit the
  limit, never wrote the file.

**Interpretation guidance**: the 5 unstarted-file lanes are NOT prover
failures; they are an external-rate-limit failure mode. Treat their
"PARTIAL" / "INCOMPLETE" status as ENVIRONMENTAL, not a signal of
route-difficulty. They should be re-dispatched verbatim iter-176.

The Lane A1 14-minute exploration WITHOUT closure IS informative,
but the prover never got to actually apply the analogist-prescribed
recipe — they spent the session restructuring `gmScalingP1_cover_X_iso`'s
`congrHom` argument (a different approach from the analogist's
option (a) `simp only [Fin.isValue, Fin.zero_eta]` recipe).

## Active routes / files for iter-176 prover assignment

Route 1 — `Genus0BaseObjects/GmScaling.lean` (Lane A1)

Last 5 iters' signals:
| iter | GmScaling sorries (start→end) | Helpers added (top-level) | Prover status | Recurring blocker phrase |
|---|---|---|---|---|
| 171 | (file did not exist yet — Genus0BaseObjects.lean monolith) | — | — | — |
| 172 | (still monolith) — net `homogeneousLocalizationAwayIso` axiom-clean closure | +1 helper | COMPLETE-low | — |
| 173 | 9 → 8 in monolith (gmScalingP1_chart body closed; 2 new private helpers) | +2 helpers | PARTIAL-low | "Fin syntactic-mismatch" |
| 174 | 8 → 8 net (over_coherence STRUCTURAL but Step C +2 helper sorries) | +1 helper (`gmScalingP1_chart_PLB_eq`) | PARTIAL-low | "Fin syntactic-mismatch X 0 vs X ⟨0, ⋯⟩" |
| 175 | (post-G0BO-split) 5 → 5 NO CLOSURE | +0 closures (restructured `congrHom` arg only) | PARTIAL-low (session-limit damaged) | "Fin syntactic mismatch" — prover never applied option (a) before limit hit |

STRATEGY.md row: `Genus-0 rigidity — gmScalingP1 body chain`, current
`Iters left = ~2–4`, this route entered its current phase iter-171.
Velocity entry: `~80–150 LOC remaining · ~25/it`.

Last iter's analogist consult (`analogies/chart-bridge-structural-pivot.md`)
provides EMPIRICALLY VERIFIED option (a) recipe: insert `simp only
[Fin.isValue, Fin.zero_eta]` (resp. `Fin.mk_one`) at the start of each
branch in Step C of `gmScalingP1_chart_PLB_eq`. The 1-line insertion was
tested via `lean_multi_attempt` on the actual goal state and confirmed
to dissolve the Fin mismatch. **The iter-175 prover did NOT apply it** —
they did a `congrHom`-arg restructure (a DIFFERENT approach) before
running out of session budget. Iter-176 dispatch will instruct the
prover to apply option (a) AS WRITTEN before any exploration.

Route 2 — `Picard/RelativeSpec.lean` (Lane B)

Last 5 iters' signals:
| iter | RelativeSpec sorries (start→end) | Helpers added | Prover status |
|---|---|---|---|
| 171 | (file did not exist yet) | — | — |
| 172 | (file did not exist yet — API-529 killed Lane B) | — | INCOMPLETE-zero-edits |
| 173 | 0 → 6 (file landed, 6 pinned scaffolds) | n/a | COMPLETE (file-skeleton) |
| 174 | 6 → 5 (`QcohAlgebra` body landed) | +0 | COMPLETE-low |
| 175 | 5 → 5 (session-limit died before any work) | +0 | INCOMPLETE-environmental |

STRATEGY.md row: `A.1.a — RelativeSpec`, current `Iters left = ~3–5`,
phase entered iter-172. Velocity: `~200–400 LOC · ~50/it`.

Route 3 — `RiemannRoch/WeilDivisor.lean` (Lane D)

Last 5 iters' signals:
| iter | WeilDivisor sorries (start→end) | Helpers added | Prover status |
|---|---|---|---|
| 171 | (file did not exist yet) | — | — |
| 172 | (file did not exist yet, Lane C scaffold) | — | n/a |
| 173 | 5 → 4 (PrimeDivisor placeholder retired + `degree_hom` closed) | +1 helper (`degree_hom_apply`) | COMPLETE-low |
| 174 | 4 → 4 NET (`ofClosedPoint` body closed; pin shift) | +0 | COMPLETE-low |
| 175 | 4 → 4 (session-limit died before any work) | +0 | INCOMPLETE-environmental |

STRATEGY.md row: `Genus-0 RR.1 — Weil divisors`, current `Iters left =
~3–6`, phase entered iter-172. Velocity: `~250–450 LOC · ~30/it`.

Route 4 (umbrella) — 7 file-skeleton lanes: 2 landed (F + J), 5 died
to session limit (`FlatteningStratification`, `RelPicFunctor`,
`QuotScheme`, `FGAPicRepresentability`, `OCofP`). 5 to re-dispatch
verbatim iter-176.

## iter-176 prover proposal (file list, 8 lanes)

1. `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (Lane A1; option (a) STRICT one-shot)
2. `AlgebraicJacobian/Picard/RelativeSpec.lean` (Lane B; re-dispatch verbatim)
3. `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean` (Lane D; re-dispatch verbatim)
4. `AlgebraicJacobian/Picard/FlatteningStratification.lean` (Lane E; re-dispatch)
5. `AlgebraicJacobian/Picard/RelPicFunctor.lean` (Lane G; re-dispatch)
6. `AlgebraicJacobian/Picard/QuotScheme.lean` (Lane H; re-dispatch)
7. `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` (Lane I; re-dispatch)
8. `AlgebraicJacobian/RiemannRoch/OCofP.lean` (Lane K; re-dispatch)

## What I'm asking you for

For each of routes 1, 2, 3, 4: verdict (CONVERGING / UNCLEAR / CHURNING / STUCK).

For Route 1 specifically: take the environmental-damage interpretation
explicitly into account before judging STUCK — was Lane A1 actually
churning, or was iter-175 a no-op because the analogist recipe was
never applied? Recommend the iter-176 corrective accordingly.

Dispatch-sanity check: is the 8-lane proposal above reasonable, or
should I trim further to reduce session-limit re-strike risk?

Report at `.archon/task_results/progress-critic-route176.md`.
