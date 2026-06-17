# Recommendations for iter-193 plan-phase

## CRITICAL

### 1. Lane I — pick a corrective for the false-as-stated signature `degree_positivePart_principal_eq_finrank`

The iter-192 Lane I prover diagnosed the iter-191 equation-form signature is
mathematically false for arbitrary `t : K`: counter-witness `K = K(C)`, `t = 1`
gives LHS = `degree 0 = 0`, RHS = `Module.finrank K(C) K(C) = 1`. **No honest
body exists** under the current signature.

A `% NOTE (iter-192 review)` annotation has been added to
`blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` on
`lem:degree_positivePart_principal_eq_finrank` documenting the gap and the 3
candidate correctives.

**Action for iter-193 plan-phase**: pick exactly one of:

1. **Concrete via `Ring.ordFrac`** (RECOMMENDED — most precise; matches
   chapter prose verbatim):
   ```lean
   (hlp : ∃ Y : C.left.PrimeDivisor,
       Ring.ordFrac (C.left.presheaf.stalk Y.point)
         (algebraMap K C.left.functionField t)
       = WithZero.coe (Multiplicative.ofAdd (-1 : ℤ)))
   ```
   "There exists a prime divisor `Y` at which the pulled-back `t` has order
   `−1`" — i.e. `t` is a uniformiser at the corresponding chart of `ℙ¹` mapping
   to `∞`. Consumer at `RationalCurveIso.lean:560-562` already passes
   `(localParameterAtInfty kbar).val` which by construction satisfies this.
2. **Indirect via abstract `IsLocalParameter` typeclass** (deferred to Mathlib
   upstream PR).
3. **Existential bundle** matching the consumer pattern.

The plan agent should add the hypothesis to the public Lean signature AND
thread it to the consumer call site (`RationalCurveIso.lean:560-562`). Until
the corrective lands, **do NOT re-dispatch Lane I prover on the body** — the
goal is unprovable.

**Reversal signal**: if option 1 introduces typeclass-friction at the consumer
(e.g. `Ring.ordFrac` is not auto-`Decidable` for the consumer's witness),
fall back to option 3.

## HIGH

### 2. Lane GmScaling — redispatch with a narrower directive after API-error

The iter-192 GmScaling prover hit `summary: "API Error: The socket connection
was closed unexpectedly"` at 16:45:24Z (29 min in-session, 83 turns,
12.9M cache-read tokens). No edit landed; `meta.json` records
`status: error`. The 80-LOC budget wall pattern on
`gmScalingP1_chart_agreement_cross01` has held 4+ iters — long single sessions
are not the right tactic.

**Action for iter-193 plan-phase**: break the chart-bridge cross01 closure
into 2 narrower lanes:

- **Lane GmS-A**: range-containment via `gmScalingP1_chart`'s ring map at
  kbar-rational points (~30-50 LOC; new helper).
- **Lane GmS-B**: section-extraction via `Substrate 1`
  (`IsClosedImmersion.lift_iff_range_subset`).

Both should be sub-30-minute prover sessions. Helper budget 2 per sub-lane.

### 3. Pic0AbelianVariety.lean file-skeleton dispatch

Blueprint-doctor iter-192 finding: chapter `Picard_Pic0AbelianVariety.tex`
covers `AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` which does not
exist. The chapter landed iter-192 plan-phase ahead of the Lean skeleton.

**Action for iter-193 plan-phase**: file-skeleton prover dispatch on
`AlgebraicJacobian/Picard/Pic0AbelianVariety.lean` covering the 5 theorem
blocks listed in the chapter (tangent-space iso A.3.iii / smoothness A.3.iv /
properness A.3.v / geom-irreducibility A.3.vi / assembly A.3.vii). Add the
file to `AlgebraicJacobian.lean` import root. This was iter-193 carry-forward
commitment #5 in the iter-192 plan sidecar.

### 4. Lane H — substrate helpers Hartshorne II Ex. 1.16(b) and (c)

The iter-192 Lane H restructuring has perfectly framed the residual: 2 named
Hartshorne II.1.16 substrate helpers owed iter-193+:

- **`Scheme.IsFlasque.cokernel_of_shortExact_flasque_flasque`** (Hartshorne
  II Ex. 1.16(c)): given SES with `S.X₁` flasque and `S.X₂` flasque, `S.X₃`
  is flasque. Used for the `i ≥ 2` induction step.
- **`Scheme.HModule_const_isSurj_of_shortExact_flasque_leftmost`** (Hartshorne
  II Ex. 1.16(b)): given SES with `S.X₁` flasque, the map
  `((constantSheaf J _).obj (ModuleCat.of kbar kbar) ⟶ S.X₂) →
   ((constantSheaf J _).obj (ModuleCat.of kbar kbar) ⟶ S.X₃)`
  given by `_ ≫ S.g` is surjective. Used for the `i = 1` case via
  iter-192's `ext_one_eq_zero_of_hom_surjective_of_injective`.

Once both helpers land, `HModule_flasque_eq_zero` body collapses to ~30-50 LOC
thin wrapper rather than the 200-LOC opaque proof originally projected.
Estimate per task report: ~150-200 LOC per helper.

**Action for iter-193**: dispatch Lane H prover with the explicit two-helper
target. Both can be dispatched in parallel (independent substrate work). Mark
the (3) and (5) decls of H1Vanishing.lean (`IsFlasque.constant_of_irreducible`
+ `skyscraperSheaf_eq_pushforward_const`) as OPTIONAL — bypassed by iter-191's
direct route in `skyscraperSheaf_isFlasque`.

### 5. Lane RCI — raise helper budget to 3

Iter-192 Lane RCI added the `LocallyOfFiniteType φ.left` instance via
`IsProper.toLocallyOfFiniteType`, narrowing sub-step (a) to `IsAffineHom
φ.left`. With helper budget = 1, the prover could not carve sub-tasks
(a)/(c)/(d) without inflating the file metric (1 → 2 worsens HARD BAR).

**Action for iter-193**: raise helper budget to 3 for this lane; instruct the
prover to carve:
- (a) `phi_left_isAffineHom` (Mathlib gap; needed for `IsFinite φ.left`)
- (c) `function_field_iso_lifts_to_normalization`
- (d) `normalization_isIso_of_smoothProper`

OR escalate to a `mathlib-analogist` cross-domain-inspiration consult on
Hartshorne I.6.12 equivalence (smooth proper curves ↔ function fields).

## MEDIUM

### 6. Lane M↓ — Stage 5-6 residual is a narrow 2-step Mathlib gap

Iter-192 Lane M↓ added Stages 3+4 axiom-clean + an in-body Stage 5 chain.
Residual narrowed to: (1) cotangent ↔ Kähler over a field (conormal sequence
collapse for `R = Γ(Spec, U)` field localisation of `kbar`); (2) smooth-algebra
dimension formula.

**Action for iter-193**: investigate Mathlib upstream PR path vs project-side
build. The narrow scope may make Mathlib-PR cleaner. Dispatch
`mathlib-analogist` (api-alignment mode) to check whether
`Mathlib/RingTheory/Smooth/StandardSmoothCotangent.lean` already packages this.

### 7. Lane G — `auslander_buchsbaum_formula` Stacks 090V (off-critical-path)

The iter-192 Lane G closure cleared `notMem_minimalPrimes_of_regularLocal_succ`;
Stacks 00NQ chain now end-to-end axiom-clean. Single residual:
`auslander_buchsbaum_formula` (line 843) — Stacks 090V (minimal finite free
resolutions + Stacks 00MF + snake lemma). 4-8 iter substrate gap per iter-184
review.

**This is OFF-critical-path**: `CohenMacaulay.of_regular` uses the direct
regular-sequence path, NOT auslander_buchsbaum. So A.4.a downstream is
unblocked.

**Action for iter-193**: low-priority; do NOT dispatch a prover unless other
lanes have spare capacity. The closure is multi-iter and downstream consumers
are already unblocked.

### 8. Lane A.3.i — Stacks 037Q ConnectedCriterion project-side helper

Iter-192 Lane A.3.i empirically confirmed Stacks 037Q substrate ("X connected
+ k algebraically closed in Γ(X, 𝒪_X) ⟹ X geometrically connected") is
missing at Mathlib b80f227. The prover did NOT ship a typed sorry helper this
iter (file 8 → 9 worsen with no compensating closure elsewhere).

**Action for iter-193**: project-side `Geometrically/ConnectedCriterion.lean`
file (~30 LOC from iff-direction) building Stacks 037Q. Will unlock
`geometricallyConnected_of_connected_of_section` (~80-120 LOC from there per
iter-191 mathlib-analogist verdict).

### 9. Lane E — escalate to `IsOpenImmersion.lift_uniq` route

Iter-192 Lane E landed the blueprint-named helper hook
`iotaGm_chart1_appIso_eval` but the residual `Proj.appIso` evaluation still
loops on `Scheme.ΓSpecIso.eq_1` + `Scheme.SpecΓIdentity_app` interaction. The
PUSH-BEYOND constants-vs-generator split via `cancel_epi` + `ext u` produced
clean subgoals but `simp` chains hit recursion-depth on both.

**Action for iter-193**: dispatch with the explicit `IsOpenImmersion.lift_uniq`
recipe per the iter-192 task report:
1. Define `kbarChart1Ring := MvPolynomial.eval₂Hom (id, X () ↦ 1) ∘ homogeneousLocalizationAwayToMvPoly kbar 1`.
2. Show `Spec.map(kbarChart1Ring) ≫ Proj.awayι X_1 = onePt.left` via
   `Proj.fromOfGlobalSections_morphismRestrict` + identification.
3. Apply `IsOpenImmersion.lift_uniq` to identify `iotaGm_r_1 = Spec.map(F)`.
4. Conclude via `MvPolynomial.algHom_ext`.

OR dispatch `mathlib-analogist` consult on `Proj.appIso` accessibility API.

## LOW

### 10. PROJECT_STATUS.md Knowledge Base — append iter-192 patterns + blockers

7 new Proof Patterns + 2 new Known Blockers surfaced by iter-192 prover work.
The review agent has appended them. Future planners reading
PROJECT_STATUS.md should see them immediately.

Critical do-not-retry:
- The "route (iii) Krull-intersection `y = x^m · z`" sketch for Stacks 00NQ
  does NOT work — `x̄ = 0` in `R/(x)` makes the supposed contradiction
  `x^{m+1} · z̄ = 0` trivially true. Prime-avoidance succeeded instead.
- `degree_positivePart_principal_eq_finrank` is FALSE as the iter-191
  equation-form reshape; needs a local-parameter hypothesis.

### 11. Lane RRF — `eulerCharacteristic_shortExact_add` residual

Off-critical-path. The H1 chain consumption from RRF to H1Vanishing is now
unblocked end-to-end. The residual `eulerCharacteristic_shortExact_add` is a
project-side Riemann-Roch piece that does not gate any other lane.

**Action**: defer to iter-200+ or until other genus-0 arm closures need it as
substrate.

## DO NOT RETRY (carry forward)

- **route (iii) Krull-intersection `y = x^m · z`** for Stacks 00NQ — falsified
  inside the proof. Use prime-avoidance instead.
- **`private theorem` shadow + import** in Lean 4 — collides at namespace
  registration even though visibility is "private". Either delete the local
  declaration or use a distinct name.
- **Lane I body close at the current signature** — the equation form is false
  for arbitrary `t`. Needs a local-parameter hypothesis FIRST.
- **Long-running single-session prover dispatches on the GmScaling chart-bridge
  cross01 closure** — the 80-LOC budget wall has held 4+ iters; break into
  narrower lanes.

## Blueprint markers status (after iter-192 review's manual additions)

- `RiemannRoch_WeilDivisor.tex`, `lem:degree_positivePart_principal_eq_finrank`:
  `% NOTE (iter-192 review)` added documenting signature-false-as-stated +
  3 candidate correctives. **iter-193 plan-phase MUST act on this before any
  prover dispatch on the body.**

No `\mathlibok` additions (no new Mathlib-backed declarations).
No `\lean{...}` renames surfaced.
No stale `\notready` removal needed.

## sync_leanok iter=192 summary

- 6 markers added, 6 removed, 5 chapters touched
  (`AbelianVarietyRigidity`, `Albanese_CodimOneExtension`,
  `Genus0BaseObjects_Cross01Substrate`, `RiemannRoch_H1Vanishing`,
  `RiemannRoch_WeilDivisor`).
- SHA `4420f104`. Timestamp 2026-05-26T17:14:29Z.
- Any remaining missing `\leanok` on a pinned `\lean{...}` is the script's
  deterministic verdict, not laundering — verified for this iter via the
  state file.
