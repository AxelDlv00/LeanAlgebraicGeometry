# AlgebraicJacobian/Jacobian.lean — iter-182 prover

## Result: NO-OP (file is off-limits this iter)

`lake build` GREEN: 2 sorry warnings + 1 longLine style warning (line
326, on the *protected* `Jacobian` definition). No diagnostics
errors.

The file contains exactly two `sorry`-bodied declarations, BOTH
explicitly listed under PROGRESS.md `## Off-limits this iteration`:

1. `genusZeroWitness.key` (L236, term-level `have` inside the
   `isAlbaneseFor` body). Per PROGRESS.md L189: "Jacobian.lean
   `genusZeroWitness.key` (L… ) — gated on RR.4 chain (Pin 1 → Pin 2
   wrapper landed → Pin 2 body iter-183+ → Pin 3)."
2. `positiveGenusWitness` (L274, term-mode `sorry`). Per PROGRESS.md
   L196: "Jacobian.lean `positiveGenusWitness` — Route A cascade."

The `Jacobian` declaration carrying the longLine warning (L326) is in
`archon-protected.yaml` — re-signing/reformatting forbidden.

Per the lane assignment table in `iter/iter-182/objectives.md` the
seven active iter-182 prover lanes are A B D E F G I across OCofP,
GmScaling, RelativeSpec, AVR, QuotScheme, AuslanderBuchsbaum, and
RatCurveIso. `Jacobian.lean` is NOT one of the listed lanes;
PROGRESS.md L189-196 confirms the gating.

## Why no partial structural progress was added

Three honest moves were considered and rejected:

- **Decompose `key` into typed-sorry descent helpers.** Would add
  structure visible to the next prover (typed-sorry `pullback_to_kbar`,
  `descend_morphism_eq_via_faithful_flat`). REJECTED because (a) the
  planner explicitly defers this until Lane B's chart-bridge body
  lands and (b) the precise signatures of the descent helpers depend
  on `genusZero_curve_iso_P1` / `rigidity_genus0_curve_to_grpScheme`
  in-AVR consumption shape, which the iter-183 plan should choose
  jointly with the iter-182 Lane B/E outcomes. Adding helpers now
  would lock the next planner into a specific shape prematurely.
- **Reformat the longLine on L326.** REJECTED — the affected
  declaration `AlgebraicGeometry.Jacobian` is protected; the
  conservative interpretation of the protection rule forbids any
  whitespace reformatting that re-renders the signature literal.
- **Doc-only edits.** Considered, but the file's docstrings are
  already detailed and aligned with PROGRESS.md narrative; further
  doc edits would be churn without informational gain. The iter-167
  / iter-172 disclosures inside `genusZeroWitness`'s docstring are
  current.

## Gating chain (informational, for the iter-183 planner)

`genusZeroWitness.key` closure requires:

1. Lane B closes `gmScalingP1_chart_agreement_cross01` body (iter-182)
   ⟹ unblocks `morphism_P1_to_grpScheme_const` helper residuals.
2. RR bridge `genusZero_curve_iso_P1` closes (iter-183+ Pin 2 body
   + iter-183+ Pin 3) ⟹ enables `rigidity_genus0_curve_to_grpScheme`
   to be consumed kernel-clean over `k̄`.
3. `k → k̄` descent step: pullback `(C, A, f, P)` to `Spec k̄`,
   apply `rigidity_genus0_curve_to_grpScheme`, descend via
   `Flat.epi_of_flat_of_surjective` along `Spec k̄ → Spec k`. This
   is genuinely new substantive work; not gated on any out-of-file
   decision, but estimated ~60-100 LOC depending on Mathlib's
   pullback-functor + faithfully-flat-descent-of-equalities API.

`positiveGenusWitness` is the headline Route A obstruction (Albanese
existence in genus ≥ 1); per STRATEGY.md it sits at the back of the
~33-54 iter Route A cascade.

## Recommendation for iter-183 planner

Promote `genusZeroWitness.key` to an active lane only if Lane B
landed kernel-clean AND the Pin 2 body lane (`Scheme.Hom.poleDivisor`
body, iter-183) is being scheduled. The descent step is a natural
companion to the iter-183 Pin 2 body — both involve crossing
field-extension boundaries (Pin 2: K(ℙ¹)/K(C) finite extension; key:
k̄/k algebraic closure). If both are batched in the same iter, the
descent infrastructure can be designed in coordination with the
ramification-inertia infrastructure that Pin 2 uses.

If Lane B PARTIALs (cross01 body still sorry'd), defer `key` again.

## Blueprint status

Chapter `blueprint/src/chapters/Jacobian.tex` exists; no edits this
iter (provers do not edit blueprint per CLAUDE.md role specification).
The chapter's `\lean{genusZeroWitness}` / `\lean{positiveGenusWitness}`
pins remain unmarked (no `\leanok` since bodies are sorry — the
deterministic `sync_leanok` phase will handle markers between prover
and review).

## Lemmas / Mathlib discoveries — none this session

No search performed; the file's two sorries are off-limits and no
non-sorry Lean editing is permitted (protected sig).

## Dead ends — none this session

No attempts made.
