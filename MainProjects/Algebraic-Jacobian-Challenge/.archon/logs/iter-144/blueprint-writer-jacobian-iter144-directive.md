# Blueprint Writer Directive

## Slug
jacobian-iter144

## Target chapter
blueprint/src/chapters/Jacobian.tex

## Strategy context

Two iter-144 user-hint reframings drive this writer pass:

### (1) M3 COMMITTED to Route A (Picard scheme via FGA)

Per the iter-144 user hint (captured verbatim in STRATEGY.md § "Iter-144
user-hint M3 disposition (binding)" near L246–260): the autonomous loop
makes all strategic and routing decisions itself; no user-escalation
gate. M3 is COMMITTED to Route A — Picard scheme via FGA (~6500 LOC
midpoint per iter-123 audit). Route B (Symⁿ + Stein) is DROPPED from
active consideration; it remains documented as a historical
alternative only.

### (2) No upstream-PR-and-wait gate, no TO_USER escalation

The iter-126 user hint "do the work, no axioms; ~6500–9000 LOC may
not be that much for an AI" is CLARIFIED iter-144: it means the loop
writes missing Mathlib material directly in-tree when it encounters a
gap. NOT "post upstream Mathlib PRs as a project deliverable" or
"wait for upstream PRs before continuing". Upstream PR extraction is
an OPTIONAL downstream possibility — code written in-tree may later
be lifted into a Mathlib PR, but NOT a project commitment and NOT a
precondition for any in-tree work.

The "PR-and-wait + do-the-work" framing from iter-126 is dropped.
Specifically:
- Drop the "off-loop PR lane" framing for M1.d
  `kaehler_quotient_localization_iso`.
- Drop the "smallest PR-piece documentation lane" framing for
  `Mathlib.AlgebraicGeometry.RelativeSpec`.
- Drop the "PR-and-wait" branch in the M3 disposition.

## Required content

### Edit 1 (MUST-FIX from `blueprint-reviewer-iter144`): `\thm{def:positiveGenusWitness}` proof body Route A reframing

`Jacobian.tex` `\thm{def:positiveGenusWitness}` proof body
(approximately L429–438, per blueprint reviewer's line citation) still
presents M3 as:

> "currently OFF-CRITICAL-PATH per STRATEGY.md § M3 (user-escalation-
> pending on the M3 prioritisation; the iter-126 user hint endorsed
> `do the work, no axioms; ~6500–9000 LOC may not be that much for an
> AI`)"

This framing is stale. Per the iter-144 user-hint reframing now in
STRATEGY.md, M3 is COMMITTED to Route A (~6500 LOC midpoint); no
user-escalation gate exists. Re-cast the proof body to:

> M3 is committed to **Route A — Picard scheme via FGA** (per
> STRATEGY.md § M3 iter-144 disposition; ~6500 LOC midpoint per the
> iter-123 audit). The autonomous loop writes the ~6500-LOC Mathlib
> material directly in-tree; upstream PR extraction is an OPTIONAL
> downstream lift, not a project deliverable. M3 sits behind M2
> critical-path during the M2 wait window; whether to start Route A
> scaffolding (smallest entry: `RelativeSpec` functor at ~700–1100
> LOC) in parallel with M2 or strictly after M2 closes is a
> planner-level scheduling call, with an iter-150 mathlib-analogist
> trigger if cumulative M2.body-pile LOC exceeds 925 LOC without
> piece (i.b) closing OR M2.a body closure has not landed by iter-160.

### Edit 2 (MUST-FIX from `blueprint-reviewer-iter144`): Route B reframing as historical alternative only

`Jacobian.tex` § Route B (currently L286–311, per blueprint reviewer)
presents Route B (Symⁿ + Stein factorisation) as an active alternative
needing scaffold support. Per the iter-144 reframing, Route B is
DROPPED from active consideration; preserved as historical alternative
only.

Re-cast the Route B prose body:
- Preserve the mathematical content (Symⁿ + Stein factorisation
  decomposition; the three top-3 gating pieces at the iter-123 audit;
  the ~9000 LOC midpoint estimate).
- Add a header NOTE: "**Iter-144 disposition**: Route B is a
  historical alternative not pursued by the project. Preserved here
  for scholarly context only. Route A — Picard scheme via FGA — is
  the committed M3 route per STRATEGY.md § M3 iter-144 disposition.
  Estimates below are the iter-123 audit figures; the chapter does
  not re-cost Route B under current Mathlib snapshots."
- Inside `\thm{def:positiveGenusWitness}` proof body, replace any
  bullet listing both Route A and Route B as parallel "Mathlib-
  prerequisite routes" with a single bullet on Route A. Cite Route B
  as "historical alternative not pursued" in a single sentence at
  most.

### Edit 3 (Cleanup — stale `\notready` markers, already resolved)

Blueprint reviewer notes that the iter-143 PROGRESS.md watch criterion
#9 stale `\notready` flags at L389, L424 are already resolved (no
`\notready` matches in current `Jacobian.tex`). DO NOT touch these
lines; just confirm in your report that they ship clean.

### Edit 4 (Optional refresh — `\thm{def:positiveGenusWitness}` scaffold status)

The `\thm{def:positiveGenusWitness}` definition block names the Lean
target `AlgebraicGeometry.Jacobian.positiveGenusWitness`
(`Jacobian.lean:219–230` — scaffold landed iter-134 with `sorry`
body; M3 work). Confirm the block correctly identifies the body as
gated on M3 Route A closure. No content change unless the existing
prose is mathematically inaccurate.

## References

- STRATEGY.md § "Iter-144 user-hint M3 disposition (binding)" near
  L246–260 — the iter-144 user-hint absorption.
- STRATEGY.md § "Route A — Picard scheme via FGA (COMMITTED iter-144)"
  near L284–295 — the route's decomposition.
- STRATEGY.md § Off-critical-path "M3 (positive-genus witness): iter-144
  disposition" near L615–630 — Route A commitment + scheduling.
- `analogies/m3-route-audit.md` (iter-123 audit; the LOC-and-cross-utility
  evidence base for Route A commitment).

## Out of scope

- **DO NOT add or remove `\leanok` / `\mathlibok` markers anywhere.**
  Managed deterministically.
- **DO NOT touch `RigidityKbar.tex` / `AlgebraicJacobian_Cotangent_GrpObj.tex` /
  any chapter other than `Jacobian.tex`.** Those have their own
  writer dispatches.
- **DO NOT recompute LOC estimates** beyond what is already in
  STRATEGY.md / `analogies/m3-route-audit.md`.
- **DO NOT delete the Route B mathematical content**. Preserve as
  historical alternative; only reframe the framing.
