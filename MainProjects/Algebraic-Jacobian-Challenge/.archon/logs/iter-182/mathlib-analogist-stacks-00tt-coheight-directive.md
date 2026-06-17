# Mathlib Analogist — Stacks 00TT + coheight-to-Krull-dim for `CodimOneExtension`

## Mode: api-alignment

## Slug
stacks-00tt-coheight

## Iteration
182

## Question

`Albanese/CodimOneExtension.lean` carries 3 sorries blocking the
critical-path Lemma 3.3 codim-1 extension argument
(`extend_of_codimOneFree_of_smooth`,
`indeterminacy_pure_codim_one_into_grpScheme`, internal `hreg_dim`
inside `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`).

The flagged Mathlib gaps are:
- **Stacks 00TT** — smooth-morphism ⟹ regular stalks (the local
  characterisation; needs to bridge to `IsRegularLocalRing`).
- **Coheight-to-Krull-dim** — for a closed irreducible subscheme of
  codim 1, the coheight equals 1 (relating
  `IsLocalRing.maximalIdeal.spanFinrank` to topological codimension).

Without these, the route to `Sym^g`'s smoothness + Albanese UP cannot
land. The route is rated dominant Route-A risk in STRATEGY.md
(`Iters left ~40–80`; STUCK ≥3 consecutive iters per progress-critic
iter-182).

## Project artifact(s)

- `AlgebraicJacobian/Albanese/CodimOneExtension.lean` — full file.
  Specific declarations: `extend_of_codimOneFree_of_smooth`,
  `indeterminacy_pure_codim_one_into_grpScheme`,
  `smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`.
- `blueprint/src/chapters/Albanese_CodimOneExtension.tex` — chapter
  prose.
- iter-178 task_result for Lane D (CodimOneExtension Path D2) —
  the only iter that landed structural progress on this file.

## Decisions identified

### Decision 1: Stacks 00TT — smooth ⟹ regular at stalks

Does Mathlib have `Smooth f → IsRegularLocalRing (X.presheaf.stalk x)`
(or a closely-related local-ring property)? Candidates:
- `Mathlib.AlgebraicGeometry.Smooth.Basic` /
  `Mathlib.AlgebraicGeometry.Smooth.Stalk`.
- `Mathlib.RingTheory.Smooth.Regular` (if exists).
- Indirect: `Smooth → GeometricallyRegular` (Stacks 056T) +
  `GeometricallyRegular → IsRegularLocalRing` (with a base-field
  hypothesis).

### Decision 2: Coheight-to-Krull-dim bridge

Mathlib's `Order.Coheight` provides `coheight` for an `OrderedType`
element. Is there a bridge
`IsLocalRing.maximalIdeal.spanFinrank = Order.coheight P + 1` for a
codim-1 prime `P`? Or equivalently
`Krull.dim (R.localization P) = coheight P`?

### Decision 3: Codim-1 valuative criterion

The Lemma 3.3 codim-1 indeterminacy argument uses a valuative
criterion at codim-1 points (the local ring is a DVR). Mathlib's
`AlgebraicGeometry/Morphisms/UniversallyClosed.lean` has valuative
criteria but for properness, not for indeterminacy extension. Is
there a Mathlib idiom for "rational map indeterminacy is codim ≥ 2"?

## Hard ask

For each Decision, return verdicts. Produce a **persistent recipe at
`analogies/stacks-00tt-coheight.md`** with:

- Concrete Lean snippets for the path forward.
- LOC estimates per blocker.
- Recommendation on whether to dispatch a CodimOneExtension prover
  lane THIS iter (if recipe lands) or to first scaffold
  project-side helpers (a new `CodimOneExtension/` sub-directory
  with the missing pieces).

If the gaps are genuinely out of reach at the pinned Mathlib commit,
the recipe should propose the minimum project-side scaffolding to
make ONE of the 3 sorries movable this iter, and DEFER the rest with
explicit re-engagement triggers.
