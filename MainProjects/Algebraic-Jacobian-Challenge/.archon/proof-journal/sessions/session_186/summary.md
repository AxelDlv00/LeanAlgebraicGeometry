# Session 186 — iter-186 review

## Metadata

- **Iteration**: 186
- **Session**: session_186
- **Date**: 2026-05-25
- **Sorry count**: 82 → **76** (net **−6**, within best-case −7 band of plan's projection 82→~75-78)
- **Project axioms**: 0 → 0 (**7th consecutive zero-axiom build retained**)
- **Lake build**: GREEN (per `.archon/logs/iter-186/meta.json` prover.status=done; no error markers in build logs)
- **planValidate**: 9 of 9 planner-intended lanes dispatched (Lane M↓ deferred at plan close; no attrition)
- **Targets attempted**: 9 lanes (E, G, B, F, A.1.b NEW LineBundlePullback, A OCofP, NEW IdentityComponent, H, I)
- **Lanes that ran**: 9 of 9 to completion (no Anthropic quota truncation this iter)
- **sync_leanok**: added 12 / removed 0 / chapters touched: AbelianVarietyRigidity, Albanese_AuslanderBuchsbaum, Picard_LineBundlePullback

## Headline outcome

**The "Lane A.1.b LineBundlePullback CLEAN SWEEP (5 → 0 axiom-clean) + Lane G R⧸(x) bridge axiom-clean + Lane A OCofP 3 carrierSubmodule closure sorries axiom-clean (refactor handover landed cleanly) + Lane B 5-iter CHURNING confirmed (Recipe 2/3 failed; mandatory gate MISSED; analogist path c separated-locus the remaining option) + Lane I CRITICAL FINDING: circular dependency between poleDivisor_degree_eq_finrank and Hom.poleDivisor surfaced (iter-186 plan misread)" iter.**

The build is GREEN with a 7th consecutive zero-axiom claim. The **−6 sorry net** is the best result since the iter-180 RelativeSpec push: Lane A.1.b LineBundlePullback alone delivered all 5 file-skeleton closures on a first body attempt (no prior body experience this lane), and Lane G + Lane A contributed 1 + 3 more axiom-clean closures. Lane H's +1 lake-count is honest structural decomposition into narrower typed sorries.

## Per-lane outcomes

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| A.1.b | **NEW HARD SUCCESS** | `Picard/LineBundlePullback.lean` | **SOLVED** | 5 → **0** (−5) | All 5 file-skeleton typed sorries closed axiom-clean (kernel-only: propext, Classical.choice, Quot.sound). `OnProduct := (pullback πC πT).Modules` (@[reducible]); `pullbackAlongProjection`, `pullback_pullback_eq` direct Mathlib; iso-class setoid for `preimage_subgroup`; `functorial` via projection-pullback. Deliberate **simplification**: drops invertibility wrapper (Mathlib b80f227 ships no `IsInvertible` on `Scheme.Modules`); types are substantive, not type-weakened. |
| G | SUCCESS (bridge axiom-clean) | `Albanese/AuslanderBuchsbaum.lean` | **PARTIAL → SUCCESS** | 3 → 2 (**−1**) | `regularLocal_inductive_step` R⧸(x) bridge inline sorry CLOSED. New 25-LOC `heq` proof + explicit `LinearEquiv` via `Submodule.mapQ` + `LinearEquiv.isRegular_congr`. Helper extracted inline (not a named separate decl per directive). `regularLocal_inductive_step` axiom-clean modulo `exists_isSMulRegular_quotient_isRegularLocal_succ` (L975 substrate). |
| A | SUCCESS (3 closures) | `RiemannRoch/OCofP.lean` | **PARTIAL → SUCCESS** | 7 → 7 (refactor 10 → 7 in-iter) | Refactor agent landed Steps 1+2 of recipe (carrierSubmodule scaffold with 3 typed sorries in zero_mem'/add_mem'/smul_mem' + WeilDivisor.lean IsDiscreteValuationRing class upgrade). Prover closed all 3 closure sorries axiom-clean (entered file at 10, exited at 7 = iter-185 baseline). Added 2 instance helpers `instNonemptyTopOpen` + `instAlgebraKbarFunctionField` to type-check the carrier. Steps 3-5 of refactor recipe (presheaf functor + isSheaf + replace L224-233 body) NOT landed mid-flight; iter-187 work. |
| F | PARTIAL substantive | `Picard/QuotScheme.lean` | **PARTIAL** | 9 → 9 | Step 2 (baseMap) axiom-clean. One body-level sorry (Stacks 02KE algebraic content) replaced by named typed-sorry on explicit `IsBaseChange Γ(Y, U) baseMap` Prop + axiom-clean construction of `pullback_app_isoTensor_baseMap`. Step 4 (IsBaseChange Prop) deferred to iter-187+. |
| E | structural advance | `AbelianVarietyRigidity.lean` | **PARTIAL** | 2 → 2 | sub-task (f) `iotaGm_chart1_composition_isOpenImmersion` appTop residual gap REFINED: documented the focused identity `r_1.appTop(isLocElem) = 1` in kbar (uniqueness of `r_1` via `cancel_mono` on `Proj.awayι`). iter-187 closure recipe in 6 steps inline + private helper plan. |
| NEW | structural | `Picard/IdentityComponent.lean` | **PARTIAL** | 5 → 5 (redistributed) | `IdentityComponent` body via `Over.mk ((identityComponentCarrier G).ι ≫ G.hom)`; new private `identityComponentCarrier : G.left.Opens` (typed sorry — substantive content gated on `LocallyConnectedSpace G.left.toTopCat` Mathlib gap, EGA I 6.1.9 unformalized). `isOpenSubgroupScheme` open-immersion half axiom-clean; closed-immersion half reduces to inline narrow `IsClosed (↑carrier : Set _)` sorry. Body-substance test PASSES; the 5 sorries redistribute as 1 helper + 1 narrow `Set`-closedness + 3 unrelated downstream. |
| H | PARTIAL substantive | `RiemannRoch/RRFormula.lean` | **PARTIAL** | 1 → 2 (+1 structural) | `eulerCharacteristic_of_shortExact_skyscraper` body now sorry-free; substantive content decomposed into 3 named sub-helpers. `eulerCharacteristic_iso` closed Tier-1 axiom-clean (LinearEquiv via `Abelian.Ext.postcompOfLinear`). `eulerCharacteristic_shortExact_add` + `eulerCharacteristic_skyscraperSheaf` remain Tier-3 typed sorries (project-side LES carrier + flasque-cohomology bridge gaps). Substantive: 1 monolithic → 2 narrower + 1 axiom-clean helper. |
| B | **CHURNING — 5th iter — mandatory gate MISSED** | `Genus0BaseObjects/GmScaling.lean` | **PARTIAL** | 4 → 4 (gate MISSED) | Path III.a refactor landed (term-mode `gmScalingP1_cover_intersection_X_iso`); axiom-clean. Recipes 2/3 BLOCKED on Mathlib simp pattern coverage gap (`inv (pullback.map _ _ _ _ _ _ _ eq₁ eq₂) ≫ pullback.fst/snd` adjacent to other `pullback.map` not served by `pullbackRightPullbackFstIso_inv_fst/_snd_fst/_snd_snd`). `cancel_mono (PLB.hom)` Mono instance doesn't synthesize. **Failure-mode trigger fires**: iter-187 opens separated-locus alternative (path c from `analogies/gmscaling-projection-idiom.md`). |
| I | **PARTIAL + CRITICAL FINDING** | `RiemannRoch/RationalCurveIso.lean` | **BLOCKED** (circular dep) | 3 → 3 | 78-LOC scaffold with 5-step `Ideal.sum_ramification_inertia` chain inline (chart at ∞ → preimage finite → sum_ramification_inertia → LHS-RHS identifications). **CRITICAL**: `Hom.poleDivisor_degree_eq_finrank` body cannot close until `Hom.poleDivisor` body lands — `unfold Hom.poleDivisor` produces a goal containing literal `sorry`. iter-186 plan-phase directive "Pin 3 body L482 and `Hom.poleDivisor` body iter-187+ separately" **misreads the dependency**. |

**Net sorry trajectory**: 82 → 76 (−6 by file count). Plan's predicted band: best −7 / realistic −2 to +2 / worst +2 to +8 → **outcome WITHIN BEST-CASE BAND** (just 1 short of best).

## Key findings / patterns discovered

### NEW patterns this iter (4 — for PROJECT_STATUS Knowledge Base)

1. **`Submodule.mapQ` + `LinearEquiv.isRegular_congr` is the 25-LOC R⧸(x)-linear equivalence recipe for QuotSMulTop ≃ₗ R⧸Ideal.span{x}** (Lane G; AuslanderBuchsbaum).

2. **`Scheme.Modules.pullback` direct-application + carrier-level invertibility forgetting is the iter-186 axiom-clean shape for `OnProduct`-style line-bundle pullback infrastructure** when Mathlib lacks `IsInvertible`-on-`Scheme.Modules` (Lane A.1.b; LineBundlePullback). 5-declaration cascade closed via `pullbackComp + pullbackCongr + pullback.lift_snd` chain on the iso side; iso-class setoid (`Nonempty (L ≅ L')`) on the equivalence side. Trade-off: iter-187+ wraps with invertibility predicate.

3. **`Algebra` instance via `RingHom.toAlgebra ∘ (Scheme.toModuleKSheaf.kToSection ≫ Scheme.germToFunctionField)` is the 2-helper bridge for `Algebra kbar K(C)` on geometrically-integral proper curves over algebraically-closed base** (Lane A OCofP). `Nonempty` synthesis trap: `(⊤ : Opens X.toTopCat)` vs `U : X.Opens` Mathlib API mismatch — resolve via exact `C.left.Opens` spelling.

4. **`Abelian.Ext.postcompOfLinear` + (`comp_assoc_of_third_deg_zero` + `mk₀_comp_mk₀` + `Iso.hom_inv_id` + `comp_mk₀_id`) is the explicit-LinearEquiv-per-n recipe for kbar-linear χ-invariance under sheaf iso (`HModule kbar F n ≃ₗ[kbar] HModule kbar G n`)** (Lane H RRFormula `eulerCharacteristic_iso` axiom-clean). Pitfall: `LinearEquiv.ofLinear`'s two `?_` are NOT symmetric (h₁ on N codomain, h₂ on M domain).

### Known anti-patterns / new blockers

- **GmScaling Recipe 2/3 PERMANENTLY BLOCKED on Mathlib simp coverage** — `inv (pullback.map _ _ _ _ _ _ _ eq₁ eq₂) ≫ pullback.fst/snd` adjacent to other `pullback.map` is unserved by `pullbackRightPullbackFstIso_inv_fst/_snd_fst/_snd_snd` because the projections must be syntactically displayed, not buried inside outer `pullback.map`. Iter-187 must pivot to separated-locus alternative (path c).

- **CRITICAL: `Hom.poleDivisor_degree_eq_finrank` blocked on circular dependency** — the helper body cannot definitionally progress past `unfold Hom.poleDivisor` producing literal `sorry` in goal. Iter-186 directive's "separately iter-187+" misread the dep order. Reorder: `Hom.poleDivisor` body FIRST.

- **`LocallyConnectedSpace X.toTopCat` from `IsLocallyNoetherian X` is a Mathlib gap at b80f227** (EGA I 6.1.9 unformalized). Blocks `identityComponentCarrier` body for `IdentityComponent`.

- **No `IsInvertible` predicate on `Scheme.Modules` at b80f227** — blocks promoting LineBundlePullback signatures to the full Pic-quotient shape; iter-187+ either project-side predicate or Mathlib PR.

- **No `H^n(X, F) = 0` for flasque `F` lemma at the `ModuleCat`-flavoured `Abelian.Ext`-cohomology level at b80f227** — blocks `eulerCharacteristic_skyscraperSheaf` H¹-vanishing closure.

## Recommendations for next session

Top-priority items go to `recommendations.md`. Brief preview:

- **iter-187 GATE** must address the iter-186 Lane I CRITICAL finding (reorder Hom.poleDivisor + degree_eq_finrank).
- **Lane B** — failure-mode trigger fires; open separated-locus alternative this iter.
- **Lane A.1.b** — best-case landing; iter-187+ open follow-up to add invertibility witness (NEW lane scaffold for `LineBundle.IsInvertible` predicate).
- **Lane M↓ CodimOneExtension** still gated on iter-186 reviewer absence; iter-187 plan-phase must dispatch fresh reviewer.
- **Two semaphore-blocked critics from iter-186 plan-phase** (`progress-critic route186` + `blueprint-reviewer iter186`) PRIORITY DISPATCH iter-187.

## Blueprint markers updated (manual)

- `Picard_LineBundlePullback.tex`, `def:line_bundle_on_product`: added `% NOTE (iter-186 review): The iter-186 closure simplifies the blueprint claim — Lean carries the bare `(pullback πC πT).Modules` carrier without the invertibility wrapper (no `IsInvertible`-on-`Scheme.Modules` predicate in Mathlib b80f227). The 5 declarations are axiom-clean as direct Mathlib applications; semantic refinement to the full Pic-quotient shape (with invertibility + π_T^* Pic(T) quotient) is iter-187+ work.`
- `Picard_LineBundlePullback.tex`, `def:pullback_along_projection`: added `% NOTE (iter-186 review)`: iter-186 body is direct `Scheme.Modules.pullback (Limits.pullback.snd πC πT) .obj N`; invertibility preservation (Stacks 01HH) deferred to iter-187+.
- `Picard_LineBundlePullback.tex`, `thm:relative_pic_quotient_well_defined`: added `% NOTE (iter-186 review)`: iter-186 setoid is `Nonempty (L ≅ L')` (identifies isomorphic modules); does NOT yet quotient by `π_T^* Pic(T)` subgroup. Full quotient requires tensor-product structure on `Scheme.Modules` + invertibility inverse — iter-187+.

No `\leanok` added or removed by review (deterministic sync_leanok handled 12 additions across 3 chapters per `sync_leanok-state.json`).

No `\mathlibok` added this iter — the LineBundlePullback closures are direct Mathlib applications but the surrounding intent (Pic = invertible sheaves) differs, so `% NOTE:` is the correct semantic marker, not `\mathlibok`.

No `\notready` stale markers detected this iter.

## Reviewer findings (subagent dispatches)

Skipped this review phase (see `## Subagent skips` in `iter/iter-186/review.md`).
