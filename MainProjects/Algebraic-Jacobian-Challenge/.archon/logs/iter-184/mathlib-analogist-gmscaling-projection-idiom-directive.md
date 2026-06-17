# mathlib-analogist — gmscaling-projection-idiom

## Mode: api-alignment

## Why this dispatch

iter-183 Lane B (`Genus0BaseObjects/GmScaling.lean` cross01 cocycle
body) is the **5-iter CHURNING route**. iter-183 progress-critic
triggered the mandatory mathlib-analogist consult for the corrective.
The iter-183 task_result documents 5 failed attempts and asks 3
specific questions (Q1/Q2/Q3) that gate Lane B re-firing.

The strategy-decision is whether Lane B can be unblocked by aligning
with a canonical Mathlib idiom (the analogist's normal output) — OR
whether the lane is structurally STUCK and should be DEMOTED off the
iter-184 active set.

## Context

### The cocycle goal (verbatim shape from iter-183 task_result)

`gmScalingP1_chart_agreement_cross01` lives in
`AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` around L382.

The goal after applying `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv`
is a morphism equality of the form:

```
(Spec ((HomogeneousLocalization.Away 𝒜 (X₀*X₁)) ⊗[k̄] GmRing) ⟶ Proj 𝒜) = (similar form)
```

where one side ends in `Proj.awayι (X 0)` after a chain of
projections, the other ends in `Proj.awayι (X 1)` after a parallel
chain. The two sides reflect the σ_× scaling action through the two
chart-1 / chart-0 perspectives.

### The iso the cocycle uses

`gmScalingP1_cover_intersection_X_iso` (iter-182 Lane B helper,
axiom-clean) is a composite of ~10 `≪≫` steps that bridges
`pullback ((cover).f 0) ((cover).f 1)` (the intersection of the
two charts in the cover) with `Spec ((Away (X₀ * X₁)) ⊗ GmRing)`
(a single concrete tensor-product chart). Key step is the application
of Mathlib's `Proj.pullbackAwayιIso` somewhere mid-chain (step 4 of
~10), wrapped in `asIso (pullback.map _ _ _ _ (𝟙) i₂ (𝟙) _ _)`.

### The Q1/Q2/Q3 from iter-183 task_result (re-stated verbatim)

> **Q1**: What is the canonical Mathlib idiom for collapsing
> `inv (pullback.map _ _ _ _ (𝟙) i₂ (𝟙) _ _) ≫ pullback.fst _ _` when
> `i₂ : Iso`? The natural name `pullback.map_fst` is not a Mathlib
> constant. The closest `pullback.lift_fst` requires un-`asIso`-ing
> the `pullback.map` first.

> **Q2**: Does Mathlib ship a `pullbackAwayιIso_inv_fst_assoc`-style
> `simp` lemma that fires through an outer `pullback.map` /
> `pullback.congrHom` wrap? If not, is there an `@[simps]`-style
> attribute that the project should add to
> `gmScalingP1_cover_intersection_X_iso` to auto-generate the
> projection lemmas?

> **Q3**: For a `gmScaling-style` cocycle between two `Proj.awayι X_i`
> compositions through different chart-rings, what is the canonical
> "shared intersection chart" definition? Is `Algebra.TensorProduct.map
> (awayMapₐ _ _) (AlgHom.id _ _)`-based extension the right idiom, or
> is there a more direct way?

### The 5 failed attempts (summary)

1. `cancel_epi` + simp on iso projections — simp lemmas for the
   wrapped `pullback.map` don't fire.
2. `aesop_cat` / `cat_disch` — exhaust safe rules; the goal involves
   non-trivial cocycle between two distinct `Proj.awayι` images.
3. `rw [← cancel_mono (Proj.awayι (X_0 * X_1))]` — pattern doesn't have
   the `_ ≫ awayι` form to cancel against (both sides end in
   `Proj.awayι X_0` / `X_1` — different right-monos).
4. `IsOpenImmersion.lift_uniq` — requires producing the shared
   factorisation target as an explicit `IsOpenImmersion.lift`, which
   itself requires the projection computation we're trying to bypass.
5. 2 named typed-sorry projection lemmas via `Classical.choice
   ⟨LHS⟩` as the "shared target" — reverted as the banned
   "Classical.choice body around an explicit witness" pattern.

## Question for the analogist

**Primary**: Is there a canonical Mathlib idiom for proving an
equality of two morphisms into `Proj 𝒜` that factor through DIFFERENT
`Proj.awayι X_i` open subschemes, by lifting through the intersection
chart `Proj.awayι (X_0 · X_1)` and a witness in the intersection
ring? If yes, what is the canonical proof shape?

**Secondary** (if primary returns ALIGN_WITH_MATHLIB or
BUILD_PROJECT_HELPER):
- Answer Q1: how should `inv (pullback.map _ _ _ _ id i_iso id _ _) ≫ pullback.fst`
  be collapsed in idiomatic Mathlib? (specific simp lemma names,
  attribute names, or a different proof strategy).
- Answer Q2: should the project add `@[simps]` to
  `gmScalingP1_cover_intersection_X_iso`, or does Mathlib provide a
  more general lemma that the project should use instead?
- Answer Q3: what is the right concrete "shared target" definition?
  (Algebra.TensorProduct.map flavor vs HomogeneousLocalization route
  vs something else.)

**Cross-domain inspiration FALLBACK**: if the api-alignment mode
verdict is "no canonical idiom — the project's path is fine but
the algebra is just hard", re-mode to `cross-domain-inspiration` and
search for the analogous structural pattern in Mathlib (cocycles
in sheaf gluing, Čech-cohomology, descent — any area where a
2-cocycle between two parallel chart embeddings has to be checked
to be coherent). Return the technique that area uses.

## Output

- Mode + verdict (PROCEED / ALIGN_WITH_MATHLIB / BUILD_PROJECT_HELPER
  / DIVERGE_INTENTIONALLY / NEEDS_MATHLIB_GAP_FILL).
- For ALIGN/BUILD: the recipe (concrete Mathlib lemma names + proof
  shape; idiom comparison; estimated LOC).
- For PROCEED: explicit go-ahead to re-fire Lane B with one of the 5
  failed attempts (which? why?), or with a fresh attempt the
  analogist surfaces.
- For NEEDS_MATHLIB_GAP_FILL / DIVERGE: explicit recommendation to
  DEMOTE Lane B from iter-184 active set + give iter-185+ closure
  path.

Persist recipe at
`analogies/gmscaling-projection-idiom.md`.

## Files to read

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean` (the
  `cross01` lemma + its `cancel_epi` lift).
- `analogies/gmscaling-cover-bridge.md` (prior iter recipe).
- `analogies/intersection-ring-cross01.md` (iter-182 recipe).
- iter-183 task_result at
  `.archon/task_results/AlgebraicJacobian_Genus0BaseObjects_GmScaling.lean.md`.
- Mathlib `AlgebraicGeometry/ProjectiveSpectrum/Basic.lean` (the
  `Proj.pullbackAwayιIso` family + companion simp lemmas).
- Mathlib `CategoryTheory/Limits/Shapes/Pullback/Limits.lean` (the
  `pullback.map` / `pullback.congrHom` family).
