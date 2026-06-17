# Mathlib Analogist Directive

## Mode
cross-domain-inspiration

## Slug
chart-bridge-structural-pivot

## Structural problem

We have a proof obligation of the form `Spec.map (f : R₁ →+* R₂) = X.hom`
where `f` is a composition of ring maps (chart-ring iso ∘ algebraMap) and
`X.hom` is a Mathlib-defined pullback iso between two presentations of the
same affine pullback scheme. After a `fin_cases i` over `i : I₀` (where
`I₀ ≃ Fin 2` from the chart-indexing cover), the goal's RHS has its
`MvPolynomial.X i` literal in the form `MvPolynomial.X (0 : Fin 2)` (from
the literal `match`-branch reduction in the original term) while the LHS
has the form `MvPolynomial.X ⟨0, h⟩` (the post-`fin_cases`-substitution
shape). These are definitionally equal but the chain of `rw [simp lemma]`
calls in the iso-equality argument (`pullbackSpecIso_hom_base`,
`pullbackRightPullbackFstIso_hom_fst`, `pullbackSymmetry_hom_comp_fst`,
`pullback.lift_fst`) all report "unused" because their LHS patterns fail
to syntactically unify with this Fin literal mismatch.

The categorical shape: a per-chart (i.e., per-index `i : Fin 2`) coherence
condition for a glued morphism `(Cover.glueMorphisms cover charts coh) ≫ g
= h`, reduced via `Cover.hom_ext` to per-chart `ι i ≫ … = …`, where the
per-chart side is an equality of `Spec`-maps obtained from chasing two
different presentations of the same canonical pullback iso.

Symbolic abstraction: we have a sieve / covering family
`{ι_i : U_i → X}_{i ∈ I}`, two morphisms `f, g : X → Y`, and we want
`f = g` reduced to `ι_i ≫ f = ι_i ≫ g` for each `i`. Each per-`i`
equation involves a Fin literal coming from a definitional-match in the
covering data; the chain of simp lemmas for the equation chase
mis-aligns because the Fin literal `(0 : Fin 2)` does not syntactically
unify with `⟨0, h⟩` after `fin_cases`.

The categorical idiom we are imitating with the failing equation chase:
the Mathlib analog is `OpenCover.pullbackCoverAffineRefinementObjIso` in
`Mathlib/AlgebraicGeometry/Pullbacks.lean` (or the equivalent in the
`Scheme.AffineCover` API). There the per-chart equation chase is closed
via a single `simp` with the `pullbackSpecIso_inv` family — but in our
case the chase manifests the Fin-literal mismatch.

## Failed approaches

- **Approach A (iter-173)**: `gmScalingP1_chart` body via 4-step bridge
  `pullbackSymmetry ≪≫ pullbackRightPullbackFstIso ≪≫ pullback.congrHom ≪≫
  pullbackSpecIso` — succeeded at the chart level, but the per-chart
  equation chase that follows (for `chart_PLB_eq Step C`) hit the Fin
  syntactic-mismatch obstacle.
- **Approach B (iter-174 chart-bridge-shared-helper recipe)**: extract
  the per-chart bridge as a shared helper `gmScalingP1_chart_PLB_eq` with
  Steps A (collapse `Proj.awayι ≫ PLB.hom` via `awayι_comp_PLB_hom`) + B
  (merge `Spec.map`s and identify via the chart-ring-iso algebraMap)
  closing axiom-clean. Step C is the per-chart equation chase that
  manifests the Fin literal mismatch. **Underlying obstacle**: the chase
  uses ~5 `simp_rw` calls each matching a Mathlib lemma whose LHS pattern
  contains a `Fin 2`-valued component; after `fin_cases i`, the rewrite
  patterns no longer unify.
- **Approach C (iter-174 chart_agreement diagonals)**: `fst_eq_snd_of_mono_eq`
  on the cover's chart maps (which are `pullback.fst _ _` of `IsOpenImmersion`,
  hence `Mono`) — this works for the `(0,0)` and `(1,1)` diagonals but the
  cross cases `(0,1)`/`(1,0)` need the `λ·u = (1/t)·λ` algebra at the level
  of `Localization.Away`, which we have not been able to thread cleanly
  through the chart-ring API.

## Search radius

`wide` — Mathlib's `AlgebraicGeometry.Pullbacks`,
`CategoryTheory.Limits.Shapes.Pullbacks`, and any cover-equation chase
involving `fin_cases` are the obvious neighbors. Also worth checking
`Mathlib.Tactic.Convert` / `Mathlib.Tactic.Change` idioms for the Fin
literal mismatch — there may be a known idiomatic pattern (e.g.,
`Fin.cases` instead of `fin_cases`, or `Fin.mk_zero'` after `NeZero 2`,
or `change` with explicit type aliasing) that the rest of Mathlib uses
to avoid this pitfall.

In addition, please consider whether a **structural pivot** of the
`gmScalingP1_cover_X_iso` definition itself would dissolve the problem:
the current definition uses `match i with | 0 => ... | 1 => ...`, which
is what forces the literal `(0 : Fin 2)` to appear after reduction; if
we instead define `gmScalingP1_cover_X_iso_zero` and
`gmScalingP1_cover_X_iso_one` separately and combine via `Fin.cases` (or
even a `match` over a custom `Fin2` inductive), would the Fin literal
mismatch evaporate? The prover task result for iter-174 explicitly
suggests this as one of four candidate options for iter-175; we want a
Mathlib-grounded judgment on whether that approach has precedent.

## Project context

`AlgebraicJacobian/Genus0BaseObjects.lean` (1143 LOC; to be split iter-175
plan-phase into 4 sub-files; the GmScaling sub-file will own the chart-bridge
machinery). The Lane A iter-175 prover lane is responsible for closing
`chart_PLB_eq Step C` (the `i=0`/`i=1` cases) and `chart_agreement` cross
cases. Without a structural pivot, we project a 5th consecutive PARTIAL on
Route 1. The progress-critic STUCK escalation trigger ARMS on a 5th PARTIAL.

Please return:

1. A ranked list of Mathlib precedents that solve the same `fin_cases`
   + simp-lemma-syntactic-mismatch problem (with file + lemma name +
   technique).
2. A concrete recommendation for iter-175 Lane A: either (a) a syntactic
   bridge (`change`, `convert ... using N`, `Fin.cases`, `simp [Fin.isValue]`,
   `Fin.mk_zero'`, …) that closes the chase without restructuring, or (b)
   a structural pivot of `gmScalingP1_cover_X_iso` that dissolves the
   literal mismatch at the source, or (c) a verdict that the chase as
   structured cannot be closed cleanly and the chart_PLB_eq helper should
   itself be re-architected.
3. For the `chart_agreement` cross cases `(0,1)`/`(1,0)`, the substantive
   algebra is `λ·u = (1/t)·λ` at the level of `Localization.Away`.
   Persist the ring identity recipe with named Mathlib API
   (`Algebra.TensorProduct.tmul_mul_tmul`, `IsLocalization.Away.invSelf`,
   `IsLocalization.mk_eq_mk_iff`, …).

Persist your full recommendation to `analogies/chart-bridge-structural-pivot.md`
so Lane A iter-175 prover can read it as the required reading
(supersedes `analogies/chart-bridge-shared-helper.md`).
