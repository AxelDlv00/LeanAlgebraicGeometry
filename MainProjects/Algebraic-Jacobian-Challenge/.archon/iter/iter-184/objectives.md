# Iter-184 prover lane objectives (detailed)

Per-lane work plan. PROGRESS.md `## Current Objectives` carries the
file list; this file holds the prover-facing details.

## Lane B — `Genus0BaseObjects/GmScaling.lean` (CHURNING corrective; LANE FIRES)

**Status entering**: 4 sorries; 5-iter CHURNING confirmed (progress-critic
route184) → consult-armed iter-184.

**Consult outcome** (`mathlib-analogist gmscaling-projection-idiom`,
delivered iter-184 plan-phase): **BUILD_PROJECT_HELPER** (critical) +
PROCEED on the other 2 sub-questions. Persistent recipe at
`analogies/gmscaling-projection-idiom.md`. Total estimated ~95-130
LOC across 3 sub-recipes.

**Target sorry**: L382 `gmScalingP1_chart_agreement_cross01` cocycle
body (the residual after iter-183's `cancel_epi` lift).

**Recipe** (3 sub-recipes, in order):

**Recipe 1 — BUILD_PROJECT_HELPER (load-bearing simp helpers)**:
Add 2 `@[reassoc (attr := simp)]` lemmas at the top of the file
(near other simp-set imports):
```lean
@[reassoc (attr := simp)]
lemma pullback_map_fst_proj {C : Type*} [Category C] {W X Y Z S T : C}
    (f₁ : W ⟶ S) (f₂ : X ⟶ S) [Limits.HasPullback f₁ f₂] (g₁ : Y ⟶ T)
    (g₂ : Z ⟶ T) [Limits.HasPullback g₁ g₂] (i₁ : W ⟶ Y) (i₂ : X ⟶ Z) (i₃ : S ⟶ T)
    (eq₁ : f₁ ≫ i₃ = i₁ ≫ g₁) (eq₂ : f₂ ≫ i₃ = i₂ ≫ g₂) :
    Limits.pullback.map f₁ f₂ g₁ g₂ i₁ i₂ i₃ eq₁ eq₂ ≫
        Limits.pullback.fst g₁ g₂ =
      Limits.pullback.fst f₁ f₂ ≫ i₁ :=
  Limits.pullback.lift_fst _ _ _
```
plus the mirror `pullback_map_snd_proj`. These close the
missing-Mathlib-simp gap that was the root cause of the 5-iter
CHURNING. (~8 LOC total.)

**Recipe 2 — 2 named projection lemmas**:
```
gmScalingP1_cover_intersection_X_iso_inv_fst (kbar) :
  iso.inv ≫ pullback.fst = <chart-side composition>
gmScalingP1_cover_intersection_X_iso_inv_snd (kbar) :
  iso.inv ≫ pullback.snd = <chart-side composition>
```
Proven via simp chain using Recipe-1 helpers + existing Mathlib simp
set: `pullbackRightPullbackFstIso_inv_*`,
`pullbackLeftPullbackSndIso_inv_*`,
`pullbackSymmetry_inv_comp_*`, `Proj.pullbackAwayιIso_inv_*` —
all already `@[reassoc (attr := simp)]`. (~30-45 LOC each.)

**Recipe 3 — cocycle body closure**:
After Recipe 2 lemmas land, close `gmScalingP1_chart_agreement_cross01`
body L382:
- `apply (cancel_epi (gmScalingP1_cover_intersection_X_iso kbar).inv).mp`
  (the lift step retained from iter-183).
- `simp only [..., gmScalingP1_cover_intersection_X_iso_inv_fst,
  gmScalingP1_cover_intersection_X_iso_inv_snd, ...]` collapses both
  sides to the shared `Spec ((Away (X 0 · X 1)) ⊗ GmRing) ⟶ Proj 𝒜`
  form.
- `rw [← Proj.SpecMap_awayMap_awayι.symm, ← Proj.SpecMap_awayMap_awayι.symm]`
  to factor both sides through `Proj.awayι (X 0 · X 1)`.
- `apply (cancel_mono (Proj.awayι (X 0 · X 1) _ _)).mp`
- `rw [← Spec.map_comp, ← Spec.map_comp]; congr 1`
  to reduce to ring-level equality.
- `MvPolynomial.algHom_ext` or `eval₂Hom`-style ring-equality closure
  using `IsLocalization.Away.mul_invSelf` for the `t · u = 1`
  residual.
(~10-20 LOC for Recipe 3 closure.)

**Helper budget**: 4 (2 Recipe-1 + 2 Recipe-2).

**Acceptable outcome**: sorry count 4 → 3 (Recipe-1 helpers axiom-clean
Tier-1; Recipe-2 named lemmas axiom-clean Tier-1 or Tier-2; cross01
body closes Tier-2 modulo the new simp lemmas). FAILURE = iter-185
opens separated-locus alternative.

## Lane E — `AbelianVarietyRigidity.lean`

**Status entering**: 3 sorries (post-iter-183 decomposition).

**Critic mandate (CHURNING corrective)**: HARD BAR — close sub-task (b)
`iotaGm_onePt_chart1_factor` AXIOM-CLEAN this iter. DROP sub-task (f)
this iter (decomposition cadence triggered CHURNING; the 2→3 sorry
delta iter-183 means residual is rising while helpers accumulate).

**Target sorry**: L105 `iotaGm_onePt_chart1_factor` — the
`IsOpenImmersion.lift` factorisation that reduces to range
containment `Set.range onePt.left ⊆ Set.range (Proj.awayι (X 1) _)`.

**Recipe** (per iter-183 task_result iter-184+ closure path,
~10-15 LOC):
1. `Proj.opensRange_awayι` identifies range as `(D₊(X 1) : Set _)`.
2. `Proj.fromOfGlobalSections_preimage_basicOpen` identifies the
   preimage of `D₊(X 1)` under `onePt.left = fromOfGlobalSections _ _ _`
   with `(Spec k̄).basicOpen (evalIntoGlobal v (X 1))`.
3. `(Spec k̄).basicOpen 1 = ⊤` closes (`evalIntoGlobal v (X 1) = 1`
   for `v = ![1, 0]` — the `onePt` vector at chart 1).

**Helper budget**: 0 (HARD RULE: NO new sub-helpers; close inline
or in an existing helper file).

**Acceptable outcome**: sub-task (b) closes axiom-clean; file sorry
count 3 → 2 (−1). Failure to close axiom-clean = report PARTIAL;
do NOT spawn a new sub-helper to defer.

## Lane G — `Albanese/AuslanderBuchsbaum.lean`

**Status entering**: 3 sorries (CONVERGING per progress-critic).

**Targets**:
1. Close the 2 named residual sorries on `depth_eq_smallest_ext_index`
   inductive step (forward direction + backward Step 3). Use the
   iter-183 axiom-clean helpers (`ext_smul_eq_zero_of_mem_annihilator`,
   `natCast_add_one_le_of_le_sub_one`).
2. After 1, attempt `auslander_buchsbaum_formula` L326 (the
   headline theorem) — ~30-60 LOC assembly via
   `depth_eq_smallest_ext_index` + `projDim`-equivalence reformulation
   per Stacks 00LF.

**Helper budget**: 2 (one per `depth_eq_smallest_ext_index` residual
if structural; one for `auslander_buchsbaum_formula` if needed).

**Off-target**: `exists_isRegular_of_regularLocal` L562 (standing
deferral; reachable iter-185+ once `auslander_buchsbaum_formula` body
gives the depth=Krull-dim equality).

## Lane M downstream — `Albanese/CodimOneExtension.lean` (NEW narrow consumer)

**Status entering**: 3 sorries (file unchanged iter-180→183;
fresh narrow consumer task built on iter-183's axiom-clean
`Albanese/CoheightBridge.lean`).

**Target sorry**: L242-243 `hreg_dim : IsRegularLocalRing (stalk z) ∧
ringKrullDim (stalk z) = 1`.

**Recipe** (~20-40 LOC):
1. Split the conjunction into two `refine ⟨_, _⟩` goals.
2. Krull-dim half (`ringKrullDim (stalk z) = 1`): close via the new
   instance `ringKrullDimLE_of_coheight_eq_one` from
   `Albanese/CoheightBridge.lean` plus `Ring.KrullDimLE.le_one` /
   `ringKrullDim_eq_of_KrullDimLE` (whichever matches the iso pattern).
   Per iter-183 CoheightBridge task_result, the instance is directly
   `coheight z = 1 → Ring.KrullDimLE 1 (stalk z)`; the eq=1 specialisation
   uses `not_zero` (from `not_isField_stalk_codim_one`) to upgrade
   `≤ 1` to `= 1`.
3. `IsRegularLocalRing` half: leave as direct sorry with comment
   "Stacks 00TT gap — see CoheightBridge.lean header; iter-185+ work".

**Helper budget**: 1 (the `ringKrullDim = 1` upgrade may need a tiny
witness lemma if the equality form isn't directly synthesised by the
new instance).

**Acceptable outcome**: residual splits from a 2-part conjunction
sorry into a 1-part `IsRegularLocalRing` sorry (file sorry count
3 → 3 inside-the-declaration sites; the 2-part conjunction body
becomes a structured proof with one closed and one residual).

## Lane D — `Picard/RelativeSpec.lean` (CHURNING + OVER_BUDGET corrective)

**Status entering**: 2 sorries (iter-183 5-helper structured proof
landed; bare sorry replaced by 3 axiom-clean + 2 Tier-3 helpers).

**Critic mandate (CHURNING + OVER_BUDGET)**: STRATEGY.md row revised
plan-phase (`Iters left ~3–6`; ~100–250 LOC remaining). Commit to
closing BOTH Tier-3 helpers iter-184; if not, iter-185 escalates to
blueprint expansion / structural refactor.

**Targets**:
1. L494 `pullback_cocone` naturality — the structural unfolding of
   `(relativeGluingData _).functor.map` to `Spec.map (P.presheaf.map _)`
   form. Per iter-183 task_result: requires transparency unfolds
   beyond `respectTransparency false`; once unfolded,
   `IsAffineOpen.map_fromSpec` closes.
2. L583 `pullback_iso_desc_isIso` per-piece factorisation — the
   per-U `IsIso (desc ∣_ q⁻¹U.1)` check via the explicit 3-iso
   factorisation: `hPre = desc⁻¹(q⁻¹U.1) = (colimit.ι d.functor U).opensRange`,
   then `isoOpensRange` to `d.functor.obj U`, then
   `(pullback_iso_affine_piece).symm` to `(q⁻¹U.1).toScheme`.

**Helper budget**: 2 (one per Tier-3 helper if structural; budget can
be 0 if direct closure).

**Acceptable outcome**: both Tier-3 helpers close axiom-clean (Tier-1);
file sorry count 2 → 0; A.1.a phase ENTERS "BODY COMPLETE" state.
Failure → iter-185 structural refactor escalation.

## Lane F — `Picard/QuotScheme.lean` (UNCLEAR; one more iter without body substance → CHURNING)

**Status entering**: 9 sorries (iter-183 PIVOT: load-bearing typed-sorry
def `Scheme.Modules.pullback_app_isoTensor` L480 added; consumer body
structured with BC inline sorry).

**Target sorry**: L480 `Scheme.Modules.pullback_app_isoTensor` BODY
(currently `letI ... ; exact sorry`).

**Recipe** (per iter-182 analogist consult, ~120-200 LOC, partial):
1. Reduce to the affine case (`U` affine) — the def's signature
   already restricts to affine `U` + `V`.
2. On `Spec Γ(X, V)`, identify `tilde N` via `Tilde.isoTop`
   (`AlgebraicGeometry.Modules.Tilde.isoTop`: `Γ(tilde N, ⊤) = N`).
3. The base-change identification `(pullback g).obj (tilde N) ≅ tilde
   (Γ(Y, U) ⊗_{Γ(X, V)} N)` at Spec rings, then promoted to the
   general affine open in `Y` via the relative-affine functor.
4. Close the LinearEquiv via `IsBaseChange.equiv` after constructing
   the `IsBaseChange` from `Module.Flat.isBaseChange`.

**Acceptable outcome**: partial body (~80-120 LOC) landing one
substantive step (e.g. Step 2 alone — the `Tilde.isoTop` identification)
+ remaining steps as named typed-sorry helpers. ≥1 body close from
the recipe; do not just add typed-sorry decomposition.

**Helper budget**: 2 (named tilde-identification helpers if substantive
step decomposition is needed).

## Lane A — `RiemannRoch/OCofP.lean` (CHURNING corrective per progress-critic)

**Status entering**: 7 sorries (iter-183 sig amend + `carrierSet` scaffold).

**Critic mandate (CHURNING — 3 of 3 dispatched iters PARTIAL with flat
sorry count, helpers accumulating)**: HARD BAR — close at least ONE
existing body sorry this iter, NOT add more typed sorries for
`carrierSet → Submodule` upgrade. The `Submodule` upgrade is acceptable
ONLY if it closes one of the downstream `globalSections_iff_mp` /
`globalSections_iff_mpr` / `globalSections_iff` consumer bodies.

**Targets** (in priority order):
1. `dim_eq_two_of_genusZero` body — downstream of sheaf-property pin;
   the sheaf-property pin can stay typed-sorry but the dim equality
   may close via `genus C = 0 ⟹ H¹ = 0` rewriting + `H⁰_via_iff` if
   that pin has substance enough. ~20-40 LOC try.
2. `globalSections_iff_mp` body — once `carrierSet → Submodule` upgrade
   gives a proper `Submodule` carrier, the iff `mp` direction may close
   via `Submodule.mem_iff` + the order-condition characterisation.
3. `carrierSet → Submodule` upgrade as a SEPARATE typed-sorry def (if
   needed for the above) — but ONLY if 1 or 2 closes.

**Helper budget**: 2 (one for the Submodule upgrade; one for the closure).

**Acceptable outcome**: sorry count ≤ 7 (no regression) AND ≥1 body
closes; sorry count > 7 = FAILED iter, escalate to blueprint expansion
(the OCofP chapter under-specifies the proof; the writer needs to
spell out the exact API the body needs).

## Lane K — `RiemannRoch/OcOfD.lean` (UNCLEAR; fresh)

**Status entering**: 4 sorries (NEW file iter-183 file-skeleton; all
Tier-3 typed sorries).

**Target sorry**: L150 `sheafOf_zero` body — `sheafOf 0 = toModuleKSheaf C`.

**Recipe** (~30-60 LOC):
- Unfold `sheafOf` at `0 : C.left.WeilDivisor` (the zero Finsupp);
  the order conditions become "all `ord_Q(f) ≥ 0` for finitely-many
  Q" which on `0` Finsupp means "always satisfied" → carrier =
  the structure sheaf.
- Identify the resulting sheaf with `Scheme.toModuleKSheaf C` via
  sheaf hom from the equal underlying `Set`-carriers.
- `Sheaf.ext` to reduce to per-stalk / per-section equality.

**Off-target this lane**:
- `sheafOf` BODY (the def itself; substantive Hartshorne II.7 content
  iter-185+).
- `sheafOf_singlePoint` body gated on `lineBundleAtClosedPoint` having
  substance (Lane A iter-185+).
- `sheafOf_ses_single_add` body gated on `sheafOf` body.

**Helper budget**: 2.

**Acceptable outcome**: `sheafOf_zero` body lands (axiom-clean or
Tier-2 modulo `sheafOf` typed def); file sorry count 4 → 3. If
`sheafOf_zero` requires substantive `sheafOf` content, report PARTIAL
with explicit decomposition.

## Lane H — `RiemannRoch/RRFormula.lean` (CONVERGING)

**Status entering**: 2 sorries (iter-183 Tier-3 helpers
`Scheme.finrank_H0_toModuleKSheaf_eq_one` L231 +
`Scheme.eulerCharacteristic_sheafOf_succ` L258).

**Targets**:
1. Helper A `finrank_H0_toModuleKSheaf_eq_one`: close via the
   `Cohomology_StructureSheafModuleK` H⁰-bridge — the constant-sheaf-Γ
   adjunction (`Carriers.lean` or similar) gives `H⁰(C, O_C) = k` for
   geometrically irreducible curves; `finrank = 1` follows.
   ~20-40 LOC. Check Mathlib `AlgebraicGeometry.Scheme.HModule_def`
   or local `Cohomology/StructureSheafModuleK.lean` for the bridge.
2. Helper B `eulerCharacteristic_sheafOf_succ`: close via
   `OcOfD.sheafOf_ses_single_add` (typed-sorry from Lane K) +
   χ-additivity on the SES.
   - Mathlib gap check: `CategoryTheory.ShortExact.eulerChar_additive`
     — if absent, scaffold as a 1-helper project lemma; if present,
     direct close. (Search via `lean_local_search "ShortExact.euler"`
     or `lean_loogle "ShortExact, eulerChar"`.)
   - Combined with `χ(skyscraper P k) = 1` (Hartshorne III.5 / Stacks
     03F3-style result).

**Helper budget**: 2.

**Acceptable outcome**: helper A closes axiom-clean or Tier-2;
helper B closes Tier-2 (modulo `sheafOf_ses_single_add`); file sorry
count 2 → 0 or 2 → 1 (best/realistic).

## Lane I — `RiemannRoch/RationalCurveIso.lean` (UNCLEAR; if miss iter-184, escalate)

**Status entering**: 3 sorries (iter-183 Pin 2 wrapper body LANDED;
`Hom.poleDivisor_degree_eq_finrank` L321 typed sorry; `Hom.poleDivisor`
L290 typed-sorry def).

**Critic mandate**: one more iter without body substance flips this to
CHURNING. Pin 2 helper body MUST land iter-184.

**Target sorry**: L321 `Hom.poleDivisor_degree_eq_finrank` body —
the degree identity `deg (poleDivisor φ) = [K(C) : K(ℙ¹)]`.

**Recipe** (per `analogies/ratcurveiso-pin2.md` Decision 2, ~80-150 LOC):
1. Pick an affine open `Spec A ⊂ ℙ¹` containing `∞`; preimage
   `Spec B ⊂ C` is finite over `Spec A` (non-constancy +
   smooth proper curves ⟹ finite).
2. Both `A → B` are Dedekind extensions.
3. `Ideal.sum_ramification_inertia`:
   `Σ_{Q above P} e(Q|P) · f(Q|P) = [Frac B : Frac A] = [K(C) : K(ℙ¹)]`.
4. Identify the LHS with the pole-divisor degree (Hartshorne II.6.9
   specialised to Dedekind bases) — degree of `poleDivisor φ`
   computed pointwise = sum of `e(Q|∞)` over poles `Q`, which by
   step 3 equals `[K(C) : K(ℙ¹)]`.

**Off-target this lane**:
- `Hom.poleDivisor` def body L290 (iter-185+).
- `iso_of_degree_one` Pin 3 body L482 (iter-185+ via
  `analogies/ratcurveiso-pin3.md`).

**Helper budget**: 3.

**Acceptable outcome**: Pin 2 helper body lands (Tier-1, Tier-2, or
substantive Tier-3); file sorry count 3 → 2 or 3 → 3 (Tier upgrade
without count change). FAILURE = critic-escalation iter-185.

## Dispatch order / parallelism notes

Provers fan out one per file (no inter-lane ordering required
within prover phase). Lane B is the only CONDITIONAL — finalized
after analogist returns. Lane K → Lane H import order is irrelevant
because Lane H already imports `OcOfD.lean` (iter-183 Edit 1) and
both files compile independently of body closures.
