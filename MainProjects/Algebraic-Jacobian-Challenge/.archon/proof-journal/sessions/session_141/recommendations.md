# Recommendations for the next plan-agent iteration (iter-142)

## Primary directive: dispatch the iter-142 prover lane on piece (i.b) Step 2 d_app + d_map sub-sorries

The iter-141 plan-phase deferral is over. The blueprint expansion
(Wave 3) and analogist verdict (Wave 2) prepared everything iter-142
needs for a substantive prover lane on `AlgebraicJacobian/Cotangent/GrpObj.lean`:

- **Target sub-sorries** (BUNDLED): L624 (d_app) + L643 (d_map). The
  L689 IsIso per-open sub-sorry stays deferred to iter-143+.
- **Acceptance criteria** (re-applying the iter-141 progress-critic gate):
  - **PASS arm**: ≥2 of 2 closed (BOTH d_app + d_map) → CONVERGING-confirmed; iter-143 prover lane on L689 IsIso + iter-143/144 on L817 Main `mulRight_globalises_cotangent` composition.
  - **PARTIAL arm**: 1 of 2 closed → CHURNING-CONFIRMED (iter-141 was CHURNING-trigger). Mid-iter strategy-critic re-dispatch with the **diagnostic question** (per iter-141 STRATEGY.md Edit 4), surface route correctives.
  - **FAIL arm**: 0 of 2 closed AND a new opacity-family blocker phrase resurfaces → STUCK; route pivot mandatory.
- **LOC envelope**: combined ~80–140 LOC for d_app + d_map (analogist
  Decision 5); cumulative (i.b)-side becomes ~565–625 LOC, well inside
  the 1000 LOC arm (~530 LOC headroom at iter-141 entry).

## High-priority load-bearing inputs for the iter-142 prover directive

1. **`analogies/d-app-d-map-recipe-shape.md`** — names the missing
   Mathlib lemma `PresheafOfModules.pushforward_obj_map_apply'`
   (`Mathlib/Algebra/Category/ModuleCat/Presheaf/Pushforward.lean:99–106`)
   and the d_map closure chase (`simp only [pushforward_obj_map_apply']`
   + `NatTrans.naturality` + `relativeDifferentials'_map_d`). Pass
   this verbatim into the prover-lane directive.

2. **`RigidityKbar.tex` updated d_app + d_map recipes** (the iter-141
   Wave 3 blueprint-writer landed 4 directive updates, file 1224 →
   1349 LOC). The chapter is `complete: true / correct: true` going
   into iter-142.

3. **Negative-lesson — `change` is BANNED on d_map**: the iter-140
   deterministic `whnf` timeout proves the d_map RHS is opaque under
   `pushforward₀`'s `set_option backward.isDefEq.respectTransparency
   false in` annotation. Future iters MUST NOT re-attempt
   `change`-first patterns on `pushforward`-transposed goals.
   Codified in Knowledge Base iter-140 + iter-141 blueprint Update 3a.

4. **d_app categorical-witness `h`** — NEEDS_MATHLIB_GAP_FILL bespoke
   chase ~40–80 LOC: combine `(fst G G).w + (snd G G).w` →
   `(fst G G).left ≫ G.hom = (snd G G).left ≫ G.hom`, lift via
   `LocallyRingedSpace.comp_c_app`, adjunction-transpose along
   `pullbackPushforwardAdjunction.homEquiv`. Close via
   `ModuleCat.Derivation.d_map` (NOT `Derivation.map_algebraMap`
   directly; analogist Decision 1 prefers the `d_map`-streamlined
   pattern for ~4 LOC savings).

## Iter-142 review-phase audit obligations

Per the review prompt's mandatory dispatch rules:

- **`lean-auditor`** — dispatch with a narrow file list including
  `Cotangent/GrpObj.lean` after the iter-142 prover lane closes. Pass
  minimal strategic context.
- **`lean-vs-blueprint-checker`** — dispatch once per prover-touched
  file (`Cotangent/GrpObj.lean` is the only candidate this round).
  Pair with `RigidityKbar.tex`.

## Watch criteria carried forward from iter-141 (per plan.md § Watch criteria committed for iter-142)

1. **Iter-142 mandatory blueprint-reviewer re-confirms `RigidityKbar.tex`**
   `complete: true / correct: true` after the iter-141 Wave 3 expansion.

2. **Iter-142 mandatory progress-critic** applies the narrowed hard
   gates above (PASS / PARTIAL / FAIL arms).

3. **Iter-142 mandatory strategy-critic re-verification** of the 4
   iter-141 STRATEGY.md edits (multi-year header, M3 PR-lane rename,
   symmetric LOC discipline, CHURNING-trigger decoupling).

4. **`sync_leanok` mis-mark concern at `RigidityKbar.tex:505`** — the
   `\leanok` marker on `\cref{lem:GrpObj_omega_basechange_proj}`'s
   proof block persists while the Lean still has 3 sub-sorries
   (L624 + L643 + L689). The iter-140 `(fun _ => sorry)` pattern
   inside `isIso_of_app_iso_module` may be confusing `sorry_analyzer`.
   Consider dispatching `archon-lean4:doctor` consult on
   `sync_leanok`'s handling of `(fun _ => sorry)`-bearing bodies if
   the mis-mark persists past iter-142.

5. **Iter-144 mandatory chart-algebra-vs-bundled re-evaluation**
   (iter-140 pinned). Both load-bearing analogy files are now on
   disk:
   - `analogies/direct-chart-algebra-rigidity-ib-ic.md` (iter-140; 450–900 LOC for chart-algebra route on pieces (i.b)+(i.c)).
   - `analogies/scheme-frobenius-piece-iii-scoping.md` (iter-141; 680–1370 LOC for in-tree scheme-Frobenius on piece (iii); HYBRID — pivot does NOT fire under the 2000 LOC threshold but chart-algebra remains LOC-dominant overall).
   The iter-144 gate is the decision point between (1) full in-tree
   (980–1970 LOC), (2) PR-core + named-gap mixed, (3) chart-algebra
   (450–900 LOC).

6. **Iter-150 consult-count threshold revisit** (per iter-140
   STRATEGY.md Edit 1 + iter-141 strategy-critic Edit 1 residual
   concern). The iter-141 d_app/d_map consult bumps piece (i.b)
   consult count to 5; the watchpoint fires mechanically but
   route-pivot has been answered REJECT, so the answer doesn't
   change. Iter-150 revisit must either pick a `k` such that ≥k
   consults guarantees a diagnostic-question dispatch or explicitly
   retire the count-only arm.

7. **Iter-145+ piece (i.b) Step 2 route-pivot breakeven**: if
   iter-142 + iter-143 prover lanes both fail to close ≥2 sub-sorries
   despite refined recipes, reopen pivot to one of the off-route
   M-piece bodies. Five consecutive iters of attention on (i.b) Step 2
   without strict-count closure is the breakeven point.

## Off-target this iter (DO NOT re-attempt without new evidence)

- **`change`-first pattern on d_map** — proved dead iter-140 via
  deterministic `whnf` timeout; the `pushforward₀`
  `respectTransparency false` annotation is the root cause; the
  ALIGN_WITH_MATHLIB `simp only [pushforward_obj_map_apply']` recipe
  replaces it. Codified in Knowledge Base.
- **Whole-morphism iso check `letI : IsIso ... := sorry`** at L689 —
  iter-140 narrowed to per-open `(fun _ => sorry)` via the new private
  helper `isIso_of_app_iso_module`. Per-open closure is the iter-143+
  target via `tensorKaehlerEquiv.symm` + chart-unfolding helper.
- **Over-k vs over-`k̄` route-pivot** — iter-141 strategy-critic
  REJECTED-AS-WRONG-QUESTION (piece (i.b) Step 2 is base-independent).
  Do not re-open as a route-pivot question; consider only as a final
  end-state simplification.

## Off-critical-path (deferred, do not assign)

- `Jacobian.lean` L197 `genusZeroWitness` (M2.b iter-153+).
- `Jacobian.lean` L223 `positiveGenusWitness` (M3 scaffold).
- `RigidityKbar.lean` L87 `rigidity_over_kbar` (M2.a iter-151+).

## Reusable proof patterns surfaced this iter (codify across the rest of the route)

1. **`PresheafOfModules.pushforward_obj_map_apply'` for `pushforward`-
   opaque rewrites** (NEW iter-141): when working under
   `Derivation'.mk` / `ModuleCat.Derivation.mk` constructions whose
   d_map obligation carries `(pushforward F).map f`-style terms, use
   `simp only [pushforward_obj_map_apply']` — NOT `change` — to unfold.
   `pushforward₀` is annotated `set_option
   backward.isDefEq.respectTransparency false in`, blocking
   `whnf`/`isDefEq` unfolding. Add to Knowledge Base.

2. **`ModuleCat.Derivation.d_map` streamlining over the `letI`-chain**
   (NEW iter-141): for `Derivation.mk`-internal `d` law closures
   where the inner function factors through a ring morphism with an
   `Algebra` instance, prefer the single-step `d_map @[simp]` over
   the `letI`-then-`map_algebraMap`-then-discharge chain (~4 LOC
   savings per call site).

3. **CHURNING-trigger pre-commitments must name diagnostic questions,
   not answers** (NEW iter-141, STRATEGY.md Edit 4): pre-wiring a
   CHURNING-trigger to "re-open route-pivot Q" is a category error —
   the right pre-commitment is "dispatch strategy-critic with the
   diagnostic question 'what is the right corrective?'". This iter
   surfaced a base-independent bottleneck where the pre-committed
   route-pivot pivot was a wrong-question.
