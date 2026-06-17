# progress-critic directive — pc254

Assess convergence of the two active prover routes and sanity-check the iter-254 dispatch plan.

## Route 1 — `Picard/TensorObjSubstrate.lean` (Lane TS-cmp), phase A.1.c.sub
STRATEGY: Iters-left = ~5–9; phase entered ~iter-234 (D2′ arc); so ~20 iters elapsed in this phase.

Signals (last 4 iters), sorry-count = decls-with-sorry in file:
- iter-250: D2′ (`pullbackTensorMap_unit_isIso`) CLOSED axiom-clean (the one canonical close). sorry 2→1. status COMPLETE(partial-target).
- iter-251: +2 closed helpers (`pullbackValIso_hom_natural`, a rfl brick); D1′ authored. sorry 1→3. status PARTIAL.
- iter-252: +1 closed helper; whisker route DISPROVED (armed reversing signal fired); STEP A reduced to an instance-free element-level residual. sorry 3→3. status PARTIAL.
- iter-253: STEP A REVERSING SIGNAL fired NEGATIVE across 3 approaches (element-descent / whisker-calculus whnf-timeout / uniform-instance-helper synth-fail); STEP B (D1′) Square-1 closed + setup, blocked on a `Sheaf.val`/`.obj` spelling merge. sorry 3→3. status PARTIAL/BLOCKED.
- Recurring blocker phrase: "`restrictScalars (𝟙)`-over-sheafification `whnf` wall" / "`.val`-carrier friction" / "two defeq monoidal `≫` instance spellings". Same root that gated D2′ for 11 iters.
- Helpers added per iter: ~2 / ~1 / ~1 / ~2(partial). Target D1′ NOT closed across 251/252/253.

Planned iter-254 action for Route 1: NOT a blind re-dispatch. The named corrective (a cross-domain
mathlib-analogist consult on the ring-functor-spelling / `restrictScalars(𝟙)` root) is dispatched THIS
iter; the prover is then armed to do a **definitional spelling-normalization** (pin one ring-functor
spelling, strip `restrictScalars(𝟙)`) as the structural pivot — explicitly a DIFFERENT shape from the
3 disproven whisker/element/erw approaches. STEP B's single-spelling fix is concrete and prover-doable.

## Route 2 — `Picard/TensorObjSubstrate/DualInverse.lean` (Lane TS-inv), phase A.1.c.sub
STRATEGY: Iters-left = ~5–9 (shared phase); route entered ~iter-251.

Signals (last 3 iters):
- iter-251: +4 closed helpers; `dual_isLocallyTrivial` assembled (transitively partial). sorry 3→2. status PARTIAL.
- iter-252: `homLocalSection` CLOSED axiom-clean (load-bearing localSection incl. naturality); `homOfLocalCompat`→compiling scaffold. sorry 2→2. status PARTIAL.
- iter-253: sub-step (b) of `homOfLocalCompat` CLOSED (+2 helpers `topSectionToHom`); sub-step (a) BLOCKED on an `hf : HEq` signature diagnosed as unsatisfiable. sorry 2→2. status PARTIAL/BLOCKED.
- Recurring blocker phrase: "`hf` HEq between pullback-images, objects only isomorphic not propositionally equal".

CRITICAL NEW FINDING (changes the Route 2 read): the `hf` blocker is a **self-imposed throttle**. The
prover believed `hf` was a PROTECTED frozen signature; it is NOT (verified: `homOfLocalCompat` is absent
from `archon-protected.yaml`, and it has no compiling caller). Planned iter-254 action: re-sign `hf` to
the honest sectionwise form (both the prover report and the lean-vs-blueprint checker agree this makes
sub-step (a) direct/`rfl`), then close (a)+(c). This is an UNBLOCK, not another helper round.

## My proposed iter-254 `## Current Objectives` (2 files, M=2)
1. `Picard/TensorObjSubstrate.lean` — spelling-normalization structural pivot (analogist-armed) for STEP A + STEP B single-spelling merge → D1′.
2. `Picard/TensorObjSubstrate/DualInverse.lean` — re-sign `hf` sectionwise → close `homOfLocalCompat` (frontier base); attempt `dual_restrict_iso` Step-4.

## What I need from you
Per-route verdict (CONVERGING/CHURNING/STUCK/UNCLEAR) and the corrective TYPE if CHURNING/STUCK. Then a
dispatch-sanity check on the 2-file plan: is M=2 right, is either lane being re-dispatched against a
shape that already failed, and is Route 2's "re-sign hf then close" a sound unblock or am I missing a
reason the close still won't land? Flag if a genuinely independent 3rd lane (the scoped engine
`IsLocallyTrivial⟹IsFinitePresentation`, currently un-blueprinted) should be set up this iter to honor
the standing PARALLELISM directive, or whether deferring its blueprint to iter-255 is acceptable.
