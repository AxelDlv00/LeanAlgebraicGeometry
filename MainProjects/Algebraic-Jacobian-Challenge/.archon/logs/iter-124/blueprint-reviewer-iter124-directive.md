# Blueprint Reviewer Directive

## Slug
iter124

## Strategy snapshot

The project's end-state is **zero inline `sorry`** across all
`AlgebraicJacobian/` files. Critical-path arc is the protected
`nonempty_jacobianWitness` (`Jacobian.lean:179`) closure via a
genus-stratified `by_cases h : genus C = 0` body decomposition:

- **M1** (off-critical-path Mathlib-contribution candidate): bridge
  between presheaf and algebra-Kähler forms on an affine chart.
  Current open sorry: `Differentials.lean:362`,
  `AlgebraicGeometry.IsAffineOpen.appLE_isLocalization`, M1.b body
  (Steps 2 + 3 of the `IsLocalization.of_le` chain — Step 0 + Step 1 +
  Step 4 already closed in body; Step 0 as named helper
  `isUnit_appLE_unitSubmonoid_in_colim` iter-122, Step 1 + Step 4
  closed iter-123). Mathlib contribution candidate is the M1.d
  tower-cancellation `equivOfFormallyUnramified` LinearEquiv.
- **M2** (genus-0 arm, on critical path): `genusZeroWitness` via
  base-change-to-`k̄` + Galois descent (handles the no-`k`-rational-
  point case). Sub-steps M2.a (rigidity over `k̄`), M2.b (witness
  assembly), M2.c (base-change + Galois descent infrastructure;
  phantom prereq spot-check pending iter-124), M2.d (RR path or
  cotangent-vanishing alt; char-`p` hazard on alt).
- **M3** (positive-genus arm): both Route A (Picard) and Route B
  (symmetric powers + Stein) >5000 LOC of Mathlib gap; user
  escalation triggered for iter-124.

Iter-124 prover lane is intended to **continue M1.b**: the focused
Step 2+3 lane on `appLE_isLocalization`'s residual AlgEquiv sorry
at `Differentials.lean:362`. The blueprint chapter that must clear
the HARD GATE for the iter-124 prover dispatch is therefore
`Differentials.tex § sec:bridge`.

## Routes

Single route active this iter (M1.b continuation on
`Differentials.lean`).  M2.a / M2.c / M2.d / M3 are queued; their
blueprint chapters need to be `complete: true / correct: true` for
**future** prover lanes but are not iter-124-blocking.

## References

- `challenge.lean`: the formal statement of the missing definitions
  and theorems for the Jacobian of an algebraic curve. Authoritative
  for protected signatures.

## Focus areas

- **`Differentials.tex`**: the iter-124 prover lane target. The
  iter-123 lean-vs-blueprint-checker-differentials-review123 report
  flagged the following non-blocking minor doc-drift items (none
  must-fix-this-iter):
  - `appLE_unitSubmonoid` (the named submonoid $M$ in M1.a) has no
    `\lean{...}` reference; recommend adding.
  - `isUnit_appLE_unitSubmonoid_in_colim` (the iter-122 Step 0
    extraction) is a top-level theorem but the chapter still inlines
    Step 0 prose; recommend adding a `\lean{...}` sub-block or a
    separate `\begin{lemma}` block.
  - Chapter L165 + L175 hedge between `IsLocalization.of_le` /
    `isLocalization_of_algEquiv` / `of_ringEquiv` is stale (the
    iter-123 mathlib-analogist verified that `AlgEquiv` is required;
    `RingEquiv` and `of_le` are not the closure pattern).
  - `appLE_colimRingHom_comp_φV` (the cocone-leg factorisation
    lemma carrying the M1.b → M1.e triangle identity) is
    unreferenced; recommend a `\lean{...}` block in the M1.e proof.

  Please re-confirm these are non-blocking minor items (the
  iter-123 prover landed the M1.b structural reduction with the
  chapter as it stands), but flag them under "soon" if they are
  worth a blueprint-writer pass.

  Iter-122/iter-123 also surfaced a wrong-direction
  `\uses{lem:appLE_isLocalization}` on
  `lem:kaehler_localization_subsingleton`; please re-confirm
  whether this is still present and whether it should be must-fix.

- **`Jacobian.tex`**: pre-staging for iter-126+ M2.a prover lane;
  please re-confirm the M2.a sub-step (rigidity for
  `ℙ¹_{k̄} → A_{k̄}` + Galois descent) has adequate proof detail.

## Known issues

- The single open sorry `Differentials.lean:362` is the in-flight
  M1.b residual (Step 2+3 packaged as a single AlgEquiv hole);
  the chapter declares it as "the heart of the bridge" and the
  prover's path is clear. NOT a blueprint defect.
- `Jacobian.lean:179` `nonempty_jacobianWitness` is the off-limits
  end-state sorry; the chapter does NOT yet contain the genus-
  stratified body restructure (intentional — that lands when
  `genusZeroWitness` + `positiveGenusWitness` are at least
  scaffolded with sorry bodies, multi-month away).
- Two iter-123 blueprint-reviewer "soon" items in
  `Differentials.tex`: wrong-direction
  `\uses{lem:appLE_isLocalization}` on
  `lem:kaehler_localization_subsingleton`; absent
  `AlgebraicGeometry.Scheme.component_nontrivial` referenced in
  `smooth_locally_free_omega` Step 4.5. Neither blocks iter-124.
