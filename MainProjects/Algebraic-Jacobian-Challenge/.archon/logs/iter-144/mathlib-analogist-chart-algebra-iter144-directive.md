# Mathlib-Analogist Directive

## Slug
chart-algebra-iter144

## Persistent file (output)

Update or create `analogies/chart-algebra-vs-bundled-iter144.md` with
your reasoning for future iters; also write your full report to
`task_results/mathlib-analogist-chart-algebra-iter144.md`.

## Context

The project is on the **iter-144 MANDATORY gate** (per iter-143
PROGRESS.md watch criterion #4 and STRATEGY.md "Iter-142+ scheduled
obligations") to re-evaluate the **chart-algebra-vs-bundled** decision
on piece (iii) before committing the in-tree scheme-level absolute
Frobenius build.

Background (read these analogy files first):

- `analogies/direct-chart-algebra-rigidity-ib-ic.md` (iter-140 verdict
  HYBRID): the chart-algebra alternative could potentially bypass
  scheme-level absolute Frobenius for piece (iii) by using ring-level
  `iterateFrobenius` on chart algebras directly. Chart-algebra route
  estimate ~450–900 LOC vs full in-tree route ~980–1970 LOC.

- `analogies/scheme-frobenius-piece-iii-scoping.md` (iter-141 verdict
  HYBRID — pivot does NOT fire): scheme-Frobenius scoping returned
  680–1370 LOC midpoint ~1025; chart-algebra alternative remains
  LOC-dominant for the iter-144 gate; named-gap-sorry alternative does
  NOT need elevation on LOC-pivot grounds.

Iter-143 NEW context the analogist should know:

- Piece (i.b) Step 2 d_map closed iter-142 substantively (3-step
  ALIGN_WITH_MATHLIB chase via `pushforward_obj_map_apply'` +
  `NatTrans.naturality_apply` + `relativeDifferentials'_map_d`).
- Piece (i.b) Step 2 d_app PARTIAL iter-143; iter-143 prover reports
  the residual is at the Lean-level type-coercion (`Eq.mpr` / `eqToHom`
  between pushforward composites `pushforward (fst).left.base ∘
  pushforward G.hom.base` vs `pushforward (G ⊗ G).hom.base`), NOT at
  recipe level. This may be **relevant** to your decision because
  the chart-algebra alternative would route piece (i.b) Step 2 through
  ring-level (not pushforward) lemmas and might dodge this specific
  type-coercion obstacle. Or it may be irrelevant if d_app's
  obstruction is the same flavor as anything chart-algebra would face.
- Cumulative (i.b)-side LOC measured iter-143: ~600 LOC at
  `Cotangent/GrpObj.lean:L350–L876` (well below 1000 LOC renormalised
  trigger cap).
- The strategy's "Iter-138 reframing to 'operationally defaulted,
  bounded revert cost preserved'" wording — under the iter-144 user-
  hint reframing dropping "PR-and-wait" framing, the chart-algebra
  decision is purely an LOC + tractability question, no longer
  "minimize PR exposure".

User-hint reframing this iter (iter-144): the loop writes missing
Mathlib material directly in-tree; the "off-loop PR lane" framing for
M1.d and `RelativeSpec` is dropped; M3 is committed to Route A; **no
user escalation gates anywhere**. This DOES NOT change the substance
of the chart-algebra-vs-bundled question (which is an LOC/tractability
trade-off and was never about PR exposure), but it removes the
"upstream-shaped MathlibPR" weight from the bundled scheme-Frobenius
side of the comparison.

## Question

Given:

(a) The chart-algebra alternative's iter-140 LOC envelope ~450–900 LOC
    bundled (piece (i.b) + (i.c) + piece (iii) all chart-side).
(b) The bundled in-tree scheme-Frobenius path's iter-141 envelope
    ~680–1370 LOC for piece (iii) alone (~+800–1500 LOC project-wide
    cumulative).
(c) Iter-143 piece (i.b) PARTIAL on d_app with type-coercion as the
    reported obstacle.
(d) Iter-144 user-hint M3 Route A commitment.
(e) Piece (i.b) Main `mulRight_globalises_cotangent` not yet at the
    prover's hands.

**Should the iter-144+ piece (iii) scheme-Frobenius commitment switch
to the chart-algebra alternative**, OR is the bundled in-tree scheme-
Frobenius path still the right choice?

Sub-questions:

1. Does the iter-143 d_app type-coercion difficulty (pushforward
   composite identification via `(fst).w` / `(snd).w` + `eqToHom`)
   foreshadow that piece (iii)'s scheme-level absolute Frobenius
   would face structurally similar type-coercion costs, OR is d_app's
   difficulty piece (i.b)-Step 2-specific (the universal-property
   route's nat-trans chase, NOT generic to scheme-level constructions)?

2. Under the chart-algebra alternative, does piece (i.b) Step 2 still
   need ITS OWN chart-side closure, or does the chart-algebra route
   re-shape piece (i.b)+(i.c)+(iii) jointly such that the iter-143
   d_app sub-sorry's analog is structurally different and possibly
   easier?

3. Per the iter-141 scheme-Frobenius scoping verdict's "named-gap-sorry
   alternative does NOT need elevation on LOC-pivot grounds at this
   iter" framing — has anything changed iter-143 that should make the
   named-gap-sorry alternative more attractive (it's the cheapest
   escape; per `mathlib-analogist-p1-hedge-iter138` it IS the cheaper
   escape hatch in an absolute sense), under the iter-144 user-hint
   reframing of in-tree work?

## Out of scope

- Do NOT re-do the iter-141 scheme-Frobenius scoping in detail; rely on
  its persistent file.
- Do NOT propose a route-pivot for piece (i.b) Step 2 d_app itself
  (that is a separate question; this directive is the chart-algebra
  vs bundled scheme-Frobenius re-evaluation for piece (iii)).
- Do NOT recommend named-axiom (the standing rule + iter-126 user-hint
  reaffirmation makes axioms out of scope).

## Verdict shape

Return one of:

- **COMMIT TO BUNDLED SCHEME-FROBENIUS** — the iter-141 verdict carries
  forward; piece (iii) builds in-tree at ~800–1500 LOC; no pivot
  iter-144.
- **PIVOT TO CHART-ALGEBRA** — chart-algebra alternative now dominates;
  piece (i.b)+(i.c)+(iii) all re-route through chart algebras; LOC
  delta and iter delta should be specified, plus the impact on
  iter-143 d_app PARTIAL on Route 1.
- **ELEVATE NAMED-GAP-SORRY ALTERNATIVE** — the project's zero-sorry
  PROVISIONAL end-state revises to named-gap on piece (iii); ~0 LOC
  for the gap declaration + scheme-Frobenius work is descoped.

Any other verdict (e.g. HYBRID with conditions) is fine if motivated.
Whichever you return, ground it in the iter-141 + iter-143 evidence
base.
