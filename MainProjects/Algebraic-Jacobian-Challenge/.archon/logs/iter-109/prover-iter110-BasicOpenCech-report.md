# AlgebraicJacobian/Cohomology/BasicOpenCech.lean — iter-110 (Archon iter-108)

## Outcome: RESOLVED (Phase A escape-valve, Option (i) — budget-deferral annotation applied)

Per PROGRESS.md spec, the trailing `sorry` inside the body of `have h_loc_exact`
(L1846) has been annotated with `-- DEFERRED (budget): ...`. No other edits.

## Committed lines (L1845–L1856)

```
        -- pre-rewrite at every cochain-degree node + ModuleCat.piIsoPi repackaging).
        sorry -- DEFERRED (budget): provable from Mathlib's
        -- IsLocalizedModule.{Away,pi,prodMap} +
        -- instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid;
        -- mechanization deferred at iter-108 (Archon canonical) due to
        -- letI-in-goal-type binder propagation friction (per-x algebra
        -- threading). The inline Steps 1a-1c scaffolding at L1786-L1834
        -- (h_V_le_U, h_slice_eq, h_pi_eq_inf', h_V_affine, h_isLoc)
        -- is preserved as inert infrastructure for a future re-attempt
        -- (parked behind C1 promotion + Phase B priorities). NOT a
        -- Mathlib gap.
      -- Step 5: apply `exact_of_isLocalized_span` to conclude global exactness of `K₀`.
```

## Compilation check

`mcp__archon-lean-lsp__lean_diagnostic_messages` with `severity=error`:
```
{"success": true, "items": [], "failed_dependencies": []}
```

File compiles. Only pre-existing style/linter warnings remain (unused-variable
notes, `show`-as-`change` style, `simp [π]` flexibility hints, maxHeartbeats
comment requests, plus the 6 `declaration uses 'sorry'` warnings).

## Sorry-count confirmation

- Total in file: **6** (unchanged from iter-110 entry state).
- Locations (verified via `grep -nE '(^|[^a-zA-Z_])sorry([^a-zA-Z_]|$)'`):
  - L1120 — `cechCofaceMap_pi_smul` (PAUSED; untouched per off-limits)
  - L1212 — substep (a) (deferred)
  - L1536 — (deferred)
  - L1564 — substep (a) for `s₀` (deferred)
  - L1754 — `g_R.map_smul'` (gated on L1120; deferred)
  - L1846 — `h_loc_exact` trailing sorry — **NOW ANNOTATED `-- DEFERRED (budget)`**

## Deviations from spec

NONE. Literal compliance.

- L1786–L1834 scaffolding: byte-for-byte preserved (untouched).
- L1835–L1845 prior comment block: LEFT INTACT (spec-permitted; both intact and
  shortened were acceptable, intact was chosen for archival fidelity).
- L1846: `sorry` token preserved with the prescribed 10-line `-- DEFERRED
  (budget): ...` annotation appended.
- L1857–L1858 closing (`rw [← hf_eq, ← hg_eq]; exact exact_of_localized_span …`):
  unchanged (formerly L1848–L1849; line numbers shifted by +10 due to the
  annotation lines).
- L1064–L1119 (PAUSED `cechCofaceMap_pi_smul` scaffold): untouched.
- No new axioms, no new declarations, no new helpers.

## Line-number note

The annotation added 10 lines of comment, so subsequent lines in the file are
shifted by +10 from the iter-110-entry numbering. Specifically:
- `-- Step 5:` comment now at L1856 (was L1847).
- `rw [← hf_eq, ← hg_eq]` now at L1857 (was L1848).
- `exact exact_of_localized_span …` now at L1858 (was L1849).
- The `exact h_transport h_K₀_exact` finale now at L1862 (was L1853).

For the next iter, the canonical post-shift L1846 reference remains accurate
because the annotated `sorry` token itself stayed on L1846; only lines *after*
it shifted.

## Next steps (for the plan agent)

- L1846 is now a labelled budget-deferral; do NOT attempt closure in the
  immediate next iter without C1 promotion + Phase B priorities settled (per
  strategy-critic-iter108 + progress-critic-iter108 directives).
- The end-state Mathlib-gap count remains **3** named gaps (`instIsMonoidal_W`,
  `h_exact`, `nonempty_jacobianWitness`); L1846 is the 4th *budget-deferred*
  sorry, distinct from the named Mathlib gaps.
- The inline Steps 1a–1c scaffolding (`h_V_le_U`, `h_slice_eq`, `h_pi_eq_inf'`,
  `h_V_affine`, `h_isLoc`) at L1786–L1834 is inert infrastructure ready for a
  future Steps 2–4 closure attempt.
