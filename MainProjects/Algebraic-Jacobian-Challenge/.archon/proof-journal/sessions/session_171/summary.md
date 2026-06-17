# Session 171 (= iter-171) — review summary

## Session metadata

- **Iteration / session number**: 171
- **Stage**: prover (one lane on `Genus0BaseObjects.lean`)
- **Sorry count**:
  - Entering: 13 (`AbelianVarietyRigidity.lean × 2`, `Genus0BaseObjects.lean × 8`,
    `Jacobian.lean × 2`, `RigidityKbar.lean × 1`).
  - Post `refactor avr-split` (LANDED plan-phase): 13 unchanged (refactor is a pure file
    move — AVR 1198 → 354 LOC, NEW `RigidityLemma.lean` 902 LOC with 0 sorries).
  - Exiting: 15 (`AbelianVarietyRigidity.lean × 2`, `RigidityLemma.lean × 0`,
    `Genus0BaseObjects.lean × 10`, `Jacobian.lean × 2`, `RigidityKbar.lean × 1`). NET
    +2 from the body-skeleton landing (one sorry split into 3 named internal scaffold
    sorries + cancel-surjective `aux_left` body added 1 focused helper sorry, then
    eliminated the bare `aux_left` sorry — net +2).
- **Targets attempted (1 prover lane)**:
  1. `algebraKbarAway` — SOLVED axiom-clean.
  2. `gmScalingP1_chart1_ringMap` — SOLVED axiom-clean.
  3. `gmScalingP1_chart0_ringMap` — SOLVED axiom-clean.
  4. `gmScalingP1_cover` — SOLVED axiom-clean.
  5. `gmScalingP1` body — PARTIAL (concrete `Over.homMk + Scheme.Cover.glueMorphisms`
     skeleton; 3 named internal scaffold sorries).
  6. `gmScalingP1_chart` / `_chart_agreement` / `_over_coherence` — NEW top-level sorries
     factored out of (5).
  7. `homogeneousLocalizationAwayIso_aux_left` — PARTIAL (real cancel-surjective body
     depending on 1 focused new helper).
  8. `mvPolyToHomogeneousLocalizationAway_surjective` — NEW top-level sorry from (7).
- **Build**: `lake build AlgebraicJacobian` GREEN; `lake build AlgebraicJacobian.Genus0BaseObjects` exit 0; `lake build AlgebraicJacobian.AbelianVarietyRigidity` exit 0.
- **Axioms verified via `lean_verify`** (this review):
  - `AlgebraicGeometry.algebraKbarAway`: `{propext, Classical.choice, Quot.sound}` ✓
  - `AlgebraicGeometry.gmScalingP1_chart1_ringMap`: `{propext, Classical.choice, Quot.sound}` ✓
  - `AlgebraicGeometry.gmScalingP1_chart0_ringMap`: `{propext, Classical.choice, Quot.sound}` ✓
  - `AlgebraicGeometry.gmScalingP1_cover`: `{propext, Classical.choice, Quot.sound}` ✓
  - `AlgebraicGeometry.gmScalingP1`: `{propext, sorryAx, Classical.choice, Quot.sound}` ✓ (sorryAx propagates honestly through 3 internal scaffold sorries)
  - `AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left`: `{propext, sorryAx, Classical.choice, Quot.sound}` ✓ (sorryAx propagates from the new helper)

## Targets — attempts and outcomes

### Target 1: `algebraKbarAway` (Genus0BaseObjects.lean:91) — SOLVED

**Goal**: Provide `Algebra kbar (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f)` so that `TensorProduct kbar (Away _ _) (GmRing kbar)` synthesizes `CommRing`/`Algebra kbar` via `Algebra.TensorProduct.instCommRing`.

**Attempt 1** (`Edit` 2026-05-22T05:08:21Z, line 91, 3-line body via `Algebra.compHom`):
```lean
noncomputable instance algebraKbarAway (kbar : Type u) [Field kbar]
    (f : MvPolynomial (Fin 2) kbar) :
    Algebra kbar
      (HomogeneousLocalization.Away (projectiveLineBarGrading kbar) f) :=
  Algebra.compHom _ (algebraMap kbar ((projectiveLineBarGrading kbar) 0))
```

**Result**: SUCCESS, axiom-clean `{propext, Classical.choice, Quot.sound}`. Verified post-edit `lean_diagnostic_messages` returned only the existing-sorry warnings (no new errors). The recipe matches `analogies/tensoraway-instance.md` Q2 verbatim.

**Insight**: Mathlib ships `Algebra (𝒜 0) (HomogeneousLocalization 𝒜 x)` but NOT `Algebra kbar (HomogeneousLocalization 𝒜 x)`; the missing hop is `kbar → ↥(𝒜 0)`, which `SetLike.GradeZero.instAlgebra` ships. `Algebra.compHom _ (algebraMap kbar (𝒜 0))` is the 3-line bridge. This refutes the iter-169 prover's diagnosis ("`TensorProduct (Away _ _) GmRing CommRing missing`") — the missing hop was the `Algebra kbar` instance, not `CommRing`.

### Target 2 + 3: `gmScalingP1_chart1_ringMap` / `gmScalingP1_chart0_ringMap` (L659, L668) — SOLVED

**Goal**: Two ring maps `MvPolynomial Unit kbar →+* TensorProduct kbar (MvPolynomial Unit kbar) (GmRing kbar)` encoding the chart-side scaling action: chart-1 sends `u ↦ u ⊗ λ`; chart-0 sends `t ↦ t ⊗ λ⁻¹`.

**Attempt 1** (`Edit` 2026-05-22T05:13:54Z, lines 659/668, `MvPolynomial.eval₂Hom` recipe):

Encoded the chart-1 case:
```lean
noncomputable def gmScalingP1_chart1_ringMap (kbar : Type u) [Field kbar] :
    MvPolynomial Unit kbar →+* TensorProduct kbar (MvPolynomial Unit kbar) (GmRing kbar) :=
  MvPolynomial.eval₂Hom (algebraMap kbar _)
    (fun _ => (MvPolynomial.X () : MvPolynomial Unit kbar) ⊗ₜ[kbar]
      (algebraMap (MvPolynomial Unit kbar) (GmRing kbar) (MvPolynomial.X ())))
```

(First write used the type annotation `MvPolynomial Unit kbar ⊗[kbar] GmRing kbar` in the *signature* — Lean parsed `[kbar]` as a list literal, producing build error `unsupported type ascription on a list literal`. Replaced with explicit `TensorProduct kbar (MvPolynomial Unit kbar) (GmRing kbar)` form; build green.)

Chart-0 analogous with `IsLocalization.Away.invSelf (MvPolynomial.X ()) : GmRing kbar` replacing the `algebraMap` factor.

**Result**: SUCCESS, both axiom-clean `{propext, Classical.choice, Quot.sound}`. `MvPolynomial.eval₂Hom` takes a `RingHom`-shaped base, which `algebraMap kbar _` provides cleanly; the analogist's alternative `MvPolynomial.aeval` route was rejected as more fragile.

**Insight**: `IsLocalization.Away.invSelf` (`Mathlib/RingTheory/Localization/Away/Basic.lean:58`) is the canonical Mathlib hook for the `1/t` factor of `Localization.Away t`. New KB pattern: when a ring map needs the `λ⁻¹` factor of `GmRing := Localization.Away (X () : MvPolynomial Unit kbar)`, use `IsLocalization.Away.invSelf (X ()) : GmRing kbar` (do not reach for `(IsUnit.unit _).inv` or `(hu.choose)`).

### Target 4: `gmScalingP1_cover` (L679) — SOLVED

**Goal**: A 2-chart cover of `(ProjectiveLineBar kbar ⊗ Gm kbar).left` for the `Scheme.Cover.glueMorphisms` invocation.

**Attempt 1** (`Edit` 2026-05-22T05:13:54Z, line 679, pullback of the affine cover along `pullback.fst`):
```lean
noncomputable def gmScalingP1_cover (kbar : Type u) [Field kbar] :
    ((ProjectiveLineBar kbar) ⊗ Gm kbar).left.OpenCover :=
  (projectiveLineBarAffineCover kbar).openCover.pullback₁
    (pullback.fst (ProjectiveLineBar kbar).hom (Gm kbar).hom)
```

**Result**: SUCCESS, axiom-clean. The prover located `pullback₁` via 5 `grep` lookups landing at `Mathlib.AlgebraicGeometry.Cover.Directed:153` and the underlying `PreZeroHypercover.pullback₁` at `Mathlib.CategoryTheory.Sites.Hypercover.Zero:97`.

**Insight**: New KB pattern: `(affineCover).openCover.pullback₁ f` is the canonical Mathlib hook for "pull back a cover of `X` along a morphism `f : Y ⟶ X`" to obtain a cover of `pullback X f`. Reusable for any product-stability cover construction.

### Target 5: `gmScalingP1` body (L742) — PARTIAL

**Goal**: Replace the existing `:= sorry` body (L693 entering this iter) with a concrete category-theoretic body in `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar`.

**Attempt 1** (Edit at L742, body via `Over.homMk + Scheme.Cover.glueMorphisms`):
```lean
noncomputable def gmScalingP1 (kbar : Type u) [Field kbar] :
    ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar :=
  Over.homMk
    ((gmScalingP1_cover kbar).glueMorphisms
      (gmScalingP1_chart kbar)
      (gmScalingP1_chart_agreement kbar))
    (gmScalingP1_over_coherence kbar)
```

The three internal obligations are hoisted to top-level named declarations:
- `gmScalingP1_chart` (L695, `(gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme kbar`).
- `gmScalingP1_chart_agreement` (L705, cocycle on intersections).
- `gmScalingP1_over_coherence` (L721, over-structure intertwining for `Scheme.Cover.hom_ext`).

**Result**: PARTIAL — body shape written, no buried sorries. `lean_verify` axioms `{propext, sorryAx, Classical.choice, Quot.sound}`; `sorryAx` propagates honestly from the three named internal sorries. The progress-critic's PARTIAL acceptance criterion is satisfied (≤3 named top-level internal sorries).

**Insight**: The body-first attack worked exactly per the iter-170 progress-critic `routec170` corrective. Three iters of "build helpers, hypothesize their shape fits, defer assembly" CHURNING terminated this iter because the assembly was attempted first, which forced the helper shapes to be precisely typed.

### Target 6 + 7: `homogeneousLocalizationAwayIso_aux_left` + `mvPolyToHomogeneousLocalizationAway_surjective` (L384, L372) — PARTIAL + NEW

**Goal**: Close the bare `sorry` at the iter-168 `aux_left` body (L368 entering this iter; was L367 before the refactor-split renumber).

**Attempt 1** (`Edit` 2026-05-22T05:19:46Z, line 384, cancel-surjective via named helper):
```lean
private lemma homogeneousLocalizationAwayIso_aux_left (kbar : Type u) [Field kbar] (i : Fin 2) :
    (mvPolyToHomogeneousLocalizationAway kbar i).comp
        (homogeneousLocalizationAwayToMvPoly kbar i) =
      RingHom.id _ := by
  ext x
  obtain ⟨p, rfl⟩ := mvPolyToHomogeneousLocalizationAway_surjective kbar i x
  have h : (homogeneousLocalizationAwayToMvPoly kbar i)
      ((mvPolyToHomogeneousLocalizationAway kbar i) p) = p :=
    RingHom.congr_fun (homogeneousLocalizationAwayIso_aux_right kbar i) p
  simp only [RingHom.comp_apply, RingHom.id_apply, h]
```

Companion sorry-bodied helper at L372:
```lean
private lemma mvPolyToHomogeneousLocalizationAway_surjective
    (kbar : Type u) [Field kbar] (i : Fin 2) :
    Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i) :=
  sorry
```

**Result**: PARTIAL — cancel-surjective body lands axiom-clean (mod the named helper); `lean_verify aux_left` returns `{propext, sorryAx, ...}` (sorryAx propagates from the helper). The helper itself is a focused surjectivity claim with a clear closure path via `Away.adjoin_mk_prod_pow_eq_top` specialised to `d=1, v=![X 0, X 1], dv=![1,1]` (~60-80 LOC, well-isolated from the body skeleton).

**Insight**: The "cancel-surjective" route per `analogies/gmscaling-deep.md` Q2 verdict is correct shape — the `aux_left` round-trip on `Away 𝒜 (X i)` follows from `aux_right` (on `MvPoly Unit kbar`) + surjectivity of the inverse map.

## Refactor lane: `avr-split` LANDED

The iter-171 plan dispatched a `refactor avr-split` agent BEFORE the prover lane. It SPLIT `AlgebraicJacobian/AbelianVarietyRigidity.lean` (1198 LOC) into:

- **NEW** `AlgebraicJacobian/RigidityLemma.lean` (902 LOC, 0 sorries): Mumford Form-I chain + Milne §I.1 corollaries (`rigidity_lemma`, `hom_additive_decomp_of_rigidity`, `av_regularMap_isHom_of_zero`, …). All migrated axiom-clean.
- **REDUCED** `AbelianVarietyRigidity.lean` (354 LOC, 2 sorries unchanged): genus-0 final assembly only (`iotaGm_isDominant`, `morphism_P1_to_grpScheme_const_aux`, `morphism_P1_to_grpScheme_const`, `genusZero_curve_iso_P1`, `rigidity_genus0_curve_to_grpScheme`).
- `AlgebraicJacobian.lean`: `import AlgebraicJacobian.RigidityLemma` added.
- `blueprint/src/chapters/AbelianVarietyRigidity.tex`: `% archon:covers` line extended to all three Lean files.

Build green post-split; no protected signatures touched. The refactor decouples the proven Mumford chain from the gated genus-0 final, enabling future Route A.4 (Albanese UP) consumers to import the foundation without pulling in `Genus0BaseObjects` sorries.

## Key findings / patterns discovered

- **Body-first attacks survive CHURNING patterns where helper-supports rounds fail**. The iter-171 prover ran the iter-170 plan's body-first attack verbatim and CLOSED a skeleton that 3 prior iters of helper-supports work could not even start. Generalised pattern: when a chain of helper rounds keeps deferring the load-bearing residual, force the residual into PARTIAL form first — the helper shapes are then constrained by the residual's signature and stop drifting.
- **Lean notation trap**: `A ⊗[R] B` in a *type ascription* position can parse the `[R]` as a list literal when `A` is itself a parametric type (e.g. `MvPolynomial _ R`). Workaround: use explicit `TensorProduct R A B` in signatures.
- **`Algebra.compHom` is the bridge for `kbar → 𝒜 0 → Away`** chains (`HomogeneousLocalization.Away`-side carries `Algebra (𝒜 0) _` from Mathlib; needs `Algebra kbar` via `compHom`).
- **`IsLocalization.Away.invSelf t : Localization.Away t`** is the canonical Mathlib hook for the `1/t` factor; do NOT reach for `(IsUnit.unit _).inv`.
- **`(affineCover).openCover.pullback₁ f`** is the canonical "pullback of a cover along a morphism" hook — lives in `Mathlib.AlgebraicGeometry.Cover.Directed:153`, underlying `PreZeroHypercover.pullback₁` at `Sites/Hypercover/Zero.lean:97`.

## Reusable proof patterns

See "Key findings / patterns discovered" above + the iter-171 KB additions in `PROJECT_STATUS.md`.

## Blueprint markers updated (manual)

- `AbelianVarietyRigidity.tex`, `def:gaTranslationP1` (L1147-1156 `% NOTE:`): refreshed iter-170 stale prose to iter-171 reality "body LANDED as concrete `Over.homMk + Scheme.Cover.glueMorphisms`; `sorryAx` flows through 3 named internal scaffold sorries (`gmScalingP1_chart`/`_chart_agreement`/`_over_coherence`); Step A ring maps + cover axiom-clean."
- `AbelianVarietyRigidity.tex`, `lem:gmScaling_fixes_zero` (L1208-1213 `% NOTE:`): refreshed iter-170 stale prose to iter-171 "gate now NARROWER on the three internal helpers, no longer on the body itself".
- `AbelianVarietyRigidity.tex`, `def:proj_chart_ring_iso` (L1091-1094 `% NOTE (iter-169):`): refreshed mildly-stale iter-169 prose per `lean-vs-blueprint-checker g0bo171` minor finding to iter-171 reality "reverse round-trip body is real this iter; sorry residual moved one node downstream to the new helper `mvPolyToHomogeneousLocalizationAway_surjective`".

No `\leanok` writes — deterministic-sync's domain. No `\mathlibok` adds. No `\notready` strips.

## Recommendations for next session (iter-172)

See `recommendations.md` in this directory for the full ranked list. Headline:

1. **Close `mvPolyToHomogeneousLocalizationAway_surjective`** (L372) — focused, well-isolated, unblocks `aux_left` axiom-clean + downstream `gmScalingP1_chart`.
2. **Close `gmScalingP1_chart` body** (L695, chart-`i` scheme morphism) — concrete shape `pullbackSpecIso ≫ Spec.map (gmScalingP1_chart_i_ringMap) ≫ Spec.map (homogeneousLocalizationAwayIso.symm) ≫ Proj.awayι`, gated on (1).
3. **Open Lane B + Lane C** (file-skeletons on `Picard/RelativeSpec.lean` + `RiemannRoch/WeilDivisor.lean`) per the iter-171 plan's decomposition commitment to ≥2 additional prover lanes iter-172. HARD GATE: scoped blueprint-reviewer re-check on the 2 new chapters via same-iter fast path.
4. **`gmScalingP1_chart_agreement`** + **`gmScalingP1_over_coherence`** — both downstream of (2); each ~40 LOC mechanical once chart is concrete.
5. **`gmScalingP1_collapse_at_zero`** — strictly downstream of (2)–(4); the chart-1 `[0:1]` factorisation gives `X 0 ↦ 0 ⊗ λ = 0` directly.

The iter-170 → iter-171 reversal trigger DOES NOT FIRE; Route C with option (c) inline chart-glue at scale remains committed and is now demonstrably tractable.
