# AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean

## `projectiveLineBar_smooth_chart_aux` (line 406; was `sorry`)

### Attempt 1 — RESOLVED via helper-lemma factoring

- **Approach (closed form):**
  1. Introduce a helper `projectiveLineBar_smooth_chart_X` that proves
     `SmoothOfRelativeDimension 1` for the *named-`X i`* form of the
     chart morphism: `Proj.awayι 𝒜 (X i) _ _ ≫ struct`. Working with
     `X i` (rather than the cover's `(![X 0, X 1] : Fin 2 → _) i`) is
     critical because the chart-ring iso `homogeneousLocalizationAwayIso`
     is stated for `Away 𝒜 (X i)` and direct rewriting of
     `(![X 0, X 1] i)` to `X i` is blocked by dependent typing on
     `f_deg : f ∈ 𝒜 1`.
  2. In the helper, rewrite the structure morphism
     `(ProjectiveLineBar kbar).hom = Proj.toSpecZero ≫ Spec.map (algebraMap kbar (𝒜 0))`
     by `rfl`.
  3. Re-associate the 3-fold composition via an explicit
     `(Category.assoc _ _ _).symm` (a plain `rw [← Category.assoc]`
     fails to find the pattern due to higher-order unification snags on
     the elided proof arguments to `Proj.awayι`).
  4. Apply `Proj.awayι_toSpecZero` to collapse
     `awayι ≫ Proj.toSpecZero` to a `Spec.map (fromZeroRingHom)`.
  5. Apply `Spec.map_comp` (backward) to combine the two `Spec.map`s
     into `Spec.map (CommRingCat.ofHom (kbarToAwayRingHom kbar i))`.
  6. Apply `HasRingHomProperty.Spec_iff (P := @SmoothOfRelativeDimension 1)`
     to translate to the ring-hom property on `kbarToAwayRingHom`.
  7. Apply `RingHom.locally_of RingHom.isStandardSmoothOfRelativeDimension_respectsIso`
     to peel `Locally` off and reduce to direct std-smooth.
  8. `change` the goal to the `algebraMap kbar (Away 𝒜 (X i))` form
     (`kbarToAwayRingHom = algebraMap kbar (Away)` is `rfl` under the
     `algebraKbarAway` instance).
  9. Apply `RingHom.isStandardSmoothOfRelativeDimension_algebraMap.mp`
     to convert to `Algebra.IsStandardSmoothOfRelativeDimension 1 kbar (Away)`.
  10. Build the `kbar`-algEquiv chain
      `MvPolynomial (Fin 1) kbar ≃ₐ[kbar] MvPolynomial Unit kbar ≃ₐ[kbar] Away`
      via `MvPolynomial.renameEquiv kbar finOneEquiv` and
      `AlgEquiv.ofRingEquiv` upgrading `homogeneousLocalizationAwayIso`
      with `homogeneousLocalizationAwayIso_algebraMap`.
  11. Apply `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv (n := 1) e`
      with the chain (composed in the reverse direction:
      `eFin.trans eUnit.symm`) and the substrate
      `mvPolynomialFin_isStandardSmoothOfRelativeDimension 1` from
      `BareScheme.lean`.

  Then in `projectiveLineBar_smooth_chart_aux`:
  1. `simp only [Scheme.AffineOpenCover.openCover_f, projectiveLineBarAffineCover,
      Proj.affineOpenCoverOfIrrelevantLESpan]` to unfold the cover.
  2. `fin_cases i` so `(![X 0, X 1] : Fin 2 → _) ⟨0/1, _⟩` reduces
     definitionally to `X 0` / `X 1`.
  3. `exact projectiveLineBar_smooth_chart_X kbar 0` / `... 1`.

- **Result:** RESOLVED axiom-clean. `projectiveLineBar_smoothOfRelDim`
  is now fully axiom-clean (`propext`, `Classical.choice`, `Quot.sound`
  only — kernel axioms).

- **Key insight:** Direct rewriting of `(![X 0, X 1] : Fin 2 → _) i` to
  `X i` in the cover-derived form is impossible because the membership
  proofs `f_deg : f ∈ 𝒜 1` are tied to the specific elaborated form.
  Factoring out the proof into a named-`X i` helper sidesteps this
  entirely. The fin_cases at the cover-level then handles the bridge
  via definitional reduction of `Matrix.cons` applied to concrete `Fin 2`
  indices.

- **Dead-end warnings (recorded for next iters):**
  - `rw [← Category.assoc]` fails to find the obvious 3-fold composition
    pattern (`?f ≫ ?g ≫ ?h` matches but doesn't fire) — likely a
    higher-order unification interaction with the elided `f_deg`/`hm`
    proofs. Use `rw [(Category.assoc _ _ _).symm]` with explicit
    placement instead.
  - `Proj.awayι_toSpecZero_assoc` (the auto-`@[reassoc]`-generated
    variant) is NOT findable by `lean_local_search` — only
    `Proj.awayι_toSpecZero` itself. The `_assoc` form may not be
    generated as a separate declaration. Use plain `awayι_toSpecZero`
    after manual re-association.
  - `show` (vs. `change`) triggers a style linter warning when the
    goal is genuinely transformed (not just renamed). Use `change`.

## Summary

- **Sorry count**: 1 → 0 in this file. `projectiveLineBar_smooth_chart_aux`
  closed axiom-clean.
- **Cascade**: `projectiveLineBar_smoothOfRelDim` (this file, line 449)
  now also fully axiom-clean — confirmed via `lean_verify`
  (axioms = `{propext, Classical.choice, Quot.sound}`; warnings = `[]`).
- **New helper added**: `projectiveLineBar_smooth_chart_X` (private),
  ~50 LOC. Self-contained; depends only on `homogeneousLocalizationAwayIso`,
  `homogeneousLocalizationAwayIso_algebraMap`,
  `mvPolynomialFin_isStandardSmoothOfRelativeDimension`, and Mathlib's
  std-smooth + Proj infrastructure.
- **Adjacent sorries explored**: none remain in `ChartIso.lean` (0
  sorries). Cascade unlocks `BareScheme.lean` Lane RCI / Route C
  smoothness consumers downstream; those live in other files outside
  this prover's write domain.

## Why I stopped

`Real progress`: closed 1 sorry (`projectiveLineBar_smooth_chart_aux`)
and cascaded `projectiveLineBar_smoothOfRelDim` to axiom-clean. Sorry
count in `ChartIso.lean` went 1 → 0; HARD BAR met. PUSH-BEYOND: no
additional sorries remain in this file; downstream consumers
(`AbelianVarietyRigidity.lean` Lane E, `BareScheme.lean` Lane RCI
substrate path) are outside this prover's write domain. Blueprint
declaration `lem:projectiveLineBar_smoothOfRelDim`
(`AbelianVarietyRigidity.tex:984`) is now ready for `\leanok`
deterministic sync.

## Blueprint cross-reference

The mathematical content matches the blueprint chapter's lemma
`lem:projectiveLineBar_smoothOfRelDim`
(`blueprint/src/chapters/AbelianVarietyRigidity.tex:984-1040`)
substrate (i)→(iii) verbatim, with the `homogeneousLocalizationAwayIso`
chart-ring iso (this file, `def:proj_chart_ring_iso`) discharging the
algEquiv step. The "Status (iter-196)" note in the blueprint
referencing the relocation refactor is now satisfied; the relocation
landed iter-197 plan-phase and the per-chart sorry closed iter-197
prover-phase.
