# Iter-188 Objectives Detail (per-lane work plan)

This document elaborates each lane's iter-188 directive. PROGRESS.md
`## Current Objectives` carries the dispatch-ready summary; this file
holds the per-lane detail.

## Lane A — `RiemannRoch/OCofP.lean` (RR.3)

**Target**: close `carrierPresheaf_isSheaf` body L409 (refactor Step 4
narrow named sorry). The sheaf condition reduces via
`Presheaf.isSheaf_iff_isSheaf_forget` to the `Type`-valued sheaf
condition for `U ↦ ↥(carrierSubmodule U)` (a sub-presheaf of the
constant `K(C)` sheaf on an irreducible scheme).

**Recipe**: explicit gluing argument:
1. Decompose the sheaf-condition goal into the equalizer:
   given matching sections `(s_i : ↥(carrierSubmodule(U_i)))` on a
   cover `(U_i ⊆ U)`, glue to a section `s : ↥(carrierSubmodule(U))`.
2. The underlying `K(C)`-value is uniquely determined since `K(C)` is
   constant on an irreducible scheme — pick any `s_i.val ∈ K(C)`.
3. Verify the order conditions on `U` by reading them off from each
   `U_i` (since `(U_i)` cover `U`, every point of `U` is in some `U_i`).
4. The carrier-conditions `Set` is the union/intersection appropriately;
   the proof is a finite case-check per point of `U`.

**Substrate present**: `Sheaf.IsSheaf.equalizer_presheaf_inclusion`,
`Subpresheaf.isSheaf_iff`, sub-presheaf gluing lemmas in Mathlib at
b80f227.

**Effort**: ~30-50 LOC axiom-clean. **Helper budget = 1**.
**HARD BAR**: ≥1 pre-existing sorry close iter-188.
**Blueprint**: `chapters/RiemannRoch_OCofP.tex` (PASS).

## Lane A.1.b — `Picard/LineBundlePullback.lean`

**Target**: close `IsLocallyTrivial.pullback` chart-iso L156 (the 1
named typed sorry remaining; affine-chart existence step already closed).

**Recipe**: 3-step Mathlib chain:
1. `restrictFunctorIsoPullback` — identify `restrict V.ι` with
   `pullback V.ι` along the open-immersion.
2. `pullbackComp` — identify `pullback V.ι ∘ pullback f` with
   `pullback (V.ι ≫ f)`; factor `V.ι ≫ f = g ≫ U.ι` for the
   restricted `g : V.toScheme ⟶ U.toScheme`.
3. `pullbackObjUnitToUnit` (from
   `Mathlib.Algebra.Category.ModuleCat.Sheaf.PullbackFree`) — identify
   `pullback g ∘ unit_U ≅ unit_V`. Requires `F.Final` instance on the
   underlying continuous functor; for open-immersion `g` this should
   be automatic.

**If `F.Final` instance not automatic**: project-side bridge ~5-10 LOC
to derive from open-immersion structure. Budget allows this.

**Effort**: ~30-50 LOC axiom-clean. **Helper budget = 2** (chart-chase
+ 1 open-immersion `F.Final` bridge if needed).
**Blueprint**: `chapters/Picard_LineBundlePullback.tex` (iter-188
plan-phase may add 2 chapter pins for `IsLocallyTrivial` +
`IsLocallyTrivial.pullback` per iter-187 prover recommendation).

## Lane F — `Picard/QuotScheme.lean`

**Target**: assemble section-level linearEquiv to close
`pullback_app_isoTensor_baseMap_isBaseChange` body via
`IsBaseChange.ofEquiv` route per iter-187 analogist Decision 4.

**Recipe** (per iter-187 prover task result § "Next step iter-188"):
1. Build section-level linearEquiv `Γ((pullback g).obj N, U) ≃ₗ[Γ(Y, U)]
   TensorProduct (Γ(Y, V)) (Γ(X, U)) (Γ(Y, V → N))` using:
   - `hV.isoSpec` / `hU.isoSpec` to transport between affine open and
     `Spec`-form.
   - `pullback_tildeIso` (already declared as named typed sorry) to
     identify `pullback (Spec.map φ) (tilde M)` with
     `tilde (TensorProduct A B M)`.
   - `tilde.isoTop` to evaluate at top open.
2. Verify the equiv intertwines `baseMap` with `TensorProduct.mk 1`
   (Beck-Chevalley compatibility check).
3. Apply `IsBaseChange.ofEquiv` ∘ `TensorProduct.isBaseChange`.

**Effort**: ~30-50 LOC route-stitching. **Helper budget = 2** (the
linearEquiv builder + the intertwining proof).

**`pullback_tildeIso` body** (Stacks 01HQ, ~115-200 LOC): stays
DEFERRED iter-189+ (sub-build via tilde-adjunction naturality).

**Acceptable outcome**: section-level linearEquiv built (axiom-clean);
`baseMap_isBaseChange` body closes IF the Beck-Chevalley check works,
otherwise PARTIAL acceptable.

**Blueprint**: `chapters/Picard_QuotScheme.tex` (iter-188 plan-phase
may add 2 chapter pins for `pullback_tildeIso` +
`pushforward_isQuasicoherent` per iter-187 recommendation).

## Lane IdentityComponent — `Picard/IdentityComponent.lean`

**Target**: close `identityComponent_locallyConnectedSpace` (private
helper L137) axiom-clean. EGA I 6.1.9 Mathlib gap.

**Recipe** (4-step classical argument documented in iter-187 prover's
helper docstring):
1. Apply `AlgebraicGeometry.LocallyOfFiniteType.isLocallyNoetherian`
   to get `IsLocallyNoetherian G.left`.
2. From `IsLocallyNoetherian`, get `NoetherianSpace G.left` (Mathlib
   bridge `IsLocallyNoetherian.NoetherianSpace`).
3. `NoetherianSpace` has finitely many irreducible components, hence
   finitely many connected components, hence each connected component
   is clopen.
4. Translate "each connected component is clopen" into
   `LocallyConnectedSpace.mk` basis form (standard topology argument).

**Effort**: ~80-100 LOC axiom-clean. **Helper budget = 2** (any
finite-irreducible-component lemma + topology bridge).
**Mathlib upstream candidate**: file as PR after closure.

**Closing this unblocks**:
- `identityComponentCarrier` body axiom-cleanness (transitively).
- `isOpenSubgroupScheme` closed-half axiom-cleanness (transitively).

**Acceptable outcome**: helper body axiom-clean OR ≤1 narrow named
typed sorry on a sub-step.

**Blueprint**: `chapters/Picard_IdentityComponent.tex` (PASS).

## Lane I — `RiemannRoch/RationalCurveIso.lean`

**Target**: close `localParameterAtInfty` (L304 substrate gap).

**Recipe** (4-step documented in iter-187 prover's helper docstring):
1. Pick the chart-1 affine open from
   `AlgebraicGeometry.projectiveLineBarAffineCover kbar`.
2. Construct the ratio coordinate `X₀ / X₁` as a
   `HomogeneousLocalization.Away (projectiveLineBarGrading kbar) (X 1)`
   element.
3. Embed via `germToFunctionField` on the chart's open.
4. Discharge the non-zero witness via injectivity of `germToFunctionField`
   (`AlgebraicGeometry.germ_injective_of_isIntegral`).

**Effort**: ~30-50 LOC axiom-clean. **Helper budget = 1**.

**Follow-up (iter-189+)**: with `localParameterAtInfty` axiom-clean,
attempt `Hom.poleDivisor_degree_eq_finrank` body (was circular-dep
blocked; now unblocked since `Hom.poleDivisor φ` unfolds to
`principal _`). Note: the iter-187 body choice gives `degree (principal
(φ^* t_∞)) = 0` by `Scheme.WeilDivisor.principal_degree_zero` once
available; the degree-via-finrank identification will need refinement
of either the body (positive-part of principal) or the helper signature
(read `(φ^* t_∞)_0` instead of full principal). Decision deferred.

**Pin 3 body** `iso_of_degree_one` L651 — orthogonal to Lane I primary;
can proceed in parallel iter-189.

**Blueprint**: `chapters/RiemannRoch_RationalCurveIso.tex` (PASS).

## Lane G — `Albanese/AuslanderBuchsbaum.lean` (sub-lane G1 close)

**Target**: close `finrank_cotangentSpace_quot_span_singleton_succ`
body (the 1 narrow named typed sorry on the spanFinrank-dim-drop
equation `(𝔪 (R/(x))).spanFinrank + 1 = (𝔪 R).spanFinrank`).

**Recipe** (per iter-187 prover task result § "iter-188+ next steps"):
- **(≥) direction** (lift-and-cons strategy, the easier half):
  Take a minimal generating set `S` of `𝔪 (R/(x))` of size `m`; lift
  to `T ⊆ 𝔪 R` via `Function.surjInv (Ideal.Quotient.mk_surjective)`;
  show `T ∪ {x}` generates `𝔪 R` (uses `(x) ⊆ 𝔪` and the lift's image
  property). Conclude `spanFinrank (𝔪 R) ≤ m + 1`.
- **(≤) direction** (Nakayama-extension strategy, the substantive
  ring-theoretic content):
  Take a minimal generating set of `𝔪 R` containing `x` (via Nakayama
  applied to `x ∉ 𝔪²`); show its image (minus `[x] = 0`) generates
  `𝔪 (R/(x))`. Conclude `spanFinrank (𝔪 (R/(x))) ≤ n - 1`.

**Substrate present at b80f227** (per iter-187 prover search log):
- `Ideal.toCotangent_eq_zero` (closing Helper 1.5 already).
- `IsLocalRing.spanFinrank_maximalIdeal_eq_finrank_cotangentSpace`.
- `Ideal.mapCotangent` + `Ideal.mapCotangent_surjective_of_comap_eq` +
  `Ideal.mapCotangent_ker_of_surjective`.
- `Submodule.finrank_quotient_add_finrank`.
- `finrank_span_singleton`.

**Effort**: ~100-150 LOC. **Helper budget = 2**.

**Sub-lane G2** (joint induction Stacks 00NQ, ~200 LOC): iter-189+
once G1 lands.

**Blueprint**: `chapters/Albanese_AuslanderBuchsbaum.tex` (PASS).

## Lane H — `RiemannRoch/RRFormula.lean` (post-chapter-clearance)

**Gate**: iter-188 mandatory `blueprint-reviewer iter188` clearance of
`RiemannRoch_RRFormula.tex` MF-1 fix (3 substrate pins + H⁰/H¹ split
landed iter-187 plan-phase via writer `rrformula-h0h1split`).

**Target on clearance**: close H⁰ half of
`eulerCharacteristic_skyscraperSheaf` via
`H0_skyscraperSheaf_finrank_eq_one` helper (chain:
`HModule_zero_linearEquiv` + `constantSheafGammaHom_linearEquiv` +
`SheafGammaObj_linearEquiv_top`).

**Effort**: ~30-60 LOC axiom-clean.

**H¹ half** indefinitely gated on Mathlib flasque-cohomology upstream;
do NOT target this iter.

**Blueprint**: `chapters/RiemannRoch_RRFormula.tex` (cleared per
iter-188 mandatory reviewer).

## Lane B — `Genus0BaseObjects/GmScaling.lean` (post-chapter-clearance)

**Gate**: iter-188 mandatory `blueprint-reviewer iter188` clearance of
`AbelianVarietyRigidity.tex` MF-2 fix ((III.c) MANDATORY PIVOT label +
expanded recipe landed iter-187 plan-phase via writer
`avr-iiic-pivot-label`).

**Target on clearance**: execute (III.c) separated-locus recipe per
writer's expanded sketch:
1. Build `Delta : P^1 → P^1 × P^1` via `prod.lift` (the diagonal).
2. Build the pair-morphism `(chart_0, chart_1) : intersection → P^1 × P^1`
   via `prod.lift`.
3. Show factorization through the diagonal via `IsClosedImmersion.lift`
   (which reduces to a discrete check: closed-point containment).
4. Reduce to two single-chart equalities via projection.

**Substrate present at b80f227**: `IsSeparated.diagonal_isClosedImmersion`,
`IsClosedImmersion.lift` + `_iff_range_subset`, `CategoryTheory.Limits.prod.lift`,
`pullback.lift`. Stacks 01KU ("Proj is separated") backs the diagonal.

**Effort**: ~80-120 LOC axiom-clean.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (cleared per
iter-188 mandatory reviewer).

## Lane E — `AbelianVarietyRigidity.lean` (post-chapter-clearance)

**Gate**: Same chapter as Lane B (`AbelianVarietyRigidity.tex` is
consolidated covering both files).

**Target on clearance**: execute 6-step appTop recipe per iter-186
progress-critic corrective:
1. Add helper `r_1_appTop_isLocElem_eq_one : r_1.appTop(isLocElem) = 1`
   in `kbar` via `cancel_mono` on `Proj.awayι` + `IsOpenImmersion.lift_appTop`
   chain (~10-15 LOC).
2. Telescope `comp_appTop` simp.
3. Telescope `ΓSpecIso_naturality` simp.
4. Telescope `pullbackSpecIso_inv_fst/snd` simp.
5. Telescope `pullback.lift_fst/snd` simp.
6. Discharge residual via the helper from Step 1.

**Effort**: ~30-50 LOC axiom-clean. **Helper budget = 1**.

**Blueprint**: `chapters/AbelianVarietyRigidity.tex` (cleared).

## Lane M↓ — COMPLETE-EXCEPT-UPSTREAM-GAP (Option c committed iter-188)

`Albanese/CodimOneExtension.lean` — **DO NOT DISPATCH** iter-188.

Per iter-188 progress-critic STUCK verdict with primary corrective
"force the deferral decision THIS iter, not iter-189": OPTION (c)
**COMMITTED** — accept the narrow named typed sorry
`isRegularLocalRing_stalk_of_smooth` (Stacks 00TT Mathlib gap on
Smooth → `IsRegularLocalRing`) as permanent until Mathlib upstream.

Downstream consumers (`smooth_codim_one_maximalIdeal_isPrincipal_and_ne_bot`,
`localRing_dvr_of_codim_one`) are axiom-clean modulo this single named
gap (iter-187 wrap landed). Lane M↓ declared complete-except-upstream-gap.

**STOP DISPATCHING** provers on `CodimOneExtension.lean` until Mathlib
upstream merges the smooth-→-regular bridge (or strategy reverses).

STRATEGY.md Open Q records the commitment. The 3 remaining sorries
(named regular-stalk helper + `extend_of_codimOneFree_of_smooth` body
+ `indeterminacy_pure_codim_one_into_grpScheme` Milne 3.3 body) are
all gated on substrate this iter cannot address.

## Lane J — DO NOT RETRY (structural BLOCK confirmed iter-187)

`RiemannRoch/OcOfD.lean` — Lane J DO NOT RETRY per iter-187 finding.
Empirical: kernel sorry-tracker propagates `else sorry` through every
closure tactic (6 tactics + 3 packaging restructurings tested); only
off-target `sheafOf` body (Hartshorne II.6, ~100-200 LOC) closes.
iter-188 plan-phase: do NOT dispatch a prover on Lane J. Future
commitment requires STRATEGY.md row addition for the Hartshorne II.6
sub-build, not planner-iter dispatch.
