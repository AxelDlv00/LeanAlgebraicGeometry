# ajcr-review-rank-one-recovery: round 2 report

## Progress

- Repeated the binding Phase 0 audit and critical-root check before advancing the rank-one route. At `0732e370c0`, AJCR has 978 library modules, 959 rooted modules, 19 unrooted modules, 265000 total Lean lines, 261977 rooted Lean lines, 15 rooted `sorry` tokens (all pre-existing in `Challenge.lean`), and no rooted explicit `axiom` declaration.
- Commit `5584a1bec8` proves that a fibrewise-nonzero element of a finite projective constant-rank-one module is a global basis, and that two such elements differ by a unique unit. It also proves fibrewise nonvanishing for the localized tensor generator used by the rank-one Picard presentation.
- Commit `fa94070589` adds the immediate localized H0 consumer: two rank-one presentation generators over `Localization.Away f` differ by a unique unit.
- Commit `0732e370c0` roots and audits all four declarations through `Pic0CriticalPath` and the project root.
- Ground review classified the slice as a Phase 4 choice-independence feeder, not Phase 3 openness work. Commit `e522adb3af` moves the root-audit pin from `AJCR.review-plan.p3-rank-one-loci` to `AJCR.review-plan.p4-rank-one-iso` and records the correction. Phase 3 remains active; Phase 4 and Phase 7 remain pending.
- The AJC sibling audit found the existing finite-Galois quotient stack (`gluedQuotient`, `isGaloisQuotient_glued`) and the AJCR action/descent-data substrate. The generic finite-Galois representability producer, finite-stage `PicRepDatum`, filtered-colimit preservation, and `pic0_representableBy` consumer remain absent. No PDF fallback criterion fired.
- Task state remains `running`. Archived handoff `I-1919` now records the feeder-only result and the native O-linear zero-locus gate. Janitor review found 28 open inbox items, 23 non-protection items, and no inbox warning requiring a safe closure.

## Verification

- `DivisorFamilyMonoH1`: focused build passed in 20.43 s, peak RSS 6.90 GB.
- `Pic0RankOnePresentation`: focused build passed in 3 min 19.60 s, peak RSS 7.61 GB.
- `Pic0RankOneLocalDivisor`: focused build passed in 1 min 46.84 s, peak RSS 7.21 GB.
- `Pic0CriticalPath`: root build passed, 9227/9227 jobs, in 21.67 s, peak RSS 6.99 GB.
- LSP diagnostics were clean after each source edit, and an exact consumer example passed `lean_run_code`.
- `#print axioms` reports only `propext`, `Classical.choice`, and `Quot.sound` for each new declaration. No new `sorry`, axiom, vacuous typeclass, unrelated witness, or resource override was introduced.
- Minimal-hypothesis probes show every explicit hypothesis is used. Some large dependent probes timed out; all binders are directly consumed, and the root kernel build covers the declarations. An independent 300 s `lean_verify` of `tensorAwayGenerator_fibre_ne_zero` also timed out, while the focused and critical-root builds passed.
- The full project build still stops at the pre-existing unsolved equality in `AlgebraicJacobian/Picard/Pic0AdmissibleDivisorQuasiProjective.lean:178`; this run did not alter that file.

## Acceptance Boundary

This round earns feeder credit only. It does not prove Phase 3 openness, define `DivRankOneOpen`, construct `divisorOfRankOne`, prove `rankOneAbelIso` or an open immersion, establish the separably closed cover, descend a representer, prove `pic0_representableBy`, or construct `JacobianData`.

The localized theorem identifies generators only in the localized H0 tensor module. A direct attempt to transport the unit through the current base-change equivalence required about 1,000,000 heartbeats and exceeded the default 200,000-heartbeat budget because of dependent definitional equality; no override or over-budget theorem was committed.

## Next

Construct a base-change-compatible native O-linear comparison identifying the evaluation section with `datumSectionBaseChange`. Transport the unique-unit equality through that comparison, prove unit-rescaled sections have identical local equations and zero loci, and only then glue the choice-independent family-level `divisorOfRankOne`. After the rank-one route closes, port or extract the shared AJC finite-Galois quotient machinery into the AJCR descent producer returning both the descended scheme and its representation certificate.

## Workspace Hygiene

All task-owned source and state units are committed. The shared index retains a known stale deletion entry for the janitor-added p3 comment, so all commits in this round used fresh private indices. The remaining 215 tracked modifications and large untracked graph/snapshot population are unrelated concurrent or generated workspace state covered by `I-1922`/`I-1913`; they were not staged, reverted, or deleted.
