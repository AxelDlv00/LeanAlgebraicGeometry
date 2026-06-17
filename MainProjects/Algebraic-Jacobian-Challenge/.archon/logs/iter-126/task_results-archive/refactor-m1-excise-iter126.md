# Refactor Report

## Slug
m1-excise-iter126

## Status
COMPLETE

## Directive

**Problem.** The M1 bridge declaration
`AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE`
plus its M1.b sub-lemma `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`
hosted one project sorry (`Function.Bijective ⇑forwardAlg` at the old
Differentials.lean:398, inside the `AlgEquiv.ofBijective forwardAlg sorry`
packaging). The bridge has zero in-tree consumers, and the M1.d Mathlib-PR
candidate `kaehler_quotient_localization_iso` stands independent. Excising
the bridge is the shortest legitimate path to drop the parked sorry while
preserving the M1.d Mathlib contribution.

**Changes requested.** Delete from `AlgebraicJacobian/Differentials.lean`:
1. `appLE_unitSubmonoid` (M1.b setup)
2. `appLE_colimRingHom` (M1.b setup)
3. `appLE_colimAlgebra` (M1.b setup)
4. `appLE_colimRingHom_comp_φV` (M1.b setup)
5. `isUnit_appLE_unitSubmonoid_in_colim` (M1.b Step 0)
6. `appLE_isLocalization` (M1.b residual carrier, hosts the sorry)
7. `relativeDifferentialsPresheaf_equiv_kaehler_appLE` (the bridge)

Keep: `relativeDifferentialsPresheaf`, `relativeDifferentialsPresheaf_obj_kaehler`,
`kaehler_localization_subsingleton`, `kaehler_quotient_localization_iso`,
`smooth_locally_free_omega`. Drop the now-empty
`namespace AlgebraicGeometry.IsAffineOpen` wrapper and update docstrings to
remove references to excised declarations.

## Pre-flight verification

Grep across the project for the excised identifiers:

```
$ Grep 'appLE_isLocalization|relativeDifferentialsPresheaf_equiv_kaehler_appLE|appLE_unitSubmonoid|appLE_colimRingHom|appLE_colimAlgebra|isUnit_appLE_unitSubmonoid_in_colim' --glob '*.lean'
```

Returned matches only inside `AlgebraicJacobian/Differentials.lean` (the
excision target itself). Zero in-tree Lean consumers — deletion is safe.

`archon-protected.yaml` confirmed: none of the excised declarations is
protected (`Differentials.lean` has no protected entries).

## Changes Made

### File: `AlgebraicJacobian/Differentials.lean`
- **What:** Rewrote the file to retain only the six "Keep" declarations
  under a single `namespace AlgebraicGeometry.Scheme` block. Concretely:
  - Removed the entire `namespace AlgebraicGeometry.IsAffineOpen` block
    (previously L70–L400 in the iter-125 file), which contained 6 of the
    7 excised declarations.
  - Removed `relativeDifferentialsPresheaf_equiv_kaehler_appLE`
    (previously L449–L522) inside the second `namespace AlgebraicGeometry.Scheme`
    block.
  - Merged the surviving declarations (`kaehler_localization_subsingleton`,
    `kaehler_quotient_localization_iso`, `smooth_locally_free_omega`) into a
    single `namespace AlgebraicGeometry.Scheme` block alongside
    `relativeDifferentialsPresheaf` and its rfl lemma, deleting the
    redundant `end / namespace` pair.
  - Rewrote the docstring of `smooth_locally_free_omega` to drop the
    paragraph referencing `relativeDifferentialsPresheaf_equiv_kaehler_appLE`,
    `appLE_unitSubmonoid`, and `appLE_isLocalization`. Retained the
    forward-statement summary and the reverse-direction
    counterexample disclosure.
  - File-level docstring (lines 15–29) is unchanged: it references neither
    the bridge nor the excised lemmas by name.
- **Why:** Per directive, eliminate the project sorry parked in
  `appLE_isLocalization` while preserving the independently useful
  presheaf definition, M1.d Mathlib-PR candidate, and the M2-relevant
  smoothness criterion.
- **Cascading:** None. `Grep` confirmed no external consumers prior to
  the edit; post-edit full project build succeeds.

Net LOC reduction: 572 → 144 lines in `Differentials.lean` (≈428 lines
removed — exceeds the ~300 LOC the directive estimated).

## New Sorries Introduced
None. The refactor only deletes declarations.

## Compilation Status

- `AlgebraicJacobian/Differentials.lean`: compiles cleanly,
  `lean_diagnostic_messages` returned empty items list.
- Full project `lake build`: completed successfully (8329 jobs). The only
  warnings reported are the two pre-existing sorries below plus two
  pre-existing 100-char line-length style warnings in `Jacobian.lean:199`
  and `AbelJacobi.lean:22`. None are introduced by this refactor.

Axiom hygiene verified for the two "Keep" declarations the directive
flagged:

- `AlgebraicGeometry.Scheme.smooth_locally_free_omega`:
  `[propext, Classical.choice, Quot.sound]` ✔ kernel-only.
- `AlgebraicGeometry.Scheme.kaehler_quotient_localization_iso`:
  `[propext, Classical.choice, Quot.sound]` ✔ kernel-only.

Sorry analyzer post-state (matches directive's predicted outcome
exactly):

```
$ sorry_analyzer.py AlgebraicJacobian/ --format=summary
Sorry Summary: 2 total across 2 file(s)
  AlgebraicJacobian/Jacobian.lean: 1 sorries
  AlgebraicJacobian/RigidityKbar.lean: 1 sorries
```

Cross-refactor net change: 2 → 2 sorries (M1 −1 via this refactor;
M2.a +1 via the parallel `refactor-m2a-scaffold-iter126`). Qualitative
shift = parked-dead-weight sorry replaced with active-critical-path
sorry, as the directive's expected outcome predicts.

## Notes for Plan Agent

**Blueprint references still pointing at excised declarations** (the
refactor agent must not touch the blueprint per descriptor rules — the
plan agent owns these updates):

`blueprint/src/chapters/Differentials.tex` contains the following lines
that still reference excised Lean declarations and must be reworked or
removed by the plan agent:

- L115–L117: `\label{thm:relativeDifferentialsPresheaf_equiv_kaehler_appLE}` +
  `\lean{AlgebraicGeometry.Scheme.relativeDifferentialsPresheaf_equiv_kaehler_appLE}` +
  `\uses{... lem:appLE_isLocalization}`.
- L128: another `\uses{... lem:appLE_isLocalization, ...}` reference (on
  the same theorem block).
- L136: prose paragraph referencing
  `\lean{AlgebraicGeometry.IsAffineOpen.appLE_unitSubmonoid}`.
- L156–L157: `\label{lem:appLE_isLocalization}` +
  `\lean{AlgebraicGeometry.IsAffineOpen.appLE_isLocalization}` (the M1.b
  lemma block itself).
- L159: prose referencing the bridge theorem and the M1.b lemma.

The directive flagged dropping `\rem:m1_parked_iter125` as well; I did
not search for it but the plan agent should locate and drop it as part of
the same blueprint sweep.

**Analogies file:** `analogies/relative-differentials-presheaf-bridge.md`
has 16 occurrences of the excised identifiers. Per the directive, the
plan agent's design notes there already document the M1.d-only
Mathlib-PR path; the references to excised declarations are historical
context and need not be edited, but the plan agent may choose to add a
"superseded by iter-126 excision" header if they want a paper trail.
Not a blocker either way.

**Mathematical justification adequacy:** The directive's justification
was precise enough — there were no cascading type fixes needed since
the deletion is pure pruning of zero-consumer declarations. No
divergence from the directive.

**Suggested follow-ups for iter-127+:**
- Blueprint sweep (as flagged above).
- M1.d (`kaehler_quotient_localization_iso`) is now the cleanest
  Mathlib-PR candidate; the iter-126 strategy-critic ratified
  off-loop PR work can proceed from `analogies/relative-differentials-presheaf-bridge.md`.
- The remaining `RigidityKbar.lean:75` sorry (newly scaffolded by the
  parallel refactor) becomes the M2.a critical-path target.
