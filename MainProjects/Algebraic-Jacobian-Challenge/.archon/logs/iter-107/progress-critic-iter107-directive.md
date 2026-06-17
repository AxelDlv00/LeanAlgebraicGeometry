# Progress Critic Directive

## Slug
iter107

## Iter
107 (Archon canonical; the planner's narrative counter calls this iter-109)

## Active routes / files under review

For each active prover route the planner is considering for this iter's
prover work, ONE block:

### Route: `BasicOpenCech.lean :: h_loc_exact` (L1802; was L1783 pre-iter-108 partial scaffold)

- **Started at iter**: 106 (Archon; project narrative iter-108)
- **Iters audited**: 106 (one iter on this lane so far)

#### Sorry counts per iter
- Pre-iter-106 (Archon)/iter-108 (narrative) entry: BasicOpenCech 6 sorries (L1120, L1212, L1536, L1564, L1754, L1783).
- Post-iter-106 (Archon)/iter-108 (narrative) prover: BasicOpenCech 6 sorries (L1120, L1212, L1536, L1564, L1754, L1802 — the former L1783 sorry shifted +19 lines due to partial proof scaffolding).

Note: this lane is fresh (1 iter of data). The route was activated this iter as a pivot from the now-PAUSED L1120 lane.

#### Helpers added per iter
- iter-106 (Archon) / iter-108 (narrative): 0 new top-level helpers. Inside the body of `h_loc_exact` (local `have` block), 2 local `have`-style helpers landed:
  - `h_V_le_U (x)`: per-coord cover `V_x ≤ U` (~4 LOC).
  - `h_slice_eq (x)`: basic-open identity `V_x ⊓ D(f.1) = D(f.1|V_x)` (~5 LOC).
  Both are body-internal scaffolding, not exported declarations.

#### Prover statuses per iter
- iter-106 (Archon) / iter-108 (narrative): PARTIAL — Steps 1a + 1b of the analogist Q1 recipe landed cleanly (no whnf timeout, no discrim-tree blocker, no Pi.lift codomain issue — the blocker pattern from L1120 did NOT recur). Steps 1c-4 deferred to next iter. The prover's report names a concrete 10-step recipe for next iter's continuation.

#### Recurring blocker phrases
- None across this lane's 1 iter of data. The L1120 lane's recurring blockers ("anonymous-closure Pi.lift codomain", "discrim-tree pattern-unification", "whnf timeout") have NOT appeared on this new lane.

#### Planner's current proposal for this iter
Continue the same lane: assign a single prover round to close Steps 1c, 2, 3, 4 of the analogist Q1 recipe inline at L1802. Bounded ~100-110 LOC of glue (per-coord `IsAffineOpen.isLocalization_of_eq_basicOpen` adapter, `IsLocalizedModule.pi` invocation, `IsLocalizedModule.iso` repackaging, `Function.Exact.iff_of_ladder_linearEquiv` transport of `h_a₀_fun f`). Mathlib names verified by the prover this iter:
- `Function.Exact.iff_of_ladder_linearEquiv` [verified Step 4].
- `IsLocalizedModule.map_iso_commute` [verified Step 4 commutation].
- `Submonoid.map_powers` [verified Step 1c submonoid translation].
- `instIsLocalizedModuleToLinearMap...` [verified Step 2 adapter].
- `IsLocalizedModule.pi` [verified Step 3 — Mathlib `IsBaseChangePi:93`].

The recipe is structurally bounded; iter-108 demonstrated Steps 1a + 1b
land without any of the L1120 blockers.

### Route: `BasicOpenCech.lean :: cechCofaceMap_pi_smul` (L1120)

- **Started at iter**: 097 (Archon; project narrative iter-099)
- **Iters audited**: 097, 098, 099, 101, 103, 104, 105, 106 (Archon)
- **Status this iter**: PAUSED. Planner does NOT propose any prover work on this lane this iter.

#### Sorry counts per iter (audited from the past 8 plan rounds on this slot)
- iter-099 (narrative): 1 (target sorry at slot).
- iter-100 (narrative): 1.
- iter-101 (narrative): 1.
- iter-103 (narrative): 1.
- iter-105 (narrative): 1.
- iter-106 (narrative): 1.
- iter-107 (narrative): 1.
- iter-108 (narrative): 1 (PAUSED; preserved byte-for-byte).

#### Recurring blocker phrases on this lane (across the 7 PARTIAL iters)
- "anonymous-closure Pi.lift codomain" — appears in iter-099, iter-101, iter-103, iter-105, iter-106, iter-107 reports.
- "discrim-tree pattern-unification" — appears in iter-101, iter-103, iter-105, iter-106, iter-107.
- "whnf timeout" — iter-105, iter-106, iter-107.
- "eqToHom-vs-Pi.π transport" — iter-103, iter-105, iter-106, iter-107.

#### Planner's current proposal for L1120
NONE. The lane stays PAUSED (per your iter-106 STUCK verdict, ratified by
strategy-critic-iter106). Iter-107 partial-proof scaffold (`hRel'` +
`h_iter104`) preserved on disk as load-bearing partial progress for a
future re-attempt; planner is NOT assigning another prover round.

This route is included for completeness — please re-affirm the STUCK
verdict (no change to PAUSE binding) or, if signals have shifted enough
to merit revisiting, name it.

## Out of scope

Routes the planner is NOT considering this iter and does not want assessed:

- `Differentials.lean` (5 sorries, Phase B, OFF-LIMITS).
- `Modules/Monoidal.lean :: instIsMonoidal_W` (Phase C0, OFF-LIMITS).
- `Jacobian.lean :: nonempty_jacobianWitness` (Phase C3 deferred via JacobianWitness exit policy).
- `Picard/Functor.lean :: representable` (gated on C3).
- BasicOpenCech L1212, L1536, L1564 (deferred Mathlib-infrastructure-blocked).
- BasicOpenCech L1754 `g_R.map_smul'` (gated on L1120 — PAUSED upstream).
