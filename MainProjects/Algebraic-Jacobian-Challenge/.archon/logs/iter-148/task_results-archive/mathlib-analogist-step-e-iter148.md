# Mathlib Analogist Report

## Mode
api-alignment

## Slug
step-e-iter148

## Iteration
148

## Question

Does Mathlib have the proper-scheme Γ-flat-base-change isomorphism
`Γ(X, ⊤) ⊗_k \bar k ≃ Γ(X_{\bar k}, ⊤)` (for `X / Spec k` proper,
geometrically irreducible, reduced, smooth) — in any form re-exportable
to close step (e) of the iter-147 closure chain for
`constants_integral_over_base_field`?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| A. Mathlib has the proper-Γ-base-change statement? | NEEDS_MATHLIB_GAP_FILL | informational (gap is upstream) |
| B. Mathlib has a canonical idiom for building it? | NEEDS_MATHLIB_GAP_FILL | informational |
| C. Cross-utility with M3 Route A justifies building now? | DIVERGE_INTENTIONALLY (modest cross-utility, ~10–15%) | informational |

**Overall verdict: BUILD IT — but only if the consumer cannot be
reformulated over `\bar k`. Else PROCEED via consumer reformulation.**

## Must-fix-this-iter

None. The gap is upstream of the project (Mathlib infrastructure
absent), not a project-side parallel-API divergence.

The iter-147 prover-lane comment in
`ChartAlgebra.lean:270–287` does need a project-side correction: it
asserts the step-(e) closure proceeds via "a thin in-tree wrapper
around the `AlgebraicGeometry.IsBaseChange` namespace + the
`Spec.map_isPullback_of_isPushout` chain". The
`AlgebraicGeometry.IsBaseChange` namespace does **not exist** in
Mathlib (snapshot used: project's lake-manifest pin). The
"thin wrapper" framing should be corrected to either (a) a 300+ LOC
in-tree build of proper-Γ-flat-base-change, (b) a consumer-side
reformulation over `\bar k`, or (c) deferring to a later iter. The
~50–100 LOC budget cannot land step (e); the comment is misleading
future readers about the actual proof debt.

## Major

ALIGN_WITH_MATHLIB verdicts where the project hasn't shipped yet:
**none** (no Mathlib idiom to align with).

## Informational

- **Q1 (does Mathlib have it?)**: NO. There is no
  `Mathlib.AlgebraicGeometry.IsBaseChange` namespace, no
  `Mathlib.AlgebraicGeometry.Cohomology` directory, no proper-pushforward
  base-change theorem. Closest near-misses (none bridge in 1–2 lines):
  - `AlgebraicGeometry.pullbackSpecIso`
    (`Mathlib.AlgebraicGeometry.Pullbacks:703`): affine-only pullback
    ≅ `Spec` of tensor product. Affine case of the gap.
    LOC-distance to bridge: 400–600.
  - `IsBaseChange` (`Mathlib.RingTheory.IsTensorProduct`): the
    algebra-level pattern, no scheme-level interface.
    LOC-distance: doesn't bridge on its own.
  - `Module.Flat.isBaseChange`
    (`Mathlib.RingTheory.Flat.Stability`): flatness preservation under
    base change, ring-level. Feeds the exactness step inside the proof,
    not the gap directly.
  - `Algebra.IsGeometricallyReduced`
    (`Mathlib.RingTheory.Nilpotent.GeometricallyReduced`): reducedness of
    `A ⊗_k \bar k` for `A` an algebra; algebra-level only, applies to
    chart-rings not to `Γ(X, ⊤)` of a non-affine `X`.
  - `GeometricallyIrreducible` /
    `GeometricallyIrreducible.irreducibleSpace_of_subsingleton`
    (`Mathlib.AlgebraicGeometry.Geometrically.Irreducible:42, 98`):
    feeds the *topological* step (b) of the closure chain, not the
    Γ-side step (e).
  - `Algebra.TensorProduct.isField_of_isAlgebraic`
    (`Mathlib.FieldTheory.LinearDisjoint`): feeds the conclusion-side
    step (f) once the gap is closed.
  - `Subalgebra.bot_eq_top_of_finrank_eq_one` /
    `IntermediateField.bot_eq_top_iff_finrank_eq_one`
    (`Mathlib.LinearAlgebra.Dimension.FreeAndStrongRankCondition` /
    `Mathlib.FieldTheory.IntermediateField.Adjoin.Basic`): feeds step
    (g), not (e).

- **Q2 (canonical idiom)**: No idiom. Mathlib does not yet have an
  abstract cohomology-and-base-change framework for proper morphisms.
  The `CategoryTheory.Sites.SheafCohomology` infrastructure
  (`{Basic, Cech, MayerVietoris}.lean`) is generic site cohomology
  but is not coupled to schemes' `Γ`/proper-pushforward at any degree.
  `Mathlib.AlgebraicGeometry.Sites.ElladicCohomology` covers étale-
  cohomology basis only. No `R^iπ_*` infrastructure for proper π.

- **Q3 (LOC estimate)**: **400–600 LOC** for an idiomatic Mathlib-PR-able
  proof via Čech reduction + tensor-with-flat exactness; **~250–300
  LOC** for an ad hoc proof specialised hard to the project's
  hypotheses. The project's "~50–100 LOC thin wrapper" estimate is
  unrealisable — there is no upstream API to wrap, and the proof debt
  is genuine new infrastructure.

- **Q4 (M3 cross-utility)**: Modest (~10–15%). M3 Route A needs higher
  H^i base change (notably H¹ for Picard via `R¹π_*(O_X^*)`); the
  iter-148 step-(e) wrapper is a degree-0 fragment. ~30–50 LOC of
  reusable Čech-complex-tensor-with-flat lemmas would carry over,
  but the bulk of M3's machinery is separate. Not a strategic reason
  to "build now to amortise".

## Recommended planner action (one-shot strategic call)

1. **Preferred path (PROCEED via consumer reformulation)**: audit the
   M2.a consumer of `constants_integral_over_base_field`. If the
   consumer can be reformulated to assume `k` is algebraically closed
   (or the over-`\bar k` lemma suffices), step (e) collapses entirely:
   `Γ(X, ⊤)` is a finite field extension of an algebraically closed
   `k`, hence equal to `k` (integral extension of alg-closed field is
   trivial). The proof becomes ~10 LOC using
   `IsAlgClosed.ringHom_bijective_of_isIntegral` or equivalent.
   No base-change-of-Γ infrastructure needed.

2. **Fallback path (BUILD IT, ~300 LOC)**: if the over-`k`
   formulation is structurally required by M2.a's consumer, budget
   ~300 LOC of in-tree construction. Proof recipe:
   1. Reduce `X` to a finite affine cover using `IsProper ⇒
      QuasiCompact` (`AffineCover` is mathlib-available).
   2. Form the Čech equaliser
      `0 → Γ(X, O_X) → ∏ Γ(U_i, O_X) ⇒ ∏ Γ(U_i ∩ U_j, O_X)`.
   3. Tensor termwise with `\bar k` (flat since `\bar k` is a
      `k`-module that is free as a `k`-vector space, hence
      `Module.Flat`); the tensored equaliser stays exact at H⁰.
   4. Identify the tensored Čech complex with the Čech complex of the
      pulled-back scheme `X_{\bar k}` along the pulled-back cover
      `(U_i)_{\bar k}`; use `pullbackSpecIso` for the affine-piece
      identifications.

3. **Defer path (sorry-acceptable)**: leave step (e) as a structured
   `sorry` documenting the gap, ship the rest of the closure chain.
   Plan a separate iter (148-149 or later) for the BUILD-IT path
   once the consumer audit clarifies whether (1) is feasible.

## Persistent file

- `analogies/step-e-iter148.md` — design-rationale, near-misses, and
  LOC analysis captured for future iters.

Overall verdict: **BUILD IT** if the consumer reformulation is
infeasible; **PROCEED** via the over-`\bar k` consumer reformulation
if it is feasible. The "thin wrapper" budget is unrealisable
either way; the planner must commit to one of the three concrete
paths above.
