# Iter-196 plan-phase recommendations (from iter-195 review)

## CRITICAL — lean-auditor iter195 must-fix-this-iter (3 findings)

Per `task_results/lean-auditor-iter195.md` whole-project audit (43 files,
3 must-fix / 7 major / 6 minor / 7 excuse-comments). All 3 must-fix are
the same canonical soundness pattern: **`:= sorry`/sorry-instance
carriers propagating `sorryAx` silently through typeclass synthesis**.
The project has precedent (iter-194 `IdentityComponent.lean:546-549`
demoted `private instance → private theorem` clearing the iter-193
auditor's parallel finding).

### 1. `WeilDivisor.lean:746-772` — `instance instIsRegularInCodimOneProjectiveLineBar`

- **Surface**: `instance instIsRegularInCodimOneProjectiveLineBar
  : Scheme.IsRegularInCodimensionOne (ProjectiveLineBar kbar).left := by
  refine ⟨fun Y => ?_⟩; sorry  -- iter-195 advance: body opened`.
- **Consumer**: `degree_positivePart_principal_eq_finrank` at L809
  (binder list includes `[Scheme.IsRegularInCodimensionOne
  (ProjectiveLineBar kbar).left]`); the iter-195 body push on the
  consumer's tactic chain now silently propagates `sorryAx` through
  this instance synthesis.
- **Iter-195 caused this exposure to GROW**: the consumer's body was
  advanced this iter (Steps A+B+C landed) WHILE the instance body
  remains sorry. The consumer was already gated on the instance, but
  the structural progress means more code is now silently sorry-aware.
- **Fix recipe (iter-196 plan-phase refactor)**: keyword swap `instance
  → theorem`. Rename `instIsRegularInCodimOneProjectiveLineBar →
  isRegularInCodimOneProjectiveLineBar` (drop the `inst` prefix). All
  consumers (currently only `degree_positivePart_principal_eq_finrank`)
  must be threaded explicitly via `haveI := isRegularInCodimOneProjectiveLineBar`
  at the start of the proof body. **Same pattern that worked
  iter-194 on `IdentityComponent.lean:500-567`**.
- **Iter-196 dispatch**: dedicate one refactor subagent slot
  (`wd-instregularcodim1-demotion`) with write_domain
  `AlgebraicJacobian/RiemannRoch/{WeilDivisor,RationalCurveIso,RRFormula}.lean`
  (RCI + RRF consume `Hom.poleDivisor_degree_eq_finrank` which consumes
  this instance transitively).

### 2. `Thm32RationalMapExtension.lean:194` — `haveI : IsReduced A.left := sorry`

- **Surface**: inside `av_isIntegral_of_smooth_geomIrred` (L168-195), the
  `haveI : IsReduced A.left := sorry` flows out via `exact
  isIntegral_of_irreducibleSpace_of_isReduced A.left` at L195. Body of
  the helper is otherwise axiom-clean — the entire conclusion of
  `av_isIntegral_of_smooth_geomIrred` is sorry-derived through one
  `haveI` line.
- **Fix recipe**: change `haveI` → named `have hreduced :
  IsReduced A.left := sorry`, then use `exact @isIntegral_... _
  _ _ hreduced`. Stacks 034V annotation at call site documents the gap
  surface. ~2-3 LOC change.
- **Iter-196 dispatch**: can be folded into the WD refactor's
  write_domain OR a fresh refactor subagent
  (`thm32-haveireduced-demotion`).

### 3. `AlbaneseUP.lean:183` — `noncomputable def bundle : Bundle C := sorry` + 4 instance projections

- **Surface**: `noncomputable def bundle : Bundle C := sorry` at L183;
  4 derived instances `instGrpObj`, `instIsProper`, `instSmooth`,
  `instGeomIrred` at L191-L201 project from `bundle.<field>`. The
  docstring L62-L80 documents dependency on A.3 chapter (multi-iter
  substrate); honest about being temporary but the **soundness
  exposure is silent** — every consumer of `jacobianScheme C`
  inherits `sorryAx` through any of the 4 instance queries.
- **Fix recipe**: convert the 4 instances to named lemmas
  (`def jacobianScheme_grpObj : GrpObj (jacobianScheme C) := bundle.grpObj`
  → equivalent but NOT an instance). Consumers must thread via
  `haveI := jacobianScheme_grpObj C`. The visible warning at the
  `bundle := sorry` carrier remains but no longer flows silently.
- **Iter-196 dispatch**: dedicated refactor subagent
  (`albaneseup-bundle-instance-demotion`) with write_domain
  `AlgebraicJacobian/Albanese/AlbaneseUP.lean` + consumer files
  (TBD; the auditor report lists `jacobianScheme C` consumers —
  iter-196 plan agent should grep for them before dispatching).

### Why these 3 are bundled into iter-196 plan-phase

The instance-demotion pattern (`instance → private theorem` + explicit
`haveI` threading at call sites) is the canonical iter-194 IC.lean
template. It is mechanical (~5-15 LOC per finding) and qualitatively
*increases* the project's soundness posture without changing semantics.
Should be landed BEFORE iter-196 prover dispatches so prover work is
not building on silently-sorryAx-carrying typeclass instances.

## Top-priority targets

### CRITICAL — re-dispatch the 2 errored lanes (root cause: API 529, not math)

1. **Lane BareScheme** (`AlgebraicJacobian/Genus0BaseObjects/BareScheme.lean`).
   - Plan-phase HARD GATE cleared via fastpath; blueprint coverage already
     landed at `AbelianVarietyRigidity.tex:951-993`.
   - Re-dispatch with mode `[prover-mode: mathlib-build]` and helper budget 3.
   - Same recipe as iter-195 plan: 2 scaffold sorries
     (`projectiveLineBar_smoothOfRelDim` via `D₊(X 0)` / `D₊(X 1)` chart cover
     + `RingHom.IsStandardSmoothOfRelativeDimension`; `projectiveLineBar_geomIrred`
     via integral-domain ring + base change preservation).
   - **Cascade unlocks** Lane I `instIsRegularInCodimOneProjectiveLineBar` (via
     affine-chart route now documented in WeilDivisor.lean body comments) and
     Lane RCI helper (a) per-fibre LQF. **Highest-leverage lane this iter.**
   - **Anti-recurrence note**: the prior session reached ~140 turns of API
     calls before timeout. Consider a checkpoint-style intermediate commit
     instruction: "after ≥30 min of substrate scouting with no edit
     committed, commit a substrate-roadmap comment block to the file at the
     scaffold sorry sites before continuing" — this preserves prover-session
     value on transient API failure.

2. **Lane E `AbelianVarietyRigidity.lean`** ANALOGUE-DRIVEN.
   - Persistent analogist file `analogies/lane-e-proj-appiso-pivot.md`
     preserves the `Proj.awayι_app_basicOpen` 3-helper recipe.
   - Re-dispatch with mode `[prover-mode: mathlib-build]`, helper budget 3.
   - HARD BAR: close ≥1 of (`kbarChart1Ring_specMap_fac` /
     `iotaGm_chart1_appIso_eval`).
   - PUSH-BEYOND: close BOTH via shared helper 3 +
     `kbarChart1Ring_pullback_collapse` via `pullbackSpecIso`.

### HIGH — Lane I `instIsRegularInCodimOneProjectiveLineBar` (gated on BareScheme cascade)

- Per Lane I prover report: pursue **Route 2 (affine-chart, k̄[t] PID transfer)
  via `projectiveLineBarAffineCover`** — substantially less substrate than
  full Smooth ⟹ IsRegularLocalRing chain.
- ~50-80 LOC: the `projectiveLineBarAffineCover` 2-chart cover is already
  available in BareScheme.lean; each chart = `Spec(k̄[t])` (PID); PID stalks
  at maximal ideals are DVRs (Mathlib `IsDiscreteValuationRing` instance for
  `IsPrincipalIdealRing` + `IsLocalRing` + `maximalIdeal ≠ ⊥`); transfer
  back via the chart-stalk iso.
- **Coordinated close** with Lane RCI `localParameterAtInfty_uniformiser_witness`
  (same chart bridge unlocks both).
- DO NOT pursue full Smooth chain — Mathlib gap is too wide (~200-300 LOC).

### HIGH — Lane F (Beck-Chevalley) refactor BEFORE prover dispatch

- The iter-195 prover report's CRITICAL finding: plan-phase "USING new
  Σ-pair identities, ~10-30 LOC" was off by ~5×. Realistic estimate ~100-150
  LOC over 4 named substrate helpers (N1)-(N4).
- **Iter-196 plan-phase action**: dispatch the refactor subagent to land
  (N1)-(N4) as named typed-sorry substrate helpers in QuotScheme.lean
  BEFORE sending the Lane F prover. The refactor commits 4 new typed sorrys
  (+4 net sorry count) but converts a single bundled opaque sorry into 4
  precisely-typed, independently-targetable named declarations.
- (N1) `baseMap` naturality in input sheaf (~20-30 LOC) — direct from
  `pullbackPushforwardAdjunction.unit` naturality.
- (N2) `baseMap` compatibility with `pullbackComp` (~30-40 LOC) —
  adjunction-composition rule at a morphism triple.
- (N3) `baseMap` compatibility with `pullbackCongr` (~10-20 LOC) — transport
  along propositional equality.
- (N4) `step3` inversion identity for `_hU.fromSpec` (~20-30 LOC) — from
  `restrictFunctorIsoPullback` for open immersions.

### MED — Lane A OCofP `exists_nonconstant_rational_from_dim_eq_two` finalization

- Iter-195 landed 6 axiom-clean substeps; 3 mathematical sub-claims remain.
- **Iter-196 attack**: package `toFunctionField` injectivity as a single
  LinearEquiv (`constantSheafAdj.homEquiv` + `M = ModuleCat.of kbar kbar`
  free of rank 1) — ~30-50 LOC.
- Once `f ≠ 0` is in scope, the order conditions follow mechanically via
  `globalSections_iff_mpr P hP f hf hPcoh ⟨s, hf_def.symm⟩`.
- The `principal f ≠ 0` sub-claim still gated on Stacks 02P0 substrate.

## Approaches that PARTIALLY worked — needs more substrate

- **Lane RCI structural lift via named helper** (1:1 inline → named-helper
  swap). DO NOT re-attempt direct tactic closure on
  `localParameterAtInfty_uniformiser_witness` — `Classical.arbitrary _`,
  `tauto`, `exact?` all confirmed dead by iter-195 prover. The 3-step
  closure path documented in the helper docstring (witness via
  `Proj.basicOpenIsoAway` chart; order via DVR uniformiser; uniqueness via
  opposite-pole at `D₊(X 0)`) is the iter-196 recipe.
- **Lane I body push**: `degree_positivePart_principal_eq_finrank` body
  now in canonical Hartshorne II.6.9 starting form. Residual is precisely
  `Ideal.sum_ramification_inertia` lifted via `Hom.ofFunctionFieldEmbedding`
  — still blocked on the iter-194 analogist's NEEDS_MATHLIB_GAP_FILL
  verdict.

## Blocked targets — do NOT re-assign without structural change

### Lane H `HModule_flasque_eq_zero` push-beyond (PUSH-BEYOND territory only)

- Blocked on `IsFlasque.injective_flasque` at L572 (Hartshorne III Lemma 2.4
  requires `j_!` extension-by-zero functor for sheaves of modules; Mathlib
  `b80f227` does not ship it). ~100-150 LOC project-side build OR USER
  escalation OR Mathlib upstream PR.
- **Iter-196 plan agent**: DO NOT dispatch Lane H this iter unless a
  refactor subagent has first committed substrate work on `injective_flasque`
  (e.g. carving a precisely-typed pin around the Hartshorne III.2.4
  argument). Push-beyond cascade to `h1_vanishing_genusZero` (OCofP L1147)
  remains gated.

### Lane A.3.i `geometricallyConnected_of_connected_of_section` body

- Iter-194 analogist `lane-a3i-stacks-04kv`: NEEDS_MATHLIB_GAP_FILL
  (0 ALIGN_WITH_MATHLIB on Stacks 037Q + 04KU + 04KV + field-tensor-
  product). Multi-iter substrate or USER escalation. PARKED per iter-195
  plan; **iter-196 candidate for USER escalation OR Mathlib upstream PR
  draft** (~350 LOC Route B per analogist).

### Lane M↓ `CodimOneExtension.lean`

- Stacks 00OE + 02JK + 0AVF unowned at b80f227. iter-200 broad-sweep
  candidate per STRATEGY.md. **iter-196 plan agent**: skip.

### Lane G n=k+1 body

- OFF-CRITICAL-PATH per session-194 R7 + iter-195 plan. Iter-196 may attempt
  the depth-drops-by-one substrate (piece 4 of the 4-piece slice) — ~40-60
  LOC — but body close stays multi-iter.

## NEW reusable proof patterns (add to PROJECT_STATUS Knowledge Base)

1. **`Functor.preservesFiniteLimits_iff_forall_exact_map_and_mono` packages
   SES exactness preservation from LEFT-half limit preservation** (Lane H —
   `Scheme.IsFlasque.shortExact_app_surjective`). For proving `(S.map F).Exact`
   given `S.ShortExact` + `F` additive between abelian categories, you do
   NOT need full `Functor.PreservesHomology`. The iff lemma's `.1`
   projection delivers exactness directly from `PreservesFiniteLimits F`.

2. **`sheafCompose_preservesFiniteLimits` via factor-through-`sheafToPresheaf`
   bridge** (Lane H, new instance ~L340). When proving
   `PreservesFiniteLimits (sheafCompose J F)` for arbitrary
   limit-preserving additive `F : A ⥤ B`, factor via
   `sheafCompose J F ⋙ sheafToPresheaf J B = sheafToPresheaf J A ⋙
   (whiskeringRight _ _ _).obj F` (by `rfl`) + RHS limits preservation +
   transport via `preservesFiniteLimits_of_reflects_of_preserves`.

3. **Generic `Finsupp.sum_max_zero_eq_sum_filter_pos`** kernel-clean ~10 LOC
   reusable Finsupp identity (Lane I, WeilDivisor.lean L684-709). Mathlib
   upstream PR candidate.

4. **Six-step linear-algebra extraction recipe from `Module.finrank kbar V = 2`
   to a non-constant section** (Lane A, OCofP.lean L1323). `Functor.map_zero`
   is the load-bearing simp lemma; `Submodule.exists_of_finrank_lt` finalises.

5. **Structural lift via file-private named helper preserves
   no-regression on sorry count when substrate-blocked** (Lane RCI). The
   1:1 swap discipline: inline `?hyp` sorry → named file-private typed sorry
   with docstring closure recipe; consumer body becomes sorry-free.

## Architectural observations (TO_USER / strategy considerations)

- **API 529 cost iter-195 the 2 highest-leverage closures** (BareScheme +
  Lane E). Neither committed any edits. Iter-196 must re-dispatch — these
  are not mathematical failures.

- **Plan-phase LOC estimates for compositional-closure lanes systematically
  undershoot** (Lane F overshoot iter-195 = ~5×; Lane H plan-phase Route A
  estimated higher than actual). The pattern: plan agent reads "using
  identity X" as direct, but each compositional stage introduces its own
  naturality obligation. Iter-196+ rule: any lane requiring ≥3 sequenced
  identities should be split into 3 refactor-subagent dispatches first.

- **Lane G n=k+1 carving is OFF-CRITICAL-PATH**; iter-195 plan-phase
  judgment confirmed. Plan agent should resist instinct to add it to
  iter-196 dispatches without explicit phase-change rationale.
