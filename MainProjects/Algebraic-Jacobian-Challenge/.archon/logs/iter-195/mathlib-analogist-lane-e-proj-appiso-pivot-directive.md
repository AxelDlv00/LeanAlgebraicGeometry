# Directive — mathlib-analogist `lane-e-proj-appiso-pivot`

## Mode

`cross-domain-inspiration` — Lane E has been STUCK for ~7 iters
(iter-188 → iter-194) on the same `Proj.appIso ⊤ .inv` evaluation
wall in `AlgebraicJacobian/AbelianVarietyRigidity.lean`. The
progress-critic iter-195 verdict is STUCK + OVER_BUDGET (2× the
~5-8 iter estimate; elapsed ~16). Another project-side helper at the
same wall from the same angle is not an acceptable corrective. The
plan agent needs structural analogues — Mathlib precedent for the
SAME categorical / algebraic shape solved in a DIFFERENT mathematical
area that the plan agent can port.

## Structural problem

In a graded ring setting, given a `Proj` scheme with a basic-open
`D₊(f)` for a positive-degree homogeneous element `f`, the project
needs to evaluate the inverse of the `appIso` morphism (the iso
between sections of the basic open and a localisation) on a
specific element. Specifically:

```
(Proj.awayι 𝒜 f).appIso ⊤ .inv : <evaluate> isLocElem f → <explicit element>
```

The structurally equivalent shape: the inverse of a canonical iso
`F(U) ≅ ι_!(...)` between sections on an open and a localised /
adjoint-image term, evaluated on a canonical generating element. The
existing project route attempts to chase this through the
`presheaf.map` + `appIso` definitional chain, which has been stuck
for 7 iters.

## Failed approaches

1. **iter-188 → 191**: direct `simp` + `rw` chains through
   `Proj.basicOpen_eq_basicOpenIso ▸ Proj.appIso_inv`
   definitional unfoldings. Lean term unification times out.
2. **iter-192**: factored through a named helper
   `iotaGm_chart1_appIso_eval` to isolate the same expression. Helper
   itself contains the same opaque sorry.
3. **iter-193 pivot**: re-routed through `IsOpenImmersion.lift_uniq`
   (the `iotaGm_r_1` factorisation). Outer morphism-level reasoning
   eliminated, but the INNER sorry on `appTop` evaluation is the
   same `Proj.appIso ⊤ .inv` chase.
4. **iter-194 narrowing**: structurally proven equivalent to the
   matching residual in `iotaGm_chart1_appIso_eval` — the shared idiom
   is now isolated, but no closure.

## Search radius

`wide` — any Mathlib domain.

## What I want from you

Return a ranked list of structural analogues. For each:

1. **Mathlib citation** — file path + declaration name(s).
2. **Technique used there** — what's the proof / construction
   strategy that made the evaluation tractable in Mathlib's domain?
3. **Concrete port suggestion** — how would the plan agent or a
   prover port the technique to the `AlgebraicGeometry.Proj` setting?
4. **Effort estimate** — port LOC + iter cost.

Candidate domains to consider (NOT exhaustive — find the best 5-10):

- Mathlib's `LocallyRingedSpace.Hom.appIso` (sister API on a
  different category).
- `ContinuousMap.basicOpen_eq` patterns in `Topology.Sheaves`.
- `Scheme.Spec.appIso` evaluation (analogous; the Spec API may have
  better-developed evaluation lemmas).
- `RingedSpace.PresheafedSpace.Hom.app` evaluation in
  `Geometry.RingedSpace.PresheafedSpace`.
- `SheafCondition.equalizer` evaluation patterns
  (`CategoryTheory.Sheaf`).
- `AlgebraicGeometry.AffineScheme.preservesFiniteColimits` patterns
  (might suggest the wrong direction is being chased).

But please don't restrict to those — the structural query is "how
does Mathlib handle 'evaluate the inverse of a canonical iso between
section presheaves'" generically, and the best analogue might be
elsewhere.

## What you SHOULD NOT do

- Do NOT try to close the project sorry yourself.
- Do NOT produce a `references/<slug>.md` — write your normal
  `analogies/<slug>.md` (per your descriptor).
- Do NOT recommend "wait for upstream Mathlib PR" as the corrective
  — the iter-200 sweep already covers that.

## Authority level

This consult is **decision-grade**: if you find a clean
cross-domain analogue with a defensible port, the iter-196 plan
agent will use it to route-pivot Lane E. If you find NONE, the iter-
196 plan agent will USER-escalate Lane E (the strategy-critic and
progress-critic both flagged this as a possible outcome).

## Output

Standard `analogies/lane-e-proj-appiso-pivot.md` plus task_results
report. Make the analogies file the persistent artifact; the
task_results report can summarise + reference it.
