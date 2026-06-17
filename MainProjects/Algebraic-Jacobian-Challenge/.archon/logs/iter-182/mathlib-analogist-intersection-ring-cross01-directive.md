# Mathlib Analogist — Cross01 intersection-ring identification

## Mode: api-alignment

## Slug
intersection-ring-cross01

## Iteration
182

## Question

Joint consult covering TWO routes blocked on the SAME upstream Mathlib
gap: the `Away 𝒜 (X 0 · X 1)` intersection-ring identification for the
projective line `ProjectiveLineBar kbar = Proj ⟨k̄[X 0, X 1]⟩`.

1. **Route 1** — `GmScaling.lean` `gmScalingP1_chart_agreement_cross01`
   (file L295 helper, body `:= sorry`). Asserts the cross-case cocycle
   identity `λ · u = (1/t) · λ` in `Localization.Away t ⊗[kbar] GmRing`
   pulled through the chart-0/chart-1 ring maps. The body needs to
   identify `pullback ((cover).f 0) ((cover).f 1)` with the Spec of an
   intersection ring `Away 𝒜 (X 0 · X 1) ⊗[kbar] GmRing`.

2. **Route 3** — `AbelianVarietyRigidity.lean` `iotaGm_range_isOpen`
   (file L98+ helper, body `:= sorry`). Asserts `IsOpen` of the range
   of the canonical inclusion `Gm ↪ ℙ¹` factored through `gmScalingP1`.
   The proof requires extracting a chart-1 section
   `s : Gm.left ⟶ (gmScalingP1_cover kbar).X 1` such that
   `(lift … _).left = s ≫ (gmScalingP1_cover).f 1`.

## Project artifact(s)

- `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean:295-308`
  (`gmScalingP1_chart_agreement_cross01`).
- `AlgebraicJacobian/AbelianVarietyRigidity.lean:98-120`
  (`iotaGm_range_isOpen`).
- iter-181 Lane B task_result
  `.archon/task_results/Genus0BaseObjects_GmScaling.lean.md` —
  documents the 3 dead-end attempts on cross01 (cancel_mono on
  `PLB.hom`, unfold+simp on bridge isos) and pinpoints the blocker as
  the missing intersection-ring identification.
- iter-181 Lane E task_result
  `.archon/task_results/AbelianVarietyRigidity.lean.md` —
  documents the chart-1 section extraction as the same blocker.
- `analogies/gmscaling-cover-bridge.md` — iter-178 consult that retired
  the TEMP axioms via the uniform-in-`i` refactor; the intersection
  ring is NOT covered by that recipe.
- `analogies/gmscaling-deep.md` — iter-180 Decision Q4 estimates ~40
  LOC for the ring-level body + ~25-40 LOC for the intersection ring
  iso helper.

## Decisions identified

### Decision 1: Does Mathlib package the homogeneous-localization intersection identification?

Specifically, for a graded algebra `𝒜` (here
`projectiveLineBarGrading kbar`) and two homogeneous elements
`f, g ∈ 𝒜`, is there a Mathlib lemma identifying
`HomogeneousLocalization.Away 𝒜 (f * g)` with a *localization* of
`HomogeneousLocalization.Away 𝒜 f` at the image of `g / f`?

Project starting point:
`HomogeneousLocalization.Away.isLocalization_mul`
(`Mathlib.RingTheory.GradedAlgebra.HomogeneousLocalization:883`,
verified in scope iter-181 Lane B).

### Decision 2: Does Mathlib package the pullback iso for two `Proj.awayι` charts?

Concretely, for the canonical cover
`Proj.affineOpenCoverOfIrrelevantLESpan 𝒜 [X 0, X 1]`, is there a
Mathlib lemma giving
`pullback (Proj.awayι 𝒜 (X 0)) (Proj.awayι 𝒜 (X 1)) ≅
  Spec (HomogeneousLocalization.Away 𝒜 (X 0 * X 1))`?

If no, what's the canonical idiom for building it? Candidates:
- `Scheme.Pullback.openCoverOfBase` followed by `Cover.pullbackCover` and
  identifying via affine basic-open intersection.
- `pullbackSpecIso` + `Algebra.TensorProduct` chase (the project's
  existing recipe family).
- Direct via `Proj.basicOpen_mul` if such exists.

### Decision 3: Does Mathlib expose the chart-1 section of `(cover).pullback₁` of a glued morphism?

The Mathlib `Scheme.Cover.pullback₁` of a cover-glued morphism
factors through the chart at each fibre. Is there a stable lemma
exposing this section?

## Hard ask

For each Decision, return:
- **Mathlib idiom** (verified by `lean_loogle` / `lean_leansearch` /
  `lean_local_search` against the pinned `lake-manifest.json` Mathlib
  commit).
- **Project's current path**.
- **Gap classification** (aligned / divergent-but-zero-cost / divergent-with-cost / Mathlib-gap).
- **Recommended action** (one of ALIGN_WITH_MATHLIB / PROCEED /
  DIVERGE_INTENTIONALLY / BUILD_PROJECT_HELPER / ESCALATE).

Then produce a **persistent recipe at `analogies/intersection-ring-cross01.md`** with:
- Concrete Lean snippets (NOT full proofs — just the Mathlib API to
  use, the typeclass binders needed, and the `change` /
  `simp only` shape of the rewrite chain).
- Estimated LOC (separately for: intersection-ring iso helper; cross01
  body; iotaGm_range_isOpen body).
- Verification step: a `lean_multi_attempt` snippet showing the
  shape of the rewrite is admissible at the goal entry point.

If the recipe is genuinely not available in Mathlib at the pinned
commit, the recipe file should say so explicitly (`NOT_FOUND` or
`BUILD_PROJECT_HELPER` verdict) and propose the smallest project-side
helper that would unblock both routes.
