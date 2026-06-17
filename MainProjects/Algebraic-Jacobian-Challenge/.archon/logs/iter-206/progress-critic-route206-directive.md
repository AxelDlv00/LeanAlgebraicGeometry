# Progress Critic Directive

## Slug
route206

## Iter
206

## Active routes / files under review

### Route: Lane TS — `AlgebraicJacobian/Picard/TensorObjSubstrate.lean`

- **Started at iter**: 202 (TS scaffold landed; substantive prover work iter-203+)
- **Iters audited**: iter-202 to iter-205

#### Sorry counts per iter (this file)
- iter-202: 6 (scaffold stubs introduced)
- iter-203: 4
- iter-204: 4
- iter-205: 4

#### Helpers added per iter (this file)
- iter-202: 6 typed-sorry scaffold stubs (file created)
- iter-203: `tensorObj`, `tensorObj_functoriality` (closed 2 sorries; −2)
- iter-204: 3 axiom-clean helpers (`tensorObjIsoOfIso`, `tensorObj_unit_iso`,
  `restrictIsoUnitOfLE`); gave `tensorObj_isLocallyTrivial` a complete proof
  reducing it to ONE new sorry-bearing ingredient `tensorObj_restrict_iso` (net 0)
- iter-205: 2 axiom-clean helpers (`isMonoidal_W_of_whiskerLeft`,
  `monoidalCategoryOfIsMonoidalW`); cone reduced to ONE fact `whiskerLeft` (net 0)

#### Prover statuses per iter
- iter-203: DONE — closed `tensorObj` + functoriality (−2); HARD BAR met + bonus
- iter-204: DONE — 3 helpers, HARD BAR "not strictly met" (self-report); net 0
- iter-205: DONE — 2 helpers, mathlib-build invariant met (decomposition, no sorry
  added); net 0; cone reduced to `whiskerLeft`

#### Prover count per iter (files dispatched)
- iter-203: 2 (COE + TS) — TS 1 of 1 ready in its branch
- iter-204: 1 (TS only; COE paused)
- iter-205: 1 (TS only; COE paused)

#### Recurring blocker phrases
- "the entire/whole cone collapses to ONE Mathlib-absent ingredient" — appears in
  iter-204 (ingredient = `tensorObj_restrict_iso` / strong-monoidal-pullback) AND
  iter-205 (fact = `whiskerLeft`, needs `MonoidalClosed (PresheafOfModules R₀)`).
  The named "one ingredient" CHANGED between iters (restrict_iso → whiskerLeft):
  i.e. the "one more foundational input" receded once.
- "verified absent from Mathlib / multi-file infrastructure gap" — iter-205.

#### Deferral language per iter
- iter-204 sidecar: TS HARD BAR "not strictly met"; one new named ingredient.
- iter-205 sidecar/TO_USER: "TS is effectively substrate-complete" pending a chosen
  discharge path for the `MonoidalClosed` gap.

#### Route status changes per iter
- iter-203: active
- iter-204: active (sole productive lane)
- iter-205: active (sole productive lane)

#### Strategy estimate vs reality
- **`Iters left` from STRATEGY.md** (A.1.c.SubT row): "~3–5"
- **Elapsed iters in current phase**: 3 substantive (iter-203,204,205) + iter-202 scaffold
- **Phase started at iter**: 202

#### Planner's current proposal for this iter
The planner is weighing the iter-205 prover fork: (a) open a multi-file
`mathlib-build` sub-lane to build `MonoidalClosed (PresheafOfModules R₀)` then
discharge `whiskerLeft`; (b) supply `whiskerLeft` directly via a flatness-free
sectionwise argument (prover believes blocked); (c) pause TS as substrate-complete
(like COE). A mathlib-analogist api-alignment consult is in flight this iter asking
whether the full `MonoidalCategory (Scheme.Modules)` is even needed for the Pic
group law or whether a lighter invertible-sheaf idiom bypasses it. Tentative: do NOT
autopilot another helper round; the dispatch decision waits on the analogist verdict.

## PROGRESS.md proposal (this iter)

- **File count**: 0–1 (undecided pending the analogist verdict; possibly a TS
  mathlib-build continuation OR a design-pivot iter with no TS prover)
- **Files**: `Picard/TensorObjSubstrate.lean` (tentative, conditional on verdict)
- **Files with complete blueprint chapters and open sorries (ready but not dispatched)**:
  TS chapter is complete; COE/WD/RPF/FGA/T32 all HELD or PAUSED with concrete
  re-engagement gates (COE: USER escalation live; RPF: 2 must-fix weakened-wrong
  defs block dispatch; WD: USER sig-strengthening gate; FGA/T32: gated on RPF/COE).
  Per USER standing directive, NO A.3 work before A.2.c closes.
- **Dispatch cap (from --max-objectives)**: 10

## Out of scope
- Lane COE (`CodimOneExtension.lean`) — PAUSED pending USER escalation (no prover
  since iter-203; already STUCK + OVER_BUDGET from route204; no new trajectory).
- All HELD lanes (WD, RPF, FGA, T32, RCI) and all Route C files.
- A.3.* lanes — forbidden before A.2.c per USER standing directive.
