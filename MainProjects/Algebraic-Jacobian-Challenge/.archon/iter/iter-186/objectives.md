# Iter-186 prover objectives — per-lane detailed prompts

(Lane order = alphabetical-by-file, matching the planValidate selection
order to avoid attrition.)

## Lane E — `AlgebraicJacobian/AbelianVarietyRigidity.lean`

**Verdict pickup**: iter-185 PARTIAL — sub-task (f) sorry pushed deeper
via privacy-bypass iso-chain reconstruction; `ext_of_isAffine`
reduction landed a concrete appTop ring-map equation residual at
**L382 / L396**.

**iter-186 target**: Close the appTop ring-map equation residual at
L382 / L396 to take sub-task (f)
`iotaGm_chart1_composition_isOpenImmersion` closer to Tier-1.

**Recipe** (per iter-185 review's PROJECT_STATUS update):
1. `Spec.map(f).appTop = (ΓSpecIso _).inv ≫ CommRingCat.ofHom f ≫
   (ΓSpecIso _).hom` (`Spec.map_appTop` or equivalent simp lemma).
2. Each `pullbackSpecIso/_Symmetry/_RightPullbackFstIso.hom.appTop`
   reduces via the corresponding Mathlib appTop simp lemma OR via
   `pullbackSpecIso.inv_naturality` after `pullback.hom_ext`.
3. `pullback.lift.appTop` distributes via `pullback.lift_appTop`.
4. Final ring-map identity via `MvPolynomial.algHom_ext`.

Alternative (cleaner; requires structural-refactor permission): drop
`private` on `gmScalingP1_cover_X_iso` and `gmScalingP1_chart_PLB_eq`
in `GmScaling.lean` (1-line visibility change). Direct unfold path
then closes via the same simp chain.

**Helper budget**: 1.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated
`% archon:covers …`).

**Stop criteria**: sub-task (f) residual closes (sorry decrement) OR
the appTop chain elaborates but lands on a fresh narrow residual
documented as Tier-3 named typed-sorry.

## Lane G — `AlgebraicJacobian/Albanese/AuslanderBuchsbaum.lean`

**Verdict pickup**: iter-185 PIVOT PARTIAL —
`regularLocal_inductive_step` body is an axiom-clean 6-step scaffold
ending in a single technical bookkeeping sorry at **L1008 / L1094**
(comment-expansion drift). Cheapest sorry-close iter-186 per
`recommendations.md` HIGH item 2.

**iter-186 target**: Close + extract to named helper the L1008/L1094
`R⧸(x)` bridge inline sorry. Estimated **~10-20 LOC pure bookkeeping**.

**Recipe**:
1. Build an `R⧸(x)`-linear equiv
   `(R ⧸ Ideal.span {x}) ≃ₗ[R⧸(x)] QuotSMulTop x R` via
   `Submodule.ideal_span_singleton_smul` + `Submodule.quotEquivOfEq`
   (R-linear).
2. Upgrade to `R⧸(x)`-linearity via `QuotSMulTop.mem_annihilator`
   (DVR ⟹ PID ⟹ closure under quotients).
3. Extract the inline sorry into a NAMED helper
   `Module.QuotSMulTop_quotEquiv_quotIdeal_singleton_linearEquiv` (or
   similar; pick a Mathlib-idiom-friendly name) above
   `regularLocal_inductive_step`.

**Outcome**: `regularLocal_inductive_step` becomes axiom-clean
transitively; file sorry **3 → 2**;
`exists_isRegular_of_regularLocal` transitively kernel-clean modulo
the new Helper 1 typed-sorry (which is iter-187+ work, not iter-186).

**Helper budget**: 1 (the extracted helper).

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex`.

## Lane M↓ — `AlgebraicJacobian/Albanese/CodimOneExtension.lean`

**Verdict pickup**: iter-185 plan-phase
`blueprint-writer codimone-stacks-00tt` landed
`lem:smooth_to_regular_local_ring` + `lem:mem_domain_partial_map_reshuffle`
chapter blocks at L189-231. iter-186 plan-phase
`blueprint-reviewer iter186` audits the patched chapter.

**iter-186 GATE**: dispatch this lane ONLY IF the iter-186
blueprint-reviewer verdict for `Albanese_CodimOneExtension.tex` is
PASS or CONDITIONAL PASS without a NEW must-fix-this-iter on the
chapter. If reviewer fails the chapter, defer this lane to iter-187.

**iter-186 target** (if GATE clears): re-open the `IsRegularLocalRing`
half of `hreg_dim` (Stacks 00TT gap). Body work uses the new
`lem:smooth_to_regular_local_ring` block as the proof grounding +
Mathlib's `Algebra.Smooth` + `IsRegularLocalRing` typeclasses.

**Recipe** (per the new chapter block's 4-Mathlib-hook derivation
sketch):
1. `Algebra.FormallySmooth` instance on the structure morphism.
2. Cotangent-complex side of `Algebra.Smooth` ⟹ regularity at
   closed points of finite residue field.
3. Closed-point specialisation via the chain-of-primes argument
   (`localisation-preserves-regularity` chain).
4. Conclude `IsRegularLocalRing (X.presheaf.stalk z)` for each
   `z ∈ X`.

The chapter block notes `[IsAlgClosed kbar]` is load-bearing — keep
the class hypothesis.

**Helper budget**: 2.

**Acceptable outcome**: ≥1 substantive Mathlib step closes
axiom-clean; remaining as named typed-sorry helpers
(`smooth_implies_formally_smooth_at_closed_point`,
`cotangent_complex_regularity`, etc.).

**Blueprint**: `chapters/Albanese_CodimOneExtension.tex`.

## Lane B — `AlgebraicJacobian/Genus0BaseObjects/GmScaling.lean`

**Verdict pickup**: iter-185 PARTIAL (5-iter CHURNING confirmed) —
prover surfaced directive conflict (helper budget = 0 vs Recipe 2
needs 2 new private simp lemmas). iter-186 plan-phase
`blueprint-writer gmscaling-chart-agreement-expansion` MUST-FIX
dispatched; planner picks **budget-relax** path
per `recommendations.md` HIGH item 1 "preferred".

**iter-186 target**: Execute Recipes 2 + 3 per
`analogies/gmscaling-projection-idiom.md`:

- **Recipe 2** — add 2 named projection lemmas
  `gmScalingP1_cover_intersection_X_iso_inv_fst` /
  `gmScalingP1_cover_intersection_X_iso_inv_snd` as
  `@[reassoc (attr := simp)]`, each proved by `pullback.hom_ext`
  against the relevant projection (NOT via `Iso.inv_comp_eq` /
  `Iso.trans_inv` — those don't fire against the tactic-elaborated
  iso form, as documented in the expanded chapter sketch
  paragraph II).
- **Recipe 3** — apply Recipe 2's lemmas to close
  `gmScalingP1_chart_agreement_cross01` via
  `cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv` +
  projection-lemma rewrites + the `Iso.trans_inv` chain.

**Sorry decrement gate**: file sorries **4 → ≤3 MANDATORY** this iter.

**Helper budget**: +2 (the 2 new projection lemmas; this is the
budget RELAX from iter-185's "0"). Reusable simp-tagged
infrastructure for downstream chart-bridge work, NOT lane-specific
noise.

**Failure mode**: if sorry count stays 4 iter-186, iter-187 plan-phase
opens the genus-0 separated-locus alternative (Recipe III.c from the
expanded chapter sketch); chart-bridge cross-case work pauses.

**GATE**: dispatch this lane ONLY IF
`blueprint-writer gmscaling-chart-agreement-expansion` lands cleanly
(check `task_results/blueprint-writer-gmscaling-chart-agreement-expansion.md`
for the writer's report). If writer fails, defer Lane B to iter-187.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (consolidated
`% archon:covers …`).

## NEW lane IdentityComponent — `AlgebraicJacobian/Picard/IdentityComponent.lean`

**Verdict pickup**: iter-185 SUCCESS file-skeleton (5/5 pins resolve);
iter-186 plan-phase `blueprint-writer identitycomponent-split` (Path B)
dispatched to address 2 MUST-FIX-THIS-ITER findings.

**iter-186 GATE**: dispatch this lane ONLY IF the Path B split lands
AND the iter-186 blueprint-reviewer verdict on
`Picard_IdentityComponent.tex` is PASS or CONDITIONAL PASS post-split.
If split fails or chapter still flagged, defer to iter-187.

**iter-186 target** (if GATE clears): cheapest body candidate per
`recommendations.md` MEDIUM item 7 —
`AlgebraicGeometry.GroupScheme.IdentityComponent` def body via
`Scheme.openSubscheme` of a topological-connected-component carrier.

**Recipe**:
1. Construct the underlying `Set` carrier as the connected component
   of `|G|` containing the image of the identity section
   `e : Spec k → G`.
2. Verify the `Set` is open (locally Noetherian topological space ⟹
   connected components are open; EGA I 6.1.9).
3. Lift to a `Scheme.openSubscheme` via the open-subscheme structure.
4. Repackage as an `Over (Spec (.of k))` object via the structure
   morphism.

The post-split chapter pin for `IdentityComponent` covers ONLY
Kleiman lem:agps(3) conclusion (a); the body produces a Lean term
of that type (a `k`-scheme + clopen inclusion data) — matching the
existing Lean signature.

**Helper budget**: 1.

**Stretch goal**: Verify the connected-component carrier is well-defined
(non-empty containing `e`) as a separate axiom-clean private lemma.

**Acceptable outcome**: ≥1 substantive step closes; remaining as
named typed-sorries.

**Blueprint**: `chapters/Picard_IdentityComponent.tex` (post Path B
split).

## NEW lane A.1.b — `AlgebraicJacobian/Picard/LineBundlePullback.lean`

**Verdict pickup**: UNBLOCKED by iter-185 Lane D HARD-BAR SUCCESS
(A.1.a body-level work declared functionally complete).

**iter-186 target**: First body attempt on the skeleton's 5 typed
sorries. Per STRATEGY.md `A.1.b — LineBundlePullback`: ~200-400 LOC
remaining (~50/it realized velocity). Verify
`archon-protected.yaml` for any signature pin BEFORE editing.

**Recipe** (initial attempt, no prior body experience this lane):
1. Read the skeleton's 5 typed sorries; identify which is the
   structural-spine declaration (likely an
   `Over.lineBundlePullback`-style functor) vs. which are
   derived lemmas.
2. Attempt the structural spine first (sheaf-of-modules pullback
   instance + line-bundle predicate-preservation).
3. Use `analogies/kaehler-tensorequiv-presheafpullback.md` and
   adjacent pullback / functoriality analogies as starting points.
4. Reuse the A.1.a `RelativeSpec` body's `IsAffineOpen.map_fromSpec`
   recipe where applicable.

**Helper budget**: 2.

**Acceptable outcome**: ≥1 substantive step closes; remaining as
named typed-sorries with documented sub-task structure. Body-substance
test — flips lane from gated to active.

**Blueprint**: `chapters/Picard_LineBundlePullback.tex`.

## Lane F — `AlgebraicJacobian/Picard/QuotScheme.lean`

**Verdict pickup**: iter-185 PARTIAL substantive — 2 new private
helpers (`pullback_app_isoTensor_unitAtV` axiom-clean +
`pullback_app_isoTensor_isBaseChange` named typed-sorry packaging
Stacks 02KE with 4-step plan). Consumer iso assembly sorry-free.

**iter-186 target**: Per `recommendations.md` MEDIUM item 8 — Step 2
of `pullback_app_isoTensor_isBaseChange` (~30-50 LOC):

- Identify `Γ((pushforward g).obj N, V) = Γ(N, g ⁻¹ᵁ V)` via
  `pushforward_obj_obj` (rfl).
- Restrict via `((pullback g).obj N).presheaf.map (homOfLE e).op`.
- Prove `Γ(X, V)`-linearity via
  `Y.presheaf.map (homOfLE e).op ∘ g.app V = g.appLE V U e`.

**Stretch goal**: Step 4 — `IsBaseChange.equiv` (~80-150 LOC
project-side tilde + pullback compatibility lemma + ~15-25 LOC
consumer cleanup via rfl-bridge). Closes the consumer's BC inline
sorry.

**Helper budget**: 2.

**Acceptable outcome**: ≥1 step closes. Does NOT flip to CHURNING if
helper budget consumed productively.

**Blueprint**: `chapters/Picard_QuotScheme.tex` — note the iter-186
plan-phase added 4 new `\lean{...}` pins (`canonicalBaseChangeMap`,
`_app_app_isIso`, `_isIso`, `Scheme.Modules.pullback_app_isoTensor`)
in `\subsection{Project-side base-change substrate}`.

## Lane A — `AlgebraicJacobian/RiemannRoch/OCofP.lean`

**Verdict pickup**: iter-185 DEFERRED (CHURNING corrective). iter-186
plan-phase `refactor ocofp-carrierset-submodule-recipe` dispatched to
execute the 5-step recipe from
`analogies/ocofp-carrierset-submodule-api.md`.

**iter-186 GATE**: dispatch this lane ONLY IF the refactor agent
lands cleanly (check
`task_results/refactor-ocofp-carrierset-submodule-recipe.md`). If
refactor reports `Notes for Plan Agent` blockers, defer to iter-187.

**iter-186 target** (if GATE clears): fill bookkeeping `sorry`s left
by the refactor inside the closure proofs (Steps 2-4 of the recipe).
Specifically:

- `carrierSubmodule.add_mem'` — close the `Ring.ordFrac_add`
  + `WithZero.log` monotonicity bookkeeping for the non-zero case.
- `carrierSubmodule.smul_mem'` — close the `Ring.ordFrac_of_isUnit`
  application for `c ≠ 0`.
- `presheaf_isSheaf` — after `rw [Presheaf.isSheaf_iff_isSheaf_forget …]`,
  close the Type-valued sheaf-property check via
  `IsIntegral C.left → IrreducibleSpace C.left.toTopCat` and density
  of nonempty opens.

**Helper budget**: 1 (extracting any inline bookkeeping that lands as
a reusable lemma).

**Acceptable outcome**: ≥1 inline `sorry` closes axiom-clean;
remaining as Tier-3 named helpers documented inline.

**Blueprint**: `chapters/RiemannRoch_OCofP.tex`.

## Lane H — `AlgebraicJacobian/RiemannRoch/RRFormula.lean`

**Verdict pickup**: iter-185 SUCCESS + PARTIAL —
`finrank_H0_toModuleKSheaf_eq_one` Tier-1 axiom-clean (~50 LOC
H⁰-bridge); `eulerCharacteristic_sheafOf_succ` consumer sorry-free
assembly mod NEW named typed-sorry helper
`eulerCharacteristic_of_shortExact_skyscraper`.

**iter-186 target**: Close `eulerCharacteristic_of_shortExact_skyscraper`
helper body via Mathlib's `Abelian.Ext.covariantSequence`
specialisation per `recommendations.md` MEDIUM item 6.

**Recipe**:
1. Specialise `Abelian.Ext.covariantSequence` to `X = constantSheaf k̄`
   (which is `ModuleCat.{u} kbar`-valued and on the Zariski site).
2. Recover the H⁰ → H¹ LES.
3. Plumb the SES → χ-additivity via Mathlib's
   `CategoryTheory.ShortExact.eulerChar_additive` (if present) or
   scaffold a project-side bridge.

**Helper budget**: 2.

**Stop criteria**: helper body closes (file sorry **1 → 0**;
`thm:euler_char_eq_deg_plus_one_minus_genus` transitively
kernel-clean). **SLIPPING throughput**: 10 of 12 iters elapsed —
failure to close iter-186 = OVER_BUDGET trigger.

**Blueprint**: `chapters/RiemannRoch_RRFormula.tex`. iter-185 review
flagged an iter-186 chapter touch: add `\lean{...}` pin for the new
helper `Scheme.eulerCharacteristic_of_shortExact_skyscraper` (5b
chapter task). Defer chapter touch to iter-187 plan-phase to keep
iter-186 focused on the body close.

## Lane I — `AlgebraicJacobian/RiemannRoch/RationalCurveIso.lean`

**Verdict pickup**: iter-185 BLOCKED (server-side 529 outage).
**DO NOT escalate Route 2d** — iter-183 breakthrough intact.

**iter-186 target**: Re-fire iter-185 directive VERBATIM. Close
`Hom.poleDivisor_degree_eq_finrank` body L321 (~80-150 LOC) via
`Ideal.sum_ramification_inertia` per `analogies/ratcurveiso-pin2.md`
Decision 2.

**Recipe**:
1. Pick affine open `Spec A ⊂ ℙ¹` containing `∞`.
2. Preimage `Spec B ⊂ C` finite over `Spec A`.
3. Both are Dedekind extensions.
4. `Σ_Q e(Q|P) · f(Q|P) = [Frac B : Frac A] = [K(C) : K(ℙ¹)]`.

Pin 3 body L482 and `Hom.poleDivisor` body iter-187+ separately.

**Helper budget**: 3.

**Acceptable outcome**: ≥1 substantive step closes; the
`Ideal.sum_ramification_inertia` chain elaborates.

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex`.

## Deferred files (no dispatch this iter)

- `AlgebraicJacobian/Picard/RelativeSpec.lean` — 0 sorries (Lane D
  SOLVED iter-185 HARD-BAR SUCCESS). A.1.a phase functionally
  complete at body-level. Signature-drift watchlist (UniversalProperty,
  affine_base_iff, base_change, functor) remains deferred iter-200+.
- `AlgebraicJacobian/RiemannRoch/OcOfD.lean` — substantive general
  `sheafOf` body is iter-200+ Hartshorne II.7 substrate. iter-186
  monitors the OcOfD value-pinning forecasting bet per lean-auditor
  watch-item.
- All standing deferrals from iter-185 PROGRESS.md `## Standing
  deferrals` — unchanged.

## Cross-lane reminders for all provers

- **NO new project axioms** under any circumstance. 6 consecutive
  zero-axiom builds; this is the project's hard floor.
- **NO `sorry` retreats** — only typed `sorry`s with documented Tier
  classification (Tier-1 axiom-clean, Tier-2 kernel-clean-mod-X,
  Tier-3 inline bookkeeping).
- **Verify Mathlib lemma names** at the pinned commit before relying
  on them; the project uses commit **b80f227** for cross-references.
- **Check protected signatures** in `archon-protected.yaml` before
  editing any declaration you don't recognize.
- **Read `/- USER: ... -/` comments** in your assigned file before
  starting; the user may have left hints.
