# Iter-193 objectives (detail)

10 prover lanes at the dispatch cap. Each ends with the user-hint-aligned
push-beyond directive.

## Lane I body (post-refactor) — `RiemannRoch/WeilDivisor.lean`

`[prover-mode: prove]`

- Plan-phase landed: refactor `lane-i-localparameter-signature` adds
  `(hlp : ∃ Y : C.left.PrimeDivisor, Scheme.RationalMap.order Y
  (algebraMap K C.left.functionField t) = 1)` to
  `degree_positivePart_principal_eq_finrank`. Body is still typed sorry
  (iter-193+ work).
- Target: close `degree_positivePart_principal_eq_finrank` body axiom-
  clean. Recipe (chapter `RiemannRoch_WeilDivisor.tex` §6):
  1. Step 1 (DONE iter-192 axiom-clean): `degree_positivePart_eq_sum_max`
     reduces to `(principal _ _).sum (fun _ n => max n 0)`.
  2. Step 2: `hlp` produces the local-parameter prime divisor `Y₀`;
     `order Y₀ (algebraMap _ _ t) = 1` ⟹ `Y₀` is in the support of
     `principal _ _` with coefficient 1.
  3. Step 3: apply `Ideal.sum_ramification_inertia` (Mathlib
     `NumberTheory.RamificationInertia.Basic`) at the affine chart at
     `Y₀` ⟹ the sum of ramification indices times residue-field degrees
     equals `[K(C) : K(ℙ¹)]` = `Module.finrank K K(C)`.
  4. Step 4: Identify residue-field degrees `f(Q | m_∞) = 1` (over `k̄`).
  5. Step 5: Identify each `e_Q` with `ord_{Y_Q} (algebraMap _ _ t)`
     via `IsDiscreteValuationRing.order_eq_ramificationIdx` (scheme-
     level DVR bridge — currently a Mathlib gap; the bridge may also
     need project-side construction).
- **HARD BAR**: ≥1 axiom-clean substrate helper toward Steps 3-5 (e.g.
  the `order_eq_ramificationIdx` scheme-level DVR bridge, OR the
  finite-pullback affine-cover bridge). Helper budget = 2.
- **PUSH-BEYOND**: if substrate lands, close
  `degree_positivePart_principal_eq_finrank` body axiom-clean. Then
  examine the other 2 sorries in the file:
  - `principal_degree_zero` non-constant branch (Hartshorne II.6.10 —
    same Hartshorne II.6.9 substrate; closes by cascade if Lane I closes).
  - `rationalMap_order_finite_support` `f ≠ 0` branch (Stacks 02RV;
    finite primes divide numerator/denominator; project-bespoke).

## Lane RCI Pin 3 Step 2 carving — `RiemannRoch/RationalCurveIso.lean`

`[prover-mode: fine-grained]`. Helper budget = 3 (raised from 1 per
iter-192 review §5).

- Plan-phase landed: refactor adds typed sorry for `?hlp` discharge at
  L560-562 consumer of `degree_positivePart_principal_eq_finrank`.
  **THIS sorry is iter-194+ work; the prover should NOT attempt to close
  it this iter** (it requires constructing the prime divisor `φ⁻¹(∞)`
  on `C` and proving its order is 1 — multi-iter substrate work).
- Target: carve Pin 3 Step 2 sub-tasks (a)/(c)/(d) per iter-192 task
  report:
  - (a) `phi_left_isAffineHom`: non-constant morphism of integral 1-dim
    schemes is finite via fibre-dimension argument
    (smooth-dim-1 + non-constancy ⟹ quasi-finite via
    `dim φ⁻¹(q) ≤ dim C - dim C' = 0`); then proper + quasi-finite ⟹
    finite. Use the `LocallyOfFiniteType φ.left` instance landed
    iter-192.
  - (c) `function_field_iso_lifts_to_normalization`: lift the function-
    field iso (Step 1) to a scheme iso through normalisation
    (Hartshorne I.6.12 = Stacks 0AVX).
  - (d) `normalization_isIso_of_smoothProper`: a smooth scheme is
    normal, so the normalisation map is an iso.
- **HARD BAR**: ≥1 of (a)/(c)/(d) axiom-clean as a named lemma.
- **PUSH-BEYOND**: close 2+ helpers; attempt `iso_of_degree_one` body
  if (a)+(c)+(d) all land. If unable to advance, dispatch
  `mathlib-analogist iso-of-degree-one-pin3` iter-194.

## Lane H II.1.16(b)/(c) substrate — `RiemannRoch/H1Vanishing.lean`

`[prover-mode: mathlib-build]`. Helper budget = 4.

- Target: build the 2 named substrate helpers framed by iter-192:
  - `Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque` (Hartshorne
    II Ex 1.16(c)): given SES `0 → S.X₁ → S.X₂ → S.X₃ → 0` with `S.X₁`
    flasque and `S.X₂` flasque, `S.X₃` is flasque.
  - `Scheme.HModule_const_isSurj_of_shortExact_flasque_leftmost`
    (Hartshorne II Ex 1.16(b)): given SES with `S.X₁` flasque, the map
    `((constantSheaf J _).obj (ModuleCat.of kbar kbar) ⟶ S.X₂) →
    ((constantSheaf J _).obj (ModuleCat.of kbar kbar) ⟶ S.X₃)`
    given by `_ ≫ S.g` is surjective.
- Once both helpers land, `HModule_flasque_eq_zero` body (Hartshorne
  III.2.5) collapses to ~30-50 LOC `(i = 1)` via II.1.16(b) +
  `ext_one_eq_zero_of_hom_surjective_of_injective` (iter-192) +
  `(i ≥ 2)` via LES iso + II.1.16(c) induction.
- **HARD BAR**: 1 of 2 substrate helpers axiom-clean (~150-200 LOC).
- **PUSH-BEYOND**: both substrate helpers axiom-clean + close
  `HModule_flasque_eq_zero` body. Decls (3) + (5) remain OPTIONAL
  (bypassed iter-191).

## Lane M↓ Stage 5-6 mathlib gap — `Albanese/CodimOneExtension.lean`

`[prover-mode: mathlib-build]`. Helper budget = 3.

- Plan-phase context: Stages 1-4 axiom-clean iter-191/192; in-body
  Stage 5 chain axiom-clean. Residual narrowed to:
  - (a) cotangent ↔ Kähler over a field: conormal sequence collapse for
    `R = Γ(Spec, U)` field localisation of `kbar`.
  - (b) smooth-algebra dimension formula.
- **HARD BAR**: 1 substrate helper axiom-clean (either gap bridge).
- **PUSH-BEYOND**: close `isRegularLocalRing_stalk_of_smooth` axiom-
  clean if both bridges land; propagate to the 2 downstream consumers
  (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`,
  `localRing_dvr_of_codim_one`).
- **Mathlib hint**: investigate
  `Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean`; if this
  packages both bridges already, the prover may need only re-export
  wiring.

## Lane G `auslander_buchsbaum_formula` — `Albanese/AuslanderBuchsbaum.lean`

`[prover-mode: prove]`. Helper budget = 2. **OFF-CRITICAL-PATH** (per
iter-192 review §7).

- Plan-phase context: Stacks 00NQ chain end-to-end axiom-clean (iter-192).
  `CohenMacaulay.of_regular` uses direct regular-sequence path, NOT
  auslander_buchsbaum_formula. So A.4.a downstream unblocked.
- Target: attempt `auslander_buchsbaum_formula` (L843, Stacks 090V).
  Substrate: minimal finite free resolutions (Stacks 00MF) + snake lemma
  + iterated `depth_of_short_exact`.
- **HARD BAR**: LOW (off-critical-path) — substantive structural advance
  is sufficient. E.g. ≥1 axiom-clean Stacks 00MF substrate or framing.
- **PUSH-BEYOND**: full body close (multi-iter; not expected this iter).
- **Rationale for keeping in the round**: file is currently 1 sorry;
  closing it makes AuslanderBuchsbaum.lean sorry-free, a clean milestone.
  But genuinely OK to return PARTIAL.

## Lane A.3.i Stacks 037Q substrate — `Picard/IdentityComponent.lean`

`[prover-mode: mathlib-build]`. Helper budget = 4.

- Plan-phase context: iter-192 landed 2 axiom-clean instances +
  `baseChangeIso` 2-of-3 conjuncts. Iso slot residual + the underlying
  `geometricallyConnected_of_connected_of_section` (Stacks 04KU) gate
  on Stacks 037Q substrate (currently a Mathlib gap at b80f227).
- Target: build the Stacks 037Q substrate as a project-side lemma in
  this file (avoid new-file overhead this iter):
  - **Stacks 037Q** (iff direction needed): given `X` connected over `k`
    and the algebraic closure of `k` in `Γ(X, 𝒪_X)` equals `k`, then
    `X` is geometrically connected over `k`. ~30-50 LOC from the
    iff-direction.
  - Then `geometricallyConnected_of_connected_of_section`: given `X`
    connected + `k`-rational section `s : Spec k ⟶ X`, the pullback
    `s^* : Γ(X, 𝒪_X) ⟶ k` is a `k`-algebra retraction; any subfield
    `F` of `Γ(X, 𝒪_X)` containing `k` maps injectively to `k` ⟹ `F = k`;
    combine with connectedness ⟹ geometrically connected. ~80-120 LOC.
- **HARD BAR**: 1 axiom-clean Stacks 037Q lemma OR the full Stacks
  04KU helper.
- **PUSH-BEYOND**: land BOTH the substrate AND the Stacks 04KU helper;
  use the latter to close the iso slot of `baseChangeIso`.

## Lane F additional residuals — `Picard/QuotScheme.lean`

`[prover-mode: prove]`. Helper budget = 2.

- Plan-phase context: iter-192 Lane F closed `pullback_of_openImmersion_iso_restrict`
  axiom-clean (12 sorries remain).
- Target: attempt `_sectionLinearEquiv` body (iter-189 left this open;
  AddEquiv structure is in place per iter-192 task report). Or any other
  closable Step-3 residual.
- **HARD BAR**: 1 axiom-clean closure.
- **PUSH-BEYOND**: close 2+ residuals. If `_sectionLinearEquiv` is too
  deep, attempt a smaller wrapper.

## Pic0AbelianVariety file-skeleton — `Picard/Pic0AbelianVariety.lean` (NEW)

`[prover-mode: formalize]`. Helper budget = 0.

- Plan-phase context: blueprint chapter `Picard_Pic0AbelianVariety.tex`
  landed iter-192 plan-phase ahead of the Lean file. blueprint-doctor
  flagged the orphan `% archon:covers`.
- Target: create `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`
  with the 5 theorem statements declared in the chapter (one per
  `\lean{...}`):
  - `AlgebraicGeometry.Scheme.Pic0.tangentSpaceIso` (A.3.iii)
  - `AlgebraicGeometry.Scheme.Pic0.smooth` (A.3.iv)
  - `AlgebraicGeometry.Scheme.Pic0.proper` (A.3.v)
  - `AlgebraicGeometry.Scheme.Pic0.geometricallyIrreducible` (A.3.vi)
  - `AlgebraicGeometry.Scheme.Pic0.isAbelianVariety` (A.3.vii assembly)
- Add `import AlgebraicJacobian.Picard.Pic0AbelianVariety` to
  `AlgebraicJacobian.lean` import root.
- **HARD BAR**: file compiles with 5 sorries; imports + namespace correct.
- **PUSH-BEYOND**: not expected to close anything (formalize mode).
- **Note**: the `Pic0` namespace under `Scheme` may need a
  `def Scheme.Pic0` namespace placeholder — coordinate with the
  chapter's `def:pic_zero_subscheme` reference (currently lives in
  `Picard/IdentityComponent.lean`'s `IdentityComponent` def). The
  skeleton should reference whatever bottom def the chapter pins.

## Lane B chart_agreement (one tighter directive) — `Genus0BaseObjects/GmScaling.lean`

`[prover-mode: prove]`. Helper budget = 3.

- Plan-phase context: iter-192 hit API socket error (no edit landed);
  iter-191 left 2 sorries.
- Target: close `gmScalingP1_chart_agreement_cross01` axiom-clean.
  Per iter-192 review §2, scope to range-containment + section-extraction
  in ONE session (25-minute target; if blow-up risk surfaces, prover
  may carve a single helper):
  1. Add `[IsAlgClosed kbar]` to the lemma signature; propagate to
     consumers.
  2. Unfold `gmScalingP1_chart`'s ring map + `gmScalingP1_cover_X_iso`
     projection at kbar-rational points.
  3. Use `QuasiSeparatedSpace (pullback PLB.hom PLB.hom)` (inherited
     from PLB proper ⟹ separated) + `quasiCompact_of_compactSpace` to
     discharge `QuasiCompact s_pair`.
  4. Apply `IsClosedImmersion.lift_iff_range_subset` (Substrate 1) to
     extract `s : intersection → PLB`.
  5. Derive cocycle via `pullback.diagonal_fst/snd`.
- **HARD BAR**: ≥1 axiom-clean helper in the range-containment chain.
- **PUSH-BEYOND**: close `gmScalingP1_chart_agreement_cross01` axiom-
  clean; if still time, attempt `gmScalingP1_collapse_at_zero`.

## Lane E `IsOpenImmersion.lift_uniq` route — `AbelianVarietyRigidity.lean`

`[prover-mode: fine-grained]`. Helper budget = 3.

- Plan-phase context: 4-iter STUCK streak on `Proj.appIso` `simp` loop
  in `iotaGm_chart1_appIso_eval`. iter-192 task report explicitly named
  the `IsOpenImmersion.lift_uniq` route as the recommended escape.
- Target: implement the recipe step-by-step:
  1. Define
     `kbarChart1Ring := MvPolynomial.eval₂Hom (id, X () ↦ 1) ∘
       homogeneousLocalizationAwayToMvPoly kbar 1`.
  2. Show `Spec.map(kbarChart1Ring) ≫ Proj.awayι X_1 = onePt.left`
     via `Proj.fromOfGlobalSections_morphismRestrict` + identification.
  3. Apply `IsOpenImmersion.lift_uniq` to identify
     `iotaGm_r_1 = Spec.map(kbarChart1Ring)`.
  4. Conclude `iotaGm_chart1_appIso_eval` via `MvPolynomial.algHom_ext`.
- **HARD BAR**: ≥1 axiom-clean helper (e.g. `kbarChart1Ring` def +
  the Spec-map factorisation).
- **PUSH-BEYOND**: close `iotaGm_chart1_appIso_eval` axiom-clean (and
  thereby axiom-clean the consumer `iotaGm_chart1_composition_isOpenImmersion`).

## Standing deferrals (off-objectives this iter)

- `AlgebraicJacobian/Picard/RelPicFunctor.lean` — gated on A.2.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean` — gated on A.2.a.
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean` — gated on A.2.c.
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean` — STRUCTURALLY BLOCKED.
- `AlgebraicJacobian/RiemannRoch/OCofP.lean` — 3 sorries gated on Lane H
  decl #4 close (iter-194 conditional).
- `AlgebraicJacobian/Albanese/AlbaneseUP.lean` — iter-200+ standing.
- `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean` — Branch 2
  gated on Lane M↓.
- `AlgebraicJacobian/Picard/RelativeSpec.lean` — functionally complete.
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean` — Mathlib gaps.
- `AlgebraicJacobian/Jacobian.lean` — gated.
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean` — 1 sorry
  (`eulerCharacteristic_shortExact_add`, off-critical-path).
