# lean-vs-blueprint-checker — Differentials review124

## Slug

differentials-review124

## Lean file

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/AlgebraicJacobian/Differentials.lean`

## Blueprint chapter

`/home/archon/FormalizationProjects/Algebraic-Jacobian-Challenge/blueprint/src/chapters/Differentials.tex`

## What changed this iter (for orientation only — do not bias the audit)

The iter-124 prover made a single substantive Edit inside the body of
`AlgebraicGeometry.IsAffineOpen.appLE_isLocalization` at L282:
promoted `forward : Localization M →+* A_colim` to an explicit
`AlgHom` (`forwardAlg`) with the `commutes'` field closed in-body via
`RingHom.congr_fun h_fwd_comp`, then reduced the residual single
`sorry` to `AlgEquiv.ofBijective forwardAlg sorry` (the new `sorry`
lives at L398 and is the `Function.Bijective ⇑forwardAlg` claim).

The iter-124 plan also made inline blueprint edits to
`Differentials.tex`:
- L138 prose hedge tightened (replaced "via `IsLocalization.of_le`"
  with the analogist-verified Step-4 closer
  `IsLocalization.isLocalization_of_algEquiv`).
- L165 + L175 same hedge update.
- Three missing `\lean{...}` references added (`appLE_unitSubmonoid`,
  `isUnit_appLE_unitSubmonoid_in_colim`, `appLE_colimRingHom_comp_φV`).
- Wrong-direction `\uses{lem:appLE_isLocalization}` removed from
  `lem:kaehler_localization_subsingleton`.

## What to check

Bidirectional:

### (A) Lean → blueprint

- For every `\lean{...}` declaration listed in the chapter, verify the
  Lean side compiles and the named declaration exists with the
  signature the chapter implies. Of particular interest given the
  iter-124 prover edit:
  - `\lean{...lem:appLE_isLocalization...}` — the body now contains
    `IsLocalization.lift` + `suffices AE` + `AlgEquiv.ofBijective forwardAlg sorry`.
    Audit whether the chapter's stated proof shape (the
    `IsLocalization.of_le` cocone-universal-property pattern, with
    Step-4 closure via `isLocalization_of_algEquiv`) still aligns
    with the body's new "promote to AlgHom + reduce to bijectivity"
    shape. Flag if the chapter's proof sketch no longer matches.
- The `appLE_isLocalization` body's L332-L397 comment block describes
  the Step 2 + Step 3 residual as "two Mathlib pieces (filtered-colim
  bridge + basic-open cofinality) NOT directly available in snapshot
  b80f227". Audit whether the chapter prose (L165-L195) still
  matches this characterisation — i.e. does the chapter state these
  same two Mathlib pieces as the gap, or does it still claim
  `IsLocalization.of_le` / `IsLocalization.lift_injective_iff` /
  `IsLocalization.lift_surjective_iff` as the closure path? Mild
  drift is acceptable; gross drift is a "soon" finding.
- Check that the in-body `RingHom.congr_fun h_fwd_comp` routing for
  `commutes'` is not contradicted by anything the chapter says about
  algebra-map compatibility. The chapter's M1.a definition of
  `appLE_colimAlgebra := (appLE_colimRingHom f e).hom.toAlgebra` is
  load-bearing (defequal); flag if the chapter has drifted away
  from that.

### (B) Blueprint → Lean

- Verify every substantive declaration in `Differentials.lean` has
  a corresponding `\lean{...}` mention in `Differentials.tex`. The
  iter-124 plan flagged that `appLE_unitSubmonoid`,
  `isUnit_appLE_unitSubmonoid_in_colim`, and
  `appLE_colimRingHom_comp_φV` now have `\lean{...}` references but
  not dedicated `\begin{lemma}` blocks — that's a "soon" item from
  blueprint-reviewer-iter124, not a must-fix. Flag if anything else
  in the Lean file (other named theorems / defs) is entirely absent
  from the chapter.
- The chapter's M1.b proof body should have enough detail that a
  prover could re-formalize the bijectivity decomposition. Is the
  current prose (L165-L195) detailed enough for that, or does it
  still hedge on "build the backward map abstractly" without naming
  the specific Mathlib bridge needed for element-representation in
  the lan-colim? Flag inadequacy if found.

## Known issues (already known — skip)

- The L138 vs L165 prose inconsistency was resolved inline this iter
  (planner reported).
- The wrong-direction `\uses{lem:appLE_isLocalization}` on
  `lem:kaehler_localization_subsingleton` was resolved inline this
  iter.
- The 3 missing `\lean{...}` references are added; the "promote to
  dedicated lemma blocks" follow-up is a "soon" blueprint-reviewer
  finding, NOT a must-fix.
- The 4 orphan chapters (`Modules_Monoidal.tex`, `Picard_Functor.tex`,
  `Picard_FunctorAb.tex`, `Picard_LineBundle.tex`) flagged by
  blueprint-reviewer-iter124 are out of scope for THIS checker (it
  audits Differentials.tex vs Differentials.lean only).

## Output

Standard lean-vs-blueprint-checker report at
`task_results/lean-vs-blueprint-checker-differentials-review124.md`.
Bidirectional findings, grouped by severity.
