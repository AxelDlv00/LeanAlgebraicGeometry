# Iter-165 objectives detail

## Lane 1 — NEW FILE `AlgebraicJacobian/Genus0BaseObjects.lean` (mathlib-aligned scaffold)

**Per analogist `gm-scaling-p1` (4 ALIGN_WITH_MATHLIB verdicts) and progress-critic `routec`
(CONVERGING, depth-conversion iter).**

### Blueprint backing (HARD GATE cleared via the extension)
`blueprint/src/chapters/AbelianVarietyRigidity.tex`:
- L1 declaration extended this iter: `% archon:covers AlgebraicJacobian/AbelianVarietyRigidity.lean AlgebraicJacobian/Genus0BaseObjects.lean`
- `def:genus0_base_objects` (L908ff) — `ProjectiveLineBar`, `Ga`, `Gm` definitions + the three k̄-points
  + the two charts.
- `def:gaTranslationP1` (L941ff) — `gmScalingP1` (primary) + `gaTranslationP1` (demoted companion)
  scaling/translation actions; load-bearing fixed-point properties.
- Both blocks were verified by `blueprint-reviewer avr-fastpath2` (iter-164 HARD GATE clearance).

### Imports the prover should add
- `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proper` — `IsProper (Proj.toSpecZero 𝒜)` (FREE).
- `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Scheme` / `…Basic` — `Proj`, `Proj.awayι`,
  `Proj.affineOpenCover`.
- `Mathlib.AlgebraicGeometry.AffineSpace` — `AffineSpace`, `AffineSpace.homOverEquiv` (L155),
  `AffineSpace.instLocallyOfFinitePresentation…OfFinite`.
- `Mathlib.AlgebraicGeometry.AffineScheme` — `IsLocalization.Away f Γ(X, X.basicOpen f)` (L632/651/666),
  `Spec_basicOpen` (L596).
- `Mathlib.AlgebraicGeometry.Group.Smooth` — `smooth_of_grpObj_of_isAlgClosed` (L38).
- `Mathlib.CategoryTheory.Monoidal.Cartesian.Grp_` — `GrpObj.ofRepresentableBy` (L35).
- `Mathlib.AlgebraicGeometry.Gluing` — `Scheme.Cover.glueMorphisms`.
- `Mathlib.AlgebraicGeometry.Morphisms.Separated` — re-export the host `[IsSeparated]` instances
  the downstream rigidity consumer needs.

### Sequential parts (one prover, one file, sequential within)

#### (A) `ProjectiveLineBar`
- Pick the standard ℕ-graded `𝒜 : ℕ → Submodule k̄ (MvPolynomial (Fin 2) k̄)` (total degree).
- Need `GradedRing 𝒜` — routine MvPolynomial homogeneous-decomposition; if Mathlib already ships
  a "standard grading on MvPolynomial" helper, use it; else build the `Submodule.homogeneous` style
  from `MvPolynomial.homogeneousSubmodule`.
- `def ProjectiveLineBar : Scheme.Over (Spec (.of kbar)) := (Proj 𝒜).asOver (Spec (.of kbar))`.
  (Pick exact `.asOver` shape per the AVR file's existing usage — see the abstract `P1` proxy at
  L909-926 for the typeclass-bundle the downstream consumer expects.)
- Instance: `IsProper ProjectiveLineBar.hom` — FREE via `Mathlib.AlgebraicGeometry.ProjectiveSpectrum.Proper:366`
  (provided `Algebra.FiniteType (𝒜 0) A` — which is `Algebra.FiniteType k̄ k̄` after base change, trivial).
- Open immersions: `def chart0 : Spec (.of (HomogeneousLocalization.Away 𝒜 X₀)) ⟶ Proj 𝒜.asOver _`
  and `def chart1` analogously via `Proj.awayι`. These supply the two affine charts `𝔸¹ = D₊(X₀)`
  and `D₊(X₁) = ℙ¹ ∖ {0}` the σ_× construction needs.
- k̄-points: `def zeroPt onePt inftyPt : 𝟙_ ⟶ ProjectiveLineBar` via `Proj.awayι`-then-section-of-the-chart.
- **Scaffold sorries** (acceptable this iter):
  - `instance : GeometricallyIrreducible ProjectiveLineBar.hom := sorry` (Mathlib doesn't ship this
    on `Proj`; sub-build for iter-166+).
  - `instance : SmoothOfRelativeDimension 1 ProjectiveLineBar.hom := sorry` (same).

#### (B) `Ga`
- `def Ga : Scheme.Over (Spec (.of kbar)) := (AffineSpace (Fin 1) (Spec (.of kbar))).asOver _`.
  (Or `AffineSpace.over` if that's the canonical `asOver` shape — analogist cited the AffineSpace API.)
- Instances: `IsAffine` (from `AffineSpace` API when base is affine), `LocallyOfFinitePresentation Ga.hom`
  (from `AffineSpace.instLocallyOfFinitePresentation…OfFinite` since `Fin 1` is finite), `IsReduced Ga.left`
  (MvPolynomial over a field is a domain ⟹ reduced).
- `instance : GrpObj Ga := GrpObj.ofRepresentableBy _ (additiveFunctor) (representableByWitness)`
  where:
  - `additiveFunctor : (Over (Spec (.of kbar)))ᵒᵖ ⥤ AddGrpCat`, `T ↦ AddGrpCat.of Γ(T.left, ⊤)`,
    using the additive-group structure on global sections.
  - `representableByWitness : (additiveFunctor ⋙ forget).RepresentableBy Ga` —
    use `AffineSpace.homOverEquiv` (`Mathlib.AlgebraicGeometry.AffineSpace:155`) which says
    S-morphisms `T ⟶ 𝔸(1; S)` correspond to `Γ(T.left, ⊤)` (one global section, since `Fin 1`).
- `instance : Smooth Ga.hom := smooth_of_grpObj_of_isAlgClosed _` (needs `[GrpObj]`,
  `[LocallyOfFinitePresentation]`, `[IsReduced _.left]`, `[IsAlgClosed kbar]` — all in scope).

#### (C) `Gm`
- `def Gm : Scheme.Over (Spec (.of kbar)) := (Spec (.of (Localization.Away (X : MvPolynomial Unit kbar)))).asOver _`
  (= `Spec k̄[t, t⁻¹]`). Underlying scheme IS AFFINE — NOT the basic-open path (analogist D2.b
  explicitly rules out `(AffineSpace _).basicOpen _` because the basic-open shape weakens
  `IsAffine` and forces bridge lemmas).
- Instances: `IsAffine` (Spec of CommRing), `LocallyOfFinitePresentation Gm.hom` (from
  `Algebra.FinitePresentation k̄ k̄[t,t⁻¹]`), `IsReduced Gm.left` (localization of a polynomial ring
  over a field is a domain).
- `instance : GrpObj Gm := GrpObj.ofRepresentableBy _ (unitsFunctor) (representableByWitness)`
  where:
  - `unitsFunctor : (Over (Spec (.of kbar)))ᵒᵖ ⥤ GrpCat`, `T ↦ GrpCat.of Γ(T.left, ⊤)ˣ`.
  - `representableByWitness` — morphisms `T ⟶ Spec k̄[t,t⁻¹]` correspond bijectively to units of
    `Γ(T.left, ⊤)`. Use the Mathlib chain: `Spec.map` adjunction (`CommRingCat.algebraMap`) +
    `IsLocalization.Away f Γ(X, X.basicOpen f)` (`Mathlib.AlgebraicGeometry.AffineScheme:632/651/666`).
- `instance : Smooth Gm.hom := smooth_of_grpObj_of_isAlgClosed _`.

#### (D) `gmScalingP1` + `gmScalingP1_collapse_at_zero`
- `noncomputable def gmScalingP1 : ProjectiveLineBar ⊗ Gm ⟶ ProjectiveLineBar` in
  `Over (Spec (.of kbar))`, via `Scheme.Cover.glueMorphisms` over the cover `{D₊(X₀) × Gm, D₊(X₁) × Gm}`:
  - Chart 0 (`D₊(X₀) ≅ 𝔸¹`, coordinate `t`): the restriction is `Spec.map` of the algebra map
    `k̄[t] → k̄[t, λ, λ⁻¹]`, `t ↦ λ·t` (target = `D₊(X₀)`; the polynomial map is regular everywhere).
  - Chart 1 (near `∞`, coordinate `u = X₁/X₀ = 1/t`): the restriction is `Spec.map` of
    `k̄[u] → k̄[u, λ, λ⁻¹]`, `u ↦ u/λ` (regular because `λ ∈ Gm` is invertible — target chart 1).
  - The `Gluing.glueMorphisms` precondition is agreement on `(D₊(X₀) ∩ D₊(X₁)) × Gm = Spec k̄[t, t⁻¹, λ, λ⁻¹]`:
    on this localization both restrictions are `Spec.map` of `t ↦ λ·t` (the second restriction
    rewrites under `u = 1/t` to give the same target value). Direct ring-level computation.
- **The load-bearing lemma `gmScalingP1_collapse_at_zero`:**
  ```lean
  lemma gmScalingP1_collapse_at_zero :
      lift (toUnit Gm ≫ zeroPt) (𝟙 Gm) ≫ gmScalingP1 = toUnit Gm ≫ zeroPt
  ```
  (or whatever the *exact* shape is that matches `_hf`'s slot in `hom_additive_decomp_of_rigidity`
  — see AVR.lean L813ff for Cor 1.5's signature; the iter-166 consumer will `rw` against this).
  Proof: the constant-`0`-in-the-first-factor restriction of `gmScalingP1` factors through the
  `t = 0` section of `D₊(X₀) ≅ 𝔸¹`, which is `0` regardless of `λ` (chartwise: `λ · 0 = 0`).
  Direct compute through `Scheme.Cover.glueMorphisms`'s component-equality lemma.

### Scope guard / hard rules
- DO NOT introduce `class IsSchemeMulAction` or any `MulAction`-style typeclass wrapper. The
  analogist D3 verdict is explicit: no such typeclass exists at scheme level in Mathlib; bare
  morphism + named lemma is the precedent (e.g. `GrpObj.mulRight`).
- DO NOT define `Gm` as `(AffineSpace _).basicOpen _`. Use `Spec k̄[t,t⁻¹]`. Per D2.b.
- DO NOT install `GrpObj` via hand-rolled `μ : G ⊗ G ⟶ G` definitions. Use
  `GrpObj.ofRepresentableBy` everywhere. Per D2.a/b.
- DO NOT touch `AbelianVarietyRigidity.lean` (the import + signature refactor + proof close is
  iter-166).
- DO NOT touch any protected signature.
- No new axioms.
- Every `sorry` must be the body of a top-level named declaration (NEVER buried in
  `letI`/`have`/anonymous-`fun`).

### Status outcomes (per progress-critic)
- COMPLETE if all 4 main defs + their primary instances + `gmScalingP1_collapse_at_zero` lemma
  land cleanly.
- PARTIAL if ≥3 of 4 defs land; some instance synthesis trips (most likely
  `GrpObj.ofRepresentableBy`). iter-166 plan agent re-dispatches mathlib-analogist on the failing
  piece.
- INCOMPLETE only if <3 defs land. Triggers iter-166 iter-flag-CHURNING tripwire — see iter-165
  plan.md "Cheapest reversal signal" for the corrective.
