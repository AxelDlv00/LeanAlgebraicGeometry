# Iter-194 — Detailed per-lane objectives

Push-beyond-HARD-BAR framing per iter-192 standing user hint applies to
all 10 lanes: each lane below ends with the directive *"if the task can
go further, close additional sorries in the same lane — do NOT stop
after the HARD BAR; push until genuinely blocked"*.

---

## Lane I — `AlgebraicJacobian/RiemannRoch/WeilDivisor.lean`

**Mode**: [prover-mode: fine-grained]
**Helper budget**: 2

### Context

iter-194 plan-phase refactor v2 LANDED the new signature for
`degree_positivePart_principal_eq_finrank` (Option (b): drops abstract
`K`, pins `t ∈ K(ℙ¹) = (ProjectiveLineBar kbar).left.functionField`,
replaces `hlp` with the uniformiser hypothesis `hLPUnif`). The
counter-witnesses `K=K(C), t=1` and `K=K(C), t=u(u-1)` are now
excluded.

Body recipe (Hartshorne II.6.9 specialised at the local-parameter
`Y₀` from `hLPUnif`):

1. Step 1 (DONE iter-192 axiom-clean): `degree_positivePart_eq_sum_max`
   reduces LHS to `(principal _).sum (fun _ n => max n 0)`.
2. Step 2 (DONE iter-193 axiom-clean via `principal_apply` +
   `one_le_degree_positivePart_principal_of_order_one`): extract `Y₀`
   from `hLPUnif`, prove the principal-divisor coefficient at `Y₀`
   equals 1, witnessing `1 ≤ LHS`.
3. Step 3-6 (iter-194 owed): affine-chart `Spec A ⊂ ℙ¹` at `Y₀`,
   `A = k̄[t]`; preimage `Spec B := φ⁻¹(Spec A) ⊂ C` affine finite over A;
   `Ideal.sum_ramification_inertia` (Mathlib
   `NumberTheory.RamificationInertia.Basic`); residue field degrees = 1
   over `k̄` (Nullstellensatz); `order_Y` ↔ `ramificationIdx Q`
   scheme-level DVR bridge.

### HARD BAR

≥1 axiom-clean substrate helper toward the affine-chart bridge:

- (i) `order_eq_ramificationIdx` scheme-level DVR bridge (~30-50 LOC):
  given `Y : C.left.PrimeDivisor`, `f ∈ C.left.functionField^×`, and
  appropriate DVR-stalk infrastructure, `Scheme.RationalMap.order Y f =
  ramificationIdx (algebraMap_at_stalk_Y) f` (with stalk-completion
  bridges).
- (ii) Or: finite-pullback affine-cover bridge (~50-80 LOC): given
  `φ : C ⟶ ProjectiveLineBar kbar` (constructed from
  `hLPUnif`'s `Y₀` + uniformiser), `φ.left` is finite over `ProjectiveLineBar`'s
  affine chart.

Either lands as project-bespoke axiom-clean helper.

### PUSH-BEYOND

- Close `degree_positivePart_principal_eq_finrank` body axiom-clean
  using the helper.
- Attempt the in-body `Ideal.sum_ramification_inertia` consumption.
- Address the 2 typed-sorry typeclass instances landed by refactor v2
  (`instIsLocallyNoetherianProjectiveLineBar` +
  `instIsRegularInCodimOneProjectiveLineBar`) — both derivable from
  `SmoothOfRelativeDimension 1 (ProjectiveLineBar kbar).hom`.

Blueprint: `chapters/RiemannRoch_WeilDivisor.tex` §6
(iter-194 plan-phase prose updated to v2 form).

---

## Lane H — `AlgebraicJacobian/RiemannRoch/H1Vanishing.lean`

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 4 (substrate-heavy)

### Context

iter-193 Lane H closed the body of `HModule_flasque_eq_zero`
structurally through 2 named Tier-3 typed-sorry substrate helpers:

- `shortExact_app_surjective` (L329, Hartshorne II Ex 1.16(b)) —
  surjectivity-on-sections of a SES where the leftmost sheaf is
  flasque. Requires Zorn's lemma chain across open subsets to lift
  any section over an open.
- `injective_flasque` (L396, Hartshorne III Lemma 2.4) — every
  injective object in the category of sheaves of `O_C`-modules is
  flasque. Requires the `j_!` extension-by-zero functor.

Iter-194 prover target: build both substrate helpers axiom-clean.

### HARD BAR

≥1 of the 2 substrate helpers axiom-clean (~150-200 LOC each).

### PUSH-BEYOND

Both substrate helpers axiom-clean. Once both land, `HModule_flasque_eq_zero`
becomes axiom-clean transitively, unblocking the H¹-vanishing chain in
RR.2 + RR.3 + Lane A (OCofP).

Blueprint: `chapters/RiemannRoch_H1Vanishing.tex`.

---

## Lane M↓ — `AlgebraicJacobian/Albanese/CodimOneExtension.lean`

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 3

### Context

iter-193 Lane M↓ landed Stages 5a + 5b axiom-clean
(`module_free_kaehlerDifferential_localization` +
`rank_kaehlerDifferential_localization_eq_relativeDimension`). Body
of `isRegularLocalRing_stalk_of_smooth` (L434-515) chains Stage 1 → 3
→ 4 → 5a → sorry (Stage 6).

Stage 6 Mathlib gap: (a) Stacks 02JK cotangent ↔ Kähler over a field
(conormal sequence collapse for `R = Γ(Spec, U)` field localisation);
(b) Stacks 00OE smooth-algebra dimension formula. Both project-side
buildable.

### HARD BAR

≥1 axiom-clean substrate helper toward Stage 6 closure (either Stacks
02JK or 00OE bridge).

### PUSH-BEYOND

- Close `isRegularLocalRing_stalk_of_smooth` axiom-clean if both
  bridges land.
- Propagate to the 2 downstream consumers
  (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot` L685,
  `localRing_dvr_of_codim_one` L728).

Blueprint: `chapters/Albanese_CodimOneExtension.tex`.

---

## Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-193 Lane E pivoted from the 4-iter STUCK `Proj.appIso` simp loop
to `IsOpenImmersion.lift_uniq`. The pivot LANDED: `kbarChart1Ring`
axiom-clean def + `iotaGm_r_1_eq_specMap` axiom-clean conditional +
consumer refactor via `simp only [iotaGm_r_1_eq_specMap]`. New
residuals are Mathlib-clean.

### HARD BAR

Close `kbarChart1Ring_specMap_fac` (L241) via
`Proj.fromOfGlobalSections_morphismRestrict` (Mathlib re-export
verified in iter-193).

### PUSH-BEYOND

- Close `iotaGm_chart1_appIso_eval` (L439) via `pullbackSpecIso`.
- If both close, file sorry count drops 3 → 1 (only the
  `genusZero_curve_iso_P1` RR-bridge gate remains).

Blueprint: `chapters/AbelianVarietyRigidity.tex`.

---

## Lane F — `AlgebraicJacobian/Picard/QuotScheme.lean`

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-193 Lane F landed the 5-step sheaf-level iso chain axiom-clean
for `_sectionLinearEquiv`. Residual = LinearEquiv extraction +
Beck-Chevalley intertwining.

### HARD BAR

≥1 axiom-clean closure on the residual LinearEquiv extraction.

### PUSH-BEYOND

Close `_sectionLinearEquiv` body fully axiom-clean. **Off-critical-path**
for genus-0 arm but the closure makes QuotScheme.lean's substrate
ready for the Pic⁰ smoothness chain (Lane Pic0AV iter-195+).

Blueprint: `chapters/Picard_QuotScheme.tex`.

---

## Lane B — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

**Mode**: [prover-mode: prove]
**Helper budget**: 3

### Context

iter-193 Lane B HARD BAR MET (3+ axiom-clean structural pieces +
signature corrective `[IsAlgClosed kbar]`). Residual narrowed to
topological range containment via closed-points/density in
`gmScalingP1_chart_agreement_cross01` (L690).

### HARD BAR

≥1 axiom-clean helper in the closed-points/density range-containment
chain.

### PUSH-BEYOND

- Close `gmScalingP1_chart_agreement_cross01` axiom-clean.
- If time, attempt `gmScalingP1_collapse_at_zero` (the second sorry).

Per iter-193 review informational: 25-minute session cap (if no
committed edit by then, prover should exit + commit partial).

Blueprint: `chapters/AbelianVarietyRigidity.tex` III.c.

---

## Lane A.3.i — `AlgebraicJacobian/Picard/IdentityComponent.lean`

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 4

### Context

iter-193 Lane A.3.i HARD BAR MET via sanctioned typed-sorry helper
`geometricallyConnected_of_connected_of_section` (Stacks 04KU/04KV
docstring) + 3 axiom-clean section helpers + private instance derived.

iter-194 prover targets:

1. **Demote** `private instance identityComponent_geometricallyConnected`
   at L500-507 to a non-instance lemma (per lean-auditor iter-193
   must-fix; the silent `sorryAx`-instance is a soundness exposure).
   Thread `letI` at consumer sites if any. Estimated ~5-10 LOC.
2. **Close** project-side Stacks 037Q iff-direction (~30-50 LOC):
   "X connected + algebraic closure of k in Γ(X, O_X) equals k ⟹ X
   geometrically connected". This is the **substrate** that unlocks
   `geometricallyConnected_of_connected_of_section` closure
   (~80-120 LOC body).

### HARD BAR

≥1 axiom-clean closure: either the Stacks 037Q iff-direction, OR
demote the instance + supply `letI` at consumer sites.

### PUSH-BEYOND

- Close Stacks 037Q AND demote instance.
- Use the Stacks 037Q substrate to close
  `geometricallyConnected_of_connected_of_section` (L420) body.
- If that lands, iso slot of `baseChangeIso` (L640) unblocks.

Blueprint: `chapters/Picard_IdentityComponent.tex`.

---

## Lane RCI — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

**Mode**: [prover-mode: mathlib-build]
**Helper budget**: 3

### Context

iter-193 Lane RCI Pin 3 Step 2 carving completed: helper (c)
`phi_left_toNormalization_isIso_of_isIntegralHom` AXIOM CLEAN via
Mathlib re-export `instIsIsoToNormalizationOfIsIntegralHom`. Helpers
(a) `phi_left_locallyQuasiFinite_of_finrank_one` (L723) and (d)
`phi_left_fromNormalization_isIso_of_smoothProper_finrank_one` (L782)
are typed sorrys.

The new `?hLPUnif` typed sorry at L571 (from iter-194 refactor v2,
1:1 swap for the iter-193 `?hlp` sorry) is iter-194+ body-close work;
NOT part of this lane's HARD BAR.

### HARD BAR

Close helper (a) `phi_left_locallyQuasiFinite_of_finrank_one` axiom-
clean via Mathlib's `LocallyQuasiFinite.of_fiberToSpecResidueField`
(verified iter-193 typecheck: `apply LocallyQuasiFinite.of_fiberToSpecResidueField`
reduces to per-fibre `LocallyQuasiFinite (φ.left.fiberToSpecResidueField y)`).
Each fibrewise step needs "smooth-dim-1 + integral ⟹ fibre 0-dim"
wrapper — Mathlib gap; project-side build budget ~30-50 LOC.

### PUSH-BEYOND

- Close helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`
  via project-side `IsNormalScheme` substrate (cross-domain-inspiration
  candidate for iter-200 mathlib-analogist sweep).
- Close `?hLPUnif` at L571 via the explicit `localParameterAtInfty`
  uniformiser property.

Blueprint: `chapters/RiemannRoch_RationalCurveIso.tex`.

---

## Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-193 Lane G landed `Module.depth_eq_of_linearEquiv` axiom-clean
(~50 LOC kernel-clean) + `auslander_buchsbaum_formula` 2-branch case
split with n=0 branch 7 substantive steps kernel-clean. Residual =
`depth(Fin k → R) = depth(R)` (an axiom-clean lemma proving the
free-module-depth-equals-base-ring-depth).

OFF-CRITICAL-PATH per PROGRESS.md (A.4.b `CohenMacaulay.of_regular`
uses direct regular-sequence path).

### HARD BAR

Close `depth(Fin k → R) = depth(R)` substrate (axiom-clean, ~30-80
LOC), the residual of the n=0 branch.

### PUSH-BEYOND

- If the n=0 closure lands, attempt the n=k+1 inductive step (Stacks
  090V minimal-finite-free-resolutions + 00MF + snake lemma).
- If the n=k+1 step is multi-iter, partial progress (any structural
  sub-lemma axiom-clean) is acceptable per push-beyond framing.

Closing both branches makes `auslander_buchsbaum_formula` axiom-clean,
which makes AuslanderBuchsbaum.lean sorry-free — a clean milestone.

Blueprint: `chapters/Albanese_AuslanderBuchsbaum.tex`.

---

## Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`

**Mode**: [prover-mode: prove]
**Helper budget**: 2

### Context

iter-193 Lane H closed the body of `HModule_flasque_eq_zero`
structurally through 2 named typed-sorry helpers; consumers can now
proceed with transitive sorry propagation (the H1V helpers landing
iter-194 will clean it).

OCofP has 3 sorries: `lineBundleAtClosedPoint` body (L183);
`carrierPresheaf_isSheaf` (L690); plus the OCofP body chain. Both
gated on RR.2.H¹ closure substrate (which Lane H is building).

### HARD BAR

≥1 axiom-clean closure on any of the 3 sorries, OR substantive
structural advance on the RR.3 chain (e.g. closing the
`carrierPresheaf_isSheaf` Mayer-Vietoris assembly).

### PUSH-BEYOND

Multi-sorry closure if budget allows. If Lane H closes both substrate
helpers iter-194, OCofP body close becomes practical iter-195.

Blueprint: `chapters/RiemannRoch_OCofP.tex`.

---

## Lane Pic0AV — DEFERRED (gated on carrier-soundness refactor iter-195+)

The new Pic0AbelianVariety.lean file-skeleton has 5 typed sorries on
the 5 chapter pins. Each consumes `Pic0Scheme C` which is itself a
`:= sorry` carrier. Iter-194 dispatch deferred pending the carrier-
soundness refactor (iter-195+).

---

## File-skeleton dispatches

None this iter — all 10 lanes target existing files with established
substrate.

---

## Off-limits / deferred iter-194

- `AlgebraicJacobian/Albanese/AlbaneseUP.lean`: standing deferral
  (iter-200+).
- `AlgebraicJacobian/Picard/RelPicFunctor.lean`: gated on A.2.
- `AlgebraicJacobian/Picard/FlatteningStratification.lean`: gated on
  A.2.a.
- `AlgebraicJacobian/Picard/FGAPicRepresentability.lean`: gated on
  A.2.c.
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean` (Lane J): STRUCTURALLY
  BLOCKED — DO NOT DISPATCH (iter-187 finding).
- `AlgebraicJacobian/Albanese/Thm32RationalMapExtension.lean`: Branch 2
  gated on Lane M↓ Stacks 00TT close.
- `AlgebraicJacobian/Picard/RelativeSpec.lean` (A.1.a): functionally
  complete; signature refinement separately tracked.
- `AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`: Mathlib gaps;
  off-target.
- `AlgebraicJacobian/Jacobian.lean`: gated.
- `AlgebraicJacobian/RiemannRoch/RRFormula.lean`: 1 residual sorry
  (off-critical-path).
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean`: standing deferral.
- `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean`: gated on carrier
  soundness refactor (iter-195+).
