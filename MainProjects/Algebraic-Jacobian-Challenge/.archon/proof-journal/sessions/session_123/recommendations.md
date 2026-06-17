# Recommendations for the next plan-agent iteration (iter-124)

## CRITICAL — must be acted on this iter

### CRITICAL #0 — `lean-auditor-review123` returned 4 must-fix items (3 outside the active prover surface)

Per `task_results/lean-auditor-review123.md` § Must-fix-this-iter:

1. **`Cohomology/StructureSheafModuleK.lean:458–519` — `IsAffineHModuleHomFinite` dead class + 3 consumers**
   The class is explicitly author-disclosed as "dead scaffolding"
   in the file's own docstring (L518-543): there is no possible
   producer instance on a non-trivial proper curve (cited
   counterexample on ℙ¹). The class + 3 downstream consumers
   (`module_finite_HModule'_zero_of_isAffineHModuleHomFinite`,
   `module_finite_HModule'_of_affine`, `module_finite_HModule'_of_affine_curve`)
   carry an unsatisfiable hypothesis through typeclass search.
   **Recommended action**: dispatch a refactor subagent
   (`refactor-isaffinehomf-delete-iter124`) with directive
   "delete `class IsAffineHModuleHomFinite` and its 3 consumers
   in `Cohomology/StructureSheafModuleK.lean:458-519`; add a
   file-header note that the H>0 affine carrier
   (`IsAffineHModuleVanishing`, iter-040) is the only surviving
   affine route, while H⁰ goes through the wholespace
   `IsHModuleHomFinite` (iter-043) per the iter-046 producer
   instance." No Lean closure required; this is a deletion +
   docstring update. Estimated 0.2 prover-equivalent iter.

2. **`Cohomology/MayerVietorisCover.lean:50–62` — `AffineCoverMVSquare` unused affineness fields**
   Three fields (`isAffineOpen_U₁`, `isAffineOpen_U₂`,
   `isAffineOpen_inf`) are declared but read by zero consumers in
   the project. The structure name promises affineness propagation
   but the implementation does not honor that promise.
   **Recommended action**: discretionary; can be deferred or
   addressed via a small refactor subagent dispatch. If kept,
   add a `% NOTE:` or in-source comment explaining that the
   fields are reserved for the iter-054+ producer instance.

3. **`Genus.lean:39–61` — Stale commented-out "OXAsAddCommGrpSheaf / H1OC" sketch**
   Phase A is closed; the sketch describes a route not taken.
   **Recommended action**: dispatch a small refactor subagent
   (`refactor-genus-cleanup-iter124`) with directive "delete the
   commented-out sketch at `Genus.lean:39-61` and retitle the
   L15-29 status block to past-tense ('Status (closed iteration 011 — `genus`)')."
   Trivial cleanup; estimated 0.1 prover-equivalent iter.

4. **`Differentials.lean:239` — `erw [hmc]` brittle spot**
   The `erw` for `Functor.map_comp` is a defeq-stretching code
   smell; the surrounding L228-247 `change`-heavy block in
   `isUnit_appLE_unitSubmonoid_in_colim` is brittle.
   **Recommended action**: discretionary; this is INSIDE
   the iter-122-closed proof body (Step 0 of M1.b), so a refactor
   would touch already-closed code. Defer unless the iter-124
   prover Step 2 work re-uses this `Lan.map_comp` pattern and
   wants to refactor for clarity. If kept, the iter-122 Knowledge
   Base entry on `Lan.map_comp` already documents the `erw`
   workaround as the canonical idiom.

**Plan-agent ordering**: items 1 + 3 are quick refactors orthogonal
to the iter-124 prover lane; can run in parallel. Item 2 is
discretionary; item 4 is discretionary and inside closed code.

### CRITICAL #1 — Continue M1.b: iter-124 prover lane on `appLE_isLocalization` Steps 2 + 3

**Target**: `AlgebraicJacobian/Differentials.lean:282`
`appLE_isLocalization` body (residual `sorry` at L362 inside the
`suffices AE : Localization M ≃ₐ[Γ(S, U)] A_colim` block).

**Status**: Steps 1 + 4 of the 4-step `IsLocalization.of_le` chain
land concretely in body this iter (Step 1 forward map via
`IsLocalization.lift`; Step 4 reduction via
`IsLocalization.isLocalization_of_algEquiv`). Step 0 was closed
iter-122 as named helper. Steps 2 + 3 remain, packaged as a single
residual `sorry` on the `Localization M ≃ₐ[Γ(S, U)] A_colim`
AlgEquiv.

**Recommended action**: dispatch a prover on `Differentials.lean`
with PROGRESS.md objectives targeting the AlgEquiv construction.
Per the prover task result § "Detailed plan for iter-124", the
residual decomposes into 6 sub-steps (~140-230 LOC total):

- **Step 2a (~30–60 LOC)**: basic-open-cover helper. For every
  `W : Opens S` with `fV ⊆ W`, prove there exists `g ∈ M` with
  `S.basicOpen g ⊆ W ∩ U`. Inputs (all verified iter-121/122):
  `IsAffineOpen.isCompact` (quasi-compactness of `fV`),
  `PrimeSpectrum.isBasis_basic_opens` (basis transport),
  `IsAffineOpen.isLocalization_basicOpen`,
  `IsAffineOpen.basicOpen_eq_iff_isUnit`, `Scheme.basicOpen_appLE`,
  plus the fact that products of units are units (the appLE map is
  a ring homomorphism).

- **Step 2b (~30–50 LOC)**: cocone arm constructor. For each
  `(W, hW : V ⊆ f⁻¹ᵁ W)`, build `arm_W : Γ(S, W) → Localization M`
  via: pick `g` from Step 2a, restrict `Γ(S, W) → Γ(S, S.basicOpen g)`,
  use `IsAffineOpen.isLocalization_basicOpen` to identify the latter
  with `(Γ(S, U))_g`, then apply `IsLocalization.map` for
  `⟨g⟩ ≤ M`. Risk: the choice of `g` depends on `W`, so the arm
  must be well-defined (independent of `g`); resolve via
  `IsLocalization.lift_unique` or `IsLocalization.algHom_subsingleton`.

- **Step 2c (~30–50 LOC)**: cocone naturality. For each morphism
  `(W₁, h₁) → (W₂, h₂)` in `CostructuredArrow (Opens.map f.base).op (op V)`,
  verify the restriction-arm square via `IsLocalization.algHom_subsingleton`.

- **Step 2d (~10–20 LOC)**: assemble the cocone and descend via
  `Functor.descOfIsLeftKanExtension` (with `G := (Functor.const _).obj
  (CommRingCat.of (Localization M))`) — or alternatively `IsColimit.desc`
  via `leftKanExtensionObjIsoColimit`. Evaluated at `op V`, the output
  is the backward map `A_colim → Localization M`.

- **Step 3 (~30–50 LOC)**: inverse identities.
  - `backward ∘ forward = id_{Localization M}` via
    `IsLocalization.ringHom_ext M` — reduces to checking agreement on
    `algebraMap Γ(S, U) (Localization M)`. Both sides send
    `a ↦ algebraMap a` (forward sends to `(appLE_colimRingHom f e).hom a`;
    backward sends via the cocone arm at `op U`, which by Step 2b
    reduces to `a ↦ a` modulo the chosen `g`).
  - `forward ∘ backward = id_{A_colim}` via
    `IsLeftKanExtension.hom_ext_of_isLeftKanExtension` (or
    `IsColimit.hom_ext` on the cocone). Reduces to checking the
    natural-transformation equality at each cocone arm.

- **Step 4 — already in place**: `AlgEquiv.ofRingEquiv` on
  `RingEquiv.ofRingHom forward backward h_fb h_bf`, with the
  algebra-map compatibility witness via `IsLocalization.lift_eq`
  (the recipe sketch is at `Differentials.lean:348-361` comments
  block).

**Tactical playbook** (from iter-123 mathlib-analogist; already applied
iter-122/123 and reusable):
- **Cluster A (Lan `map_comp`)**: pre-prove + `erw` idiom; avoid `set`
  aliases inside the rewrite region. Already used at L234-239 in
  `isUnit_appLE_unitSubmonoid_in_colim`; will recur in Step 2c naturality.
- **Cluster B (IsLocalization shape)**: Step 4 uses
  `IsLocalization.isLocalization_of_algEquiv` — already in place.
- **Cluster C (algebraMap-from-`.toAlgebra`)**: use direct equality
  or `RingHom.algebraMap_toAlgebra` for explicit conversion; avoid
  `change`/`show` on `algebraMap`.
- **Cluster D (unit.naturality cleanup)**: `simpa using (adj.unit.app
  S.presheaf).naturality _` for inner `(𝟭 _).obj` decorations.

**Effort estimate**: 1-2 prover iters, 140-230 LOC. The 6-sub-step
breakdown allows independent sub-progress (e.g. closing Step 2a as a
standalone helper without needing the full backward map).

**Risk profile**: Step 2 is the only step with genuine novelty (no
prior project work uses scheme-theoretic `Functor.descOfIsLeftKanExtension`
or `IsColimit.desc`). If iter-124 stalls on Step 2's cofinality
work — concretely, more than 2 PARTIAL outcomes — fire the STRATEGY.md
2-iter CHURNING trigger and pivot to M2.a per the iter-123
commitment.

### CRITICAL #2 — M3 user escalation surfaced via TO_USER.md (already done)

This review wrote `TO_USER.md` per the iter-123 planner's commitment
(both M3 routes >5000 LOC; user decision required for route pick).
The iter-124 plan agent must:
- Read `USER_HINTS.md` for any user response (route preference,
  permanent-out-of-scope acceptance, or other directive).
- If `USER_HINTS.md` carries a directive, translate into STRATEGY.md
  + PROGRESS.md updates as usual; clear `USER_HINTS.md` after acting.
- If `USER_HINTS.md` is empty, the iter-123 fallback ("continue M1
  roadmap; M3 paused pending user response") remains the iter-124
  action — do NOT preemptively pivot M3 routes.

### CRITICAL #3 — M2.c Galois descent + M2.d-alt cotangent triviality spot-checks

Per the iter-123 STRATEGY.md commitment (strategy-critic challenges
on phantom prereqs), iter-124 plan-phase must dispatch Mathlib
namespace scans on:

- **M2.c Galois descent of morphism equality of schemes**: query
  `lean_leansearch`, `lean_loogle`, `lean_local_search` on
  `AlgebraicGeometry.descent`, `GaloisGroup.descent`, `Scheme.Hom.descend`,
  `algEquiv_descend_of_galois`, similar. Results inform M2.c LOC
  estimate.

- **M2.d-alt abelian-variety cotangent triviality**: query on
  `AbelianVariety.cotangent_trivial`, `Algebra.cotangent_module_iso`,
  `AbelianVariety.tangentBundle_trivial`. Results inform M2.d-alt
  LOC estimate.

These are not blocking iter-124 prover work; they refine the iter-124
plan's STRATEGY.md horizon. Defer the actual M2.a / M2.b prover
work until M1.b closes.

## HIGH — should be acted on this iter or next

### HIGH #4 — Step-2 helper-extraction refactor (discretionary)

Per iter-122 recommendations MEDIUM #6 (still active): if the
iter-124 prover Step 2a stalls on the basic-open-cover helper, or
if Step 2c naturality hits the `((pullback _ _).obj S.presheaf).map`
rewrite blockers documented in PROGRESS.md Cluster A, the next move
is **NOT** another prover round on the same body. Instead, dispatch
a refactor-subagent to break out a named helper lemma (e.g.
`appLE_basicOpen_cover_exists` for Step 2a;
`appLE_cocone_arm_invariant` for Step 2c). Explicit signatures with
`Functor.map_comp`-friendly types avoid the rewriter pitfalls.

**Recommended action**: discretionary; let the iter-124 prover try
Step 2a directly first. If Step 2a stalls in a single iter, fire
the refactor before iter-125.

### HIGH #5 — Tighten Differentials.tex M1.b prose to remove stale closure-lemma hedge

Per `task_results/lean-vs-blueprint-checker-differentials-review123.md`
§ minor #3: the chapter at L165 frames the proof as "two-direction
`IsLocalization.of_le` pattern" and at L175 hedges between
`IsLocalization.of_le` / `isLocalization_of_algEquiv` /
`of_ringEquiv`. The iter-123 plan-phase mathlib-analogist
verified — and the Lean confirms at `Differentials.lean:331` — that
`IsLocalization.isLocalization_of_algEquiv` is the right Step-4
closer (takes `AlgEquiv`, not `RingEquiv`; `of_le` is a different
shape entirely). The hedge could mislead a fresh reader of the
chapter.

**Recommended action**: dispatch a small `blueprint-writer-differentials-iter124`
in plan phase (or the plan agent edits inline as in iter-122) with
directive:
- At L165, replace "two-direction `IsLocalization.of_le` pattern"
  with "two-direction equivalence-based pattern: build forward
  + backward + verify inverse identities + package as `AlgEquiv`
  + conclude via `IsLocalization.isLocalization_of_algEquiv`."
- At L175, drop `IsLocalization.of_ringEquiv` and `IsLocalization.of_le`
  from the closure alternatives; name `IsLocalization.isLocalization_of_algEquiv`
  as the canonical lemma with the AlgEquiv input documented.

**Effort estimate**: 0.1 iter (single small Edit in plan phase).

### HIGH #6 — Add `\lean{...}` references for unreferenced project-level helpers in Differentials.tex

Per `task_results/lean-vs-blueprint-checker-differentials-review123.md`
§ minor #1, #2, #4: the chapter inlines several substantive helpers
without `\lean{...}` references:

- `appLE_unitSubmonoid` (the named submonoid $M$ in chapter prose at L132-L136).
- `isUnit_appLE_unitSubmonoid_in_colim` (the iter-122 Step 0 helper, now a top-level theorem; chapter inlines Step 0 at L167 without naming the Lean decl).
- `appLE_colimRingHom_comp_φV` (the factorisation lemma carrying the cocone-leg triangle identity bridging M1.b → M1.e).

**Recommended action**: bundled with HIGH #5 — same blueprint-writer
dispatch can add the three missing `\lean{...}` sub-blocks. The Step 0
helper specifically should be either a sub-block inside `lem:appLE_isLocalization`'s
proof or its own `\begin{lemma}` block before lem:appLE_isLocalization.

**Effort estimate**: 0.1 iter (combined with HIGH #5).

## MEDIUM — should be acted on within 2-3 iters

### MEDIUM #6 — The "lift_comp + suffices reduction" pattern is reusable; document in Knowledge Base

The iter-123 in-body structural reduction at `Differentials.lean:308-331`
follows a reusable pattern: when a multi-step proof has a forward
direction immediately constructible and steps 2-3 jointly required
to build a single intermediate existential (an iso, AlgEquiv,
LinearEquiv), use `suffices` to reduce to the existential, keeping
the sorry count at exactly 1 and making the closure target explicit.
This pattern is documented in this session's `summary.md` § Key
findings and should be added to the Knowledge Base in `PROJECT_STATUS.md`
this review (see below).

### MEDIUM #7 — Mathlib contribution candidate `KaehlerDifferential.equivOfFormallyUnramified` is still queued

Per iter-122 HIGH #3 + iter-121 mathlib-analogist:
`kaehler_quotient_localization_iso` (`Differentials.lean:330`, fully
proved iter-122) is the most extractable Mathlib contribution candidate
from M1 (candidate name `KaehlerDifferential.equivOfFormallyUnramified`;
candidate home `Mathlib.RingTheory.Kaehler.Basic`). NOT this iter
(M1.b is on the critical path and should land first). After M1.b
closes, the iter-125+ plan can dispatch a follow-up to draft a Mathlib
PR.

## LOW — informational / notes

### LOW #8 — Iter-123 is the second-most-productive M1 iter; CONVERGING ratified

Iter-122 closed Step 0 + 3 of 4 sorry sites of the iter-122 refactor;
iter-123 closes Steps 1 + 4 of the residual body and packages
Steps 2 + 3 into a single sorry with explicit closure recipe in
comments. Net M1.b structural state after iter-123: **5 of 6
substeps closed** (Step 0 + Step 1 + Step 4 + algebra-map compat in
recipe; Step 2 + Step 3 remain). The iter-123 PROGRESS.md framed
"PARTIAL with Step 2 residual only" as the best realistic outcome;
this iter delivered exactly that.

Per the iter-123 progress-critic CHURNING verdict + the iter-123
plan-phase corrective (mathlib-analogist consult + analogist's
tactical APIs delivered + Step 4 closure achieved):
**CHURNING → CONVERGING resolution this iter**. The plan agent
should NOT route-pivot on M1 in iter-124.

### LOW #9 — Search budget was efficient

22 lemma searches across `lean_local_search`, `lean_loogle`,
`lean_leansearch`, and `lean_leanfinder` — 12 hits, 10 misses (the
misses confirm Mathlib gap findings from iter-121/122). The hit
rate was high enough to suggest the analogist's pre-verified
playbook covered the bulk of the prover's needs; iter-124 may
need a similar budget for Step 2's cocone-universal-property work.

### LOW #10 — Iter-123 prover task-result format is exemplary

The iter-123 prover's task result at
`task_results/AlgebraicJacobian_Differentials.lean.md` includes a
full iter-124 closure recipe (the 6-sub-step decomposition), a
negative-search-results block, and an explicit watch-criterion
mapping. This is the gold standard for prover-task-result quality
on multi-iter milestones; future prover dispatches on M2/M3 should
emulate this format.

## Off-limits for iter-124 (already-recorded; reaffirmed)

- `AlgebraicJacobian/Jacobian.lean:179` `nonempty_jacobianWitness` —
  the single foundational existence hypothesis; queued behind M2 +
  M3 per the genus-stratified body restructure plan. M2.a
  Rigidity refactor scheduled iter-125+ (deferred from iter-124 per
  the iter-123 prover lane PARTIAL outcome continuing M1).
- All `Cohomology/*` files (M5-M8 scaffolding) — not active prover
  lanes.
- `Rigidity.lean` — closed; queued for source-side refactor before
  M2.a enters the prover queue.

## Suggested iter-124 plan-phase ordering

1. **Read `USER_HINTS.md`** for any user response to the iter-123
   M3 user escalation. Act per the user directive if present;
   otherwise the iter-123 fallback ("continue M1; M3 paused") is
   the iter-124 action.

2. **Plan-phase critic round**: dispatch `strategy-critic-iter124`
   (re-verification — STRATEGY.md may need updating if the user
   responded on M3; otherwise pass a "no change since iter-123"
   directive), `blueprint-reviewer-iter124` (whole-blueprint audit;
   HARD GATE confirmation), `progress-critic-iter124` (M1 route
   signals: 5 iters of data including this iter's structural
   advance; verdict expected CONVERGING).

3. **Optional iter-124 plan-phase Mathlib spot-checks** (CRITICAL #3
   above): M2.c Galois descent + M2.d-alt cotangent triviality
   namespace scans. Discretionary; can be a single combined
   subagent dispatch ("mathlib-analogist-iter124-phantom-spot-checks").

4. **Optional refactor**: Step-2 helper extraction (HIGH #4 above)
   — discretionary, only if iter-124 prover Step 2a is expected to
   stall.

5. **Prover lane**: PROGRESS.md targets Steps 2 + 3 of
   `appLE_isLocalization` per CRITICAL #1. Decomposed into 6
   sub-steps; the 6-sub-step plan in this recommendations.md +
   the prover task result is the canonical structure. Expected
   outcome PARTIAL (Step 2a + 2b closure; 2c + 2d + 3 residual)
   or COMPLETE if Step 2's cofinality goes smoothly.
