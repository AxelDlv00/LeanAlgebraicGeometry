# Mathlib Analogist Report

## Mode
api-alignment

## Slug
gm-scaling-p1

## Iteration
165

## Question
For the three new infrastructure declarations of the 𝔾ₘ-scaling shortcut
(`ProjectiveLineBar`, `Gm` + `Ga`, `gmScalingP1`) consumed by
`morphism_P1_to_grpScheme_const` in `AbelianVarietyRigidity.lean`, what is
the Mathlib-aligned shape — for ℙ¹ realization, GrpObj installation idiom,
σ_× shape (typeclass or bare morphism), and file location?

## Verdicts (summary)

| Decision | Verdict | Severity |
|---|---|---|
| D1 — `ProjectiveLineBar` realization (Proj of graded k̄[X₀,X₁] vs. abstract proxy vs. raw glue) | ALIGN_WITH_MATHLIB (use `AlgebraicGeometry.Proj`) + sub-`NEEDS_MATHLIB_GAP_FILL` for Smooth/Geom-irred | major |
| D2 — `Gm`/`Ga` realization + `GrpObj` installation | NEEDS_MATHLIB_GAP_FILL with ALIGN sub-rules (Yoneda via `GrpObj.ofRepresentableBy`; reuse `AffineSpace` for `Ga`; `Spec k̄[t,t⁻¹]` for `Gm`; smoothness FREE via `smooth_of_grpObj_of_isAlgClosed`) | major |
| D3 — `gmScalingP1` shape (typeclass / bare morphism / `Scheme.Cover.glueMorphisms`) | ALIGN_WITH_MATHLIB (bare morphism + named lemma; glue via `Scheme.Cover.glueMorphisms`; no `MulAction` typeclass) | major |
| D4 — file location | ALIGN_WITH_MATHLIB (split to `AlgebraicJacobian/Genus0BaseObjects.lean`; mirrors `Mathlib.AlgebraicGeometry.Group.Smooth` precedent) | informational |

## Major

The scaffold has **not yet shipped** (only the consuming `morphism_P1_to_grpScheme_const`
ships, with an abstract `P1 : Over (Spec kbar)` proxy and a `sorry` body). All four
decisions are therefore "ALIGN before the prover writes the scaffold this iter",
not "refactor shipped code". Concretely:

- **D1 — adopt `Proj`-based ℙ¹**. Define `ProjectiveLineBar` as the base change to `Spec k̄` of `Proj 𝒜` where `𝒜 : ℕ → Submodule k̄ (MvPolynomial (Fin 2) k̄)` is the standard total-degree grading. `IsProper ProjectiveLineBar.hom` is then FREE from `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proper:366` (which proves `IsProper (Proj.toSpecZero 𝒜)` when `Algebra.FiniteType (𝒜 0) A`). The two affine charts `D₊(X₀) ≅ 𝔸¹` and `D₊(X₁) ≅ ℙ¹ \ {0}` are `Proj.awayι` images — usable directly by `gmScalingP1`'s chartwise definition. The three `k̄`-points `0`, `1`, `∞` are `pointOfClosedPoint`-style global sections through these charts.
  - Sub-`NEEDS_MATHLIB_GAP_FILL`: `GeometricallyIrreducible ProjectiveLineBar.hom`, `SmoothOfRelativeDimension 1 _`, and `genus ProjectiveLineBar = 0` are project-side sub-builds Mathlib does not ship for `Proj`. These exist on *every* ℙ¹ realization and are not specific to this verdict.
  - Do **NOT** adopt: (i) `ProjectiveSpace` — it doesn't exist as a `Scheme` in Mathlib (only `Projectivization` from linear algebra). (ii) Pure-glue from `Scheme.GlueData` of two `𝔸¹`s — loses `IsProper` for free and forces the project to reprove what `Proj` ships. (iii) The current abstract proxy `(P1 : Over (Spec kbar))` — it has no charts and cannot host `gmScalingP1`.

- **D2 — Yoneda-install `GrpObj` for `Gm` and `Ga`; reuse `AffineSpace` for `Ga`, `Spec k̄[t,t⁻¹]` for `Gm`; let smoothness come free**.
  - **`Ga`**: `Ga : Over (Spec (.of kbar)) := (AffineSpace (Fin 1) (Spec (.of kbar))).asOver _`. The underlying scheme is Mathlib's `AffineSpace` (`Mathlib.AlgebraicGeometry.AffineSpace:46`), which already ships `IsAffine` (when base is affine), `IsAffineHom`, `Surjective`, `LocallyOfFinitePresentation` (when `n` is finite — `Fin 1` is). Install `GrpObj Ga` via `CategoryTheory.GrpObj.ofRepresentableBy` (`Mathlib.CategoryTheory.Monoidal.Cartesian.Grp_:35`), with the additive-group functor `T ↦ AddGrpCat.of Γ(T.left, ⊤)`. The `RepresentableBy` witness is `AffineSpace.homOverEquiv` (AffineSpace:155): S-morphisms `T ⟶ 𝔸(1; S)` correspond to one global section of `T`. This is the canonical Mathlib idiom — NOT a direct `lift`-based μ-definition (which would build a parallel API around the Yoneda installer Mathlib already provides for exactly this purpose).
  - **`Gm`**: `Gm : Over (Spec (.of kbar)) := (Spec (CommRingCat.of (Localization.Away (X : MvPolynomial Unit kbar)))).asOver _`. Underlying scheme is `Spec k̄[t, t⁻¹]` — affine. Install `GrpObj Gm` via `GrpObj.ofRepresentableBy` with the units-functor `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`. The `RepresentableBy` witness uses `IsLocalization.Away f Γ(X, X.basicOpen f)` (`Mathlib.AlgebraicGeometry.AffineScheme:632/651/666`) and `Spec_basicOpen` (AffineScheme:596).
  - **Smoothness for both**: derive via `AlgebraicGeometry.smooth_of_grpObj_of_isAlgClosed` (`Mathlib.AlgebraicGeometry.Group.Smooth:38`) — `[GrpObj] + [LocallyOfFinitePresentation] + [IsReduced] + [IsAlgClosed K] ⇒ Smooth`. Project owes only `LocallyOfFinitePresentation` and `IsReduced`, both straightforward (`AffineSpace.instLocallyOfFinitePresentation…OfFinite` for `Ga`; finite-presentation of `k̄[t,t⁻¹]` over `k̄` for `Gm`; reducedness from "polynomial / localization over a field is a domain").
  - **`GeometricallyIrreducible` for both**: derive from `GeometricallyIntegral → GeometricallyIrreducible` (`Mathlib.AlgebraicGeometry.Geometrically.Integral:58`); reduce to `IsIntegral` on the global-section ring (immediate over `k̄ = k̄`).
  - Do **NOT** adopt: (i) `Gm = (AffineSpace _).basicOpen (coord _ 0)` — gives a `Scheme.Opens` shape, not an `IsAffine` scheme; the Over-structure and `GrpObj` installation are messier and force bridge lemmas at every consumer. (ii) Hand-rolled `μ : Gm ⊗ Gm ⟶ Gm` via `lift` + `Pi.lift` — duplicates `GrpObj.ofRepresentableBy`. The Yoneda installer is shorter, lemma-rich, and already used internally by `GrpObj`-mathlib downstream.

- **D3 — `gmScalingP1` is a bare morphism, glued via `Scheme.Cover.glueMorphisms`, with a named fixed-point lemma**.
  - Define `gmScalingP1 : ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar` directly as a morphism in `Over (Spec (.of kbar))`. Use `AlgebraicGeometry.Scheme.Cover.glueMorphisms` (`Mathlib.AlgebraicGeometry.Gluing:?`) over the cover `{D₊(X₀) × Gm, D₊(X₁) × Gm}` of `ℙ¹ × Gm`. Each chart-restriction is a `Spec.map` of an explicit `k̄[t, λ, λ⁻¹]`-algebra map (on `𝔸¹ × Gm`: `t ↦ λ·t`; near `∞`: `u ↦ u/λ`); the pairwise-pullback condition is then an equality of ring maps into `k̄[t, t⁻¹, λ, λ⁻¹]` — a direct computation.
  - Expose the single load-bearing property as a named lemma `gmScalingP1_collapse_at_zero` (or similar) in the exact shape `lift (toUnit _ ≫ zeroPt) (𝟙 Gm) ≫ gmScalingP1 = toUnit Gm ≫ zeroPt` that the rigidity consumer `hom_additive_decomp_of_rigidity` will rewrite with.
  - Do **NOT** introduce a typeclass `class IsSchemeMulAction (G H : ...)` or any `MulAction`-style wrapper. **No such typeclass exists at scheme level in Mathlib** (`Mathlib.AlgebraicGeometry.Group.{Abelian,Smooth}` package everything as bare morphisms + named lemmas, exactly the shape we want). The only consumer needs the bare morphism plus the one fixed-point lemma.

- **D4 — split the new declarations into `AlgebraicJacobian/Genus0BaseObjects.lean`**, imported by AVR.lean (which is already 992 lines). Mirror the size/scope of Mathlib's `AlgebraicGeometry.Group.Smooth` (62 lines, one main lemma) and `AlgebraicGeometry.Group.Abelian` (147 lines, one main theorem) — both are short focused files imported by exactly the proofs that need them. This keeps AVR.lean's rigidity-proof content centred and leaves a clean unit for eventual upstreaming.

## Informational

- The `NEEDS_MATHLIB_GAP_FILL` sub-rules under D1 (`GeometricallyIrreducible`, `SmoothOfRelativeDimension 1`, `genus = 0` for `Proj`-based ℙ¹) and D2 (no Mathlib `Gm`/`Ga` at all) are independent of the API-shape decision: every ℙ¹/Gm/Ga realization carries these debts. The `ALIGN_WITH_MATHLIB` verdict picks the realization that makes the *rest* of the API free, even though these specific sub-builds remain.
- The integral-vs-base-changed choice for `Gm`/`Ga` (build over `Spec ℤ` and pull back vs. build directly over `Spec k̄`) is out of scope for this iter — `GrpObjAsOverPullback` (`Mathlib.AlgebraicGeometry.Pullbacks:808`) makes the integral version a free `GrpObj` for any base, so when the project later wants to upstream `Gm`/`Ga` to Mathlib it can refactor at low cost. For the current k̄-only consumer, building directly over `Spec k̄` is sufficient.
- The blueprint's "the open immersion `𝔾ₘ ↪ ℙ¹` has dense image" remark is fulfilled at the proof site by Mathlib's `IsOpen.dense` + `ext_of_isDominant_of_isSeparated'` (the same density argument already used by `Scheme.Over.ext_of_eqOnOpen` in `AlgebraicJacobian/Rigidity.lean:91`). The 𝔾ₘ side ⟶ ℙ¹ open immersion is exactly `Proj.awayι 𝒜 X₀ …`-followed-by-the-open-immersion-of-the-D(t)-subscheme.

## Persistent file
- `analogies/gm-scaling-p1.md` — design-rationale captured for future iters (full Mathlib citations, sub-decision breakdown, recommended file skeleton).

Overall verdict: **build the scaffold this iter in a new file `AlgebraicJacobian/Genus0BaseObjects.lean`, using Mathlib's `Proj` for ℙ¹, `AffineSpace`/`Spec k̄[t,t⁻¹]` for `Ga`/`Gm` with `GrpObj` installed via the Yoneda installer `GrpObj.ofRepresentableBy`, and `gmScalingP1` as a bare `Over`-morphism glued from two affine charts via `Scheme.Cover.glueMorphisms` — no parallel API anywhere on the path.**
