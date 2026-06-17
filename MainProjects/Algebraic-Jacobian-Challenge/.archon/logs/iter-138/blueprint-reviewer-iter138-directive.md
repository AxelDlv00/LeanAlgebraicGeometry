# Blueprint Reviewer Directive

## Slug
iter138

## Strategy snapshot

Iter-138 active critical path is `AlgebraicJacobian/Cotangent/GrpObj.lean`
piece (i.b) closure. Three honest sorry-bodied scaffolds remain in
`Cotangent/GrpObj.lean` (signed against intended sheaf-level RHS using
`Scheme.Hom.toRingCatSheafHom`); the iter-136 prover lane closed Step 3
(`_restrict_along_identity_section`), and the iter-137 prover lane on Step 2
(`_basechange_along_proj_two`) returned PARTIAL.

The iter-137 prover surfaced a load-bearing blueprint adequacy gap:

- `RigidityKbar.tex` proof of `lem:GrpObj_omega_basechange_proj` (L471–480)
  prescribes a chart-by-chart recipe via `tensorKaehlerEquiv` +
  `TopCat.Presheaf.pullback`, but does NOT anticipate that Mathlib's
  `PresheafOfModules.pullback` is OPAQUE on `.obj`/`.map` (defined as
  `(pushforward φ).leftAdjoint`). The chart-by-chart route requires an
  intermediate ~30–60 LOC chart-unfolding helper that the blueprint
  never names.

This iter the plan agent is dispatching a blueprint-writer for
`RigidityKbar.tex` IN PARALLEL with you, to add a `% NOTE iter-137:` block
documenting the chart-opacity blocker + the two alternative closure paths
(chart-unfolding helper route OR inverse-direction-via-adjunction-transpose
route). Account for that parallel dispatch when assessing the chapter.

Critical-path files this iter (planner is considering for a prover dispatch):

- `AlgebraicJacobian/Cotangent/GrpObj.lean` — piece (i.b) Step 2 retry on
  `_basechange_along_proj_two` (the iter-137 PARTIAL target); blueprint
  chapter is `RigidityKbar.tex` (cross-chapter; the pointer chapter is
  `AlgebraicJacobian_Cotangent_GrpObj.tex` but `\lean{...}` hints live in
  `RigidityKbar.tex`).

## Routes

Single route — over-k cotangent-vanishing pile via pieces (i)+(ii)+(iii)
of M2.body-pile. M3 positive-genus arm is user-escalation-pending / off-
critical-path. M1 EXCISED iter-126. M2.d Riemann–Roch path NOT ACTIVE.
M2.d-alt piece (iv) Serre duality DEFERRED as named-gap.

## References

- `references/challenge.lean`: Christian Merten's original formal
  statement of the 9 protected declarations. `\lean{...}` hints in
  `Jacobian.tex` and `AbelJacobi.tex` should pin to those signatures
  verbatim.

## Focus areas

- `RigidityKbar.tex` § Piece (i.b): is the chapter adequate AFTER the
  parallel blueprint-writer's iter-138 `% NOTE` block lands? You can
  assume the writer will document the chart-opacity blocker per
  `analogies/kaehler-tensorequiv-presheafpullback.md` Decision 4
  (universal-property-at-presheaf-level route) + the inverse-direction-
  via-adjunction route from `task_results/Cotangent_GrpObj.lean.md`
  Attempt 2.
- `Cotangent/GrpObj.lean` blueprint coverage of helper declarations
  (especially `schemeHomRingCompatibility` flagged iter-137 as lacking
  a `\lean{...}` block).

## Known issues

- Iter-137 carry-overs (do NOT re-flag):
  - `Jacobian.tex:400` stale citation
  - `Cohomology_StructureSheafModuleK.tex` label-prefix asymmetry on MV side ref
  - `Jacobian.tex` C.2.d second-bullet prose thinness

- Iter-135 carry-over (do NOT re-flag): `Cotangent/GrpObj.lean` file-header
  line-anchor drift at L61/L107/L146/L155/L160 (the iter-138 plan agent
  is aware; refresh deferred until Step 2 body closes substantively so
  line numbers stabilise).

- The two `sorry`-bodied scaffolds in `Cotangent/GrpObj.lean`
  (`_basechange_along_proj_two` L500 + `mulRight_globalises_cotangent`
  L624) are honest scaffolds pinned to `\notready` blueprint blocks;
  iter-137 PARTIAL preserved this state. Do not re-flag them as fake
  placeholders.

- `Jacobian.lean:197` `genusZeroWitness` + `:223` `positiveGenusWitness`
  + `RigidityKbar.lean:87` `rigidity_over_kbar` are honest-scaffold
  sorries; off-critical-path this iter.

Audit every chapter, not just the ones above.
