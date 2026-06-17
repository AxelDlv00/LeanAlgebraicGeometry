# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gm-grpobj

## Iteration
167

## Question

Per directive: find the right Mathlib idiom for installing the multiplicative `GrpObj`
structure on `Spec (Localization.Away t)` (Archon's `Gm`) over `Spec k̄` — the iter-166
Lane 2 PARTIAL — plus, alongside, the `gmScalingP1` chartwise glue body and the four
product / Proj-integrality instances on `(ℙ¹ ⊗ Gm)` that `morphism_P1_to_grpScheme_const_aux`
carries as sorries (AVR L944, L949, L953, L1029).

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| Q1: `Gm`/`Ga` realization (does Mathlib ship?) | PROCEED | informational |
| Q2: `GrpObj.ofRepresentableBy` for `gm_grpObj` | PROCEED | informational |
| Q3: `gmScalingP1` via `Cover.glueMorphisms` + `pullbackSpecIso` | PROCEED | informational |
| Q4(a): `GeometricallyIrreducible (ℙ¹ ⊗ Gm).hom` | PROCEED | informational |
| Q4(b): `LocallyOfFiniteType (ℙ¹ ⊗ Gm).hom` | PROCEED | informational |
| Q4(c): `IsReduced (ℙ¹ ⊗ Gm).left` | PROCEED (via workaround) | informational |
| Q4(d): `IsReduced (ProjectiveLineBar).left` | PROCEED | informational |

## Informational

All seven decisions are **PROCEED** — the project's planned paths are Mathlib-aligned
and no parallel-API risks were identified. The one notable gap is *upstream*, not
project-side: Mathlib does NOT ship `Smooth → GeometricallyReduced` at scheme level
(Q4(c)), but the project has a clean workaround via `IsReduced.of_openCover` that
avoids introducing a project-side bridge. Detail per question:

- **Q1 — `Gm` realization (PROCEED).** Mathlib has NO `𝔾_m` / `GroupScheme.Gm` / etc.;
  the only nearby pieces are `AlgebraicGeometry.AffineSpace` (used by the project for
  `Ga`), `Mathlib.AlgebraicGeometry.Group.Smooth` (consumer of arbitrary `GrpObj`),
  and `Mathlib.AlgebraicGeometry.Pullbacks.Scheme.GrpObjAsOverPullback`
  (`Pullbacks.lean:808` — transports `GrpObj` along pullback). The project's
  `Gm = (Spec (.of (Localization.Away (X : MvPolynomial Unit k̄)))).asOver _` encoding
  is the natural "affine `Spec` of `k̄[t, t⁻¹]`" path and is upstream-able later as a
  single ~80-LOC file (no project-specific wrappers to peel off).

- **Q2 — `GrpObj.ofRepresentableBy` (PROCEED).** Confirmed correct idiom (Mathlib's
  ONLY canonical mechanism for installing `GrpObj` on a representable object). Cite:
  `Mathlib.CategoryTheory.Monoidal.Cartesian.Grp_.lean:35`. Body construction:
  ```text
  (T ⟶ Gm)_{/Spec k̄}
    ─ over-cat unfold ─→
  {f : T.left ⟶ Spec(k̄[t, t⁻¹]) // f.IsOver Spec k̄}
    ─ ΓSpec.adjunction (restricted to over-cat) ─→
  {φ : k̄[t, t⁻¹] →+* Γ(T.left, ⊤) // φ ∘ algebraMap k̄ _ = …}
    ─ IsLocalization.Away.lift + IsLocalization.Away.algebraMap_isUnit_iff ─→
  {u : Γ(T.left, ⊤) // IsUnit u}  =  Γ(T.left, ⊤)ˣ
  ```
  Key Mathlib citations: `IsLocalization.Away.lift` (`Localization.Away.Basic:471`),
  `IsLocalization.Away.algebraMap_isUnit` (`L82`), `ΓSpec.adjunction` and `Scheme.ΓSpecIso`
  (`Mathlib.AlgebraicGeometry.GammaSpecAdjunction`). No precedent in Mathlib for a
  concrete `GrpObj` via `ofRepresentableBy` on a scheme (only the abstract `yonedaGrpObjRepresentableBy`
  companion and `CommGrp_`/`CommMon_`/`Mon_` parallel hooks), so the project lands the
  first concrete-scheme use — but the **shape** is identical to what Mathlib would
  itself land.

- **Q3 — `gmScalingP1` glue (PROCEED).** Use `AlgebraicGeometry.Scheme.Cover.glueMorphisms`
  (`Mathlib.AlgebraicGeometry.Gluing.lean:436`) over a 2-element cover constructed via
  `Proj.affineOpenCoverOfIrrelevantLESpan` (`Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Basic.lean:324`)
  specialised to `f = ![X₀, X₁]`. Each chart's morphism is `Spec.map` of a polynomial
  ring map (chart 0: `t ↦ λ·t`; chart 1: `u ↦ u/λ`). Cross-chart agreement uses
  `pullbackSpecIso` (`Pullbacks.lean:703`) to identify the intersection as
  `Spec(k̄[t, t⁻¹, λ, λ⁻¹])`, then a `ring`-level computation. Bare morphism — NO
  `IsAction`/`MulAction`-style typeclass at scheme level (no Mathlib precedent;
  the rigidity consumer needs only the bare morphism + the `gmScalingP1_collapse_at_zero`
  fixed-point lemma).

- **Q4(a) — `GeometricallyIrreducible ((ℙ¹) ⊗ (Gm)).hom` (PROCEED).** Composition via
  `GeometricallyIrreducible.comp` (`Geometrically/Irreducible.lean:121`). Sub-prereqs:
  (i) `[GeometricallyIrreducible (Gm kbar).hom]` — install via reduction
  to `IrreducibleSpace (Spec k̄[t, t⁻¹])` (free from `Localization.Away X` being a
  domain), (ii) `[UniversallyOpen]` on both — free from `Smooth → Flat`
  (`Morphisms/Smooth.lean:113`) + `UniversallyOpen.of_flat`
  (`Morphisms/UniversallyOpen.lean:145`). No project-side gap.

- **Q4(b) — `LocallyOfFiniteType ((ℙ¹) ⊗ (Gm)).hom` (PROCEED).** TRIVIAL. LOFT is both
  `IsStableUnderComposition` (`L63`) AND `IsStableUnderBaseChange` (`L79`); both factors
  LOFT (ℙ¹ from `Proj.toSpecZero` LOFT shipped at `ProjectiveSpectrum.Proper.lean:143`,
  Gm from `LocallyOfFinitePresentation → LocallyOfFiniteType` instance shipped). Closes
  via `infer_instance` after installing one missing instance
  `[LocallyOfFiniteType (ProjectiveLineBar kbar).hom]` on the project side.

- **Q4(c) — `IsReduced ((ℙ¹) ⊗ (Gm)).left` (PROCEED via workaround).** Mathlib's
  shipped instance `GeometricallyReduced.isReduced_of_flat_of_isLocallyNoetherian`
  (`Geometrically/Reduced.lean:106`) is the natural path BUT requires
  `[GeometricallyReduced f]` on one side — and Mathlib does NOT ship
  `Smooth → GeometricallyReduced` at scheme level (genuine Mathlib gap). The project
  should bypass via `IsReduced.of_openCover` over the chart-level cover:
  - `(ℙ¹ ⊗ Gm)` is locally `Spec (k̄[t]) ⊗_{k̄} Spec(k̄[λ, λ⁻¹]) ≅ Spec(k̄[t, λ, λ⁻¹])`
    (via `pullbackSpecIso`), and `k̄[t, λ, λ⁻¹]` is a domain over an alg-closed field
    hence reduced.
  - Same helper closes Q4(d), double-leveraged.

- **Q4(d) — `IsReduced (ProjectiveLineBar).left` (PROCEED).** Mathlib does NOT ship
  `IsReduced` for `Proj` of any graded ring. Standard technique:
  `IsReduced.of_openCover` over `Proj.affineOpenCover` (`Basic.lean:339`), each chart
  being `Spec (HomogeneousLocalization.Away 𝒜 X_i)` — a localization of an integral
  graded ring's degree-0, hence integral (so reduced). Project needs a small bridge:
  `HomogeneousLocalization.Away 𝒜 X_i` is a domain for the standard ℕ-graded
  `MvPolynomial (Fin 2) k̄` — derivable from Mathlib's `HomogeneousLocalization` API in
  `RingTheory.GradedAlgebra.HomogeneousLocalization` (~10 LOC).

**Bonus (out-of-scope per directive but FREE):** `ga_grpObj` at L335 of
`Genus0BaseObjects.lean` becomes a 2-3 line `ofRepresentableBy` proof — Mathlib's
`AffineSpace.homOverEquiv` (`Mathlib.AlgebraicGeometry.AffineSpace.lean:155`) is the
exact additive analogue of the 3-step bijection needed for `gm_grpObj`, packaged as a
single lemma. The reason `gm_grpObj` is the harder of the two: Mathlib has the analogous
lemma for `𝔸(n; S)` but NOT for `Spec (Localization.Away _)` (the natural "missing
companion" to `homOverEquiv`).

## Persistent file
- `analogies/gm-grpobj-and-friends.md` — full design-rationale captured for iter-167+
  prover lane (4 decisions × concrete Mathlib citations + reduction-to-trivial steps).

Overall verdict: project's planned paths are all Mathlib-aligned; the iter-167 prover
lane should `PROCEED` on every front, with one chart-local workaround for the
`Smooth → GeometricallyReduced` Mathlib gap that arises in Q4(c).
