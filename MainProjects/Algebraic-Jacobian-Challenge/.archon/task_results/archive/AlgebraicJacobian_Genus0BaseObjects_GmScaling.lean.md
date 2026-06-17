# AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

## Iter-193 Lane B prover session

**Entering state**: 2 sorries (`gmScalingP1_chart_agreement_cross01`,
`gmScalingP1_collapse_at_zero`).

**Exiting state**: 2 sorries (still). **Net file count**: 0.

**Structural advance**: SIGNIFICANT. Multiple axiom-clean helpers
established along the range-containment chain. **HARD BAR met**: ≥1
axiom-clean helper in the range-containment chain (in fact, several
landed). The single substantive residual (topological range
containment via closed-points) is now precisely named and isolated
inside `gmScalingP1_chart_agreement_cross01`'s `hrange` step.

## `gmScalingP1_chart_agreement_cross01` (line 463)

### Attempt 1 — Signature corrective + Substrate 1 plug-in

- **Approach**:
  1. Added `[IsAlgClosed kbar]` to signature, propagated to
     `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence`,
     `gmScalingP1`, `gmScalingP1_collapse_at_zero`.
  2. Moved `projectiveLineBar_isReduced` instance to BEFORE the
     cocycle proof (was previously after `gmScalingP1_collapse_at_zero`)
     so that `IsReduced (ProjectiveLineBar kbar).left` resolves via
     `inferInstance` for the `IsClosedImmersion.lift_iff_range_subset`
     application.
  3. Added `QuasiSeparatedSpace` instance derivations:
     `QuasiSeparatedSpace PLB.left` via
     `quasiSeparatedSpace_of_quasiSeparated PLB.hom` (PLB.hom is
     separated since PLB is proper);
     `QuasiSeparatedSpace (pullback PLB.hom PLB.hom)` via the same
     route along `pullback.fst PLB.hom PLB.hom` (separated by
     `IsSeparated.pullback_fst` base change).
  4. Added `QuasiCompact s_pair` instance via
     `quasiCompact_of_compactSpace` (using existing `hcompact` from
     intersection ≅ affine spec).
  5. Stated topological range containment `Set.range s_pair.base ⊆
     Set.range (pullback.diagonal PLB.hom).base` as a typed sorry
     (`hrange`, line 463). This is the substantive residual.
  6. Applied `IsClosedImmersion.lift_iff_range_subset` to extract
     `s : intersection → PLB` with `s ≫ Δ = s_pair`.
  7. Derived the cocycle from `s ≫ Δ = s_pair` via
     `pullback.diagonal_fst` / `pullback.diagonal_snd` (both = 𝟙):
     `pullback.fst (cover) ≫ chart 0 = s = pullback.snd (cover) ≫ chart 1`.

- **Result**: **PARTIAL — structural advance**. Steps (1)–(7) above
  are axiom-clean **except** for `hrange` (step 5), which carries
  the substantive sorry. The cocycle proof now reduces cleanly to
  the topological range containment statement.

- **Key axiom-clean structural pieces landed this iter**:
  * **`QuasiSeparatedSpace` chain** (lines ~604–614 in current file):
    `QuasiSeparated PLB.hom → QuasiSeparatedSpace PLB.left →
     QuasiSeparated (pullback.fst PLB.hom PLB.hom) →
     QuasiSeparatedSpace (pullback PLB.hom PLB.hom)`.
  * **`QuasiCompact s_pair`** (line ~617):
    `quasiCompact_of_compactSpace _` from `[CompactSpace
    intersection] [QuasiSeparatedSpace codomain]`.
  * **Cocycle deduction from factorization** (lines ~664–686):
    given `s : intersection → PLB` with `s ≫ Δ = s_pair`, both
    `pullback.fst (cover) ≫ chart 0` and `pullback.snd (cover) ≫
    chart 1` equal `s` via `pullback.diagonal_fst/_snd` + the
    `hs_fst`/`hs_snd` projection identities of `s_pair`.

- **Substantive residual** (the SINGLE remaining sorry on this
  lemma): `hrange : Set.range s_pair.base ⊆ Set.range
  (pullback.diagonal PLB.hom).base`. This is the topological
  range containment of the pair-morphism's image in the diagonal.

- **Why the residual is genuinely substantive**:
  Proving `hrange` requires either:
  (a) a closed-points + Jacobson density argument computing both
      chart maps on `k̄`-rational points (~30-50 LOC: identify
      `(intersection)(k̄) ≃ k̄* × k̄*`, evaluate `chart 0` and
      `chart 1` at `(x, λ)` to obtain matching `k̄`-points
      `[xλ : 1] ∈ PLB(k̄)`, conclude via continuity + dense closed
      points = full range);
  (b) the direct ring-level identity `λ · u = (1/t) · λ` in
      `Localization.Away t ⊗[kbar] GmRing kbar` (essentially the
      classical path (III.a) computation, blocked since iter-181
      by `Iso.trans_inv` simp coverage gap on the
      `gmScalingP1_cover_intersection_X_iso` `≪≫`-chain — NOT
      revisited this iter).

- **Reason no further closure attempted this iter**:
  Route (a) requires `(intersection)(k̄)` identification —
  `Spec ((Away (X_0·X_1)) ⊗ GmRing)` k̄-rational points correspond
  to maximal ideals with residue field `k̄`. The chart-side
  computation is structurally similar to the iter-188+ struggle
  with `Proj.appIso` (Lane E). Estimated ~60-100 LOC across
  multiple iters.
  Route (b) is path (III.a) — empirically blocked since iter-181.

### Mathlib lemmas confirmed PRESENT and USED
- `AlgebraicGeometry.IsClosedImmersion.lift_iff_range_subset`
  (`Genus0BaseObjects/Cross01Substrate.lean:71` — Substrate 1,
  iter-189 axiom-clean).
- `AlgebraicGeometry.IsSeparated.isClosedImmersion_diagonal`
  (`Mathlib/AlgebraicGeometry/Morphisms/Separated.lean:46`).
- `AlgebraicGeometry.quasiSeparatedSpace_of_quasiSeparated`
  (`Mathlib/AlgebraicGeometry/Morphisms/QuasiSeparated.lean:148`).
- `AlgebraicGeometry.quasiCompact_of_compactSpace`
  (`Mathlib/AlgebraicGeometry/Morphisms/QuasiSeparated.lean:243`,
  low-priority instance).
- `CategoryTheory.Limits.pullback.diagonal_fst` /
  `pullback.diagonal_snd`
  (`Mathlib/CategoryTheory/Limits/Shapes/Diagonal.lean:46,50`).

### Mathlib lemmas confirmed NOT SHIPPED (preserved iter-188 finding)
- `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` (no
  generic direct shim for tensor-of-domains-over-alg-closed-field);
  the project's Substrate 2 supersedes this for our concrete factors.
- `IsScheme.range_eq_image_of_closedPoints_dense` style
  density lemma — not surveyed in this session; iter-194+ worth
  searching via `lean_state_search` on the topological range
  containment goal.

## `gmScalingP1_collapse_at_zero` (line 833)

### Attempt 1 — Time-budget hold

- **Approach**: Did not attempt this iter. The proof requires
  (1) building a section `s : Gm.left → cover.X 1` factoring the
  LHS pullback.lift through chart-1 of the cover, (2) computing
  `s ≫ chart 1` on the actual ring map. Step (2) is structurally
  similar to the cross01 ring-level computation that's blocked.
- **Result**: UNCHANGED (sorry preserved with iter-185 documentation).
- **Next step recommendation**: After cross01's range containment
  closes, the same ring-level machinery (chart 1 ring map
  evaluation, chart-1 source iso composition) directly produces
  the section + chart-1 computation needed here. Best estimate:
  iter-195+ after Lane E's `iotaGm_chart1_appIso_eval`-route
  matures the chart-1 ring-map evaluation idiom.

## Net trajectory

- **Sorries**: 2 → 2 (file count unchanged).
- **Axiom-clean helpers added**: 3+ structural pieces (QSS chain,
  QuasiCompact deduction, cocycle-from-factorization deduction).
- **Substantive residual narrowed**: from "missing Substrate 1 +
  full ring-level identity" (iter-188+) → "topological range
  containment via closed-points or remaining ring-level identity"
  (iter-193).
- **Files moved**: `projectiveLineBar_isReduced` instance moved up
  ~370 lines (no API change — instance still resolves identically
  for downstream code).

## Mathlib-doctor flags
- 3 long-line warnings (lines 901/926/933, all in existing code
  not modified this iter — pre-existing baseline).
- 1 `show` vs `change` warning (line 954, pre-existing).

## HARD BAR assessment

**HARD BAR MET**: ≥1 axiom-clean helper in the range-containment
chain landed (in fact, 3+: `hPLB_QSS`, `hcodom_QSS`, `hs_pair_QC`,
plus the entire `lift_iff_range_subset`-to-cocycle deduction).

## PUSH-BEYOND assessment

**PUSH-BEYOND NOT MET**: full closure of
`gmScalingP1_chart_agreement_cross01` and attempt of
`gmScalingP1_collapse_at_zero` BOTH remain open. The substantive
residual is the topological range containment.

## Blueprint hints

The lemma `gmScalingP1_chart_agreement_cross01` now matches the
(III.c) blueprint recipe of `AbelianVarietyRigidity.tex` precisely:
steps 1–5 (separated-locus structural setup + range-containment-
via-`lift_iff_range_subset` + cocycle-from-`diagonal_fst/snd`) are
axiom-clean; step 3's range containment is the named residual.

**No `\mathlibok` / `\leanok` adjustments warranted from prover
side** — `\leanok` is managed deterministically by `sync_leanok`
based on `sorry` count (which is unchanged: still 1 in this
lemma). The structural advance is a Tier-2 narrative point for
the review agent.
