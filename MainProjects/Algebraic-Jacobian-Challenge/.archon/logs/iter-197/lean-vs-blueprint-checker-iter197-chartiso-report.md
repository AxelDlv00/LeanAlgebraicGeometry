# Lean ↔ Blueprint Check Report

## Slug
iter197-chartiso

## Iteration
197

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/ChartIso.lean` (464 lines)
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (2992 lines; sections ~L982–L1379 are the relevant ChartIso-covering region)

---

## Declaration inventory (ChartIso.lean)

**Public declarations** (4 `def`/`lemma`/`instance`, 1 helper `def`):
1. `otherFin` (L41) — `def`, public (no `private`), blueprint-uncovered helper
2. `homogeneousLocalizationAwayToMvPoly` (L74) — `noncomputable def`, public
3. `mvPolyToHomogeneousLocalizationAway` (L97) — `noncomputable def`, public
4. `homogeneousLocalizationAwayIso` (L328) — `noncomputable def`, public
5. `homogeneousLocalizationAwayIso_algebraMap` (L347) — `lemma`, public
6. `projectiveLineBar_smoothOfRelDim` (L456) — `instance`, public

**Private declarations** (not independently required to be blueprint-pinned):
- `otherFin_zero`, `otherFin_one`, `otherFin_ne` — private simp lemmas
- `chartEvalRingHom` + simp lemmas (`chartEvalRingHom_X_self`, `_X_other`, `_C`)
- `kbarToAwayRingHom`
- `homogeneousLocalizationAwayIso_aux_right` (L109) — forward round-trip
- `mvPolyToHomogeneousLocalizationAway_surjective` (L162) — **has blueprint pin** (see below)
- `homogeneousLocalizationAwayIso_aux_left` (L311) — **has blueprint pin** (see below)
- `projectiveLineBar_smooth_chart_X` (L389) — **new iter-197 helper**, no blueprint pin
- `projectiveLineBar_smooth_chart_aux` (L439) — per-chart vehicle, no blueprint pin

---

## Per-declaration (blueprint → Lean)

### `\lean{AlgebraicGeometry.projectiveLineBar_smoothOfRelDim}` (chapter: `\lem:projectiveLineBar_smoothOfRelDim`, blueprint L987)

- **Lean target exists**: yes — `instance projectiveLineBar_smoothOfRelDim (kbar : Type u) [Field kbar] : SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom` at L456
- **Signature matches**: yes — blueprint says "the structure morphism `(ProjectiveLineBar k̄).hom` is smooth of relative dimension 1"; Lean uses exactly `SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom`
- **Proof follows sketch**: yes — blueprint (L993–1041) describes cover-reduction via `IsZariskiLocalAtSource.of_openCover`, per-chart reduction via `HasRingHomProperty.Spec_iff` + `RingHom.locally_of`, then closing via `Algebra.IsStandardSmoothOfRelativeDimension.of_algEquiv` with the chart-ring iso reparameterised as a k̄-algEquiv. Lean proof (L456–460) applies exactly `IsZariskiLocalAtSource.of_openCover` delegating to `projectiveLineBar_smooth_chart_aux`, and the private helper `projectiveLineBar_smooth_chart_X` (L389–437) executes steps (i)–(iv) of the blueprint sketch verbatim.
- **notes**: Blueprint uses the term `HasRingHomProperty.iff_of_isAffine` (L1012) for the reduction step; Lean uses `HasRingHomProperty.Spec_iff` (L415). These are mathematically equivalent in this `Spec.map` context; minor naming divergence in the proof sketch only.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso}` (chapter: `\def:proj_chart_ring_iso`, blueprint L1233)

- **Lean target exists**: yes — `noncomputable def homogeneousLocalizationAwayIso (kbar : Type u) [Field kbar] (i : Fin 2) : HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (MvPolynomial.X i) ≃+* MvPolynomial Unit kbar` at L328
- **Signature matches**: yes — blueprint says `Away A X_i ≃+* k̄[u]` (with `MvPolynomial Unit k̄` = k̄[u]); target type matches exactly, including the `Fin 2` index parameter `i`
- **Proof follows sketch**: yes — blueprint (L1243–1249) describes forward direction via `Localization.awayLift` with chart evaluation `X_i ↦ 1, X_{1-i} ↦ u`, inverse via `MvPolynomial.eval₂Hom` sending `u ↦ isLocalizationElem`, packaged via `RingEquiv.ofRingHom`. Lean (L328–336) uses exactly these components.
- **Blueprint `\leanok`**: present (L1230) — correct, no sorries.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_aux_left}` (chapter: `\lem:proj_chart_ring_iso_aux_left`, blueprint L1265)

- **Lean target exists**: yes — `private lemma homogeneousLocalizationAwayIso_aux_left` at L311
- **Signature matches**: yes — blueprint says "composite `inverse ∘ forward : Away A X_i → Away A X_i` is the identity ring map"; Lean states `(mvPolyToHomogeneousLocalizationAway kbar i).comp (homogeneousLocalizationAwayToMvPoly kbar i) = RingHom.id _`
- **Proof follows sketch**: yes — blueprint (L1275–1281) describes the "cancel surjective" route: from surjectivity of inverse + the proven forward round-trip, cancel to conclude `inverse ∘ forward = id`. Lean proof (L311–322) uses `mvPolyToHomogeneousLocalizationAway_surjective` to `obtain ⟨p, rfl⟩`, then applies `homogeneousLocalizationAwayIso_aux_right` for the cancellation.
- **Blueprint `\leanok`**: present (L1262) — correct.
- **notes**: This is a `private` declaration pinned by blueprint. Appropriate: it is a named proof obligation with substantive mathematical content.

### `\lean{AlgebraicGeometry.mvPolyToHomogeneousLocalizationAway_surjective}` (chapter: `\lem:mvPoly_to_homogeneousLocalization_away_surjective`, blueprint L1287)

- **Lean target exists**: yes — `private lemma mvPolyToHomogeneousLocalizationAway_surjective (kbar : Type u) [Field kbar] (i : Fin 2) : Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i)` at L162
- **Signature matches**: yes — blueprint says "the ring map `mvPolyToHomogeneousLocalizationAway_i : MvPolynomial {*} k̄ → Away A X_i` is surjective"; Lean states `Function.Surjective (mvPolyToHomogeneousLocalizationAway kbar i)`
- **Proof follows sketch**: yes — blueprint (L1306–1323) describes the `Away.adjoin_mk_prod_pow_eq_top` route with `d=1, v=(X₀,X₁), dv=(1,1)`, adjoin induction, and the `algebraMap kbar (A₀)` surjectivity case. Lean proof (L162–302) executes this route in full detail including `gen_eq_pow` and `Algebra.adjoin_induction`.
- **Blueprint `\leanok`**: present (L1284) — correct.

### `\lean{AlgebraicGeometry.homogeneousLocalizationAwayIso_algebraMap}` (chapter: `\lem:chart_ring_iso_preserves_algebraMap`, blueprint L1329)

- **Lean target exists**: yes — `lemma homogeneousLocalizationAwayIso_algebraMap (kbar : Type u) [Field kbar] (i : Fin 2)` at L347
- **Signature matches**: yes — blueprint (L1340–1351) states `algebraMap k̄ (Away A X_i) ≫ forward_i = algebraMap k̄ (MvPolynomial {*} k̄)`; Lean states `((homogeneousLocalizationAwayIso kbar i).toRingHom).comp (algebraMap kbar (Away ...)) = algebraMap kbar (MvPolynomial Unit kbar)`
- **Proof follows sketch**: yes — blueprint (L1357–1378) describes the route via `HomogeneousLocalization.algebraMap_eq` unfolding, `eval₂Hom_C` evaluation, and using the forward round-trip identity. Lean proof (L354–376) executes this via `hinv` + `hround`.
- **Blueprint `\leanok`**: present (L1326) — correct.

---

## Red flags

### Placeholder / suspect bodies
None. All declarations in ChartIso.lean have complete proofs. No `:= sorry`, `:= True`, or `Classical.choice _` on substantive claims. The grep for `sorry` returned zero matches.

### Excuse-comments
None. No `-- TODO replace with real def`, `-- temporary`, `-- placeholder`, `-- wrong but works for now` comments found.

### Axioms / Classical.choice on non-trivial claims
None. No `axiom` declarations in ChartIso.lean. The proof of `mvPolyToHomogeneousLocalizationAway_surjective` opens with `classical` tactic (L165) which is normal for surjectivity arguments of this type and is not a red flag.

---

## Unreferenced declarations (informational)

The following declarations in ChartIso.lean have no `\lean{...}` blueprint pin:

| Declaration | Public? | Assessment |
|---|---|---|
| `otherFin` (L41) | **public** | Trivial enumeration helper (`0↔1` on `Fin 2`); not a mathematical theorem. No pin needed. |
| `homogeneousLocalizationAwayToMvPoly` (L74) | **public** | The forward ring-hom component of `homogeneousLocalizationAwayIso`. Described within `def:proj_chart_ring_iso`'s prose but not separately pinned. Flagged below. |
| `mvPolyToHomogeneousLocalizationAway` (L97) | **public** | The inverse ring-hom component. Same situation as above. Flagged below. |
| `homogeneousLocalizationAwayIso_aux_right` (L109) | private | Forward round-trip helper; correctly described within `lem:proj_chart_ring_iso_aux_left` prose. Acceptable as unpinned. |
| `projectiveLineBar_smooth_chart_X` (L389) | private | **New iter-197 helper** implementing the per-chart standard-smooth property for the named form `X i`. Private implementation detail of `projectiveLineBar_smooth_chart_aux`. No pin needed. |
| `projectiveLineBar_smooth_chart_aux` (L439) | private | Per-chart vehicle, private. Mentioned by name in the blueprint Status note (L1028) but not independently pinned. Acceptable. |

**Notable unpinned public declarations**: `homogeneousLocalizationAwayToMvPoly` and `mvPolyToHomogeneousLocalizationAway` are public `noncomputable def`s that form the explicit component ring homs of the chart-ring iso. They are adequately described in the prose of `def:proj_chart_ring_iso` (blueprint L1243–1249) and are consumed as API by downstream files (`GmScaling.lean`, etc.). Their absence as independent `\lean{...}` pins is acceptable for this iteration — they are implementation components whose signatures are fully derivable from the iso pin.

---

## Blueprint adequacy for this file

- **Coverage**: 4 of the 6 public declarations have explicit `\lean{...}` blueprint pins (`homogeneousLocalizationAwayIso`, `homogeneousLocalizationAwayIso_algebraMap`, `projectiveLineBar_smoothOfRelDim`, and via the private-but-pinned route: `homogeneousLocalizationAwayIso_aux_left` + `mvPolyToHomogeneousLocalizationAway_surjective`). The 2 unpinned public `def`s (`homogeneousLocalizationAwayToMvPoly`, `mvPolyToHomogeneousLocalizationAway`) are described in prose. The 1 trivial helper (`otherFin`) and 4 private helpers are acceptably uncovered.

- **Proof-sketch depth**: **adequate**. The surjectivity proof sketch (L1306–1323) is detailed enough to guide the `adjoin_mk_prod_pow_eq_top` route. The algebraMap preservation sketch (L1357–1378) pinpoints the `eval₂Hom_C` + round-trip step. The smoothness sketch (L993–1041) describes the 4-step per-chart reduction and the `of_algEquiv` close accurately.

- **Hint precision**: **precise** for all pinned declarations. The `\lean{...}` names in the chapter all resolve exactly to the Lean declarations; no cases of wrong Mathlib predicate or stale name.

- **Generality**: **matches need**. The blueprint describes the exact types at the level of generality the Lean uses.

- **Recommended chapter-side actions**:
  1. **(Major — stale note)** Update or replace the "Status (iter-196)" block at L1026–1041 of `lem:projectiveLineBar_smoothOfRelDim`. The note says the per-chart aux "carries the residual sorry" and the refactor is "being dispatched separately" — both claims are **no longer true as of iter-197**. The relocation to `ChartIso.lean` landed, `projectiveLineBar_smooth_chart_X` closed the per-chart sorry, and `projectiveLineBar_smoothOfRelDim` is now fully axiom-clean. The status note should be updated to: "Status (iter-197): fully axiom-clean. Relocated to `ChartIso.lean` iter-196/197; per-chart sorry closed iter-197 via `projectiveLineBar_smooth_chart_X`."
  2. **(Minor)** Align the blueprint's proof-sketch term `HasRingHomProperty.iff_of_isAffine` (L1012) with the Lean's actual use of `HasRingHomProperty.Spec_iff` (Lean L415) — the current phrasing could mislead a future prover who searches for that lemma name.

---

## Severity summary

### must-fix-this-iter
None.

### major
1. **Stale "Status (iter-196)" note in `lem:projectiveLineBar_smoothOfRelDim`** (blueprint L1026–1041). The note asserts that `projectiveLineBar_smooth_chart_aux` "carries the residual sorry" and recommends a relocation — both of which have been executed in iter-196/197. The note is factually wrong about the current proof state and will confuse future prover/plan iterations. The blueprint-writer should replace this note with a "Status (iter-197): axiom-clean, closed" annotation.

### minor
1. **Naming divergence in proof sketch**: blueprint uses `HasRingHomProperty.iff_of_isAffine` (L1012) but Lean uses `HasRingHomProperty.Spec_iff` (L415). Cosmetically misleading; not blocking.
2. **`homogeneousLocalizationAwayToMvPoly` and `mvPolyToHomogeneousLocalizationAway` lack individual `\lean{...}` pins**. They are public API described only within the iso block. Not blocking this iteration, but should be pinned when the blueprint is next revised.

**Overall verdict**: ChartIso.lean is faithful to the blueprint — all pinned declarations exist with matching signatures and proofs that follow the sketches, no sorries, no red flags — with one major stale status note in `lem:projectiveLineBar_smoothOfRelDim` that should be updated to reflect the iter-197 sorry closure; 5 declarations checked, 0 blocking red flags.
