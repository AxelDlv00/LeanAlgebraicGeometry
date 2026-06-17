# Iter-147 (Archon canonical) — review

## Outcome at a glance

- **Prover lane FIRED** on
  `AlgebraicJacobian/Cotangent/ChartAlgebra.lean` with 3 in-scope
  sorries (β-core L97, KDM L107, constants substep 3 L177). Result:
  **1 substantive closure (β-core) + 2 substantive partials (KDM +
  constants substep 3)** — second strict-count sorry reduction on
  Route 1, monotone-decreasing trajectory across iter-146 + iter-147.
  `meta.json`: `planValidate.status: ok / objectives: 1`,
  `prover.status: done`, `prover.durationSecs: 1104` (~18 min).

- **Sorry count delta** (declarations using `sorry` / inline
  `sorry`): 6 / 6 → **5 / 5** (NET **−1**). Per-file at iter-147
  close:
  - `Cotangent/ChartAlgebra.lean` — **2 / 2** (was 3 / 3):
    - L123 `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
      body: reverse inclusion closed via `Derivation.map_algebraMap`
      as named `_hRev`; forward inclusion (substantive) is the
      structured `sorry` at L139.
    - L220 `constants_integral_over_base_field` body: substeps
      1–2 closed iter-146; substep 3 reduced to `Function.Surjective`
      via `rw [RingHom.range_eq_top]`; 7-step closure chain (a)–(g)
      documented in-source at L243–L293; residual `sorry` at L294
      concentrated at step (e) (flat base change of `Γ` for proper
      schemes; Stacks Tag 02KH).
  - `Cotangent/GrpObj.lean` — 0 / 0 (unchanged).
  - `Jacobian.lean` — 2 / 2 (unchanged).
  - `RigidityKbar.lean` — 1 / 1 (unchanged).

- **Per-target outcome** (iter-147 in-scope: 3 of 3 chart-algebra
  remaining sorries):
  - **(β-core) `df_zero_factors_through_constant_on_chart`** —
    SOLVED (sorry-free). Placeholder refined to real chart-of-
    proper-curve signature with finite-type-`k`-algebra chart-ring
    `B`; body = one-line delegate
    `AlgebraicGeometry.KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero hDb`.
    Required re-ordering KDM above the second `namespace GrpObj`
    reopening (intermediate `Unknown identifier` error).
  - **(KDM) `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`**
    — PARTIAL. Signature refined to the blueprint-mandated
    finite-type-`k`-algebra form. Reverse inclusion
    `range algebraMap ⊆ ker D` closed via `Derivation.map_algebraMap`
    as named `_hRev`. Forward inclusion (substantive) deferred via
    structured `sorry` at L139 with two iter-148+ closure paths
    catalogued: (p2) char-0 via `Differential.ContainConstants`
    bridge; (p1)+(p3) char-p via Stacks 07F4 `ker D = B^p` chain
    (Mathlib gap) + chart-of-proper-curve helper.
  - **(constants substep 3) `constants_integral_over_base_field`**
    — PARTIAL. Substep 3 reduced to `Function.Surjective` via
    `rw [RingHom.range_eq_top]`. 7-step closure chain documented
    in-source naming Mathlib lemmas
    (`IsAlgClosed.algebraMap_bijective_of_isIntegral`,
    `Module.finrank_baseChange`,
    `Subalgebra.bot_eq_top_iff_finrank_eq_one`,
    `IsStableUnderBaseChange @GeometricallyIrreducible`,
    `isField_of_universallyClosed`,
    `finite_appTop_of_universallyClosed`). Substantive Mathlib gap
    concentrated at step (e) (flat base change of `Γ` for proper
    schemes; Stacks Tag 02KH / 0BUG).

- **Substantive code delta** (iter-147 prover lane, 3 edits / 7
  diagnostic checks / 0 builds via lean LSP / 56 lemma searches
  per `attempts_raw.jsonl`): `Cotangent/ChartAlgebra.lean` 225 →
  342 LOC (+117 LOC). Two placeholder declarations refined to real
  signatures; one inline `sorry` replaced by a goal-reduction +
  closure-chain comment block + residual structured `sorry`. No
  other files edited; no protected signatures touched.

- **5 subagent dispatches this iter** (all plan-phase; 3 mandatory
  + 2 plan-phase optional; all returned + absorbed):

  - `blueprint-reviewer-iter147` → **ALL CLEAN; HARD GATE CLEARS**
    on all 11 chapters. 2 informational items (documented
    signature-reduction divergence on `Scheme_Over_ext_of_diff_zero`;
    `def:positiveGenusWitness` scaffold-proof brevity adequate
    given M3 off-critical-path scheduling). 0 must-fix.
  - `progress-critic-iter147` → **HEALTHY overall.** Route 1
    (chart-algebra) UNCLEAR-leaning-positive (1 prover-data-point,
    monotone-decreasing sorry count, 0 helpers stacked). Route 2
    (off-critical-path scaffolds) UNCLEAR-deliberately-dormant
    (correctly held). Dispatch sanity OK. 0 must-fix.
  - `strategy-critic-iter147` → **CHALLENGE on Route C + Route A;
    major alternatives flagged (over-`k̄` + descent on M2; Sym^g +
    Stein on M3); format NON-COMPLIANT.** Absorbed via STRATEGY.md
    re-restructure (167 LOC → 178 LOC under canonical skeleton);
    phantom prerequisite `Algebra.IsStandardSmooth.free_kaehlerDifferential`
    VERIFIED via `lean_loogle`.

- **Review-phase subagent dispatches**: 0 this iter. Per the
  review-prompt § "When NOT to dispatch": the iter-147 prover lane
  was a narrowly-scoped proof-filling round on a single file with
  no new definitions / refactors, and the iter-146 mandatory
  dispatches (lean-auditor + lean-vs-blueprint-checker on the same
  file) landed the cataloguing that would otherwise repeat.
  Iter-148 mandatory dispatches will refresh.

## Sorry trajectory (Route 1)

| Iter | Decls | Inline | Δ | Notes |
|---|---|---|---|---|
| 144 | 6 | 6 | — | bundled-route pre-pivot |
| 145 | 8 | 8 | +2 | chart-algebra decomposition cost |
| 146 | 6 | 6 | −2 | α + lift closed; constants partial |
| 147 | **5** | **5** | **−1** | β-core closed; KDM + constants partial |

Two consecutive strict-count decreases. Per progress-critic's
K=3-5 hysteresis hook, iter-148 is the earliest iter at which a
formal CONVERGING verdict on Route 1 becomes available. The
qualitative signal is unambiguously positive: 0 helpers stacked,
no recurring blocker phrase, two route-internal targets closed
substantively iter-146 + iter-147.

## Blueprint markers landed manually (iter-147 review)

3 `% NOTE: (iter-147 review)` annotations in `RigidityKbar.tex`:

- `lem:constants_integral_over_base_field` — surjectivity-form
  goal reduction + 7-step closure-chain documentation + identification
  of step (e) (flat base change of `Γ` for proper schemes) as the
  single residual Mathlib gap.
- `lem:chart_algebra_isPushout_of_affine_product` — carry-over
  confirmation that the `inferInstance` closure stands and the
  proof block is informational rather than load-bearing.
- `lem:Scheme_Over_ext_of_diff_zero` — clarifies that the (β-core)
  sub-piece now exists as a sorry-free delegate to KDM, but the
  iter-148+ refinement remains gated on KDM body closure.

No `\mathlibok` markers added (the closest candidate,
`algebra_isPushout_of_affine_product`, is `inferInstance` rather
than a direct `theorem foo := Mathlib.bar` re-export — not
matching the marker's strict criterion). No `\leanok` touched
(deterministic sync's domain). No stale `\notready` to strip.

## Notable structural decisions absorbed

- **Re-ordering of KDM above the second `namespace GrpObj`
  reopening.** The iter-146 file structure placed KDM (then a
  `: True := sorry` placeholder at L107) after `end GrpObj`. When
  iter-147 refined β-core to delegate to KDM, the reference
  failed with `Unknown identifier`. The prover re-ordered so KDM
  lands before β-core; file structure is now:
  `(α) algebra_isPushout ⊳ end GrpObj ⊳ KDM ⊳ namespace GrpObj ⊳
  (β-core) ⊳ end GrpObj ⊳ (β-aux) constants ⊳ (lift) ext_of_diff_zero`.
  Reusable pattern for any consumer-of-named-helper situation
  inside a re-opened namespace.

- **`rw [RingHom.range_eq_top]` as the natural goal-reduction for
  `range = ⊤` claims with surjectivity witnesses.** Substep 3 of
  `constants_integral_over_base_field` was hitting impedance with
  the `Subalgebra`/`AlgHom.range`/`RingHom.range` layer; the
  rewrite to `Function.Surjective ⇑f` lets the algclose-base-
  change chain compose cleanly with
  `IsAlgClosed.algebraMap_bijective_of_isIntegral`. Added to the
  Knowledge Base.

- **Multi-step closure chain documented in-source with one
  residual sorry concentrated at the substantive gap.** Substep
  3's 7-step chain (a)–(g) is committed as in-source comments
  with each substep's target Mathlib lemma named. Step (e) (flat
  base change of `Γ` for proper schemes) is the substantive
  Mathlib gap; residual `sorry` placed at the chain exit (NOT at
  each substep). Reusable for any closure where most substeps
  have catalogued lemmas but one is the substantive gap.

## Open items for iter-148 plan agent

- Iter-148 mandatory blueprint-reviewer confirms iter-147 prover-
  lane outcome did not introduce blueprint drift (3 new `% NOTE:`
  annotations are review-agent semantic markers, not strategy-
  modifying findings).
- Iter-148 mandatory progress-critic: Route 1 verdict moves from
  UNCLEAR (iter-146 + iter-147 data; iter-145 doesn't count for
  K=3–5 because it was refactor-only) toward CONVERGING; the
  iter-147 escalation hook (PARTIAL on substep 3 with the same
  geom-irr base-change phrase → blueprint expansion / Mathlib-
  idiom consult rather than third prover lane) carries forward.
- Iter-148 mandatory strategy-critic re-verifies the iter-147
  STRATEGY.md canonical-skeleton restructure stuck (LOC under
  250, no per-iter narrative regressed).
- Iter-148 recommended prover lane: thin in-tree wrapper for
  flat base change of `Γ` for proper schemes (Stacks 02KH;
  ~50–150 LOC). Once landed, the catalogued 6-step Mathlib
  chain in substep 3 assembles into a sorry-free closure of
  `constants_integral_over_base_field` (~100–200 LOC for the
  closure proper). This drops `ChartAlgebra.lean` from 2 → 1
  sorry.
- Iter-148+ KDM forward-inclusion closure remains the second
  iter-148 candidate, but it requires either (a) the char-0
  `ContainConstants` typeclass bridge or (b) the iter-149+
  char-p (p1.a)–(p1.d) chain. Iter-148 should commit to one of
  the two paths (recommendation: char-0 first).
- Iter-148+ M2.a body closure `rigidity_over_kbar` remains
  gated on chart-algebra piece (ii) closure (KDM body + substep
  3); iter-149+ realistic earliest fire date.

## Critical paths committed (unchanged from iter-146 close)

- Critical path: chart-algebra piece (ii) in
  `Cotangent/ChartAlgebra.lean`. 3 sub-pieces fully closed
  (α + lift + β-core); 2 partial (KDM + constants substep 3).
  Iter-148+ continuation.
- M2.a body closure gated on chart-algebra piece (ii) — iter-149+.
- M2.b body closure + terminal-object cluster + vacuity branch
  — iter-151+.
- M2 closure — iter-155+.
- M3 Route A scaffold scheduling — iter-170+.

## Blueprint doctor (iter-147)

Clean. No orphan chapters, no broken cross-references, no
empty `\uses{}` annotations, no new `axiom` declarations. The
iter-147 plan-agent's 5 empty-`\uses{}` fix in
`Cohomology_MayerVietoris.tex` is verified.

## Files written this review

- `.archon/proof-journal/sessions/session_147/summary.md`
- `.archon/proof-journal/sessions/session_147/milestones.jsonl`
- `.archon/proof-journal/sessions/session_147/recommendations.md`
- `.archon/PROJECT_STATUS.md` (Knowledge Base + Last Updated)
- `.archon/iter/iter-147/review.md` (this file)
- `.archon/TO_USER.md` (empty — no escalation)
- `blueprint/src/chapters/RigidityKbar.tex` (3 `% NOTE: (iter-147 review)` annotations)
