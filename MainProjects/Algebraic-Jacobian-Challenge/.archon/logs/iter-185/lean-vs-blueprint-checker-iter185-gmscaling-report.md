# Lean ↔ Blueprint Check Report

## Slug
iter185-gmscaling

## Iteration
185

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex`

## Diagnostics summary

LSP diagnostics confirm exactly 4 sorry-bearing declarations:
- L412 `gmScalingP1_chart_agreement_cross01` (private)
- L620 `gmScalingP1_collapse_at_zero`
- L716 `gm_geomIrred`
- L746 `projGm_isReduced`

---

## Per-declaration

### `\lean{AlgebraicGeometry.gmScalingP1}` (def:gaTranslationP1)
- **Lean target exists**: yes — `noncomputable def gmScalingP1` at L595
- **Signature matches**: yes — `ProjectiveLineBar kbar ⊗ Gm kbar ⟶ ProjectiveLineBar kbar` in `Over (Spec (.of kbar))`, built via `Over.homMk + Scheme.Cover.glueMorphisms`
- **Proof follows sketch**: yes — assembled from `gmScalingP1_cover`, `gmScalingP1_chart`, `gmScalingP1_chart_agreement`, `gmScalingP1_over_coherence` exactly as described
- **Notes**: no inline sorries; sorry-taint propagates through two named helpers (`gmScalingP1_chart_agreement_cross01` L412, `gmScalingP1_collapse_at_zero` L620); this is accurately not `\leanok`-proof-marked in the blueprint

### `\lean{AlgebraicGeometry.gmScalingP1_cover}` (def:gmscaling_cover)
- **Lean target exists**: yes — L136
- **Signature matches**: yes — `((ProjectiveLineBar kbar) ⊗ Gm kbar).left.OpenCover` obtained via `openCover.pullback₁`
- **Proof follows sketch**: N/A (definition, no proof body)
- **Notes**: axiom-clean; blueprint `\leanok` on statement is accurate

### `\lean{AlgebraicGeometry.gmScalingP1_chart}` (def:gmscaling_chart)
- **Lean target exists**: yes — L186
- **Signature matches**: yes — `(gmScalingP1_cover kbar).X i ⟶ ProjectiveLineBarScheme kbar` for `i : Fin 2`
- **Proof follows sketch**: yes — `gmScalingP1_cover_X_iso.hom ≫ Spec.map (ring map) ≫ Proj.awayι` matches the `pullbackSpecIso + Spec.map + chart-ring iso + Proj.awayι` chain described in the blueprint
- **Notes**: axiom-clean; blueprint `\leanok` on statement accurate

### `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` (lem:gmscaling_chart_agreement)
- **Lean target exists**: yes — L523
- **Signature matches**: yes — `∀ x y : Fin 2, pullback.fst (f x) (f y) ≫ chart x = pullback.snd (f x) (f y) ≫ chart y`
- **Proof follows sketch**: partial — diagonal cases `(0,0)` and `(1,1)` via `fst_eq_snd_of_mono_eq` are axiom-clean; `(1,0)` via `pullbackSymmetry` is axiom-clean; the `(0,1)` cross case delegates to `gmScalingP1_chart_agreement_cross01` (sorry at L412)
- **Notes**: blueprint statement has `\leanok` (correct — declaration exists), no proof `\leanok` (correct). The blueprint prose describes the cross-case content correctly ("λ·u = (1/t)·λ in Localization.Away t ⊗ GmRing") but the proof sketch is critically under-specified — see Blueprint Adequacy below.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` (lem:gmscaling_chart_PLB_eq)
- **Lean target exists**: yes — L221 (`private lemma`)
- **Signature matches**: yes — per-chart bridge equation
- **Proof follows sketch**: yes — 3-step structure (A: awayι_comp_PLB_hom, B: Spec.map merge, C: pullback iso chain) matches; closed axiom-clean via `set_option backward.isDefEq.respectTransparency false` in iter-180
- **Notes**: the blueprint's "Status (iter-174 → iter-175)" block at L1397-1405 says "Step (C) carries two residual scaffold sorries" — this is **stale**. The declaration was closed axiom-clean in iter-180. The stale status text is misleading. **Major finding** — see Red Flags.

### `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` (lem:gmscaling_over_coherence)
- **Lean target exists**: yes — L571
- **Signature matches**: yes
- **Proof follows sketch**: yes — `Scheme.Cover.hom_ext` + `ι_glueMorphisms_assoc` + `gmScalingP1_chart_PLB_eq` per chart
- **Notes**: axiom-clean; blueprint `\leanok` on statement accurate

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (lem:gmScaling_fixes_zero)
- **Lean target exists**: yes — L620
- **Signature matches**: yes — `lift (toUnit Gm ≫ zeroPt) (𝟙 Gm) ≫ gmScalingP1 = toUnit Gm ≫ zeroPt`
- **Proof follows sketch**: partial — Lean applies `Over.OverMorphism.ext` then `simp` to get to the `Scheme`-level goal, then sorry; blueprint describes the chart-1 approach but not the `Over.OverMorphism.ext` reduction step or the `pullback.lift` section-construction recipe
- **Notes**: no proof `\leanok` in blueprint (correct — sorry at L620). Blueprint proof block (L1469-1480) is correct in content but under-specified in tactic path; see Blueprint Adequacy.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (lem:projlinebar_isReduced)
- **Lean target exists**: yes — L674
- **Signature matches**: yes — `IsReduced (ProjectiveLineBar kbar).left`
- **Proof follows sketch**: yes — `IsReduced.of_openCover` + `Function.Injective.isDomain` on `val_injective` into `Localization.Away` + `IsLocalization.isDomain_localization`
- **Notes**: axiom-clean; blueprint `\leanok` on both statement and proof block (L1148-1165) accurate

---

## Red flags

### Placeholder / suspect bodies
- `gmScalingP1_chart_agreement_cross01` at L412: `:= sorry` at the end of the proof body. This is a private named helper — honest sorry, not a laundered axiom. Blueprint correctly has no `\lean{...}` pin on it, and `lem:gmscaling_chart_agreement`'s proof block has no `\leanok`.
- `gmScalingP1_collapse_at_zero` at L620: `:= sorry` at end of proof. Honest sorry; no proof `\leanok` in blueprint.
- `gm_geomIrred` at L716: `:= sorry`. Public instance, Mathlib gap. No blueprint `\lean{...}` pin.
- `projGm_isReduced` at L746: `:= sorry`. Public instance, Mathlib gap. No blueprint `\lean{...}` pin.

### Excuse-comments
- L419-508: The 90-line comment block inside `gmScalingP1_chart_agreement_cross01`'s proof describes the blocking reason (5th consecutive iter without progress), iter-185 Recipe 2 BLOCKED finding, and iter-186+ pickup paths `(a)/(b)/(c)`. These are accurate workflow notes, NOT excuse-comments of the "TODO: replace with real def" variety. They document a genuine Mathlib/tooling obstacle. No issue here.

### Stale status prose in blueprint — **MAJOR**
- `lem:gmscaling_chart_PLB_eq` blueprint block (L1397-1405): reads "Steps (A) and (B) are axiom-clean as of iter-174. Step (C) carries two residual scaffold `sorry`'s on the `i = 0` and `i = 1` cases, owing to a syntactic `Fin`-literal mismatch." This status is **12 iterations stale** — `gmScalingP1_chart_PLB_eq` was closed axiom-clean in iter-180 via `set_option backward.isDefEq.respectTransparency false`. A reader of the blueprint today would incorrectly believe this lemma still has sorries.

---

## Unreferenced declarations (informational)

Public declarations in `GmScaling.lean` with no `\lean{...}` pin in the blueprint:

**Flagged as should-be-pinned (substantive):**
- `pullback_map_fst_proj` (L51): public `@[reassoc (attr := simp)]` lemma; landed iter-184, no blueprint coverage. This is a helper promoted to module-level for broader Mathlib contribution potential.
- `pullback_map_snd_proj` (L61): same.
- `gmScalingP1_chart1_ringMap` (L116): public `def`, mentioned by name in `def:gmscaling_chart` prose but has no standalone `\lean{...}` block.
- `gmScalingP1_chart0_ringMap` (L125): same.
- `projGm_locallyOfFiniteType` (L663): public instance, axiom-clean. Referenced in blueprint only in `%NOTE` comments inside `prop:morphism_P1_to_AV_constant`; no standalone block.
- `gm_geomIrred` (L716): public instance, sorry (Mathlib gap). No blueprint documentation of the gap.
- `projGm_geomIrred` (L728): public instance, axiom-clean given `gm_geomIrred`. No blueprint pin.
- `projGm_isReduced` (L746): public instance, sorry (Mathlib gap). No blueprint documentation.

**Acceptable helpers (private or infrastructure):**
- `awayι_comp_PLB_hom` (L84): private; OK
- `gmScalingP1_cover_X_iso` (L154): private; OK
- `gmScalingP1_cover_intersection_X_iso` (L313): private; OK
- `gmScalingP1_chart_agreement_cross01` (L412): private; OK
- `gmScalingP1_chart_PLB_eq` (L221): private; the blueprint `\lean{...}` pin is fine for documentation, though the declaration is inaccessible outside the file

---

## Blueprint adequacy for this file

- **Coverage**: 8/16 public Lean declarations have a `\lean{...}` block. Of the 8 unreferenced: 4 are private (acceptable); 4 are helpers (`chart{0,1}_ringMap`, `cover_X_iso`) mentioned in prose but not standalone-pinned (acceptable-ish); 4 substantive public declarations are completely absent (`pullback_map_fst_proj/snd_proj`, `projGm_locallyOfFiniteType`, `projGm_geomIrred`) or mentioned only in `%NOTE` prose (`gm_geomIrred`, `projGm_isReduced`).

- **Proof-sketch depth**: **under-specified** for two critical targets:

  1. **`lem:gmscaling_chart_agreement` cross-case (the primary blocker)** — The blueprint prose at L1325-1338 says the cross-case "routes through the chart-ring iso and the same `pullbackSpecIso` bridge" and "See `analogies/chart-bridge.md` (iter-173 in flight)". This is 12 iterations stale and completely insufficient. The blueprint does NOT describe:
     - The `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv` structural lift that is the current proof state's entry point
     - Why the `Iso.trans_inv`-based simp chain is blocked: the iso is tactic-elaborated via `refine … ≪≫ … ?_; refine …; exact …` producing a term with no `Iso.trans`-spine, so all `Iso.inv_comp_eq / pullback.congrHom_inv / asIso_inv` rewrites report "unused"
     - The three concrete pickup paths for iter-186+:
       - (a) Refactor `gmScalingP1_cover_intersection_X_iso` to term-mode (`≪≫`-spine only) to enable `Iso.trans_inv` simp
       - (b) Package two projection lemmas `_inv_fst/_snd` as `@[reassoc (attr := simp)]` with hand-written proofs via `pullback.hom_ext`
       - (c) Bypass the iso via the separating-sheaf argument on `PLB.hom` (requires establishing mono or using a sheaf-level argument)
     After **5 consecutive iterations without decrement**, the blueprint's proof sketch has demonstrably not been sufficient to guide formalization. This is a **must-fix-this-iter** blueprint adequacy failure.

  2. **`lem:gmScaling_fixes_zero` (stretch)** — The blueprint proof block (L1469-1480) describes the chart-1 approach at a high level but doesn't describe the `Over.OverMorphism.ext` reduction, the `pullback.lift (toUnit Gm).left (𝟙 Gm.left) ...` section construction, or the bridge from `gmScalingP1`'s glued form to the chart-1 ring-map computation. Under-specified but lower priority (stretch goal).

- **Hint precision**: **loose**. For `gm_geomIrred` and `projGm_isReduced` the Lean file documents specific Mathlib gaps (`Algebra.TensorProduct.isDomain_of_isAlgClosed_left` absent; `Smooth → GeometricallyReduced` absent), but the blueprint chapter has no documentation of these gaps, their severity, or proposed workarounds. A prover arriving at these instances would not know from the blueprint that these are Mathlib gaps requiring upstream contribution.

- **Generality**: matches need for covered declarations.

- **Recommended chapter-side actions**:
  1. **(must-fix)** Expand `lem:gmscaling_chart_agreement`'s proof sketch to describe the current state:
     - Replace the stale "See `analogies/chart-bridge.md` (iter-173 in flight)" reference with the current structural approach: `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv` lifts the goal to `Spec ((Away X₀X₁) ⊗ GmRing) ⟶ Proj 𝒜`
     - Document the simp-chain blockage (tactic-elaborated iso has no `Iso.trans`-spine; all inv-projection lemmas report "unused")
     - List the three pickup paths (a) refactor iso to term-mode, (b) `@[simp]` projection lemmas via `pullback.hom_ext`, (c) bypass via sheaf argument
  2. **(major)** Update the stale status note in `lem:gmscaling_chart_PLB_eq`: replace "Step (C) carries two residual scaffold `sorry`'s" with "axiom-clean since iter-180 via `set_option backward.isDefEq.respectTransparency false`".
  3. **(major)** Add `\lean{...}` pins for: `pullback_map_fst_proj`, `pullback_map_snd_proj` (under a new "Recipe 1 helpers" subsection), and the four product-stability instances `projGm_locallyOfFiniteType`, `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced` (can be a bullet-list definition block under "(E) Product-stability instances").
  4. **(major)** Add a `% NOTE:` on `gm_geomIrred` and `projGm_isReduced` documenting the Mathlib gap: `Algebra.TensorProduct.isDomain_of_isAlgClosed_left` is absent; no "factor is alg-closed + other is domain ⟹ tensor is domain" bridge exists in current Mathlib.

---

## Severity summary

- **must-fix-this-iter**:
  - `lem:gmscaling_chart_agreement` blueprint proof sketch is under-specified: 5 consecutive iters blocked at the cross-case; the blueprint lacks tactic-level detail on the `cancel_epi` approach, the simp blockage reason, and the iter-186+ pickup paths. A prover cannot formalize the cross-case from the blueprint prose alone.

- **major**:
  - Stale status note in `lem:gmscaling_chart_PLB_eq` (blueprint L1397-1405): claims Step (C) still has sorries; was axiom-clean since iter-180.
  - Missing `\lean{...}` pins for 6 public declarations: `pullback_map_fst_proj`, `pullback_map_snd_proj`, `projGm_locallyOfFiniteType`, `gm_geomIrred`, `projGm_geomIrred`, `projGm_isReduced`.
  - No blueprint documentation of the `gm_geomIrred` / `projGm_isReduced` Mathlib gaps or their workaround paths.

- **minor**:
  - `gmScalingP1_chart1_ringMap` and `gmScalingP1_chart0_ringMap` are mentioned in the prose of `def:gmscaling_chart` but have no standalone `\lean{...}` blocks; low impact since they are documented by name.
  - `lem:gmScaling_fixes_zero` proof sketch doesn't describe the `Over.OverMorphism.ext` + section-construction recipe; stretch priority only.

**Overall verdict**: The chapter's `\leanok` markers are all consistent with the actual Lean state (no false positives on proof blocks). The primary actionable issue is that the blueprint proof sketch for the cocycle cross-case (`lem:gmscaling_chart_agreement`) has been inadequate for 5 consecutive iterations and needs urgent expansion with tactic-level detail. Secondary issues are the stale `lem:gmscaling_chart_PLB_eq` status note and missing `\lean{...}` pins for 6 public declarations — 15 declarations checked, 4 red flags (all honest sorries), 1 must-fix + 3 major blueprint-side findings.
