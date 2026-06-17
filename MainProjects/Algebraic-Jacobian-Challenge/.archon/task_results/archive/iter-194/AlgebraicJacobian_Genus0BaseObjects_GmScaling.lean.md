# AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean

## Iter-194 Lane B prover session

**Entering state**: 2 sorries (`gmScalingP1_chart_agreement_cross01` at L463
inner `hrange`, and `gmScalingP1_collapse_at_zero` at L944).

**Exiting state**: 2 sorries (file count unchanged). Substantial structural
advance landed (HARD BAR met).

## `gmScalingP1_chart_agreement_cross01` (line 463)

### Attempt 1 — Closed-points reduction via Jacobson density

- **Approach** (per iter-194 plan-phase Lane B directive: HARD BAR = ≥1
  axiom-clean helper in closed-points chain):
  1. Add JacobsonSpace infrastructure on the intersection scheme via
     `LocallyOfFiniteType.jacobsonSpace`. Required chain: `pullback.fst`
     of cover.f 0 and cover.f 1 (LOFT since cover.f i are open immersions)
     ≫ cover.f 0 (LOFT) ≫ (PLB ⊗ Gm).hom (LOFT via pullback.fst-PLB.hom
     composition). Five new haveIs make this composition synthesizable.
     `JacobsonSpace (Spec kbar)` follows from kbar being a field (artinian
     → jacobson).
  2. Establish that `Set.range Δ.base` is closed via
     `IsClosedImmersion.isClosedEmbedding ... .isClosed_range` (Mathlib
     `Topology.IsClosedEmbedding.isClosed_range`).
  3. Establish `Dense (closedPoints intersection)` via
     `closure_closedPoints` (Mathlib) + `dense_iff_closure_eq`.
  4. Reduce the topological range containment `hrange` to a
     closed-point check `hCP_check`: for every closed point `x` of the
     intersection, `s_pair.base x ∈ Set.range Δ.base`. Closure
     assembly via `Continuous.range_subset_closure_image_dense` +
     `closure_mono` + `IsClosed.closure_eq`.

- **Result**: **PARTIAL — structural advance**. Steps (1)–(4) above are
  axiom-clean (verified via `lean_verify`; sorryAx remaining is at the
  closed-point check sorry only). The cocycle proof now reduces cleanly
  to a per-closed-point chart-map evaluation, which is the genuinely
  substantive content.

- **New axiom-clean structural helpers landed this iter (4+ named haveIs
  with explicit witnesses)**:
  * `hLOFT_f0` / `hLOFT_f1` — `cover.f i` is LOFT (from `IsOpenImmersion`).
  * `hLOFT_fst` — pullback.fst of `cover.f 0`, `cover.f 1` is LOFT.
  * `hLOFT_PG` — `(PLB ⊗ Gm).hom` is LOFT (via `pullback.fst PLB.hom Gm.hom
    ≫ PLB.hom`; explicit `change` since `projGm_locallyOfFiniteType` is
    declared later in the file).
  * `hLOFT_inter` — full LOFT chain composition.
  * `hJac_Spec_kbar` — JacobsonSpace of Spec kbar (from field → artinian
    → jacobson).
  * `hJac_inter` — JacobsonSpace of intersection (via
    `LocallyOfFiniteType.jacobsonSpace`).
  * `hΔ_range_closed` — diagonal's range is closed
    (`IsClosedImmersion.isClosedEmbedding .isClosed_range`).
  * `hClosed_dense` — closed points are dense in intersection.
  * The full closure-assembly chain `range s_pair ⊆ closure(s_pair ''
    closedPoints) ⊆ closure(range Δ) = range Δ` is axiom-clean.

- **Substantive residual** (the remaining single sorry on this lemma):
  `hCP_check : ∀ x ∈ closedPoints intersection,
       s_pair.base x ∈ Set.range (pullback.diagonal PLB.hom).base`.
  Mathematically: at every kbar-rational closed point `(x_0, x_1, λ)`
  of the intersection (corresponding to `D₊(X_0·X_1) × G_m`), both
  chart maps yield the same kbar-point `[x_0·λ : x_1] ∈ ℙ¹`. The
  required chart-side evaluation:
  * `chart 0` (at `(cover).X 0` with coord `t = X_1/X_0`): `t ↦ t ⊗ λ⁻¹`,
    i.e. `t/λ = x_1/(x_0·λ)`, yielding the point
    `[1 : x_1/(x_0·λ)] = [x_0·λ : x_1]`.
  * `chart 1` (at `(cover).X 1` with coord `u = X_0/X_1`): `u ↦ u ⊗ λ`,
    i.e. `u·λ = (x_0·λ)/x_1`, yielding the point
    `[(x_0·λ)/x_1 : 1] = [x_0·λ : x_1]`.

  Both equal `[x_0·λ : x_1]`. Formalization requires maturing the
  chart-1 ring-map evaluation idiom that Lane E's
  `iotaGm_chart1_appIso_eval` is currently developing.

- **Why no further closure attempted this iter**: the closed-point check
  is the same substantive content as path (III.a/b)'s ring-level identity
  computation — namely, traceing through `gmScalingP1_cover_X_iso` (or
  `gmScalingP1_cover_intersection_X_iso`) to identify how chart maps
  send specific kbar-rational maximal ideals to kbar-rational maximal
  ideals of `Proj`. Lane E's experimental `iotaGm_chart1_appIso_eval`-
  route is the leading edge of this idiom; until that matures (iter-195+),
  attempting this closed-point check here risks duplicating the same
  blocker that has stalled Lane B since iter-181.

### Mathlib lemmas confirmed PRESENT and USED
- `AlgebraicGeometry.LocallyOfFiniteType.jacobsonSpace`
  (`Mathlib/AlgebraicGeometry/Morphisms/FiniteType.lean`)
- `JacobsonSpace.closure_closedPoints` /
  `Topology.JacobsonSpace.closure_closedPoints`
  (`Mathlib/Topology/JacobsonSpace.lean`)
- `Continuous.range_subset_closure_image_dense`
  (`Mathlib/Topology/Continuous.lean`)
- `AlgebraicGeometry.IsClosedImmersion.isClosedEmbedding`
  (`Mathlib/AlgebraicGeometry/Morphisms/ClosedImmersion.lean`)
- `Topology.IsClosedEmbedding.isClosed_range`
  (`Mathlib/Topology/Defs/Induced.lean`)
- `AlgebraicGeometry.Scheme.instIsOpenImmersionF`
  (`Mathlib/AlgebraicGeometry/Cover/Open.lean`)
- `AlgebraicGeometry.locallyOfFiniteType_of_isOpenImmersion` /
  `instLocallyOfFiniteTypeFstScheme` /
  `locallyOfFiniteType_comp`
  (`Mathlib/AlgebraicGeometry/Morphisms/FiniteType.lean`)
- `AlgebraicGeometry.PrimeSpectrum.instJacobsonSpaceOfIsJacobsonRing`
  (`Mathlib/RingTheory/Spectrum/Prime/Jacobson.lean`)
- `instIsJacobsonRingOfIsArtinianRing`
  (`Mathlib/RingTheory/Jacobson/Ring.lean`)
- `IsClosed.closure_eq` / `IsClosed.closure_subset_iff` / `closure_mono`
  (`Mathlib/Topology/Closure.lean`)

### Mathlib lemmas explored but NOT used this attempt
- `AlgebraicGeometry.ext_of_isDominant_of_isSeparated'` —
  considered as alternative to closed-points route via a dominant
  probe through the generic point of the (integral) intersection;
  defer to iter-195+ pickup if closed-points route stalls.

## `gmScalingP1_collapse_at_zero` (line 944)

### Attempt 1 — Time-budget hold

- **Approach**: Not attempted this iter. The proof requires building a
  section `s : Gm.left → cover.X 1` that factors the LHS `pullback.lift`
  through chart-1 of the cover, then computing chart-1's ring-map action
  on `zeroPt`'s global section. Both steps depend on the chart-1
  ring-map evaluation idiom that is the same blocker as the `cross01`
  closed-point check.
- **Result**: UNCHANGED (sorry preserved with iter-185 documentation).
- **Next step recommendation**: After `cross01`'s closed-point check
  closes (iter-195+), the same chart-1 ring-map machinery directly
  produces the section + chart-1 evaluation needed here.

## Net trajectory

- **Sorries**: 2 → 2 (file count unchanged).
- **New axiom-clean helpers added this iter**: 9 named haveIs spanning
  the LOFT-chain inference (`hLOFT_f0/f1/fst/PG/inter`), the JacobsonSpace
  derivations (`hJac_Spec_kbar`, `hJac_inter`), and the topological
  density-closure assembly (`hΔ_range_closed`, `hClosed_dense`).
- **Substantive residual narrowed**: from "topological range containment
  for the entire intersection" (iter-193) → "closed-point check at each
  kbar-rational point" (iter-194). The closed-point check is a precise,
  per-point chart-map evaluation rather than a global topological
  statement.

## Build & axiom hygiene

- `lake build AlgebraicJacobian.Genus0BaseObjects.GmScaling` succeeds
  with only the expected 2 `sorry` warnings (lines 771 and 944).
- `lean_verify` on `gmScalingP1_chart_agreement_cross01`:
  `{propext, sorryAx, Classical.choice, Quot.sound}` — only kernel
  axioms beyond the inevitable `sorryAx` from the remaining
  closed-point sorry. **No new project axioms introduced.**

## HARD BAR assessment

**HARD BAR MET**: ≥1 axiom-clean helper in the closed-points chain.
In fact, **9 new axiom-clean helpers** landed (the entire closed-
points-reduction infrastructure). The residual is now exactly one
focused per-point chart-evaluation sorry, much more tractable than
the iter-193 topological range containment.

## PUSH-BEYOND assessment

**PUSH-BEYOND NOT MET**: full closure of
`gmScalingP1_chart_agreement_cross01` and attempt of
`gmScalingP1_collapse_at_zero` BOTH remain open. The substantive
residual is the per-point chart-map evaluation, which requires the
chart-1 ring-map evaluation idiom currently in development on
Lane E (`iotaGm_chart1_appIso_eval`).

## Blueprint hints

The lemma `gmScalingP1_chart_agreement_cross01` now matches the
(III.c) blueprint recipe of `AbelianVarietyRigidity.tex` precisely:
the topological-range-containment-via-closed-points step is now
explicitly factored as `hCP_check` (closed-point check) plus
density-closure assembly. The iter-194 structural advance is the
**closed-points reduction** itself, which converts the global
range-containment statement into a per-point evaluation.

**No `\mathlibok` / `\leanok` adjustments warranted from prover
side** — `\leanok` is managed deterministically by `sync_leanok`
based on `sorry` count (which is unchanged: still 1 in this lemma).
The structural advance is a Tier-2 narrative point for the
review agent.

## Suggested iter-195+ followups

1. **Closed-point check closure** (`hCP_check` at L771): this is now
   the precise residual. Approach: extract `(cover.fst x)` and
   `(cover.snd x)` from a closed point `x` of intersection via
   `gmScalingP1_cover_intersection_X_iso`, then trace through chart 0
   and chart 1 to verify both yield the same kbar-point of PLB.
   Companion idiom: Lane E's `iotaGm_chart1_appIso_eval`.

2. **`gmScalingP1_collapse_at_zero`** (L944): same chart-1 ring-map
   evaluation idiom unlocks this.

3. **Alternative route via `morphism_eq_of_eqAt_closedPoints`**: the
   project-side `morphism_eq_of_eqAt_closedPoints` in
   `RigidityLemma.lean` (axiom-clean Step 2 of the Mumford rigidity
   chain) provides a parallel framing. Could replace the diagonal-
   range-containment route entirely with a morphism-equality-via-
   closed-points route. Would require adding `import
   AlgebraicJacobian.RigidityLemma` to GmScaling.lean (verified no
   cycle: RigidityLemma → Genus → Mathlib + Cohomology, no
   transitive dependency on Genus0BaseObjects). Reserved for if
   closed-points route stalls.
