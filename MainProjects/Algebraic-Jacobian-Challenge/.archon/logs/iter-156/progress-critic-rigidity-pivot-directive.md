# Progress Critic Directive

## Slug
rigidity-pivot

## What I need from you

This is a strategic-PIVOT iter. I am NOT proposing any prover assignment this iter
(mechanical gate). I need your fresh-context convergence verdict on the one route
that has been the project's critical path, to validate (or rebut) the decision to
PIVOT away from it. Specifically: confirm whether the differential rigidity route is
genuinely STUCK (so the pivot is warranted) or whether I am abandoning a route that
was actually converging.

## Active route under assessment

### Route: genus-0 rigidity via the differential `df=0` argument (chart-algebra)

The keystone is `rigidity_over_kbar` (`RigidityKbar.lean`), whose closure was, until
this iter, planned via "produce `df=0`, then the closed chart-algebra envelope gives
`df=0 ⟹ constant`".

Last-5-iters signals (whole-project bare-`sorry` counts and the keystone's state):

- iter-151: keystone `rigidity_over_kbar` open; KDM declared FALSE as a bare lemma, repaired by `[IsAlgClosed]` pivot. Global sorry ~9. Helpers added: KDM signature pivot.
- iter-152: keystone open; `[IsAlgClosed]` signature pivot landed (build green, no prover validation yet). Global sorry ~9→8 region.
- iter-153: keystone open; `constants_integral_over_base_field` CLOSED (chart-algebra envelope piece). Global sorry 9→8. Helpers: 0 new (closed an existing one).
- iter-154: keystone open; KDM (`mem_range_algebraMap_of_D_eq_zero`) CLOSED axiom-clean. Global sorry 8→7. The chart-algebra ENVELOPE is now fully closed — but it only supplies the *converse* `df=0 ⟹ constant`.
- iter-155: keystone `rigidity_over_kbar` STILL open. A cross-domain analogist consult PROVED `df=0` is irreducibly a global-sections fact (`df=0 ⟺ H^0(C,Ω_C)=0`) that the chart-by-chart envelope CANNOT detect — so the closed envelope does not, and cannot, close the keystone. `ChartAlgebraS3.lean` deleted (orphaned). Global sorry 7→3 (deletion). The keystone's actual blocker (df=0 production) needs either Serre duality (~3000–8000 LOC, absent) or the Pic⁰/Albanese engine. NO prover round closed the keystone in any of iters 149–155.

Prover statuses on the keystone over the window: no COMPLETE on `rigidity_over_kbar`; the closures (constants, KDM) were on the *envelope around it*, not the keystone itself; iter-155 surfaced that the envelope is structurally incapable of reaching the keystone.

Recurring blocker phrase: "`df=0` production — Serre duality + Ω_A globalisation; chart-by-chart KDM cannot detect a global-sections vanishing."

STRATEGY.md `Iters left` for this route's current phase (pre-pivot): "many · 0/it".
Phase entered (genus-0 rigidity keystone): ~iter-144 (chart-algebra pivot).

### Proposed corrective (for your assessment)

PIVOT: re-prove `rigidity_over_kbar` through Route A's Pic⁰/Albanese engine
(`Alb(genus-0)=0`), which is mandatory for the positive-genus object regardless, and
demote the differential route + chart-algebra envelope to an off-critical-path
fallback (kept in tree, not deleted). I want your verdict: is the differential route
STUCK (validating the pivot), or am I mis-reading a converging route?

## This iter's PROGRESS.md `## Current Objectives` proposal
NONE — mechanical hard gate (no prover-ready critical-path target post-pivot; Route
A blueprint is a sketch, gated by the HARD GATE until a blueprint-writer fleshes it).
So there is no objective-list dispatch-sanity check to run this iter.
