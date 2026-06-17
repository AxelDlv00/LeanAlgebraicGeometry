# Recommendations for iter-194 plan-agent

## CRITICAL — must-fix this iter

### 0. lean-auditor iter193 returned 7 MUST-FIX findings (read full report)

Whole-project audit (`task_results/lean-auditor-iter193.md`) flagged **7 must-fix-this-iter findings + 5 major + 6 minor**. The dominant pattern (5 of 7 must-fix) is **typed-`sorry` on load-bearing *definition carriers*** (not proof bodies) across the Picard/Quot/RelPic chain:

- `Picard/IdentityComponent.lean:671-676` — `Pic0Scheme := sorry` (consumed by 5 theorems in Pic0AbelianVariety.lean).
- `Picard/FGAPicRepresentability.lean:187-189` — `PicScheme := sorry` (consumed by IdentityComponent.lean + Pic0AbelianVariety.lean).
- `Picard/QuotScheme.lean:326-330` — `QuotScheme := sorry`.
- `Picard/RelPicFunctor.lean:{284, 370, 429}` — `PicSharp`, `presheaf`, `PicSharp.etSheaf := sorry`.
- `Picard/FGAPicRepresentability.lean:{132, 147, 226}` — `divFunctor`, `abelMap`, `picSharp := sorry`.

**Why these are different from typed-sorry on theorem bodies**: a `:= sorry` on the *carrier of a definition* silently propagates `sorryAx` through every consumer's typeclass synthesis. Every `[GrpObj (Pic0Scheme C)]` etc. carries `sorryAx`. This is the project's single largest soundness exposure.

**Auditor recommendation** (paraphrased): either land the supporting instance (e.g. `[LocallyOfFiniteType (PicScheme C).hom]`) immediately so each definition can be filled by `GroupScheme.IdentityComponent (PicScheme C)` etc.; OR guard each definition behind an existential `Nonempty (Σ' S : Over (Spec k), _)` like the rest of the file-skeleton uses (this keeps the carrier honest at the soundness level even when the construction is sorry-bodied).

**iter-194 plan-phase decision needed**: pick a refactoring strategy for this whole family. A single `refactor` subagent (`pic-quot-relpic-carrier-soundness`) holding write_domain across all 4 affected files could re-shape each `:= sorry` into the existential form in one atomic pass.

The other 2 must-fix findings are independent:
- `Picard/IdentityComponent.lean:500-507` — `private instance identityComponent_geometricallyConnected` is a **typeclass instance** derived from a sorry-bodied helper. Auditor flags this is qualitatively worse than a sorry-bodied theorem because instance synthesis fires automatically. Recommendation: demote to a non-instance lemma until the helper closes, OR gate behind an explicit `[Hypothesis]` typeclass.
- `RiemannRoch/WeilDivisor.lean` signature — same as §1 below.

### 1. Lane I signature still false; v2 corrective owed

The iter-193 plan-phase refactor `lane-i-localparameter-signature` added `(hlp : ∃ Y, Scheme.RationalMap.order Y (algebraMap K K(C) t) = 1)` to repair the iter-192 counter-witness `K = K(C), t = 1`. Iter-193 prover discovered a **second counter-witness still admitted by the new signature**:

```
K = K(C) = k̄(u), algebraMap = id, t = u(u - 1)
→ algebraMap _ _ t ≠ 0 (= u(u-1))
→ order_{{u=0}} t = 1                        ← hlp satisfied
→ positivePart(principal t) = [{u=0}] + [{u=1}]
→ degree = 2 ≠ 1 = Module.finrank K K(C)
```

The hypothesis captures "*some* zero of order 1" but not "*unique* zero of order 1". **iter-194 plan-phase MUST dispatch a corrective `refactor` subagent** — `lane-i-localparameter-signature-v2`. Prover-recommended Option 3 (cleanest scope): restrict `K` to a single-variable polynomial / function-field shape such that `algebraMap K K(C)` is concretely the function-field-of-ℙ¹ inclusion. Concretely the new signature would replace `{K : Type u} [Field K] (t : K) (halg : algebraMap K K(C) t ≠ 0)` with something like:

```
{K : Type u} [Field K] [Algebra (Polynomial kbar) K] [IsFractionRing (Polynomial kbar) K]
(t : K) (halg : algebraMap K K(C) t ≠ 0) (hgen : t = algebraMap (Polynomial kbar) K (Polynomial.X))
```

…or equivalently re-export the theorem only for `K = kbar(t)` with `t` the generator.

The 8 axiom-clean substrate helpers landed iter-193 (`principal_apply`, `positivePart_single`, `degree_single`, `one_le_degree_positivePart_principal_of_order_one`, `degree_zero`, `degree_add`, `Scheme.RationalMap.order_one`, `principal_one`) remain valid and become genuinely useful once the signature is sound.

**Cascade**: `RationalCurveIso.lean:521` `Hom.poleDivisor_degree_eq_finrank` `?hlp` discharge is gated on this signature being sound.

### 2. lean-auditor / lvbc reports landing this review

A whole-project `lean-auditor` dispatch and 3 selective `lean-vs-blueprint-checker` dispatches (WeilDivisor, Pic0AbelianVariety, AbelianVarietyRigidity) are landing during this review phase. iter-194 plan-phase MUST read their reports under `.archon/task_results/` before composing objectives and act on every CRITICAL / HIGH finding.

## High priority

### 3. Lane H Hartshorne II.1.16(b) + III.2.4 substrate

`HModule_flasque_eq_zero` is now structurally closed; the only residual sorrys are two named, blueprint-pinable substrate helpers:

- `Scheme.IsFlasque.shortExact_app_surjective` (Hartshorne II Ex 1.16(b)) — Zorn's lemma over pairs `(V, s)` with `V ⊆ U` open and `s ∈ S.X₂.val.obj (op V)` restricting to `t|_V`. ~150-200 LOC; needs stalkwise surjection from SES + sheaf gluing + flasqueness extension.
- `Scheme.IsFlasque.injective_flasque` (Hartshorne III Lemma 2.4) — construction of the extension-by-zero `j_!` functor for open immersions in `Opens X`, then use injectivity of `I`. ~100-150 LOC; `j_!` for module-valued sheaves may need a project-side build.

Once both land, **all chained downstream consumers become axiom-clean**: `Scheme.H1_skyscraperSheaf_finrank_eq_zero`, `eulerCharacteristic_skyscraperSheaf` (RRFormula), and the RR.3 chain in `OCofP.lean`. Recommend dispatch `mathlib-build` mode.

### 4. Lane M↓ Stage 6 bridges

Iter-193 landed Stages 5a/5b axiom-clean. `isRegularLocalRing_stalk_of_smooth` body now reads as Stage 1 → 3 → 4 → 5a → sorry(gap 6). The remaining gaps are:

- **(a) Stacks 02JK cotangent ↔ Kähler over a field** — the conormal sequence collapse `m/m² ≃ Ω[A⁄R] ⊗_A k(p)` when `R` is a field and `k(p)/R` is separable. Mathlib has no packaged `cotangentSpace_iso_baseChange_kaehlerDifferential_over_field` helper at SHA b80f227.
- **(b) Stacks 00OE smooth-algebra dimension formula** — `ringKrullDim Aₚ = relative dim`. Stage 5b supplies the `rank Ω` side; the `ringKrullDim` side requires Stacks 00OE, which is not in Mathlib at b80f227.

Recommend `mathlib-analogist` `lane-m-stage6-bridges` consult to scope project-side vs Mathlib-upstream paths (both gaps may be Mathlib-PR-cleaner than project-side).

### 5. Lane I substrate (Mathlib-analogist consults)

Even after the v2 signature lands, the body needs:
- Scheme-level `order_eq_ramificationIdx` DVR bridge (~30-50 LOC, project-bespoke).
- Project-bespoke affine-chart factorisation of `φ : C → ℙ¹` (multi-iter).
- `Ideal.sum_ramification_inertia` consumption (Mathlib).
- Residue-field degree = 1 over k̄ via Nullstellensatz + smooth-proper-curve (Mathlib bridge).

Plus Lane I Pin 2 (`rationalMap_order_finite_support` `f ≠ 0` branch) is genuinely Hartshorne II.6.1 / Stacks 02RV substrate — Mathlib's `Ideal.finite_minimalPrimes_of_isNoetherianRing` exists for the affine local case; lifting to scheme prime divisors is multi-iter substrate.

Recommend `mathlib-analogist` `weildivisor-pin1-ramification-bridge` AND `weildivisor-pin2-hartshorne-621`.

### 6. Lane E final closures

The Proj.appIso 4-iter STUCK is ELIMINATED. Two clean iter-194 targets remain:

- `kbarChart1Ring_specMap_fac` (AVR:222) via `Proj.fromOfGlobalSections_morphismRestrict` (Mathlib `ProjectiveSpectrum/Basic.lean:493`) + `homogeneousLocalizationAwayIso_algebraMap` (project iter-174, `Genus0BaseObjects/ChartIso.lean:347`). ~30-60 LOC.
- `iotaGm_chart1_appIso_eval` pullback-collapse residual (AVR:439) via `pullbackSpecIso_hom_appTop` chain + `Algebra.TensorProduct.lid` + `MvPolynomial.algHom_ext`. ~40-60 LOC.

Both axiom-clean = full Lane E closure. Recommend ordinary `prove` mode, single lane each (or one lane targeting both with helper budget = 0 since the recipes are spelled out).

## Medium priority

### 7. Lane A.3.i iso slot of `baseChangeIso`

The iter-193 helpers `identityComponentSection`, `identityComponent_geometricallyConnected` are the critical preparation. 4-step recipe documented in the task report:
1. Construct open immersion `pullback (IdentityComponent G).hom φ ⟶ pullback G.hom φ` via `pullback.map ... ι (𝟙) (𝟙)` + `Scheme.pullback_map_isOpenImmersion`.
2. Show range = preimage of `identityComponentCarrier G` under `pullback.fst G.hom φ`.
3. Show this preimage = `connectedComponent (identitySectionPoint G_K)` via Mathlib's `GeometricallyConnected` + `UniversallyOpen` + `ConnectedSpace pullback` instance.
4. Apply `IsOpenImmersion.isoOfRangeEq`.

Estimated 80-120 LOC. Gated on `geometricallyConnected_of_connected_of_section` body close (Stacks 037Q project-side substrate ~30-50 LOC iff-direction).

### 8. Lane F `_sectionLinearEquiv` extraction

The 5-step sheaf-level iso chain is in place. Next iter needs:
- ⊤-section transport via `tilde.isoTop` with `Γ(X, V)` notation disambiguation (`set R : CommRingCat := Γ(X, V)`).
- AddEquiv → `Γ(Y, U)`-LinearEquiv upgrade via `Hom.app_smul` + ΓSpecIso scalar transport.
- Compose with `step3.symm` to land in `Γ((pullback g).obj N, U)`.
- Beck-Chevalley intertwining check `1 ⊗ x ↦ baseMap g N e x` via naturality of `pullback_app_isoTensor_unitAtV`.

~80-120 LOC iter-194 target. Recommend `prove` mode with helper budget = 2.

### 9. Lane B topological range containment

Single substantive residual: `Set.range s_pair.base ⊆ Set.range (pullback.diagonal PLB.hom).base`. Closed-points + Jacobson density route preferred (~30-50 LOC). iter-194 plan-phase should first `lean_state_search` on the topological range containment goal for any density-style lemma that may already exist in Mathlib.

`gmScalingP1_collapse_at_zero` (line 833) is structurally similar; expect iter-195+ after cross01 closes.

## Reusable proof patterns discovered

1. **`Module.depth_eq_of_linearEquiv` substrate** (Lane G; ~50 LOC, kernel-clean): generic substrate for any depth + free-module-rank-identification argument. Now in `Albanese/AuslanderBuchsbaum.lean:798`.
2. **`Module.lift_rank_of_isLocalizedModule_of_free` + `KaehlerDifferential.isLocalizedModule_map`** (Lane M↓): localisation-of-free-Kähler-module rank transport. Reusable for any scheme-stalk Kähler argument.
3. **`IsOpenImmersion.lift_uniq` pattern** (Lane E): define a concrete ring map factoring through the open immersion; prove the Spec-map factorisation; apply lift_uniq to identify the abstract IsOpenImmersion.lift with the concrete construction. Bypasses opaque Mathlib unfolding (e.g. Proj.appIso simp loops).
4. **`simp only` for proof-irrelevant auto-param dependencies** (Lane E): when rewriting through a pullback.lift cocycle hypothesis whose type depends on the rewritten symbol, `simp only` handles it via `@[congr]` infrastructure while `rw` fails on `motive is not type correct`.
5. **Strong-induction-on-i with F-generalised quantifier** (Lane H): for higher-cohomology vanishing in flasque-resolution-style arguments, generalise the IH over the SECOND argument so the recursive case can apply to a derived flasque quotient. Pattern reusable for any "preserve P under quotient" induction.
6. **`@IsOpenImmersion.lift X Y Z f g inferInstance H'` workaround** (Lane A.3.i): explicit universe-level scheme arguments + explicit `inferInstance` for the open-immersion proof, when bare `IsOpenImmersion.lift` fails on def-folded carrier extraction.
7. **`CategoryTheory.NatTrans.naturality_apply` for pointwise naturality** (Lane H): pointwise naturality equation directly from `NatTrans`, sidestepping `NatTrans.naturality` + `FunctionLike.congr_fun` chain.

## Blocked / do-not-retry targets

- **Lane I body close** without v2 signature first — would re-encounter the same counter-witness issue.
- **Path (III.a) ring-level identity for `gmScalingP1_chart_agreement_cross01`** — blocked since iter-181 by `Iso.trans_inv` simp coverage gap on the `gmScalingP1_cover_intersection_X_iso` `≪≫`-chain. iter-194 prover should NOT retry path (III.a); prefer (III.c) closed-points route.
- **Type-wrapping the Stage 6 gap as a typed sorry helper for `isRegularLocalRing_stalk_of_smooth`** — would just move sorries around without making progress. Substrate (Stacks 00OE + 02JK) must come first.

## Plan-phase subagent suggestions for iter-194

- **`refactor` `lane-i-localparameter-signature-v2`** (mandatory): execute Option 3 (restrict `K` to single-variable polynomial / function-field-of-ℙ¹ shape).
- **`mathlib-analogist` `weildivisor-pin1-ramification-bridge`** (api-alignment): scheme-level `order_eq_ramificationIdx` DVR bridge — is there a Mathlib idiom for "DVR stalk-level order vs ramification index"?
- **`mathlib-analogist` `weildivisor-pin2-hartshorne-621`** (api-alignment): scheme-level lift of `Ideal.finite_minimalPrimes_of_isNoetherianRing` — Stacks 02RV.
- **`mathlib-analogist` `lane-m-stage6-bridges`** (cross-domain-inspiration): Stacks 00OE smooth-algebra dim formula + Stacks 02JK cotangent ↔ Kähler — is the bridge Mathlib-upstream-PR-cleaner?
- **`mathlib-analogist` `lane-rci-smoothdim1-fibre`** (api-alignment): "smooth-dim-1 morphism ⟹ fibre 0-dim" wrapper — is there a Mathlib idiom?
- **`mathlib-analogist` `lane-rci-normalScheme`** (cross-domain-inspiration): IsNormalScheme class is missing; is there a structural analogue in topology / order theory?

## Iter-194 prover-lane suggestions

Cap is 10 lanes (max_parallel constraint). Suggested fan-out:

1. Lane I body (post-v2-signature): `prove` mode + helper budget = 3. PUSH HARD beyond HARD BAR.
2. Lane H II.1.16(b) — `shortExact_app_surjective`: `mathlib-build` mode (Zorn argument; ~150-200 LOC).
3. Lane H III.2.4 — `injective_flasque`: `mathlib-build` mode (j_! construction; ~100-150 LOC).
4. Lane M↓ Stage 6: `mathlib-build` mode (Stacks 00OE + 02JK substrate; may be 2 dispatches).
5. Lane E `kbarChart1Ring_specMap_fac` + pullback collapse: `prove` mode (recipes spelled out).
6. Lane RCI helper (a) `phi_left_locallyQuasiFinite_of_finrank_one`: `fine-grained` mode (smooth-dim-1 fibre + Mathlib analogist consult landing).
7. Lane RCI helper (d) `phi_left_fromNormalization_isIso_of_smoothProper_finrank_one`: `fine-grained` mode (IsNormalScheme substrate).
8. Lane A.3.i Stacks 037Q: `mathlib-build` mode (iff-direction; ~30-50 LOC).
9. Lane F `_sectionLinearEquiv` extraction: `prove` mode + helper budget = 2.
10. Lane B topological range containment: `fine-grained` mode (closed-points/Jacobson density; ~30-50 LOC).

## Subagent results landing this iter

A `lean-auditor` whole-project audit and 3 selective `lean-vs-blueprint-checker` dispatches (WeilDivisor, Pic0AbelianVariety, AbelianVarietyRigidity) are dispatched this review. iter-194 plan-agent: read `.archon/task_results/lean-auditor-iter193.md` and `.archon/task_results/lean-vs-blueprint-checker-*.md` BEFORE composing objectives.
