# Progress-Critic Directive — iter-036

Assess convergence per active prover route. Verdict per route: CONVERGING / CHURNING /
STUCK / UNCLEAR.

## Route 1 — `TildeExactness.lean` (01I8 step P3: build `tildePreservesFiniteLimits`, `~` exact)

Mode: mathlib-build (no-sorry invariant; "helpers added" is the progress signal, sorry
count stays 0 throughout).

Signals (last 4 iters):
- iter-032: file did not yet exist (lane started iter-033).
- iter-033: PARTIAL, +3 axiom-clean helpers (right-exact half, flatness core
  `tilde_toStalk_map_injective`, kernel→finite-limit reduction). Blocker phrase:
  "ModuleCat-valued stalk route DEAD (Mathlib privacy)".
- iter-034: PARTIAL, +2 helpers (germ-naturality CRUX `tilde_stalkFunctor_map_toStalk`,
  categorical reduction `tildePreservesFiniteLimits_of_toPresheaf`; refuted feared
  "obstruction 2"). Blocker phrase: "residual = R-linear σ_x packaging + jointly-reflecting
  stalk assembly".
- iter-035: PARTIAL, +4 helpers (sub-step A COMPLETE: `tilde_germ_algebraMap_smul`,
  `stalkMapₗ` R-linear, `stalkMapₗ_eq` identification, `stalkMapₗ_injective`). Blocker
  phrase: "jointly-reflecting assembly + `Scheme.Modules.toSheaf` does not exist".
- sorry count: 0 → 0 → 0 → 0 (mathlib-build). Named target `tildePreservesFiniteLimits`
  still absent (no pin).
- Status string: PARTIAL ×3.

Planner note for your judgment (you decide if it changes the verdict): the iter-035 blocker
"`Scheme.Modules.toSheaf` does not exist" is now established FALSE by the planner —
`SheafOfModules.toSheaf` exists in Mathlib with `PreservesFiniteLimits` + iso-reflection, so
iter-036 has a concrete unblock, and each prior iter closed a DIFFERENT named sub-piece
(right-exact → germ-naturality → R-linearity). iter-035 plan set a watchpoint: "a 3rd PARTIAL
on the SAME R-linearity/jointly-reflecting blocker → CHURNING." Judge whether the
blocker has genuinely shifted each iter (forward progress) or is the same wall reworded.

Strategy: 01I8 row entered ACTIVE iter-029; `Iters left` ≈ 4–6.

## Route 2 — `QcohRestrictBasicOpen.lean` (01I8 step P1a: `F|_{D(f)} ≅ ~M_f`)

Mode: mathlib-build. Signals:
- iter-035: NEW FILE, +5 axiom-clean (L1 both named targets `modulesRestrictBasicOpen`/
  `…Iso` + feeder `specAwayToSpec_eq`). Blocker phrase: "L2 `tilde_restrict_basicOpen` =
  tilde base-change compatibility, absent from Mathlib, multi-hundred-LOC". Status PARTIAL
  (first iter on this file).
- sorry: 0 (new file).

Strategy: same 01I8 row, `Iters left` ≈ 4–6.

## This iter's objectives proposal (for your dispatch-sanity check)
Likely 1 prover file: `TildeExactness.lean` (continuation, with the `SheafOfModules.toSheaf`
unblock). `QcohRestrictBasicOpen.lean` is a candidate to PAUSE this iter pending a Mathlib-route
re-mapping (a mathlib-analogist consult dispatched in parallel) that may show its L2 tilde
base-change wall is droppable. Flag if you think pausing Route 2 is premature, or if Route 1
should also pause.
