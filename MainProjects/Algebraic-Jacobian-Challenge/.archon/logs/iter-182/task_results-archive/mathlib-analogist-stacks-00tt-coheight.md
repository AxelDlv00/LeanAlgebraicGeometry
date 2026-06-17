# Mathlib Analogist Report

## Mode
api-alignment

## Slug
stacks-00tt-coheight

## Iteration
182

## Question

For the 3 sorries in `Albanese/CodimOneExtension.lean` blocking the
critical-path Lemma 3.3 codim-1 extension argument, what is the
Mathlib status of:
1. **Stacks 00TT** — smooth ⟹ regular stalks.
2. **Coheight-to-Krull-dim** — `Order.coheight z = ringKrullDim (stalk z)`.
3. **Codim-1 valuative criterion** — "rational map indeterminacy is codim ≥ 2".

Should iter-182 dispatch a `CodimOneExtension` prover lane, or first
scaffold project-side helpers?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| 1. Stacks 00TT (`Algebra.Smooth → IsRegularLocalRing`) | NEEDS_MATHLIB_GAP_FILL | critical |
| 2. Coheight ↔ ringKrullDim bridge | PROCEED (project-side scaffold ~60–100 LOC) | high |
| 3. Codim-1 valuative criterion for indeterminacy | NEEDS_MATHLIB_GAP_FILL | critical |

## Must-fix-this-iter

None of the verdicts apply to *shipped, divergent* project code (the
relevant sorries are honest sorries with documented gaps, not parallel
APIs). No must-fix.

## Major

**Decision 2 — `CoheightBridge` scaffold**: build the project-side
`Order.coheight z = ringKrullDim (X.presheaf.stalk z)` bridge **this
iter** in a new `AlgebraicJacobian/CodimOneExtension/CoheightBridge.lean`
(or fold into `RiemannRoch/WeilDivisor.lean`). All Mathlib prerequisites
ship (`coheight_orderIso`, `spec_le_iff`,
`IsLocalization.AtPrime.ringKrullDim_eq_height`,
`IsAffineOpen.isLocalization_stalk`, `Specializes.mem_open`,
`exists_isAffineOpen_mem_and_subset`); the assembly is ~60–100 LOC.

Outcome of the scaffold:
- Refactor `hreg_dim` (CodimOneExtension.lean:242) from
  `IsRegularLocalRing ∧ ringKrullDim = 1` (two-gap conjunction) into a
  *closed* `hdim : ringKrullDim = 1` step + a residual
  `hreg : IsRegularLocalRing` sorry. The remaining sorry is then
  precisely the Stacks 00TT half — one named Mathlib gap rather than
  two.
- `Scheme.RationalMap.order` (`WeilDivisor.lean:148-151`) can drop its
  explicit `[Ring.KrullDimLE 1 _]` instance argument, simplifying every
  downstream Riemann-Roch consumer.

## Informational

- **Decision 1 (Stacks 00TT)**: genuine Mathlib upstream gap. `IsRegularLocalRing`
  lives in `Mathlib.RingTheory.RegularLocalRing.Defs` (79 LOC, single
  file) and has zero references inside `Mathlib/AlgebraicGeometry/`.
  No `Algebra.Smooth → IsRegularLocalRing` declaration exists. A
  project-side build is ~200–300 LOC across 3 sub-lemmas (cotangent
  finrank = relative dim; ringKrullDim = relative dim; combine via
  `IsRegularLocalRing.iff_finrank_cotangentSpace`). This is the natural
  next sub-project after Lane G's `IsRegularLocalRing → IsDomain` gap
  and the coheight bridge close. **Do NOT package together with
  the coheight bridge** — they are independent.

- **Decision 3 (codim-1 valuative criterion)**: Mathlib has the
  underlying valuative-criterion machinery
  (`AlgebraicGeometry.ValuativeCriterion`, `IsProper.eq_valuativeCriterion`)
  but does not package the Hartshorne II.4.4 / Milne 3.1 statement
  "rational map from nonsingular variety to proper target has
  indeterminacy of codim ≥ 2". For
  `indeterminacy_pure_codim_one_into_grpScheme`, the diagonal/
  difference-map construction `Φ : X × X ⇢ G` + pole-divisor pullback +
  diagonal intersection is **~300–500 LOC** of project-side
  infrastructure — multi-iter scope, not resolvable by an api-alignment
  recipe. `extend_of_codimOneFree_of_smooth` is independently gated on
  the Auslander-Buchsbaum / depth-2 chain (Lane G).

- **Prover-lane recommendation**: **do NOT dispatch a
  `CodimOneExtension.lean` prover lane this iter**. Instead, dispatch
  a `CoheightBridge` scaffold lane on the new file. The three sorries
  in `CodimOneExtension.lean` are blocked on three separate multi-iter
  sub-projects (00TT, codim-≥2 extension via Auslander-Buchsbaum, Milne
  3.3 difference-map construction); only the *coheight* sub-piece of
  one of them is movable this iter.

- **Mathlib upstream PRs (parallel to the loop)**: two small,
  self-contained PRs that the mathematician could submit while the
  loop continues:
  - `Order.coheight_eq_of_isOpenEmbedding` (~20 LOC, generic topology).
  - `AlgebraicGeometry.Scheme.ringKrullDim_stalk_eq_coheight` (~40 LOC).
  Neither blocks the loop; both would simplify project-side code if
  accepted.

## Persistent file
- `analogies/stacks-00tt-coheight.md` — full design rationale, the
  precise scaffold sketch, the cited Mathlib lemmas, and the
  strategic note on the Stacks 00TT separate sub-project.

Overall verdict: **scaffold the coheight bridge this iter; defer 00TT
and Milne 3.3 as independent multi-iter sub-projects with explicit
re-engagement triggers**.
