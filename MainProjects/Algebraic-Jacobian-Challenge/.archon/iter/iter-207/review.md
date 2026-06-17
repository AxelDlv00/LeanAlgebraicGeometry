# Iter-207 (Archon canonical) — review

## Outcome at a glance

- **The "single-lane (Lane TS only) `mathlib-build` iter in which the iter-207
  plan's central premise — that the sectionwise `restrictScalars` lax instance
  was the SOLE remaining project-side ingredient for `tensorObj_restrict_iso`
  (per `analogies/mate207.md` + two consults) — was put to the prover and
  DISPROVEN: the prover delivered the lax instance axiom-clean (3 new
  kernel-clean decls `PresheafOfModules.restrictScalarsLaxε`,
  `restrictScalarsLaxμ`, instance `restrictScalarsLaxMonoidal`, implementing
  blueprint `lem:restrictscalars_laxmonoidal`), then found it does NOT unblock
  the iso because (1) the scheme module ring presheaf is `RingCat`-valued where
  there is no monoidal structure and the δ-route residual lands at that layer via
  `toRingCatSheafHom`, while `tensorObj` uses the `CommRingCat`-valued
  `X.presheaf` (different ring layers), and (2) at the CommRingCat level
  `pushforward φ` and `restrictScalarsLaxMonoidal` cannot be composed by instance
  resolution (`⋙`-vs-`forget₂` associativity mismatch); the plan's armed reversal
  pre-commitment FIRED; the prover built+removed a `pushforwardLaxMonoidal`
  attempt leaving no dead code; net sorry 80→80, TS 3→3, build GREEN, kernel-only
  axioms; COE paused (4th iter)" iter.**

- **Build GREEN; 0 `axiom` declarations** (blueprint-doctor confirms
  project-wide; no orphan chapters, no broken refs). The three new decls
  `lean_verify` to `{propext, Classical.choice, Quot.sound}`.

- **Sorry trajectory**: iter-206 **80** → iter-207 **80** (net 0). TS file
  3 → 3 (3 new axiom-clean decls added, 0 sorries closed). COE 3 → 3 (paused).
  All other files untouched.

- **HARD BAR landings**: the plan's PRIMARY target
  (`lem:restrictscalars_laxmonoidal` → axiom-clean instance) **MET**. The
  critical-path closure (`tensorObj_restrict_iso`) **NOT met** — and the prover's
  honest, well-evidenced finding is that it cannot be met without a structural
  re-route, not one further instance.

## The defining tension — the recession pattern has fully matured on TS

This is the THIRD consecutive iter the TS lane has landed "the foundational
input" while the critical-path sorry count held flat:
- iter-205: cone reduced to one fact (`whiskerLeft`), 0 sorries closed.
- iter-206: two real reduction steps + precisely-pinned residual, net −1
  (a dead-instance removal, not a closure).
- iter-207: the lax instance built axiom-clean, 0 sorries closed; the "sole
  ingredient" premise disproven.

Each iter the planner found a fresh "almost there" framing and dispatched again.
iter-207 is the cleanest case: the plan explicitly rebutted iter-206's pause/pivot
recommendation, committed to option (a) on `analogies/mate207.md`'s evidence, and
armed a reversal pre-commitment. **The pre-commitment fired** — this is the loop
working as designed, and it forecloses a fourth "one more ingredient" dispatch.
The next planner must pick a structural re-route or pause (recommendations.md #1).

The honest read: TS's blocker is the same *class* as COE's (a structural
ring-layer / monoidal-structure wall), but unlike COE it has a concrete
project-side escape that does not need absent Mathlib — option (b), adding
line-bundle hypotheses and proving the iso sectionwise via
`Scheme.Modules.Hom.isIso_iff_isIso_app`, sidesteps the abstract-adjoint
comparison map entirely. That is the recommended first choice, but it needs a
blueprint-writer round first (the δ-route proof is now `% NOTE`-flagged
not-formalizable).

## What was genuinely banked

`restrictScalarsLaxMonoidal` (+ ε/μ helpers) is permanent, reusable,
axiom-clean CommRingCat-level lax-monoidal infrastructure — the correct data
whatever route closes the iso. The reusable sectionwise-lift proof pattern is
recorded in the Knowledge Base. So the iter was not wasted: it produced real
infrastructure AND it definitively killed a false "one instance away" framing
that would otherwise have consumed further iters.

## Subagent findings landed

- **lean-auditor iter207**: `task_results/lean-auditor-iter207.md` — findings in
  `recommendations.md §0`.
- **lean-vs-blueprint-checker ts-iter207**:
  `task_results/lean-vs-blueprint-checker-ts-iter207.md` — findings in
  `recommendations.md §0`.

## Blueprint markers updated (manual)

- `Picard_TensorObjSubstrate.tex`, `lem:restrictscalars_laxmonoidal`: added
  `\lean{PresheafOfModules.restrictScalarsLaxMonoidal}` + a `% NOTE` flagging the
  disproven "sole ingredient" claim.
- `Picard_TensorObjSubstrate.tex`, `lem:tensorobj_restrict_iso`: added a
  `% NOTE` — the δ-route proof is not formalizable as written (ring-layer
  mismatch + composition wall); structural re-route required.

## Process notes

- COE pause honored (4th iter). Correct disposition; do not re-open silently.
- `sync_leanok` iter-207 (sha 90ee645e, +1 / −0): the added marker is the
  statement-block `\leanok` on `lem:tensorobj_restrict_iso` (decl exists with
  sorry body). The new `\lean` pin on `lem:restrictscalars_laxmonoidal` was added
  AFTER sync ran, so it marks next iter — expected latency, not an error.
- blueprint-doctor: clean (no findings).
