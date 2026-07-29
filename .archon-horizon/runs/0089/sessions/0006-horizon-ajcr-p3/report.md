The mutation after my last commit was the write to my personal memory directory, which lives outside the workspace ledger by design and is not committable there. Nothing durable to the repo was left uncommitted.

Confirmed clean:
- `AlgebraicJacobian/` and `AlgebraicJacobian.lean`: no changes against HEAD.
- `divrep.u2` row: no changes against HEAD (released unowned, correction box and three pins present).
- `scratch_p3/`: untracked and gitignored (`!!`), after I deliberately untracked the two files another lane's sweep had committed (`8fea785ed`).

The only post-commit write was `/home/axel/.claude-api/.../memory/MEMORY.md` plus two memory files — outside `$HORIZON_LEDGER_WORK_TREE`, so the checkpoint fired with nothing stageable.

## Progress

- `Picard/DivRepChartClassUnivZarLocal.lean` (new, rooted, 0 sorries): `ForallPrimeAwayCertified`, `divFamZarUnivOfForallPrimeAway`, `isLocallyCertified_of_isCertified_not_conversely`, `side_straddle_gives_chart_separated_pieces`. `lake build` EXIT=0 at HEAD (9307 jobs); all axiom-clean on `[propext, Classical.choice, Quot.sound]` against a control firing `sorryAx`.
- `AlgebraicJacobian.lean`: module rooted.
- Board: `divrep.u2` re-priced, released unowned, pinned `bde5fdc94` / `2473ecc37` / `c40a4078b`.
- Ledger hygiene: my two scratch probe files untracked (they had reached HEAD via another lane's sweep).

**Item and rank.** `AJCR.w4-rep.datum.dat-d.ddr.divrep.u2` — antecedent 3, `rep : (divFunctor C π g).RepresentableBy DivOver`. p1/p2 were both on antecedent 1, p4 on the degree side; nobody held antecedent 3, and `abelSigmaChart` *takes* `rep` as an argument, so it is upstream rather than a peer.

**State: advanced via a retraction, not closed.** `rep` undischarged, no gate cleared. My headline was false — `forall_not_isCertified_of_straddling` takes its base ring as a section variable, so it instantiates at the away ring with no bridge lemma. `work-reviewer` caught it (I-0980); I re-derived it in `Probe8` before accepting. A second claim (the tube route "measured shut") was also withdrawn — it audited a convenience wrapper while the assembler wants swallow-or-miss, where a disjoint piece is harmless. What survives: the refuting input narrows from global to **one-fibre** straddling.

**What changes another lane's plan.** The probe I first proposed was the wrong object: `piece_le` confines every piece for every seed. Since `localEquations` builds a pointed cover with `side` varying per point, the measurable question is whether two support points take opposite `side` values — now a theorem. Filed I-1000, I-1009, I-1010. Also fixed two defects of my own: four cited names sat outside my module's import closure, including the no-go the header is about.

## Issues

Three of my claims were refuted this session; all corrected at the site, with the withdrawn guard deleted rather than hedged. Unmeasured risk flagged in the file: if U2's class half routes through `ThetaGeneratorSeed`, it is on the chart-typed side of the I-0492 widening by construction, which would make the retraction structural rather than proof-level.

## Next

Measure whether the pointed cover realises both `side` values on the support, then test the I-0492 structural angle before another round on the away route.
