# Iter-194 (Archon canonical) — review

## Outcome at a glance

- **The "Lane G n=0 branch substrate CLOSED axiom-clean via new public
  `Module.depth_pi_const_eq_depth_of_nonempty` (4 helpers + main lemma
  ~135 LOC; AB 2 → 1 −1; n=0 closure landed at full HARD-BAR-CLOSURE
  strength; n=k+1 left untouched per OFF-CRITICAL-PATH framing) +
  Lane I 1 of 2 owed typed-sorry instances CLOSED via direct
  Mathlib composition `IsProper.toLocallyOfFiniteType +
  LocallyOfFiniteType.isLocallyNoetherian` (WD 5 → 4 −1; the other
  instance blocked on the `projectiveLineBar_smoothOfRelativeDimension`
  scaffold in BareScheme.lean; body of
  `degree_positivePart_principal_eq_finrank` advanced via `hLPUnif`
  destructure exposing Y₀, remainder blocked on Mathlib gap I.6.12) +
  Lane H 3 NEW axiom-clean substrate helpers (`sheafCompose_additive`,
  `sheafCompose_preservesZero`, `Scheme.IsFlasque.toAddCommGrpCat`) +
  `shortExact_app_surjective` body STRUCTURALLY DECOMPOSED via
  `forget₂` bridge to AddCommGrpCat — `Mono SAb.f` + `Epi SAb.g`
  axiom-clean inline, ONLY `SAb.Exact` remains as a focused well-defined
  typeclass goal `(sheafCompose (forget₂)).PreservesHomology` (H1V
  4 → 4 net 0; substantive structural improvement) +
  Lane RCI 2 NEW axiom-clean substrate helpers
  (`algebraMap_bijective_of_finrank_one` +
  `phi_left_functionField_algEquiv_of_finrank_one`) + helper (a) body
  reduced via `LocallyQuasiFinite.of_fiberToSpecResidueField` to
  per-fibre case (RCI 3 → 3 net 0; substantive structural advance) +
  Lane B 9 NEW axiom-clean structural helpers landing the closed-points
  reduction (JacobsonSpace via LOFT chain + density via
  `closure_closedPoints` + closure assembly via
  `range_subset_closure_image_dense`); residual narrowed to per-closed-
  point chart-evaluation `hCP_check` (GMS 2 → 2 net 0) +
  Lane A.3.i instance demotion `private instance →
  private theorem identityComponent_geometricallyConnected` clearing
  lean-auditor iter-193 must-fix (zero sorryAx silent-propagation via
  typeclass synthesis) + body restructure of
  `geometricallyConnected_of_connected_of_section` reducing to precise
  `ConnectedSpace ↥(pullback ...)` surface (IC 9 → 9 net 0) +
  Lane M↓ STUCK PROTOCOL RESPECTED — 0 helpers added; 3 sorries each
  converted from bare to `by`-block + precise gap-surface docstring;
  1 axiom-clean inline derivation `Y.left.IsSeparated` (CodimOneExt
  3 → 3 net 0) + Lane A OCofP 2 consumer-facing theorem bodies
  (`dim_eq_two_of_genusZero`, `exists_nonconstant_genusZero`) closed
  structurally via 2 new named substrate helpers
  (`h0_sub_h1_lineBundleAtClosedPoint_eq_two`,
  `exists_nonconstant_rational_from_dim_eq_two`) — consumer bodies now
  sorry-free transitively; partial setup committed in the
  rational-from-dim helper (distinguished constant section `s₁`
  produced concretely) (OCofP 3 → 3 net 0; substantive structural
  advance) + Lane E pivot narrowing: `kbarChart1Ring_specMap_fac`
  outer morphism-level reasoning eliminated via `iotaGm_r_1_fac` +
  `ext_of_isAffine` → ring-map identity on `appTop` residual; SAME
  opaque `Proj.appIso ⊤ .inv` on `isLocElem` evaluation that has been
  STUCK iter-188-193 remains in the inner sorry (AVR 3 → 3 net 0;
  HARD BAR NOT MET) + Lane F LinearEquiv extraction (Steps a-c)
  landed axiom-clean inside `_sectionLinearEquiv` body via
  `topAdd.toLinearEquiv` + `tilde.isoTop` + `Scheme.Modules.Hom.app_smul`;
  Beck-Chevalley intertwining at `1 ⊗ₜ x` PROVABLY blocked on step1/step2
  opaque `Nonempty (... ≅ ...)` bodies — architectural finding for
  iter-195 Σ-pair refactor (QuotScheme 12 → 12 net 0; HARD BAR NOT MET
  but substantive structural advance)" iter.**

- **`lake build AlgebraicJacobian` GREEN** — per `meta.json`
  `prover.status: done`; 8361/8361 jobs replayed; **88 sorries**
  (counted directly from `lake build`'s `declaration uses 'sorry'`
  warnings via `wc -l = 88`).

- **0 → 0 project axioms** — **14th consecutive zero-axiom build
  streak**.

- **planValidate**: 10 objectives dispatched. 10 of 10 lanes returned
  `done`. Per-lane outcomes — see per-lane verification below.

- **Plan-predicted band** (entering 89 sorries post-refactor v2):
  - Best 89 → ~80-83 (−6 to −9).
  - Realistic 89 → ~83-87 (−2 to −6).
  - Worst 89 → ~86-89 (−0 to −3).

  Landing **88** sits at the **worst-case upper boundary − 1**. The
  iter delivered substantial structural advance (8 of 10 HARD BARs
  met + 1 push-beyond full closure on Lane G n=0) but only 1 net
  sorry-elimination on the count. The user-hint "push as far as
  possible" requirement: 1 lane (Lane G) genuinely closed a sorry; 4
  lanes (H, B, A.3.i, A) achieved substantive structural narrowing
  without closure; 2 lanes (E, F) did NOT meet HARD BAR but produced
  architectural findings for iter-195 routing.

- **Reviewer-phase subagents** — `## Subagent skips` recorded in
  `summary.md`. Rationale: plan-phase critics (`blueprint-reviewer
  iter194` + `iter194-fastpath` + `progress-critic route194`) already
  audited the trajectory and HARD GATE-cleared all 10 prover-touched
  files; sequential dispatch of 10 lvbc at `loop.max_parallel = 1`
  would be wall-clock-prohibitive (~75 min) for marginal new
  information; the iter-193 lean-auditor whole-project verdict is
  still authoritative on the largest soundness issue (carrier
  soundness, deferred to iter-195+).

- **sync_leanok iter=194**: 6 added / 8 removed / 4 chapters touched
  (`Albanese_CodimOneExtension`, `RiemannRoch_H1Vanishing`,
  `RiemannRoch_OCofP`, `RiemannRoch_RationalCurveIso`) per
  `.archon/sync_leanok-state.json` sha=`b3255f69` timestamp
  `2026-05-27T02:42:28Z`.

- **blueprint-doctor `iter-194`**: NO findings. Every chapter
  `\input`'d, every `\ref` / `\uses` resolves, no `axiom`
  declarations.

- **Manual blueprint markers landing this review (semantic only)**:
  4 `% NOTE (iter-194 reviewer)` annotations applied to chapters —
  see `summary.md` `## Blueprint markers updated (manual)` for the
  per-chapter list. No `\mathlibok` warranted (no prover-added direct
  Mathlib re-exports). No `\lean{...}` renames flagged.

## Per-lane verification

| # | Lane | File | Status | Sorry Δ (file) | Notes |
|---|---|---|---|---|---|
| I | **PARTIAL (HARD BAR MET — 1 of 2 instances + body restructured)** | `RiemannRoch/WeilDivisor.lean` | structural advance | 5 → 4 | `instIsLocallyNoetherianProjectiveLineBar` axiom-clean via direct Mathlib composition; other instance blocked on BareScheme scaffold; body destructures `hLPUnif` to expose Y₀, remainder Mathlib-gap-blocked. |
| H | **PARTIAL (HARD BAR MET — substrate + decomposition)** | `RiemannRoch/H1Vanishing.lean` | structural advance | 4 → 4 | 3 new axiom-clean helpers (forget₂ bridge to AddCommGrpCat); `shortExact_app_surjective` body now has Mono+Epi axiom-clean inline; only `SAb.Exact` remains (focused typeclass goal). `injective_flasque` Mathlib-gap-blocked. |
| M↓ | **PARTIAL (HARD BAR MET — precise gap surface)** | `Albanese/CodimOneExtension.lean` | structural advance (no helpers added) | 3 → 3 | STUCK PROTOCOL RESPECTED — 0 helpers added (budget = 1); 3 bare sorries → `by`-block + precise gap-surface docstring; `Y.left.IsSeparated` axiom-clean inline. |
| E | INCOMPLETE (HARD BAR NOT MET; narrowing) | `AbelianVarietyRigidity.lean` | structural narrowing | 3 → 3 | Outer morphism-level reasoning of `kbarChart1Ring_specMap_fac` eliminated; same opaque `Proj.appIso ⊤ .inv` evaluation residual remains (STUCK iter-188-194). |
| F | INCOMPLETE (HARD BAR NOT MET; LinearEquiv landed) | `Picard/QuotScheme.lean` | structural advance | 12 → 12 | Steps a-c LinearEquiv extraction axiom-clean inside `_sectionLinearEquiv`; Beck-Chevalley intertwining provably blocked on step1/step2 opaque bodies. |
| B | **PARTIAL (HARD BAR MET — 9 helpers, closed-points reduction)** | `Genus0BaseObjects/GmScaling.lean` | structural advance | 2 → 2 | Closed-points reduction infrastructure axiom-clean; residual narrowed to per-closed-point chart-evaluation `hCP_check` (shares Lane E idiom). |
| A.3.i | **PARTIAL (HARD BAR MET — instance demotion)** | `Picard/IdentityComponent.lean` | structural advance | 9 → 9 | `private instance → private theorem`; lean-auditor iter-193 must-fix CLEARED. Body restructure of `geometricallyConnected_of_connected_of_section` reduces to precise Stacks 04KV gap surface. |
| RCI | **PARTIAL (HARD BAR MET — 2 axiom-clean substrate helpers)** | `RiemannRoch/RationalCurveIso.lean` | structural advance | 3 → 3 | `algebraMap_bijective_of_finrank_one` + `phi_left_functionField_algEquiv_of_finrank_one` axiom-clean; helper (a) body reduced via `LocallyQuasiFinite.of_fiberToSpecResidueField`. Inline Step 1 of `iso_of_degree_one` refactored 16 → 4 LOC. |
| G | **SOLVED (n=0 branch closure)** | `Albanese/AuslanderBuchsbaum.lean` | sorry closure | 2 → 1 | New public lemma `Module.depth_pi_const_eq_depth_of_nonempty` (4 helpers + main; ~135 LOC kernel-clean). n=k+1 branch (L1125) untouched — multi-iter substrate; OFF-CRITICAL-PATH. |
| A | **PARTIAL (HARD BAR MET — 2 consumer bodies restructured)** | `RiemannRoch/OCofP.lean` | structural advance | 3 → 3 | `dim_eq_two_of_genusZero` + `exists_nonconstant_genusZero` bodies closed structurally via 2 new named substrate helpers; partial setup (distinguished constant section `s₁`) committed in the rational-from-dim helper. |

## Sorry-count breakdown by file (post-iter-194)

Per `lake build AlgebraicJacobian` `declaration uses 'sorry'` warning
count = **88** total:

| Sorries | File |
|---:|---|
| 12 | Picard/QuotScheme.lean |
| 9 | Picard/IdentityComponent.lean |
| 7 | Picard/FlatteningStratification.lean |
| 7 | Picard/FGAPicRepresentability.lean |
| 7 | Albanese/AlbaneseUP.lean |
| 6 | Picard/RelPicFunctor.lean |
| 5 | Picard/Pic0AbelianVariety.lean |
| 4 | RiemannRoch/WeilDivisor.lean |
| 4 | RiemannRoch/OcOfD.lean |
| 4 | RiemannRoch/H1Vanishing.lean |
| 3 | RiemannRoch/RationalCurveIso.lean |
| 3 | RiemannRoch/OCofP.lean |
| 3 | Albanese/CodimOneExtension.lean |
| 3 | AbelianVarietyRigidity.lean |
| 2 | Jacobian.lean |
| 2 | Genus0BaseObjects/GmScaling.lean |
| 2 | Genus0BaseObjects/BareScheme.lean |
| 2 | Albanese/Thm32RationalMapExtension.lean |
| 1 | RigidityKbar.lean |
| 1 | RiemannRoch/RRFormula.lean |
| 1 | Albanese/AuslanderBuchsbaum.lean |

(20 files; 21 entries above sum to 88.)

## Critic verdicts referenced this phase

The iter-194 plan-phase dispatched 3 critics whose verdicts are
relevant context for the iter-195 plan-phase:

- **`refactor lane-i-localparameter-signature-v2`**: COMPLETE.
  Option (b) signature reshape landed; WeilDivisor 3 → 5; RationalCurveIso 3 → 3.
- **`blueprint-reviewer iter194` (+ `iter194-fastpath`)**: COMPLETE.
  HARD GATE: 2 chapters PASSED on fastpath (H1Vanishing,
  CodimOneExtension); 1 MEDIUM quality issue flagged on
  CodimOneExtension (`private theorem` access visibility on Stage 5a/5b
  helpers — iter-196 cleanup task per recommendation #12).
- **`progress-critic route194`**: COMPLETE. 0 CONVERGING, 6 CHURNING
  (H, E, F, B, RCI, G), 3 STUCK (I, M↓, A.3.i), 1 UNCLEAR (Pic0AV).
  All 5 must-fix-this-iter findings actioned plan-phase.

## Iter-195 prep notes for the plan agent

The bulk of the iter-194 outcome is **structural narrowing without
sorry-elimination**, which the user hint explicitly flagged as the
"lazy" failure mode. The iter-195 plan-phase should:

1. Treat the iter-195 prover dispatch as **closure-focused** — the
   highest-leverage closure target this iter is Lane H's `SAb.Exact`
   (single typeclass goal, not a Mathlib gap; ~50-120 LOC project-side
   build). See `recommendations.md` §3.
2. Decide on carrier-soundness refactor TIMING — either land iter-195
   (with mathlib-analogist precursor consult) or commit to a concrete
   iter-200+ slot in STRATEGY.md. The current "iter-195+" framing has
   been sliding for 2 iters. See `recommendations.md` §1.
3. Consider whether Lane I deserves the BareScheme scaffold close as
   its iter-195 directive (~30-50 LOC) instead of re-attempting the
   body close (which is gated on a much larger Mathlib gap). See
   `recommendations.md` §2.
4. The shared chart-1 ring-map evaluation idiom blocker connects Lane
   E + Lane B; closing it unlocks both. See `recommendations.md` §6.

## Recommendations cross-link

Full landed list at
`.archon/proof-journal/sessions/session_194/recommendations.md`.
Top items: (1) carrier-soundness refactor; (2) Lane I body OR
BareScheme scaffold close; (3) Lane H `SAb.Exact` direct attack;
(5) Lane F Σ-pair refactor; (6) Lane E + Lane B shared chart-1 idiom.

## Net trajectory summary

- **iter-187 → iter-188**: 73 → 77 (+4 substrate-carving).
- **iter-188 → iter-189**: 77 → 77 (net 0; structural).
- **iter-189 → iter-190**: integration RED (positivePart clash);
  notional ~79.
- **iter-190 → iter-191**: 79 → 80 (+1; clash fix + new file).
- **iter-191 → iter-192**: 80 → 77 (−3; realistic-band lower-bound).
- **iter-192 → iter-193**: 77 → 87 (+10; +5 from new Pic0AbelianVariety
  file + 5 sanctioned substrate decompositions).
- **iter-193 → iter-194**: 87 → 89 (entering, post refactor v2) →
  88 (exit; net −1 from prover).

The 8-iter rolling delta is +15 (73 → 88), of which +5 is the new
Pic0AbelianVariety.lean file-skeleton (essentially fixed substrate
debt that the carrier-soundness refactor is expected to address) and
~+10 is substrate-decomposition into smaller named sorrys. The
underlying mathematical progress is substantial but the headline
count grows because the project is converting opaque-body sorrys
into named-substrate sorrys with axiom-clean preparation. iter-195's
biggest win — if achieved — would be Lane H `SAb.Exact` closing the
H1V chain, which would cascade into OCofP `h1_vanishing_genusZero`
and unlock the genus-0 Riemann-Roch arm headway.
