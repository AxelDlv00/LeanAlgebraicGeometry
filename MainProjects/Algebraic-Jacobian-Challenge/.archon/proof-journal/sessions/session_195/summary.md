# Session 195 (iter-195) — Review summary

## Session metadata

- **Session number / iter**: 195.
- **Sorry count entering prover** (per iter-194 review close): **88**.
- **Sorry count exiting prover** (this iter close): **87**
  (counted from `lake build AlgebraicJacobian` `declaration uses 'sorry'` warnings
  — verified `wc -l = 87`).
- **Net delta**: **−1** (88 → 87).
- **Axioms**: 0 → 0 — **15th consecutive zero-axiom build streak**.
- **Build status**: GREEN (8361/8361 jobs replayed).
- **Plan-predicted band**: best 88 → ~76-80 (−8 to −12); realistic 88 → ~81-85
  (−3 to −7); worst 88 → ~85-88 (0 to −3). Landing **87** sits at the
  **worst-case lower bound** (worst minus 1). The dispatch was 8 lanes, but
  **2 of 8 lanes (BareScheme, AbelianVarietyRigidity) ERRORED on API 529
  Overloaded mid-session with NO edits committed** — Lane BareScheme after
  ~25 min of substantive Mathlib scouting, Lane AVR after ~3.5 min before any
  meaningful action.

  The 2 errored lanes were the two highest-leverage scheduled closures of the
  iter: BareScheme closure was meant to cascade-unblock Lane I
  (`instIsRegularInCodimOneProjectiveLineBar`) and Lane RCI helper (a); Lane E
  ANALOGUE-driven close was the analogist-confirmed `Proj.awayι_app_basicOpen`
  recipe expected to close 1-2 sorries in `AbelianVarietyRigidity.lean`. With
  both errored, the realistic-band lower-bound was unreachable.

## Targets attempted (8 lanes)

| Lane | File | Status | Δ sorries | HARD BAR | PUSH-BEYOND |
|---|---|---|---|---|---|
| H | RiemannRoch/H1Vanishing.lean | **SOLVED (closure)** | 4 → 3 (−1) | **MET (axiom-clean closure)** | Not met (substrate-gap on `IsFlasque.injective_flasque` Tier-3) |
| BareScheme | Genus0BaseObjects/BareScheme.lean | **ERROR (API 529)** | 4 → 4 | NOT MET | NOT MET |
| E | AbelianVarietyRigidity.lean | **ERROR (API 529)** | 3 → 3 | NOT MET | NOT MET |
| I | RiemannRoch/WeilDivisor.lean | PARTIAL | 4 → 4 | **MET** (new kernel-clean Finsupp helper + 3-step body push) | Not met (Mathlib gap on `Hom.ofFunctionFieldEmbedding`) |
| F | Picard/QuotScheme.lean | PARTIAL | 12 → 12 | NOT MET (Stage 1 of 6 axiom-clean inline; (N1)-(N4) named gaps) | Not met |
| A | RiemannRoch/OCofP.lean | PARTIAL | 3 → 3 | **MET** (6 axiom-clean substeps on L1323 substrate helper) | Not met |
| RCI | RiemannRoch/RationalCurveIso.lean | PARTIAL | 3 → 3 | NOT MET (1:1 inline → named-helper swap; structural lift only) | N/A (scoped) |
| G | Albanese/AuslanderBuchsbaum.lean | PARTIAL | 1 → 1 | **MET** (n=k+1 inductive step carved into typed helper) | Not met (OFF-CRITICAL-PATH per plan) |

**4 of 8 HARD BARs met (H, I, A, G); 2 lanes errored on API; 2 NOT MET (F, RCI).**
**1 closure (Lane H `Scheme.IsFlasque.shortExact_app_surjective`).**

## Per-target details

### Lane H — `Scheme.IsFlasque.shortExact_app_surjective` (CLOSURE)

- **Entry state**: residual typeclass-shaped goal `SAb.Exact` at former L462,
  where `SAb := S.map (sheafCompose J (forget₂ ModuleCat AddCommGrpCat))`.
  `Mono SAb.f` + `Epi SAb.g` were axiom-clean inline since iter-194; the
  `SAb.Exact` final piece had been STUCK 3 consecutive iters under the
  "another helper round" wall.
- **Helper used (1/2 budget)**: NEW instance
  `sheafCompose_preservesFiniteLimits` (~L340) — `PreservesFiniteLimits
  (sheafCompose J F)` for any `F : A ⥤ B` between abelian categories with
  finite limits when `F` preserves finite limits and `J.HasSheafCompose F`.
  Factors through `sheafToPresheaf J B` faithful-and-reflects-iso bridge:
  `sheafCompose J F ⋙ sheafToPresheaf J B = sheafToPresheaf J A ⋙
  (whiskeringRight _ _ _).obj F` (by `rfl`), then transport via
  `preservesFiniteLimits_of_reflects_of_preserves`.
- **Closure technique**: invoke
  `Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono` (Mathlib
  abelian-category exactness preservation lemma). The `.1` projection of the
  forward direction gives `(S.map Fforget).Exact = SAb.Exact` directly from
  `PreservesFiniteLimits (sheafCompose J (forget₂ _ _))` + `S.ShortExact`.
- **Result**: axiom-clean closure. `lean_verify` confirms
  `[propext, Classical.choice, Quot.sound]` (kernel only).
- **Substantive insight**: the iter-194 plan's "Route A: `(sheafCompose J
  (forget₂ _ _)).PreservesHomology` via forget₂ preserves finite limits +
  colimits + lift through sheafCompose" was OVERSHOT. For `S.ShortExact`
  *inputs*, only the LEFT half (PreservesFiniteLimits) of preservation is
  needed — the `_iff_forall_exact_map_and_mono` lemma packages exactness
  preservation on SES directly from the limit-preservation side. Avoids the
  substantial PreservesFiniteColimits + PreservesSheafification machinery.

#### Why PUSH-BEYOND not achieved

`HModule_flasque_eq_zero` consumes the now-axiom-clean
`shortExact_app_surjective`, but its body still routes through
`IsFlasque.injective_flasque` (Hartshorne III Lemma 2.4) at L572 — a typed
sorry requiring the `j_!` extension-by-zero functor for sheaves of modules
which Mathlib `b80f227` does not ship (~100-150 LOC project-side substrate
build). This is a separate Tier-3 substrate gap unrelated to the iter-195
Lane H critical-path objective.

### Lane BareScheme — `projectiveLineBar_smoothOfRelDim` + `projectiveLineBar_geomIrred` (ERROR)

- **Entry state**: 2 scaffold sorries blocking Lane I cascade. iter-195
  plan-phase landed blueprint coverage via fastpath
  (`AbelianVarietyRigidity.tex:951-993`); HARD GATE cleared.
- **Session shape**: prover ran 25 min, did extensive Mathlib scouting
  (`AlgebraicGeometry.Smooth.exists_isStandardSmooth`, `RingHom.Locally`,
  `RingHom.IsStandardSmoothOfRelativeDimension`, `Proj.awayι_toSpecZero`).
  Was building toward `IsStandardSmoothOfRelativeDimension 1` lift via the
  `D₊(X 0)` / `D₊(X 1)` chart cover; ~140 turns of API exploration. **No
  edit committed** — terminated by API 529 Overloaded.
- **No fault of the prover**; transient external infrastructure failure.

### Lane E — `AbelianVarietyRigidity.lean` ANALOGUE-DRIVEN (ERROR)

- **Entry state**: 3 sorries; plan dispatched per analogist-confirmed
  `Proj.awayι_app_basicOpen` recipe documented in
  `analogies/lane-e-proj-appiso-pivot.md`. 3 helper budget; expected closure
  of ≥1 of (`kbarChart1Ring_specMap_fac` / `iotaGm_chart1_appIso_eval`).
- **Session shape**: terminated at ~3.5 min, 1 session turn, by API 529
  Overloaded. **No edit committed**.
- **No fault of the prover**; transient external infrastructure failure. The
  ANALOGUE remains viable for iter-196 re-dispatch.

### Lane I — `WeilDivisor.lean` substrate cleanup (PARTIAL with HARD BAR met)

- **Entry state**: 4 sorries; primary objective was
  `instIsRegularInCodimOneProjectiveLineBar` (gated on BareScheme cascade);
  unconditional fallback was body push on
  `degree_positivePart_principal_eq_finrank`.
- **NEW kernel-clean generic Finsupp helper** at L684-709:
  ```
  Finsupp.sum_max_zero_eq_sum_filter_pos {α : Type*} (D : α →₀ ℤ) :
    D.sum (fun _ n => max n 0) =
      ∑ a ∈ D.support.filter (fun a => 0 < D a), D a
  ```
  ~10 LOC via `Finsupp.sum` ↦ `Finset.sum_filter`-with-`if` + `Finset.sum_congr`
  to match `max (D a) 0 = if 0 < D a then D a else 0` via `omega`. Reusable.
- **Body push on `degree_positivePart_principal_eq_finrank` (3 sub-steps)**:
  Steps A (`degree_positivePart_eq_sum_max`) + B (new helper) + C
  (per-Y bridge via `principal_apply`) reduce the goal to the canonical
  Hartshorne II.6.9 starting form:
  `∑ Y ∈ supp ∩ {0 < order Y (algMap t)}, order Y (algMap t) =
   (Module.finrank K(ℙ¹) K(C) : ℤ)`.
- **`instIsRegularInCodimOneProjectiveLineBar` body opened** with `refine ⟨fun
  Y => ?_⟩`; the per-prime-divisor obligation is now exposed.
- **Substrate findings** (REPORT TO PLAN AGENT, repeated in
  `recommendations.md`):
  1. No `Smooth ⟹ IsRegularLocalRing` stalk bridge in Mathlib `b80f227`.
     **Recommendation**: pursue affine-chart Route 2 (via `Spec(k̄[t])` PID)
     instead of the full Smooth chain — ~50-80 LOC vs ~200-300 LOC.
  2. No `Hom.ofFunctionFieldEmbedding` constructor (reconfirmed; iter-194
     analogist `lane-a3i-stacks-04kv` already flagged NEEDS_MATHLIB_GAP_FILL).
  3. No `Order.coheight` ↔ `Ring.KrullDimLE 1` bridge for scheme stalks.

### Lane F — `QuotScheme.lean` Beck-Chevalley (PARTIAL, HARD BAR NOT MET)

- **Entry state**: 12 sorries; primary objective was Beck-Chevalley
  intertwining at `pullback_app_isoTensor_baseMap_sectionLinearEquiv` body
  consuming the iter-195 plan-phase Σ-pair refactor identities `_step1_apply`
  + `_step2_apply`.
- **Stage 1 axiom-clean `have`** landed inside the body (~L999-1080):
  `have stage1 := _step2_apply x` giving the ⊤-section identity.
- **Stages 2-6 documented as (N1)-(N4) named substrate gaps**:
  (N1) `baseMap` naturality (~20-30 LOC); (N2) `baseMap` compatibility with
  `pullbackComp` (~30-40 LOC); (N3) `baseMap` compatibility with
  `pullbackCongr` (~10-20 LOC); (N4) `step3` inversion identity (~20-30 LOC).
  Total iter-196 substrate ~100-150 LOC.
- **CRITICAL revision to plan-phase estimate**: the plan's "USING the new
  identities, ~10-30 LOC" was too optimistic. Realistic estimate is ~100-150
  LOC over 4 named substrate helpers — the Σ-pair refactor closed Stages
  1+2 but Stages 3+4+5 each require a `pullbackComp`/`pullbackCongr`
  naturality + baseMap-composition rule that is genuinely missing from both
  Mathlib AND the project.
- **Dead-end warning**: writing Stages 2-6 inline as `have ... := sorry` with
  explicit type signatures FAILS due to `Γ(X, V) : CommRingCat / Ab`
  notation ambiguity in fresh `have`-type position; works inside
  `_step2_apply` only because the function signature there fixes the reading.
  Workaround: chain stages without explicit types using
  `Iso.inv_hom_id_apply` + `_step1_apply`. Also: `set ΓNV := ...` renames
  step1/step2 (breaking `hom_inv_id`); avoid `set` rebinding inside this body.

### Lane A — `OCofP.lean` substrate helpers (PARTIAL with HARD BAR met)

- **Entry state**: 3 sorries (L1147 cascade target, L1209 χ-arithmetic
  blocked on OcOfD substrate, L1323 linear-algebra helper).
- **L1323 `exists_nonconstant_rational_from_dim_eq_two`**: 6 axiom-clean
  sub-steps landed (~50 LOC):
  1. `htF_zero : toFunctionField 0 = 0` via
     `simp only [toFunctionField, map_zero, Functor.map_zero]; rfl`.
  2. `htF_smul`, `htF_add` (kbar-linearity of `toFunctionField`).
  3. `hs₁_ne : s₁ ≠ 0` from `toFunctionField s₁ = 1` + `htF_zero`.
  4. `Module.Finite kbar H⁰` via `Module.finite_of_finrank_pos`.
  5. `finrank kbar (span kbar {s₁}) = 1` via `finrank_span_singleton`.
  6. Extract `s : H⁰` with `s ∉ span kbar {s₁}` via
     `Submodule.exists_of_finrank_lt 1 < 2`. Define
     `f := toFunctionField s` as candidate non-constant rational function.
- **Remaining residual**: 3 mathematical sub-claims documented —
  (a) `f ≠ 0` via `Function.Injective toFunctionField` (LinearEquiv chain
  packaging, ~30-50 LOC); (b) mechanical `globalSections_iff_mpr`; (c)
  Stacks 02P0 (`principal f = 0 ⟹ f ∈ kbar^×` on complete geom-irred curve).
- **L1209 NOT TOUCHED** per directive (substrate-blocked on
  `OcOfD.lean` STRUCTURALLY BLOCKED state).
- **L1147 NOT TOUCHED** (cascade target on Lane H landing; Lane H closure
  did land but `HModule_flasque_eq_zero` body remains gated by
  `injective_flasque` Tier-3 substrate).

### Lane RCI — `?hLPUnif` structural lift (PARTIAL, HARD BAR NOT MET strictly)

- **Entry state**: 3 typed sorries; primary objective was axiom-clean close
  of `?hLPUnif` (uniformiser witness for `localParameterAtInfty kbar`).
- **Tactic-level closure attempts FAILED**: `Classical.arbitrary _`
  (no `Nonempty (ProjectiveLineBar kbar).left.PrimeDivisor` instance);
  `tauto` cannot produce existential witness; `exact?` returns nothing.
  No Mathlib lemma in `b80f227` supplies the uniformiser witness for
  `Proj k̄[X₀,X₁]`.
- **Structural lift landed**: file-private helper
  `localParameterAtInfty_uniformiser_witness` at L463 with typed sorry +
  3-step closure path documented in docstring
  (witness via `Proj.basicOpenIsoAway` chart; order via DVR uniformiser at
  the chart; uniqueness via opposite-pole at `D₊(X 0)`). Consumer
  `Hom.poleDivisor_degree_eq_finrank` body is now sorry-free; delegates via
  `exact localParameterAtInfty_uniformiser_witness kbar`.
- **Net sorry count unchanged** (1:1 inline → named-helper swap).
- **HARD BAR strictly NOT MET** (was "axiom-clean closure" not "structural
  lift"); the swap is a no-regression structural advance suitable for
  iter-196 targeted close.

### Lane G — n=k+1 carving (PARTIAL with HARD BAR met)

- **Entry state**: 1 sorry (inline at the n=k+1 inductive step of
  `auslander_buchsbaum_formula`).
- **Carving**: NEW private helper `auslander_buchsbaum_formula_succ_pd`
  (L1106-1124) consuming the precise hypothesis surface for the n=k+1
  step (`Module.projectiveDimension R M = (k+1 : WithBot ℕ∞)`). Main
  theorem's n=k+1 branch dispatches via `exact
  auslander_buchsbaum_formula_succ_pd k _hpd`.
- **iter-196+ re-engagement plan** in the helper's docstring: 4-piece
  ordering (depth-drops-by-one → minimal-resolution carving → snake-lemma
  → "what is exact"; total ~350-500 LOC across iters 196-200+).
- **Per directive Option (b) carving** = HARD BAR MET; net sorry count
  unchanged.

## Key findings / patterns discovered

### NEW reusable patterns (iter-195)

1. **`Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono` packages
   SES-exactness preservation directly from LEFT-half limit preservation**:
   for proving `(S.map F).Exact` given `S.ShortExact` and `F` additive
   between abelian categories, you do NOT need full
   `Functor.PreservesHomology` (i.e. both limits AND colimits). The Mathlib
   iff lemma says: `PreservesFiniteLimits F ↔ ∀ S.ShortExact, (S.map F).Exact
   ∧ Mono (F.map S.f)`. The `.1` projection gives exactness directly. This
   cuts the substrate work for any "SES is preserved by a (sheaf-level)
   functor" obligation. Iter-195 instance: closed Lane H final residual via
   1 new instance (`sheafCompose_preservesFiniteLimits`) instead of the
   plan's anticipated 50-100 LOC PreservesHomology chain.

2. **`sheafCompose_preservesFiniteLimits` (factor through faithful-and-
   reflects `sheafToPresheaf`)** as a structural recipe: when proving
   `PreservesFiniteLimits (sheafCompose J F)` for an arbitrary `F : A ⥤ B`
   between abelian categories preserving finite limits, use that
   `sheafCompose J F ⋙ sheafToPresheaf J B = sheafToPresheaf J A ⋙
   (whiskeringRight _ _ _).obj F` (by `rfl`), get
   `PreservesFiniteLimits` on the RHS via
   `whiskeringRight_preservesLimitsOfShape` + `sheafToPresheaf` preserves
   finite limits, then transport back via
   `preservesFiniteLimits_of_reflects_of_preserves` (using that
   `sheafToPresheaf J B` is fully faithful and hence reflects isomorphisms).
   Reusable for any `sheafCompose`-derived preservation argument.

3. **Generic `Finsupp.sum_max_zero_eq_sum_filter_pos`** kernel-clean: for any
   `D : α →₀ ℤ`, `D.sum (fun _ n => max n 0) =
   ∑ a ∈ D.support.filter (fun a => 0 < D a), D a`. ~10 LOC via
   `Finset.sum_filter` + per-term match via `omega`. Reusable as a generic
   Finsupp lemma — no scheme content. Could be Mathlib upstream PR
   candidate.

4. **6-step linear-algebra extraction recipe from `Module.finrank kbar V = 2`
   to a non-constant section**: when `dim_eq_two_of_genusZero` exposes
   `_hdim : Module.finrank kbar H⁰ = 2` with a distinguished constant `s₁`
   satisfying `toFunctionField s₁ = 1`, the chain to extract a "different"
   section `s` is: (i) prove kbar-linearity of `toFunctionField` via three
   one-liners (`htF_zero`, `htF_smul`, `htF_add`) using `simp only
   [toFunctionField, map_zero, Functor.map_zero]; rfl` (the `Functor.map_zero`
   simp lemma is load-bearing); (ii) `hs₁_ne : s₁ ≠ 0` from
   `htF_zero` + `toFunctionField s₁ = 1` + `one_ne_zero`; (iii) `Module.Finite
   kbar H⁰` via `Module.finite_of_finrank_pos`; (iv) `finrank kbar (span kbar
   {s₁}) = 1` via `finrank_span_singleton hs₁_ne`; (v)
   `Submodule.exists_of_finrank_lt 1 < 2` extracts the wanted `s` with
   `s ∉ span kbar {s₁}`. Reusable for any "extract non-trivial vector outside
   a span" argument from a finrank-gap.

5. **Structural lift via named file-private helper preserves no-regression
   on net sorry count when the body is substrate-blocked**: when an inline
   `?hyp` sorry inside a consumer body is genuinely substrate-blocked
   (witness construction requires multi-step Mathlib gap fill), the discipline
   is a 1:1 swap to a file-private typed-sorry helper with documented
   closure path. The structural improvement is real (substrate need now
   exposed at a single named declaration; iter-N+1 prover gets a focused
   target with documented recipe; consumer body is sorry-free at body
   level) without inflating the sorry count. Iter-195 instance:
   `localParameterAtInfty_uniformiser_witness` (RationalCurveIso.lean L463).

### Architectural / strategic findings

6. **API 529 Overloaded is a real failure mode for high-cost lanes**:
   Iter-195 lost the 2 highest-leverage lanes (BareScheme + Lane E) to API
   exhaustion mid-session. Neither committed any edits. The substrate
   exploration in Lane BareScheme (~140 turns over 25 min) was lost as
   working context. **Implication**: high-stakes lanes (~ones whose
   closure is meant to cascade-unblock 2-3 downstream lanes) should be
   given checkpoint-style intermediate commit budgets — at least
   preserve scouting findings as comments in the file even on
   API-failure.

7. **Plan-phase LOC estimates for compositional-closure lanes systematically
   undershoot**: Lane F's "USING new Σ-pair identities, ~10-30 LOC" was
   actually ~100-150 LOC of named substrate (N1-N4). The plan's identities
   closed Stage 1+2 but missed that Stages 3-5 require additional
   `pullbackComp`/`pullbackCongr` naturality chains. This is the second iter
   in a row Lane F has been mis-estimated. Iter-196 must commit to landing
   N1-N4 as named substrate helpers via the refactor subagent first, then
   send the prover.

8. **Lane RCI structural-lift is the canonical pattern when `?hyp` is
   substrate-blocked**: rather than reverting the iter-194 refactor's
   stronger `hLPUnif` signature, the structural-lift swap (inline → named
   helper) preserves the consumer's sorry-free body. The discipline is:
   when a refactor introduces a stronger signature whose `?hyp` is
   inevitably substrate-blocked, the canonical close is the 1:1 swap not
   tactic-experiments at the consumer.

## Subagent reports landed this phase

- `lean-auditor iter195` — **complete** (`task_results/lean-auditor-iter195.md`,
  1177s, 43 files audited). **3 must-fix-this-iter findings** (all canonical
  `:= sorry`/sorry-instance carriers propagating `sorryAx` silently through
  typeclass synthesis): `WeilDivisor.lean:746` (instance), `Thm32RationalMapExtension.lean:194`
  (in-proof `haveI`), `AlbaneseUP.lean:183` (`bundle := sorry` def projecting to 4
  instances). 7 major, 6 minor, 7 excuse-comments. Iter-195 edits themselves
  classified as *clean and well-carved* — the 3 must-fix items are pre-iter-195
  substrate state. Findings written to top of `recommendations.md` as CRITICAL
  section with iter-194 IC.lean-template fix recipes.

## Blueprint markers updated (manual)

(See per-file recommendations from prover task_results in
`recommendations.md`.) No `\mathlibok` / `\lean{...}` corrections were
needed this iter. No stale `\notready` removed (the deterministic
`sync_leanok` ran iter=195 with 12 added / 3 removed across 4 chapters:
`Albanese_AuslanderBuchsbaum.tex`, `RiemannRoch_H1Vanishing.tex`,
`RiemannRoch_OCofP.tex`, `RiemannRoch_RationalCurveIso.tex`).

## Blueprint doctor findings

`blueprint-doctor` report at
`.archon/logs/iter-195/blueprint-doctor.md`: **no structural findings**
(every chapter `\input`'d by `content.tex`, every `\ref{...}` / `\uses{...}`
resolves to a defined `\label{...}`, no `axiom` declarations under
`.lean` files).

## Recommendations for the next session

See `recommendations.md`. Headlines:

- **CRITICAL**: re-dispatch the 2 errored lanes (BareScheme, Lane E
  ANALOGUE-driven) iter-196 — both lost to API 529, not to mathematical
  blockers. BareScheme cascade unlocks Lane I + Lane RCI helper (a).
- **HIGH**: Lane I `instIsRegularInCodimOneProjectiveLineBar` should pursue
  affine-chart Route 2 (via `Spec(k̄[t])` PID) instead of full
  Smooth chain — ~50-80 LOC vs ~200-300 LOC per prover report.
- **HIGH**: Lane F (Beck-Chevalley) commit to landing N1-N4 named substrate
  helpers via refactor subagent BEFORE next prover dispatch — plan-phase LOC
  estimate was off by ~5×.
- **MED**: iter-196 carrier-soundness refactor pull-forward (per iter-195
  plan-phase commitment).
