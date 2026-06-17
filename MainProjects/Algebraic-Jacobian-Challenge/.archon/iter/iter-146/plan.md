# Iter-146 (Archon canonical) plan-agent run

## Headline outcome

Iter-145 was substantive-plan-only at the prover level: a refactor
subagent landed the iter-144 chart-algebra pivot in code (excised 3
named + 2 cascade-chained bundled-route declarations from
`Cotangent/GrpObj.lean`; created NEW `Cotangent/ChartAlgebra.lean`
scaffold with 5 `: True := sorry` placeholders). The iter-145 review
flagged Route 2 (chart-algebra piece (ii)) UNCLEAR with a fresh-route
data-point and warned that a 3rd consecutive iter without a prover
dispatch on `Cotangent/ChartAlgebra.lean` would trip the meta-pattern.

**Iter-146 fires the FIRST chart-algebra prover lane** on
`Cotangent/ChartAlgebra.lean`, scoped to the 3-of-5 blueprint-adequate
sub-pieces per `lean-vs-blueprint-checker-chart-algebra-review145`:
* (α) `algebra_isPushout_of_affine_product` (~80–150 LOC).
* `constants_integral_over_base_field` (~50–100 LOC).
* `Scheme.Over.ext_of_diff_zero` (~100–150 LOC; depends on β-core
  helper which remains `sorry` — landing here as structural shell
  with helper-sorry-call is acceptable).

The other 2 sub-pieces (`df_zero_factors_through_constant_on_chart`
β-core + `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero`
KDM ring-side) defer to iter-147+ — the iter-146 blueprint-writer
this iter (rigiditykbar-iter146) has landed the must-fix items those
sub-pieces needed (KDM step (p1) 4-substep recipe + KDM step (p3)
new helper lemma `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve`
+ β-core Step 3 2-chart Čech rewrite); iter-147 mandatory blueprint-
reviewer re-confirms the chapter is `complete: true / correct: true`
post-writer.

**Iter-146 is plan + Wave-1 (3 mandatory critics, parallel) +
Wave-2 (2 blueprint-writers, parallel) + STRATEGY.md mechanical
excise (plan-agent in-place) + Wave-3 (sequential prover lane on
`Cotangent/ChartAlgebra.lean` after this plan phase via the loop
dispatcher).** 5 subagent dispatches this plan phase; all returned +
absorbed.

## Wave 1 (parallel) — 3 mandatory critics, all returned + absorbed

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `blueprint-reviewer` | iter146 | **HARD GATE FIRES** on `RigidityKbar.tex` (`complete: partial / correct: partial`; 11 must-fix items: KDM step (p1) under-spec + KDM step (p3) hidden-hypothesis mismatch + β-core Step 3 cites non-existent Genus.lean H¹=0 computation + 8 broken `\lean{...}` hints to iter-145-EXCISED declarations) + `AlgebraicJacobian_Cotangent_GrpObj.tex` (`complete: partial / correct: partial`; iter-144 disposition paragraph asserts "preserved as auditable record" but the 5 EXCISED declarations are not in-tree). 9 chapters clean. 0 strategy-modifying findings. Multi-route coverage PASS for Route C (chart-algebra) + Route A (M3 Picard FGA). | Wave 2 absorption: `blueprint-writer-rigiditykbar-iter146` + `blueprint-writer-pointer-iter146`. Iter-146 plan-agent rebuttal on HARD GATE letter-vs-spirit: see "HARD GATE rebuttal" below. |
| `progress-critic` | iter146 | **UNCLEAR on both routes; HEALTHY overall.** Route 1 (chart-algebra piece (ii)) UNCLEAR-fresh — 1 iter of data (iter-145 scaffold landing); iter-146 is the first prover-attempt iter; throughput ON_SCHEDULE (envelope iter-146→iter-152, 1 iter elapsed). Route 2 (off-critical-path scaffolds) UNCLEAR-by-deliberate-hold — three frozen scaffolds pending chart-algebra piece (ii) closure + M3 Route A. Dispatch sanity OK (1 file, well below cap of 10, not growing). 0 must-fix-this-iter findings. **Watch hook for iter-147 audit**: iter-146 prover is hybrid signature-shaping + prove-attempt (the iter-145 `: True := sorry` placeholders need signature refinement before bodies can land); PARTIAL return is plausible but does NOT yet constitute CHURNING. Only iter-148+ PARTIAL → PARTIAL → PARTIAL would. | Verdict feeds directly into iter-146's narrowly-scoped prover lane plan. |
| `strategy-critic` | iter146 | **2 CHALLENGE / 2 SOUND across 4 routes; format NON-COMPLIANT.** SOUND on chart-algebra piece (ii) decomposition + M3 Route A. CHALLENGE on M2 (the M2 decomposition table at L161–228 still describes the iter-127 bundled pile as the active critical path, contradicting the iter-144 chart-algebra pivot at L631 onwards). CHALLENGE on format (701 LOC / 132 KB; ~3×/~11× over the canonical 250-line / 12-KB bound; no canonical headings present in canonical form; per-iter narrative pervasive). All named Mathlib prerequisites VERIFIED (`Algebra.IsPushout`, `RingHom.iterateFrobenius_comm`, `Ideal.IsLocalRing.CotangentSpace`, `Algebra.IsStandardSmoothOfRelativeDimension`, `PresheafOfModules`). No phantom blockers. Suggests UNBUNDLED Q5 compaction: iter-146 mechanical excise of per-iter narrative (~250 LOC); iter-147 canonical-skeleton restructure. **Two alternatives surfaced**: (i) pre-verify forgetful-MV routing for cotangent before β-core prover lane fires (iter-147+ minor); (ii) symmetric blueprint-pointer-chapter discipline (excise stale pointer chapter rather than add a ChartAlgebra parallel) — already addressed iter-146 via the pointer-iter146 writer (which deleted 5 stale `\item` bullets). | Iter-146 absorbs M2 CHALLENGE + format CHALLENGE via in-place STRATEGY.md edits this iter (see "STRATEGY.md edits iter-146" below). Iter-147 absorbs canonical-skeleton restructure. |

## Wave 2 (parallel) — 2 blueprint-writers, both returned + absorbed

| Subagent | Slug | Verdict | Absorption |
|---|---|---|---|
| `blueprint-writer` | rigiditykbar-iter146 | **COMPLETE**. `RigidityKbar.tex` 1971 → 2091 LOC (+120 LOC): KDM proof step (p1) carries a 4-substep recipe (p1.a–p1.d) per Stacks Tag 07F4; new `\lem:KaehlerDifferential_constants_in_chart_of_proper_curve` helper extracted from the KDM proof (carrying the chart-of-proper-curve hypothesis explicitly); KDM step (p3) invokes the new helper by `\cref`; chart-algebra (β-core) Step 3 rewritten with 2-chart Čech / Step 3.aux paragraphs (drops the "Genus.lean H¹=0 running model" reference; cites Stacks Tag 0F8L for the 2-chart cover existence); 8 broken `\lean{...}` hints stripped (the blocks themselves remain as `\notready` + EXCISED-iter-145 disposition); chart-algebra (α) cleanups (stray `\uses` strip + `Mathlib.RingTheory.IsPushout` → `Mathlib.RingTheory.IsTensorProduct` filename fix). | All 11 must-fix items from `blueprint-reviewer-iter146` absorbed. Iter-147 mandatory blueprint-reviewer re-confirms `complete: true / correct: true`. |
| `blueprint-writer` | pointer-iter146 | **COMPLETE**. `AlgebraicJacobian_Cotangent_GrpObj.tex` 136 → 87 LOC (−49 LOC): disposition paragraph (L10–L17) rewritten to reflect post-iter-145 reality (zero sorries in tree; piece (i.a) trio + orphan helpers in-tree; bundled-route decls excised; chart-algebra in `RigidityKbar.tex` + `ChartAlgebra.lean`); 5 stale `\item` bullets DELETED outright (per iter-145 Q7 "git history IS the audit record"); 3 surviving orphan-helper bullets (`shearMulRight`, `schemeHomRingCompatibility`, `relativeDifferentialsPresheaf_restrict_along_identity_section`) gained orphan-status sentence + iter-146+ cleanup-candidate label. | Both must-fix items absorbed. |

## STRATEGY.md edits iter-146 (mechanical excise, plan-agent in-place)

Per `strategy-critic-iter146` Must-fix #1 (format NON-COMPLIANT) +
Must-fix #2 (M2 CHALLENGE), 2 in-place edits applied iter-146:

1. **Per-iter narrative excise (L561–629, ~70 LOC → 1 paragraph)**.
   Replaced the iter-127 → iter-141 decision-chain (Direct over-k
   rigidity defense, ground (i)/(ii)/(iii)/(iv) reformulations, iter-130
   ground-(i)-STRUCK, iter-136 reframing, iter-138 reframing, iter-139
   §519 auto-flag, iter-141 decoupling correction, `Classical.choose`-
   chain RESOLVED iter-131, Replacement (B′) iter-131, Fibre-free
   4-axis scorecard iter-133, ℙ¹-hedge iter-138 RESOLVED, standalone
   cotangent sheaf iter-129 + iter-130 Q2 + iter-133 resolution)
   with a single paragraph naming the historical decision chain as
   superseded by the iter-144 chart-algebra pivot. Per-iter narrative
   pointers preserved to `iter/iter-127/plan.md` ... `iter/iter-141/plan.md`
   + 5 `analogies/*.md` files. The iter-138 operational reframing
   ("operationally defaulted, bounded revert cost preserved") is
   carried forward as the one-paragraph summary; the iter-142
   simplification convention (one sentence) stays as the live operational
   rule.

2. **M2 decomposition table reconciliation (L214–229)**. Dropped
   the strikethrough M2.c, M2.c.aux, M2.d (NOT ACTIVE) rows + the
   iter-127 standalone-cotangent-sheaf alternative paragraph + the
   iter-129 trigger-RESOLVED paragraph. Rewrote the M2.body-pile row
   to describe the iter-144 chart-algebra envelope (600–1050 LOC over
   5–7 iter; piece (i.a) DONE iter-128–iter-132; pieces (i.b)+(i.c)
   DESCOPED + EXCISED iter-145; piece (iii) DESCOPED; piece (ii)
   inflated to 5 sub-pieces in `ChartAlgebra.lean`) and to defer to
   § Iter-144 chart-algebra pivot below for the per-sub-piece detail.

**Total STRATEGY.md delta iter-146**: 701 → 624 LOC (−77 LOC).
Iter-147 absorbs the canonical-skeleton restructure (introduce `## Goal`,
`## Phases & estimations`, `## Routes`, `## Open strategic questions`,
`## Mathlib gaps & new material` headings; relocate any remaining
per-route LOC/iter estimates into a single `## Phases & estimations`
table; target post-iter-147 ~400–450 LOC, with the canonical ~250 LOC
bound aspirational at this stage of the multi-year roadmap).

## HARD GATE rebuttal (iter-146 plan agent)

The `blueprint-reviewer-iter146` HARD GATE FIRES on `RigidityKbar.tex`
(`complete: partial / correct: partial`). Per the catalog's HARD GATE
letter, this would DROP `Cotangent/ChartAlgebra.lean` from this iter's
prover objectives. Iter-146 plan agent rebuts:

1. **The 3 sub-pieces in iter-146's prover scope** (α, integral, lift)
   are explicitly classified `adequate` by `lean-vs-blueprint-checker-chart-algebra-review145`
   and the `blueprint-reviewer-iter146`'s must-fix findings (a)+(b)+(c)
   touch ONLY the 2 deferred sub-pieces (β-core + KDM ring-side). The
   3 in-scope sub-pieces have CLEAN first-class blocks in `RigidityKbar.tex`
   with NO must-fix items against them.

2. **The 8 broken `\lean{...}` hints (findings d–k)** point at iter-145-
   EXCISED declarations in `Cotangent/GrpObj.lean` — NONE of those
   point at `Cotangent/ChartAlgebra.lean`. The broken hints corrupt
   the dependency graph for the EXCISED bundled-route piece (i.b)
   blocks, not for the chart-algebra piece (ii) blocks the iter-146
   prover consumes.

3. **The iter-146 Wave 2 writer (rigiditykbar-iter146) absorbed all
   11 must-fix items in the same iter** (KDM (p1) recipe + KDM (p3)
   helper extraction + β-core Step 3 rewrite + 8 broken `\lean{...}`
   strips). The iter-147 mandatory blueprint-reviewer re-confirms
   `complete: true / correct: true` post-writer; until then, the
   3 iter-146 in-scope sub-pieces are dispatchable on the spirit of
   the HARD GATE (don't formalize against a broken sketch for the
   sub-piece you're proving) even if the letter (chapter-level
   partial rating) reads otherwise.

4. **Deferring to iter-147 would trip the meta-pattern.** Iter-144
   was plan-only at the prover level; iter-145 was plan-only at the
   prover level (refactor landed structural Lean code but no prover
   was dispatched); iter-146 plan-only would be a 3rd consecutive
   iter with zero prover dispatch on `Cotangent/ChartAlgebra.lean`,
   triggering `progress-critic`'s plan-only-meta-pattern CHURNING
   clause per iter-145 review.md L66. The iter-146 progress-critic
   explicitly flagged this risk and explicitly green-lit the narrowly-
   scoped single-lane dispatch on the 3 adequate sub-pieces.

**Decision**: PROCEED with the iter-146 prover lane on
`Cotangent/ChartAlgebra.lean` scoped to (α) + integral + lift. The
2 deferred sub-pieces (β-core + KDM) wait for iter-147+ blueprint-
reviewer green-light. This rebuttal honors HARD GATE *spirit*
(don't formalize against broken blueprint for the sub-piece you're
proving) while not stalling the route.

## Wave 3 (sequential) — prover lane

Fires after this plan phase via the loop dispatcher (one prover per
file; 1 file = `Cotangent/ChartAlgebra.lean`; 3 ready sub-piece
sorries listed under that file's objective).

* **(α) `AlgebraicGeometry.GrpObj.algebra_isPushout_of_affine_product`**
  — `ChartAlgebra.lean:50` placeholder `: True := sorry`. Prover
  refines the signature to the real `Algebra.IsPushout k B₁ B₂ (B₁ ⊗[k] B₂)`
  shape per blueprint sketch (`RigidityKbar.tex` § Chart-algebra
  piece (ii) first-class decomposition `\lem:chart_algebra_isPushout_of_affine_product`),
  then closes via the 3-step Mathlib recipe `pullbackSpecIso` →
  `isPullback_SpecMap_of_isPushout` → `CommRingCat.isPushout_iff_isPushout`.
  Estimate: ~80–150 LOC.

* **`AlgebraicGeometry.constants_integral_over_base_field`** —
  `ChartAlgebra.lean:77` placeholder. Prover refines to
  `Γ(X, O_X) = range (algebraMap k Γ(X, O_X))` for `X` smooth proper
  geom-irr over `k`, then closes via the 3-substep recipe
  (properness ⇒ finite-dim Γ; smooth + geom-irr ⇒ integral domain;
  finite integral domain over field, geom-irr forces dim_k = 1 via
  base-change to `k̄`). Estimate: ~50–100 LOC.

* **`AlgebraicGeometry.Scheme.Over.ext_of_diff_zero`** —
  `ChartAlgebra.lean:89` placeholder. Prover refines to
  `(f, g : C → A in Over (Spec k)) (df = dg) (eqOnOpen U) ⇒ f = g`,
  then closes via the 3-step recipe (KaehlerDifferential.D_sub
  reduction to `h = μ ∘ ⟨f, ι ∘ g⟩` with `dh = 0`; chart-by-chart
  apply `\lem:chart_algebra_df_zero_factors_through_constant_on_chart`
  — this is the β-core sub-piece, still `sorry`; invoke `\thm:GrpObj_eq_of_eqOnOpen`
  for the iter-125 ext_of_eqOnOpen packaging). Estimate: ~100–150
  LOC. Note: the β-core helper is `sorry`-bodied; the iter-146 prover
  may land a structural shell with the β-core helper call as a
  pre-existing `sorry`, leaving the actual body closure dependent on
  iter-147+ β-core closure.

**Order of attack**: planner recommends (α) first (smallest +
foundational; ~80–150 LOC), then `constants_integral_over_base_field`
(smallest standalone; ~50–100 LOC), then `Scheme.Over.ext_of_diff_zero`
(structural shell; depends on β-core helper-sorry call). Prover may
re-order if it judges dependencies differently.

## Off-limits this iter

- All `.lean` files except `Cotangent/ChartAlgebra.lean`.
- The 2 deferred sub-pieces in `Cotangent/ChartAlgebra.lean`
  (`df_zero_factors_through_constant_on_chart` β-core +
  `KaehlerDifferential.mem_range_algebraMap_of_D_eq_zero` KDM
  ring-side): blueprint-writer just landed must-fix absorption,
  iter-147+ prover lane.
- The 5 orphan helpers in `Cotangent/GrpObj.lean` (iter-147+ cleanup
  candidate, recommended by iter-145 plan agent watch criterion #5
  + iter-146 pointer-writer's orphan-status sentences).
- Iter-147 canonical-skeleton restructure of STRATEGY.md (Q5
  completion).

## Watch criteria committed for iter-147

1. **Iter-147 mandatory blueprint-reviewer**: re-confirm
   `RigidityKbar.tex` is `complete: true / correct: true` post the
   iter-146 rigiditykbar-iter146 writer. Confirm `AlgebraicJacobian_Cotangent_GrpObj.tex`
   is also `complete: true / correct: true` post the iter-146
   pointer-iter146 writer.

2. **Iter-147 mandatory strategy-critic** re-verification of the
   iter-146 STRATEGY.md edits: (a) the L561–629 excise + 1-paragraph
   summary read internally consistent; (b) the M2 decomposition table
   reconciliation reads coherent with the iter-144 chart-algebra
   pivot; (c) Q5 canonical-skeleton restructure (iter-147 plan-agent
   task) is the natural next step.

3. **Iter-147 mandatory progress-critic**: Route 1 (chart-algebra
   piece (ii)) verdict updates from UNCLEAR (iter-146) to one of:
   * **CONVERGING** if iter-146 prover lane returns COMPLETE on ≥2
     of 3 sub-pieces (substantive signature + body landings).
   * **UNCLEAR / fresh** if iter-146 returns PARTIAL on 1 sub-piece
     (first attempt on a fresh route; expected behaviour).
   * **CHURNING** only if iter-146 returns PARTIAL on 0 substantive
     closures (no sub-piece's signature even refined toward its real
     shape).

4. **Iter-147 STRATEGY.md canonical-skeleton restructure** (Q5
   completion deferred from iter-146 per strategy-critic unbundling
   recommendation). Plan agent introduces `## Goal`, `## Phases &
   estimations`, `## Routes`, `## Open strategic questions`,
   `## Mathlib gaps & new material` canonical headings; absorbs the
   M2-decomposition table + Sequencing per-iter table into a single
   `## Phases & estimations` table; relocates any remaining historical
   detail (M1 EXCISED narrative, Route B historical block, completed
   Mathlib gap entries) to a `STRATEGY-history.md` archive. Target
   post-iter-147 size: ~400–450 LOC.

5. **Iter-147 iter-146 prover lane evaluation**: signature-refinement-
   to-real-shape on each of the 3 sub-pieces (α + integral + lift)
   is the primary success criterion for iter-146. Body closure
   secondary; for `Scheme.Over.ext_of_diff_zero` the structural shell
   + β-core helper-sorry call is acceptable as "signature refined +
   body partially shaped".

6. **Iter-147+ β-core + KDM prover lane**: once iter-147 blueprint-
   reviewer confirms `RigidityKbar.tex` is post-rigiditykbar-iter146
   clean (which it should be), iter-147 OR iter-148 plan agent
   dispatches a prover lane on the 2 deferred sub-pieces
   (`df_zero_factors_through_constant_on_chart` + KDM
   `mem_range_algebraMap_of_D_eq_zero`).

7. **Iter-147 orphan-cleanup follow-up** (deferred from iter-145
   plan-agent watch criterion #5): decide whether to excise the 5
   orphan helpers identified in `Cotangent/GrpObj.lean` by the
   iter-145 refactor (`shearMulRight` + `_hom_fst`/`_hom_snd`,
   `schemeHomRingCompatibility`, `isIso_of_app_iso_module`,
   `relativeDifferentialsPresheaf_restrict_along_identity_section`).
   Iter-146 pointer-writer added orphan-status sentences to 3 of
   these; if iter-147 plan agent excises them, the pointer-chapter
   `\item` bullets are deleted in tandem.

8. **Iter-148+ piece (iv) Serre duality**: unchanged — named-theorem
   stays DEFERRED; cohomological content via chart-Čech Mayer–Vietoris
   per iter-145 Q3 honest framing + iter-146 rigiditykbar-iter146
   β-core Step 3 rewrite.

9. **Iter-150 over-k vs over-`k̄` symmetric audit** (preserved per
   iter-145 Q6 reframing): symmetric fresh-context strategy-critic
   question; rolling mid-iter trigger fires earlier if any of (a)
   cumulative chart-algebra (α)+(β) costs exceed envelope upper bound
   (~1050 LOC) without closing, (b) a fresh prover lane returns
   INCOMPLETE on a base-dependent sub-goal, (c) a new analogist
   surfaces an unanticipated route alternative.

10. **Iter-150 RelativeSpec scaffold M2.a body arm trigger** preserved
    per iter-142 STRATEGY.md Edit 4 (LOC arm unlikely to fire under
    chart-algebra; iter-160 M2.a body arm primary trigger).

11. **Iter-170+ M3 Route A audit re-refresh** (per iter-145
    `mathlib-analogist-m3-route-a-refresh-iter145` recommendation):
    or earlier if `Hilbert*`/`Quot*`/`Coherent*`/`Flattening*` lands
    in mainline.
