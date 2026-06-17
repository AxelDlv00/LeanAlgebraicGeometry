# iter-167 objectives — per-attempt scope

## Lane A — `AlgebraicJacobian/Genus0BaseObjects.lean`

### PRIMARY (must-land for status COMPLETE)

- **`gmScalingP1` body** (L437/L439). Chartwise glue via
  `Scheme.Cover.glueMorphisms` over `Proj.affineOpenCoverOfIrrelevantLESpan` (specialised to
  `![X₀, X₁]`). 2 chart morphisms (`t ↦ λ·t`, `u ↦ u/λ`); cross-chart agreement via
  `pullbackSpecIso`. ~150–250 LOC.
- **`gmScalingP1_collapse_at_zero` body** (L452/L456). Once `gmScalingP1` is concrete, the
  chart-level computation `λ·0 = 0` discharges via the `glueMorphisms_at_chart` (or
  equivalent) lookup at the `D₊(X₀)` chart. ~30–50 LOC.
- **`instance : IsReduced (ProjectiveLineBar kbar).left`** — `IsReduced.of_openCover` over
  `Proj.affineOpenCover` with chart `Spec (HomogeneousLocalization.Away 𝒜 X_i)`. Domain via
  `HomogeneousLocalization.Away` API. ~30 LOC.
- **`instance : LocallyOfFiniteType (ProjectiveLineBar kbar).hom`** — `Proj.toSpecZero` LOFT
  + composition. ~5 LOC.
- **`instance : GeometricallyIrreducible (Gm kbar).hom`** — `Spec` of an alg-closed-domain
  is `GeometricallyIrreducible`. ~5 LOC.
- **`instance : LocallyOfFiniteType (Gm kbar).hom`** — `LocallyOfFinitePresentation → LOFT`
  built-in Mathlib instance. ~3 LOC.
- **Product instances on `(ℙ¹ ⊗ Gm)`** — `GeometricallyIrreducible.comp` + LOFT
  composition+base-change + `IsReduced.of_openCover` over the chart `Spec (k̄[t, λ, λ⁻¹])`.
  ~30–60 LOC.

### OPT-IN (close if PRIMARY lands with budget remaining)

- `gm_grpObj` (L400) — 4-step `GrpObj.ofRepresentableBy` bijection per analogist recipe.
  ~50–100 LOC.
- `ga_grpObj` (L335) — FREE via `AffineSpace.homOverEquiv`. ~3–5 LOC.
- `projectiveLineBar_geomIrred` (L177) — shares the `Proj.affineOpenCover` chart-cover
  technique with `IsReduced ProjectiveLineBar.left`. ~20 LOC.
- `projectiveLineBar_smoothOfRelDim` (L184) — may need a smoothness-of-`Proj` Mathlib check
  first; PARTIAL acceptable.

## Lane B — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

### PRIMARY (must-land for status COMPLETE)

- **Close L944**: `GeometricallyIrreducible ((ℙ¹) ⊗ Gm).hom` — replace `sorry` with
  `inferInstance` once Lane A exports.
- **Close L949**: `LocallyOfFiniteType ((ℙ¹) ⊗ Gm).hom` — same.
- **Close L953**: `IsReduced ((ℙ¹) ⊗ Gm).left` — same.
- **Close L1029**: `IsReduced (ProjectiveLineBar).left` — same.
- **Drop the 5 `-- TODO:` excuse comments** (L943, L947-948, L952, L1028, L1034-1036) per
  lean-auditor iter-166 major; replace inline rationale with calls to Lane A's named
  instances.

### OPT-IN (close if Lane A's `gmScalingP1` body lands)

- **Close L1037**: `IsDominant iotaGm.left` — once Lane A's `gmScalingP1` is the concrete
  chartwise glue, `iotaGm = lift (toUnit Gm ≫ onePt) (𝟙 Gm) ≫ gmScalingP1` becomes the
  standard open-immersion `Gm = Spec k̄[t, t⁻¹] ↪ ℙ¹` (`λ ↦ [λ:1]`). Density follows from
  `ℙ¹` irreducible + `Gm` non-empty. Add a small `iotaGm_isDominant` lemma. ~20–40 LOC.

## Out of scope this iter (do NOT touch)

- `genusZero_curve_iso_P1` body (L1131/L1137) — RR-bridge, iter-168+.
- Stale-narrative blocks in fallback files — hygiene iter when no critical-path lane open.
- Protected signatures.
- The chapter — blueprint-writer already landed iter-167 edits.

## Status target summary

- Lane A COMPLETE: PRIMARY + ≥1 OPT-IN closed.
- Lane A PARTIAL: only the 4 product/Proj instances close (Lane B still unblocks for 4 of 5).
- Lane B COMPLETE: all 5 aux sorries close + all 5 TODO comments dropped.
- Lane B PARTIAL: 4 of 5 aux sorries close (L1037 deferred to iter-168 if Lane A blocks).

## Build / axiom expectations

- `lake build AlgebraicJacobian` must exit 0 (sorry warnings only allowed on residuals).
- New declarations must `lean_verify` to `{propext, Classical.choice, Quot.sound}` or
  `{propext, sorryAx, Classical.choice, Quot.sound}` (sorryAx only when a documented
  residual is in the call chain).
- NO new `axiom` declarations.
- NO protected-signature edits.

## Read-before-attempting

- `analogies/gm-grpobj-and-friends.md` — analogist's persistent rationale with concrete
  Mathlib citations for every iter-167 target.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex` — sections `def:genus0_base_objects`,
  `def:gaTranslationP1`, `lem:gmScaling_fixes_zero` (NEW iter-167), and the proof of
  `prop:morphism_P1_to_AV_constant`.
