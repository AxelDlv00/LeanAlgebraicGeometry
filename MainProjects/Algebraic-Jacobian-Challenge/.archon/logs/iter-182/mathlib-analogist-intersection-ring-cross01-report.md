# Mathlib Analogist Report

## Mode
api-alignment

## Slug
intersection-ring-cross01

## Iteration
182

## Question

Joint consult covering two routes blocked on the SAME upstream Mathlib gap:
the `Away 𝒜 (X 0 · X 1)` intersection-ring identification for the
projective line `ProjectiveLineBar kbar = Proj ⟨k̄[X 0, X 1]⟩`.

1. **Route 1** — `GmScaling.lean` `gmScalingP1_chart_agreement_cross01`
   (file L295 helper, body `:= sorry`). Asserts the cross-case cocycle
   identity `λ · u = (1/t) · λ` pulled through the chart-0/chart-1 ring
   maps. Body needs `pullback ((cover).f 0) ((cover).f 1)` identified
   with `Spec ((Away 𝒜 (X 0 · X 1)) ⊗[kbar] GmRing)`.
2. **Route 3** — `AbelianVarietyRigidity.lean` `iotaGm_range_isOpen`
   (file L98+ helper, body `:= sorry`). Needs a chart-1 section
   `s : Gm.left ⟶ (gmScalingP1_cover kbar).X 1` with
   `(lift … _).left = s ≫ (gmScalingP1_cover).f 1`.

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| (1) `HomogeneousLocalization.Away.isLocalization_mul` is shipped and is the ring-level idiom | PROCEED | informational |
| (2) `Proj.pullbackAwayιIso` IS shipped — discard the "build intersection-ring iso" plan | ALIGN_WITH_MATHLIB | critical |
| (3) Outer "intersection cover X iso" still needed; one pasting chain wrapping Mathlib idioms | BUILD_PROJECT_HELPER | informational |
| (4) Chart-1 section for `iotaGm_range_isOpen` via `pullback.lift` + `Proj.fromOfGlobalSections_morphismRestrict` | BUILD_PROJECT_HELPER | informational |

## Must-fix-this-iter

The ALIGN_WITH_MATHLIB verdict applies to a TASK-RESULT MISCLAIM, not to
already-shipped project code. The project's `gmScalingP1_chart_agreement_cross01`
is correctly recorded as an honest sorry; the misclaim is in the iter-181
Lane B task_result lines 64–67 ("the bridge `pullback ((cover).f 0)
((cover).f 1) ≅ Spec (...)` is not packaged in Mathlib as a single
lemma") and the recommended "step 1 — build `Away_X0_X1_iso : Away 𝒜
(X 0 · X 1) ≃+* Localization.Away (chart-1's affine coord)` (~25-40 LOC)".

**Concrete fix**: iter-182+ planner should DROP the "build `Away_X0_X1_iso`"
sub-task. Mathlib ships:

- `Proj.pullbackAwayιIso 𝒜 hf hm hg hm' hx :
  pullback (awayι 𝒜 f hf hm) (awayι 𝒜 g hg hm') ≅ Spec (.of (Away 𝒜 x))`
  for `hx : x = f * g`
  (`.lake/packages/mathlib/Mathlib/AlgebraicGeometry/ProjectiveSpectrum/Basic.lean:258-265`).
- Three `reassoc (attr := simp)` companion lemmas pinning every
  projection (lines 268, 275, 282, 291, 297 of the same file).

Both routes (cross01 and `iotaGm_range_isOpen`) ALIGN with this idiom;
no project-side ring-level helper is needed.

## Informational

- **Decision 1** (`HomogeneousLocalization.Away.isLocalization_mul`):
  PROCEED — the project already cites this lemma correctly. Used inside
  `Proj.pullbackAwayιIso`'s proof in Mathlib (line 317 of the same
  file). The project doesn't need to invoke it directly; consuming
  `pullbackAwayιIso` gives the Spec-level iso for free.

- **Decision 3** (outer iso `pullback ((cover).f 0) ((cover).f 1) ≅
  Spec ((Away 𝒜 (X 0 · X 1)) ⊗[kbar] GmRing)`): BUILD_PROJECT_HELPER.
  ~50-60 LOC, mirrors the existing `gmScalingP1_cover_X_iso` recipe
  with the merged generator `X 0 * X 1 ∈ 𝒜 2`. The KEY step inside the
  pasting chain is `Proj.pullbackAwayιIso`; the rest is
  `pullbackRightPullbackFstIso` + `pullbackSpecIso` (already used in
  the project).

- **Decision 4** (chart-1 section): BUILD_PROJECT_HELPER. ~45-60 LOC.
  The section extraction uses `Proj.fromOfGlobalSections_morphismRestrict`
  on chart-1 (since `onePt`'s vector `v 0 = v 1 = 1` makes BOTH chart
  generators units, so the underlying scheme map factors through EITHER
  `awayι X_0` or `awayι X_1`; chart-1 is the one needed). Then
  `pullback.lift` lifts into `(cover).X 1`. The open-immersion
  conclusion uses `Proj.awayι`'s `IsOpenImmersion` instance
  (`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic:196`) and the
  fact that the composite `Gm.left ⟶ Spec(Away X_1)` extracted from
  `r_1` is the standard open immersion `Spec k̄[t,t⁻¹] ↪ Spec k̄[u]`
  (`u ↦ t`, `t⁻¹ ↦ 1/u`).

- **Bonus**: the same chart-1 factorization (via `r_0` instead of `r_1`,
  using `zeroPt`'s `v 1 = 1`) closes `gmScalingP1_collapse_at_zero`
  (L420 of `GmScaling.lean`). Out of scope for iter-182's helper
  budget = 1, but a same-iter sibling lane could land it for ~30-40 LOC.

## Persistent file

- `analogies/intersection-ring-cross01.md` — full design rationale
  including concrete Lean snippets (signatures + body skeletons), LOC
  estimates by sub-task, exact Mathlib citations with line numbers,
  and a verification probe demonstrating that `Proj.pullbackAwayιIso`
  elaborates at the project's pinned Mathlib commit.

Overall verdict: **`Proj.pullbackAwayιIso` is the missing Mathlib idiom; the
iter-181 Lane B task_result over-pessimistically classified it as a
Mathlib gap. Decision 2 is ALIGN_WITH_MATHLIB and drops the "build
intersection ring iso" sub-task entirely; Decisions 3 (outer pasting
iso) and 4 (chart-1 section) remain genuine project-side
BUILD_PROJECT_HELPER work but unblock immediately given Mathlib's
shipped iso.**
