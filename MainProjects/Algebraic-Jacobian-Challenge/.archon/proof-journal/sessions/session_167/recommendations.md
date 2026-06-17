# Recommendations for iter-168

## Top priority (single-helper-three-closures pivot)

1. **Build `homogeneousLocalizationAwayIso`** — `HomogeneousLocalization.Away
   (projectiveLineBarGrading kbar) (MvPolynomial.X i) ≃+* MvPolynomial Unit kbar`,
   the "degree-0 of localization at `X_i` = polynomial in `X_{1-i}/X_i`" iso.
   Estimated ~30 LOC of project-side ring-iso work. **One helper, three closures**:
   - Unlocks `projectiveLineBar_isReduced` (via `IsReduced.of_openCover` over
     `Proj.affineOpenCover` + "Spec of a domain is reduced").
   - Unlocks the chart-local branch of `projGm_isReduced`.
   - Unlocks step (3) of the analogist's `gmScalingP1` 5-step recipe.

   This is the cheapest infrastructure lever in iter-168.

## Lane B (`AbelianVarietyRigidity.lean`)

2. **`iotaGm_isDominant` (L934)** — gated on Lane A's concrete `gmScalingP1` body.
   Once `gmScalingP1` is the chartwise glue with `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` as
   the open immersion factor, dominance reduces to `IsOpenImmersion → IsDominant`
   on an irreducible target via Mathlib's priority-100 instance L226 in
   `Mathlib.AlgebraicGeometry.Morphisms.UnderlyingMap`. **Do NOT retry direct
   `infer_instance` in the meantime** — iter-167 showed it appears to succeed in a
   standalone `lean_run_code` smoke test but fails in the file context (backward-defeq
   quirk with `gmScalingP1 := sorry`). Wait for Lane A.

3. **`genusZero_curve_iso_P1` (L1141)** — off-limits RR bridge, deferred to iter-168+.
   Pre-prover consult: mathlib-analogist on Mathlib's divisor / Riemann-Roch /
   degree-map machinery for genus-0 curves.

## Lane A (`Genus0BaseObjects.lean`)

4. **`gmScalingP1` body (L459) + `gmScalingP1_collapse_at_zero` (L476)** — the 5-step
   recipe from `analogies/gm-grpobj-and-friends.md` is concrete. After (1) above lands,
   each remaining step is ~30-50 LOC. Recommended structure: 4 sub-lemmas + one
   `Scheme.Cover.glueMorphisms` invocation. **Multi-iter sub-lane (3-4 iters).**

5. **`gm_grpObj` (L420) — escalation candidate.** The progress-critic-routec167 watch
   item explicitly named this as the lone 2-iter-deferred CRITICAL item:

   > If `GrpObj.ofRepresentableBy` persists into iter-168 reports, escalate to
   > STUCK with a Mathlib-idiom consult corrective.

   **Action:** dispatch a dedicated mathlib-analogist consult slug
   `grpobj-of-representable-by` BEFORE iter-168's prover phase, asking specifically:
   (a) is there a Mathlib idiom for "functor `(C^op ⥤ AddGrpCat)` representable by an
   `Over S` object" that avoids spelling out F + RepresentableBy + naturality from
   scratch? (b) the iter-167 prover found that the analogist's previous "FREE 2-3 LOC"
   verdict for `ga_grpObj` was wrong — what's the realistic minimum to land it? The
   `ga_grpObj` `AffineSpace.homOverEquiv` shortcut covers the bijection layer only.

6. **`gm_geomIrred` (L532) — defer.** Mathlib gap on tensor-localization
   (`Localization.Away t ⊗_R S ≃+* Localization.Away (t ⊗ 1)`) +
   tensor-of-domains-over-field. Sub-lane on its own. Not on the critical path for
   `morphism_P1_to_grpScheme_const` (`projGm_geomIrred` propagates `sorryAx` via this
   route; closing it cleans the propagation but doesn't unblock).

7. **`ga_grpObj` (L335), `projectiveLineBar_geomIrred` (L177),
   `projectiveLineBar_smoothOfRelDim` (L184)** — OPT-IN, defer.

## Patterns to reuse (added to PROJECT_STATUS Knowledge Base this iter)

- `(X ⊗ Y).hom = pullback.fst X.hom Y.hom ≫ X.hom` rfl-unfold in
  `Mathlib/CategoryTheory/Monoidal/Cartesian/Over.lean:62`
  (`tensorObj_hom`) + `change` + `infer_instance` chain for any
  `MorphismProperty` stable under composition + base change. Iter-167:
  `projGm_locallyOfFiniteType` axiom-clean via this idiom.
- `GeometricallyIrreducible.comp` does NOT auto-fire via `infer_instance`; needs
  `exact GeometricallyIrreducible.comp _ _` explicitly. Iter-167: `projGm_geomIrred`
  required the two-attempt fix.
- `IsLocalization.isDomain_localization
  (powers_le_nonZeroDivisors_of_noZeroDivisors (X_ne_zero _))` for "localization at
  powers of a polynomial variable preserves domain". Iter-167: `gmRing_isDomain`
  axiom-clean.

## Anti-patterns / do-not-retry

- **Do NOT retry `infer_instance` on `IsDominant iotaGm.left`** until Lane A's
  `gmScalingP1` body lands. The in-context synthesis fails even though the standalone
  `lean_run_code` smoke test succeeds (backward-defeq quirk).
- **Do NOT trust an analogist's "FREE" verdict that bridges between Mathlib's canonical
  decl and the project's `Over S` encoding without checking the bijection / iso
  layer.** iter-165 surfaced this for `projectiveLineBar_isProper`; iter-167 re-surfaced
  it for `ga_grpObj`. Standard recipe: any time the analogist promises "2-3 LOC FREE"
  on a `GrpObj`/`IsProper`/structural instance bridge, the prover should still budget
  the bijection layer separately.

## Subagent advice for the plan agent

- The `progress-critic` should be re-dispatched iter-168 with both lanes scoped:
  - **Lane B (AVR):** trajectory is CONVERGING (6 → 2 sorries this iter, hard test
    passed). Watch item: `iotaGm_isDominant` becomes a 2-iter deferred bridge if Lane
    A's `gmScalingP1` doesn't land iter-168.
  - **Lane A (Genus0BaseObjects):** sorry count went 6 → 9 (added 3 scaffold exports
    Lane B consumes); per-instance, 4 closed axiom-clean + 2 closed-via-scaffold-deferral
    + 2 PRIMARY bodies deferred. This is **decomposition + export-pattern, not churn**,
    but the 3-iter deferral of `gmScalingP1` body + `gm_grpObj` body now meets the
    CHURNING precursor pattern in spirit (CRITICAL items deferred across 3 consecutive
    iters: iter-165, iter-166, iter-167). The single `homogeneousLocalizationAwayIso`
    helper is the cheapest progress lever; if iter-168 lands it and closes 1 of the
    3 downstream consumers, the route stays CONVERGING.
- `mathlib-analogist` cross-domain (NOT api-alignment) consult on
  `GrpObj.ofRepresentableBy` warranted iter-168 if `gm_grpObj` is to be attempted.
