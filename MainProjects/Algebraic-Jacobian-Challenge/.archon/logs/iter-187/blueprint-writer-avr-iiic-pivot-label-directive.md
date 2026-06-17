# Blueprint Writer Directive

## Slug
avr-iiic-pivot-label

## Target chapter
blueprint/src/chapters/AbelianVarietyRigidity.tex

## Strategy context

This consolidated chapter covers `AlgebraicJacobian/AbelianVarietyRigidity.lean`,
`Genus0BaseObjects.lean`, `Genus0BaseObjects/GmScaling.lean`,
`RigidityLemma.lean` (see `% archon:covers` line). Per STRATEGY.md row
"Genus-0 rigidity — chart-bridge cross-case body":

> Iters left ~2–4 | LOC ~30–70 · NOT-YET-MEASURED | cocycle helper
> `λ·u = (1/t)·λ` in `Localization.Away t ⊗_{k̄} GmRing` |
> algebra-chase; budget assumes ring identity isolates cleanly

iter-187 progress-critic (`route187`) returned a **STUCK +
OVER_BUDGET** verdict for Lane B `GmScaling.lean`:

> - Sorry count flat 4/4/4/4 across iter-183 to iter-186.
> - Recurring blocker: `"pullback.map ... ≫ pullbackRightPullbackFstIso.inv
>   adjacency not Mathlib-simp-covered"` empirically confirmed via
>   `simp made no progress` in iter-186.
> - 4 consecutive iters of pivot/recipe language without sorry closure.
> - Mandatory decrement gate MISSED iter-186 (per the iter-185 STRATEGY.md
>   Open Q failure-mode trigger).
> - **Primary corrective: Route pivot to separated-locus alternative
>   (path III.c).** Do NOT attempt Recipe II or III.b again.

iter-187 blueprint-reviewer (`iter187`) returned a **MUST-FIX** for
this chapter (MF-2):

> The `lem:gmscaling_chart_agreement` proof block describes (III.c)
> as ONE OF THREE paths [(III.a) `Algebra.TensorProduct.isDomain_of_isAlgClosed_left`,
> (III.b) direct scheme-map argument, (III.c) separated-locus argument]
> but does NOT explicitly label (III.c) as "the iter-187 mandatory
> pivot" or indicate that (III.a) and (III.b) are blocked at b80f227.

## Required content

The single substantive edit is to the proof block of
`lem:gmscaling_chart_agreement` (the chart-bridge agreement lemma
whose proof currently lists 3 paths). The required intervention is to
**re-label the 3 paths to reflect their iter-187 status**:

- **Path (III.a)** — `Algebra.TensorProduct.isDomain_of_isAlgClosed_left`
  shim route. **Label**:

      \textbf{BLOCKED at Mathlib b80f227.} The Mathlib lemma
      `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` does not
      exist at the pinned commit. The iter-186 Lane B prover empirically
      verified that the cocycle's residual simp normal form cannot be
      reduced by Mathlib's existing `pullbackRightPullbackFstIso_inv_*`
      simp lemmas (which require the projection to be syntactically
      displayed, while the cocycle has projections buried inside
      outer `pullback.map` constructs). Route is permanently
      blocked at this commit pending Mathlib upstream.

- **Path (III.b)** — direct named-projection-lemma route (the 2
  proposed `gmScalingP1_cover_intersection_X_iso_inv_fst/_snd`
  `@[reassoc (attr := simp)]` helpers). **Label**:

      \textbf{DESCOPED iter-187.} The path requires building two
      named projection lemmas via `pullback.hom_ext` on the codomain
      `(cover).X i = pullback (PLB.fst Gm.hom) (openCover.f i)`, then
      applying them to collapse the cocycle. iter-186 Lane B
      empirically determined that the III.a refactor (term-mode iso)
      removes the elaboration shape obstacle but the simp coverage
      gap persists in mid-chain (the `pullback.map ... ≫
      pullbackRightPullbackFstIso.inv` adjacency is not Mathlib-canonical).
      Per iter-185 STRATEGY.md failure-mode trigger and iter-187
      progress-critic STUCK verdict, this path is descoped this iter
      to focus on the alternative; may be revisited if Path (III.c)
      surfaces unexpected blockers.

- **Path (III.c)** — separated-locus alternative. **Label**:

      \textbf{iter-187 MANDATORY PIVOT} (per iter-185 STRATEGY.md
      \texttt{Open Q} failure-mode trigger; iter-187 progress-critic
      STUCK verdict; iter-187 blueprint-reviewer MF-2).

  Then **expand the (III.c) sub-paragraph** with a concrete recipe
  sketch — the existing chapter has a brief mention; this writer call
  should flesh it out enough for a prover. Key mathematical content
  (the writer should restate in chapter prose):

  > **(III.c) separated-locus path.** Use that `ℙ¹ / k̄` is
  > separated (Stacks 01KU: `Proj` of a graded ring is separated
  > over the base), so the diagonal `Δ : ℙ¹ ⟶ ℙ¹ × ℙ¹` is a
  > closed immersion. The cocycle's equality on `(cover).X 0 ∩
  > (cover).X 1` is the statement that two morphisms agree on the
  > intersection. Reformulate as: the pair of morphisms `(chart₀,
  > chart₁) : pullback (chart-1 cover-component) ⟶ ℙ¹ × ℙ¹`
  > factors through `Δ`. The factorization through `Δ` is
  > equivalent (by Mathlib's `IsClosedImmersion.lift_iff_range_subset`
  > or the universal property of the diagonal `IsSeparated.diagonal_isClosedImmersion`)
  > to the *closed-set containment* of the cocycle's image in `Δ`'s
  > image, which on points reduces to the chart equality on the
  > intersection's *closed points* — a discrete check that bypasses
  > the simp coverage gap entirely.
  >
  > Concretely, the prover's recipe is:
  >
  > 1. Pick `Δ_ℙ¹ : ℙ¹ ⟶ ℙ¹ × ℙ¹` via Mathlib's
  >    `CategoryTheory.Limits.prod.lift (𝟙 ℙ¹) (𝟙 ℙ¹)` or
  >    `IsSeparated.diagonal_isClosedImmersion`.
  > 2. Build the pair-morphism `(chart₀, chart₁) :
  >    (cover).X 0 ∩ (cover).X 1 ⟶ ℙ¹ × ℙ¹` via `prod.lift`.
  > 3. Show this pair factors through `Δ_ℙ¹` via the universal
  >    property of `(cover).X 0 ∩ (cover).X 1`'s pullback structure
  >    combined with `IsClosedImmersion.lift`.
  > 4. The factorization reduces to two scheme-equalities on the
  >    components, each of which is a direct chart-bridge equality
  >    on `(cover).X i`'s structure (not the full cocycle).
  >
  > Substrate hooks: `IsSeparated.diagonal_isClosedImmersion`,
  > `IsClosedImmersion.lift`, `prod.lift`, `pullback.lift`. All
  > present at Mathlib `b80f227`. Estimated ~80-120 LOC for the
  > full closure, predominantly category-theory chasing.

(The writer is expected to render this in chapter prose, matching
the chapter's existing style of (I)/(II)/(III) labeling. The detailed
recipe above is the mathematical seed; the writer should refine the
sentences but preserve the substrate-hook citations.)

### Other adjustments

- The chapter's section `\section{(III) Mathlib simp coverage gap on
  the chart-bridge cross-case}` (or equivalent header) — if it
  enumerates (III.a)/(III.b)/(III.c) in sequence — should retain its
  structure; only the labels and the (III.c) body need rewriting.

- The `% NOTE` annotations the iter-186 review added on
  `Picard_LineBundlePullback.tex` are the model for the labels —
  prose paragraphs prefixed with bold tags like `\textbf{BLOCKED:}`
  / `\textbf{DESCOPED:}` / `\textbf{iter-187 MANDATORY PIVOT:}`.

## References

- Stacks tag 01KU (Proj is separated). Read from
  `references/stacks-constructions.tex` if needed.
- Hartshorne II.4.6 (separatedness criteria; the diagonal-is-closed
  characterisation). Read from
  `references/hartshorne-algebraic-geometry.pdf`.
- The existing iter-186 chapter expansion paragraphs (II/III) ARE
  in this chapter — re-read the local file (not the analogies/) to
  ensure the rewrite preserves the existing prose.

## Out of scope

- Do NOT add `\leanok` / `\mathlibok` markers.
- Do NOT edit Lean files.
- Do NOT touch sibling chapters.
- Do NOT add Lean tactic code in the proof sketch.
- Do NOT expand on Lane B-internal blockers like `gm_geomIrred` /
  `projGm_isReduced` — those are tracked separately.

## Notes

This single rewrite simultaneously:

1. Resolves blueprint-reviewer MF-2 by labeling (III.c) as the
   mandatory pivot;
2. Provides the iter-187 Lane B prover (if it dispatches this iter)
   with the recipe sketch needed to execute (III.c);
3. Records the (III.a) / (III.b) descoping for future iters so the
   project does not re-attempt them.

The chapter coverage of `AbelianVarietyRigidity.lean` Lane E
(appTop-residual sub-task f) is unrelated to (III.c); Lane E's
content (chart-1 composition + ΓSpecIso telescoping) is in a
different sub-section and should be left untouched. Only the
`lem:gmscaling_chart_agreement` proof block content needs
adjustment for MF-2 / Lane B III.c labeling.
