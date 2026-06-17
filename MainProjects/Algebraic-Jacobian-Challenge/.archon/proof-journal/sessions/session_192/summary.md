# Session 192 — Review of iter-192

## Session metadata

- **Iteration / session**: 192
- **Sorry count before**: 80 (iter-191 ending; 11th consecutive zero-axiom build)
- **Sorry count after**: **77** (`lake build AlgebraicJacobian` `declaration uses 'sorry'` warning count — verified by regex extraction; 12th consecutive zero-axiom build streak)
- **Sorry delta**: **−3**
- **Build status**: `lake build AlgebraicJacobian` GREEN (8360/8360 jobs replayed).
- **Project axiom count**: 0 (kernel-only `{propext, Classical.choice, Quot.sound}` on every closed declaration; `sorryAx` only inside named typed-sorry pins).
- **Targets attempted (10 prover lanes)**:
  1. Lane H — `RiemannRoch/H1Vanishing.lean` (`HModule_flasque_eq_zero` body restructuring + substrate helpers)
  2. Lane I (WD) — `RiemannRoch/WeilDivisor.lean` (`degree_positivePart_principal_eq_finrank` body + Pin 1/Pin 2)
  3. Lane M↓ — `Albanese/CodimOneExtension.lean` (`isRegularLocalRing_stalk_of_smooth` Stages 3-4)
  4. Lane F — `Picard/QuotScheme.lean` (`pullback_of_openImmersion_iso_restrict` aliasing-`let`)
  5. Lane A.3.i — `Picard/IdentityComponent.lean` (`geometricallyConnected_of_connected_of_section` Stacks 04KU)
  6. Lane G — `Albanese/AuslanderBuchsbaum.lean` (`notMem_minimalPrimes_of_regularLocal_succ` route iii Krull-intersection)
  7. Lane E — `AbelianVarietyRigidity.lean` (`iotaGm_chart1_appIso_eval` + composition consumer)
  8. Lane GmScaling — `Genus0BaseObjects/GmScaling.lean` (`gmScalingP1_chart_agreement_cross01` chart-bridge)
  9. Lane RCI — `RiemannRoch/RationalCurveIso.lean` (`iso_of_degree_one` Pin 3 sub-tasks (a)/(c)/(d))
 10. Lane RRF — `RiemannRoch/RRFormula.lean` (H1 chain consumption)

## Per-target summary

### Lane G — `Albanese/AuslanderBuchsbaum.lean` (SUCCESS — HARD BAR + PUSH-BEYOND)

- **HARD BAR**: MET. `notMem_minimalPrimes_of_regularLocal_succ` (typed sorry, iter-191 helper) closed kernel-clean.
- **PUSH-BEYOND**: PARTIAL (only the substantive `auslander_buchsbaum_formula` Stacks 090V remains; multi-iter substrate gap).
- **Approach (Attempt 1, FAILED)**: route (iii) Krull-intersection decomposition `y = x^m · z` per PROGRESS.md sketch. Empirically falsified inside the proof — passing to `R/(x)` collapses `x^{m+1}` to `0`, so `x^{m+1} · z̄ = 0` is trivially true in the domain `R/(x)` and yields no contradiction with `z̄ ≠ 0`. The PROGRESS.md sketch has a logical gap.
- **Approach (Attempt 2, SUCCESS)**: prime-avoidance route. Pick `x' ∈ 𝔪 \ (𝔪² ∪ ⋃ minimalPrimes R)` via `Ideal.subset_union_prime_finite`. Apply iter-191 helper `regularLocal_quotient_isRegularLocal_of_notMemSq` ⟹ `R/(x')` is regular local of `spanFinrank = k`. Apply `hIH` (universally quantified IH) ⟹ `IsDomain (R/(x'))` ⟹ `(x')` prime. Pick minimal prime `𝔭' ⊆ (x')`; `x' ∉ 𝔭'` by avoidance. Conclude `𝔭' ⊆ x' · 𝔭'` via primality + comparison; apply Nakayama `Submodule.FG.eq_bot_of_le_jacobson_smul` ⟹ `𝔭' = ⊥`. So `⊥ ∈ minimalPrimes R` ⟹ `IsDomain R` ⟹ `(⊥ : Ideal R).minimalPrimes = {⊥}` ⟹ `(x) = ⊥` ⟹ `x = 0`, contradicting `x ∉ 𝔪²`.
- **Lemmas used**: `minimalPrimes.finite_of_isNoetherianRing`, `Ideal.subset_union_prime_finite`, `Ideal.primeHeight_eq_zero_iff`, `IsLocalRing.maximalIdeal_primeHeight_eq_ringKrullDim`, `IsRegularLocalRing.spanFinrank_maximalIdeal`, `Ideal.minimalPrimes_isPrime`, `Ideal.exists_minimalPrimes_le`, `Ideal.Quotient.isDomain_iff_prime`, `Submodule.FG.eq_bot_of_le_jacobson_smul`, `IsLocalRing.ringJacobson_eq_maximalIdeal`, `IsDomain.of_bot_isPrime`, `Ideal.minimalPrimes_eq_subsingleton_self`.
- **Sorry trajectory**: 2 → 1 (−1).
- **Axioms**: kernel-only.
- **Key insight (KB candidate)**: the IH is universally quantified in the ring `R'`; we can apply it to `R/(x')` for ANY admissible `x'` (not just the specific `x` from the goal). The freedom to pick a fresh witness avoiding all minimal primes lets us run the standard proof of `IsDomain R` and derive contradiction.

### Lane F — `Picard/QuotScheme.lean` (SUCCESS — HARD BAR MET)

- **HARD BAR**: MET. `pullback_of_openImmersion_iso_restrict` (Step 3 pin) closed kernel-clean.
- **Approach**: applied the `lane-f-restrictscalars-smul` analogist recipe verbatim:
  - Step A: aliasing-`set y : Γ(N, hU.fromSpec ''ᵁ ⊤)` to bring the Y-side smul into instance scope (HSMul resolution on `restrict_obj` fails per iter-190 finding).
  - Step B: `change` to the Y-side action via the `(hU.fromSpec.appIso ⊤).inv.hom` unfold.
  - Step C: `rw [Scheme.Modules.map_smul]` to migrate the Y-side scalar through the presheaf restriction.
  - Step D: prove the key identity `(ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫ Y.presheaf.map (eqToHom hImg.symm).op = 𝟙` via `Scheme.Hom.appLE_appIso_inv` + `IsAffineOpen.fromSpec_app_self` + poset-`Subsingleton` collapse.
- **Key insight**: the sub-key identity `hU.fromSpec.appLE U ⊤ e₀ = (ΓSpecIso Γ(Y, U)).inv` closes via `simp [Scheme.Hom.appLE, hU.fromSpec_app_self, ← Functor.map_comp]`. Internally collapses the Spec-side `eqToHom ≫ homOfLE` poset arrow through `Functor.map_id`.
- **Pattern**: the `set y` (rather than `let y`) is important — `set` substitutes the term in the goal, but the smul instance on `y`'s type is the `Γ(Spec _, ⊤)`-action defined via the restrict module structure on the carrier. The `change` then re-expresses this as the Y-side action by the rfl-unfold of `restrictFunctor`'s smul.
- **LOC**: ~50. Helper budget: 0 used / 2 budgeted.
- **Sorry trajectory**: 13 → 12 (−1).
- **Axioms**: kernel-only.

### Lane RRF — `RiemannRoch/RRFormula.lean` (SUCCESS — HARD BAR MET)

- **HARD BAR**: MET. `H1_skyscraperSheaf_finrank_eq_zero` shadow removed; consumer `eulerCharacteristic_skyscraperSheaf` now traces to the iter-191 Lane H public pin.
- **Approach (Attempt 1, FAILED)**: add `import AlgebraicJacobian.RiemannRoch.H1Vanishing` + delegate the local `private theorem Scheme.H1_skyscraperSheaf_finrank_eq_zero` body to `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero`. Error: `` a non-private declaration `AlgebraicGeometry.Scheme.H1_skyscraperSheaf_finrank_eq_zero` has already been declared ``.
- **Approach (Attempt 2, SUCCESS)**: delete the local `private theorem` entirely + replace with a docstring-only `/-! ... -/` block explaining the sourcing change. Downstream consumer resolves to the public version automatically.
- **Key insight (KB candidate)**: `private` in Lean 4 controls *visibility* (callability from outside the file), not *namespace registration*. The fully qualified name still goes into the environment; a `private` declaration cannot share a name with an imported declaration even though it cannot be referenced from outside.
- **Sorry trajectory**: 2 → 1 (−1).
- **Residual**: `eulerCharacteristic_shortExact_add` (off-critical-path).

### Lane H — `RiemannRoch/H1Vanishing.lean` (PARTIAL — HARD BAR EXCEEDED, 4 new substrate helpers)

- **HARD BAR**: EXCEEDED. Target was ≥1 new axiom-clean intermediate helper; 4 landed.
- **Approach**: restructure `Scheme.HModule_flasque_eq_zero` body around 4 new axiom-clean substrate helpers.
- **New helpers**:
  1. `Scheme.HModule_injective_finrank_eq_zero` (L170): via `HasInjectiveDimensionLT.subsingleton` + `instHasInjectiveDimensionLTOfNatNatOfInjective` + `Module.finrank_zero_of_subsingleton`. 3 lines.
  2. `Scheme.injectiveSES` def (L188): canonical injective-embedding `ShortComplex` (`F → Injective.under F → cokernel(Injective.ι F)`).
  3. `Scheme.injectiveSES_shortExact` theorem (L196): upgrades to `ShortExact` via `ShortComplex.exact_cokernel`, `Injective.ι_mono`, `Limits.coequalizer.π_epi`.
  4. `ext_one_eq_zero_of_hom_surjective_of_injective` (L224): generic abelian-category `Ext^1` vanishing given a SES with injective middle + Hom-surjectivity. Uses `HasInjectiveDimensionLT.subsingleton` + `Abelian.Ext.covariant_sequence_exact₁` + `Abelian.Ext.addEquiv₀`.
- **Body restructure**: `HModule_flasque_eq_zero` (decl #4) now carries a single typed sorry backed by an explicit two-case recipe — `(i = 1)` apply `ext_one_eq_zero_of_hom_surjective_of_injective` + Hartshorne II.1.16(b); `(i ≥ 2)` LES iso `HModule kbar F i ≃ HModule kbar G (i-1)` (G flasque by II.1.16(c)).
- **Dead-end avoided**: an earlier draft expanded the body into two sub-sorries (one per case), inflating the file count. Collapsed back to a single typed sorry to preserve file count.
- **Sorry trajectory**: 3 → 3 (file flat; substantive structural advance).
- **Residual substrate**: 2 Hartshorne II.1.16(b)/(c) helpers owed iter-193+ (estimated ~150-200 LOC each per task report).

### Lane M↓ — `Albanese/CodimOneExtension.lean` (PARTIAL — HARD BAR MET, 2 new helpers + in-body Stage 5)

- **HARD BAR**: MET. 2 NEW axiom-clean helpers (Stage 3 + Stage 4).
- **New helpers**:
  - **Stage 3** (L260) `exists_algebra_isStandardSmooth_section_stalk_isLocalization_of_smooth`: composes iter-191 Stage 2 + `RingHom.IsStandardSmooth.toAlgebra` + `IsAffineOpen.isLocalization_stalk`. Output: existence of affine V ∋ z, `Algebra Γ(Spec _, U) Γ(X.left, V)` instance with `Algebra.IsStandardSmooth`, AND `IsLocalization.AtPrime` witness.
  - **Stage 4** (L294) `module_free_kaehlerDifferential_of_isStandardSmooth`: re-exports `Algebra.IsStandardSmooth.iff_exists_basis_kaehlerDifferential` + `Module.Free.of_basis`.
- **PUSH-BEYOND in-body Stage 5**: `letI`-driven `Algebra Γ(Spec _, U) (stalk z)` chain + `IsScalarTower` + `IsLocalizedModule` via `KaehlerDifferential.isLocalizedModule_map` + `Module.Free (stalk z) Ω[(stalk z)⁄Γ(Spec _, U)]` via `Module.free_of_isLocalizedModule`. All axiom-clean in-body.
- **Residual narrowed**: 2-step Mathlib gap — (1) cotangent ↔ Kähler over a field (conormal sequence collapse for `R = Γ(Spec, U)` field localisation of `kbar`); (2) smooth-algebra dimension formula.
- **Sorry trajectory**: 3 → 3.

### Lane E — `AbelianVarietyRigidity.lean` (PARTIAL — blueprint hook in code)

- **HARD BAR**: NOT MET strictly. Helper introduced but body residual.
- **Approach (Attempt 1, PARTIAL)**: extract the iter-185–iter-191 proof skeleton (Stages 1–8) into a NEW named blueprint-pinned helper `iotaGm_chart1_appIso_eval` (matching plan-phase blueprint chapter `lem:iotaGm_chart1_appIso_eval` at L1146-1219). Consumer `iotaGm_chart1_composition_isOpenImmersion` body cleaned up — uses helper via `rw [iotaGm_chart1_appIso_eval kbar]`. LOC delta in consumer: −110 lines (skeleton relocated).
- **Approach (Attempt 2, PARTIAL)**: PUSH-BEYOND on the residual via `rw [← cancel_epi (ΓSpecIso ...).inv]; refine CommRingCat.hom_ext ?_; ext u`. Splits cleanly into 2 subgoals (`e_a.hC.a` constants, `e_a.hX` generator). `simp` chain hits `Possibly looping simp theorem` warning (`Scheme.ΓSpecIso.eq_1` + `Scheme.SpecΓIdentity_app`) then `maximum recursion depth` error.
- **Next-step recipe (recorded in task_result)**: pursue `IsOpenImmersion.lift_uniq` route — define `kbarChart1Ring := MvPolynomial.eval₂Hom(id, X() ↦ 1) ∘ homogeneousLocalizationAwayToMvPoly kbar 1` and prove `Spec.map(kbarChart1Ring) ≫ Proj.awayι X_1 = onePt.left` via `Proj.fromOfGlobalSections_morphismRestrict`. Or dispatch `mathlib-analogist` consult on `Proj.appIso` evaluation API.
- **Sorry trajectory**: 2 → 2.
- **Lemmas discovered**: `IsOpenImmersion.lift_app` (Mathlib `OpenImmersion.lean:696`); `Proj.basicOpenIsoSpec` / `basicOpenIsoAway` / `awayToSection` triangle; `Proj.fromOfGlobalSections_resLE` (Mathlib `Basic.lean:502`).

### Lane A.3.i — `Picard/IdentityComponent.lean` (PARTIAL — PUSH-BEYOND landed)

- **HARD BAR**: NOT MET. `geometricallyConnected_of_connected_of_section` axiom-clean was the target; Stacks 037Q substrate ("`X` connected and `k` algebraically closed in `Γ(X, 𝒪_X)` ⟹ `X` geometrically connected") is genuinely missing from Mathlib at `b80f227`. Helper NOT shipped as typed sorry (would inflate file 8 → 9 without enabling axiom-clean closures elsewhere). Intended signature + proof outline + Mathlib dependency chain documented in file comment block (L317-340).
- **PUSH-BEYOND**: 2 NEW axiom-clean instances + `baseChangeIso` partial closure:
  - `identityComponentCarrier_connectedSpace` (~L350): `Subtype.preconnectedSpace isPreconnected_connectedComponent` + explicit witness `identitySectionPoint G ∈ connectedComponent _`.
  - `identityComponent_connectedSpace` (~L370): transport from carrier via `change`-to-defeq + `infer_instance`.
  - `IdentityComponent.baseChangeIso` (~L447-474) PARTIAL: was 1 sorry covering 3 conjuncts; now 2 of 3 axiom-clean (`_grpInst : GrpObj G_K` via `CategoryTheory.Over.grpObjMkPullbackSnd` from `analogies/lane-a3i-isconnected-prod.md`; second conjunct similar).
- **Concrete next steps (recorded)**: (1) project-side Stacks 037Q `ConnectedCriterion.lean` (~30 LOC from iff-direction); (2) Stacks 04KS clopen-partition descent; (3) `[LocallyOfFiniteType (PicScheme C).hom]` instance.
- **Sorry trajectory**: 8 → 8.

### Lane I (WD) — `RiemannRoch/WeilDivisor.lean` (PARTIAL — CRITICAL signature finding)

- **HARD BAR**: NOT MET (Hartshorne II.6.9 body not closed) — structural reason below.
- **CRITICAL FINDING**: the iter-191 Lane I main theorem signature is MATHEMATICALLY FALSE as the iter-191 equation-form reshape:
  ```
  ∀ (t : K) (halg : algebraMap K K(C) t ≠ 0),
    degree (positivePart (principal (algebraMap K K(C) t) halg))
      = Module.finrank K(C) K(C)
  ```
  Counter-witness: `K = K(C)` (algebra map = id) + `t = 1`. Then `principal 1 halg = 0`, `positivePart 0 = 0`, `degree 0 = 0` — LHS = 0. RHS = `Module.finrank K(C) K(C) = 1`. `0 ≠ 1`.
- **Approach (Attempt 1, PARTIAL)**: new axiom-clean helper `degree_positivePart_eq_sum_max` (L519-530) reducing `degree (positivePart D)` to `D.sum (fun _ n => max n 0)` via `Finsupp.sum_mapRange_index`.
- **Approach (Attempt 2, PARTIAL)**: `rationalMap_order_finite_support` `f = 0` branch closed axiom-clean via direct computation (`WithZero.log 0 = 0`).
- **Approach (Attempt 3, PARTIAL)**: `degree_positivePart_principal_eq_finrank` body now applies the new helper to reduce to the explicit sum form, then documents the genuine gap in a 5-step recipe (per `analogies/ratcurveiso-pin2.md` Decision 2).
- **3 candidate correctives recorded for iter-193 plan-phase**:
  1. `(hlp : ∃ Y : C.left.PrimeDivisor, Ring.ordFrac _ (algebraMap K C.left.functionField t) = WithZero.coe (Multiplicative.ofAdd (-1 : ℤ)))` — most precise.
  2. `[IsLocalParameter (algebraMap K C.left.functionField t)]` — needs Mathlib upstream.
  3. Existential bundle matching consumer pattern in `RationalCurveIso.lean:560-562`.
- **Sorry trajectory**: 3 → 3.

### Lane RCI — `RiemannRoch/RationalCurveIso.lean` (PARTIAL — incremental scaffold)

- **HARD BAR**: NOT MET. The PROGRESS.md item 9 framing ("close the 1 remaining sorry by consuming the public pin") is misaligned with file state — the public-pin consumption is already wired up in `Hom.poleDivisor_degree_eq_finrank` (L559-562, `unfold` + `exact Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank ...`). The remaining sorry is `iso_of_degree_one` (Pin 3 Step 2) — the deep "lift function-field iso to scheme iso" gap, standing deferral target since iter-177+.
- **PUSH-BEYOND attempts**:
  - Attempt 1: Mathlib infrastructure scan for shorter paths. FAILED — no 30-50 LOC shortcut exists; closest available is `Scheme.Hom.instIsIsoToNormalizationOfIsIntegralHom` (Stacks 03GP) requiring sub-step (a) (`IsAffineHom φ.left`).
  - Attempt 2 (LANDED): add `haveI : LocallyOfFiniteType φ.left := IsProper.toLocallyOfFiniteType` instance (first half of `IsFinite φ.left`, available without new infrastructure). Sub-step (a) residual narrowed to `IsAffineHom φ.left` only.
  - Attempt 3 (NOT pursued): carve sub-task (a) as named typed-sorry helper. Helper budget 1 → 2 cap; adding 1 helper still leaves the main sorry. File metric would worsen 1 → 2.
- **Recommendation for plan (in task_result)**: iter-193 helper budget to 3; carve sub-tasks (a)/(c)/(d) explicitly. Or escalate to `mathlib-analogist` cross-domain-inspiration consult for Hartshorne I.6.12.
- **Sorry trajectory**: 1 → 1.

### Lane GmScaling — `Genus0BaseObjects/GmScaling.lean` (ERROR — API socket close mid-session)

- **Outcome**: prover session ended at 16:45:24Z (29 minutes in-session, 83 turns, ~12.9M cache-read tokens) with `summary: "API Error: The socket connection was closed unexpectedly"`. No `task_results/AlgebraicJacobian_Genus0BaseObjects_GmScaling.lean.md` written. No edit committed.
- **In-session state at termination**: deep Mathlib search around `AlgebraicGeometry.Proj.SpecMap_awayMap_awayι` chain (`lean_declaration_file` errored on missing `file_path` arg; pivoted to Bash grep of `ProjectiveSpectrum/Basic.lean`).
- **meta.json status**: `error`.
- **File at HEAD**: 2 sorries (unchanged from iter-191).
- **Iter-193 action**: redispatch with narrower directive — break the chart-bridge cross01 closure into 2 narrower lanes (range-containment + sectional-extraction). The 80-LOC budget wall pattern on this lane has held for 4+ iters; a single long session is not the right tactic.

## Key findings / patterns discovered (this iter)

### Reusable Proof Patterns (added to PROJECT_STATUS.md)

1. **Prime-avoidance via `Ideal.subset_union_prime_finite` + `hIH`-rewriting on a fresh witness `x'` avoiding all minimal primes**, plus Nakayama (`Submodule.FG.eq_bot_of_le_jacobson_smul`) + `IsDomain.of_bot_isPrime` + `Ideal.minimalPrimes_eq_subsingleton_self` for direct Stacks 00NQ-style "regular local ⟹ domain" closure inside an induction hypothesis. The key insight is that the IH is universally quantified in the ring `R'`, so we can apply it to `R/(x')` for ANY admissible `x'`, not just the specific `x` in the goal.
2. **Aliasing-`set y` (not `let y`) for instance scope + `change`-to-Y-side-action + `rw [Scheme.Modules.map_smul]` + the key identity `(ΓSpecIso _).inv ≫ (hU.fromSpec.appIso ⊤).inv ≫ Y.presheaf.map _ = 𝟙`** is the canonical recipe for closing `pullback_of_openImmersion_iso_restrict`-style restrict-iso-pullback module isomorphisms on `Scheme.Modules`. Sub-key identity `hU.fromSpec.appLE U ⊤ e₀ = (ΓSpecIso Γ(Y, U)).inv` collapses via `simp [Scheme.Hom.appLE, hU.fromSpec_app_self, ← Functor.map_comp]` (internally collapsing `eqToHom ≫ homOfLE` poset arrow through `Functor.map_id`).
3. **`private` in Lean 4 controls VISIBILITY, not NAMESPACE REGISTRATION**: a `private theorem Foo.bar` registers `Foo.bar` in the environment at fully-qualified name. Cannot share a name with an imported `Foo.bar`. The remediation when an iter-N file-local placeholder + iter-(N+1) public version collide: delete the private placeholder entirely; replace with `/-! docstring -/` block explaining the sourcing.
4. **`HasInjectiveDimensionLT.subsingleton` + `Abelian.Ext.covariant_sequence_exact₁` + `Abelian.Ext.addEquiv₀`** is the abelian-category `Ext^1` vanishing recipe given a SES with injective middle + Hom-surjectivity. 3-step proof chain: `Ext X S.X₂ 1` subsingleton ⟹ `x₁.comp (mk₀ S.f) = 0` ⟹ lift via connecting morphism to `x₃ ∈ Ext X S.X₃ 0` ⟹ `addEquiv₀` to a Hom — discharged by surjectivity hypothesis.
5. **`KaehlerDifferential.isLocalizedModule_map` + `Module.free_of_isLocalizedModule`** is the in-body chain to deduce `Module.Free (stalk z) Ω[(stalk z)⁄Γ(Spec _, U)]` from `Algebra.IsStandardSmooth Γ(Spec _, U) Γ(X.left, V)` + `IsLocalization.AtPrime`. Stage-5 substrate for the Smooth ⟹ IsRegularLocalRing chain.
6. **`Subtype.preconnectedSpace isPreconnected_connectedComponent` + explicit witness** is the clean `ConnectedSpace ↥{ p // p ∈ connectedComponent x }` recipe; transport via `change`-to-defeq + `infer_instance` gives the carrier-level `ConnectedSpace` instance for `(IdentityComponent G).left`.
7. **`degree (positivePart D) = D.sum (fun _ n => max n 0)` via `Finsupp.sum_mapRange_index`** with `(h := fun _ b => b)` and `by intro _; rfl` — the canonical structural reduction for positivePart-degree-of-Finsupp computations. Reusable for any Hartshorne II.6.10 / Riemann-Roch-style "sum-of-positive-orders" computation.

### Known Blockers (added to PROJECT_STATUS.md)

8. **`Scheme.WeilDivisor.degree_positivePart_principal_eq_finrank` is MATHEMATICALLY FALSE as the iter-191 equation-form reshape** — for arbitrary `t : K`, the counter-witness `K = K(C), t = 1` gives LHS = 0, RHS = 1. Needs an explicit local-parameter hypothesis (3 candidate shapes recorded).
9. **The "route (iii) Krull-intersection `y = x^m · z` then `x^{m+1} · z̄ = 0`" sketch in `notMem_minimalPrimes_of_regularLocal_succ` docstring (iter-191 KB entry) DOES NOT WORK** — `x̄ = 0` in `R/(x)` makes `x^{m+1} · z̄ = 0` trivially true regardless of `z̄`, yielding no contradiction. The successful closure used prime-avoidance instead.

## Blueprint markers updated (manual)

- `RiemannRoch_WeilDivisor.tex`, `lem:degree_positivePart_principal_eq_finrank`: added `% NOTE (iter-192 review)` annotation documenting the iter-191 Lean signature is mathematically false-as-stated for arbitrary `t : K` (counter-witness recorded), listing the 3 candidate correctives for iter-193 plan-phase, and cross-referencing the iter-189 Known Blockers entry on `Hom.poleDivisor_degree_eq_finrank`.

No `\mathlibok` additions this iter (no new Mathlib-backed declarations).
No `\lean{...}` rename surfaced.
No stale `\notready` removal needed.

## Recommendations for next session

See `recommendations.md` in this directory.

## Files touched (this session, by review agent)

- `.archon/iter/iter-192/review.md` (this iter's sidecar)
- `.archon/proof-journal/sessions/session_192/{summary,milestones,recommendations}.md`
- `.archon/PROJECT_STATUS.md` (Knowledge Base update)
- `blueprint/src/chapters/RiemannRoch_WeilDivisor.tex` (`% NOTE` annotation)
- `.archon/TO_USER.md` (banner reset)
