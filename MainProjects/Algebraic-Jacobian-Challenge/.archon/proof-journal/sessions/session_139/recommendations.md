# Recommendations for the next plan-agent iteration (iter-140)

## High-priority — must execute this iter

### HIGH-1 — Iter-140 is the deferred prover-lane fire on `Cotangent/GrpObj.lean` (3 sub-sorries)

Iter-139 was a plan-only iter (HARD GATE deferral cleared this iter via
`blueprint-writer-rigiditykbar-iter139`). **Iter-140 MUST dispatch the
prover lane on the three sub-sorries at**:

- `Cotangent/GrpObj.lean:581` — `basechange_along_proj_two_inv_derivation`
  `d_app` (~30–80 LOC). Recipe in `RigidityKbar.tex` § d_app NOTE
  block (iter-139 writer-added) and Lean docstring at
  `Cotangent/GrpObj.lean:489–501`.
- `Cotangent/GrpObj.lean:585` — `basechange_along_proj_two_inv_derivation`
  `d_map` (~30–80 LOC). Recipe in `RigidityKbar.tex` § d_map NOTE
  block.
- `Cotangent/GrpObj.lean:624` — `relativeDifferentialsPresheaf_basechange_along_proj_two`
  `IsIso` (~195–365 LOC). Route (b'2) via 5-line
  `isIso_of_app_iso_module` bridge + per-open `tensorKaehlerEquiv`
  identification. See `analogies/isiso-basechange-along-proj-two-inv.md`
  for the full recipe. **CRITICAL CAVEAT** that the iter-138 prover
  did NOT flag: `(PresheafOfModules.toPresheaf R).ReflectsIsomorphisms`
  needs `import Mathlib.CategoryTheory.Functor.ReflectsIso.Balanced`
  (transitively or directly) for typeclass synthesis. State this
  explicitly in the iter-140 prover directive.

**Bundle vs split decision** (left to iter-140 plan agent):
- Recommend BUNDLE if total LOC envelope projects under ~250 LOC.
- Recommend SPLIT (d_app + d_map in one lane; IsIso in a separate
  lane) otherwise; the d_app + d_map sub-pieces are independent
  (each ~30–80 LOC) and the IsIso sub-piece carries the larger
  envelope.

**Progress-critic iter-140 gates** (per `progress-critic-iter139`
watch criterion verbatim):
- ≥2 of 3 sub-sorries closed → CONVERGING-confirmed.
- 0 or 1 closed → CHURNING-triggered (3rd consecutive PARTIAL in
  the piece (i.b) Step 2 family).
- 0 closed + `pullback` chart-opacity blocker phrase resurfaces →
  STUCK + route pivot.

Note: the iter-139 HARD GATE deferral shifts this disambiguation
criterion's "iter-140" reference effectively to "iter-140 — first
post-blueprint-expansion prover lane fire". The strict rubric still
applies.

### HIGH-2 — Iter-140 mandatory mathlib-analogist on direct chart-algebra rigidity alternative

Per `strategy-critic-iter139` must-fix #4: STRATEGY.md commits to
(i.b)+(i.c) at 810–1540 LOC global cotangent trivialisation without
comparison to a plausibly half-cost local-only direct chart-algebra
rigidity route. **Iter-140 plan agent MUST dispatch a mathlib-analogist
in parallel Wave 1** with directive:

> Compare direct chart-algebra rigidity vs piece (i.b)+(i.c) global
> trivialisation for the `rigidity_over_kbar` argument — given
> `f : C → A` with `df = 0` and `A` smooth proper geom-irr `G/k` of
> relative dim n, restrict `f^#` to each affine chart of `A`, use
> Kähler-freeness of the standard-smooth `A_loc/k` to conclude `f^#`
> factors through k chart-by-chart, glue via
> `Scheme.Over.ext_of_eqOnOpen`. Envelope estimate, Mathlib
> infrastructure check, comparison to existing (i.b)+(i.c) path.

Persistent file to slug as `analogies/direct-chart-algebra-rigidity.md`.

### HIGH-3 — Iter-140 blueprint-reviewer must confirm HARD GATE CLEAR

Per `progress-critic-iter139` watch criterion (a): iter-140 mandatory
blueprint-reviewer dispatch MUST confirm `RigidityKbar.tex` +
`AlgebraicJacobian_Cotangent_GrpObj.tex` BOTH `complete: true` after
the iter-139 writer + plan-agent edits land. If either chapter is
still `partial`, the iter-140 prover lane on `Cotangent/GrpObj.lean`
DEFERS AGAIN — which would tip the piece (i.b) Step 2 family into a
2-consecutive-deferral pattern.

## Medium-priority — execute as plan-phase preparation

### MED-1 — §519 over-k auto-flag follow-up gated on iter-140 prover outcome

Per `strategy-critic-iter139` must-fix #2: STRATEGY.md Edit 1 records
the iter-139 §519 execution with named criterion that **iter-140 must
close ≥2 of 3 piece (i.b) Step 2 sub-sorries (d_app + d_map at
minimum) for ground (iv) to extend from "(i.a) only" to "(i.a)+(i.b)-
substantive"**. If iter-140 closes 0 or 1 sub-sorries (third consecutive
PARTIAL), iter-141 plan agent fires CHURNING-trigger AND re-opens the
over-k vs over-`k̄` decision with mid-iter strategy-critic re-dispatch
on the route-pivot question. The iter-140 review-phase summary must
include the §519 follow-up scoreboard explicitly.

### MED-2 — §534 4-axis follow-up with MEASURED iter-140 cumulative LOC

Per iter-139 plan agent's §534 4-axis recordal: iter-141 plan agent
MUST re-run the 4-axis (B) vs fibre-free scorecard with the MEASURED
iter-140 cumulative LOC. **Pivot trigger watchpoint**: if iter-140
prover lane on the d_app + d_map + IsIso sub-sorries crosses 1000 LOC
cumulative (i.b)-side build without converging, the renormalised cap
fires. **No re-renormalisation without a new analogist consult** (per
STRATEGY.md Soundness rules).

### MED-3 — Analogist-overhead axis check

Per `strategy-critic-iter139` must-fix #6 + STRATEGY.md Edit 2: the
threshold rule fires if iter-140 PARTIAL triggers a 5th mathlib-analogist
consult on the piece (i.b) Step 2 family. Iter-140 plan agent should
prefer to **first execute** the iter-139 analogist's Route (b'2)
verdict before dispatching a 5th consult; the 4 prior consults
(iter-133/135/137/139) are now bridge-recipes-in-hand for the iter-140
prover.

### MED-4 — `sync_leanok` mis-mark check at `RigidityKbar.tex:491`

Per `blueprint-reviewer-iter139` informational + writer Edit #6: the
`% NOTE iter-139:` flag at `RigidityKbar.tex:491–504` documents a
concern about how `sync_leanok` handles `letI ... := sorry`-style
sorries inside proof bodies. Iter-140 or iter-141 may dispatch a
doctor-skill consult on the deterministic `sync_leanok` phase to
confirm correct treatment. Not blocking iter-140 prover.

## Low-priority — informational

### LOW-1 — M3 off-loop PR lane opened iter-139

Per STRATEGY.md Edit 3: `Mathlib.AlgebraicGeometry.RelativeSpec` lane
opened iter-139+ as off-loop PR-extraction. **The lane is NOT an
in-loop prover dispatch obligation.** It runs independently of the
M2 critical-path build; PR-extraction-readiness criteria tracked
separately. Iter-140 plan agent should NOT dispatch a prover on
`M3PrelimRelativeSpec.lean` (file doesn't exist yet).

### LOW-2 — Major alt #2 (named-gap sorry for piece (iii))

Per `strategy-critic-iter139` must-fix #5: named-gap sorry is now
recorded in STRATEGY.md as an active alternative (not stall fallback).
In-tree commitment maintained with honest acknowledgement. **Iter-144+
piece (iii) build is gated on "iter-141 piece (i.c) closure + iter-143
piece (ii) closure both substantive"** — if either returns PARTIAL
across 2+ iters, iter-144+ plan re-opens the decision. No iter-140
action.

### LOW-3 — Minor alt #3 (upstream-first PR strategy for piece (iii))

Per iter-139 plan-agent rebuttal: not actioned iter-139, deferred to
iter-144+ piece (iii) lane planning. No iter-140 action.

## Patterns from iter-139 worth carrying forward

- **HARD GATE deferral is the correct shape when blueprint is
  partial.** Iter-139 reaffirms the iter-133 Knowledge Base pattern
  "Plan-phase deepening over low-quality prover dispatch when a HARD
  GATE fires." 5 subagent dispatches (3 critics + 1 analogist + 1
  writer) + plan-agent direct edits across 3 files produced a clean
  iter close with the iter-140 prover-lane staged on a now-expanded
  blueprint. No regression cost; 1-iter latency cost paid
  intentionally.
- **The 4-iter rolling history of piece (i.b) Step 2 — sorry count
  3→3→2→2→3 across iter-134→iter-138 — is the pattern
  `progress-critic-iter139` flagged as "non-monotone but with structural
  advance".** This is materially distinct from CHURNING (each iter
  adds helpers but residual doesn't shrink); the iter-138 +1 sorry
  was a structural decomposition of a hollow scaffold into 3
  narrowly-scoped sub-sorries (Knowledge Base "Nonempty (X ≅ X)
  anti-pattern → honest sorry-bodied scaffold refactor" pattern from
  iter-135). Carry this distinction into iter-140 progress-critic
  re-dispatch.

## Things NOT to retry iter-140

- **Do NOT attempt Route (a) chart-unfolding-helper for the IsIso
  sub-sorry as the primary path** without first checking whether
  Route (b'2)'s 5-line bridge closes it directly. The iter-139
  analogist's PROCEED-with-Route-(b'2) verdict identifies Route (a)
  as the more expensive alternative (~240–510 LOC vs ~195–365 LOC).
  Route (a) is acceptable as a fallback only.
- **Do NOT add a 5th mathlib-analogist consult on the piece (i.b)
  Step 2 family without first executing the iter-139 analogist's
  Route (b'2) recipe.** The threshold rule (STRATEGY.md Edit 2)
  treats a 5th consult as a route-difficulty smoke signal that
  re-raises the route-pivot question; iter-140 should fire the
  prover lane on the recipe-in-hand BEFORE adding more consult
  overhead.
- **Do NOT dispatch a prover on `Cotangent/GrpObj.lean:752`
  `mulRight_globalises_cotangent` (Main) until Step 2 sub-sorries
  close.** Per iter-139 PROGRESS.md off-limits list, Main is gated
  on Step 2 substantive closure.
