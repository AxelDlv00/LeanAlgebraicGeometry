# Iter-206 (Archon canonical) — review

## Outcome at a glance

- **The "single-lane (Lane TS only) iter in which the iter-206 plan's TS flat/line-bundle
  pivot was put to the prover and its central premise was partially DISPROVEN: the prover
  removed the dead `monoidalCategory := sorry` instance + 2 off-path `MonoidalClosed`-route
  transport supplements (clearing the multi-iter contamination guard; net −1 sorry) and
  advanced `tensorObj_restrict_iso` from a bare sorry to TWO genuine Mathlib reduction steps
  (`restrictFunctorIsoPullback` + `sheafificationCompPullback` — the latter proven present in
  Mathlib, correcting an old absence claim) before a precisely-pinned residual; but it found
  that re-scoping to line bundles does NOT bypass the multi-file Mathlib gap after all — the
  base-change comparison MAP for the abstract-left-adjoint `PresheafOfModules.pullback` is
  itself absent (oplax structure / mate of the strong-monoidal pushforward), and flatness only
  upgrades an existing map to an iso, so the iter-206 plan's pre-committed reversal signal FIRED
  + lean-vs-blueprint-checker ts-iter206 independently returned the matching must-fix (the
  blueprint `lem:tensorobj_restrict_iso` flat-exactness sketch is NOT formalizable as written)
  + lean-auditor iter206 returned 0 new must-fix (the pivot is honest) + COE remained paused
  (3rd consecutive iter, escalation honored)" iter.**

- **Build GREEN; 0 `axiom` declarations** (blueprint-doctor confirms project-wide). The two
  removed transport defs left no dangling references (lean-auditor verified).

- **Sorry trajectory**: TS file **4 → 3** (net −1, a dead-instance removal — NOT a critical-path
  closure). Global ~81 → ~80. COE 3 → 3 (untouched). All other files untouched.

- **HARD BAR landings**: the directive's HARD-BAR cleanup item (remove the dead
  `monoidalCategory := sorry` instance) **MET**. The critical-path closure
  (`tensorObj_restrict_iso` → 4 iso lemmas → `addCommGroup_via_tensorObj`) **NOT met** — and the
  prover's honest finding is that it cannot be met by a prove lane at all without first building
  absent Mathlib infrastructure.

## The defining tension — the recession pattern has now spread to TS

The iter-206 plan adopted the flat/line-bundle pivot precisely to escape the
`MonoidalClosed (PresheafOfModules R₀)` wall, on the premise that line bundles make
`tensorObj_restrict_iso` "elementary flat-exactness already in Mathlib." It armed a reversal
pre-commitment. **That signal fired this iter**: the comparison map is absent (abstract left
adjoint, no sectionwise formula), and flatness is downstream of map *construction*, not a
bypass. So TS now joins COE in the **multi-file-absent-Mathlib-monoidal-structure regime** —
the same class of blocker, on a different object (`PresheafOfModules.pullback` oplax-monoidal
vs Stacks 02JK conormal localization).

This is the same *progress shape* that drove the COE escalation: each iter lands "the
foundational input" (here, two real reduction steps + a precisely-pinned residual) while the
visible critical-path sorry count does not move. The net −1 this iter is a dead-declaration
removal. The next planner must NOT autopilot another TS helper round — recommendations.md #1
lays out the (a)/(b)/(c) fork and recommends pivoting strategic focus to the Albanese-UP /
RR-free A.2.c excision (already the plan's TOP open question), with TS paused in the interim.

The gap is genuinely a *lift* not an *invention* (sectionwise `ModuleCat.extendScalars.Monoidal`
exists; `sheafificationCompPullback` discharges the sheafification half) — so option (a), a
dedicated `mathlib-build` lane, is viable if the USER directs Mathlib-infra work. Recipe in
`informal/tensorObj_restrict_iso.md`.

## Subagent findings landed

- **lean-vs-blueprint-checker ts-iter206** (`task_results/lean-vs-blueprint-checker-ts-iter206.md`):
  1 must-fix **F1** (blueprint `lem:tensorobj_restrict_iso` proof not formalizable as written —
  matches the prover's rebuttal exactly), 4 major (M1 missing `\lean{}` pin — **fixed this
  review**; M2 functoriality λ/ρ/α/β overpromise; M3 `tensorObj_lift_onproduct` scope; M4 four
  blocked blocks need pins + blocking notes). All blueprint-writer tasks for iter-207.
- **lean-auditor iter206** (45 files, `task_results/lean-auditor-iter206.md`): 0 new must-fix;
  iter-206 pivot honest; 2 major pre-existing excuse-comments (`RelPicFunctor.lean:266` TODO on
  `addCommGroup` sorry, HELD; `BareScheme.lean:220` `sorry` *instance* propagating via
  `inferInstance`, since iter-165); re-confirmed the 2 HELD RelPicFunctor placeholders; 1 minor
  stale-iter docstring in TS.

## Process correctness

- COE pause honored (3rd iter) — correct disposition; do not silently re-open (recommendations #3).
- The plan's armed reversal pre-commitment was correctly triggered by the prover's honest
  self-report; this review surfaces it as the headline rather than letting iter-207 autopilot.
- Markers: added the missing `\lean{}` pin + an F1 `% NOTE:` on `lem:tensorobj_restrict_iso`;
  did not touch `\leanok` (sync ran iter-206, added 0/removed 0).

## Environment note

`archon-informal-agent.py` again returned HTTP 401 (MOONSHOT key), matching memory
[[informal-agent-key-invalid]]. The prover fell back to Lean LSP search, which surfaced the key
`sheafificationCompPullback` lemma — so the fallback was effective this iter.
