# Mathlib-analogist directive — slug `gmscaling-deep`

## Mode

api-alignment

## Iteration

168

## Question

The iter-167 prover deferred `gmScalingP1` body (`AlgebraicJacobian/Genus0BaseObjects.lean:457`)
for the 3rd consecutive iter. The progress-critic's `routec168` verdict CHURNING
names "Mathlib-idiom consult on the `σ_× : ℙ¹ × 𝔾_m → ℙ¹` chartwise glue" as the
primary corrective. A prior analogist call (`gm-grpobj`, iter-167, persistent file
`analogies/gm-grpobj-and-friends.md`) produced a *sketch-level* recipe; the prover
identified ~30 LOC of intervening helper work (`homogeneousLocalizationAwayIso :
HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (MvPolynomial.X i) ≃+*
MvPolynomial Unit kbar`) that was not in the previous sketch but is on the critical
path.

This consult is the **deeper, transcription-ready** consult. The deliverable I need
is a concrete enough recipe that a prover can transcribe each step into Lean syntax
without further design decisions. NOT a brand-new survey — read the previous file
first and EXTEND it.

### Sub-questions (answer each)

**Q1** — The 2-chart cover of `ProjectiveLineBar kbar` via
`AlgebraicGeometry.ProjectiveSpectrum.affineOpenCoverOfIrrelevantLESpan` specialised
to the irrelevant ideal's 2 generators `![X 0, X 1]` for the standard ℕ-grading on
`MvPolynomial (Fin 2) kbar`. What is the exact Mathlib API for installing this as a
`Scheme.AffineOpenCover`? Concrete code skeleton — name the type, the index set, the
`f` and `iso` fields. Cite the file:line of every Mathlib lemma you use.

**Q2** — The `homogeneousLocalizationAwayIso` helper itself:
`HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (MvPolynomial.X i) ≃+*
MvPolynomial Unit kbar` (i.e. the deg-0 part of `MvPolynomial (Fin 2) kbar` localized
at `X_i`'s powers is a polynomial ring in `X_{1-i}/X_i`). What is the canonical
Mathlib path to build this iso? Is `HomogeneousLocalization.Away` a localization of
*the graded ring* (the `MvPolynomial (Fin 2) kbar` filtered by degree) or *just the
degree-0 part*? Check `Mathlib/RingTheory/GradedAlgebra/HomogeneousLocalization.lean`.
If the LOC estimate is wrong, give the right one. If Mathlib already ships the
`Proj ∘ standardₙGraded(k[X_0, …, X_{n-1}]) ≅ 𝔸ⁿ⁻¹`-chart iso for some `n`, name it.

**Q3** — After `homogeneousLocalizationAwayIso` is in hand, the chart-side morphism
on chart 0 is `Spec.map (φ_0 : k̄[t] →+* k̄[t, λ, λ⁻¹]); t ↦ λ·t`. How to plumb this
through `pullbackSpecIso` (which expects ring-tensor `Spec(S ⊗_R T)`) to write the
exact morphism `Spec(k̄[t]) ⊗_{Spec k̄} Spec(GmRing) ⟶ Spec(k̄[t])` in
`Over (Spec (.of kbar))`? Concrete code — `pullbackSpecIso`'s direction (`hom` vs
`inv`), the unit ring map (`MvPolynomial.aeval` vs `MvPolynomial.eval₂RingHom`),
the AsOver lift.

**Q4** — The cross-chart agreement on
`D₊(X_0) ∩ D₊(X_1) ⊗ Gm ≅ Spec(k̄[t, t⁻¹, λ, λ⁻¹])`: which `pullbackSpecIso` chain
gives the agreement, and what is the actual ring-level equation that closes the
`Scheme.Cover.glueMorphisms` hypothesis? Concrete: `pullback.fst _ _ ≫ f₀ = pullback.snd _ _ ≫ f₁`
expanded — at the ring level the two paths reduce to a `MvPolynomial`-level
identity; spell it out (which ring map equates which generators).

**Q5** — `Scheme.Cover.glueMorphisms`'s exact signature on a `Cover` (not
`AffineOpenCover`) and how to bridge: does the project need `.AffineOpenCover.cover`?
What's the chosen type for the cover index? `Fin 2`?

**Q6** — `gmScalingP1_collapse_at_zero` body: once `gmScalingP1` is concrete, the
proof is a chart-level direct computation. Concrete: the section
`zeroPt : 𝟙_ ⟶ ℙ¹` lands in `D₊(X_1)` (since `zeroPt = pointOfVec (fun i => if i = 0 then 0 else 1)`,
so `X_1 ↦ 1` is nonzero at this section). So the precomposition factors through
the chart-1 side of `gmScalingP1`. The chart-1 ring map sends `u ↦ u/λ`; precomposing
with `u ↦ 0` (the chart-1 expression of `zeroPt`) gives `0/λ = 0` constant. Spell
out the exact `pointOfVec` realisation of `zeroPt` on chart 1 + the `Spec.map`
composition + the `rw` or `simp` set that closes the equation.

### Constraint

- Read `analogies/gm-grpobj-and-friends.md` first. Treat it as the iter-167 baseline
  that this consult deepens. The prover identified `homogeneousLocalizationAwayIso`
  AFTER that file landed — that's the gap.
- Read `analogies/gm-scaling-p1.md` if present.
- The deliverable persists to `analogies/gmscaling-deep.md` as a refresh / extension
  of `gm-grpobj-and-friends.md`, NOT a duplicate. If the existing file has a section
  you can build on (e.g. Decision Q3), refresh / extend that section in the new file
  with the deeper detail.
- Concretely: if you can quote Mathlib's `pullbackSpecIso` or
  `affineOpenCoverOfIrrelevantLESpan` exact `def` text, do so verbatim; otherwise
  cite file:line and reproduce the signature.

### Output expectation

Each Q's answer is a "PROCEED / ALIGN_WITH_MATHLIB / NEEDS_MATHLIB_GAP_FILL"
verdict + a code skeleton (or, for Q1/Q2/Q5, the exact API signatures the prover
should call). The whole document should land at ~150-250 lines. Do NOT speculate
beyond what `lean_local_search` / `lean_loogle` / direct Mathlib file reads confirm.
