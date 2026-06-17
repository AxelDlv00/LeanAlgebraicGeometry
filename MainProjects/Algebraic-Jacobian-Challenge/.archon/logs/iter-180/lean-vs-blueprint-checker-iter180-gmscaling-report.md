# Lean ↔ Blueprint Check Report

## Slug
iter180-gmscaling

## Iteration
180

## Files audited
- Lean: `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`
- Blueprint: `blueprint/src/chapters/AbelianVarietyRigidity.tex` (covers GmScaling.lean per `% archon:covers` header)

## Per-declaration

### `\lean{AlgebraicGeometry.gmScalingP1_cover}` (chapter: `def:gmscaling_cover`, L1353)
- **Lean target exists**: yes (`gmScalingP1_cover`, L106)
- **Signature matches**: yes — Mathlib `openCover.pullback₁ (pullback.fst PLB.hom Gm.hom)`, matches blueprint's "pulling back the chart cover along the first pullback projection"
- **Proof follows sketch**: N/A (definition, body is a direct Mathlib expression)
- **notes**: axiom-clean since iter-171

### `\lean{AlgebraicGeometry.gmScalingP1_chart}` (chapter: `def:gmscaling_chart`, L1380)
- **Lean target exists**: yes (`gmScalingP1_chart`, L156)
- **Signature matches**: yes — chart-`i` scheme morphism `(gmScalingP1_cover).X i ⟶ ProjectiveLineBarScheme kbar`
- **Proof follows sketch**: yes — body follows the "iso bridge → Spec.map of ring map → Proj.awayι" chain described in blueprint L1400-1416
- **notes**: body uses a per-`i` `match`-branch for the chart-0 (`λ⁻¹`) vs chart-1 (`λ`) ring-map split. The blueprint's "Construction recipe" describes both halves at the right level of detail.

### `\lean{AlgebraicGeometry.gmScalingP1_chart_PLB_eq}` (chapter: `lem:gmscaling_chart_PLB_eq`, L1461)
- **Lean target exists**: yes (private lemma, L191)
- **Signature matches**: yes — exactly the chart-`i` over-coherence equation in L1472-1478 of the blueprint
- **Proof follows sketch**: yes (well done) — the blueprint's three-step decomposition (A) chart-bridge collapse, (B) Spec.map merge + algebraMap identification, (C) source-side iso chase is realised by the five stages in the Lean proof body (L194-256), in the same order; the iter-180 retire used `set_option backward.isDefEq.respectTransparency false in` per `analogies/pullbackspeciso-bypass.md` Decision 4
- **notes**: **iter-180 lane A's headline result.** Now axiom-clean; the iter-174 "Step C carries two residual scaffold sorries" status note in the blueprint (L1516-1523) is stale post-iter-180 — blueprint-writer should refresh to "axiom-clean iter-180 via the `respectTransparency` recipe."

### `\lean{AlgebraicGeometry.gmScalingP1_chart_agreement}` (chapter: `lem:gmscaling_chart_agreement`, L1423)
- **Lean target exists**: yes (L270)
- **Signature matches**: yes — `∀ x y : I₀, pullback.fst ∘ chart x = pullback.snd ∘ chart y`
- **Proof follows sketch**: partial — diagonal `(0,0)/(1,1)` closed via `fst_eq_snd_of_mono_eq` (blueprint L1440 says "trivial via `pullback.condition`"; the Lean uses the mono-of-open-immersion route, which is a sound mathematical equivalent: `pullback.fst` along a mono is itself a mono and therefore the two projections agree on `pullback (f x) (f x)`). Cross cases `(0,1)/(1,0)` remain a single honest `sorry` (L289)
- **notes**: blueprint pinpoints exactly the residual ring-level identity `λ · u = (1/t) · λ` in `Localization.Away t ⊗ GmRing` (L1444-1448). Strong guidance — see "Blueprint adequacy" below.

### `\lean{AlgebraicGeometry.gmScalingP1_over_coherence}` (chapter: `lem:gmscaling_over_coherence`, L1531)
- **Lean target exists**: yes (L304)
- **Signature matches**: yes
- **Proof follows sketch**: yes — body is `Scheme.Cover.hom_ext` + `ι_glueMorphisms_assoc` + `gmScalingP1_chart_PLB_eq` exactly as blueprint L1551 describes
- **notes**: in-Lean docstring "Status (iter-174)" claim that "the only residual sorryAx propagates through the helper's Step C" is now STALE — iter-180 closed `gmScalingP1_chart_PLB_eq`, so the only sorry reachable from here is `gmScalingP1_chart_agreement`'s cross case. Not an excuse-comment, just out-of-date narrative; minor cleanup.

### `\lean{AlgebraicGeometry.gmScalingP1}` (chapter: `def:gaTranslationP1`, L1278)
- **Lean target exists**: yes (L328)
- **Signature matches**: yes — `Over.homMk` of the glued morphism with the over-coherence
- **Proof follows sketch**: yes (definition body) — `Over.homMk ((gmScalingP1_cover).glueMorphisms gmScalingP1_chart gmScalingP1_chart_agreement) gmScalingP1_over_coherence`, exactly matching the iter-171 chart-glue commitment encoded in the blueprint docstring NOTE
- **notes**: in-Lean docstring claim "body skeleton with three internal `sorry`s" (L322) is also STALE post-iter-180 (`chart_PLB_eq` now axiom-clean; only `chart_agreement` cross case + `collapse_at_zero` remain). Minor staleness.

### `\lean{AlgebraicGeometry.gmScalingP1_collapse_at_zero}` (chapter: `lem:gmScaling_fixes_zero`, L1571)
- **Lean target exists**: yes (L353)
- **Signature matches**: yes — `lift (toUnit Gm ≫ zeroPt) (𝟙 Gm) ≫ gmScalingP1 = toUnit ≫ zeroPt`
- **Proof follows sketch**: partial — body is an honest single `sorry` (L359, no laundering through deleted TEMP axioms; explicitly noted in the docstring at L344-352)
- **notes**: **iter-180 verified the axiom retirement** — `gmScalingP1_collapse_at_zero_temp` is gone from the file. The escalation-target comment at L357-358 directly cites the chart-1 ring-map route. Blueprint sketch is at L1590-1600 and is mathematically clean (chart-1 polynomial computation), but does not describe the Lean-specific bridge from `glueMorphisms` to the chart-1 ring-map computation — see "Blueprint adequacy" below.

### `\lean{AlgebraicGeometry.projectiveLineBar_isReduced}` (chapter: `lem:projlinebar_isReduced`, L1254)
- **Lean target exists**: yes (instance, L393)
- **Signature matches**: yes — `IsReduced (ProjectiveLineBar kbar).left`
- **Proof follows sketch**: yes — body uses `IsReduced.of_openCover` over `projectiveLineBarAffineCover`, each chart shown to be a domain via the `val`-injection from `HomogeneousLocalization.Away` into `Localization.Away` (a localization of `MvPolynomial (Fin 2) kbar` at a non-zero-divisor). Mirrors blueprint L1262-1270 exactly.
- **notes**: axiom-clean since iter-168; unchanged this iter

## Red flags

None at must-fix-this-iter severity.

### Placeholder / suspect bodies

None — all four residual sorries are honest direct sorries with named-declaration discipline, matching the blueprint's gating language:

- `gmScalingP1_chart_agreement` cross case at L289 — blueprint L1440-1448 acknowledges the cross-case residual at the level of the ring-level identity and gates it on the chart-bridge cocycle helper
- `gmScalingP1_collapse_at_zero` at L359 — blueprint L1573-1579 docstring NOTE acknowledges the gate is narrower than the iter-170 form, and the in-Lean status comment at L344-352 names the exact route
- `gm_geomIrred` at L437 — blueprint discusses this as a Mathlib gap (see L1910 NOTE; the chapter has no dedicated block for it, see "Unreferenced declarations" below)
- `projGm_isReduced` at L469 — same status; blueprint mentions only via L1925 NOTE in `morphism_P1_to_grpScheme_const`'s proof

### Excuse-comments

None — the docstrings are status narratives ("iter-180: body retired axiom-clean via the empirically-verified ... recipe") tied to verified empirical recipes in the `analogies/` corpus, not excuses for wrong code.

### Axioms / Classical.choice on non-trivial claims

None — **iter-180 verified the TEMP axiom retirement**: `gmScalingP1_chart_data_temp` and `gmScalingP1_collapse_at_zero_temp` are absent from GmScaling.lean (only mentioned as a comment reference in `AbelianVarietyRigidity.lean:105`).

## Unreferenced declarations (informational)

Lean declarations in this file with no `\lean{...}` in the blueprint:

- `awayι_comp_PLB_hom` (private lemma, L54) — chart-bridge helper. Blueprint mentions by name at L1487, L1495 inside `lem:gmscaling_chart_PLB_eq`'s proof sketch. Acceptable as a helper; mild improvement would be promoting to its own `\lean{...}` block since it is now load-bearing across multiple chart-glue lemmas and the iter-180 retire pivot turned on it.
- `gmScalingP1_chart0_ringMap` (def, L86), `gmScalingP1_chart1_ringMap` (def, L95) — chart-side ring maps. Blueprint mentions both by name at L1395-1396 inside `def:gmscaling_chart`'s recipe. Acceptable as helpers; would be a minor improvement to promote each to its own `\lean{...}` block (the proof of `gmScaling_fixes_zero` will route through `chart1_ringMap`'s action on `zeroPt`, per the iter-181 escalation comment).
- `gmScalingP1_cover_X_iso` (private def, L124) — pullback-iso bridge. Blueprint mentions at L1506. Acceptable as an internal helper.
- `projGm_locallyOfFiniteType` (instance, L382) — proven, infer_instance via stability. Mentioned in L1910 NOTE only. **Minor:** could be promoted to a standalone `\lean{...}` block since it's an exported Lane B product-stability instance.
- `gm_geomIrred` (instance, L435) — substantive `sorry` (Mathlib gap on `GeometricallyIrreducible` for `Spec(domain)` over alg-closed base). Mentioned in L1910 NOTE only. **Should be promoted** to a standalone blueprint block stating the Mathlib gap, so its `sorry` is tracked as a named obligation rather than buried in a proof note.
- `projGm_geomIrred` (instance, L447) — derived from `gm_geomIrred` + composition; the `change`+`exact` body is honest. Mentioned in L1910 NOTE. **Should be promoted** to a standalone blueprint block.
- `projGm_isReduced` (instance, L465) — `sorry`. Mentioned in L1910 NOTE. **Should be promoted** to a standalone blueprint block.

## Blueprint adequacy for this file

- **Coverage**: 8/14 substantive declarations have a corresponding `\lean{...}` block. Unreferenced: 3 axiom-clean helpers (acceptable), 1 chart-bridge helper that has become load-bearing (`awayι_comp_PLB_hom` — minor), and 4 product-stability / Mathlib-gap instances exported for Lane B (3 of them with non-trivial `sorry`s; **should be promoted**).
- **Proof-sketch depth**: **adequate for the iter-180 retire** and **mostly adequate for iter-181+ work.** The chart-bridge identity `λ · u = (1/t) · λ in Localization.Away t ⊗[kbar] GmRing` is specified verbatim at blueprint L1444-1448 — a prover can read off exactly the ring identity to prove. The `gmScalingP1_collapse_at_zero` chart-level math is at L1590-1600 with explicit chart-`x` evaluation `(x, λ) → λ · x` restricted to `x = 0`. **One gap:** the blueprint does not preview the Lean-specific bridge from the abstract `Over.homMk (glueMorphisms …)` form of `gmScalingP1` to the per-chart computation (in particular, the `Cover.hom_ext` + `pointOfVec` factorisation chain the L357-358 comment names). The Lean proof will need this bridge, and the blueprint reader would have to consult `analogies/gmscaling-cover-bridge.md` (named in L344-352 of the Lean) to find the step-by-step.
- **Hint precision**: precise. Every `\lean{...}` pin matches the actual Lean declaration namespace + name; no signature drift.
- **Generality**: matches need. The blueprint's typeclass annotations (`[Field kbar]`, `[IsAlgClosed kbar]` downstream, `[LocallyOfFiniteType (X ⊗ Y).hom]`) match what GmScaling.lean carries.
- **Recommended chapter-side actions** (for the blueprint-writer dispatch):
  - Refresh the iter-174 status note inside `lem:gmscaling_chart_PLB_eq` (blueprint L1516-1523, "Step (C) carries two residual scaffold sorries") to "axiom-clean iter-180 via the `respectTransparency` recipe of `analogies/pullbackspeciso-bypass.md`."
  - Add a brief NOTE on `lem:gmscaling_chart_agreement` recording iter-180's diagonal-case retire (via `fst_eq_snd_of_mono_eq` and `IsOpenImmersion.mono`) so the diagonal-vs-cross status is explicit; currently the blueprint at L1440 calls the diagonal "trivial via `pullback.condition`" — sound, but iter-180 took a slightly different route.
  - Add a NOTE on `lem:gmScaling_fixes_zero` recording iter-180's retire of the laundering axiom `gmScalingP1_collapse_at_zero_temp`, plus a one-paragraph bridge preview from the glued `gmScalingP1` form to the chart-1 ring-map computation (cite the `Cover.hom_ext` + `pointOfVec` chain) so iter-181+ has the Lean-specific recipe inline rather than only in `analogies/`.
  - Promote four (or five) of the unreferenced declarations to their own blueprint blocks: `gm_geomIrred`, `projGm_isReduced`, `projGm_geomIrred`, `projGm_locallyOfFiniteType`, and optionally `awayι_comp_PLB_hom`. This makes the genuine residual `sorry`s (the first three) traceable as named blueprint obligations rather than buried inside `morphism_P1_to_grpScheme_const`'s proof note.

## Severity summary

- **must-fix-this-iter**: 0
- **major**: 0
- **minor**: 6
  - Stale "Status (iter-174)" docstring inside `gmScalingP1_over_coherence` (L298-303) — out-of-date narrative about `gmScalingP1_chart_PLB_eq`
  - Stale "body skeleton with three internal `sorry`s" claim in `gmScalingP1` docstring (L322-323)
  - Blueprint L1516-1523 "Step (C) carries two residual scaffold sorries" status note stale
  - `awayι_comp_PLB_hom` should arguably be promoted to its own `\lean{...}` block (load-bearing post-iter-180)
  - Three substantive `sorry`-carrying instances (`gm_geomIrred`, `projGm_isReduced`, `projGm_geomIrred`) and one axiom-clean instance (`projGm_locallyOfFiniteType`) should be promoted to standalone blueprint blocks
  - Blueprint should preview the Lean-side bridge for `gmScalingP1_collapse_at_zero` (`Cover.hom_ext` + `pointOfVec` chain), currently only in `analogies/gmscaling-cover-bridge.md`

Overall verdict: **iter-180 Lane A landed cleanly and is faithfully reflected in the Lean** — the headline `gmScalingP1_chart_PLB_eq` is axiom-clean and follows the blueprint's three-step decomposition verbatim, TEMP axioms are genuinely deleted, both residual `sorry`s (`chart_agreement` cross case, `collapse_at_zero`) are honest single-statement gaps. The blueprint guided iter-180 successfully; iter-181+ has *most* of what it needs but would benefit from one paragraph of Lean-specific bridge preview for `collapse_at_zero` and refreshed status narratives. No must-fix-this-iter findings.
