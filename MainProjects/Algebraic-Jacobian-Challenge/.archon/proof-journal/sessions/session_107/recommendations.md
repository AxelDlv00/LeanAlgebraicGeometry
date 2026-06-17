# Recommendations for the next plan-agent iteration (iter-108 Archon / iter-110 project)

## CRITICAL — Strategy-critic-iter107 exit criterion has FIRED: iter-108 (Archon) plan agent MUST pick from the Phase A escape-valve menu

**Background.** Iter-107 (Archon) / iter-109 (narrative) was bound by the strategy-critic-iter107 amendment to a **single further substantive prover iter** on the L1802 `h_loc_exact` slot under the analogist Q1 ALIGN_WITH_MATHLIB recipe. The prover landed Step 1c cleanly (40 LOC of `h_pi_eq_inf'` + `h_V_affine` + `h_isLoc` at L1796–L1834) but Steps 2–4 hit a structural blocker (the `letI ... in <goal-type>` propagation issue + the explicit `@`-form on `IsLocalizedModule` argument-order brittleness). Sorry count flat at 6→6; the trailing sorry shifted L1802 → L1846.

**This is the second consecutive PARTIAL on `h_loc_exact` (iter-108 narrative landed Steps 1a+1b; iter-109 narrative landed Step 1c).** Per the strategy-critic-iter107 amendment in STRATEGY.md § "Phase A escape-valve menu", the iter-108 (Archon) plan agent MUST pick one of:

### Option 1 (DEFAULT, cheapest) — defer L1846 as a named Mathlib-gap sorry

- Mark L1846 with `-- MATHLIB GAP: Step 2 of analogist Q1 — per-x Algebra/IsScalarTower threading requires either a top-level helper (forbidden by iter-107 plan) or a term-mode IsLocalizedModule.mk reconstruction (unattempted).`
- Preserve the iter-109 Step 1c progress on disk (`h_pi_eq_inf'`, `h_V_affine`, `h_isLoc`) as inert infrastructure for any future re-attempt.
- BasicOpenCech: 6 sorries → 6 sorries (one of them now a named gap). Phase A is then "complete modulo the named gap" — iter-108+ schedules Phase B / Phase C1 in standard order.
- **Justification**: cheapest; preserves momentum; honest about the structural blocker; named gap is auditable.

### Option 2 — fire C1 promotion immediately

- Refactor `Picard/LineBundle.lean` body to `MonoidalCategory.Invertible (X.Modules)` per strategy-critic-iter106 critical alternative #3 + user-iter107 hint authorisation. Estimate 5–8 iters / 200–300 LOC.
- Replaces the weakened-wrong `LineBundle X := CommRing.Pic Γ(X, ⊤)` (carryover critical from iter-104, re-confirmed by lean-auditor-iter107) with the mathematically correct definition.
- Orthogonal to L1846 — does NOT close `h_loc_exact`. But user-iter107 hint explicitly framed approximation/admitted-wrong defs as off-limits; this is the structurally correct move.
- **Justification**: the user hint is operative; the structural blocker on L1846 makes this the natural pivot moment.

### Option 3 — re-consult `mathlib-analogist` on a Step 2-only design that avoids the `letI` propagation issue

- Concrete obstruction is now identified: `letI ... in <goal-type>` propagation does not work; explicit `@`-form on `IsLocalizedModule` has brittle argument order.
- The analogist should evaluate whether term-mode `IsLocalizedModule.mk` is feasible inline OR whether outer-scope per-x algebra setup via a new top-level helper is required (the iter-107 plan explicitly forbade new helpers; iter-108 plan can lift that constraint if the verdict warrants).
- **Risk**: a third consecutive PARTIAL on L1846 is the failure mode; iter-108 plan should bind the analogist's verdict to a hard exit criterion (e.g. "if the analogist's verdict requires a new top-level helper, switch to Option 1 immediately").

**RECOMMENDATION** (review agent's read): **Option 2 (C1 promotion)** is the strongest call given the iter-107 user hint + lean-auditor-iter107's continued critical-severity flag on `LineBundle` weakened-wrong def. Option 1 is the cheapest fallback if the iter-108 plan agent judges Phase B preparation more urgent than Phase C1. Option 3 buys one more iter but risks the third consecutive PARTIAL on a slot that has now identified the structural blocker concretely.

## CRITICAL — carryover structural items requiring user attention (no change this iter)

The lean-auditor-iter107 confirmed all four items are still present with severity unchanged:

1. **`AlgebraicJacobian/Picard/LineBundle.lean:85–86` — Weakened-wrong `LineBundle` definition** (CRITICAL, carrying since iter-104). The docstring at L14–60 admits the def is "first-approximation" and captures only the strict subgroup of trivial-on-global-sections line bundles. Propagates to `Pic`, `Pic.pullback`, `PicardFunctor`, `nonempty_jacobianWitness`. Resolution is the Phase C1 refactor (see Option 2 above).

2. **`AlgebraicJacobian/Modules/Monoidal.lean:166–173` — `sorry`-bodied instance `instIsMonoidal_W`** (CRITICAL, carrying since iter-104). Mathlib upstream gap (varying-`R₀` stalk-of-presheaf-tensor missing). Honest documentation in `Modules_Monoidal.tex`; not closable in the autonomous loop. Verified by lean-auditor-iter107 that this does NOT block downstream `instMonoidalCategoryStruct` / `instMonoidalCategory` (both pivot through `LocalizedMonoidal`, NOT through `instIsMonoidal_W`). **No iter-108 action.**

3. **`AlgebraicJacobian/Picard/Functor.lean:190` — `PicardFunctor.representable := sorry`** (MAJOR, downstream of LineBundle). Lean-auditor-iter107 noted the docstring at L176–184 explicitly admits "Intentionally deferred. This is FGA-level and not honestly closeable on the global-sections-approximate `LineBundle`" — exactly the kind of excuse-comment severity escalates on. Closure is downstream of C1 promotion.

4. **`AlgebraicJacobian/Jacobian.lean:179` — `nonempty_jacobianWitness := sorry`** (CRITICAL, carrying). Phase-C scaffolding sorry; packages four downstream protected instances. Acknowledged in STRATEGY.md.

## HIGH — actionable for iter-108 plan-agent

### `lean-auditor-iter107` findings (full report: `task_results/lean-auditor-iter107.md`)

- **1 new MAJOR**: **`AlgebraicJacobian/Differentials.lean:28–31` header status drift** — the block claims "iteration 064 — scaffold / Closure trajectory is estimated at ~10 iterations" but ~50 iters have passed and most of the file (`relativeDifferentialsPresheaf`, `relativeDifferentials`, `universalDerivation`, `cotangentExactSeqAlpha/Beta` with closed `h_zero` + `h_epi`, the entire `moduleKPresheafOfModules*` chain, and `serre_duality_genus` setup down to its sorry statement) is now closed. Replace the wording with a concrete remaining-sorry count (5: L122, L636, L718, L735, L877). **Suggested iter-108 action**: dispatch a `refactor iter110-cleanup` subagent for this single edit (header text only, no semantics).
- **5 MINOR header/scaffolding drifts**:
  - `Genus.lean:39–61` — 22-line commented-out "sketch of the route" block is dead (current body is L65–68). Trim to a single-line pointer.
  - `Picard/LineBundle.lean:60` — docstring references "next iteration's refactor expected to either (a) build the tensor product of sheaves of modules and refine this definition, or (b) replace it altogether"; "next iteration" is iter-004 but we are at iter-107. Update wording to match current state (Monoidal.lean now has `MonoidalCategory X.Modules` closed). [If Option 2 fires, this comment becomes moot.]
  - `Modules/Monoidal.lean:18–30` — status header says "iteration 077 — refactor-subagent scaffold" and lists three signatures' bodies "to fill iter-078+"; two of three are closed. Tighten the header.
  - `StructureSheafModuleK.lean:46–61` — `CategoryTheory.Functor.const_additive` / `Functor.const_linear` are project-local Mathlib gap-fills worth upstreaming (no current action — informational).
  - `BasicOpenCech.lean:1083–1091` — iter-102 plan-note comment block on an attempted deterministic-timeout route. Trim once `cechCofaceMap_pi_smul` lands (no current action; still relevant context).
- **5 EXCUSE-COMMENTS (all carryover, unchanged)**: see Critical block above. No new excuse-comments this iter.

### `lean-vs-blueprint-checker-basicopencech-iter107` findings (full report: `task_results/lean-vs-blueprint-checker-basicopencech-iter107.md`)

- **PASS**: 14/14 `\lean{...}` declarations check, 0 red flags, no must-fix, no major.
- **1 MINOR "soon → should-fix-soon"**: **`Cohomology_MayerVietoris.tex` Step 2 of `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` should expand to preview the Mathlib API used at iter-108/109 geometric setup.** The iter-106 checker flagged this as "soon" carry-over; iter-107 hardens it because the prover has now committed ~40 LOC of inline scaffolding (`h_pi_eq_inf'`, `h_V_affine`, `h_isLoc` at L1796–L1834) that the chapter never previewed. **Recommended action**: in iter-108 plan-phase, dispatch a `blueprint-writer` for `Cohomology_MayerVietoris.tex` with the following content directive — add a labelled sub-lemma or step-enumeration under Step 2 of `thm:basicOpenCover_isCechAcyclicCover_toModuleKSheaf` previewing the four Mathlib pieces:
  1. `∏ᶜ` ↔ `Finset.inf'` over `Finset.image x` bridge (the iter-107 `h_pi_eq_inf'` shape).
  2. Each `V_x` is affine (iter-057 helper + image-Finset bridge).
  3. Per-coord `IsLocalization.Away ((presheaf.map _).hom f) Γ(V_x ⊓ D(f))` via `IsAffineOpen.isLocalization_of_eq_basicOpen` + `Scheme.basicOpen_res`.
  4. Finite-product-localization via `IsLocalizedModule.pi` combining (3) over the finite index set.
- **Non-blocking** for iter-108's substantive lane; should land if a `blueprint-writer` is dispatched anyway (e.g. for Option 2's C1 promotion blueprint preparation).

## MEDIUM — actionable for iter-108 plan-agent

- The iter-105 (narrative) wrapper helpers `cechCofaceMap_summand_family'` (L612–630) and `cechCofaceMap_summand_family'_R_linear` (L642+) remain on disk as inert infrastructure. The iter-105/iter-107 (narrative) partial-proof scaffold at L1115–L1119 (`hRel'` + `h_iter104`) is similarly preserved. If Option 2 (C1 promotion) fires, these may eventually be removable as dead code; if Option 1 (defer-as-gap) fires, they remain inert but harmless.
- If Option 3 fires (mathlib-analogist re-consult), the iter-108 plan agent should consider whether to lift the "no new top-level helpers" constraint that bound iter-107's prover. The constraint was correct for a bounded-recipe attempt but is itself the obstruction to outer-scope per-x algebra setup. The analogist's verdict should explicitly answer "can we close Step 2 inline, or must we add a top-level helper?"

## LOW — informational

- Iter-109 (narrative) prover added a `debug_feedback.md` entry on the `letI ... in <goal-type>` propagation trap (visible as the final Bash event in `attempts_raw.jsonl` @ L93). Good signal — Step 2's structural blocker is now documented in three places (task_results file, recommendations.md, and developer-feedback channel).
- One MCP `lean_diagnostic_messages` call early in the iter failed with a relative-path error (L17 of attempts_raw.jsonl) and recovered immediately with absolute path on the next call. UX nit; no impact on the iter.
- 25 lemma searches were performed mid-iter (recipe verification). All key Mathlib citations re-verified: `IsLocalizedModule.pi`, `IsAffineOpen.isLocalization_of_eq_basicOpen`, `Function.Exact.iff_of_ladder_linearEquiv`, `LinearEquiv.conj_exact_iff_exact`, `IsLocalizedModule.iso`, `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`, `Submonoid.map_powers`, `Algebra.algebraMapSubmonoid_powers`, `IsLocalizedModule.linearMap_ext`, `Finset.inf_univ_eq_iInf`, `Finset.inf'_image`, `Finset.inf'_eq_inf`, `IsScalarTower.of_algebraMap_eq`, `RingHom.algebraMap_toAlgebra`.

## What NOT to retry (do not assign to iter-110 prover)

These approaches are confirmed dead this iter on the L1846 slot AND continuing-dead on the L1120 slot:

**L1846 slot (post iter-109)**:

1. `letI ... in <goal-type>` propagation for per-x typeclass threading — confirmed DEAD. The letI elaborates eagerly during goal type-checking; the body has no `intro` targets. NEW iter-107 finding.
2. Explicit `@IsLocalizedModule R _ S M _ _ N _ <module> <linear>` form — argument order brittle; `RingHom.toLinearMap` doesn't exist on bare `RingHom`. NEW iter-107 finding (~60 LOC of explicit bookkeeping was needed; abandoned).
3. `rw [CompleteLattice.finite_product_eq_finset_inf]` direct on `∏ᶜ` in `Opens` — fails on universe mismatch (`Fin (n+1) : Type 0` vs `Opens : Type u`). Workaround `h_pi_eq_inf'` documented; reusable.
4. `LocalizedModule.map_exact` direct application — confirmed CIRCULAR (iter-108 + iter-109 re-confirmations).

**L1120 slot (PAUSED — do not touch until escape-valve decision)**:

All 8 dead-end classes from iter-099/100/101/103/105/106/107 persist (wrapper-helper variants, body-level inlining, `rw [ModuleCat.hom_zsmul]`, `Preadditive.zsmul_comp`, body-local rfl-helpers, change/show on named family, `rcases n + simp [hPrev]`, heartbeat-budget escalation). Iter-108 plan agent should leave L1120 PAUSED unless Option 3 fires AND the analogist explicitly authorises a Q2 Path B revival.

## Streak-escalation guidance (for iter-108 plan-agent)

- **L1846**: **2 consecutive PARTIAL iters** (iter-108 narrative + iter-109 narrative). Strategy-critic-iter107 exit criterion fires — iter-108 (Archon) MUST pick from the Phase A escape-valve menu. No third substantive lane on L1846 is authorised.
- **L1120**: **7 consecutive PARTIAL iters FROZEN through iter-109**. Streak does not extend. Re-opening requires either Option 3 (analogist Q2 Path B) or C1 promotion (Option 2), depending on iter-108 plan agent's choice.

## Reusable proof patterns documented this iter (added to Knowledge Base)

- **`∏ᶜ` over `Fin (n+1)` ↔ `Finset.inf'` over `Finset.image x univ` bridge** (NEW iter-109): 14-LOC chain `∏ᶜ = ⨅ = Finset.univ.inf = Finset.univ.inf' = (Finset.image x univ).inf'` via `Pi.π / Pi.lift` le_antisymm + `Finset.inf_univ_eq_iInf` + `Finset.inf'_eq_inf` + reversed `Finset.inf'_image`. Sidesteps the universe-mismatch in Mathlib's `CompleteLattice.finite_product_eq_finset_inf` (which requires `α, ι : Type u` same-universe; `Fin (n+1) : Type 0` vs `Opens : Type u` fails this). Reusable for any future Fin-indexed `∏ᶜ → Finset.inf'` bridging inside a Čech-style proof.
- **`letI ... in <goal-type>` does NOT propagate to the proof body** (NEW iter-109, anti-pattern): when an inline `have` has the form `have foo : letI _ := ... ; <goal-type> := by intro; ...`, the `letI` elaborates eagerly during goal type-checking, leaving no `intro` targets and the local typeclass instances are invisible to `infer_instance` from the body. **Workaround**: hoist the `letI` to outer scope (turning the have-target type-level instances into proof-level instances, but breaking the per-x bound-variable shape); OR use term-mode `IsLocalizedModule.mk` to construct the instance directly without binding the algebra typeclasses. Documented as a recurring trap; the iter-109 prover's debug-feedback entry escalates it for future iters.
- **Explicit `@`-form on `IsLocalizedModule` is brittle**: argument order varies across Mathlib refactors; `RingHom.toLinearMap` doesn't exist on bare `RingHom` (needs Algebra structure); ~60 LOC of explicit bookkeeping is the minimum cost. Prefer the implicit-instance route via the standard adapter `instIsLocalizedModuleToLinearMapToAlgHomOfIsLocalizationAlgebraMapSubmonoid`, with the algebras threaded via outer-scope `letI` (per the workaround above).
- **The `@`-form `IsLocalization.Away` typing pattern from iter-059** (RECONFIRMED iter-109): for a conclusion of shape `IsLocalization.Away ((presheafMap _).hom f.1) Γ(V_x ⊓ D(f.1))` where the algebra is supplied explicitly, mirror iter-059's `basicOpenCover_finset_inf'_isLocalization` shape exactly. This works for the single-step `h_isLoc` use case (iter-109's L1822–L1834) but does NOT generalise to `IsLocalizedModule` (see anti-pattern above).

## Sidebar: developer-feedback observation

The iter-109 prover left a `.archon/.debug-feedback/debug_feedback.md` entry on the `letI ... in <goal-type>` propagation trap (final Bash event in `attempts_raw.jsonl` @ L93). Good signal; the developer will see the structural blocker independently of the journal narrative.
